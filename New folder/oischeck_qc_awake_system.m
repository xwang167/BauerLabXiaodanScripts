function oischeck_qc_awake_system(op)                                                           %%%%%%%%%%%%%%%%%%%input op should be 'fc' or 'stim'
                                                                                                %%%%%%%%%%%%%%%%%%%all changes needed noted off to the side
                                                                                                %%%%%%%%%%%%%%%%%%%all runs change through filename
                                                                                                %%%%%%%%%%%%%%%%%%%if 'stim' also change lines 194-196
%           %Ket
%           qc=struct('Date',{'160829'},...
%           'MouseDay', {'Ms1'},...
%           'Runs', {[7 9]}); 
      
      qc=struct('Date',{'170526','170526','170527','170527','170527','170527','170527','170527','170528','170528','170528','170530','170530','170610'},...
          'MouseDay', {'a','a','a','a','a','a','a','a','a','a','a','a','a','a'},...
          'MouseNum', {'GCAMPSSRI3_3','GCAMPSSRI4_2','GCAMPSSRI1_1','GCAMPSSRI1_4','GCAMPSSRI2_3','GCAMPSSRI3_1','GCAMPSSRI3_4','GCAMPSSRI4_3','GCAMPSSRI1_3','GCAMPSSRI2_4','GCAMPSSRI4_1','GCAMPSSRI1_5','GCAMPSSRI3_2','GCAMPSSRI2_1'},...
          'Runs', {[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3],[1:3]});   

%       qc=struct('Date',{'170714','170714','170714','170714','170628','170628','170628','170628'},...
%           'MouseDay', {'etc','a','a','a','a','a','a','a'},...
%           'MouseNum', {'9510-1_P22','9510-2_P22','9510-5_P22','9510-7_P22','9309-1_P28','9309-2_P28','9365-2_P35','9365-4_P35'},...
%           'Runs', {[1:6],[1:4],[1:4],[1:4],[1:6],[1:5],[1:6],[1:6]}); 
      
for i=1:length(qc)      
      
date=qc(i).Date;
msd=qc(i).MouseDay;
runs=qc(i).Runs;

