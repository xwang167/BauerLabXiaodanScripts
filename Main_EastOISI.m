
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = [140];

runs =2;
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
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};
    
    
    
    
    
    
    
    if strcmp(systemType,'EastOIS2_OneCam')&&strcmp(char(sessionInfo.mouseType),'gcamp6f')
        systemInfo.numLEDs = 3;
        systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt", ...
            "TwoCam_TL625_Pol.txt"];
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
        
    elseif strcmp(systemType,'EastOIS2')
        systemInfo.numLEDs = 4;
        systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt", ...
            "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
            "TwoCam_TL625_Pol_Longer593.txt"];
        if strcmp(char(sessionInfo.mouseType),'WT')
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
        
    elseif strcmp(systemType,'EastOIS1_Fluor')
        systemInfo.numLEDs = 4;
        systemInfo.LEDFiles = {'M470nm_SPF_pol.txt', ...
            'TL_530nm_515LPF_Pol.txt', ...
            'East3410OIS1_TL_617_Pol.txt', ...
            'East3410OIS1_TL_625_Pol.txt'};
        sessionInfo.hbSpecies = 2:4;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
        
    end
    
    
    
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    %maskDir = saveDir;
    maskDir = strcat('J:\ProcessedData_3\GCaMP\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'I','xform_isbrain','isbrain')
    
    
    pkgDir = what('bauerParams');
    
    %fluorDir = fullfile(pkgDir.path,'probeSpectra');
    fluorDir = 'C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts';
    
    for n = runs
        
        
        
        
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if ~exist(fullfile(saveDir,processedName))
            disp('loading raw data')
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            if exist(fullfile(saveDir,rawName),'file')
                disp(strcat('combined file already exist for ',rawName ))
                load(fullfile(saveDir,rawName),'rawdata')
            else
                if strcmp(systemType,'EastOIS1_Fluor')
                    rawdata = single(readtiff(fullfile(rawdataloc,recDate,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif'))));
                    rawdata= reshape(rawdata,nVy,nVx,systemInfo.numLEDs,[]);
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
                    rawdata = fluor.registerCam2andCombineTwoCams_v3(binnedRaw_cam1,binnedRaw_cam2,transformMat);
                end
                disp(strcat('QC raw for ',rawName))
                visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
                QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName)
                
                save(fullfile(saveDir,rawName),'rawdata','-v7.3')
                
            end
            if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
                sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
            end
            
            
            
            
            
            if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
                sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
            end
            
            
            
            
            %
            disp('preprocess raw and tranform raw');
            %load(fullfile(saveDir,rawName),'rawdata')
            %detrend raw
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
                raw_baselineMinus = double(rawdata) - repmat(darkFrame,1,1,1,size(rawdata,4));
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
            
            affineMarkers = I;
            xform_raw = process.affineTransform(raw_detrend,affineMarkers);
            clear raw_detrend
            xform_raw(isnan(xform_raw)) = 0;
            disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
            
            xform_isbrain(isnan(xform_isbrain)) = 0;
            xform_isbrain = logical(xform_isbrain);
            
            
%             
%             [op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
%             %         %%%
                    [op, E] = getHbOpticalProperties_hillman(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
                    %%%
            
            BaselineFunction  = @(x) mean(x,numel(size(x)));
            baselineValues = BaselineFunction(xform_raw);
            xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);
            xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
            
            save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E','-v7.3')
            
            
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
                        xform_gcamp = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
                        clear xform_fluor
                        [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
                        
                        
                        
%                         [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies )));
%                         [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
%                         %                     %
                        %
                                            %%%
                                            [op_in, E_in] = getHbOpticalProperties_hillman(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies )));
                                            [op_out, E_out] = getHbOpticalProperties_hillman(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
                                            %%%
                        
                        
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
    %maskDir = saveDir;
    maskDir = strcat('J:\ProcessedData_3\GCaMP\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(maskDir,maskName), 'isbrain','xform_isbrain')
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
        
        if strcmp(sessionType,'fc')
            disp(char(['fc QC check on ', processedName]))
            
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                
                load(fullfile(saveDir,processedName),'xform_datahb','xform_gcampCorr')
                
                QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r','g',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                close all
                clear xform_gcampCorr xform_datahb
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
                load(fullfile(saveDir,processedName),'xform_datahb')
                
                QCcheck_fc_twoFluor(double(xform_FADCorr),double(squeeze(xform_jrgeco1aCorr)),'FADCorr','jrgeco1aCorr','g','m',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaF/F)','(\DeltaF/F)');
                close all
                QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_jrgeco1aCorr)),'oxy','jrgeco1aCorr','r','m',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                close all
                clear xform_FADCorr xform_jrgeco1aCorr xform_datahb
            end
            
        elseif strcmp(sessionType,'stim')
            
            load('D:\OIS_Process\noVasculatureMask.mat')
            load('J:\ProcessedData_3\ROI')
            xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            stimStartTime = 10;
            info.freqout=1;
            disp('loading Non GRS data')
            if strcmp(sessionInfo.mouseType,'gcamp6f')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','xform_datahb')
            end
            
            
            numBlock = size(xform_green,3)/sessionInfo.stimblocksize;
            
            
            numDesample = size(xform_green,3)/sessionInfo.framerate*info.freqout;
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
                [goodBlocks_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                    xform_FAD,xform_FADCorr,xform_green,xform_jrgeco1a,xform_jrgeco1aCorr,xform_red,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR);
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
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','-append')
                disp('QC on GSR stim')
                [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                    xform_gcamp_GSR,xform_gcampCorr_GSR,xform_green_GSR,[],[],[],...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI);
                
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
                    'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
                
                
                
                
                disp('QC on GSR stim')
                [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                    xform_FAD_GSR,xform_FADCorr_GSR,xform_green_GSR,xform_jrgeco1a_GSR,xform_jrgeco1aCorr_GSR,xform_red_GSR,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI);
            end
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','ROI','-append')
            close all
            
        end
        
    end
end


































