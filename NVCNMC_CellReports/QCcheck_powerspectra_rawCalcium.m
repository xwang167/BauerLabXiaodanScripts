excelRows = [181 183 185 228 232 236];
% excelRows = [ 195 202 204 230 234 240];
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
saveDir_cat = "E:\RGECO\cat\";
% excelRows = 4:4:24;
% excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
% saveDir_cat = "X:\Paper1\WT_Paper1\cat\";
% excelFile = "X:\Paper1\WT\WT.xlsx";
% %excelRows = [2,4,7,11,14];
% excelRows = [3,5,8,12,15];
% saveDir_cat = "X:\Paper1\WT\cat\";
runs = 1:3;
%%
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'xform_jrgeco1a')
        xform_jrgeco1a= real(double(xform_jrgeco1a));
        disp('calculate pds')
        [~,powerdata_jrgeco1a] = QCcheck_CalcPDS(xform_jrgeco1a/0.01,sessionInfo.framerate,xform_isbrain);
        [~,powerdata_average_jrgeco1a] = QCcheck_CalcPDSAverage(xform_jrgeco1a/0.01,sessionInfo.framerate,xform_isbrain);
        clear xform_jrgeco1a
        save(fullfile(saveDir, processedName),'powerdata_jrgeco1a','powerdata_average_jrgeco1a','-append')
        clear powerdata_jrgeco1a powerdata_average_jrgeco1a
    end
    close all
end

%% mouse average for raw calcium
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
    powerdata_average_jrgeco1a_mouse = [];
    powerdata_jrgeco1a_mouse = [];
    for n = runs
        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'powerdata_jrgeco1a','powerdata_average_jrgeco1a')
        powerdata_jrgeco1a_mouse = cat(1,powerdata_jrgeco1a_mouse,squeeze(powerdata_jrgeco1a));
        powerdata_average_jrgeco1a_mouse = cat(1,powerdata_average_jrgeco1a_mouse,squeeze(powerdata_average_jrgeco1a'));
    end
    powerdata_average_jrgeco1a_mouse = mean(powerdata_average_jrgeco1a_mouse,1);
    powerdata_jrgeco1a_mouse = mean(powerdata_jrgeco1a_mouse,1);

    if exist(fullfile(saveDir, processedName_mouse),'file')
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_jrgeco1a_mouse','powerdata_jrgeco1a_mouse','-append')
    else
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_jrgeco1a_mouse','powerdata_jrgeco1a_mouse')
    end
end

%% mouse average for corrected calcium
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
    powerdata_average_jrgeco1aCorr_mouse = [];
    powerdata_jrgeco1aCorr_mouse = [];
    for n = runs
        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'powerdata_jrgeco1aCorr','powerdata_average_jrgeco1aCorr')
        powerdata_jrgeco1aCorr_mouse = cat(1,powerdata_jrgeco1aCorr_mouse,squeeze(powerdata_jrgeco1aCorr));
        powerdata_average_jrgeco1aCorr_mouse = cat(1,powerdata_average_jrgeco1aCorr_mouse,squeeze(powerdata_average_jrgeco1aCorr'));
    end
    powerdata_average_jrgeco1aCorr_mouse = mean(powerdata_average_jrgeco1aCorr_mouse,1);
    powerdata_jrgeco1aCorr_mouse = mean(powerdata_jrgeco1aCorr_mouse,1);

    if exist(fullfile(saveDir, processedName_mouse),'file')
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_jrgeco1aCorr_mouse','powerdata_jrgeco1aCorr_mouse','-append')
    else
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_jrgeco1aCorr_mouse','powerdata_jrgeco1aCorr_mouse')
    end
end

%% mouse visualization
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir, processedName_mouse),'powerdata_jrgeco1a_mouse')
    figure
    loglog(hz',powerdata_jrgeco1a_mouse)
    title(strcat(mouseName,'Raw jRGECO1a'))
    
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-powerdata-jrgeco1a-mouse.png')))
end

%% mice average for raw calcium
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
powerdata_average_jrgeco1a_mice = [];
powerdata_jrgeco1a_mice = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_average_jrgeco1a_mouse','powerdata_jrgeco1a_mouse')
    powerdata_average_jrgeco1a_mice = cat(1,powerdata_average_jrgeco1a_mice,squeeze(powerdata_average_jrgeco1a_mouse));
    powerdata_jrgeco1a_mice = cat(1,powerdata_jrgeco1a_mice,squeeze(powerdata_jrgeco1a_mouse));
end
powerdata_average_jrgeco1a_mice = mean(powerdata_average_jrgeco1a_mice,1);
powerdata_jrgeco1a_mice = mean(powerdata_jrgeco1a_mice,1);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

if exist(fullfile(saveDir_cat, processedName_mice),'file')
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1a_mice','powerdata_jrgeco1a_mice','-append')
else
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1a_mice','powerdata_jrgeco1a_mice')
end

%% mice average for corrected mice
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
powerdata_average_jrgeco1aCorr_mice = [];
powerdata_jrgeco1aCorr_mice = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_average_jrgeco1aCorr_mouse','powerdata_jrgeco1aCorr_mouse')
    powerdata_average_jrgeco1aCorr_mice = cat(1,powerdata_average_jrgeco1aCorr_mice,squeeze(powerdata_average_jrgeco1aCorr_mouse));
    powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));
