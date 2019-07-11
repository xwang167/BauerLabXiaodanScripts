clear all;close all;clc
import mouse.*
excelRow = [90];
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
recDate = excelRaw{1}; recDate = string(recDate);
mouseName = excelRaw{2}; mouseName = string(mouseName);
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemInfo.invalidFrameInd = 1;
systemInfo.numLEDs = 4;
    systemInfo.LEDFiles = ["East3410OIS1_TL_470_Pol.txt", "East3410OIS1_TL_590_Pol.txt","East3410OIS1_TL_617_Pol.txt",  "East3410OIS1_TL_625_Pol.txt"];
    pkgDir = what('bauerParams');
rawdataloc = excelRaw{3};
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);

    ledDir = fullfile(pkgDir.path,'ledSpectra');
    for ind = 1:numel(systemInfo.LEDFiles)
        systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
        
    end
    
    
    
    for excelRow = 90
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    systemInfo = mouse.expSpecific.sysInfo(systemType);
    mouseType = excelRaw{13};
    sessionInfo =  mouse.expSpecific.sesInfo(mouseType);
    sessionInfo.mouseType = mouseType;
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);

    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    if exist(fullfile(saveDir,maskName))
        disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
        load(fullfile(saveDir,maskName), 'isbrain',  'I')
    else
        % need to be modified to see if WL exist
        sessionInfo.darkFrameNum = excelRaw{11};

        sessionInfo.stimbaseline=excelRaw{9};
        sessionInfo.framerate = excelRaw{7};
        sessionInfo.stimblocksize = excelRaw{8};
        darkFrameInd = 2:sessionInfo.darkFrameNum;
        filename = char(fullfile(rawdataloc,recDate,strcat(recDate,'-',mouseName,'-',sessionType,'1.tif')));

        %     raw = read.readRaw(fileName,systemInfo.numLEDs,systemInfo.readFcn);
        %     WL = preprocess.getWL(raw,darkFrameInd,[4 3 2]);

        WL= zeros(128,128,3);
        green= read.readtiff_oneImage(filename,7);
        blue = read.readtiff_oneImage(filename,6);
        red = read.readtiff_oneImage(filename,9);

        WL(:,:,1) = red./max(max(red));
        WL(:,:,2) = green/max(max(green));
        WL(:,:,3) = blue/max(max(blue));

        disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
        [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
        save(fullfile(saveDir,maskName), 'isbrain',  'I' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter')
        isbrain_contour = bwperim(isbrain);

        figure;
        imagesc(WL); %changed 3/1/1
        axis off
        axis image
        title(strcat(recDate,'-',mouseName));

        for f=1:size(seedcenter,1)
            hold on;
            plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
        end
        hold on;
        plot(I.tent(1,1),I.tent(1,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(I.bregma(1,1),I.bregma(1,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(I.OF(1,1),I.OF(1,2),'ko','MarkerFaceColor','b')
        hold on;
        contour(isbrain_contour,'r')
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMask.jpg')))
    end
    clearvars -except excelFile nVx nVy excelRows runs
    close all;
end

 muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;    
     sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = false;
    sessionInfo.detrendTemporally = true;
        sessionInfo.framerate = excelRaw{7};
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
   n=1;
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            disp('preprocess');
            systemInfo.invalidFrameInd = 1;
            fileName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
            raw = readtiff(char(fullfile(rawdataloc,recDate,fileName)));
            raw = reshape(raw,128,128,5,[]);
            raw = double(raw(:,:,1:4,:));
            time = 1:size(raw,4); time = time./sessionInfo.framerate;
            maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
            load(fullfile(saveDir,maskName), 'xform_isbrain','I')
            [time,xform_raw,raw] = fluor.preprocess(time,raw,systemInfo,sessionInfo,I);
            save(fullfile(saveDir,rawName),'raw','xform_raw','-v7.3')

            disp('get hemoglobin data');



            xform_isbrain(isnan(xform_isbrain)) = 0;
            xform_isbrain = logical(xform_isbrain);


            [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles);
            BaselineFunction  = @(x) mean(x,numel(size(x)));
            baselineValues = BaselineFunction(xform_raw);
            xform_datahb = mouse.process.procOIS(xform_raw,baselineValues,op.dpf,E,xform_isbrain);
            save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','-v7.3')




for excelRow = 90
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    
    for n = 1
          
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','sessionInfo')
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','sessionInfo')
        end
        
        if strcmp(sessionType,'fc')
            oxy = double(squeeze(xform_datahb(:,:,1,:)));
            disp(char(['QC check on ', processedName]))
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcampCorr = double(squeeze(xform_gcampCorr));
                QCcheck_fc(oxy,gcampCorr,'gcamp',xform_isbrain, sessionInfo,saveDir,visName);
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                
                jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr));
                QCcheck_fc(oxy,jrgeco1aCorr,'jrgeco1a',xform_isbrain, sessionInfo,saveDir,visName);
            end
        elseif strcmp(sessionType,'stim')
            
            sessionInfo.stimblocksize = excelRaw{8};
            sessionInfo.stimbaseline=excelRaw{9};
            sessionInfo.stimduration = excelRaw{10};
            sessionInfo.stimFrequency = excelRaw{12};
            info.newFreq = 8;
            info.freqout=1;
            info.bandtype = {"0.01Hz-8Hz",0.01,8};
            
            
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                C = who('-file',fullfile(saveDir,processedName));
                isBandPass = false;
                for  k=1:length(C)
                    if strcmp(C(k),'xform_green_GSR')
                        isBandPass = true;
                    end
                end
                if isBandPass
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR');
                else
                    xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                    xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                    rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                    
                    disp('loading raw data');
                    if strcmp(systemType,'EastOIS2')
                        
                        load(fullfile(saveDir,rawName),'xform_raw')
                    elseif strcmp(systemType,'EastOIS1_Fluor')
                        load(fullfile(saveDir,rawName),'xform_raw');
                    end
                    xform_raw = double(mouse.expSpecific.procFluor(xform_raw));
                    if ~isempty(find(isnan(xform_raw), 1))
                        xform_raw(isnan(xform_raw))=0;
                    end
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp','xform_gcampCorr')
                    if ~isempty(find(isnan(xform_gcamp), 1))
                        xform_gcamp(isnan(xform_gcamp))=0;
                    end
                    if ~isempty(find(isnan(xform_gcampCorr), 1))
                        xform_gcampCorr(isnan(xform_gcampCorr))=0;
                    end
                    
                    
                    
                    
                    xform_gcamp_bandpass =highpass(double(xform_gcamp),info.bandtype{2},sessionInfo.framerate);
                    xform_gcampCorr_bandpass =highpass(double(xform_gcampCorr),info.bandtype{2},sessionInfo.framerate);
                    xform_green_bandpass =highpass(xform_raw(:,:,2,:),info.bandtype{2},sessionInfo.framerate);
                    
                    xform_gcamp_bandpass =lowpass(double(xform_gcamp_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_gcampCorr_bandpass =lowpass(double(xform_gcampCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_green_bandpass =lowpass(xform_green_bandpass,info.bandtype{3},sessionInfo.framerate);
                    %
                    
                    
                    
                    
                    xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_gcamp_GSR = mouse.preprocess.gsr(xform_gcamp_bandpass,xform_isbrain);
                    xform_gcampCorr_GSR = mouse.preprocess.gsr(xform_gcampCorr_bandpass,xform_isbrain);
                    xform_green_GSR = mouse.preprocess.gsr(xform_green_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','-append');
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                C = who('-file',fullfile(saveDir,processedName));
                isBandPass = false;
                for  k=1:length(C)
                    
                    if strcmp(C(k),'xform_red_bandpass')
                        isBandPass = true;
                    end
                end
                if isBandPass
                    %                     load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_bandpass','xform_jrgeco1a_bandpass','xform_jrgeco1aCorr_bandpass','xform_red_bandpass');
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR');
                else
                    xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                    xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                    rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                    
                    disp('loading raw data');
                    if strcmp(systemType,'EastOIS2')
                        
                        load(fullfile(saveDir,rawName),'xform_raw')
                    elseif strcmp(systemType,'EastOIS1_Fluor')
                        load(fullfile(saveDir,rawName),'xform_raw');
                    end
                    xform_red = double(mouse.expSpecific.procFluor(xform_raw(:,:,3,:)));
                    if ~isempty(find(isnan(xform_red), 1))
                        xform_red(isnan(xform_red))=0;
                    end
                    
                    load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat'),'xform_jrgeco1a','xform_jrgeco1aCorr')
                    if ~isempty(find(isnan(xform_jrgeco1a), 1))
                        xform_jrgeco1a(isnan(xform_jrgeco1a))=0;
                    end
                    if ~isempty(find(isnan(xform_jrgeco1aCorr), 1))
                        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr))=0;
                    end
                    
                    xform_jrgeco1a_bandpass =highpass(double(xform_jrgeco1a),info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =highpass(double(xform_jrgeco1aCorr),info.bandtype{2},sessionInfo.framerate);
                    xform_red_bandpass =highpass(xform_red,info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1a_bandpass =lowpass(double(xform_jrgeco1a_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =lowpass(double(xform_jrgeco1aCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_red_bandpass =lowpass(xform_red_bandpass,info.bandtype{3},sessionInfo.framerate);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_bandpass','xform_jrgeco1a_bandpass','xform_jrgeco1aCorr_bandpass','xform_red_bandpass','-append');
                    %
                    
                    xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_jrgeco1a_GSR = mouse.preprocess.gsr(xform_jrgeco1a_bandpass,xform_isbrain);
                    xform_jrgeco1aCorr_GSR = mouse.preprocess.gsr(xform_jrgeco1aCorr_bandpass,xform_isbrain);
                    xform_red_GSR = mouse.preprocess.gsr(xform_red_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append');
                end
            elseif strcmp(char(sessionInfo.mouseType),'WT')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb')
                xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
            end
            %
            %
            % if ~isempty(find(isnan(xform_datahb_bandpass_GSR), 1))
            %     xform_datahb_bandpass_GSR(isnan(xform_datahb_bandpass_GSR))=0;
            %     disp(strcat(tiffFileName,'xform_datahb_bandpass_GSR has NAN'));
            % end
            %
            %
            %
            
            
            oxy_noGSR = double(squeeze(xform_datahb_bandpass(:,:,1,:)));
            deoxy_noGSR = double(squeeze(xform_datahb_bandpass(:,:,2,:)));
            clear xform_datahb_bandpass
            total_noGSR = double(oxy_noGSR+deoxy_noGSR);
            
            oxy_GSR = double(squeeze(xform_datahb_GSR(:,:,1,:)));
            deoxy_GSR = double(squeeze(xform_datahb_GSR(:,:,2,:)));
            clear xform_datahb_GSR
            total_GSR = double(oxy_GSR+deoxy_GSR);
            
            clear xform_datahb_bandpass xform_datahb_GSR
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = double(squeeze(xform_gcamp_GSR(:,:,1,:)));
                gcampCorr = double(squeeze(xform_gcampCorr_GSR(:,:,1,:)));
                green = double(squeeze(xform_green_GSR(:,:,1,:)));
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a_GSR = double(squeeze(xform_jrgeco1a_GSR(:,:,1,:)));
                jrgeco1aCorr_GSR = double(squeeze(xform_jrgeco1aCorr_GSR(:,:,1,:)));
                red_GSR = double(squeeze(xform_red_GSR(:,:,1,:)));
                
                jrgeco1a_noGSR = double(squeeze(xform_jrgeco1a_bandpass(:,:,1,:)));
                jrgeco1aCorr_noGSR = double(squeeze(xform_jrgeco1aCorr_bandpass(:,:,1,:)));
                red_noGSR = double(squeeze(xform_red_bandpass(:,:,1,:)));
                clear xform_jrgeco1a_bandpass xform_jrgeco1aCorr_bandpass xform_jrgeco1a_GSR xform_jrgeco1aCorr_GSR
            end
            
            
            xform_isbrain = double(xform_isbrain);
            
            oxy_GSR = oxy_GSR.*xform_isbrain;
            deoxy_GSR = deoxy_GSR.*xform_isbrain;
            total_GSR = total_GSR .*xform_isbrain;
            
            oxy_GSR(isnan(oxy_GSR)) = 0;
            deoxy_GSR(isnan(deoxy_GSR)) = 0;
            total_GSR(isnan(total_GSR)) = 0;
            
            oxy_noGSR = oxy_noGSR.*xform_isbrain;
            deoxy_noGSR = deoxy_noGSR.*xform_isbrain;
            total_noGSR = total_noGSR .*xform_isbrain;
            
            oxy_noGSR(isnan(oxy_noGSR)) = 0;
            deoxy_noGSR(isnan(deoxy_noGSR)) = 0;
            total_noGSR(isnan(total_noGSR)) = 0;
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = gcamp.*xform_isbrain;
                gcampCorr = gcampCorr.*xform_isbrain;
                green = green.*xform_isbrain;
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a_GSR = jrgeco1a_GSR.*xform_isbrain;
                jrgeco1aCorr_GSR = jrgeco1aCorr_GSR.*xform_isbrain;
                red_GSR = red_GSR.*xform_isbrain;
                
                jrgeco1a_noGSR = jrgeco1a_noGSR.*xform_isbrain;
                jrgeco1aCorr_noGSR = jrgeco1aCorr_noGSR.*xform_isbrain;
                red_noGSR = red_noGSR.*xform_isbrain;
            end
            
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            R=mod(size(oxy_noGSR,3),sessionInfo.stimblocksize);
            if R~=0
                pad=sessionInfo.stimblocksize-R;
                disp(strcat('** Non integer number of blocks presented. Padded ', num2str(n), ' with '," ", num2str(pad), ' zeros **'))
                oxy_GSR(:,:,end:end+pad)=0;
                deoxy_GSR(:,:,end:end+pad)=0;
                total_GSR(:,:,end:end+pad)=0;
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_GSR(:,:,end:end+pad)=0;
                    gcampCorr_GSR(:,:,end:end+pad)=0;
                    green_GSR(:,:,end:end+pad)=0;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_GSR(:,:,end:end+pad)=0;
                    jrgeco1aCorr_GSR(:,:,end:end+pad)=0;
                    red_GSR(:,:,end:end+pad)=0;
                end
                
                
                oxy_noGSR(:,:,end:end+pad)=0;
                deoxy_noGSR(:,:,end:end+pad)=0;
                total_noGSR(:,:,end:end+pad)=0;
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_noGSR(:,:,end:end+pad)=0;
                    gcampCorr_noGSR(:,:,end:end+pad)=0;
                    green_noGSR(:,:,end:end+pad)=0;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_noGSR(:,:,end:end+pad)=0;
                    jrgeco1aCorr_noGSR(:,:,end:end+pad)=0;
                    red_noGSR(:,:,end:end+pad)=0;
                end
                
            end
            
            oxy_GSR=reshape(oxy_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(oxy_GSR,4)
                MeanFrame=squeeze(mean(oxy_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(oxy_GSR, 3);
                    oxy_GSR(:,:,t,b)=squeeze(oxy_GSR(:,:,t,b))-MeanFrame;
                end
            end
            
            deoxy_GSR=reshape(deoxy_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(deoxy_GSR,4)
                MeanFrame=squeeze(mean(deoxy_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(deoxy_GSR, 3);
                    deoxy_GSR(:,:,t,b)=squeeze(deoxy_GSR(:,:,t,b))-MeanFrame;
                end
            end
            
            total_GSR=reshape(total_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(total_GSR,4)
                MeanFrame=squeeze(mean(total_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(total_GSR, 3);
                    total_GSR(:,:,t,b)=squeeze(total_GSR(:,:,t,b))-MeanFrame;
                end
            end
            
            oxy_noGSR=reshape(oxy_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(oxy_noGSR,4)
                MeanFrame=squeeze(mean(oxy_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(oxy_noGSR, 3);
                    oxy_noGSR(:,:,t,b)=squeeze(oxy_noGSR(:,:,t,b))-MeanFrame;
                end
            end
            
            deoxy_noGSR=reshape(deoxy_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(deoxy_noGSR,4)
                MeanFrame=squeeze(mean(deoxy_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(deoxy_noGSR, 3);
                    deoxy_noGSR(:,:,t,b)=squeeze(deoxy_noGSR(:,:,t,b))-MeanFrame;
                end
            end
            
            total_noGSR=reshape(total_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(total_noGSR,4)
                MeanFrame=squeeze(mean(total_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(total_noGSR, 3);
                    total_noGSR(:,:,t,b)=squeeze(total_noGSR(:,:,t,b))-MeanFrame;
                end
            end
            
            
            
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp=reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(gcamp,4)
                    MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(gcamp, 3);
                        gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                    end
                end
                
                gcampCorr=reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(gcampCorr,4)
                    MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(gcampCorr, 3);
                        gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
                    end
                end
                
                
                green=reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(green,4)
                    MeanFrame=squeeze(mean(green(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(green, 3);
                        green(:,:,t,b)=squeeze(green(:,:,t,b))-MeanFrame;
                    end
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a_noGSR=reshape(jrgeco1a_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1a_noGSR,4)
                    MeanFrame=squeeze(mean(jrgeco1a_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1a_noGSR, 3);
                        jrgeco1a_noGSR(:,:,t,b)=squeeze(jrgeco1a_noGSR(:,:,t,b))-MeanFrame;
                    end
                end
                jrgeco1aCorr_noGSR=reshape(jrgeco1aCorr_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1aCorr_noGSR,4)
                    MeanFrame=squeeze(mean(jrgeco1aCorr_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1aCorr_noGSR, 3);
                        jrgeco1aCorr_noGSR(:,:,t,b)=squeeze(jrgeco1aCorr_noGSR(:,:,t,b))-MeanFrame;
                    end
                end
                red_noGSR=reshape(red_noGSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(red_noGSR,4)
                    MeanFrame=squeeze(mean(red_noGSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(red_noGSR, 3);
                        red_noGSR(:,:,t,b)=squeeze(red_noGSR(:,:,t,b))-MeanFrame;
                    end
                end
                
                
                
                
                jrgeco1a_GSR=reshape(jrgeco1a_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1a_GSR,4)
                    MeanFrame=squeeze(mean(jrgeco1a_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1a_GSR, 3);
                        jrgeco1a_GSR(:,:,t,b)=squeeze(jrgeco1a_GSR(:,:,t,b))-MeanFrame;
                    end
                end
                jrgeco1aCorr_GSR=reshape(jrgeco1aCorr_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1aCorr_GSR,4)
                    MeanFrame=squeeze(mean(jrgeco1aCorr_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1aCorr_GSR, 3);
                        jrgeco1aCorr_GSR(:,:,t,b)=squeeze(jrgeco1aCorr_GSR(:,:,t,b))-MeanFrame;
                    end
                end
                red_GSR=reshape(red_GSR,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(red_GSR,4)
                    MeanFrame=squeeze(mean(red_GSR(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(red_GSR, 3);
                        red_GSR(:,:,t,b)=squeeze(red_GSR(:,:,t,b))-MeanFrame;
                    end
                end
                
            end
           
            
            
            
            % Block Average
            texttitle_GSR = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(n)," ",'with GSR');
            output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_GSR'));
            
            
            texttitle_noGSR = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(n)," ",'without GSR');
            output_noGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_noGSR'));
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                
                fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
                
                close all
                
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
                load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
                fluor.traceImagePlot_rgeco(oxy_GSR,deoxy_GSR,total_GSR,jrgeco1a_GSR,jrgeco1aCorr_GSR,red_GSR,info,sessionInfo,output_GSR,texttitle_GSR,xform_isbrain)
                fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
                close all
            elseif strcmp(char(sessionInfo.mouseType),'WT')
                maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
                load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
                fluor.traceImagePlot_WT(oxy_GSR,deoxy_GSR,total_GSR,info,sessionInfo,output_GSR,texttitle_GSR)
                clear oxy_GSR deoxy_GSR total_GSR
                fluor.traceImagePlot_WT_noGSR(oxy_noGSR,deoxy_noGSR,total_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR)
                clear oxy_noGSR deoxy_noGSR total_noGSR
            end
        end
    end
end







