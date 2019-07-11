function OISGCaMPQC_run(recDate, mouseName, sessionType, saveDir, tiffFileDir, isGsrname,systemInfo,sessionInfo)

filename = strcat(recDate,"-",mouseName,"-",sessionType);

run=1;
while 1
    
    loopfile=fullfile(tiffFileDir, strcat(filename ,num2str(run),'.tif'));
    
    if ~exist(loopfile,'file');
        disp(['The file: ', loopfile, ', does not exist'])
        
        run=run+1;
        loopfile=fullfile(tiffFileDir, strcat(filename ,num2str(run),'.tif'));
        
        if ~exist(loopfile,'file');
            disp(['The file: ', loopfile, ', does not exist. Moving on.'])
            break
        end
    end
    
    if exist(fullfile(tiffFileDir, strcat(filename ,num2str(run),'_rawVis.jpg')),'file')
        
        disp(strcat(filename,num2str(run),' OISFluorQC Already Ran'))
        run=run+1;
    else
        disp(strcat('OISFluorQC on ', filename, num2str(run)))
        
        processedDataName= strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname ,"-Detrend");
        load(fullfile(saveDir,strcat(processedDataName,'.mat')),'raw','xform_isbrain')
        [info.nVy, info.nVx, L]=size(raw);
        systemInfo.LEDFiles = 4;
        R=mod(L,systemInfo.LEDFiles);
        if R~=0
            raw=raw(:,:,1:(L-R));
            disp(['** ',num2str(systemInfo.LEDFiles-R),' frames were dropped **'])
            info.framesdropped=systemInfo.LEDFiles-R;
        end
        
        raw=reshape(raw,info.nVy,info.nVx,systemInfo.LEDFiles,[]);
        info.T1=size(raw,4);
        
        testpixel=squeeze(raw(31,82,:,:));
        if any(any(testpixel==0))
            emptyframes=zeros(size(testpixel));
            for c=1:systemInfo.LEDFiles;
                emptyframes(c,:)=any(testpixel(c,:)==0,1);
            end
            disp([filename,num2str(run),' had empty frames, no QC performed, moving on...'])
            info.emptyframes=emptyframes;
            save(fullfile(saveDir,strcat(processedDataName,'.mat')),'info', '-v7.3','-append');
            break
        end
        
        ibi=find(xform_isbrain==1);
        raw=single(reshape(raw,info.nVy*info.nVx,systemInfo.LEDFiles,[]));
        
        clear mdatanorm stddatanorm
        mdata=squeeze(mean(raw(ibi,:,:),1));
        
        for c=1:systemInfo.LEDFiles;
            mdatanorm(c,:)=mdata(c,:)./(squeeze(mean(mdata(c,:),2)));
        end
        
        for c=1:systemInfo.LEDFiles;
            stddatanorm(c,:)=std(mdatanorm(c,:),0,2);
        end
        
        time=linspace(1,info.T1,info.T1)/sessionInfo.framerate;
        
        fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        system = 'EastOIS1_Fluor';
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
        elseif strcmp(system, 'EastOIS1_Fluor')
            Colors = [0 0 1; 0 1 0; 1 0.5 0; 1 0 0];
            TickLabels = {'B','G','O', 'R' };
            
        end
        
        
        
        subplot('position', [0.12 0.71 0.25 0.2])
        p=plot(time,mdata'); title('Raw Data');
        for c=1:systemInfo.LEDFiles;
            set(p(c),'Color',Colors(c,:));
        end
        title('Raw Data');
        xlabel('Time (sec)')
        ylabel('Counts');
        ylim([500 14000])
        xlim([time(1) time(end)])
        
        subplot('position', [0.45 0.71 0.35 0.2])
        p=plot(time,mdatanorm'); title('Normalized Raw Data');
        for c=1:systemInfo.LEDFiles;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Time (sec)')
        ylabel('Mean Counts')
        ylim([0.95 1.05])
        xlim([time(1) time(end)])
        
        subplot('position', [0.12 0.4 0.1 0.2])
        plot(stddatanorm*100');
        set(gca,'XTick',(1:systemInfo.LEDFiles));
        set(gca,'XTickLabel',TickLabels)
        title('Std Deviation');
        ylabel('% Deviation')
        
        %% FFT Check
        fdata=abs(fft(logmean(mdata),[],2));
        hz=linspace(0,sessionInfo.framerate,info.T1);
        subplot('position', [0.35 0.4 0.35 0.2])
        p=loglog(hz(1:ceil(info.T1/2)),fdata(:,1:ceil(info.T1/2))'); title('FFT Raw Data');
        for c=1:systemInfo.LEDFiles;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        xlim([0.01 25]);
        
        
        fdata=abs(fft(logmean(mdata),[],2));
        hz=linspace(0,sessionInfo.framerate,info.T1);
        subplot('position', [0.75 0.4 0.2 0.2])
        p=semilogy(hz(1:ceil(info.T1/2)),fdata(:,1:ceil(info.T1/2))'); title('FFT Raw Data');
        for c=1:systemInfo.LEDFiles;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        xlim([0.5 5]);
        
        
        %% Movement Check
        raw=reshape(raw, info.nVy, info.nVx,systemInfo.LEDFiles, []);
        
        if strcmp(system, 'fcOIS1')
            BlueChan=4;
        elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')||strcmp(system, 'EastOIS1_Fluor')
            BlueChan=1;
        end
        
        Im1=single(squeeze(raw(:,:,BlueChan,1)));
        F1 = fft2(Im1); % reference image
        
        InstMvMt=zeros(size(raw,4),1);
        LTMvMt=zeros(size(raw,4),1);
        Shift=zeros(2,size(raw,4),1);
        
        for t=1:size(raw,4)-1;
            LTMvMt(t)=sum(sum(abs(squeeze(raw(:,:,BlueChan,t+1))-Im1)));
            InstMvMt(t)=sum(sum(abs(squeeze(raw(:,:,BlueChan,t+1))-squeeze(raw(:,:,BlueChan,t)))));
        end
        
        for t=1:size(raw,4);
            Im2=single(squeeze(raw(:,:,BlueChan,t)));
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
        
        clear raw
        
        subplot('position', [0.1 0.08 0.35 0.2]);
        [AX, H1, H2]=plotyy(time, InstMvMt/1e6,time, LTMvMt/1e6);
        maxval=3;
        set(AX(1),'ylim',[0 maxval]);
        set(AX(1),'ytick',[0,0.2,0.4,0.6,0.8,1]*maxval)
        set(AX(2),'ylim',[0 maxval]);
        set(AX(2), 'ytick',[0,0.2,0.4,0.6,0.8,1]*maxval)
        set(get(AX(1), 'YLabel'), 'String', {'Sum Abs Diff Frame to Frame,'; '(Counts x 10^6)'});
        set(get(AX(2),'YLabel'), 'String', {'Sum Abs Diff WRT First Frame,'; '(Counts x 10^6)'});
        xlabel('Time  (sec)');
        xlim(AX(1), [time(1) time(end)])
        xlim(AX(2), [time(1) time(end)])
        legend('Instantaneous Change','Change over Run');
        
        subplot('position', [0.55 0.08 0.35 0.2]);
        plot(time, Shift(1,:),'k');
        hold on;
        plot(time, Shift(2,:),'b');
        ylim([-1*(max(Shift(:))+1) max(Shift(:)+1)]);
        xlabel('Time  (sec)');
        xlim([time(1) time(end)])
        ylabel('Offset (pixels)');
        legend('Vertical','Horizontal');
        
        
        
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,' Raw Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
       
        output=strcat(fullfile(saveDir,processedDataName),'_rawVis.jpg');
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
        
        save(fullfile(saveDir,strcat(processedDataName,'.mat')), 'mdatanorm', 'mdata', 'stddatanorm', 'LTMvMt', 'InstMvMt', 'Shift', 'time', 'fdata', 'hz','info', '-append');
        
        load(fullfile(saveDir,strcat(processedDataName,"-","0.01Hz-8Hz",".mat")), 'xform_datahb_bandpass','xform_total_bandpass','xform_gcamp_bandpass','xform_gcampCorr_bandpass','xform_green_bandpass',...
            'xform_isbrain','sessionInfo')
        %         datahb=real(datahb);
        %         [Oxy, DeOxy]=gsr(datahb,isbrain);
        
        %% Check Evoked Responses
        
        if strcmp(sessionType, 'stim')
            
            oxy = squeeze(xform_datahb_bandpass(:,:,1,:));
            deoxy = squeeze(xform_datahb_bandpass(:,:,2,:));
            total = squeeze(xform_total_bandpass(:,:,1,:));
            gcamp = squeeze(xform_gcamp_bandpass(:,:,1,:));
            gcampCorr = squeeze(xform_gcampCorr_bandpass(:,:,1,:));
            green = squeeze(xform_green_bandpass);
            
            clear xform_datahb xform_total xform_gcamp xform_gcampCorr
            
            oxy = oxy.*xform_isbrain;
            deoxy = deoxy.*xform_isbrain;
            total = total .*xform_isbrain;
            gcamp = gcamp.*xform_isbrain;
            gcampCorr = gcampCorr.*xform_isbrain;
            green = green.*xform_isbrain;
            
            oxy(isnan(oxy)) = 0;
            deoxy(isnan(deoxy)) = 0;
            total(isnan(total)) = 0;
            gcamp(isnan(gcamp)) = 0;
            gcampCorr(isnan(gcampCorr)) = 0;
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            R=mod(size(oxy,3),sessionInfo.stimblocksize);
            if R~=0
                pad=sessionInfo.stimblocksize-R;
                disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ',' ', num2str(pad), ' zeros **'))
                oxy(:,:,end:end+pad)=0;
                deoxy(:,:,end:end+pad)=0;
                total(:,:,end:end+pad)=0;
                gcamp(:,:,end:end+pad)=0;
                gcampCorr(:,:,end:end+pad)=0;
            end
            
            oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(oxy,4)
                MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(oxy, 3);
                    oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
                end
            end
            
            deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(deoxy,4)
                MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(deoxy, 3);
                    deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
                end
            end
            
            total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(total,4)
                MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(total, 3);
                    deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
                end
            end
            
            
            gcamp =reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(gcamp,4)
                MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcamp, 3);
                    gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                end
            end
            
            gcampCorr =reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(gcampCorr,4)
                MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcampCorr, 3);
                    gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
                end
            end
            
            %% Block Average
            
            mask_oxy_name = strcat(fullfile(saveDir,processedDataName),'_OxyActiveMask');
            if exist(strcat(mask_oxy_name,'.mat'),'file')
                load(strcat(mask_oxy_name,'.mat'),'mask_oxy');
            else
                AvgOxy= mean(oxy,4);
                MeanFrame_oxy=mean(AvgOxy(:,:,1:sessionInfo.stimbaseline),3);
                AvgOxy_stim = mean(AvgOxy(:,:,(sessionInfo.stimbaseline+1):(sessionInfo.stimbaseline+round((sessionInfo.stimduration+1)*sessionInfo.framerate)))-MeanFrame_oxy,3);
                
                imagesc(AvgOxy_stim, [-0.95*max(max(AvgOxy_stim)) 0.95*max(max(AvgOxy_stim))]);
                axis image off
                title('Avg Oxy')
                disp('Create mask')
                p = drawpolygon('LineWidth',7,'Color','cyan');
                bw = poly2mask(p.Position(:,1),p.Position(:,2),128,128);
                isActivate=double(bw);
                temp_oxy_area = AvgOxy_stim.*isActivate;
                temp_oxy_max = max(temp_oxy_area,[],'all');
                
                mask_oxy = zeros(128,128);
                mask_oxy(temp_oxy_area>= 0.75*temp_oxy_max) = 1;
                mask_oxy = logical(mask_oxy);
                imshow(mask_oxy);
                saveas(gcf,strcat(mask_oxy_name,'jpg'));
                save(strcat(mask_oxy_name,'.mat'),'mask_oxy');
            end
            
            mask_gcampCorr_name = strcat(fullfile(saveDir,processedDataName),'_GcampCorrActiveMask');
            if exist(strcat(mask_gcampCorr_name,'.mat'),'file')
                load(strcat(mask_gcampCorr_name,'.mat'),'mask_gcampCorr');
            else
                AvggcampCorr = mean(gcampCorr,4);
                MeanFrame_gcampCorr=mean(AvggcampCorr(:,:,1:sessionInfo.stimbaseline),3);
                AvggcampCorr_stim=mean(AvggcampCorr(:,:,(sessionInfo.stimbaseline+1):(sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)))-MeanFrame_gcampCorr,3);
                imagesc(AvggcampCorr_stim, [-0.9*max(max(AvggcampCorr_stim)) 0.9*max(max(AvggcampCorr_stim))]);
                axis image off
                title('Avg GcampCorr')
                disp('Create mask')
                p_gcampCorr = drawpolygon('LineWidth',7,'Color','cyan');
                bw_gcampCorr = poly2mask(p_gcampCorr.Position(:,1),p_gcampCorr.Position(:,2),128,128);
                isActivate_gcampCorr=double(bw_gcampCorr);
                temp_gcampCorr_area = AvggcampCorr_stim.*isActivate_gcampCorr;
                temp_gcampCorr_max = max(temp_gcampCorr_area,[],'all');
                
                mask_gcampCorr = zeros(128,128);
                mask_gcampCorr(temp_gcampCorr_area>=0.75*temp_gcampCorr_max) = 1;
                mask_gcampCorr = logical(mask_gcampCorr);
                imshow(mask_gcampCorr)
                saveas(gcf,strcat(mask_gcampCorr_name,'jpg'));
                save(strcat(mask_gcampCorr_name,'.mat'),'mask_gcampCorr');
            end
            
            clear AvgOxy_stim AvggcampCorr_stim
            
            stimName = strcat(processedDataName,"-",sessionInfo.bandtype{1});
                     R=mod(size(oxy,3),sessionInfo.stimblocksize);
            
            if R~=0
                pad=sessionInfo.stimblocksize-R;
                disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ', num2str(pad), ' zeros **'))
                oxy(:,:,end:end+pad)=0;
                deoxy(:,:,end:end+pad)=0;
                total(:,:,end:end+pad)=0;
                gcamp(:,:,end:end+pad)=0;
                gcampCorr(:,:,end:end+pad)=0;
                green(:,:,end:end+pad)=0;
                info.appendedzeros=pad;
            end
            
            
     
            
            
            oxy_blocks = mean(oxy,4);
            deoxy_blocks = mean(deoxy,4);
            total_blocks = mean(total,4);
            gcamp_blocks = mean(gcamp,4);
            gcampCorr_blocks = mean(gcampCorr,4);
            green_blocks = mean(green,4);

            
            
            oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
            deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
            total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);
            gcamp_blocks_baseline = gcamp_blocks-mean(gcamp_blocks(:,:,1:sessionInfo.stimbaseline),3);
            gcampCorr_blocks_baseline = gcampCorr_blocks-mean(gcampCorr_blocks(:,:,1:sessionInfo.stimbaseline),3);
            green_blocks_baseline = green_blocks-mean(green_blocks(:,:,1:sessionInfo.stimbaseline),3);
            
            
            
            clear oxy_blocks deoxy_blocks  total_blocks  gcamp_blocks gcampCorr_blocks green_blocks
            
            oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
            deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
            total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
            gcamp_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
            gcampCorr_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
            green_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
            for i = 1:sessionInfo.stimblocksize
                
                oxy_temp = oxy_blocks_baseline(:,:,i);
                oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_oxy));
                
                deoxy_temp = deoxy_blocks_baseline(:,:,i);
                deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_oxy));
                
                total_temp = total_blocks_baseline(:,:,i);
                total_blocks_baseline_active(i) = mean(total_temp(mask_oxy));
                
                gcamp_temp = gcamp_blocks_baseline(:,:,i);
                gcamp_blocks_baseline_active(i) = mean(gcamp_temp(mask_gcampCorr));
                
                gcampCorr_temp = gcampCorr_blocks_baseline(:,:,i);
                gcampCorr_blocks_baseline_active(i) = mean(gcampCorr_temp(mask_gcampCorr));
                
                green_temp = green_blocks_baseline(:,:,i);
                green_blocks_baseline_active(i) = mean(green_temp(mask_gcampCorr));
            end
            
            visName = strcat(stimName,'-BlockAvg');
            
            [max_oxy,locs_oxy] = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
            [peakValue_gcampCorr,locs_gcamp] = findpeaks(gcampCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))),'MinPeakHeight',0.01);
            max_gcampCorr = mean(peakValue_gcampCorr);
            
            plotBlockAvg(gcampCorr_blocks_baseline_active,gcamp_blocks_baseline_active,green_blocks_baseline_active,oxy_blocks_baseline_active,deoxy_blocks_baseline_active,total_blocks_baseline_active,visName,saveDir,sessionInfo,xform_isbrain,mask_oxy,mask_gcampCorr,max_oxy,max_gcampCorr)
            save(fullfile(saveDir,strcat(stimName,'.mat')),'gcampCorr_blocks_baseline_active','oxy_blocks_baseline_active','deoxy_blocks_baseline_active','total_blocks_baseline_active','gcamp_blocks_baseline_active','green_blocks_baseline_active','-append')
            
            close all
            
            %% StimMap
            
            stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);

            numBlocks = size(gcamp,4);
            
            oxy_peakAvg = squeeze(mean(oxy(:,:,locs_oxy+sessionInfo.stimbaseline-1,:),3));
            deoxy_peakAvg = squeeze(mean(deoxy(:,:,locs_oxy+sessionInfo.stimbaseline-1,:),3));
            total_peakAvg = squeeze(mean(total(:,:,locs_oxy+sessionInfo.stimbaseline-1,:),3));
            gcamp_peakAvg = squeeze(mean(gcamp(:,:,locs_gcamp+sessionInfo.stimbaseline-1,:),3));
            gcampCorr_peakAvg = squeeze(mean(gcampCorr(:,:,locs_gcamp+sessionInfo.stimbaseline-1,:),3));
            
            Avggcamp_peakAvg=mean(oxy_peakAvg,3);
            AvggcampCorr_peakAvg=mean(deoxy_peakAvg,3);
            AvgOxy_peakAvg=mean(total_peakAvg,3);
            AvgDeOxy_peakAvg=mean(gcamp_peakAvg,3);
            AvgTotal_peakAvg=mean(gcampCorr_peakAvg,3);
            
            save(fullfile(saveDir,strcat(stimName,'.mat')) , 'info','AvgOxy_peakAvg', 'AvgDeOxy_peakAvg', 'AvgTotal_peakAvg','Avggcamp_peakAvg','AvggcampCorr_peakAvg','gcamp_peakAvg','gcampCorr_peakAvg','oxy_peakAvg','deoxy_peakAvg','total_peakAvg', '-append');
           getStimMap(numBlocks,gcamp_peakAvg,gcampCorr_peakAvg,oxy_peakAvg,deoxy_peakAvg,total_peakAvg,AvgOxy_peakAvg,Avggcamp_peakAvg,AvgDeOxy_peakAvg,AvgTotal_peakAvg,AvggcampCorr_peakAvg,visName,saveDir,max_oxy,max_gcampCorr)

        elseif strcmp(sessionType,'fc')
            %% Check functional connectivty
            saveDataFileName_ISA = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),isGsrname ,"-Detrend-ISA.mat");
            saveDataFileName_Delta = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),isGsrname ,"-Detrend-Delta.mat");
    
           load(fullfile(saveDir,strcat(saveDataFileName_ISA,".mat")),'xform_datahb_ISA','xform_gcampCorr_ISA')
           load(fullfile(saveDir,strcat(saveDataFileName_Delta,".mat")),'xform_datahb_Delta','xform_gcampCorr_Delta')
           saveDataFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),isGsrname ,"-Detrend");
           load(fullfile(saveDir,strcat(saveDataFileName,".mat")),'xform_isbrain','sessionInfo')
            [info.nVy,info.nVx,~,~] = size(xform_datahb_ISA);
            oxy_ISA = squeeze(xform_datahb_ISA (:,:,1,:));
            gcampCorr_ISA  = squeeze(xform_gcampCorr_ISA (:,:,1,:));
            oxy_Delta = squeeze(xform_datahb_Delta(:,:,1,:));
            gcampCorr_Delta = squeeze(xform_gcampCorr_Delta(:,:,1,:));
            clear xform_datahb_ISA   xform_gcampCorr_ISA   xform_datahb_Delta   xform_gcampCorr_Delta  
            
            oxy_ISA = oxy_ISA.*xform_isbrain;
            gcampCorr_ISA = gcampCorr_ISA.*xform_isbrain;
            oxy_Delta = oxy_Delta.*xform_isbrain;
            gcampCorr_Delta = gcampCorr_Delta.*xform_isbrain;
            
            oxy_ISA(isnan(oxy_ISA)) = 0;
            gcampCorr_ISA(isnan(gcampCorr_ISA)) = 0;
            oxy_Delta(isnan(oxy_Delta)) = 0;
            gcampCorr_Delta(isnan(gcampCorr_Delta)) = 0;
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            oxy_ISA=reshape(oxy_ISA,info.nVy*info.nVx,[]);
            gcampCorr_ISA = reshape(gcampCorr_ISA,info.nVy*info.nVx,[]);
            
            oxy_Delta = reshape(oxy_Delta,info.nVy*info.nVx,[]);
            gcampCorr_Delta = reshape(gcampCorr_Delta,info.nVy*info.nVx,[]);
            
            
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            
            
            mm=10;
            mpp=mm/info.nVx;
            seedradmm=0.25;
            seedradpix=seedradmm/mpp;
            

            P=burnseeds(refseeds,seedradpix,xform_isbrain);
            
            strace_oxy_ISA = P2strace(P,oxy_ISA, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
            strace_gcampCorr_ISA = P2strace(P,gcampCorr_ISA, refseeds);
            strace_oxy_Delta = P2strace(P,oxy_Delta, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
            strace_gcampCorr_Delta=P2strace(P,gcampCorr_Delta, refseeds);
            
            
            
            R_oxy_ISA=strace2R(strace_oxy_ISA,oxy_ISA, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
            R_gcampCorr_ISA = strace2R(strace_gcampCorr_ISA,gcampCorr_ISA, info.nVx, info.nVy);
            R_oxy_Delta = strace2R(strace_oxy_Delta,oxy_Delta, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
            R_gcampCorr_Delta = strace2R(strace_gcampCorr_Delta,gcampCorr_Delta, info.nVx, info.nVy);
            
            clear oxy_ISA    gcampCorr_ISA    oxy_Delta    gcampCorr_Delta  
            
            R_oxy_ISA(isnan(R_oxy_ISA)) = 0;
            Rs_oxy_ISA=normRow(strace_oxy_ISA)*normRow(strace_oxy_ISA)';
            R_gcampCorr_ISA(isnan(R_gcampCorr_ISA)) = 0;
            Rs_gcampCorr_ISA = normRow(strace_gcampCorr_ISA)*normRow(strace_gcampCorr_ISA)';
            
            R_oxy_Delta(isnan(R_oxy_Delta)) = 0;
            Rs_oxy_Delta = normRow(strace_oxy_Delta)*normRow(strace_oxy_Delta)';
            R_gcampCorr_Delta(isnan(R_gcampCorr_Delta)) = 0;
            Rs_gcampCorr_Delta =normRow(strace_gcampCorr_Delta)*normRow(strace_gcampCorr_Delta)';
            
%             WL_atlas =  zeros(128,128);

            
            save(fullfile(saveDir,strcat(saveDataFileName_ISA,".mat",".mat")),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA', 'Rs_gcampCorr_ISA');
            save(fullfile(saveDir,strcat(saveDataFileName_Delta,".mat",".mat")),'R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', '-v7.3','-append');
            createFCMap()
            clear  R_oxy_ISA    Rs_oxy_ISA   R_gcampCorr_ISA    Rs_gcampCorr_ISA   R_oxy_Delta    Rs_oxy_Delta   R_gcampCorr_Delta    Rs_gcampCorr_Delta  
        end
       run=run+1; 
    end
    
end
    
    
    
