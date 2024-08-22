
close all;clearvars;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;
%
excelRows =180;

runs =1:3;

% for ii = 0:1
isDetrend = true;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionInfo.mouseType = excelRaw{13};
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    if exist(fullfile(saveDir,maskName))
        disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
        load(fullfile(saveDir,maskName), 'isbrain',  'I')
    else
        if strcmp(systemType,'EastOIS2')
            fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,'1.mat');
            fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
            load(fileName_cam1)
            
            if strcmp(char(sessionInfo.mouseType),'WT')
                sessionInfo.hbSpecies = 1:2;
                systemInfo.numLEDs = 2;
            elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
                sessionInfo.hbSpecies = 2:3;
                sessionInfo.fluorSpecies = 1;
                sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
                sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
                sessionInfo.darkFrameNum = excelRaw{11};
                systemInfo.numLEDs = 3;
            end
            
            
            WL = zeros(128,128,3);
            
            if strcmp(char(sessionInfo.mouseType),'WT')
                WL(:,:,1) = rawdata(:,:,sessionInfo.hbSpecies(2),1)/max(max( squeeze(rawdata(:,:,sessionInfo.hbSpecies(2),1))));
                WL(:,:,2) = rawdata(:,:,sessionInfo.hbSpecies(1),1)/max(max( squeeze(rawdata(:,:,sessionInfo.hbSpecies(1),1))));
            elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
                darkNum= sessionInfo.darkFrameNum/systemInfo.numLEDs;
                WL(:,:,1) = rawdata(:,:,sessionInfo.hbSpecies(2),1+darkNum)/max(max( squeeze(rawdata(:,:,sessionInfo.hbSpecies(2),1+darkNum))));
                WL(:,:,2) = rawdata(:,:,sessionInfo.hbSpecies(1),1+darkNum)/max(max( squeeze(rawdata(:,:,sessionInfo.hbSpecies(1),1+darkNum))));
            end
            
        elseif strcmp(systemType,'EastOIS1_Fluor')||strcmp(systemType,'EastOIS1')
            systemInfo.numLEDs = 4;
            filename = char(fullfile(rawdataloc,recDate,strcat(recDate,'-',mouseName,'-',sessionType,'3.tif')));
            sessionInfo.darkFrameNum = excelRaw{11};
            wl = zeros(128,128,3);
            wl(:,:,1)= read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+4);
            wl(:,:,2) = read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+3);
            wl(:,:,3) = read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+2);
            WL = zeros(128,128,3);
            WL(:,:,1) = wl(:,:,1)./max(max(wl(:,:,1)));
            WL(:,:,2) = wl(:,:,2)./max(max(wl(:,:,2)));
            WL(:,:,3) = wl(:,:,3)./max(max(wl(:,:,3)));
        end        
        disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
        [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
        isbrain_contour = bwperim(isbrain);
        save(fullfile(saveDir,maskName),'isbrain',  'I' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter')
        figure('units','normalized','outerposition',[0 0 1 1]);
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
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
        close all
        
    end
    clearvars -except excelFile nVx nVy excelRows runs isDetrend
end



% Process raw data to get xform_datahb and xform_fluor(if needed)


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionInfo.mouseType = excelRaw{13};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    
    sessionInfo.mouseType = excelRaw{13};
    sessionInfo.totalFrameNum = excelRaw{18};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = false;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};
    
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    systemInfo.invalidFrameInd = [];
    if strcmp(systemType,'EastOIS2')
        systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt", ...
            "TwoCam_TL625_Pol.txt"];
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            
            sessionInfo.hbSpecies = 1:2;
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.hbSpecies = 2:3;
            sessionInfo.fluorSpecies = 1;
            sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
            sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 3;
        end
        
    elseif strcmp(systemType,'EastOIS1_Fluor')
        
        sessionInfo.hbSpecies = 2:4;
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            systemInfo.LEDFiles = {'M470nm_SPF_pol.txt', ...
                'TL_530nm_515LPF_Pol.txt', ...
                'East3410OIS1_TL_617_Pol.txt', ...
                'East3410OIS1_TL_625_Pol.txt'};
            sessionInfo.fluorSpecies = 1;
            sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
            sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 4;
        end
    elseif strcmp(systemType,'EastOIS1')
        
        sessionInfo.hbSpecies = 1:4;
        systemInfo.LEDFiles = {'East3410OIS1_TL_470_Pol.txt', ...
            'East3410OIS1_TL_590_Pol.txt', ...
            'East3410OIS1_TL_617_Pol.txt', ...
            'East3410OIS1_TL_625_Pol.txt'};
        sessionInfo.darkFrameNum = 0;
        systemInfo.invalidFrameInd = 1;
        systemInfo.numLEDs = 4;
    end
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName),'I')
    
    
    pkgDir = what('bauerParams');
    ledDir = fullfile(pkgDir.path,'ledSpectra');
    for ind = 1:numel(systemInfo.LEDFiles)
        systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
    end
    
    for n = runs
        if isDetrend
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        else
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
        end
        tiffFileName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
        tiffFileName = fullfile(rawdataloc,recDate,tiffFileName);
        if ~exist(fullfile(saveDir,processedName),'file')
            %%need code to skip empty and _1 run
            disp('loading raw data')
            if strcmp(systemType,'EastOIS2')
                fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
                
                load(fileName_cam1)
            elseif strcmp(systemType,'EastOIS1_Fluor')||strcmp(systemType,'EastOIS1')
                rawDataMatName = fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),".mat"));
                
                if exist(rawDataMatName,'file')
                    
                    load(rawDataMatName,'rawdata')
                else
                    rawdata = double(readtiff(char(tiffFileName)));
                    rawdata = reshape(rawdata,nVy,nVx,systemInfo.numLEDs,[]);
                    save(rawDataMatName,'rawdata','-v7.3')
                end
                
            end
            
            disp('preprocess raw and tranform raw');
            
            load(fullfile(saveDir,maskName), 'xform_isbrain','I','isbrain')
            
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
            QCcheck_raw(rawdata(:,:,:,sessionInfo.darkFrameNum/systemInfo.numLEDs+2:end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
            
            % detrend raw
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                sessionInfo.darkFrameNum = excelRaw{11};
                if sessionInfo.darkFrameNum ==0
                    raw_nondark =rawdata;
                    darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
                    darkName =  fullfile(rawdataloc,recDate,darkName);
                    load(darkName)
                    darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
                    raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
                    rawdata = raw_baselineMinus;
                else
                    darkFrameInd = 2:sessionInfo.darkFrameNum/systemInfo.numLEDs;
                    darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
                    raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
                    raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/systemInfo.numLEDs)=[];
                    rawdata = raw_baselineMinus;
                    
                end
            end
            if strcmp(sessionType,'stim')
                rawdata(:,:,:,1) = rawdata(:,:,:,2);
            elseif strcmp(sessionType,'fc')
                rawdata(:,:,:,1) = [];
            end
            if isDetrend
                %                 raw_detrend = process.temporalDetrend(rawdata,true);
                raw_detrend = temporalDetrendAdam(rawdata);
            end
            % affine transform
            %             invalidFrames = [94:165,1363:1483,3180:3371,4083:4216,4373:4436,4764:4875,5950:5994];
            %             raw_detrend(:,:,:,invalidFrames) =[];
            
            xform_raw = process.affineTransform(raw_detrend,I);
            xform_raw(isnan(xform_raw)) = 0;
            disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
            maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
            
            
            xform_isbrain(isnan(xform_isbrain)) = 0;
            xform_isbrain = logical(xform_isbrain);
            
            [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(sessionInfo.hbSpecies));
            BaselineFunction  = @(x) mean(x,numel(size(x)));
            baselineValues = BaselineFunction(xform_raw);
            xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);
            xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
            
            save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E','-v7.3')
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                
                xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
                
                baseline = nanmean(xform_fluor,3);
                xform_fluor = xform_fluor./repmat(baseline,[1 1 size(xform_fluor,3)]); % make the data ratiometric
                xform_fluor = xform_fluor - 1; % make the data change from baseline (center at zero)
                
                
                [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
                [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
                
                
                dpIn = op_in.dpf/2;
                dpOut = op_out.dpf/2;
                
                
                xform_gcamp= xform_fluor ;
                xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
                    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                xform_green = squeeze(xform_raw(:,:,2,:));
                
                xform_gcamp = process.smoothImage(xform_gcamp,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                baseline = nanmean(xform_green,3);
                xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
                xform_green = xform_green - 1;
                xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                
                save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','op_in', 'E_in','op_out', 'E_out','-append')
            end
        else
            %
            disp(strcat('OIS data already processed for ',processedName))
        end
        
    end
    clearvars -except excelFile nVx nVy excelRows runs isDetrend
end




for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':T',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    if strcmp(systemType,'EastOIS2')
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 3;
        end
        
    elseif strcmp(systemType,'EastOIS1_Fluor')||strcmp(systemType,'EastOIS1')
        systemInfo.numLEDs = 4;
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.darkFrameNum = excelRaw{11};
            
        end
    end
    
    
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        output = fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
        if isDetrend
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        else
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
        end
        if exist(fullfile(saveDir, processedName),'file')
            disp('loading processed data')
            
            
            if strcmp(sessionType,'fc')&&exist(fullfile(saveDir, processedName),'file')
                load(fullfile(saveDir, processedName),'xform_datahb')
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    load(fullfile(saveDir, processedName),'xform_gcampCorr')
                    
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    
                    load(fullfile(saveDir, processedName),'xform_jrgeco1aCorr')
                end
                isQC = false;
                %             C = who('-file',fullfile(saveDir,processedName));
                %             for  k=1:length(C)
                %                 if strcmp(C(k),'fdata_total')
                %                     isQC= true;
                %                 end
                %             end
                if isQC
                    clear xform_datahb
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        
                        
                        clear xform_gcampCorr
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        
                        clear  xform_jrgeco1aCorr
                    end
                else
                    
                    disp(char(['QC check on ', processedName]))
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        
                        if isDetrend
                            QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_gcampCorr(:,:,:))),'gcamp6f',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),true);
                            
                            
                        else
                            QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_gcampCorr)),'gcamp6f',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_NoDetrend'),true);
                        end
                        
                        clear xform_datahb xform_gcampCorr
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        
                        
                        QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_jrgeco1aCorr)),'jrgeco1a',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),true);
                        clear xform_datahb xform_jrgeco1aCorr
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),[],[],xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),true);
                        
                    end
                end
            elseif strcmp(sessionType,'stim')
                load('D:\OIS_Process\noVasculatureMask.mat')
                
                %xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
                
                
                sessionInfo.stimblocksize = excelRaw{8};
                sessionInfo.stimbaseline=excelRaw{9};
                sessionInfo.stimduration = excelRaw{10};
                sessionInfo.stimFrequency = excelRaw{12};
                info.newFreq = 8;
                info.freqout=1;
                %info.bandtype = {"0.01Hz-8Hz",0.01,8};
                if ~isempty(excelRaw(20))
                    fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                    load(fullfile(rawdataloc,recDate,fileName_cam1));
                    startInd = sessionInfo.darkFrameNum/systemInfo.numLEDs/sessionInfo.framerate*excelRaw{20};
                    time = timeStamps(startInd+1:end);
                    darkTime = timeStamps(startInd);
                    input_stimbox = data(startInd+1:end);
                    time = time(1:end/4)-darkTime;
                    input_stimbox = input_stimbox(1:end/4);
                    [~,locs] = findpeaks(input_stimbox,'MinPeakHeight',4.5);
                    sessionInfo.stimbaseline = round(time(locs(1))*sessionInfo.framerate);
                end
                isGSR = false;
                C = who('-file',fullfile(saveDir,processedName));
                for  k=1:length(C)
                    if strcmp(C(k),'xform_datahb_GSR')
                        isGSR= true;
                    end
                end
                
                if isGSR
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR')
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        disp('loading GRS data')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR')
                    end
                else
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb')
                    %                 xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                    %                 xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                    %                 xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_datahb(isnan(xform_datahb))=0;
                    xform_datahb(isinf(xform_datahb))=0;
                    disp('gsr')
                    xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','-append')
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp','xform_gcampCorr','xform_green')
                        xform_gcamp(isnan(xform_gcamp))=0;
                        xform_gcampCorr(isnan(xform_gcampCorr)) = 0;
                        xform_green(isnan(xform_green))=0;
                        
                        xform_gcamp(isinf(xform_gcamp))=0;
                        xform_gcampCorr(isinf(xform_gcampCorr)) = 0;
                        xform_green(isinf(xform_green))=0;
                        
                        xform_gcamp_GSR = mouse.process.gsr(xform_gcamp,xform_isbrain);
                        clear xform_gcamp
                        xform_gcampCorr_GSR = mouse.process.gsr(xform_gcampCorr,xform_isbrain);
                        clear xform_gcampCorr
                        xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
                        clear xform_green
                        disp('saving')
                        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','-append')
                    end
                end
                
                
                oxy_GSR = double(squeeze(xform_datahb_GSR(:,:,1,:)));
                deoxy_GSR = double(squeeze(xform_datahb_GSR(:,:,2,:)));
                clear xform_datahb_GSR
                total_GSR = double(oxy_GSR+deoxy_GSR);
                
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_GSR = double(xform_gcamp_GSR);
                    clear xform_gcamp_GSR
                    gcampCorr_GSR = double(xform_gcampCorr_GSR);
                    clear xform_gcampCorr_GSR
                    green_GSR = double(xform_green_GSR);
                    clear xform_green_GSR
                end
                clear xform_datahb_bandpass xform_datahb_GSR
                xform_isbrain = double(xform_isbrain);
                
                oxy_GSR = oxy_GSR.*xform_isbrain;
                deoxy_GSR = deoxy_GSR.*xform_isbrain;
                total_GSR = total_GSR .*xform_isbrain;
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_GSR = gcamp_GSR.*xform_isbrain;
                    gcampCorr_GSR = gcampCorr_GSR.*xform_isbrain;
                    green_GSR = green_GSR.*xform_isbrain;
                end
                oxy_GSR(isnan(oxy_GSR)) = 0;
                deoxy_GSR(isnan(deoxy_GSR)) = 0;
                total_GSR(isnan(total_GSR)) = 0;
                
                
                
                R=mod(size(oxy_GSR,3),sessionInfo.stimblocksize);
                if R~=0
                    pad=sessionInfo.stimblocksize-R;
                    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                    oxy_GSR(:,:,end:end+pad)=0;
                    deoxy_GSR(:,:,end:end+pad)=0;
                    total_GSR(:,:,end:end+pad)=0;
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        gcamp_GSR(:,:,end:end+pad)=0;
                        gcampCorr_GSR(:,:,end:end+pad)=0;
                    end
                end
                
                
                %             oxy_GSR = reshape(oxy_GSR,128,128,[],10);
                %             deoxy_GSR = reshape(deoxy_GSR,128,128,[],10);
                %             total_GSR = reshape(total_GSR,128,128,[],10);
                
                
                % Block Average
                texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
                output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_GSR'));
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,~,~,~, gcampCorr_downsampled_GSR,gcamp_downsampled_GSR, temp_gcampCorr_max_GSR] = fluor.pickGoodBlocks(double(oxy_GSR),double(deoxy_GSR),double(total_GSR),info.freqout,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr',double(gcampCorr_GSR),'gcamp',double(gcamp_GSR));
                    
                elseif strcmp(char(sessionInfo.mouseType),'WT')
                    [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime] = fluor.pickGoodBlocks(oxy_GSR,deoxy_GSR,total_GSR,info.freqout,sessionInfo,output_GSR,texttitle_GSR);
                end
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','-append')
                
                if ~isempty(goodBlocks_GSR)
                    
                    %block average
                    oxy_blocks_downsampled = mean(oxy_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                    deoxy_blocks_downsampled = mean(deoxy_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                    total_blocks_downsampled = mean(total_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                    
                    
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        gcampCorr_blocks_downsampled = mean(gcampCorr_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                        gcamp_blocks_downsampled = mean(gcamp_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                    end
                    
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR);
                        
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime);
                    end
                    
                    
                    
                    numBlock = size(oxy_GSR,3)/sessionInfo.stimblocksize;
                    oxy_GSR = reshape(oxy_GSR,size(oxy_GSR,1),size(oxy_GSR,2),[],numBlock);
                    deoxy_GSR = reshape(deoxy_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
                    total_GSR = reshape(total_GSR,size(total_GSR,1),size(total_GSR,2),[],numBlock);
                    oxy_blocks_GSR = mean(oxy_GSR(:,:,:,goodBlocks_GSR),4);
                    deoxy_blocks_GSR = mean(deoxy_GSR(:,:,:,goodBlocks_GSR),4);
                    total_blocks_GSR = mean(total_GSR(:,:,:,goodBlocks_GSR),4);
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        gcampCorr_GSR = reshape(gcampCorr_GSR,size(oxy_GSR,1),size(oxy_GSR,2),[],numBlock);
                        gcamp_GSR = reshape(gcamp_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
                        green_GSR = reshape(green_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
                        gcampCorr_blocks_GSR = mean(gcampCorr_GSR(:,:,:,goodBlocks_GSR),4);
                        gcamp_blocks_GSR = mean(gcamp_GSR(:,:,:,goodBlocks_GSR),4);
                        green_blocks_GSR = mean(green_GSR(:,:,:,goodBlocks_GSR),4);
                        
                        if isempty(excelRaw(20))
                            fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain)
                        else
                            fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
                        end
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'ROI_total',ROI_total)
                    end
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb')
                    
                    %% No GSR
                    oxy_NoGSR = double(squeeze(xform_datahb(:,:,1,:)));
                    deoxy_NoGSR = double(squeeze(xform_datahb(:,:,2,:)));
                    clear xform_datahb
                    total_NoGSR = double(oxy_NoGSR+deoxy_NoGSR);
                    
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp','xform_gcampCorr','xform_green')
                        
                        gcamp_NoGSR = double(xform_gcamp);
                        clear xform_gcamp
                        gcampCorr_NoGSR = double(xform_gcampCorr);
                        clear xform_gcampCorr
                        green_NoGSR = double(xform_green);
                        clear xform_green
                    end
                    xform_isbrain = double(xform_isbrain);
                    
                    oxy_NoGSR = oxy_NoGSR.*xform_isbrain;
                    deoxy_NoGSR = deoxy_NoGSR.*xform_isbrain;
                    total_NoGSR = total_NoGSR .*xform_isbrain;
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        gcamp_NoGSR = gcamp_NoGSR.*xform_isbrain;
                        gcampCorr_NoGSR = gcampCorr_NoGSR.*xform_isbrain;
                        green_NoGSR = green_NoGSR.*xform_isbrain;
                    end
                    oxy_NoGSR(isnan(oxy_NoGSR)) = 0;
                    deoxy_NoGSR(isnan(deoxy_NoGSR)) = 0;
                    total_NoGSR(isnan(total_NoGSR)) = 0;
                    
                    
                    
                    R=mod(size(oxy_NoGSR,3),sessionInfo.stimblocksize);
                    if R~=0
                        pad=sessionInfo.stimblocksize-R;
                        disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                        oxy_NoGSR(:,:,end:end+pad)=0;
                        deoxy_NoGSR(:,:,end:end+pad)=0;
                        total_NoGSR(:,:,end:end+pad)=0;
                        
                        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                            gcamp_NoGSR(:,:,end:end+pad)=0;
                            gcampCorr_NoGSR(:,:,end:end+pad)=0;
                        end
                    end
                    
                    
                    %             oxy_NoGSR = reshape(oxy_NoGSR,128,128,[],10);
                    %             deoxy_NoGSR = reshape(deoxy_NoGSR,128,128,[],10);
                    %             total_NoGSR = reshape(total_NoGSR,128,128,[],10);
                    
                    
                    % Block Average
                    texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR');
                    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_NoGSR'));
                    
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,~,~,~, gcampCorr_downsampled_NoGSR,gcamp_downsampled_NoGSR, temp_gcampCorr_max_NoGSR] = fluor.pickGoodBlocks(double(oxy_NoGSR),double(deoxy_NoGSR),double(total_NoGSR),info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr',double(gcampCorr_NoGSR),'gcamp',double(gcamp_NoGSR));
                        
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime] = fluor.pickGoodBlocks(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR);
                    end
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_NoGSR','-append')
                    
                    if ~isempty(goodBlocks_NoGSR)
                        
                        %block average
                        oxy_blocks_downsampled = mean(oxy_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        deoxy_blocks_downsampled = mean(deoxy_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        total_blocks_downsampled = mean(total_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        
                        
                        
                        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                            gcampCorr_blocks_downsampled = mean(gcampCorr_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                            gcamp_blocks_downsampled = mean(gcamp_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        end
                        
                        
                        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR);
                            
                        elseif strcmp(char(sessionInfo.mouseType),'WT')
                            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime);
                        end
                        
                        
                        
                        numBlock = size(oxy_NoGSR,3)/sessionInfo.stimblocksize;
                        oxy_NoGSR = reshape(oxy_NoGSR,size(oxy_NoGSR,1),size(oxy_NoGSR,2),[],numBlock);
                        deoxy_NoGSR = reshape(deoxy_NoGSR,size(deoxy_NoGSR,1),size(deoxy_NoGSR,2),[],numBlock);
                        total_NoGSR = reshape(total_NoGSR,size(total_NoGSR,1),size(total_NoGSR,2),[],numBlock);
                        oxy_blocks_NoGSR = mean(oxy_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        deoxy_blocks_NoGSR = mean(deoxy_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        total_blocks_NoGSR = mean(total_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        
                        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                            gcampCorr_NoGSR = reshape(gcampCorr_NoGSR,size(oxy_NoGSR,1),size(oxy_NoGSR,2),[],numBlock);
                            gcamp_NoGSR = reshape(gcamp_NoGSR,size(deoxy_NoGSR,1),size(deoxy_NoGSR,2),[],numBlock);
                            green_NoGSR = reshape(green_NoGSR,size(deoxy_NoGSR,1),size(deoxy_NoGSR,2),[],numBlock);
                            gcampCorr_blocks_NoGSR = mean(gcampCorr_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                            gcamp_blocks_NoGSR = mean(gcamp_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                            green_blocks_NoGSR = mean(green_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                            
                            if isempty(excelRaw{20})
                                fluor.traceImagePlot(oxy_blocks_NoGSR,deoxy_blocks_NoGSR,total_blocks_NoGSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_blocks_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_NoGSR,'green_blocks',green_blocks_NoGSR,'xform_isbrain',xform_isbrain)
                            else
                                fluor.traceImagePlot(oxy_blocks_NoGSR,deoxy_blocks_NoGSR,total_blocks_NoGSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_blocks_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_NoGSR,'green_blocks',green_blocks_NoGSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
                            end
                            
                        elseif strcmp(char(sessionInfo.mouseType),'WT')
                            fluor.traceImagePlot(oxy_blocks_NoGSR,deoxy_blocks_NoGSR,total_blocks_NoGSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,ROI_total,sessionInfo,output_NoGSR,texttitle_NoGSR)
                        end
                    end
                    
                    close all
                end
            end
            close all
        end
        
        close all
    end
end
%


% end



