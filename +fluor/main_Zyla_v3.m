
close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;
%
excelRows = [182];%[181:186  195 202:205];

runs =1:3;
isDetrend = 1;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     systemType = excelRaw{5};
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.mouseType = excelRaw{13};
%     sessionInfo.darkFrameNum = excelRaw{11};
%     sessionInfo.totalFrameNum = excelRaw{18};
%     systemInfo.numLEDs = 4;
%     sessionInfo.stimbaseline=excelRaw{9};
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.stimblocksize = excelRaw{8};
% 
% 
%     wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     if exist(fullfile(saveDir,wlName),'file')
%         disp(strcat('WL and transform file already exists for ', recDate,'-', mouseName))
%         load(fullfile(saveDir,wlName),'transformMat','WL');
%     else
%         disp(strcat('get WL and transform for ', recDate,'-', mouseName))
% 
%         fileName_cam1 = strcat(recDate,'-',mouseName,'-cam1','-',sessionType,'1.mat');
%         fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
%         load(fileName_cam1)
% 
%         if strcmp(sessionInfo.mouseType,'jrgeco1a')|| strcmp(sessionInfo.mouseType,'WT')
%         firtFrame_cam1  = squeeze(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/4+1));
%         elseif strcmp(sessionInfo.mouseType,'gcamp6f')
%         firtFrame_cam1  = squeeze(raw_unregistered(:,:,2,sessionInfo.darkFrameNum/4+1));
%         end
%         clear raw_unregistered
%         fileName_cam2 = strcat(recDate,'-',mouseName,'-cam2','-',sessionType,'1.mat');
%         fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%         load(fileName_cam2)
%         if strcmp(sessionInfo.mouseType,'jrgeco1a')
%         firtFrame_cam2  = squeeze(raw_unregistered(:,:,2,sessionInfo.darkFrameNum/4+1));
%         elseif strcmp(sessionInfo.mouseType,'gcamp6f')|| strcmp(sessionInfo.mouseType,'WT')
%         firtFrame_cam2  = squeeze(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/4+1));
%         end
% 
%         clear raw_unregistered
%         [WL,transformMat] = fluor.getTransformationandWL_Zyla(firtFrame_cam1, firtFrame_cam2,nVy,nVx);
%         save(fullfile(saveDir,wlName),'transformMat','WL');
%         close all
%     end
% 
% 
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     if exist(fullfile(saveDir,maskName))
%         disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
%         load(fullfile(saveDir,maskName), 'isbrain',  'affineMarkers')
%     else
%         % need to be modified to see if WL exist
% 
%         disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
%         [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
%         isbrain_contour = bwperim(isbrain);
%         save(fullfile(saveDir,maskName),'isbrain',  'affineMarkers' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'affineMarkers', 'seedcenter')
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
%         plot(I.tent(1,1),I.tent(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         plot(I.bregma(1,1),I.bregma(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         plot(I.OF(1,1),I.OF(1,2),'ko','MarkerFaceColor','b')
%         hold on;
%         contour(isbrain_contour,'r')
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
% 
% 
%     end
%     clearvars -except excelFile nVx nVy excelRows runs
% end
%
%
%
% % Process raw data to get xform_datahb and xform_fluor(if needed)

% %
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
% 
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
% 
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.totalFrameNum = excelRaw{22};
%     sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
%     sessionInfo.detrendSpatially = true;
%     sessionInfo.detrendTemporally = true;
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.freqout = sessionInfo.framerate;
%     muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
%     systemType = excelRaw{5};
% 
%     if strcmp(char(sessionInfo.mouseType),'WT')
%         sessionInfo.hbSpecies = 1:2;
%     elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
%         sessionInfo.hbSpecies = 2:3;
%         sessionInfo.fluorSpecies = 1;
%         sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
%         sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
%     elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
%         sessionInfo.hbSpecies = 3:4;
%         sessionInfo.fluorSpecies = 2;
%         sessionInfo.fluorExcitationFile = "jrgeco1a_excitation.txt";%% need
%         sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
%     end
% 
%     systemInfo.numLEDs = 4;
%     systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
%         "TwoCam_Mightex525_BP_Pol.txt", ...
%         "TwoCam_Mightex525_BP_Pol.txt", ...
%         "TwoCam_TL625_Pol.txt"];
% 
%     systemInfo.invalidFrameInd = 1;
%     systemInfo.gbox = 5;
%     systemInfo.gsigma = 1.2;
% 
% 
% 
% 
% 
% maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     load(fullfile(maskDir,maskName),'affineMarkers')
% 
% 
%     pkgDir = what('bauerParams');
% 
%     fluorDir = fullfile(pkgDir.path,'probeSpectra');
%     sessionInfo.fluorEmissionFile = fullfile(fluorDir,sessionInfo.fluorEmissionFile);
% 
%     ledDir = fullfile(pkgDir.path,'ledSpectra');
%     for ind = 1:numel(systemInfo.LEDFiles)
%         systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
% 
%     end
% 
%     for n = runs
% 
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         if ~exist(fullfile(saveDir,processedName))
%             disp('loading raw data')
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%             if exist(fullfile(saveDir,rawName),'file')
%                 disp(strcat('combined file already exist for ',rawName ))
%                 load(fullfile(saveDir,rawName),'rawdata')
%             else
%                  wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%                  maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
% 
%                  load(fullfile(maskDir,wlName),'transformMat');
%                 disp(strcat('Register and Combine two cameras for ', rawName))
%                 fileName_cam1 = strcat(recDate,'-',mouseName,'-cam1','-',sessionType,num2str(n),'.mat');
%                 fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
%                 fileName_cam2 = strcat(recDate,'-',mouseName,'-cam2','-',sessionType,num2str(n));
%                 fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%                 load(fileName_cam1)
%                 binnedRaw_cam1 = raw_unregistered;
%                 clear raw_unregistered
%                 load(fileName_cam2)
%                 binnedRaw_cam2 = raw_unregistered;
%                 clear raw_unregistered
%                 rawdata = fluor.registerCam2andCombineTwoCams_v3(binnedRaw_cam1,binnedRaw_cam2,transformMat);
%                 save(fullfile(saveDir,rawName),'rawdata','-v7.3')
% 
%             end
%             if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
%                 sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
%             end
% 
% 
% 
%          
%             
%             disp('preprocess raw and tranform raw');
%             maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataHb','.mat')),'xform_isbrain');
%       
%             load(fullfile(maskDir,maskName), 'affineMarkers','isbrain')
%            
%             visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%             QCcheck_raw(rawdata(:,:,:,sessionInfo.darkFrameNum/systemInfo.numLEDs+2:end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
%             
%             % detrend raw
%                 if sessionInfo.darkFrameNum ==0
%                     raw_nondark =rawdata;
%                     darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
%                     darkName =  fullfile(rawdataloc,recDate,darkName);
%                     load(darkName)
%                     darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
%                     clear rawdata
%                     raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
%                     clear raw_baselineMinus
%                     rawdata = raw_baselineMinus;
%                 else
%                     darkFrameInd = 2:sessionInfo.darkFrameNum/systemInfo.numLEDs;
%                     darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
%                     raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
%                     clear rawdata
%                     raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/systemInfo.numLEDs)=[];
%                     rawdata = raw_baselineMinus;
%                     clear raw_baselineMinus
%                     
%                 end
%      
%             if strcmp(sessionType,'stim')
%                 rawdata(:,:,:,1) = rawdata(:,:,:,2);
%             elseif strcmp(sessionType,'fc')
%                 rawdata(:,:,:,1) = [];
%             end
%             if isDetrend
% %                 raw_detrend = process.temporalDetrend(rawdata,true);
%                 raw_detrend = temporalDetrendAdam(rawdata);
%             end
%             % affine transform
%        
%             
%             xform_raw = process.affineTransform(raw_detrend,affineMarkers);
%             clear raw_detrend
%             xform_raw(isnan(xform_raw)) = 0;
%             disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
%               
%             xform_isbrain(isnan(xform_isbrain)) = 0;
%             xform_isbrain = logical(xform_isbrain);
%             
%             [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(sessionInfo.hbSpecies));
%             BaselineFunction  = @(x) mean(x,numel(size(x)));
%             baselineValues = BaselineFunction(xform_raw);
%             xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);
%             xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%             
%             save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','op','E','-v7.3')
%             
%             if strcmp(char(sessionInfo.mouseType),'gcamp6f')
%                 
%                 xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
%                 
%                 baseline = nanmean(xform_fluor,3);
%                 xform_fluor = xform_fluor./repmat(baseline,[1 1 size(xform_fluor,3)]); % make the data ratiometric
%                 xform_fluor = xform_fluor - 1; % make the data change from baseline (center at zero)
%                 
% 
%                 [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
%                 [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
%                 
%                 
%                 dpIn = op_in.dpf/2;
%                 dpOut = op_out.dpf/2;
%                 
%                 
%                 xform_gcamp= xform_fluor ;
%                 xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
%                     [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
%                 xform_green = squeeze(xform_raw(:,:,2,:));
%                 
%                 xform_gcamp = process.smoothImage(xform_gcamp,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 
%                 baseline = nanmean(xform_green,3);
%                 xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
%                 xform_green = xform_green - 1;
%                 xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 
%                 
%                 save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','op_in', 'E_in','op_out', 'E_out','-append')
%             end
% 
%         else
%             disp(strcat('OIS data already processed for ',processedName))
%             load(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo')
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%             load(fullfile(saveDir,rawName),'xform_raw')
%         end
% 
% 
%         if ~strcmp(char(sessionInfo.mouseType),'WT')
% 
%  
%             if strcmp(char(sessionInfo.mouseType),'gcamp6f')
%                           
%                 C = who('-file',fullfile(saveDir,processedName));
%                 isFluorGot = false;
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_gcamp')
%                         isFluorGot = true;
%                     end
%                 end
%                 if ~isFluorGot
%                     disp('correct gcamp')
%                            xform_fluor = xform_raw(:,:,sessionInfo.fluorSpecies,:);
%             xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
%             [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
% 
% 
% 
%                              xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
%                 
%                 baseline = nanmean(xform_fluor,3);
%                 xform_fluor = xform_fluor./repmat(baseline,[1 1 size(xform_fluor,3)]); % make the data ratiometric
%                 xform_fluor = xform_fluor - 1; % make the data change from baseline (center at zero)
%                 
% 
%                 [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
%                 [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
%                 
%                 
%                 dpIn = op_in.dpf/2;
%                 dpOut = op_out.dpf/2;
%                 
%                 
%                 xform_gcamp= xform_fluor ;
%                 xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
%                     [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
%                 xform_green = squeeze(xform_raw(:,:,2,:));
%                 clear xform_raw
%                 xform_gcamp = process.smoothImage(xform_gcamp,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 
%                 baseline = nanmean(xform_green,3);
%                 xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
%                 xform_green = xform_green - 1;
%                 xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 
%                 
%                 save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green','op_in', 'E_in','op_out', 'E_out','-append')                
%                 end
%             elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
% 
%                 C = who('-file',fullfile(saveDir,processedName));
%                 isFluorGot = false;
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_jrgeco1a')
%                         isFluorGot = true;
%                     end
%                 end
%                 if ~isFluorGot
%                     disp('correct jrgeco1a')
%                            xform_fluor = xform_raw(:,:,sessionInfo.fluorSpecies,:);
%             xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
%             [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
% 
% 
% 
% 
%                     [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(2));
%                     [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
% 
% 
%                     dpIn = op_in.dpf/2;
%                     dpOut = op_out.dpf/2;
% 
%                     %             dpIn = 0.056;
%                     %             dpOut = 0.057;
%                     xform_jrgeco1a = xform_fluor ;
%                     xform_jrgeco1aCorr = mouse.physics.correctHb(xform_jrgeco1a,xform_datahb,...
%                         [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
%   xform_red = squeeze(xform_raw(:,:,4,:));
%                 clear xform_raw
%                 xform_jrgeco1a = process.smoothImage(xform_jrgeco1a,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 xform_jrgeco1aCorr = process.smoothImage(xform_jrgeco1aCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%                 
%                 baseline = nanmean(xform_red,3);
%                 xform_red = xform_red./repmat(baseline,[1 1 size(xform_red,3)]); % make the data ratiometric
%                 xform_red = xform_red - 1;
%                 xform_red = process.smoothImage(xform_red,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
% 
%                     save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','-append')
%                 else
%                     disp(strcat('jrgeco1a data already processed for ',processedName))
%                 end
%             end
% 
%         
% 
%         end
%     end
% 
% end









for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
   load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
   
    load(fullfile(maskDir,maskName), 'isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    
    if strcmp(systemType,'EastOIS2')
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
            sessionInfo.darkFrameNum = excelRaw{15};
            systemInfo.numLEDs = 3;
        end
        
    elseif strcmp(systemType,'EastOIS1_Fluor')||strcmp(systemType,'EastOIS1')
        systemInfo.numLEDs = 4;
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.darkFrameNum = excelRaw{15};
            
        end
    end
    
    
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(maskDir,maskName), 'isbrain');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        output = fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
        
        if ~ exist(output,'file')
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            load(fullfile(saveDir,rawName),'rawdata')
            disp(strcat('QC raw for ',rawName))
            
            QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
        end
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        output = fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            disp('loading processed data')
            
             if strcmp(sessionType,'fc')
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
                
                
                sessionInfo.stimblocksize = excelRaw{11};
                sessionInfo.stimbaseline=excelRaw{12};
                sessionInfo.stimduration = excelRaw{13};
                sessionInfo.stimFrequency = excelRaw{16};
                info.newFreq = 8;
                info.freqout=1;
                %info.bandtype = {"0.01Hz-8Hz",0.01,8};
                %                 if ~isempty(excelRaw(20))
                %                     fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                %                     load(fullfile(saveDir,fileName_cam1));
                %                     startInd = sessionInfo.darkFrameNum/systemInfo.numLEDs/sessionInfo.framerate*excelRaw{20};
                %                     time = timeStamps(startInd+1:end);
                %                     darkTime = timeStamps(startInd);
                %                     input_stimbox = data(startInd+1:end);
                %                     time = time(1:end/4)-darkTime;
                %                     input_stimbox = input_stimbox(1:end/4);
                %                     [~,locs] = findpeaks(input_stimbox,'MinPeakHeight',4.5);
                %                     sessionInfo.stimbaseline = round(time(locs(1))*sessionInfo.framerate);
                %                 end
                isGSR = false;
%                 C = who('-file',fullfile(saveDir,processedName));
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_datahb_GSR')
%                         isGSR= true;
%                     end
%                 end
                
                if isGSR
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR')
                    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                        disp('loading GRS data')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR')
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        disp('loading GRS data')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR')
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
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red')
                        xform_jrgeco1a(isnan(xform_jrgeco1a))=0;
                        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
                        xform_red(isnan(xform_red))=0;
                        
                        xform_jrgeco1a(isinf(xform_jrgeco1a))=0;
                        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
                        xform_red(isinf(xform_red))=0;
                        
                        xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
                        clear xform_jrgeco1a
                        xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
                        clear xform_jrgeco1aCorr
                        xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
                        clear xform_red
                        disp('saving')
                        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append')
                        
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_GSR = double(xform_jrgeco1a_GSR);
                    clear xform_jrgeco1a_GSR
                    jrgeco1aCorr_GSR = double(xform_jrgeco1aCorr_GSR);
                    clear xform_jrgeco1aCorr_GSR
                    red_GSR = double(xform_red_GSR);
                    clear xform_red_GSR
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_GSR = jrgeco1a_GSR.*xform_isbrain;
                    jrgeco1aCorr_GSR = jrgeco1aCorr_GSR.*xform_isbrain;
                    red_GSR = red_GSR.*xform_isbrain;
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
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1a_GSR(:,:,end:end+pad)=0;
                        jrgeco1aCorr_GSR(:,:,end:end+pad)=0;
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,jrgeco1aCorr_downsampled_GSR,jrgeco1a_downsampled_GSR, temp_jrgeco1aCorr_max_GSR,~,~,~] = fluor.pickGoodBlocks(double(oxy_GSR),double(deoxy_GSR),double(total_GSR),info.freqout,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr',double(jrgeco1aCorr_GSR),'jrgeco1a',double(jrgeco1a_GSR));
                    numBlock = size(red_GSR,3)/sessionInfo.stimblocksize;


numDesample = size(red_GSR,3)/sessionInfo.framerate*info.freqout;
factor = round(numDesample/numBlock);
numDesample = factor*numBlock;
red_downsampled_GSR = resampledata(red_GSR,size(red_GSR,3),numDesample,10^-5);
red_downsampled_GSR = reshape(red_downsampled_GSR,size(red_GSR,1),size(red_GSR,2),[],numBlock);
baseline_red_GSR_downsampled = squeeze(mean(red_downsampled_GSR(:,:,1:stimStartTime,2),3));
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
                        
                        [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR);
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1aCorr_blocks_downsampled = mean(jrgeco1aCorr_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                        jrgeco1a_blocks_downsampled = mean(jrgeco1a_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
   red_blocks_downsampled = mean(red_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
                                             
                        [~,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,ROI_jrgeco1aCorr_GSR,Avgjrgeco1aCorr_stim,~,~] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR);
                        
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
                        %                                         if isnan(excelRaw(20))
                        fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain)
                        %                     else
                        %                         fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
                        %                     end
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1aCorr_GSR = reshape(jrgeco1aCorr_GSR,size(oxy_GSR,1),size(oxy_GSR,2),[],numBlock);
                        jrgeco1a_GSR = reshape(jrgeco1a_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
                        red_GSR = reshape(red_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
                        jrgeco1aCorr_blocks_GSR = mean(jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR),4);
                        jrgeco1a_blocks_GSR = mean(jrgeco1a_GSR(:,:,:,goodBlocks_GSR),4);
                        red_blocks_GSR = mean(red_GSR(:,:,:,goodBlocks_GSR),4);
                        
                        %                     if isnan(excelRaw(20))
                        fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_blocks_GSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_GSR,'jrgeco1a_blocks_downsampled',jrgeco1a_blocks_downsampled,'red_blocks_downsampled',red_blocks_downsampled,'jrgeco1a_blocks',jrgeco1a_blocks_GSR,'red_blocks',red_blocks_GSR,'xform_isbrain',xform_isbrain)
                        %                     else
                        %                         fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_blocks_GSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr,'jrgeco1a_blocks_downsampled',jrgeco1a_blocks_downsampled,'jrgeco1a_blocks',jrgeco1a_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
                        %                     end
                        
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'ROI_total',ROI_total)
                    end
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red')
                    
                    jrgeco1a_NoGSR = double(xform_jrgeco1a);
                    clear xform_jrgeco1a
                    jrgeco1aCorr_NoGSR = double(xform_jrgeco1aCorr);
                    clear xform_jrgeco1aCorr
                    red_NoGSR = double(xform_red);
                    clear xform_red
                end
                
                xform_isbrain = double(xform_isbrain);
                
                oxy_NoGSR = oxy_NoGSR.*xform_isbrain;
                deoxy_NoGSR = deoxy_NoGSR.*xform_isbrain;
                total_NoGSR = total_NoGSR .*xform_isbrain;
                
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_NoGSR = gcamp_NoGSR.*xform_isbrain;
                    gcampCorr_NoGSR = gcampCorr_NoGSR.*xform_isbrain;
                    green_NoGSR = green_NoGSR.*xform_isbrain;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_NoGSR = jrgeco1a_NoGSR.*xform_isbrain;
                    jrgeco1aCorr_NoGSR = jrgeco1aCorr_NoGSR.*xform_isbrain;
                    red_NoGSR = red_NoGSR.*xform_isbrain;
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
                        
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1a_NoGSR(:,:,end:end+pad)=0;
                        jrgeco1aCorr_NoGSR(:,:,end:end+pad)=0;
                        
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime, jrgeco1aCorr_downsampled_NoGSR,jrgeco1a_downsampled_NoGSR, temp_jrgeco1aCorr_max_NoGSR,~,~,~] = fluor.pickGoodBlocks(double(oxy_NoGSR),double(deoxy_NoGSR),double(total_NoGSR),info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR,'jrgeco1aCorr',double(jrgeco1aCorr_NoGSR),'jrgeco1a',double(jrgeco1a_NoGSR));
numBlock = size(red_NoGSR,3)/sessionInfo.stimblocksize;


numDesample = size(red_NoGSR,3)/sessionInfo.framerate*info.freqout;
factor = round(numDesample/numBlock);
numDesample = factor*numBlock;
red_downsampled_NoGSR = resampledata(red_NoGSR,size(red_NoGSR,3),numDesample,10^-5);
red_downsampled_NoGSR = reshape(red_downsampled_NoGSR,size(red_NoGSR,1),size(red_NoGSR,2),[],numBlock);
baseline_red_NoGSR_downsampled = squeeze(mean(red_downsampled_NoGSR(:,:,1:stimStartTime,2),3));                    
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
                        [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR);
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1aCorr_blocks_downsampled = mean(jrgeco1aCorr_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        jrgeco1a_blocks_downsampled = mean(jrgeco1a_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);
red_blocks_downsampled = mean(red_downsampled_NoGSR(:,:,:,goodBlocks_NoGSR),4);                         
[~,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,Avgjrgeco1aCorr_stim,~,~] = fluor.generatePeakMapandROI(oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_NoGSR);
                        
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
                    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                        jrgeco1aCorr_NoGSR = reshape(jrgeco1aCorr_NoGSR,size(oxy_NoGSR,1),size(oxy_NoGSR,2),[],numBlock);
                        jrgeco1a_NoGSR = reshape(jrgeco1a_NoGSR,size(deoxy_NoGSR,1),size(deoxy_NoGSR,2),[],numBlock);
                        red_NoGSR = reshape(red_NoGSR,size(deoxy_NoGSR,1),size(deoxy_NoGSR,2),[],numBlock);
                        jrgeco1aCorr_blocks_NoGSR = mean(jrgeco1aCorr_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        jrgeco1a_blocks_NoGSR = mean(jrgeco1a_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        red_blocks_NoGSR = mean(red_NoGSR(:,:,:,goodBlocks_NoGSR),4);
                        
                        
                        fluor.traceImagePlot(oxy_blocks_NoGSR,deoxy_blocks_NoGSR,total_blocks_NoGSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_blocks_NoGSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_NoGSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_GSR,'jrgeco1a_blocks_downsampled',jrgeco1a_blocks_downsampled,'red_blocks_downsampled',red_blocks_downsampled,'jrgeco1a_blocks',jrgeco1a_blocks_NoGSR,'red_blocks',red_blocks_NoGSR,'xform_isbrain',xform_isbrain)
                        
                        
                    elseif strcmp(char(sessionInfo.mouseType),'WT')
                        fluor.traceImagePlot(oxy_blocks_NoGSR,deoxy_blocks_NoGSR,total_blocks_NoGSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,ROI_total,sessionInfo,output_NoGSR,texttitle_NoGSR)
                    end
                end
       
             end
            close all

        end
    end
end

% 
% 