end
powerdata_average_jrgeco1aCorr_mice = mean(powerdata_average_jrgeco1aCorr_mice,1);
powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

if exist(fullfile(saveDir_cat, processedName_mice),'file')
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1aCorr_mice','powerdata_jrgeco1aCorr_mice','-append')
else
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1aCorr_mice','powerdata_jrgeco1aCorr_mice')
end

%% Visualization

% set color for lines https://experience.sap.com/fiori-design-ios/article/colors/
dr = "#5A0404";
lr = "#FF5C77";

dg = "#12171C";
lg = "#8396A8";
% Awake
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_jrgeco1a_mice')
powerdata_jrgeco1a_mice_RGECO_awake = powerdata_jrgeco1a_mice;
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_jrgeco1aCorr_mice')
powerdata_jrgeco1aCorr_mice_RGECO_awake = powerdata_jrgeco1aCorr_mice;

load("X:\Paper1\WT\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-fc.mat", 'powerdata_jrgeco1a_mice', 'powerdata_jrgeco1aCorr_mice')
powerdata_jrgeco1a_mice_WT_awake = powerdata_jrgeco1a_mice;
powerdata_jrgeco1aCorr_mice_WT_awake = powerdata_jrgeco1aCorr_mice;

figure
loglog(hz',powerdata_jrgeco1aCorr_mice_RGECO_awake,'color',dr)
hold on
loglog(hz',powerdata_jrgeco1a_mice_RGECO_awake,'color',lr)
hold on
loglog(hz',powerdata_jrgeco1aCorr_mice_WT_awake,'color',dg)
hold on
loglog(hz',powerdata_jrgeco1a_mice_WT_awake,'color',lg)
xlim([0.01 10])
legend('Corrected jrgeco1a Em CMOS2','Raw jrgeco1a Em CMOS2','Corrected CMOS2 signal in C57BL/6J mice','Raw CMOS2 signal in C57BL/6J mice')
title('Awake, jRGECO1a')
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
ylim([-inf 10000])

% Anes
load("E:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat", 'powerdata_jrgeco1a_mice','powerdata_jrgeco1aCorr_mice')
powerdata_jrgeco1a_mice_RGECO_anes = powerdata_jrgeco1a_mice;
powerdata_jrgeco1aCorr_mice_RGECO_anes = powerdata_jrgeco1aCorr_mice;

load("X:\Paper1\WT\cat\210830--W30M1-anes-W30M2-anes-W30M3-anes-W31M1-anes-W31M2-anes-fc.mat",'powerdata_jrgeco1a_mice','powerdata_jrgeco1aCorr_mice')
powerdata_jrgeco1a_mice_WT_anes = powerdata_jrgeco1a_mice;
powerdata_jrgeco1aCorr_mice_WT_anes = powerdata_jrgeco1aCorr_mice;

figure
loglog(hz',powerdata_jrgeco1aCorr_mice_RGECO_anes,'color',dr)
hold on
loglog(hz',powerdata_jrgeco1a_mice_RGECO_anes,'color',lr)
hold on
loglog(hz',powerdata_jrgeco1aCorr_mice_WT_anes,'color',dg)
hold on
loglog(hz',powerdata_jrgeco1a_mice_WT_anes,'color',lg)
xlim([0.01 10])
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
legend('Corrected jrgeco1a Em CMOS2','Raw jrgeco1a Em CMOS2','Corrected CMOS2 signal in C57BL/6J mice','Raw CMOS2 signal in C57BL/6J mice')
title('Anesthetized, jRGECO1a')
ylim([-inf 100000])