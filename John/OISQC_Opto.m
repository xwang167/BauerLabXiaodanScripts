function OISQC_Opto(Date, Mouse, suffix, directory, rawdataloc, info, system, gsrornot)
filename = [Date,'-',Mouse,'-',suffix];

run=1;
while 1
    
    loopfile=[rawdataloc, filename,num2str(run),'.tif'];
    
    if ~exist(loopfile,'file');
        disp(['The file: ', loopfile, ', does not exist'])
        
        run=run+1;
        loopfile=[rawdataloc, filename,num2str(run),'.tif'];
        
        if ~exist(loopfile,'file');
            disp(['The file: ', loopfile, ', does not exist. Moving on.'])
            break
        end
    end
    
    if exist([directory, filename,num2str(run),'_DataVis.jpg'],'file')
        
        disp([filename,num2str(run),' OISQC Already Ran'])
        run=run+1;
    else
        disp(['OISQC on ', filename, num2str(run)])
        load([directory, Date,'-', Mouse,'-LandmarksandMask.mat']);
        ibi=find(isbrain==1);
        load([directory, filename, num2str(run),'-datahb'], 'info');
        [rawdata]=readtiff(loopfile);
        
        if exist([loopfile(1:(end-4)),'_X2',loopfile((end-3):end)],'file')
            [rawdata2]=readtiff([loopfile(1:(end-4)),'_X2',loopfile((end-3):end)]);
            rawdata=cat(3,rawdata,rawdata2); clear rawdata2
        end
        
        [~, ~, L]=size(rawdata);
        
        R=mod(L,info.numled+info.numlaser);
        if R~=0
            rawdata=rawdata(:,:,1:(L-R));
            disp(['** ',num2str(info.numled+info.numlaser-R),' frames were dropped **'])
            info.framesdropped=info.numled+info.numlaser-R;
        end
        
        R=mod(L,info.stimblocksize*info.framerate*(info.numled+info.numlaser));  %%% ADDED on 8/24/2018 by John Lee 
if R~=0
    rawdata=rawdata(:,:,1:(L-R));
    disp(['** ',num2str(R),' frames were intentionally cropped to facilitate block averaging**'])
