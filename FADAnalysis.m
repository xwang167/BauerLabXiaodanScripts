
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = [ 182 184 186];

runs =1:3;
isDetrend = 1;

%%process

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    oriDir = "C:\Users\xiaodanwang\Documents";
    oriDir =  fullfile(oriDir,recDate);
    
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
    
    
    
    if strcmp(char(sessionInfo.mouseType),'WT')
        sessionInfo.hbSpecies = 1:2;
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        sessionInfo.hbSpecies = 2:3;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 2;
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission_TwoCamFilter.txt";
        
        sessionInfo.FADspecies = 1;
        sessionInfo.FADEmissionFile = "fad_emission.txt";
        
    end
    
    
    
    
    
    
    systemInfo.numLEDs = 4;
    systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_TL625_Pol.txt"];
    
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    
    
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers')
    
    
    pkgDir = what('bauerParams');
    
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    sessionInfo.FADEmissionFile = fullfile(fluorDir,sessionInfo.FADEmissionFile);
    
    for n = runs
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        disp('loading raw data')
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        
        load(fullfile(saveDir,rawName),'rawdata')
        
        if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
            sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
        end
        
        
        
        
        
        maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataHb','.mat')),'xform_isbrain');
        load(fullfile(maskDir,maskName), 'affineMarkers','isbrain')
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        %QCcheck_raw(rawdata(:,:,:,sessionInfo.darkFrameNum/systemInfo.numLEDs+2:end),isbrain,systemType,sessionInfo.framerate,saveDir,visName)
        
        disp('preprocess raw and tranform raw');
        
        % detrend raw
        if sessionInfo.darkFrameNum ==0
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
            %                 raw_detrend = process.temporalDetrend(rawdata,true);
            raw_detrend = temporalDetrendAdam(rawdata);
        end
        % affine transform
        
        
        xform_raw = process.affineTransform(raw_detrend,affineMarkers);
        clear raw_detrend
        xform_raw(isnan(xform_raw)) = 0;
        disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
        
        xform_isbrain(isnan(xform_isbrain)) = 0;
        xform_isbrain = logical(xform_isbrain);
        
        BaselineFunction  = @(x) mean(x,numel(size(x)));
        baselineValues = BaselineFunction(xform_raw);
        
        disp('load previously processed datahb')
        load(fullfile(oriDir,processedName),'xform_datahb')
        
        if ~strcmp(char(sessionInfo.mouseType),'WT')
            
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                
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
                    xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
                    [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
                    
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
                    clear xform_raw
                    xform_gcamp = process.smoothImage(xform_gcamp,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    
                    baseline = nanmean(xform_green,3);
                    xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
                    xform_green = xform_green - 1;
                    xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    
                    
                    save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','op_in', 'E_in','op_out', 'E_out','-append')
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                
                C = who('-file',fullfile(saveDir,processedName));
                isFluorGot = false;
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
                    
                    
                    [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(2));
                    [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
                    
                    
                    dpIn = op_in.dpf/2;
                    dpOut = op_out.dpf/2;
                    
                    %             dpIn = 0.056;
                    %             dpOut = 0.057;
                    xform_jrgeco1a = xform_fluor ;
                    xform_jrgeco1aCorr = mouse.physics.correctHb(xform_jrgeco1a,xform_datahb,...
                        [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                    xform_red = squeeze(xform_raw(:,:,4,:));
                    clear xform_raw
                    xform_jrgeco1a = process.smoothImage(xform_jrgeco1a,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    xform_jrgeco1aCorr = process.smoothImage(xform_jrgeco1aCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    
                    baseline = nanmean(xform_red,3);
                    xform_red = xform_red./repmat(baseline,[1 1 size(xform_red,3)]); % make the data ratiometric
                    xform_red = xform_red - 1;
                    xform_red = process.smoothImage(xform_red,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                    
                    save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','-append')
                    
                    
                    
                    disp('correct FAD')
                    xform_FAD = squeeze(xform_raw(:,:,sessionInfo.FADspecies,:));
                    
                    baseline = nanmean(xform_FAD,3);
                    xform_FAD = xform_FAD./repmat(baseline,[1 1 size(xform_FAD,3)]); % make the data ratiometric
                    xform_FAD = xform_FAD - 1; % make the data change from baseline (center at zero)
                    
                    
                    [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
                    [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,sessionInfo.FADEmissionFile);
                    
                    
                    dpIn_FAD = op_in_FAD.dpf/2;
                    dpOut_FAD = op_out_FAD.dpf/2;
                    
                    
                    xform_FADCorr = mouse.physics.correctHb(xform_FAD,xform_datahb,...
                        [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
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
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    load(fullfile(maskDir,maskName), 'isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata')
        disp(strcat('QC raw for ',rawName))
        %QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName)
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
            
            disp(char(['QC check on ', processedName]))
            QCcheck_fc_twoFluor(double(xform_FADCorr),double(squeeze(xform_jrgeco1aCorr)),'FADCorr','jrgeco1aCorr','g','m',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaF/F)','(\DeltaF/F)');
            close all
            QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_jrgeco1aCorr)),'oxy','jrgeco1aCorr','r','m',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
            close all
            clear xform_FADCorr xform_jrgeco1aCorr
            
        elseif strcmp(sessionType,'stim')
            
            load('D:\OIS_Process\noVasculatureMask.mat')
            
            xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            stimStartTime = 5;
            info.freqout=1;
            disp('loading Non GRS data')
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green')
            numBlock = size(xform_green,3)/sessionInfo.stimblocksize;
            
            
            numDesample = size(xform_green,3)/sessionInfo.framerate*info.freqout;
            factor = round(numDesample/numBlock);
            numDesample = factor*numBlock;
            
            texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
            output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
            disp('QC on non GSR stim')
            [goodBlocks_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                xform_FAD,xform_FADCorr,xform_green,xform_jrgeco1a,xform_jrgeco1aCorr,xform_red,...
                xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR);
            
            clear xform_datahb xform_jrgeco1a xform_jrgeco1aCorr xform_red
            
            disp('loading GRS data')
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR')
            xform_FAD_GSR = mouse.process.gsr(xform_FAD,xform_isbrain);
            clear xform_FAD
            xform_FADCorr_GSR = mouse.process.gsr(xform_FADCorr,xform_isbrain);
            clear xform_FADCorr
            xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
            clear xform_green
            disp('saving FAD related data')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
            
            
            
            texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
            output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
            disp('QC on GSR stim')
            [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                xform_FAD_GSR,xform_FADCorr_GSR,xform_green_GSR,xform_jrgeco1a_GSR,xform_jrgeco1aCorr_GSR,xform_red_GSR,...
                xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','-append')
            
            
        end
        
        
        
        
        close all
        
    end
end


































