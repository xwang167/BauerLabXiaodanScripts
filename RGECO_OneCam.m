close all;clearvars;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
nVx = 128;
nVy = 128;
excelRows = 442;
runs = 1:3;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':Z',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%
%     sessionInfo.mouseType = excelRaw{17};
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     systemType = excelRaw{5};
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%
%     fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,'1-cam2.mat');
%     fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%     load(fileName_cam2)
%     sessionInfo.hbSpecies = 2:3;
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemInfo.numLEDs = 3;
%     WL = zeros(128,128,3);
%     darkNum= sessionInfo.darkFrameNum/systemInfo.numLEDs;
%     WL(:,:,1) = raw_unregistered(:,:,sessionInfo.hbSpecies(2),1+darkNum)/max(max( squeeze(raw_unregistered(:,:,sessionInfo.hbSpecies(2),1+darkNum))));
%     WL(:,:,2) = raw_unregistered(:,:,sessionInfo.hbSpecies(1),1+darkNum)/max(max( squeeze(raw_unregistered(:,:,sessionInfo.hbSpecies(1),1+darkNum))));
%     WL(:,:,3) = WL(:,:,1);
%
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     if exist(fullfile(saveDir,maskName))
%         disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
%         load(fullfile(saveDir,maskName), 'isbrain',  'I')
%     else
%
%         disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
%         [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
%         isbrain_contour = bwperim(isbrain);
%         save(fullfile(saveDir,maskName),'isbrain',  'I' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter')
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
%     end
%     clearvars -except excelFile nVx nVy excelRows runs isDetrend
% end
%


% Process raw data to get xform_datahb and xform_fluor(if needed)
%

% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':Z',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     systemType = excelRaw{5};
%     sessionInfo.mouseType = excelRaw{17};
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     
%     sessionInfo.totalFrameNum = excelRaw{22};
%     sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
%     sessionInfo.detrendSpatially = false;
%     sessionInfo.detrendTemporally = true;
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.freqout = sessionInfo.framerate;
%     muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
%     
%     systemInfo.LEDFiles = ["TwoCam_Mightex525_BP_Pol.txt",...
%         "TwoCam_TL625_Pol_Longer593.txt", ...
%         "TwoCam_TL590_BPD_SP700_LP593_Pol.txt"];
%     
%     systemInfo.invalidFrameInd = 1;
%     systemInfo.gbox = 5;
%     systemInfo.gsigma = 1.2;
%     
%     sessionInfo.hbSpecies = 2:3;
%     sessionInfo.fluorSpecies = 1;
%     sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemInfo.numLEDs = 3;
%     
%     
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     load(fullfile(saveDir,maskName),'I','isbrain')
%     
%     
%     pkgDir = what('bauerParams');
%     ledDir = fullfile(pkgDir.path,'ledSpectra');
%     for ind = 1:numel(systemInfo.LEDFiles)
%         systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
%     end
%     
%     for n = runs
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         
%         %             if ~exist(fullfile(saveDir,processedName))
%         
%         
%         fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
%         fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
%         load(fileName_cam2)
%         
%         if sessionInfo.darkFrameNum>0
%             if sum(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/3+1),'all')/ sum(raw_unregistered(:,:,1,sessionInfo.darkFrameNum/3),'all')<5
%                 numCh = size(raw_unregistered,3);
%                 raw_unregistered = reshape(raw_unregistered,128,128,[]);
%                 raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
%                 raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
%             end
%         end
%         rawdata = raw_unregistered;
%         clear raw_unregistered
%         rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%         disp('preprocess raw and tranform raw');
%         systemInfo.invalidFrameInd = [];
%         
%         
%         
%         sessionInfo.darkFrameNum = excelRaw{15};
%         systemInfo.numLEDs = 3;
%         if sessionInfo.darkFrameNum ==0
%             raw_nondark =rawdata;
%             darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
%             darkName =  fullfile(rawdataloc,recDate,darkName);
%             load(darkName)
%             darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
%             raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
%             rawdata = raw_baselineMinus;
%         else
%             darkFrameInd = 2:sessionInfo.darkFrameNum/systemInfo.numLEDs;
%             darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
%             raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
%             raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/systemInfo.numLEDs)=[];
%             rawdata = raw_baselineMinus;
%         end
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         [mdata] = QCcheck_raw(rawdata,isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType);
%         save(fullfile(saveDir,rawName),'rawdata','mdata','-v7.3')
%         
%         raw_detrend = temporalDetrendAdam(rawdata);
%         clear rawdata
%         % smooth image
%         raw = process.smoothImage(raw_detrend,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
%         clear raw_detrend
%         % affine transform
%         xform_raw = process.affineTransform(raw,I);
%         xform_raw(isnan(xform_raw)) = 0;
%         disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%         load(fullfile(saveDir,maskName), 'xform_isbrain','I')
%         
%         xform_isbrain(isnan(xform_isbrain)) = 0;
%         xform_isbrain = logical(xform_isbrain);
%         
%         [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(sessionInfo.hbSpecies));
%         BaselineFunction  = @(x) mean(x,numel(size(x)));
%         baselineValues = BaselineFunction(xform_raw);
%         xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E,xform_isbrain);
%         xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma);
%         save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','-v7.3')
%         
%         
%         
%         xform_fluor = squeeze(xform_raw(:,:,sessionInfo.fluorSpecies,:));
%         
%         baseline = nanmean(xform_fluor,3);
%         xform_fluor = xform_fluor./repmat(baseline,[1 1 size(xform_fluor,3)]); % make the data ratiometric
%         xform_fluor = xform_fluor - 1; % make the data change from baseline (center at zero)
%         
%         [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
%         [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
%         [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra',sessionInfo.fluorEmissionFile));
%         
%         
%         dpIn = op_in.dpf/2;
%         dpOut = op_out.dpf/2;
%         
%         
%         xform_jrgeco1a= xform_fluor ;
%         xform_jrgeco1aCorr = mouse.physics.correctHb(xform_jrgeco1a,xform_datahb,...
%             [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
%         xform_jrgeco1aCorr = process.smoothImage(xform_jrgeco1aCorr,systemInfo.gbox,systemInfo.gsigma);
%         xform_jrgeco1a = process.smoothImage(xform_jrgeco1a,systemInfo.gbox,systemInfo.gsigma);
%         xform_red = squeeze(xform_raw(:,:,2,:));
%         baseline = nanmean(xform_red,3);
%         xform_red = xform_red./repmat(baseline,[1 1 size(xform_red,3)]); % make the data ratiometric
%         xform_red = xform_red - 1;
%         save(fullfile(saveDir, processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','-append')
%         
%         %
%         %                 else
%         %                 disp(strcat('OIS data already processed for ',processedName))
%         %             end
%         %
%     end
%     clearvars -except excelFile nVx nVy excelRows runs
% end
% %

% 
% for excelRow = excelRows
%     
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     maskName_new = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     % maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
%     %     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskDir = saveDir;
%     load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     
%     for n = runs
%         if strcmp(sessionType,'stim')
%             disp('loading processed data')
%             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%             load(fullfile(saveDir,processedName),'xform_datahb')
%             for ii = 1:size(xform_datahb,4)
%                 xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
%                 xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
%                 
%             end
%             xform_datahb(isinf(xform_datahb)) = 0;
%             xform_datahb(isnan(xform_datahb)) = 0;
%             sessionInfo.stimblocksize = excelRaw{11};
%             sessionInfo.stimbaseline=excelRaw{12};
%             sessionInfo.stimduration = excelRaw{13};
%             sessionInfo.stimFrequency = excelRaw{16};
%             stimStartTime = 5;
%             info.freqout=1;
%             disp('loading Non GRS data')
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                 'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_datahb')
%             
%             numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
%             
%             numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
%             factor = round(numDesample/numBlock);
%             numDesample = factor*numBlock;
%             %
%             texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
%             output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
%             
%             disp('Generating GRS data')
%             
%             texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
%             output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
%             
%             xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
%             
%             xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
%             
%             xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
%             
%             xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
%             
%             
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                 'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append')
%             
%             %             disp('QC on GSR stim')
%             %             [goodBlocks_GSR,ROI_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
%             %                 [],[],[],xform_jrgeco1a_GSR,xform_jrgeco1aCorr_GSR,xform_red_GSR,...
%             %                 xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[],[]);
%             %             disp('QC on non GSR stim')
%             %             [goodBlocks_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%             %                 [],[],[],xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
%             %                 xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_GSR,[]);
%             %             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%             %                 'ROI_GSR','-append')
%         end
%     end
% end


stimStartTime = 5;

nVx = 128;
nVy = 128;
for excelRow = excelRows
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    info.freqout=1;
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,maskName),'xform_isbrain','isbrain');
    
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_datahb_mouse_GSR = [];
    xform_datahb_mouse_NoGSR = [];
    
    xform_jrgeco1a_mouse_GSR = [];
    xform_jrgeco1a_mouse_NoGSR = [];
    
    xform_jrgeco1aCorr_mouse_GSR = [];
    xform_jrgeco1aCorr_mouse_NoGSR = [];
    
    xform_red_mouse_GSR = [];
    xform_red_mouse_NoGSR = [];
    
    for n = runs
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            sessionInfo.stimblocksize = excelRaw{11};
            disp('loading processed data')
            goodBlocks_GSR = 1:10;
            goodBlocks_NoGSR = 1:10;
            load(fullfile(saveDir, processedName),'xform_datahb','goodBlocks_NoGSR','ROI_NoGSR')
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);         
            clear xform_datahb          
            xform_datahb_baseline = mean(xform_datahb_NoGSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_baseline = repmat(xform_datahb_baseline,1,1,1,size(xform_datahb_NoGSR,4),1);           
            xform_datahb_NoGSR = xform_datahb_NoGSR - xform_datahb_baseline;
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
 
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','goodBlocks_GSR')
            
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_datahb_GSR_baseline = mean(xform_datahb_GSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_GSR_baseline = repmat(xform_datahb_GSR_baseline,1,1,1,size(xform_datahb_GSR,4),1);
            xform_datahb_GSR = xform_datahb_GSR - xform_datahb_GSR_baseline;
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            clear xform_datahb_GSR 
            
            load(fullfile(saveDir, processedName),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR')

            disp('loading  Non GRS data')
            sessionInfo.stimblocksize = excelRaw{11};
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red')
            
            xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],numBlocks);
            xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
            xform_red= reshape(xform_red,128,128,[],numBlocks);
            xform_jrgeco1aCorr_baseline = mean(xform_jrgeco1aCorr(:,:,1:5*sessionInfo.framerate,:),3);
            xform_jrgeco1aCorr_baseline = repmat(xform_jrgeco1aCorr_baseline,1,1,size(xform_jrgeco1aCorr,3),1);
            
            xform_jrgeco1aCorr= xform_jrgeco1aCorr-xform_jrgeco1aCorr_baseline;
            xform_jrgeco1a_mouse_NoGSR = cat(4,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1a(:,:,:,goodBlocks_NoGSR));
            clear xform_jrgeco1a
            xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr(:,:,:,goodBlocks_NoGSR));
            clear xform_jrgeco1aCorr
            xform_red_mouse_NoGSR = cat(4,xform_red_mouse_NoGSR,xform_red(:,:,:,goodBlocks_NoGSR));
            clear xform_red
            
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
            xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
            xform_jrgeco1aCorr_GSR_baseline = mean(xform_jrgeco1aCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
            xform_jrgeco1aCorr_GSR_baseline = repmat(xform_jrgeco1aCorr_GSR_baseline,1,1,size(xform_jrgeco1aCorr_GSR,3),1);
            
            xform_jrgeco1aCorr_GSR= xform_jrgeco1aCorr_GSR-xform_jrgeco1aCorr_GSR_baseline;
            
            xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
            
            if ~isempty(goodBlocks_GSR)
                disp('loading gsr data')
                xform_jrgeco1a_mouse_GSR = cat(4,xform_jrgeco1a_mouse_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
                clear xform_jrgeco1a_GSR
                
                xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
                clear xform_jrgeco1aCorr_GSR
                xform_red_mouse_GSR = cat(4,xform_red_mouse_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
                clear xform_red_GSR
                
                
            end
        end
    end
    xform_datahb_mouse_GSR = mean(xform_datahb_mouse_GSR,5);
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR','-v7.3');
    
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','-append');
    %save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','ROI_NoGSR','-v7.3');
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    
    xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
    xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
    xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
 
    
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','-append')
    texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
    
    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
    numDesample = size(xform_red_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    
     
    %
    xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
    xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
    xform_red_mouse_GSR = mean(xform_red_mouse_GSR,4);
    
    %
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1aCorr_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_red_mouse_GSR','-append')
    
    %
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
    
    
    disp('QC on GSR stim')
   [~,ROI_GSR] = QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_GSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mouse_GSR*100,xform_jrgeco1aCorr_mouse_GSR*100,xform_red_mouse_GSR*100,...
        xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[],[]);
    
    clear xform_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR
    
    disp('QC on non GSR stim')
       QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_GSR,[]);
    clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
    close all
end


close all;clearvars;clc

import mouse.*

numMice = length(excelRows);
excelRows = 441:442;
miceName = [];
catDir = 'J:\RGECO\OneCam\cat' ;

stimStartTime = 5;

nVx = 128;
nVy = 128;

xform_datahb_mice_GSR = [];
xform_datahb_mice_NoGSR = [];
%
xform_jrgeco1a_mice_GSR = [];
xform_jrgeco1a_mice_NoGSR = [];

xform_jrgeco1aCorr_mice_GSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];

xform_red_mice_GSR = [];
xform_red_mice_NoGSR = [];

xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    
    %     maskDir = saveDir;
    %     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain');
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    disp('loading  GRS data')
    sessionInfo.stimblocksize = excelRaw{11};
    load(fullfile(saveDir,processedName_mouse),...
        'xform_datahb_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR')
    if size(xform_datahb_mouse_GSR,1)>1
        xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
    end
    clear xform_datahb_mouse_GSR
    xform_jrgeco1a_mice_GSR = cat(4,xform_jrgeco1a_mice_GSR,xform_jrgeco1a_mouse_GSR);
    clear xform_jrgeco1a_mouse_GSR
    xform_jrgeco1aCorr_mice_GSR = cat(4,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_mouse_GSR);
    clear xform_jrgeco1aCorr_mouse_GSR
    xform_red_mice_GSR = cat(4,xform_red_mice_GSR,xform_red_mouse_GSR);
    clear xform_red_mouse_GSR
    disp('loading  Non GRS data')
    
    load(fullfile(saveDir,processedName_mouse),...
        'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR')
    xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
    clear xform_datahb_mouse_NoGSR
    xform_jrgeco1a_mice_NoGSR = cat(4,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1a_mouse_NoGSR);
    clear xform_jrgeco1a_mouse_NoGSR
    xform_jrgeco1aCorr_mice_NoGSR = cat(4,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR);
    clear xform_jrgeco1aCorr_mouse_NoGSR
    xform_red_mice_NoGSR = cat(4,xform_red_mice_NoGSR,xform_red_mouse_NoGSR);
    clear xform_red_mouse_NoGSR
    
end
xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');

save(fullfile(catDir,processedName_mice),'xform_datahb_mice_GSR','xform_datahb_mice_NoGSR','xform_isbrain_mice','-v7.3');
xform_jrgeco1a_mice_NoGSR = mean(xform_jrgeco1a_mice_NoGSR,4);
xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,4);
xform_red_mice_NoGSR = mean(xform_red_mice_NoGSR,4);

xform_jrgeco1aCorr_mice_NoGSR(isinf(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
xform_jrgeco1aCorr_mice_NoGSR(isnan(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
%
xform_jrgeco1a_mice_NoGSR(isinf(xform_jrgeco1a_mice_NoGSR)) = 0;
xform_jrgeco1a_mice_NoGSR(isnan(xform_jrgeco1a_mice_NoGSR)) = 0;
%
save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_NoGSR','xform_jrgeco1aCorr_mice_NoGSR','xform_red_mice_NoGSR','-append')
texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
numDesample = size(xform_red_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
factor = round(numDesample/1);
numDesample = factor*1;


QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
    [],[],[],xform_jrgeco1a_mice_NoGSR*100,xform_jrgeco1aCorr_mice_NoGSR*100,xform_red_mice_NoGSR*100,...
    xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_contour,[]);    clear xform_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR

xform_jrgeco1a_mice_GSR = mean(xform_jrgeco1a_mice_GSR,4);
xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,4);
xform_red_mice_GSR = mean(xform_red_mice_GSR,4);
%
save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_GSR','xform_jrgeco1aCorr_mice_GSR','xform_red_mice_GSR','-append')

texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
output_GSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_GSR'));

%
disp('QC on GSR stim')
[~,ROI_GSR] = QC_stim(squeeze(xform_datahb_mice_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_GSR(:,:,2,:))*10^6,...
    [],[],[],xform_jrgeco1a_mice_GSR*100,xform_jrgeco1aCorr_mice_GSR*100,xform_red_mice_GSR*100,...
    xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[],[]);

clear xofrm_datahb_mice_GSR xform_jrgeco1a_mice_GSR xform_jrgeco1aCorr_mice_GSR xform_red_mice_GSR  xform_FAD_mice_GSR xform_FADCorr_mice_GSR xform_green_mice_GSR