end
%%%
        
        rawdata=reshape(rawdata,info.nVx,info.nVy,info.numled+info.numlaser,[],6); % hard coded, need to fix;
        LaserFrames=squeeze(rawdata(:,:,info.numled+info.numlaser,(info.stimbaseline+1)*info.framerate,:));
        save([directory, filename,num2str(run),'-datahb'], 'LaserFrames', '-append');
        
        rawdata=reshape(rawdata,info.nVy,info.nVx,info.numled+info.numlaser,[]); %reshape to be pixels by color by time for spectroscopy
        rawdata=rawdata(:,:,1:info.numled,2:end); % cut off first frame (our Andor does not collect first red image, so we drop first frame)
        rawdata=single(reshape(rawdata,info.nVy,info.nVx,info.numled,[]));
        
        testpixel=squeeze(rawdata(31,82,:,:));
        
        if any(any(testpixel==0))
            emptyframes=zeros(size(testpixel));
            for c=1:info.numled;
                emptyframes(c,:)=any(testpixel(c,:)==0,1);
            end
            disp([filename,num2str(run),' had empty frames, no QC performed, moving on...'])
            info.emptyframes=emptyframes;
            save([directory, filename,num2str(run),'-datahb'],'info', '-append');
            break
        end
        
        rawdata=single(reshape(rawdata,info.nVy*info.nVx,info.numled,[]));
        
        clear mdatanorm stddatanorm
        mdata=squeeze(mean(rawdata(ibi,:,:),1));
        
        for c=1:info.numled;
            mdatanorm(c,:)=mdata(c,:)./(squeeze(mean(mdata(c,:),2)));
        end
        
        for c=1:info.numled;
            stddatanorm(c,:)=std(mdatanorm(c,:),0,2);
        end
        
        time=linspace(1,info.T1,info.T1)/info.framerate;
        
        fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        
        %% Plot Raw Data
        if strcmp(system, 'fcOIS1')
            Colors=[1 0 0; 1 0.5 0; 1 1 0; 0 0 1];
            TickLabels={'R', 'O', 'Y', 'B'};
        elseif strcmp(system, 'fcOIS2')
            Colors=[0 0 1; 0 1 0; 1 1 0; 1 0 0];
            TickLabels={'B', 'G', 'Y', 'R'};
        elseif strcmp(system, 'EastOIS1')
            Colors=[0 0 1; 1 1 0; 1 0.5 0; 1 0 0];
            TickLabels={'B', 'Y', 'O', 'R'};
        end
        
        subplot('position', [0.12 0.71 0.17 0.2])
        p=plot(time,mdata'); title('Raw Data');
        for c=1:info.numled;
            set(p(c),'Color',Colors(c,:));
        end
        title('Raw Data');
        xlabel('Time (sec)')
        ylabel('Counts');
        ylim([500 14000])
        
        subplot('position', [0.35 0.71 0.17 0.2])
        p=plot(time,mdatanorm'); title('Normalized Raw Data');
        for c=1:info.numled;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Time (sec)')
        ylabel('Mean Counts')
        ylim([0.95 1.05])
        
        subplot('position', [0.6 0.71 0.1 0.2])
        plot(stddatanorm*100');
        set(gca,'XTick',(1:info.numled));
        set(gca,'XTickLabel',TickLabels)
        title('Std Deviation');
        ylabel('% Deviation')
        
        %% FFT Check
        fdata=abs(fft(logmean(mdata),[],2));
        hz=linspace(0,info.framerate,info.T1);
        subplot('position', [0.77 0.71 0.2 0.2])
        p=loglog(hz(1:ceil(info.T1/2)),fdata(:,1:ceil(info.T1/2))'); title('FFT Raw Data');
        for c=1:info.numled;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        xlim([0.01 15]);
        
        %% Movement Check
        rawdata=reshape(rawdata, info.nVy, info.nVx,info.numled, []);
        
        if strcmp(system, 'fcOIS1')
            BlueChan=4;
        elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')
            BlueChan=1;
        end
        
        Im1=single(squeeze(rawdata(:,:,BlueChan,1)));
        F1 = fft2(Im1); % reference image
        
        InstMvMt=zeros(size(rawdata,4),1);
        LTMvMt=zeros(size(rawdata,4),1);
        Shift=zeros(2,size(rawdata,4),1);
        
        for t=1:size(rawdata,4)-1;
            LTMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,BlueChan,t+1))-Im1)));
            InstMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,BlueChan,t+1))-squeeze(rawdata(:,:,BlueChan,t)))));
        end
        
        for t=1:size(rawdata,4);
            Im2=single(squeeze(rawdata(:,:,BlueChan,t)));
            F2 = fft2(Im2); % subsequent image to translate
            
            pdm = exp(1i.*(angle(F1)-angle(F2))); % Create phase difference matrix
            pcf = real(ifft2(pdm)); % Solve for phase correlation function
            pcf2(1:size(Im1,1)/2,1:size(Im1,1)/2)=pcf(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1)); % 4
            pcf2(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1))=pcf(1:size(Im1,1)/2,1:size(Im1,1)/2); % 1
            pcf2(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1))=pcf(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2); % 3
            pcf2(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2)=pcf(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1)); % 2
            
            [~, imax] = max(pcf2(:));
            [ypeak, xpeak] = ind2sub(size(Im1,1),imax(1));
            offset = [ypeak-(size(Im1,1)/2+1) xpeak-(size(Im1,2)/2+1)];
            
            Shift(1,t)=offset(1);
            Shift(2,t)=offset(2);
            
        end
        
        clear rawdata
        load([directory, filename,num2str(run),'-datahb'], 'datahb');
        datahb=real(datahb);
        
        if gsrornot == 1
            disp('Performing gsr')
            [Oxy, DeOxy]=gsr(datahb,isbrain);
            %             Oxy = squeeze(Oxy(:,:,info.stimblocksize+1:end));
            %             DeOxy = squeeze(DeOxy(:,:,info.stimblocksize+1:end));
        elseif gsrornot == 0
            disp('gsr not performed')
            Oxy = squeeze(datahb(:,:,1,:)); % remove first block
            DeOxy = squeeze(datahb(:,:,2,:)); % remove first block
        else
            disp('Invalid gsr input')
        end
       
        Total = Oxy + DeOxy; % Added by John on 1/30/19
        
        %% Check Evoked Responses
        
        if strcmp(suffix, 'stim')
            
            R=mod(size(Oxy,3),info.stimblocksize);
            if R~=0
                pad=info.stimblocksize-R;
                disp(['** Non integer number of blocks presented. Padded ' filename, num2str(run), ' with ', num2str(pad), ' zeros **'])
                Oxy(:,:,end:end+pad)=0;
                DeOxy(:,:,end:end+pad)=0;
                Total(:,:,end:end+pad)=0; % Added by John on 1/30/19
                info.appendedzeros=pad;
            end
            
            Oxy=reshape(Oxy,info.nVy,info.nVx,info.stimblocksize,[]);
            for b=1:size(Oxy,4)
                MeanFrame=squeeze(mean(Oxy(:,:,1:info.stimbaseline,b),3));
                for t=1:size(Oxy, 3);
                    Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
                end
            end
            
            DeOxy=reshape(DeOxy,info.nVy,info.nVx,info.stimblocksize,[]);
            for b=1:size(DeOxy,4)
                MeanFrame=squeeze(mean(DeOxy(:,:,1:info.stimbaseline,b),3));
                for t=1:size(DeOxy, 3);
                    DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
                end
            end
            
            Total=reshape(Total,info.nVy,info.nVx,info.stimblocksize,[]);
            for b=1:size(Total,4)
                MeanFrame=squeeze(mean(Total(:,:,1:info.stimbaseline,b),3));
                for t=1:size(Total, 3);
                    Total(:,:,t,b)=squeeze(Total(:,:,t,b))-MeanFrame;
                end
            end
            
            AvgOxy=mean(Oxy,4);
            AvgDeOxy=mean(DeOxy,4);
            AvgTotal=mean(Total,4);
            
            MeanFrame=squeeze(mean(AvgOxy(:,:,1:info.stimbaseline),3));
            for t=1:size(AvgOxy, 3);
                AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:info.stimbaseline),3));
            for t=1:size(AvgDeOxy, 3);
                AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvgTotal(:,:,1:info.stimbaseline),3));
            for t=1:size(AvgTotal, 3);
                AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
            end
            
            %% Make Plots
            thresh = [-1e-3,1e-3];
            for b=1:size(Oxy,4);
                subplot('position', [0.03+(b-1)*0.095 0.5 0.095 0.095]);
                temp=Oxy(:,:,info.stimbaseline+info.stimduration,b);
                %                 imagesc(temp, [-max(max(temp)) max(max(temp))]);
                imagesc(temp, thresh);
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('Oxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            for b=1:size(DeOxy,4);
                subplot('position', [0.03+(b-1)*0.095 0.35 0.095 0.095]);
                temp=DeOxy(:,:,info.stimbaseline+info.stimduration,b);
                %                 imagesc(temp, [min(min(temp)) -1*min(min(temp))]);
                imagesc(temp, thresh);
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('DeOxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            for b=1:size(Oxy,4);
                subplot('position', [0.03+(b-1)*0.095 0.2 0.095 0.095]);
                temp=Oxy(:,:,info.stimbaseline+info.stimduration,b)+DeOxy(:,:,info.stimbaseline+info.stimduration,b);
                %                 imagesc(temp, [-max(max(temp)) max(max(temp))]);
                imagesc(temp, thresh);
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('Total')
                end
                title(['Pres ', num2str(b)]);
            end
            
            subplot('position', [0.05 0.05 0.095 0.095]);
            temp=mean(AvgOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
            %             imagesc(temp, [-max(max(temp)) max(max(temp))]);
            imagesc(temp, thresh);
            axis image off
            title('Avg Oxy')
            
            subplot('position', [0.20 0.05 0.095 0.095]);
            temp=mean(AvgDeOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
            %             imagesc(temp, [min(min(temp)) -1*min(min(temp))]);
            imagesc(temp, thresh);
            axis image off
            title('Avg DeOxy')
            
            subplot('position', [0.35 0.05 0.095 0.095]);
            temp=mean(AvgTotal(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
            %             imagesc(temp, [-max(max(temp)) max(max(temp))]);
            imagesc(temp, thresh);
            axis image off
            title('Avg Total')
            
            % save([directory, filename,num2str(run),'-datahb'], 'AvgOxy',
            % 'AvgDeOxy', 'AvgTotal', 'Oxy', 'DeOxy', '-append'); Removed
            % by John on 1/30/19 b/c it was not affine transformed
            
            %% Check functional connectivity
            
        elseif strcmp(suffix, 'fc')
            
            Oxy=reshape(Oxy,info.nVy*info.nVx,[]);
            seednames={'Olf','Fr','Cg','M','SS','RS','V'};
            seedcenter=seedcenter(1:14,:);
            sides={'L','R'};
            
            mm=10;
            mpp=mm/info.nVx;
            seedradmm=0.25;
            seedradpix=seedradmm/mpp;
            
            numseeds=numel(seednames);
            numsides=numel(sides);
            
            P=burnseeds(seedcenter,seedradpix,isbrain);
            strace=P2strace(P,Oxy, seedcenter); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
            R=strace2R(strace,Oxy, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
            Rs=normRow(strace)*normRow(strace)';
            
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.25;
                else
                    OE=0.05;
                end
                
                subplot('position', [OE (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
                Im2=overlaymouse(R(:,:,(2*(s-1)+1)),WL, isbrain,'jet',-1,1);
                image(Im2); %changed 3/1/11
                hold on;
                plot(seedcenter(2*(s-1)+1,1),seedcenter(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'L'])
                
                subplot('position', [OE+0.10 (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
                Im2=overlaymouse(R(:,:,(2*(s-1)+2)),WL, isbrain,'jet',-1,1);
                image(Im2); %changed 3/1/11
                hold on;
                plot(seedcenter(2*(s-1)+2,1),seedcenter(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'R'])
                hold off;
            end
            save([directory, filename,num2str(run),'-datahb'],'R', 'Rs', '-append');
        end
        
        subplot('position', [0.55 0.4 0.35 0.2]);
        [AX, H1, H2]=plotyy(time, InstMvMt/1e6,time, LTMvMt/1e6);
        set(AX(1),'ylim',[0 5]);
        set(AX(1), 'ytick',[0,1,2,3,4,5])
        set(AX(2),'ylim',[0 5]);
        set(AX(2), 'ytick',[0,1,2,3,4,5])
        set(get(AX(1), 'YLabel'), 'String', {'Sum Abs Diff Frame to Frame,'; '(Counts x 10^6)'});
        set(get(AX(2),'YLabel'), 'String', {'Sum Abs Diff WRT First Frame,'; '(Counts x 10^6)'});
        xlabel('Time  (sec)');
        legend('Instantaneous Change','Change over Run');
        
        subplot('position', [0.55 0.08 0.35 0.2]);
        plot(time, Shift(1,:),'k');
        hold on;
        plot(time, Shift(2,:),'b');
        ylim([-1*(max(Shift(:))+1) max(Shift(:)+1)]);
        xlabel('Time  (sec)');
        ylabel('Offset (pixels)');
        legend('Vertical','Horizontal');
        
        colormap('jet'); % added 8/29/2018 for visualization purposes
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',[filename,num2str(run),' Data Visualization'],'FontWeight','bold','Color',[1 0 0]);
        
        output=[directory, filename,num2str(run),'_DataVis.jpg'];
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
        save([directory, filename,num2str(run),'-datahb'], 'mdatanorm', 'mdata', 'stddatanorm', 'LTMvMt', 'InstMvMt', 'Shift', 'time', 'fdata', 'hz','info', '-append');
        run=run+1;
    end
end

end


