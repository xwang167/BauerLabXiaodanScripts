
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = [228 230 232 234];

runs =1:3;
isDetrend = 1;
nVy = 128;
nVx = 128;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    systemType = excelRaw{5};
    
    
    wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    if exist(fullfile(saveDir,wlName),'file')
        disp(strcat('WL and transform file already exists for ', recDate,'-', mouseName))
        load(fullfile(saveDir,wlName),'transformMat','WL');
    else
        disp(strcat('get WL and transform for ', recDate,'-', mouseName))
        
        fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,'1-cam1.mat');
        fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
        load(fileName_cam1)
        
        if strcmp(sessionInfo.mouseType,'jrgeco1a')|| strcmp(sessionInfo.mouseType,'WT')||strcmp(sessionInfo.mouseType,'PV')
            firtFrame_cam1  = squeeze(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/4+1));
        elseif strcmp(sessionInfo.mouseType,'gcamp6f')
            firtFrame_cam1  = squeeze(raw_unregistered(:,:,2,sessionInfo.darkFrameNum/4+1));
        end
        clear raw_unregistered
        fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,'1-cam2.mat');
        fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
        load(fileName_cam2)
        if strcmp(sessionInfo.mouseType,'jrgeco1a')
            firtFrame_cam2  = squeeze(raw_unregistered(:,:,2,sessionInfo.darkFrameNum/4+1));
        elseif strcmp(sessionInfo.mouseType,'gcamp6f')|| strcmp(sessionInfo.mouseType,'WT')||strcmp(sessionInfo.mouseType,'PV')
            firtFrame_cam2  = squeeze(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/4+1));
        end
        
        clear raw_unregistered
        [WL,transformMat] = fluor.getTransformationandWL_Zyla(firtFrame_cam1, firtFrame_cam2,nVy,nVx);
        save(fullfile(saveDir,wlName),'transformMat','WL');
        close all
        
        
        
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
        % need to be modified to see if WL exist
        
        disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
        [isbrain,xform_isbrain,affineMarkers,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
        isbrain_contour = bwperim(isbrain);
        save(fullfile(saveDir,maskName),'isbrain', 'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'affineMarkers', 'seedcenter','-append')
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
        plot(affineMarkers.tent(1,1),affineMarkers.tent(1,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(affineMarkers.bregma(1,1),affineMarkers.bregma(1,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(affineMarkers.OF(1,1),affineMarkers.OF(1,2),'ko','MarkerFaceColor','b')
        hold on;
        contour(isbrain_contour,'r')
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
        
        
        
        clearvars -except excelFile nVx nVy excelRows runs isDetrend
    end
end

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};
    
    
    
    if strcmp(char(sessionInfo.mouseType),'WT')||strcmp(char(sessionInfo.mouseType),'PV')
        sessionInfo.hbSpecies = 1:2;
        
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 2;
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
        
        sessionInfo.FADspecies = 1;
        sessionInfo.FADEmissionFile = "fad_emission.txt";
        
    end
    
    
    
    
    
    if strcmp(systemType,'EastOIS2_OneCam')
        systemInfo.numLEDs = 3;
        systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt", ...
            "TwoCam_TL625_Pol.txt"];
    elseif strcmp(systemType,'EastOIS2')
        
        if strcmp(sessionInfo.mouseType,'PV')
            systemInfo.numLEDs = 2;
            systemInfo.LEDFiles = [
                "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
                "TwoCam_TL625_Pol_Longer593.txt"];
            
        else
            systemInfo.numLEDs = 4;
            systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
                "TwoCam_Mightex525_BP_Pol.txt", ...
                "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
                "TwoCam_TL625_Pol_Longer593.txt"];
        end
        
    end
    
    
    
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    maskDir = saveDir;
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    
    
    pkgDir = what('bauerParams');
    
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    
    for n = runs
        
        
        
        disp('loading raw data')
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if ~exist(fullfile(saveDir,processedName))
            disp('loading raw data')
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            if exist(fullfile(saveDir,rawName),'file')
                disp(strcat('combined file already exist for ',rawName ))
                load(fullfile(saveDir,rawName),'rawdata')
            else
                wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
                load(fullfile(maskDir,wlName),'transformMat');
                disp(strcat('Register and Combine two cameras for ', rawName))
                fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
                fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
                fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
                fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
                load(fileName_cam1)
                binnedRaw_cam1 = raw_unregistered;
                clear raw_unregistered
                load(fileName_cam2)
                binnedRaw_cam2 = raw_unregistered;
                clear raw_unregistered
                rawdata = fluor.registerCam2andCombineTwoCams_v3(binnedRaw_cam1,binnedRaw_cam2,transformMat,sessionInfo.mouseType);
                disp(strcat('QC raw for ',rawName))
                visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
                QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
                
                save(fullfile(saveDir,rawName),'rawdata','-v7.3')
                
            end
            if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
                sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
            end
        else
            load(fullfile(saveDir,rawName),'rawdata')
        end
        
        
        
        
        if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
            sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
        end
        
        
        
        
        %
        disp('preprocess raw and tranform raw');

        if strcmp(sessionInfo.mouseType,'PV')
        elseif sessionInfo.darkFrameNum ==0
            raw_nondark =rawdata;
            darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
            darkName =  fullfile(rawdataloc,recDate,darkName);
            load(darkName)
            darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
            clear rawdata
            raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
            clear raw_baselineMinus
            rawdata = raw_baselineMinus;
        else
            darkFrameInd = 2:sessionInfo.darkFrameNum/systemInfo.numLEDs;
            darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
            raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
            clear rawdata
            raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/systemInfo.numLEDs)=[];
            rawdata = raw_baselineMinus;
            clear raw_baselineMinus
            
            
        end
        
        if strcmp(sessionType,'stim')
            rawdata(:,:,:,1) = rawdata(:,:,:,2);
        elseif strcmp(sessionType,'fc')
            rawdata(:,:,:,1) = [];
        end
        if isDetrend
            %raw_detrend = process.temporalDetrend(rawdata,true);
            raw_detrend = temporalDetrendAdam(rawdata);
        end
        %affine transform
        
       if  strcmp(systemType,'EastOIS2')
                   raw_detrend = process.smoothImage(raw_detrend,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        
       end
        xform_raw = process.affineTransform(raw_detrend,affineMarkers);
        clear raw_detrend
        xform_raw(isnan(xform_raw)) = 0;
        disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
        
        xform_isbrain(isnan(xform_isbrain)) = 0;
        xform_isbrain = logical(xform_isbrain);
        
        
        
        [op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
%         %
%         [op, E] = getHbOpticalProperties_hillman(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
%         %%
        
        BaselineFunction  = @(x) mean(x,numel(size(x)));
        baselineValues = BaselineFunction(xform_raw);
        xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);
        xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        
        save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E','-v7.3')
        
        
        if strcmp(char(sessionInfo.mouseType),'WT')||strcmp(char(sessionInfo.mouseType),'PV')
            
            
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
            C = who('-file',fullfile(saveDir,processedName));
            isFluorGot = false;
            for  k=1:length(C)
                if strcmp(C(k),'xform_gcamp')
                    isFluorGot = true;
                end
            end
            if ~isFluorGot
                disp('correct gcamp')
                xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
                xform_gcamp = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
                clear xform_fluor
                [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
                
                
%                 
%                 %%%
%                 [op_in, E_in] = getHbOpticalProperties_hillman(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies )));
%                 [op_out, E_out] = getHbOpticalProperties_hillman(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
%                 %%%
                
                
                dpIn = op_in.dpf/2;
                dpOut = op_out.dpf/2;
                
                
                xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
                    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                xform_green = squeeze(xform_raw(:,:,2,:));
                clear xform_raw
                xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                baseline = nanmean(xform_green,3);
                xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
                xform_green = xform_green - 1;
                xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                
                save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','op_in', 'E_in','op_out', 'E_out','-append','-v7.3')
                clear xform_gcamp xform_gcampCorr xform_green
            end
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            isFluorGot = false;
            C = who('-file',fullfile(saveDir,processedName));
            
            for  k=1:length(C)
                if strcmp(C(k),'xform_jrgeco1a')
                    isFluorGot = true;
                end
            end
            if ~isFluorGot
                disp('correct jrgeco1a')
                xform_fluor = xform_raw(:,:,sessionInfo.fluorSpecies,:);
                xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
                [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
                
                
                [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(2)));
                [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
                
                dpIn = op_in.dpf/2;
                dpOut = op_out.dpf/2;
                
                
                xform_jrgeco1a = xform_fluor ;
                xform_jrgeco1aCorr = mouse.physics.correctHb(xform_jrgeco1a,xform_datahb,...
                    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                xform_red = squeeze(xform_raw(:,:,4,:));
                
                xform_jrgeco1a = process.smoothImage(xform_jrgeco1a,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                xform_jrgeco1aCorr = process.smoothImage(xform_jrgeco1aCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                baseline = nanmean(xform_red,3);
                xform_red = xform_red./repmat(baseline,[1 1 size(xform_red,3)]); % make the data ratiometric
                xform_red = xform_red - 1;
                xform_red = process.smoothImage(xform_red,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','-append','-v7.3')
                clear xform_jrgeco1a xform_jrgeco1aCorr xform_red
                disp('correct FAD')
                xform_FAD = squeeze(xform_raw(:,:,sessionInfo.FADspecies,:));
                
                baseline = nanmean(xform_FAD,3);
                xform_FAD = xform_FAD./repmat(baseline,[1 1 size(xform_FAD,3)]); % make the data ratiometric
                xform_FAD = xform_FAD - 1; % make the data change from baseline (center at zero)
                
                
                [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
                [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'probeSpectra',sessionInfo.FADEmissionFile));
                
                dpIn_FAD = op_in_FAD.dpf/2;
                dpOut_FAD = op_out_FAD.dpf/2;
                
                
                xform_FADCorr = mouse.physics.correctHb(xform_FAD,xform_datahb,...
                    [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
                clear xform_datahb
                xform_green = squeeze(xform_raw(:,:,3,:));
                clear xform_raw
                xform_FAD = process.smoothImage(xform_FAD,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                xform_FADCorr = process.smoothImage(xform_FADCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                baseline = nanmean(xform_green,3);
                xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
                xform_green = xform_green - 1;
                xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                
                save(fullfile(saveDir, processedName),'xform_FAD','xform_FADCorr','xform_green',...
                    'op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','-append')
            else
                disp(strcat('jrgeco1a data already processed for ',processedName))
            end
        end
        
        
        
    end
    clearvars -except excelFile excelRows runs isDetrend
end





for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir = saveDir;
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(maskDir,maskName), 'xform_isbrain','affineMarkers')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        %         load(fullfile(saveDir,rawName),'rawdata')
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb')
        for ii = 1:size(xform_datahb,4)
            xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
            xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
        end
        save(fullfile(maskDir,maskName), 'xform_isbrain','-append')
        
        
        if strcmp(sessionType,'fc')
            disp(char(['fc QC check on ', processedName]))
            
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                
                load(fullfile(saveDir,processedName),'xform_gcampCorr')
                
                QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r-','g-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                close all
                clear xform_gcampCorr xform_datahb
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
                
                QCcheck_fc_twoFluor(double(xform_FADCorr),double(squeeze(xform_jrgeco1aCorr)),'FADCorr','jrgeco1aCorr','g-','m-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaF/F)','(\DeltaF/F)');
                close all
                QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_jrgeco1aCorr)),'oxy','jrgeco1aCorr','r-','m-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                close all
                
                
                clear xform_FADCorr xform_jrgeco1aCorr xform_datahb
            end
            
        elseif strcmp(sessionType,'stim')
            xform_datahb(isinf(xform_datahb)) = 0;
            xform_datahb(isnan(xform_datahb)) = 0;
            %             load('D:\OIS_Process\noVasculatureMask.mat')
            %
            %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            stimStartTime = 5;
            info.freqout=1;
            disp('loading Non GRS data')
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','xform_datahb')
            elseif strcmp(sessionInfo.mouseType,'PV')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'.mat')))
                peakMap_ROI= process.affineTransform(rawdata(:,:,3,sessionInfo.stimbaseline+1),affineMarkers) ;
                clear rawdata
                imagesc(peakMap_ROI)
                axis image off
                colormap jet
                
                hold on
                load('D:\OIS_Process\atlas.mat','AtlasSeeds')
                barrel = AtlasSeeds == 9;
                ROI_barrel =  bwperim(barrel);
                
                
                contour(ROI_barrel,'k')
                
                [x1,y1] = ginput(1);
                [x2,y2] = ginput(1);
                [X,Y] = meshgrid(1:128,1:128);
                radius = sqrt((x1-x2)^2+(y1-y2)^2);
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                max_ROI = prctile(peakMap_ROI(ROI),99);
                temp = peakMap_ROI.*ROI;
                ROI = temp>max_ROI*0.30;
                hold on
                ROI_contour = bwperim(ROI);
                contour( ROI_contour,'k');
                
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
            end
            
            numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            
            numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
            factor = round(numDesample/numBlock);
            numDesample = factor*numBlock;
            
            texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
            output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
            disp('QC on non GSR stim')
            
            
            
            
            
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                    xform_gcamp,xform_gcampCorr,xform_green,[],[],[],...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                    xform_FAD,xform_FADCorr,xform_green,xform_jrgeco1a,xform_jrgeco1aCorr,xform_red,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
            elseif strcmp(sessionInfo.mouseType,'PV')
                xform_datahb =  mouse.freq.lowpass(xform_datahb,0.5,sessionInfo.framerate);
                [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                    [],[],[],[],[],[],...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
            end
            close all
            
            
            disp('loading GRS data')
            
            texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
            output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
            
            xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
            clear xform_datahb
            
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                xform_gcamp_GSR = mouse.process.gsr(xform_gcamp,xform_isbrain);
                clear xform_FAD
                xform_gcampCorr_GSR = mouse.process.gsr(xform_gcampCorr,xform_isbrain);
                clear xform_FADCorr
                xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
                clear xform_green
                disp('saving gcamp related data')
                
                disp('QC on GSR stim')
                [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                    xform_gcamp_GSR,xform_gcampCorr_GSR,xform_green_GSR,[],[],[],...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_NoGSR);
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_NoGSR','goodBlocks_GSR','ROI_NoGSR','-append')
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
                clear xform_jrgeco1a
                xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
                clear xform_jrgeco1aCorr
                xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
                clear xform_red
                
                xform_FAD_GSR = mouse.process.gsr(xform_FAD,xform_isbrain);
                clear xform_FAD
                xform_FADCorr_GSR = mouse.process.gsr(xform_FADCorr,xform_isbrain);
                clear xform_FADCorr
                xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
                clear xform_green
                disp('saving FAD related data')
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','goodBlocks_NoGSR','goodBlocks_GSR','ROI_NoGSR','-append')
                
                
                disp('QC on GSR stim')
                [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                    xform_FAD_GSR,xform_FADCorr_GSR,xform_green_GSR,xform_jrgeco1a_GSR,xform_jrgeco1aCorr_GSR,xform_red_GSR,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR);
            else
                [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                    [],[],[],[],[],[],...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI);
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','ROI_NoGSR','ROI','xform_datahb_GSR','-append')
                
                
            end
            close all
            
        end
        
    end
end


































