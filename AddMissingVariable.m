
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = [229];

runs = 2;
isDetrend = 1;
nVy = 128;
nVx = 128;

% 
%%%%%process raw to trace
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
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
    
    if strcmp(sessionType,'stim')
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
    else
        sessionInfo.stimbaseline =0;
        sessionInfo.stimduration =0;
    end
    
    
    if strcmp(char(sessionInfo.mouseType),'WT')||strcmp(char(sessionInfo.mouseType),'PV')||strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto2')
        sessionInfo.hbSpecies = 1:2;
        systemInfo.LEDFiles = [
            "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
            "TwoCam_TL625_Pol_Longer593.txt"];
        if strcmp(char(sessionInfo.mouseType),'PV')
            sessionInfo.peakChan = 3;
        end
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
    elseif strcmp(char(sessionInfo.mouseType),'Wopto3')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 2;
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
    elseif strcmp(char(sessionInfo.mouseType),'Gopto3')
        sessionInfo.hbSpecies = 3:4;
        sessionInfo.fluorSpecies = 2;
        sessionInfo.fluorEmissionFile = "fad_emission.txt";
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        sessionInfo.hbSpecies = [3 4];
        sessionInfo.FADspecies = 1;
        sessionInfo.fluorSpecies = 2;
        sessionInfo.refChan = 4;
        sessionInfo.refChan_Green = 3;
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
        
        sessionInfo.FADEmissionFile = "fad_emission.txt";
        systemInfo.LEDFiles = [
            "TwoCam_Mightex470_BP_Pol.txt",...
            "TwoCam_Mightex525_BP_Pol.txt",...
            "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
            "TwoCam_TL625_Pol_Longer593.txt"];
        
        
        
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        systemInfo.numLEDs = 4;
        sessionInfo.hbSpecies = 1:2;
        sessionInfo.fluorSpecies = 3;
        sessionInfo.peakChan = 4;
        sessionInfo.refChan = 2;
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
        systemInfo.LEDFiles = [
            "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
            "TwoCam_TL625_Pol_Longer593.txt", ...
            "TwoCam_Mightex525_BP_Pol.txt"];
    end
    
    
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        maskDir = fullfile(rawdataloc,recDate);
        maskName = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    else
        maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
        else
            maskDir = saveDir;
            maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
            load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
        end
        
    end
    
    xform_isbrain(isnan(xform_isbrain)) = 0;
    xform_isbrain = logical(xform_isbrain);
    
    pkgDir = what('bauerParams');
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    %     badruns = str2num(excelRaw{19});
    %     runs(badruns) = [];
    
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        %         if ~exist(fullfile(saveDir,processedName),'file')
        if exist(fullfile(saveDir,rawName),'file')
            
            isDatahbGot = false;
