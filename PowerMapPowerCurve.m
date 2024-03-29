import mouse.*

excelFile = "L:\RGECO\RGECO.xlsx";
%excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 11:13;%:450;
runs = 1:3;
% 
% for excelRow = excelRows
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
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
%     else
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
%     end
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName),'xform_datahb')
%         disp(strcat('fc QC check on ', processedName))
%         load(fullfile(saveDir, processedName),'xform_FADCorr','xform_FAD',...
%             'xform_jrgeco1aCorr','xform_jrgeco1a')
%         sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
%         sessionInfo.bandtype_Delta = {"Delta",0.4,4};
%         total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
%         
%         %                         disp('calculate pds')
%         xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
%         xform_FADCorr = real(double(xform_FADCorr));
%         total = real(double(total));
%         xform_datahb = real(double(xform_datahb));
%         [hz,powerdata_jrgeco1a] = QCcheck_CalcPDS(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
%         [~,powerdata_FADCorr] = QCcheck_CalcPDS(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
%         [~,powerdata_FAD] = QCcheck_CalcPDS(xform_FAD/0.01,sessionInfo.framerate,xform_isbrain);
%         [~,powerdata_total] = QCcheck_CalcPDS(total*10^6,sessionInfo.framerate,xform_isbrain);
%         [~,powerdata_oxy] = QCcheck_CalcPDS((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
%         [~,powerdata_deoxy] = QCcheck_CalcPDS(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
%         
%         clear xform_datahb
%         
%         
%         disp('calculate power map')
%         jrgeco1a_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%         FAD_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_FAD)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%         FADCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%         total_ISA_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%         
%         jrgeco1a_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%         FADCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%         FAD_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_FAD)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%         total_Delta_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%         save(fullfile(saveDir, processedName),'powerdata_jrgeco1a','powerdata_FADCorr','powerdata_FAD','powerdata_total','powerdata_oxy','powerdata_deoxy',......
%             'FADCorr_ISA_powerMap','total_ISA_powerMap','FADCorr_Delta_powerMap','total_Delta_powerMap',...
%             'jrgeco1a_Delta_powerMap','FAD_Delta_powerMap','jrgeco1a_ISA_powerMap','FAD_ISA_powerMap','hz','-append')
%         
%         
%         nameString = fullfile(saveDir,visName);
%         
%         
%         leftData = cell(3,1);
%         leftData{1} = double(powerdata_FAD);
%         leftData{2} = powerdata_jrgeco1a;
%         leftData{3} = powerdata_FADCorr;
%         
%         rightData = cell(3,1);
%         rightData{1} = powerdata_oxy;
%         rightData{2} = powerdata_deoxy;
%         rightData{3} = powerdata_total;
%         
%         leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%         rightLabel = 'Hb(\muM^2/Hz)';
%         leftLineStyle = {'y-','m-','g-'};
%         rightLineStyle= {'r-','b-','k-'};
%         legendName = ["Raw FAD","red-cam2","Corrected FAD","HbO","HbR","HbT"];
%         
%         
%         QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve'))
%         
%         QCcheck_powerMapVis_dB(jrgeco1a_ISA_powerMap,xform_isbrain,saveDir,strcat(visName, '_RawRGECOISA'))
%         QCcheck_powerMapVis_dB(FADCorr_ISA_powerMap,xform_isbrain,saveDir,strcat(visName, '_FADISA'))
%         QCcheck_powerMapVis_dB(FAD_ISA_powerMap,xform_isbrain,saveDir,strcat(visName, '_RawFADISA'))
%         QCcheck_powerMapVis_dB(total_ISA_powerMap,xform_isbrain,saveDir,strcat(visName, "_TotalISA"))
%         
%         QCcheck_powerMapVis_dB(jrgeco1a_Delta_powerMap,xform_isbrain,saveDir,strcat(visName, "_RawRGECODelta"))
%         QCcheck_powerMapVis_dB(FADCorr_Delta_powerMap,xform_isbrain,saveDir,strcat(visName,"_FADDelta"))
%         QCcheck_powerMapVis_dB(FAD_Delta_powerMap,xform_isbrain,saveDir,strcat(visName,"_RawFADDelta"))
%         QCcheck_powerMapVis_dB(total_Delta_powerMap,xform_isbrain,saveDir,strcat(visName,"_TotalDelta"))
%         
%         close all
%     end
% end



% excelRows = 11:13;%:450;
% runs = 1:3;
% length_runs = 3;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     rawdataloc = excelRaw{3};
%     info.nVx = 128;
%     info.nVy = 128;
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     goodRuns = str2num(excelRaw{18});
%     
%     if strcmp(char(sessionInfo.mouseType),'WT')
%         systemInfo.numLEDs = 2;
%     elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
%         systemInfo.numLEDs = 3;
%     end
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))
%         
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');
%         
%     else
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%         load(fullfile(saveDir,maskName), 'xform_isbrain')
%     end
%     xform_isbrain(xform_isbrain ==2)=1;
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
%     
%     
%     total_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     total_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     
%     powerdata_oxy_mouse = [];
%     powerdata_deoxy_mouse = [];
%     powerdata_total_mouse = [];
%     
%     
%     jrgeco1a_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     jrgeco1a_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     powerdata_average_jrgeco1a_mouse = [];
%     powerdata_jrgeco1a_mouse = [];
%     
%     FADCorr_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     FADCorr_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     powerdata_average_FADCorr_mouse = [];
%     powerdata_FADCorr_mouse = [];
%     
%     FAD_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     FAD_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
%     powerdata_average_FAD_mouse = [];
%     powerdata_FAD_mouse = [];
%     
%     for n = runs
%         
%         
%         disp('loading processed data')
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         
%         load(fullfile(saveDir, processedName),'powerdata_jrgeco1a','powerdata_FADCorr','powerdata_FAD','powerdata_total','powerdata_oxy','powerdata_deoxy',...
%             'FADCorr_ISA_powerMap','total_ISA_powerMap','FADCorr_Delta_powerMap','total_Delta_powerMap',...
%             'jrgeco1a_Delta_powerMap','FAD_Delta_powerMap','jrgeco1a_ISA_powerMap','FAD_ISA_powerMap','hz')
%         
%         total_Delta_powerMap_mouse(:,:,n) = total_Delta_powerMap;
%         total_ISA_powerMap_mouse(:,:,n) = total_ISA_powerMap;
%         
%         powerdata_jrgeco1a_mouse = cat(1,powerdata_jrgeco1a_mouse,squeeze(powerdata_jrgeco1a));
%         powerdata_FADCorr_mouse = cat(1,powerdata_FADCorr_mouse,squeeze(powerdata_FADCorr));
%         powerdata_FAD_mouse = cat(1,powerdata_FAD_mouse,squeeze(powerdata_FAD));
%         powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
%         powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
%         powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));
%         
%         
%         jrgeco1a_Delta_powerMap_mouse(:,:,n) = jrgeco1a_Delta_powerMap;
%         jrgeco1a_ISA_powerMap_mouse(:,:,n) = jrgeco1a_ISA_powerMap;
%         
%         FADCorr_Delta_powerMap_mouse(:,:,n) = FADCorr_Delta_powerMap;
%         FADCorr_ISA_powerMap_mouse(:,:,n) = FADCorr_ISA_powerMap;
%         
%         FAD_Delta_powerMap_mouse(:,:,n) = FAD_Delta_powerMap;
%         FAD_ISA_powerMap_mouse(:,:,n) = FAD_ISA_powerMap;
%     end
%     
%     
%     powerdata_oxy_mouse = mean(powerdata_oxy_mouse,1);
%     powerdata_deoxy_mouse = mean(powerdata_deoxy_mouse,1);
%     powerdata_total_mouse = mean(powerdata_total_mouse,1);
%     
%     total_Delta_powerMap_mouse = mean(total_Delta_powerMap_mouse,3);
%     total_ISA_powerMap_mouse = mean(total_ISA_powerMap_mouse,3);
%     disp(char(['QC check on ', processedName_mouse]))
%     
%     jrgeco1a_Delta_powerMap_mouse = mean(jrgeco1a_Delta_powerMap_mouse,3);
%     jrgeco1a_ISA_powerMap_mouse = mean(jrgeco1a_ISA_powerMap_mouse,3);
%     
%     FADCorr_Delta_powerMap_mouse = mean(FADCorr_Delta_powerMap_mouse,3);
%     FADCorr_ISA_powerMap_mouse = mean(FADCorr_ISA_powerMap_mouse,3);
%     
%     FAD_Delta_powerMap_mouse = mean(FAD_Delta_powerMap_mouse,3);
%     FAD_ISA_powerMap_mouse = mean(FAD_ISA_powerMap_mouse,3);
%     
%     save(fullfile(saveDir, processedName_mouse),...
%         'total_ISA_powerMap_mouse','jrgeco1a_ISA_powerMap_mouse','FADCorr_ISA_powerMap_mouse','FAD_ISA_powerMap_mouse',...
%         'total_Delta_powerMap_mouse','jrgeco1a_Delta_powerMap_mouse','FADCorr_Delta_powerMap_mouse','FAD_Delta_powerMap_mouse')
%     visName = strcat(recDate,'-',mouseName,'-',sessionType);
%     
%     powerdata_jrgeco1a_mouse = mean(powerdata_jrgeco1a_mouse,1);
%     powerdata_FADCorr_mouse = mean(powerdata_FADCorr_mouse,1);
%     powerdata_FAD_mouse = mean(powerdata_FAD_mouse,1);
%     save(fullfile(saveDir, processedName_mouse),...
%         'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_total_mouse',...
%         'powerdata_jrgeco1a_mouse','powerdata_FADCorr_mouse','powerdata_FAD_mouse','hz','-append')
%     leftData = cell(3,1);
%     leftData{1} = double(powerdata_FAD_mouse);
%     leftData{2} = powerdata_jrgeco1a_mouse;
%     leftData{3} = powerdata_FADCorr_mouse;
%     
%     
%     rightData = cell(3,1);
%     rightData{1} = powerdata_oxy_mouse;
%     rightData{2} = powerdata_deoxy_mouse;
%     rightData{3} = powerdata_total_mouse;
%     
%     leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%     rightLabel = 'Hb(\muM^2/Hz)';
%     leftLineStyle = {'y-','m-','g-'};
%     rightLineStyle= {'r-','b-','k-'};
%     legendName = ["Raw FAD","red-cam2","Corrected FAD","HbO","HbR","HbT"];
%     
%     QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve'))
%     
%     QCcheck_powerMapVis_dB(jrgeco1a_ISA_powerMap_mouse,xform_isbrain,saveDir,strcat(visName, '_RawRGECOISA'))
%     QCcheck_powerMapVis_dB(FADCorr_ISA_powerMap_mouse,xform_isbrain,saveDir,strcat(visName, '_FADISA'))
%     QCcheck_powerMapVis_dB(FAD_ISA_powerMap_mouse,xform_isbrain,saveDir,strcat(visName, '_RawFADISA'))
%     QCcheck_powerMapVis_dB(total_ISA_powerMap_mouse,xform_isbrain,saveDir,strcat(visName, "_TotalISA"))
%     
%     QCcheck_powerMapVis_dB(jrgeco1a_Delta_powerMap_mouse,xform_isbrain,saveDir,strcat(visName, "_RawRGECODelta"))
%     QCcheck_powerMapVis_dB(FADCorr_Delta_powerMap_mouse,xform_isbrain,saveDir,strcat(visName,"_FADDelta"))
%     QCcheck_powerMapVis_dB(FAD_Delta_powerMap_mouse,xform_isbrain,saveDir,strcat(visName,"_RawFADDelta"))
%     QCcheck_powerMapVis_dB(total_Delta_powerMap_mouse,xform_isbrain,saveDir,strcat(visName,"_TotalDelta"))
%     
%     close all
% end






