
close all;clearvars;clc

excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


% create landmarks and mask for all mice
% for excelRow = 17:21
%      [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     systemType = excelRaw{5};
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     systemInfo = mouse.expSpecific.sysInfo(systemType);
%     sessionInfo = mouse.expSpecific.sesInfo('gcamp6f');
%     
%     sessionInfo.darkFrameNum = excelRaw{11};
% 
%     
%     GetLandMarksandMask_fluor(recDate, mouseName, saveDir, tiffFileDir, systemType,systemInfo,sessionInfo)
% end

% poolobj = gcp('nocreate'); % If no pool, do not create new one.
% numcores = feature('numcores');
% if isempty(poolobj)
%     parpool('local',numcores);
% end


for excelRow = 28:32
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    frameRate = excelRaw{7};
    
    systemInfo = mouse.expSpecific.sysInfo(systemType);
    sessionInfo = mouse.expSpecific.sesInfo(excelRaw{13});
    
    
    % manually change sessionInfo since Xiaodan uses some different
    % parameters for fc and stim sessions
    
    sessionInfo.framerate = frameRate;
    sessionInfo.freqout = frameRate;
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline = excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
    sessionInfo.darkFrameNum = excelRaw{11};             
     
    ProcMultiOISFiles_fluor(recDate, mouseName, systemType, saveDir, tiffFileDir, sessionInfo, systemInfo,sessionType)
    
%     load('atlas.mat','AtlasSeeds');
%     roi = AtlasSeeds == 9;
%  
%     OISGCaMPQC_run(recDate, mouseName, sessionType, saveDir, tiffFileDir, true,systemInfo,sessionInfo,roi)
%      OISGCaMPQC_run(recDate, mouseName, sessionType, saveDir, tiffFileDir, false,systemInfo,sessionInfo,roi)

end
close all;
clear all;
isGsr = false;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
%Xiaodan

if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '-NoGSR';
end
for excelRow = [20 21]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':K',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    frameRate = excelRaw{7};
    darkTime = excelRaw{11};
    
    for run = 1:3
        tiffFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),".tif");
        tiffFileName = fullfile(tiffFileDir,tiffFileName);
        
        
        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
        
        rawdata = double(readtiff(tiffFileName));
        
        
        [info.nVy, info.nVx, L]=size(rawdata);
        systemInfo.LEDFiles = 4;
        R=mod(L,systemInfo.LEDFiles);
        if R~=0
            rawdata=rawdata(:,:,1:(L-R));
            disp(['** ',num2str(systemInfo.LEDFiles-R),' frames were dropped **'])
            info.framesdropped=systemInfo.LEDFiles-R;
        end
        
        rawdata=reshape(rawdata,info.nVy,info.nVx,systemInfo.LEDFiles,[]);
        if darkTime == 0
            rawdata = rawdata(:,:,:,2:end);
        else
            darkFrameNum = rawdata(:,:,:,2:round(darkTime));% cut off bad first set of framesraw
            rawdata=rawdata(:,:,:,(round(darkTime)+1):end);
            darkFrame = nanmean(darkFrameNum,4);
            
            rawdata = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
        end
        info.T1=size(rawdata,4);
        
        testpixel=squeeze(rawdata(31,82,:,:));
        
        if any(any(testpixel==0))
            emptyframes=zeros(size(testpixel));
            for c=1:systemInfo.LEDFiles;
                emptyframes(c,:)=any(testpixel(c,:)==0,1);
            end
            disp([filename,num2str(run),' had empty frames, no QC performed, moving on...'])
            info.emptyframes=emptyframes;
            save(fullfile(saveDir,strcat(processedDataName,'.mat')),'info', '-append');
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


close all;
clear all;
isGsr = false;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
%Xiaodan

