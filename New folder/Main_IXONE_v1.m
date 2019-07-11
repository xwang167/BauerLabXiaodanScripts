
close all;clearvars;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;

excelRows = [29 31 34 35 36 37];
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
%     systemInfo = expSpecific.sysInfo(systemType);
%     mouseType = excelRaw{13};
%     sessionInfo =  expSpecific.sesInfo(mouseType);
%     sessionInfo.mouseType = mouseType;
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%         if exist(fullfile(saveDir,maskName))
%             disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
%             load(fullfile(saveDir,maskName), 'isbrain',  'I')
%         else
%     % need to be modified to see if WL exist
%     sessionInfo.darkFrameNum = excelRaw{11};
%     
%     sessionInfo.stimbaseline=excelRaw{9};
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.stimblocksize = excelRaw{8};
%     darkFrameInd = 2:sessionInfo.darkFrameNum;
%     fileName = fullfile(rawdataloc,recDate,strcat(recDate,'-',mouseName,'-',sessionType,'1.tif'));
%     
%     raw = read.readRaw(fileName,systemInfo.numLEDs,systemInfo.readFcn);
%     WL = preprocess.getWL(raw,darkFrameInd,[4 3 2]);
%     
%     %     wl = zeros(128,128,3);
%     %     wl(:,:,1)= read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+4);
%     %     wl(:,:,2) = read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+3);
%     %     wl(:,:,3) = read.readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+2);
%     
%     disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
%     [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
%     save(fullfile(saveDir,maskName), 'isbrain',  'I' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter')
%     isbrain_contour = bwperim(isbrain);
%     
%     figure;
%     imagesc(WL); %changed 3/1/1
%     axis off
%     axis image
%     title(strcat(recDate,'-',mouseName));
%     
%     for f=1:size(seedcenter,1)
%         hold on;
%         plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
%     end
%     hold on;
%     plot(I.tent(1,1),I.tent(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     plot(I.bregma(1,1),I.bregma(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     plot(I.OF(1,1),I.OF(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     contour(isbrain_contour,'r')
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
%       end
%     clearvars -except excelFile nVx nVy excelRows
%     close all;
% end
% 
% 
% 
% % Process raw data to get xform_datahb and xform_fluor(if needed)
% 
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
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
%     systemType = excelRaw{5};
%     systemInfo = expSpecific.sysInfo(systemType);
%     mouseType = excelRaw{13};
%     sessionInfo =  expSpecific.sesInfo(mouseType);
%     sessionInfo.mouseType = mouseType;
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     
%     sessionInfo.darkFrameNum = excelRaw{11};
%     
%     
%     sessionInfo.stimbaseline=excelRaw{9};
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.stimblocksize = excelRaw{8};
%     
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.freqout = sessionInfo.framerate;
%     darkFrameInd = 2:sessionInfo.darkFrameNum;
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%     load(fullfile(saveDir,maskName),'I','isbrain')
%     xform_isbrain = preprocess.affineTransform(isbrain,I);
%     
%     
%     
%     pkgDir = what('bauerParams');
%     ledDir = fullfile(pkgDir.path,'ledSpectra');
%     for ind = 1:numel(systemInfo.LEDFiles)
%         systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
%     end
%     
%     for n = 1:3
%         
%         
%         
%         
%         
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         if ~exist(fullfile(saveDir,processedName))
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%             if exist(fullfile(saveDir,rawName))
%                 disp(strcat('data already preprocessed for ',rawName ))
%                 load(fullfile(saveDir,rawName),'xform_raw')
%             else
%                 fileName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
%                 raw = read.readRaw(fullfile(rawdataloc,recDate,fileName),systemInfo.numLEDs,systemInfo.readFcn);
%                 time = 1:size(raw,4); time = time./sessionInfo.framerate;
%                 disp('preprocess raw');
%                 
%                 [time,xform_raw,raw] = fluor.preprocess(time,raw,systemInfo,sessionInfo,I,'darkFrameInd',darkFrameInd);
%                 
%                 save(fullfile(saveDir,rawName),'raw','xform_raw','-v7.3')
%                 
%             end
%             disp('get hemoglobin data');
%             
%             maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%             load(fullfile(saveDir,maskName), 'isbrain','I')
%             xform_isbrain = mouse.preprocess.affineTransform(isbrain,I);
%             xform_isbrain(isnan(xform_isbrain)) = 0;
%             xform_isbrain = logical(xform_isbrain);
%             save(fullfile(saveDir,maskName), 'xform_isbrain','-append')
%             
%             
%             
%             [xform_datahb, ~, ~]= mouse.preprocess.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),systemInfo.LEDFiles(sessionInfo.hbSpecies), xform_isbrain);
%             save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','-v7.3')
%             xform_fluor = xform_raw(:,:,sessionInfo.probeSpecies,:);
%             xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % detrending occurs
%             [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
%             
%             
%             disp('correct gcamp')
%             sessionInfo.exciteWavelength = 454; % nm
%             sessionInfo.emitgreenWavelength = 512; % nm
%             bluePath = 5.6E-2; % cm
%             greenPath = 5.7E-2; % cm
%             
%             greenLambdaInd = find(lambda == sessionInfo.exciteWavelength);
%             redLambdaInd = find(lambda == sessionInfo.emitgreenWavelength);
%             
%             
%             
%             hbOExtCoeff = extCoeff([greenLambdaInd redLambdaInd],1);
%             hbRExtCoeff = extCoeff([greenLambdaInd redLambdaInd],2);
%             xform_gcamp = xform_fluor;
%             xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
%                 hbOExtCoeff,hbRExtCoeff,bluePath,greenPath);
%             
%             save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','-append')
%             
%         else
%             disp(strcat('OIS data already processed for ',processedName))
%             C = who('-file',fullfile(saveDir,processedName));
%             isFluorGot = false;
%             for  k=1:length(C)
%                 if strcmp(C(k),'xform_gcamp')
%                     isFluorGot = true;
%                 end
%             end
%             if ~isFluorGot
%                 disp('get fluor data');
%                 
%                 load(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo')
%                 rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%                 load(fullfile(saveDir,rawName),'xform_raw')
%                 xform_fluor = xform_raw(:,:,sessionInfo.probeSpecies,:);
%                 xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % detrending occurs
%                 [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));
%                 
%                 
%                 disp('correct gcamp')
%                 sessionInfo.exciteWavelength = 454; % nm
%                 sessionInfo.emitgreenWavelength = 512; % nm
%                 bluePath = 5.6E-2; % cm
%                 greenPath = 5.7E-2; % cm
%                 
%                 greenLambdaInd = find(lambda == sessionInfo.exciteWavelength);
%                 redLambdaInd = find(lambda == sessionInfo.emitgreenWavelength);
%                 
%                 
%                 
%                 hbOExtCoeff = extCoeff([greenLambdaInd redLambdaInd],1);
%                 hbRExtCoeff = extCoeff([greenLambdaInd redLambdaInd],2);
%                 xform_gcamp = xform_fluor;
%                 xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
%                     hbOExtCoeff,hbRExtCoeff,bluePath,greenPath);
%                 
%                 save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','-append')
%             else
%                 disp(strcat('gcamp data already processed for ',processedName))
%             end
%             
%         end
%         
%     end
%     
% end





R_oxy_ISA_mice = [];
R_fluorCorr_ISA_mice = [];
R_oxy_Delta_mice = [];
R_fluorCorr_Delta_mice = [];


Rs_oxy_ISA_mice = [];
Rs_fluorCorr_ISA_mice = [];
Rs_oxy_Delta_mice = [];
Rs_fluorCorr_Delta_mice = [];
mouseName_cat = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    mouseName_cat = strcat(mouseName_cat," ",mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    sessionInfo.framerate = excelRaw{7};
    if strcmp(sessionType,'fc')
        R_oxy_ISA_runs = [];
        R_fluorCorr_ISA_runs = [];
        R_oxy_Delta_runs = [];
        R_fluorCorr_Delta_runs = [];
        
        
        Rs_oxy_ISA_runs = [];
        Rs_fluorCorr_ISA_runs = [];
        Rs_oxy_Delta_runs = [];
        Rs_fluorCorr_Delta_runs = [];
    end
    for n = 1:3
%         rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%         load(fullfile(saveDir,rawName),'raw')
%         disp(strcat('QC raw for ',rawName))
       visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         QCcheck_raw(raw,isbrain,systemType,sessionInfo.framerate,saveDir,visName)
        disp('loading processed data')
         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','sessionInfo')
        
        if strcmp(sessionType,'fc')
            oxy = double(squeeze(xform_datahb(:,:,1,:)));
            gcampCorr = double(squeeze(xform_gcampCorr));
            [R_oxy_ISA, Rs_oxy_ISA,R_gcampCorr_ISA,Rs_gcampCorr_ISA,R_oxy_Delta, Rs_oxy_Delta,R_gcampCorr_Delta, Rs_gcampCorr_Delta,oxy_ISA,oxy_Delta,gcampCorr_ISA,gcampCorr_Delta] = QCcheck_fc(oxy,gcampCorr,'gcamp',xform_isbrain, sessionInfo,saveDir,visName);
            
            save(strcat(fullfile(saveDir,visName),".mat"),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA', 'Rs_gcampCorr_ISA','R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta','oxy_ISA','oxy_Delta','gcampCorr_ISA','gcampCorr_Delta', '-append');
            
            
            R_oxy_ISA_runs = cat(4,R_oxy_ISA_runs,R_oxy_ISA);
            R_fluorCorr_ISA_runs = cat(4,R_fluorCorr_ISA_runs,R_gcampCorr_ISA);
            R_oxy_Delta_runs = cat(4,R_oxy_Delta_runs,R_oxy_Delta);
            R_fluorCorr_Delta_runs = cat(4,R_fluorCorr_Delta_runs,R_gcampCorr_Delta);
            Rs_oxy_ISA_runs = cat(3,Rs_oxy_ISA_runs,Rs_oxy_ISA);
            Rs_fluorCorr_ISA_runs = cat(3,Rs_fluorCorr_ISA_runs,Rs_gcampCorr_ISA);
            Rs_oxy_Delta_runs = cat(3,Rs_oxy_Delta_runs,Rs_oxy_Delta);
            Rs_fluorCorr_Delta_runs = cat(3,Rs_fluorCorr_Delta_runs,Rs_gcampCorr_Delta);
        end
    end
    if strcmp(sessionType,'fc')
        
        R_oxy_ISA_runs = mean(R_oxy_ISA_runs,4);
        R_fluorCorr_ISA_runs = mean(R_fluorCorr_ISA_runs,4);
        R_oxy_Delta_runs = mean(R_oxy_Delta_runs ,4);
        R_fluorCorr_Delta_runs = mean(R_fluorCorr_Delta_runs,4);
        
        Rs_oxy_ISA_runs = mean(Rs_oxy_ISA_runs,3);
        Rs_fluorCorr_ISA_runs = mean(Rs_fluorCorr_ISA_runs,3);
        Rs_oxy_Delta_runs = mean(Rs_oxy_Delta_runs ,3);
        Rs_fluorCorr_Delta_runs = mean(Rs_fluorCorr_Delta_runs,3);
        visName = strcat(recDate,'-',mouseName,'-',sessionType);
        refseeds=GetReferenceSeeds;
        refseeds = refseeds(1:14,:);
        QCcheck_fcVis(refseeds,R_oxy_ISA_runs, Rs_oxy_ISA_runs,R_fluorCorr_ISA_runs,Rs_fluorCorr_ISA_runs, R_oxy_Delta_runs, Rs_oxy_Delta_runs,R_fluorCorr_Delta_runs, Rs_fluorCorr_Delta_runs,'gcamp',saveDir,visName)
        
        R_oxy_ISA_mice = cat(4,R_oxy_ISA_mice,R_oxy_ISA_runs);
        R_fluorCorr_ISA_mice = cat(4,R_fluorCorr_ISA_mice,R_fluorCorr_ISA_runs);
        R_oxy_Delta_mice = cat(4,R_oxy_Delta_mice,R_oxy_Delta_runs);
        R_fluorCorr_Delta_mice = cat(4,R_fluorCorr_Delta_mice,R_fluorCorr_Delta_runs);
        
        Rs_oxy_ISA_mice = cat(3,Rs_oxy_ISA_mice,Rs_oxy_ISA_runs);
        Rs_fluorCorr_ISA_mice = cat(3,Rs_fluorCorr_ISA_mice,Rs_fluorCorr_ISA_runs);
        Rs_oxy_Delta_mice = cat(3,Rs_oxy_Delta_mice,Rs_oxy_Delta_runs);
        Rs_fluorCorr_Delta_mice = cat(3,Rs_fluorCorr_Delta_mice,Rs_fluorCorr_Delta_runs);
    end
    
end

R_oxy_ISA_mice = mean(R_oxy_ISA_mice,4);
R_fluorCorr_ISA_mice = mean(R_fluorCorr_ISA_mice,4);
R_oxy_Delta_mice = mean(R_oxy_Delta_mice ,4);
R_fluorCorr_Delta_mice = mean(R_fluorCorr_Delta_mice,4);

Rs_oxy_ISA_mice = mean(Rs_oxy_ISA_mice,3);
Rs_fluorCorr_ISA_mice = mean(Rs_fluorCorr_ISA_mice,3);
Rs_oxy_Delta_mice = mean(Rs_oxy_Delta_mice ,3);
Rs_fluorCorr_Delta_mice = mean(Rs_fluorCorr_Delta_mice,3);
saveDir = fullfile(string(excelRaw{4}),'cat');
QCcheck_fcVis_v1(refseeds,R_oxy_ISA_mice, Rs_oxy_ISA_mice,R_fluorCorr_ISA_mice,Rs_fluorCorr_ISA_mice, 'gcamp','ISA',saveDir,mouseName_cat)
QCcheck_fcVis_v1(refseeds,R_oxy_Delta_mice, Rs_oxy_Delta_mice,R_fluorCorr_Delta_mice, Rs_fluorCorr_Delta_mice, 'gcamp','Delta',saveDir,mouseName_cat)