close all;clearvars -except hz;clc
import mice.*
excelFile = "L:\RGECO\RGECO.xlsx";
%excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 8:13;%:450;

isZTransform = true;
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;

numMice = length(excelRows);
saveDir_cat = 'L:\RGECO\cat';
powerdata_oxy_mice = [];
powerdata_deoxy_mice = [];
powerdata_total_mice = [];

powerdata_jrgeco1a_mice = [];
powerdata_FADCorr_mice = [];
powerdata_FAD_mice = [];
%

total_Delta_powerMap_mice = nan(128,128,numMice);
total_ISA_powerMap_mice = nan(128,128,numMice);
jrgeco1a_Delta_powerMap_mice = nan(128,128,numMice);
jrgeco1a_ISA_powerMap_mice = nan(128,128,numMice);
FADCorr_Delta_powerMap_mice = nan(128,128,numMice);
FADCorr_ISA_powerMap_mice = nan(128,128,numMice);
FAD_Delta_powerMap_mice = nan(128,128,numMice);
FAD_ISA_powerMap_mice = nan(128,128,numMice);
xform_isbrain_mice = ones(128,128);
miceName = [];
miceName_powerdata = [];
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    goodRuns = str2num(excelRaw{18});

    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    %    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_jrgeco1a_mouse','powerdata_total_mouse','powerdata_FADCorr_mouse','powerdata_FAD_mouse',...
        'total_Delta_powerMap_mouse','total_ISA_powerMap_mouse','jrgeco1a_Delta_powerMap_mouse','jrgeco1a_ISA_powerMap_mouse',...
        'FADCorr_Delta_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
        'FAD_Delta_powerMap_mouse','FAD_ISA_powerMap_mouse','hz')
    
    total_Delta_powerMap_mice(:,:,ll) = total_Delta_powerMap_mouse;
    total_ISA_powerMap_mice(:,:,ll) = total_ISA_powerMap_mouse;
    %
    
    miceName_powerdata =  char(strcat(miceName_powerdata, '-', mouseName));
    powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
    
    powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
    powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
    powerdata_jrgeco1a_mice = cat(1,powerdata_jrgeco1a_mice,squeeze(powerdata_jrgeco1a_mouse));
    powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr_mouse));
    powerdata_FAD_mice = cat(1,powerdata_FAD_mice,squeeze(powerdata_FAD_mouse));
    jrgeco1a_Delta_powerMap_mice(:,:,ll) = jrgeco1a_Delta_powerMap_mouse;
    jrgeco1a_ISA_powerMap_mice(:,:,ll) = jrgeco1a_ISA_powerMap_mouse;
    
    FADCorr_Delta_powerMap_mice(:,:,ll) = FADCorr_Delta_powerMap_mouse;
    FADCorr_ISA_powerMap_mice(:,:,ll) = FADCorr_ISA_powerMap_mouse;
    FAD_Delta_powerMap_mice(:,:,ll) = FAD_Delta_powerMap_mouse;
    FAD_ISA_powerMap_mice(:,:,ll) = FAD_ISA_powerMap_mouse;
    
    ll = ll+1;
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');




powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
powerdata_total_mice = mean(powerdata_total_mice,1);

powerdata_jrgeco1a_mice = mean(powerdata_jrgeco1a_mice,1);
powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);
powerdata_FAD_mice = mean(powerdata_FAD_mice,1);


total_Delta_powerMap_mice = mean(total_Delta_powerMap_mice,3);
total_ISA_powerMap_mice = mean(total_ISA_powerMap_mice,3);

jrgeco1a_Delta_powerMap_mice = mean(jrgeco1a_Delta_powerMap_mice,3);
jrgeco1a_ISA_powerMap_mice = mean(jrgeco1a_ISA_powerMap_mice,3);

FADCorr_Delta_powerMap_mice = mean(FADCorr_Delta_powerMap_mice,3);
FADCorr_ISA_powerMap_mice = mean(FADCorr_ISA_powerMap_mice,3);

FAD_Delta_powerMap_mice = mean(FAD_Delta_powerMap_mice,3);
FAD_ISA_powerMap_mice = mean(FAD_ISA_powerMap_mice,3);

save(fullfile(saveDir_cat, processedName_mice), 'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice',...
    'powerdata_jrgeco1a_mice','powerdata_FADCorr_mice','powerdata_FAD_mice',...
    'total_ISA_powerMap_mice','jrgeco1a_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice','FAD_ISA_powerMap_mice',...
    'total_Delta_powerMap_mice','jrgeco1a_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice','FAD_Delta_powerMap_mice',...
    'hz')