%             if exist(fullfile(saveDir,processedName),'file')
%                 C = who('-file',fullfile(saveDir,processedName));
%                 
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_datahb')
%                         isDatahbGot = true;
%                     end
%                 end
%             end
            
            if ~isDatahbGot
                disp(mouseName)
                disp('loading raw data')
                load(fullfile(saveDir,rawName),'rawdata')
                
                
                
                %             disp('substract dark frame again, needes to delete')
                            if size(rawdata,4)~=(sessionInfo.framerate*600) && (size(rawdata,4)~=sessionInfo.framerate*300)
                                darkFrameInd = 2:sessionInfo.darkFrameNum/size(rawdata,3);
                                darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
                                raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
                                clear rawdata
                                raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
                                rawdata = raw_baselineMinus;
                            end
                
                
                
                
                
                
                
                disp('preprocess raw and tranform raw');
                if strcmp(sessionType,'stim')
                    rawdata(:,:,:,1) = rawdata(:,:,:,2);
                elseif strcmp(sessionType,'fc')
                    rawdata(:,:,:,1) = [];
                end
                rawdata(:,:,:,end) = rawdata(:,:,:,end-1);
                
                if isDetrend
                    %raw_detrend = process.temporalDetrend(rawdata,true);
                    raw_detrend = temporalDetrendAdam(rawdata);
                end
                
                if  strcmp(systemType,'EastOIS2')
                    raw_detrend = process.smoothImage(raw_detrend,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                end
                
                xform_raw = process.affineTransform(raw_detrend,affineMarkers);
                clear raw_detrend
                xform_raw(isnan(xform_raw)) = 0;
                
                  
                if strcmp(sessionType,'stim')
                    sessionInfo.stimblocksize = excelRaw{11};
                    sessionInfo.stimbaseline=excelRaw{12};
                    sessionInfo.stimduration = excelRaw{13};
                    numBlock = size(xform_raw,4)/sessionInfo.stimblocksize;
                    numBlock = floor(numBlock);
                    xform_raw = xform_raw(:,:,:,1:numBlock*sessionInfo.stimblocksize);
                    baselineValues = reshape(xform_raw,size(xform_raw,1),size(xform_raw,2),size(xform_raw,3),[],numBlock);
                    
                    
                    baselineValues(:,:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.framerate*(sessionInfo.stimduration+2),:) =[];
                    baselineValues = reshape(baselineValues,size(baselineValues,1),size(baselineValues,2),size(baselineValues,3),[]);
                else
                    baselineValues = xform_raw;
                end
                   BaselineFunction  = @(x) mean(x,numel(size(x)));
                baselineValues = BaselineFunction(baselineValues);
                     load(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E')
                
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')||strcmp(char(sessionInfo.mouseType),'jrgeco1a')||strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')||strcmp(char(sessionInfo.mouseType),'Gopto3')||strcmp(char(sessionInfo.mouseType),'Wopto3')
                    C = who('-file',fullfile(saveDir,processedName));
                    isFluorGot = false;
                    %                         for  k=1:length(C)
                    %                             if strcmp(C(k),'xform_gcamp')||strcmp(C(k),'xform_FAD')||strcmp(C(k),'xform_rgeco')
                    %                                 isFluorGot = true;
                    %                             end
                    %                         end
                    if ~isFluorGot
                        disp('get FLuor data')
                        xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
                        xform_fluor = mouse.expSpecific.procFluor(xform_fluor,baselineValues(:,:,sessionInfo.fluorSpecies));

                        xform_Reflectance = squeeze(xform_raw(:,:,sessionInfo.refChan,:));
                        
                        xform_Reflectance = mouse.expSpecific.procFluor(xform_Reflectance,baselineValues(:,:,sessionInfo.refChan)); % make the data ratiometric
                        
                        [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
                        [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
                        
                        dpIn = op_in.dpf/2;
                        dpOut = op_out.dpf/2;
                        
                        
                        xform_fluorCorr = mouse.physics.correctHb(xform_fluor,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                        xform_fluorCorr = process.smoothImage(xform_fluorCorr,systemInfo.gbox,systemInfo.gsigma);
                        xform_fluor = process.smoothImage(xform_fluor,systemInfo.gbox,systemInfo.gsigma);
                        
                        switch sessionInfo.mouseType
                            case 'gcamp6f'
                                clear xform_datahb xform_raw
                                xform_gcamp = xform_fluor;
                                clear xform_fluor
                                xform_gcampCorr = xform_fluorCorr;
                                clear xform_fluorCorr
                                xform_green = xform_Reflectance;
                                clear xform_Reflectance
                                save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','xform_Laser','op_in', 'E_in','op_out', 'E_out','-append','-v7.3')
                            case 'jrgeco1a-opto3'
                                clear xform_datahb xform_raw
                                xform_jrgeco1a = xform_fluor;
                                clear xform_fluor
                                xform_jrgeco1aCorr = xform_fluorCorr;
                                clear xform_fluorCorr
                                xform_red = xform_Reflectance;
                                clear xform_Reflectance
                                save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_Laser','op_in', 'E_in','op_out', 'E_out','-append','-v7.3')
                            case 'jrgeco1a'
                                xform_jrgeco1a = xform_fluor;
                                clear xform_fluor
                                xform_jrgeco1aCorr = xform_fluorCorr;
                                clear xform_fluorCorr
                                xform_red = xform_Reflectance;
                                clear xform_Reflectance
                                
                                xform_FAD = squeeze(xform_raw(:,:,sessionInfo.FADspecies,:));
                                xform_green = squeeze(xform_raw(:,:,sessionInfo.refChan_Green,:));
                                clear xform_raw
                                
                                %                                         baseline = nanmean(xform_FAD,3);%%%%%
                                %                 xform_FAD = xform_FAD./repmat(baseline,[1 1 size(xform_FAD,3)]); % make the data ratiometric%%%%%
                                %                 xform_FAD = xform_FAD - 1; % make the data change from baseline (center at zero)%%%%%
                                
                                xform_FAD= mouse.expSpecific.procFluor(xform_FAD,baselineValues(:,:,sessionInfo.FADspecies));
                                xform_green = mouse.expSpecific.procFluor(xform_green,baselineValues(:,:,sessionInfo.refChan_Green)); % make the data ratiometric
                                
                                [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
                                [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.FADEmissionFile));
                                
                                dpIn_FAD = op_in_FAD.dpf/2;
                                dpOut_FAD = op_out_FAD.dpf/2;
                                
                                
                                load(fullfile(saveDir, processedName),'xform_datahb')%%%need to delete
                                
                                xform_FADCorr = mouse.physics.correctHb(xform_FAD,xform_datahb,...
                                    [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
                                clear xform_datahb
                                xform_FAD = mouse.process.smoothImage(xform_FAD,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data%%%%%
                                xform_FADCorr = mouse.process.smoothImage(xform_FADCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data%%%%%
                                save(fullfile(saveDir,processedName),'xform_red','xform_jrgeco1a','xform_jrgeco1aCorr','xform_green','xform_FAD','xform_FADCorr','-append')
                                
                                %                                     save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','-append','-v7.3')
                        end
                    end
                end
            end
        end
        
        
    end
    
    %end
    clearvars -except excelFile excelRows runs isDetrend
end





