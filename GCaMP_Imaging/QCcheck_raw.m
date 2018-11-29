
close all;clearvars;clc
isGsr = true;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
%Xiaodan

if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end
%Xiaodan
for excelRow = 10:11
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':G',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = string(saveDir);
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    frameRate = excelRaw{7};
    if  strcmp(char(sessionType),'fc')
            bandtype = "Delta";
    else
            bandtype = "0.01Hz-8Hz";
    end
    for run = 1:3
        tiffFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),".tif");
        tiffFileName = fullfile(tiffFileDir,tiffFileName);
        

        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),"-",bandtype,isGsrname,"-NewDetrend");
        
        rawdata = readtiff(tiffFileName);
        [info.nVy, info.nVx, L]=size(rawdata);
        systemInfo.LEDFiles = 4;
        R=mod(L,systemInfo.LEDFiles);
        if R~=0
            rawdata=rawdata(:,:,1:(L-R));
            disp(['** ',num2str(systemInfo.LEDFiles-R),' frames were dropped **'])
            info.framesdropped=systemInfo.LEDFiles-R;
        end
        
        rawdata=reshape(rawdata,info.nVy,info.nVx,systemInfo.LEDFiles,[]);
        rawdata=rawdata(:,:,:,2:end); % cut off bad first set of framesraw
        
        info.T1=size(rawdata,4);
        
        testpixel=squeeze(rawdata(31,82,:,:));
        
        if any(any(testpixel==0))
            emptyframes=zeros(size(testpixel));
            for c=1:systemInfo.LEDFiles;
                emptyframes(c,:)=any(testpixel(c,:)==0,1);
            end
            disp([filename,num2str(run),' had empty frames, no QC performed, moving on...'])
            info.emptyframes=emptyframes;
            save([processedDataName,'.mat'],'info', '-append');
            break
        end
        info.freqout = 1;
        load(fullfile(saveDir,strcat(processedDataName,'.mat')),'xform_isbrain')
        
        ibi=find(xform_isbrain==1);
        rawdata=single(reshape(rawdata,info.nVy*info.nVx,systemInfo.LEDFiles,[]));
        
        clear mdatanorm stddatanorm
        mdata=squeeze(mean(rawdata(ibi,:,:),1));
        
        for c=1:systemInfo.LEDFiles;
            mdatanorm(c,:)=mdata(c,:)./(squeeze(mean(mdata(c,:),2)));
        end
        
        for c=1:systemInfo.LEDFiles;
            stddatanorm(c,:)=std(mdatanorm(c,:),0,2);
        end
        
        time=linspace(1,info.T1,info.T1)/frameRate;
        
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
        hz=linspace(0,frameRate,info.T1);
        subplot('position', [0.35 0.4 0.6 0.2])
        p=loglog(hz(1:ceil(info.T1/2)),fdata(:,1:ceil(info.T1/2))'); title('FFT Raw Data');
        for c=1:systemInfo.LEDFiles;
            set(p(c),'Color',Colors(c,:));
        end
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        xlim([0.01 15]);
        
        %% Movement Check
        rawdata=reshape(rawdata, info.nVy, info.nVx,systemInfo.LEDFiles, []);
        
        if strcmp(system, 'fcOIS1')
            BlueChan=4;
        elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')||strcmp(system, 'EastOIS1_Fluor')
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
        
        output=strcat(fullfile(saveDir,processedDataName),'_RawDataVis.jpg');
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
        save(strcat(fullfile(saveDir,processedDataName),'.mat'), 'mdatanorm', 'mdata', 'stddatanorm', 'LTMvMt', 'InstMvMt', 'Shift', 'time', 'fdata', 'hz','info', '-append');
        
        
    end
end