disp(strcat('QC check on ', processedName_mice))
    visName = 'Anes RGECO';  
        leftData = cell(3,1);
    leftData{1} = double(powerdata_FAD_mice);
    leftData{2} = powerdata_jrgeco1a_mice;
    leftData{3} = powerdata_FADCorr_mice;
    
    
    rightData = cell(3,1);
    rightData{1} = powerdata_oxy_mice;
    rightData{2} = powerdata_deoxy_mice;
    rightData{3} = powerdata_total_mice;
    
    leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
    rightLabel = 'Hb(\muM^2/Hz)';
    leftLineStyle = {'y-','m-','g-'};
    rightLineStyle= {'r-','b-','k-'};
    legendName = ["Raw FAD","red-cam2","Corrected FAD","HbO","HbR","HbT"];
  
    QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(miceName_powerdata, '_powerCurve'))
  
    QCcheck_powerMapVis(jrgeco1a_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RawRGECOISA'))
    QCcheck_powerMapVis(FADCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA'))
    QCcheck_powerMapVis(FAD_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RawFADISA'))
    QCcheck_powerMapVis(total_ISA_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA"))

    QCcheck_powerMapVis(jrgeco1a_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RawRGECODelta"))
    QCcheck_powerMapVis(FADCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta"))
    QCcheck_powerMapVis(FAD_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_RawFADDelta"))
    QCcheck_powerMapVis(total_Delta_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta"))