if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end
for excelRow = [17] %6:15
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    for run = 1:3
        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
        if  strcmp(char(sessionType),'fc')
            
             
            load(strcat(fullfile(saveDir,processedDataName),".mat"),'xform_datahb_','xform_gcampCorr_ISA','xform_datahb_Delta','xform_gcampCorr_Delta','xform_isbrain','sessionInfo')
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
            system = 'EastOIS1_Fluor';
            oxy_ISA=reshape(oxy_ISA,info.nVy*info.nVx,[]);
            gcampCorr_ISA = reshape(gcampCorr_ISA,info.nVy*info.nVx,[]);
            
            oxy_Delta = reshape(oxy_Delta,info.nVy*info.nVx,[]);
            gcampCorr_Delta = reshape(gcampCorr_Delta,info.nVy*info.nVx,[]);
            
            seednames={'Olf','Fr','Cg','M','SS','RS','V'};
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            sides={'L','R'};
            
            mm=10;
            mpp=mm/info.nVx;
            seedradmm=0.25;
            seedradpix=seedradmm/mpp;
            
            numseeds=numel(seednames);
            numsides=numel(sides);
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
            
            WL_atlas =  zeros(128,128);
            figure;
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p1,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            
            for s=1:numseeds
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            
            
            
            
            
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
            
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
            
            
            
            
            
            
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,' Processed Data Visualization'),'FontWeight','bold');
            annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
            
            annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
            
            output= strcat(fullfile(saveDir,processedDataName),'_FCMap.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all
            
            save(strcat(fullfile(saveDir,processedDataName),".mat"),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA', 'Rs_gcampCorr_ISA','R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', '-append');
            clear  R_oxy_ISA    Rs_oxy_ISA   R_gcampCorr_ISA    Rs_gcampCorr_ISA   R_oxy_Delta    Rs_oxy_Delta   R_gcampCorr_Delta    Rs_gcampCorr_Delta  
        else
            %rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
            %         [~, ~, L]=size(rawdata);
            
            load(strcat(fullfile(saveDir,processedDataName),".mat"),'xform_datahb','xform_gcampCorr','xform_isbrain','xform_gcamp','xform_total','sessionInfo','info')
            %[oxy, deoxy]=gsr(xform_datahb,xform_isbrain);
            oxy = squeeze(xform_datahb(:,:,1,:));
            deoxy = squeeze(xform_datahb(:,:,2,:));
            total = squeeze(xform_total(:,:,1,:));
            gcamp = squeeze(xform_gcamp(:,:,1,:));
            gcampCorr = squeeze(xform_gcampCorr(:,:,1,:));
            
            clear xform_datahb xform_total xform_gcamp xform_gcampCorr
            
            oxy = oxy.*xform_isbrain;
            deoxy = deoxy.*xform_isbrain;
            total = total .*xform_isbrain;
            gcamp = gcamp.*xform_isbrain;
            gcampCorr = gcampCorr.*xform_isbrain;
            
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
            
            AvgOxy_stim= mean(oxy(:,:,(sessionInfo.stimbaseline+1):(sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),:),4);
            AvggcampCorr_stim = mean(gcampCorr(:,:,(sessionInfo.stimbaseline+1):(sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),:),4);
            
            MeanFrame=squeeze(mean(AvgOxy_stim(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvgOxy_stim,3);
                AvgOxy_stim(:,:,t)=squeeze(AvgOxy_stim(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvggcampCorr_stim(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvggcampCorr_stim, 3);
                AvggcampCorr_stim(:,:,t)=squeeze(AvggcampCorr_stim(:,:,t))-MeanFrame;
            end
            
            
            
            
            %% Block Average for each run
            
            
            
            
            
            
            
            
            
            
            
            
            
            %% Make Plots
            gcamp_peakStim = zeros(info.nVy,info.nVx,size(gcamp,4));
            for b=1:size(gcamp,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
                gcamp_peakStim(:,:,b)=gcamp(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(gcamp_peakStim(:,:,b), [-0.75*max(max(gcamp_peakStim(:,:,b))) 0.75*max(max(gcamp_peakStim(:,:,b)))]);
                
                if b == size(gcamp,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.8 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampRaw')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            gcampCorr_peakStim = zeros(info.nVy,info.nVx,size(gcamp,4));
            for b=1:size(gcampCorr,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
                gcampCorr_peakStim(:,:,b)=gcampCorr(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(gcampCorr_peakStim(:,:,b), [-0.75*max(max(gcampCorr_peakStim(:,:,b))) 0.75*max(max(gcampCorr_peakStim(:,:,b)))]);
                if b == size(gcampCorr,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.65 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampCorr')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            oxy_peakStim = zeros(info.nVy,info.nVx,size(gcamp,4));
            for b=1:size(oxy,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
                oxy_peakStim(:,:,b)=oxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(oxy_peakStim(:,:,b), [-0.75*max(max(oxy_peakStim(:,:,b))) 0.75*max(max(oxy_peakStim(:,:,b)))]);
                if b == size(oxy,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b == 1
                    ylabel('Oxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            deoxy_peakStim = zeros(info.nVy,info.nVx,size(gcamp,4));
            for b=1:size(deoxy,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
                deoxy_peakStim(:,:,b)=deoxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(deoxy_peakStim(:,:,b), [-0.75*max(max(deoxy_peakStim(:,:,b))) 0.75*max(max(deoxy_peakStim(:,:,b)))]);
                if b == size(deoxy,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.35 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('DeOxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            total_peakStim = zeros(info.nVy,info.nVx,size(gcamp,4));
            
            
            for b=1:size(total,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
                total_peakStim(:,:,b)=total(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(total_peakStim(:,:,b), [-0.75*max(max(total_peakStim(:,:,b))) 0.75*max(max(total_peakStim(:,:,b)))]);
                if b == 10
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.2 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('Total')
                end
                title(['Pres ', num2str(b)]);
            end
            
            clear oxy deoxy total gcamp gcampCorr
            
            p = subplot('position', [0.015 0.05 0.095 0.095]);
            Avggcamp_peakStim=mean(Avggcamp_stim(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(Avggcamp_peakStim, [-0.75*max(max(Avggcamp_peakStim)) 0.75*max(max(Avggcamp_peakStim))]);
            colorbar
            set(p,'Position',[0.015 0.05 0.095 0.095]);
            axis image off
            title('Avg Gcamp')
            
            
            
            p = subplot('position', [0.165 0.05 0.095 0.095]);
            AvggcampCorr_peakStim=mean(AvggcampCorr_stim(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(AvggcampCorr_peakStim, [-0.75*max(max(AvggcampCorr_peakStim)) 0.75*max(max(AvggcampCorr_peakStim))]);
            colorbar
            set(p,'Position',[0.165 0.05 0.095 0.095]);
            axis image off
            title('Avg GcampCorr')
            

            
            p = subplot('position', [0.315 0.05 0.095 0.095]);
            AvgOxy_peakStim=mean(AvgOxy_stim(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(AvgOxy_peakStim, [-0.75*max(max(AvgOxy_peakStim)) 0.75*max(max(AvgOxy_peakStim))]);
            colorbar
            set(p,'Position',[0.315 0.05 0.095 0.095]);
            axis image off
            title('Avg Oxy')
            
            p = subplot('position', [0.465 0.05 0.095 0.095]);
            AvgDeOxy_peakStim=mean(AvgDeOxy_stim(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);

            imagesc(AvgDeOxy_peakStim, [-0.75*max(max(AvgDeOxy_peakStim)) 0.75*max(max(AvgDeOxy_peakStim))]);
            colorbar
            set(p,'Position',[0.465 0.05 0.095 0.095]);
            axis image off
            title('Avg DeOxy')
            
            
            p = subplot('position', [0.615 0.05 0.095 0.095]);
            AvgTotal_peakStim=mean(AvgTotal_stim(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(AvgTotal_peakStim, [-0.75*max(max(AvgTotal_peakStim)) 0.75*max(max(AvgTotal_peakStim))]);
            colorbar
            set(p,'Position',[0.615 0.05 0.095 0.095]);
            axis image off
            title('Avg Total')
            
            save(strcat(fullfile(saveDir,processedDataName),".mat") , 'info','AvgOxy_peakStim', 'AvgDeOxy_peakStim', 'AvgTotal_peakStim','Avggcamp_peakStim','AvggcampCorr_peakStim','gcamp_peakStim','gcampCorr_peakStim','oxy_peakStim','deoxy_peakStim','total_peakStim', '-append');
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,'Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
            
            output= strcat(fullfile(saveDir,processedDataName),'_StimMap.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all
            clear AvgOxy AvgDeOxy AvgTotal Avggcamp AvggcampCorr 
            
        end
    end
end

