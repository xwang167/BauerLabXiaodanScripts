
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "X:\Paper1\ExposureTime\ExposureTime.xlsx";
excelRows = 2:3;%:450;
runs = 1;
isDetrend = 1;
nVy = 128;
nVx = 128;
numCh = 4;
% % %make mask and transform matrix
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.freqout = sessionInfo.framerate;
%     systemType = excelRaw{5};
%     
%     wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask.mat');
%     
%     if ~exist(fullfile(saveDir,strcat(recDate,'-mytform.mat')),'file')
%         load(fullfile(rawdataloc,recDate,strcat(recDate,'-gridWL-cam1.mat')))
%         cam1 = mean(raw_unregistered,3);
%         clear raw_unregistered
%         
%         load(fullfile(rawdataloc,recDate,strcat(recDate,'-gridWL-cam2.mat')))
%         cam2 = mean(raw_unregistered,3);
%         clear raw_unregistered
%         
%         [transformMat,~,~] = getTransformation(cam1,cam2);
%         save(fullfile(saveDir,strcat(recDate,'-mytform')),'transformMat')
%     end
%     
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     if ~exist(fullfile(saveDir,maskName),'file')
%         disp(strcat('get WL and transform for ', recDate,'-', mouseName))
%         % Load the first 200*numCh frames from cam1
%         fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,'1-cam1.mat');
%         fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
%         tmp=matfile(fileName_cam1);
%         raw_unregistered=tmp.raw_unregistered(:,:,1:200*numCh);
%         % Insert one dark frame in front if there is a drop frame
%         if sum(raw_unregistered(:,:,sessionInfo.darkFrameNum),'all')/ sum(raw_unregistered(:,:,sessionInfo.darkFrameNum-1),'all')>5 %%% check if drop frame
%             raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
%         end
%         % reshape to nVy*nVx*numCh*Frames
%         raw_unregistered = reshape(raw_unregistered,nVy,nVx,numCh,[]);
%         % Get the first non-dark frame for OIS green
%         firtFrame_cam1 = raw_unregistered(:,:,3,sessionInfo.darkFrameNum+1);
%         clear raw_unregistered
%         
%         % Load the first 200*numCh frames from cam2
%         fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,'1-cam2.mat');
%         fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%         tmp=matfile(fileName_cam2);
%         raw_unregistered=tmp.raw_unregistered(:,:,1:200*numCh);
%         % Insert one dark frame in front if there is a drop frame
%         if sum(raw_unregistered(:,:,sessionInfo.darkFrameNum),'all')/ sum(raw_unregistered(:,:,sessionInfo.darkFrameNum-1),'all')>5 %%% check if drop frame
%             raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
%         end
%         %
%         raw_unregistered = reshape(raw_unregistered,nVy,nVx,numCh,[]);
%         % Get the first non-dark frame for OIS red
%         firtFrame_cam2 = raw_unregistered(:,:,4,sessionInfo.darkFrameNum+1);
%         clear raw_unregistered
%         
%         % Generate WL with registered image
%         load(fullfile(saveDir,strcat(recDate,'-mytform')),'transformMat')
%         [WL,transformMat] = fluor.getTransformationandWL_Zyla(firtFrame_cam1, firtFrame_cam2,nVy,nVx,transformMat);
%         save(fullfile(saveDir,wlName),'transformMat','WL');
%         close all
%         
%         disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
%         [isbrain,xform_isbrain,affineMarkers,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
%         isbrain_contour = bwperim(isbrain);
%         save(fullfile(saveDir,maskName),'isbrain', 'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'affineMarkers', 'seedcenter','-append')
%         figure;
%         imagesc(WL); %changed 3/1/1
%         axis off
%         axis image
%         title(strcat(recDate,'-',mouseName));
%         
%         for f=1:size(seedcenter,1)
%             hold on;
%             plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
%         end
%         hold on;
%         plot(affineMarkers.tent(1,1),affineMarkers.tent(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         plot(affineMarkers.bregma(1,1),affineMarkers.bregma(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         plot(affineMarkers.OF(1,1),affineMarkers.OF(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         contour(isbrain_contour,'r')
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
%         close all
%         clearvars -except excelFile nVx nVy excelRows runs isDetrend numCh
%     end
%     
% end
% % %
% % % % %get registered together, dark frame removed raw and QC_raw check
% % %
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     maskDir = saveDir;
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     
%     load(fullfile(maskDir,maskName),'isbrain')
%     
%     for n = runs
%         
%         rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%         if exist(fullfile(saveDir,rawName),'file')
%             disp(strcat('registered rawdata file already exist for ',rawName ))
%             
%         else
%             wlName = maskName;
%             %wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%             
%             %             fileName_cam1 = strcat(recDate,'-',mouseName,'-cam1','-',sessionType,num2str(n),'.mat');%
%             fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
%             fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
%             %             fileName_cam2 = strcat(recDate,'-',mouseName,'-cam2','-',sessionType,num2str(n),'.mat');%
%             fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
%             fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%             
%             disp('loading unregistered data')
%             load(fileName_cam1)
%             
%             % Pad one dark frame in the front if there is a drop frame
%             if sum(raw_unregistered(:,:,sessionInfo.darkFrameNum),'all')/ sum(raw_unregistered(:,:,sessionInfo.darkFrameNum-1),'all')>5
%                 raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
%             end
%             raw_unregistered = reshape(raw_unregistered,nVy,nVx,numCh,[]);
%             binnedRaw_cam1 = raw_unregistered(:,:,[1,3],:);
%             clear raw_unregistered
%             
%             load(fileName_cam2)
%             if sum(raw_unregistered(:,:,sessionInfo.darkFrameNum),'all')/ sum(raw_unregistered(:,:,sessionInfo.darkFrameNum-1),'all')>5
%                 raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
%             end
%             raw_unregistered = reshape(raw_unregistered,nVy,nVx,numCh,[]);
%             binnedRaw_cam2= raw_unregistered(:,:,[2,4],:);
%             clear raw_unregistered
%             
%             disp(strcat('Register and Combine two cameras for ', rawName))
%             load(fullfile(maskDir,wlName),'transformMat');
%             length_1 = size(binnedRaw_cam1,4);
%             length_2 = size(binnedRaw_cam2,4);
%             if  length_1==length_2
%                 rawdata = fluor.registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2,transformMat,sessionInfo.mouseType);
%             elseif length_1 < length_2
%                 rawdata = fluor.registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2(:,:,:,1:length_1),transformMat,sessionInfo.mouseType);
%                 disp(['raw1 is shorter than raw 2, raw1 is ', num2str(length_1)] )
%             else
%                 rawdata = fluor.registerCam2andCombineTwoCams(binnedRaw_cam1(:,:,:, 1:length_2),binnedRaw_cam2,transformMat,sessionInfo.mouseType);
%                 disp(['raw2 is shorter than raw 1, raw1 is ', num2str(length_1)] )
%             end
%             
%             if strcmp(sessionInfo.mouseType,'PV')
%             elseif sessionInfo.darkFrameNum ==0
%                 raw_nondark =rawdata;
%                 darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
%                 darkName =  fullfile(rawdataloc,recDate,darkName);
%                 load(darkName)
%                 darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
%                 clear rawdata
%                 raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
%                 clear raw_baselineMinus
%                 rawdata = raw_baselineMinus;
%             else
%                 darkFrameInd = 2:sessionInfo.darkFrameNum/size(rawdata,3);
%                 darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
%                 raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
%                 clear rawdata
%                 raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
%                 rawdata = raw_baselineMinus;
%                 clear raw_baselineMinus
%                 
%             end
%             
%             
%             disp(strcat('QC raw for ',rawName))
%             visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%             [mdata] = QCcheck_raw(rawdata,isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType);
%             save(fullfile(saveDir,rawName),'rawdata','mdata','-v7.3')
%             close all
%         end
%     end
% end
% 
% %
% 
% %
% % %
%
%
% %
%%%%%process raw to trace
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
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
    
    
    if strcmp(char(sessionInfo.mouseType),'PV')||strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto2')
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
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a') || strcmp(char(sessionInfo.mouseType),'WT')
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
    %     if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
    %         maskDir = fullfile(rawdataloc,recDate);
    %         maskName = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
    %         load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    %     else
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    
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
            if exist(fullfile(saveDir,processedName),'file')
                C = who('-file',fullfile(saveDir,processedName));
                
                for  k=1:length(C)
                    if strcmp(C(k),'xform_datahb')
                        isDatahbGot = true;
                    end
                end
            end
            
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
                
                disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
                if strcmp(char(sessionInfo.mouseType),'Gopto3')||strcmp(char(sessionInfo.mouseType),'Wopto3')
                    [op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(2:3)));
                else
                    
                    [op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
                end
                %                     %         %
                %                     %         [op, E] = getHbOpticalProperties_hillman(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
                %                     %         %%
                
                BaselineFunction  = @(x) mean(x,numel(size(x)));
                
                if strcmp(sessionType,'stim')
                    sessionInfo.stimblocksize = excelRaw{9}*sessionInfo.framerate;
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
                baselineValues = BaselineFunction(baselineValues);
                xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);
                xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
                save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E','-v7.3')
                
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')||strcmp(char(sessionInfo.mouseType),'jrgeco1a')||strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')||strcmp(char(sessionInfo.mouseType),'Gopto3')||strcmp(char(sessionInfo.mouseType),'Wopto3')||strcmp(sessionInfo.mouseType,'WT')
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
                        
                        if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                            xform_Laser = squeeze(xform_raw(:,:,sessionInfo.peakChan,:));
                        end
                        xform_Reflectance = squeeze(xform_raw(:,:,sessionInfo.refChan,:));
                        
                        xform_Reflectance = mouse.expSpecific.procFluor(xform_Reflectance,baselineValues(:,:,sessionInfo.refChan)); % make the data ratiometric
                        
                        [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
                        [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
                        
                        dpIn = op_in.dpf/2;
                        dpOut = op_out.dpf/2;
                        
                        
                        xform_fluorCorr = mouse.physics.correctHb(xform_fluor,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                        xform_fluorCorr = mouse.process.smoothImage(xform_fluorCorr,systemInfo.gbox,systemInfo.gsigma);
                        xform_fluor = mouse.process.smoothImage(xform_fluor,systemInfo.gbox,systemInfo.gsigma);
                        
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
                            case 'WT'
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
                                save(fullfile(saveDir,processedName),...
                                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red',...
                                    'xform_FAD','xform_FADCorr','xform_green','-append')
                                clear xform_jrgeco1a xform_jrgeco1aCorr xform_red xform_FAD xform_FADCorr xform_green
                                %                                     save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','-append','-v7.3')
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
                                save(fullfile(saveDir,processedName),...
                                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red',...
                                    'xform_FAD','xform_FADCorr','xform_green','-append')
                                clear xform_jrgeco1a xform_jrgeco1aCorr xform_red xform_FAD xform_FADCorr xform_green
                        end
                    end
                end
            end
        end
        
        
    end
    
    %end
    clearvars -except excelFile excelRows runs isDetrend
end





for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName), 'xform_isbrain')

    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir,processedName),'file')
            
            
            if strcmp(sessionType,'fc')
                C = who('-file',fullfile(saveDir,processedName));
                isQCGot = false;
                %                 for  k=1:length(C)
                %                     if strcmp(C(k),'powerdata_oxy')
                %                         isQCGot = true;
                %                     end
                %                 end
                if ~isQCGot
                    disp('loading processed data')
                    load(fullfile(saveDir,processedName),'xform_datahb')
                    %                     for ii = 1:size(xform_datahb,4)
                    %                         xform_isbrain(isinf(real(xform_datahb(:,:,1,ii)))) = 0;
                    %                         xform_isbrain(isnan(real(xform_datahb(:,:,1,ii)))) = 0;
                    %
                    %                     end
                    disp(strcat('fc QC check on ', processedName))
                    
                    if strcmp(sessionInfo.mouseType,'gcamp6f')
                        
                        load(fullfile(saveDir,processedName),'xform_gcampCorr')
                        
                        QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r-','g-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                        close all
                        clear xform_gcampCorr xform_datahb
                        
                    elseif strcmp(sessionInfo.mouseType,'jrgeco1a')||strcmp(sessionInfo.mouseType,'WT')
                        load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_jrgeco1a')
                        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                        
                        %                         disp('calculate pds')
                        xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
                        xform_FADCorr = real(double(xform_FADCorr));
                        total = real(double(total));
                        xform_datahb = real(double(xform_datahb));
                        [hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_jrgeco1a] = QCcheck_CalcPDS(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_FADCorr] = QCcheck_CalcPDS(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_total] = QCcheck_CalcPDS(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_oxy] = QCcheck_CalcPDS((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_deoxy] = QCcheck_CalcPDS(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        
                        [hz,powerdata_average_jrgeco1aCorr] = QCcheck_CalcPDSAverage(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_jrgeco1a] = QCcheck_CalcPDSAverage(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_FADCorr] = QCcheck_CalcPDSAverage(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_total] = QCcheck_CalcPDSAverage(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_oxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,1,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_deoxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        
                        clear xform_datahb
                        
                        
                        disp('calculate power map')
                        jrgeco1aCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        FADCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        total_ISA_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        
                        jrgeco1aCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        FADCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        total_Delta_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        
                        disp('calculate fc')
                        refseeds=GetReferenceSeeds;
                        %refseeds = refseeds(1:14,:);
                        
                        [R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        [R_FADCorr_ISA,Rs_FADCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        [R_total_ISA,Rs_total_ISA] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        
                        [R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        [R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        [R_total_Delta,Rs_total_Delta] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        
                        clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
                        
                        
                        save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
                            'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','xform_isbrain','-append')
                        
                        
                        save(fullfile(saveDir, processedName),'powerdata_jrgeco1aCorr','powerdata_jrgeco1a','powerdata_FADCorr','powerdata_total','powerdata_oxy','powerdata_deoxy',...
                            'powerdata_average_jrgeco1aCorr','powerdata_average_jrgeco1a','powerdata_average_FADCorr','powerdata_average_total','powerdata_average_oxy','powerdata_average_deoxy','hz',...
                            'jrgeco1aCorr_ISA_powerMap','FADCorr_ISA_powerMap','total_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','FADCorr_Delta_powerMap','total_Delta_powerMap',...
                            'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
                            'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','xform_isbrain','-append')
                        
                        
                        nameString = fullfile(saveDir,visName);
                        
                        
                        leftData = cell(3,1);
                        leftData{1} = powerdata_jrgeco1aCorr;
                        leftData{2} = powerdata_jrgeco1a;
                        leftData{3} = powerdata_FADCorr;
                        
                        rightData = cell(3,1);
                        rightData{1} = powerdata_oxy;
                        rightData{2} = powerdata_deoxy;
                        rightData{3} = powerdata_total;
                        
                        leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                        rightLabel = 'Hb(\muM^2/Hz)';
                        leftLineStyle = {'m-','y-','g-'};
                        rightLineStyle= {'r-','b-','k-'};
                        legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
                        
                        
                        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve'))
                        
                        
                        leftData = cell(3,1);
                        leftData{1} = powerdata_average_jrgeco1aCorr;
                        leftData{2} = powerdata_average_jrgeco1a;
                        leftData{3} = powerdata_average_FADCorr;
                        
                        rightData = cell(3,1);
                        rightData{1} = powerdata_average_oxy;
                        rightData{2} = powerdata_average_deoxy;
                        rightData{3} = powerdata_average_total;
                        
                        %                 leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                        %                 rightLabel = 'Hb(\muM^2/Hz)';
                        %                 leftLineStyle = {'m-','y-','g-'};
                        %                 rightLineStyle= {'r-','b-','k-'};
                        %                 legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
                        %
                        %                 leftLegend = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD"];
                        %                 rightLegend = ["HbO","HbR","HbT"];
                        
                        
                        
                        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve_average'))
                        %
                        %
                        %                         QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOISA'))
                        %                         QCcheck_powerMapVis(FADCorr_ISA_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADISA'))
                        %                         QCcheck_powerMapVis(total_ISA_powerMap,xform_isbrain,'\muM',saveDir,strcat(visName, "_TotalISA"))
                        %
                        %                         QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, "_RGECODelta"))
                        %                         QCcheck_powerMapVis(FADCorr_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName,"_FADDelta"))
                        %                         QCcheck_powerMapVis(total_Delta_powerMap,xform_isbrain,'\muM',saveDir,strcat(visName,"_TotalDelta"))
                        %
                        
                        
                        
                        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
                        close all
                        
                        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
                        close all
                    end
                    
                end
                
            elseif strcmp(sessionType,'stim')
                disp('loading processed data')
                load(fullfile(saveDir,processedName),'xform_datahb')
                for ii = 1:size(xform_datahb,4)
                    xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
                    xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
                end
                xform_datahb(isinf(xform_datahb)) = 0;
                xform_datahb(isnan(xform_datahb)) = 0;
                %             load('D:\OIS_Process\noVasculatureMask.mat')
                %
                %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
                sessionInfo.stimblocksize = excelRaw{9}*sessionInfo.framerate;
                sessionInfo.stimbaseline=excelRaw{12};
                sessionInfo.stimduration = excelRaw{13};
                sessionInfo.stimFrequency = excelRaw{16};
                stimStartTime = 5;
                info.freqout=1;
                disp('loading Non GRS data')
                if strcmp(sessionInfo.mouseType,'gcamp6f')||strcmp(sessionInfo.mouseType,'Gopto3')
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
                elseif strcmp(sessionInfo.mouseType,'Gopto3')
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a')||strcmp(sessionInfo.mouseType,'WT')
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','xform_datahb')
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_Laser','xform_datahb')
                    
                    
                end
                
                
                
                if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')||strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'.mat')))
                    if strcmp(sessionInfo.mouseType,'PV')
                        load(fullfile(maskDir_new,maskName_new), 'affineMarkers')
                        peakMap_ROI = process.affineTransform(rawdata(:,:,3,sessionInfo.stimbaseline+1),affineMarkers) ;
                        clear rawdata
                    elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                        frameInd = sessionInfo.stimbaseline+1:1/sessionInfo.stimFrequency*sessionInfo.framerate:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate;
                        peakMap_ROI = mean(xform_Laser(:,:,frameInd),3);
                    elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
                        peakMap_ROI = rawdata(:,:,3,sessionInfo.stimbaseline+1);
                        clear rawdata
                    else
                        peakMap_ROI = rawdata(:,:,1,sessionInfo.darkFrameNum/4+sessionInfo.stimbaseline+1);
                        clear rawdata
                    end
                    
                    imagesc(peakMap_ROI)
                    axis image off
                    colormap jet
                    %                     hold on
                    %                     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
                    %                     barrel = AtlasSeeds == 9;
                    %                     ROI_barrel =  bwperim(barrel);
                    
                    
                    %                     contour(ROI_barrel,'k')
                    [X,Y] = meshgrid(1:128,1:128);
                    if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                        [~,I] = max(peakMap_ROI,[],'all','linear');
                        [y1,x1] = ind2sub([128 128],I);
                        radius = 5;
                    else
                        
                        [x1,y1] = ginput(1);
                        [x2,y2] = ginput(1);
                        
                        radius = sqrt((x1-x2)^2+(y1-y2)^2);
                        
                    end
                    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                    max_ROI = prctile(peakMap_ROI(ROI),99);
                    temp = double(peakMap_ROI).*double(ROI);
                    ROI = temp>max_ROI*0.75;
                    hold on
                    ROI_contour = bwperim(ROI);
                    [~,c] = contour( ROI_contour,'r');
                    c.LineWidth = 0.001;
                    
                    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
                    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
                end
                
                numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
                
                numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
                factor = round(numDesample/numBlock);
                numDesample = factor*numBlock;
                %
                texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
                output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
                disp('QC on non GSR stim')
                
                
                %   load(fullfile(saveDir,'ROI.mat'))
                
                if strcmp(sessionInfo.mouseType,'Gopto3')
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                        xform_gcamp,xform_gcampCorr,xform_green,[],[],[],...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
                elseif strcmp(sessionInfo.mouseType,'Wopto3')
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
                        xform_FAD,xform_FADCorr,xform_green,[],[],[],...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                        xform_FAD*100,xform_FADCorr*100,xform_green*100,xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
                    
                elseif strcmp(sessionInfo.mouseType,'WT')
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim_WT(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                        xform_FAD*100,xform_FADCorr*100,xform_green*100,xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                    
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                        [],[],[],xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI,[]);
                elseif strcmp(sessionInfo.mouseType,'PV')
                    xform_datahb(isnan(xform_datahb)) = 0;
                    %xform_datahb =  mouse.freq.lowpass(xform_datahb,0.5,sessionInfo.framerate);
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                        [],[],[],[],[],[],...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
                    load(fullfile(maskDir_new,maskName_new), 'isbrain')
                    [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                        [],[],[],[],[],[],...
                        isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
                    
                end
                close all
                %                 save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_NoGSR','ROI_NoGSR','-append')
                
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
                    xform_jrgeco1a(isnan(xform_jrgeco1a)) = 0;
                    xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
                    clear xform_jrgeco1a
                    xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
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
                    %save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    %'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','goodBlocks_NoGSR','goodBlocks_GSR','ROI_NoGSR','-append')
                    
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
                    
                    disp('QC on GSR stim')
                    [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
                        xform_FAD_GSR*100,xform_FADCorr_GSR*100,xform_green_GSR*100,xform_jrgeco1a_GSR*100,xform_jrgeco1aCorr_GSR*100,xform_red_GSR*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','-append')
                elseif strcmp(sessionInfo.mouseType,'WT')
                    xform_jrgeco1a(isnan(xform_jrgeco1a)) = 0;
                    xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
                    clear xform_jrgeco1a
                    xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
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
                    %save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    %'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','goodBlocks_NoGSR','goodBlocks_GSR','ROI_NoGSR','-append')
                    
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
                    
                    disp('QC on GSR stim')
                    [goodBlocks_GSR] = QC_stim_WT(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
                        xform_FAD_GSR*100,xform_FADCorr_GSR*100,xform_green_GSR*100,xform_jrgeco1a_GSR*100,xform_jrgeco1aCorr_GSR*100,xform_red_GSR*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','-append')
                    
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                    xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
                    clear xform_jrgeco1a
                    xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
                    clear xform_jrgeco1aCorr
                    xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
                    clear xform_red
                    
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append')
                    %                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    %                         'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','ROI_NoGSR')
                    
                    disp('QC on GSR stim')
                    [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
                        [],[],[],xform_jrgeco1a_GSR*100,xform_jrgeco1aCorr_GSR*100,xform_red_GSR*100,...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_NoGSR,[]);
                    
                else
                    [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
                        [],[],[],[],[],[],...
                        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','ROI_NoGSR','ROI','xform_datahb_GSR','-append')
                    
                end
            end
            close all
            
        end
        
    end
end