mousenum=qc(i).MouseNum;
      
    %tif=[date '\GCAMP\' date '-' mousenum '-fc'  num2str(n)];%
    
    path=['Z:\Rachel\Rachel_fcOIS\'];
    %path=['Y:\Zach\'];                                                                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change path
    label='-Affine_GSR_NewDetrend_is';                                                              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change proc file tag
    ibi=imread([path date '\' date '-' mousenum '_mask.tif']);                                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change mask
    seedcenter=cell2mat(struct2cell(load([path date '\' date '-' mousenum '_seeds.mat'],'seedcenter')));        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change seeds
    %%WL=cell2mat(struct2cell(load(['H:\DATA\GOOD_AFF_WL'])));     
    %WL=load(['Z:\Rachel\Rachel_fcOIS\Development\' date '\' date '-' mousenum '-fc' num2str(n) '-Affine_GSR_NewDetrend'],'WL2');                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change WL
    

    
for n=min(runs):max(runs)
    WL=cell2mat(struct2cell(load(['Z:\Rachel\Rachel_fcOIS\' date '\' date '-' mousenum '-fc' num2str(n) '-Affine_GSR_NewDetrend_is'],'WL2')));                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change WL
    disp(['OISCheck on ' date]);
        disp('Mouse');  msd 
        disp('Run'); n
        clear functions mex; clf; cla; close all;
        
        %filename=[date '\' date '-' mousenum '-fc' num2str(n)];
        filename=[date '\' date '-' mousenum '-stim' num2str(n)];
        %filename=[date '-' msd '-stim' num2str(n)];                                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change filename
        
        [rawdata]=readtiff([path filename '.tif']);
        
        info.framerate=16.81;
        info.numled=4;
        [nVy, nVx, L]=size(rawdata);
        L2=L-rem(L,info.numled);
        rawdata=rawdata(:,:,1:L2);
        info.nVx=nVx;
        info.nVy=nVy;
       
        for x=1:info.nVx
        for y=1:info.nVy
            
            if ibi(x,y)<255
                isbrain(x,y)=0;
            else
                isbrain(x,y)=1;
            end
            
        end
        end
       
        ibiz=find(isbrain==1);
       
        rawdata=reshape(rawdata,info.nVx,info.nVy,info.numled,[]);
        rawdata=rawdata(:,:,:,2:end); 
        info.T1=size(rawdata,4);
        rawdata=double(reshape(rawdata,info.nVx*info.nVy,info.numled,[]));
        
        mdata=squeeze(mean(rawdata(ibiz,:,:),1));
        
        for c=1:info.numled;
            mdatanorm(c,:)=mdata(c,:)./(squeeze(mean(mdata(c,:),2)));
        end
        
        for c=1:info.numled;
            stddatanorm(c,:)=std(mdatanorm(c,:),0,2);
        end
        
        time=linspace(1,info.T1,info.T1)/info.framerate;
        
        fhraw=figure('Units','inches','Position',[15 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        
        %% Raw Data Check
        
        subplot('position', [0.12 0.71 0.17 0.2])
        p=plot(time,mdata'); title('Raw Data');
        set(p(1),'Color',[0 0 1]);
        set(p(2),'Color',[0 1 0]);
        set(p(3),'Color',[1 1 0]);
        set(p(4),'Color',[1 0 0]);
        title('Raw Data');
        xlabel('Time (sec)')
        ylabel('Counts');
        ylim([2000 10000])
        
        subplot('position', [0.35 0.71 0.17 0.2])
        p=plot(time,mdatanorm'); title('Normalized Raw Data');
        set(p(1),'Color',[0 0 1]);
        set(p(2),'Color',[0 1 0]);
        set(p(3),'Color',[1 1 0]);
        set(p(4),'Color',[1 0 0]);
        xlabel('Time (sec)')
        ylabel('Mean Counts')
         ylim([0.95 1.05])

        subplot('position', [0.6 0.71 0.1 0.2])
        plot(stddatanorm*100');
        set(gca,'XTick',(1:4));
        set(gca,'XTickLabel',{'B', 'G', 'Y', 'R'})
        title('Std Deviation');
        ylabel('% Deviation')
        
        
        %% FFT Check
        fdata=abs(fft(logmean(mdata),[],2));
        hz=linspace(0,info.framerate,info.T1);        
        subplot('position', [0.77 0.71 0.2 0.2])
        p=loglog(hz(1:ceil(info.T1/2)),fdata(:,1:ceil(info.T1/2))'); title('FFT Raw Data');
        set(p(1),'Color',[0 0 1]);
        set(p(2),'Color',[0 1 0]);
        set(p(3),'Color',[1 1 0]);
        set(p(4),'Color',[1 0 0]);
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        xlim([0.01 15]);
        
        %% Movement Check
        rawdata=reshape(rawdata, info.nVy, info.nVx,info.numled, []);
        Im1=single(squeeze(rawdata(:,:,4,1)));
        F1 = fft2(Im1); % reference image
        
        InstMvMt=zeros(size(rawdata,4),1);
        LTMvMt=zeros(size(rawdata,4),1);
        Shift=zeros(2,size(rawdata,4),1);
        
        for t=1:size(rawdata,4)-1;
            LTMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,4,t+1))-Im1)));
            InstMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,4,t+1))-squeeze(rawdata(:,:,4,t)))));
        end
        
        for t=1:size(rawdata,4);
            Im2=single(squeeze(rawdata(:,:,4,t)));
            F2 = fft2(Im2); % subsequent image to translate
            
            pdm = exp(1i.*(angle(F1)-angle(F2))); % Create phase difference matrix
            pcf = real(ifft2(pdm)); % Solve for phase correlation function
            pcf2(1:size(Im1,1)/2,1:size(Im1,1)/2)=pcf(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1)); 
            pcf2(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1))=pcf(1:size(Im1,1)/2,1:size(Im1,1)/2); 
            pcf2(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1))=pcf(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2); 
            pcf2(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2)=pcf(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1)); 
            
            [~, imax] = max(pcf2(:));
            [ypeak, xpeak] = ind2sub(size(Im1,1),imax(1));
            offset = [ypeak-(size(Im1,1)/2+1) xpeak-(size(Im1,2)/2+1)];
            
            Shift(1,t)=offset(1);
            Shift(2,t)=offset(2);
            
        end
        
        clear rawdata
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
        plot(time, Shift(1,:),'m');
        hold on;
        plot(time, Shift(2,:),'k');
        ylim([-1*(max(Shift(:))+1) max(Shift(:)+1)]);
        xlabel('Time  (sec)');
        ylabel('Offset (pixels)');
        legend('Vertical','Horizontal');
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',[path filename ' Data Visualization'],'FontWeight','bold','Color',[0 0 1]);
  
        
         %% Check Evoked Responses
        
        %if strcmp(op, 'stim')
            
            file=[path filename label];                              
            load(file,'gcamp6all','oxy');
            AC = 84:168;                                                                            %%%%%%%%%%%%%%%%%%%%%%%%change frames stim is present
            info.stimlength=336;                                                                    %%%%%%%%%%%%%%%%%%%%%%%%change length of a block   
            info.hzstim=3;   
            info.framerate=29.76;
    info.freqout=1;
    info.lowpass=0.5;
    info.highpass=0.009;
    info.numled=4;
    info.stimblocksize=60;
    info.stimbaseline=5;
    info.stimduration=10;
    %%%%%%%%%%%%%%%%%%%%%%%%change freq of stims
            
            gcamp=real(squeeze(gcamp6all(:,:,1,:)));
            gcamp(:,:,length(gcamp6all)+1)=zeros(info.nVy,info.nVx);
            gcamp=reshape(gcamp,info.nVy,info.nVx,info.stimlength,length(gcamp)/info.stimlength);
            
            oxy(:,:,length(oxy)+1)=zeros(info.nVy,info.nVx);
            Oxy=real(reshape(oxy,info.nVy,info.nVx,info.stimlength,length(oxy)/info.stimlength));
            

            
            for b=1:size(Oxy,4)
                MeanFrame=squeeze(mean(Oxy(:,:,[1:(min(AC)-1) (max(AC)+1):end],b),3));
                for t=1:size(Oxy, 3);
                    Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
                end
            end
            
            
            for b=1:size(gcamp,4)
                MeanFrame=squeeze(mean(gcamp(:,:,[1:(min(AC)-1) (max(AC)+1):end],b),3));
                for t=1:size(gcamp, 3);
                    gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                end
            end
            
            AvgOxy=mean(Oxy,4);
            Avggcamp=mean(gcamp,4);
            
            MeanFrame=squeeze(mean(AvgOxy(:,:,[1:(min(AC)-1) (max(AC)+1):end]),3));
            for t=1:size(AvgOxy, 3);
                AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(Avggcamp(:,:,[1:(min(AC)-1) (max(AC)+1):end]),3));
            for t=1:size(Avggcamp, 3);
                Avggcamp(:,:,t)=squeeze(Avggcamp(:,:,t))-MeanFrame;
            end
            
            %From oischeck_fromraw_mvmt: Oxy=reshape(Oxy,info.nVy,info.nVx,info.stimblocksize,[]);
%             for b=1:size(Oxy,4)
%                 MeanFrame=squeeze(mean(Oxy(:,:,1:info.stimbaseline,b),3));
%                 for t=1:size(Oxy, 3);
%                     Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
%                 end
%             end
%             
%             DeOxy=reshape(DeOxy,info.nVy,info.nVx,info.stimblocksize,[]);
%             for b=1:size(DeOxy,4)
%                 MeanFrame=squeeze(mean(DeOxy(:,:,1:info.stimbaseline,b),3));
%                 for t=1:size(DeOxy, 3);
%                     DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
%                 end
%             end
%             
%             AvgOxy=mean(Oxy,4);
%             AvgDeOxy=mean(DeOxy,4);
%             AvgTotal=mean(Oxy+DeOxy,4);
%             
%             MeanFrame=squeeze(mean(AvgOxy(:,:,1:info.stimbaseline),3));
%             for t=1:size(AvgOxy, 3);
%                 AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
%             end
%             
%             MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:info.stimbaseline),3));
%             for t=1:size(AvgDeOxy, 3);
%                 AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
%             end
%             
%             MeanFrame=squeeze(mean(AvgTotal(:,:,1:info.stimbaseline),3));
%             for t=1:size(AvgTotal, 3);
%                 AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
%             end

            subplot('position', [0.05 0.05 0.095 0.095]);
            imagesc(mean(AvgOxy(:,:,AC),3), [-1e-3 1e-3]);
            axis image off; 
            title('Avg Oxy')
            
            subplot('position', [0.20 0.05 0.095 0.095]);
            imagesc(mean(Avggcamp(:,:,AC),3), [-5e-3 5e-3]);
            axis image off;
            title('Avg GCaMP')
            
            Actmean=mean(Avggcamp(:,:,AC),3);
            Actmeano=mean(AvgOxy(:,:,AC),3);
            
            for p=1:info.nVx
            for j=1:info.nVy
    
            Actnew(p,j)=isbrain(p,j)*Actmean(p,j);
            Actnewo(p,j)=isbrain(p,j)*Actmeano(p,j);

            end
            end
            
            linemap = reshape(Actnew,info.nVx*info.nVy,1);

            maxforroi = max(linemap);
            disp(['max is ',num2str(maxforroi)]);
            thresh= 0.9*maxforroi;

            Act2 = Actnew;
            Act2(Act2<thresh)=0;

            Act2 = logical(Act2);
            
            gcamp= reshape(Avggcamp,info.nVx*info.nVy,info.stimlength);
            oxy=reshape(AvgOxy,info.nVx*info.nVy,info.stimlength);

            ROIx= Act2;
            ROI2 = reshape(ROIx,info.nVx*info.nVy,1);
            ROImask = find(ROI2);
            indivROI = gcamp(ROImask,:);
            indivROIo = oxy(ROImask,:);
            gcampROI=(mean(indivROI,1));
            gcampROIo=(mean(indivROIo,1));

            framelines= min(AC)/info.framerate:1/info.hzstim:max(AC)/info.framerate;
            seconds= linspace(0,info.stimlength/info.framerate,info.stimlength);
            subplot('position', [0.075 0.25 0.3 0.3]);
                yyaxis left
                plot(seconds,gcampROI,'k','linewidth',2); ylabel('GCaMP \DeltaF/F'); xlabel('Time (s)'); title('Group Average Left Forepaw'); hold on

                yyaxis right
                plot(seconds,gcampROIo,'r','linewidth',2); ylabel('\Delta Oxy');

                vline(framelines,'b'); legend('GCaMP','Oxy');


                
%         %% Check functional connectivty       
%         %elseif strcmp(op, 'fc')
%             
%             load([path filename label],'gcamp6all');
%             gcamp3c=squeeze(gcamp6all(:,:,1,:));
%             
%             seednames={'Olf','Fr','Cg','M','SS','RS','V'};
%             seedcenter=seedcenter(1:14,:);
%             sides={'L','R'};
%             
%             mm=10;
%             mpp=mm/info.nVx;
%             seedradmm=0.25;
%             seedradpix=seedradmm/mpp;
%             
%             numseeds=numel(seednames);
%             numsides=numel(sides);
%             
%             P=(burnseeds(seedcenter,seedradpix,isbrain));
%             strace=P2strace(P,gcamp3c); 
%             R=strace2R(strace,gcamp3c,nVx,nVy); 
%             Rs=normr(strace)*normr(strace)';
%             
%             for s=1:numseeds
%                 
%                 OE=0;
%                 if mod(s,2)==0
%                     OE=0.25;
%                 else
%                     OE=0.05;
%                 end
%                 
%                 subplot('position', [OE (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
%                 Im2=overlaymouse(R(:,:,(2*(s-1)+1)),WL, isbrain,'jet',-1,1);
%                 image(Im2); 
%                 hold on;
%                 plot(seedcenter(2*(s-1)+1,1),seedcenter(2*(s-1)+1,2),'ko');
%                 axis image off
%                 title([seednames{s},'L'])
%                 
%                 subplot('position', [OE+0.10 (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
%                 Im2=overlaymouse(R(:,:,(2*(s-1)+2)),WL, isbrain,'jet',-1,1);
%                 image(Im2); 
%                 hold on;
%                 plot(seedcenter(2*(s-1)+2,1),seedcenter(2*(s-1)+2,2),'ko');
%                 axis image off
%                 title([seednames{s},'R'])
%                 hold off;
%                 
% 
%             end
%             
%                 annotation('textbox', [0.205 0.54 1 0.1], ...
%                 'String', 'GcaMP FC', ...
%                 'EdgeColor', 'none',...
%                 'FontSize', 12,...
%                 'FontWeight','bold')
%             
%         %end
%         
        
        
        
        output=[path filename '_DataVis.jpg'];
        orient portrait
        print ('-djpeg', '-r300', output);
        
        close all
        clear info isbrain
end
end
end
        
        
        
        
        
        
        
        
        
        
        
        