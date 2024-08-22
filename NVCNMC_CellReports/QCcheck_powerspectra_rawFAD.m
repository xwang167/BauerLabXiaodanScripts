% excelRows = [ 195 202 204 230 234 240];
% excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
% saveDir_cat = "E:\RGECO\cat\";
% excelRows = 4:4:24;
% excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
% saveDir_cat = "X:\Paper1\WT_Paper1\cat\";
excelFile = "X:\Paper1\WT\WT.xlsx";
excelRows = [2,4,7,11,14];
saveDir_cat = "X:\Paper1\WT\cat\";
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
        load(fullfile(saveDir, processedName),'xform_FAD')
        xform_FAD= real(double(xform_FAD));
        disp('calculate pds')
        [~,powerdata_FAD] = QCcheck_CalcPDS(xform_FAD/0.01,sessionInfo.framerate,xform_isbrain);
        [~,powerdata_average_FAD] = QCcheck_CalcPDSAverage(xform_FAD/0.01,sessionInfo.framerate,xform_isbrain);
        clear xform_FAD
        save(fullfile(saveDir, processedName),'powerdata_FAD','powerdata_average_FAD','-append')
        clear powerdata_FAD powerdata_average_FAD
    end
    close all
end

%% mouse average
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
    powerdata_average_FAD_mouse = [];
    powerdata_FAD_mouse = [];
    for n = runs
        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'powerdata_FAD','powerdata_average_FAD')
        powerdata_FAD_mouse = cat(1,powerdata_FAD_mouse,squeeze(powerdata_FAD));
        powerdata_average_FAD_mouse = cat(1,powerdata_average_FAD_mouse,squeeze(powerdata_average_FAD'));
    end
    powerdata_average_FAD_mouse = mean(powerdata_average_FAD_mouse,1);
    powerdata_FAD_mouse = mean(powerdata_FAD_mouse,1);

    if exist(fullfile(saveDir, processedName_mouse),'file')
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_FAD_mouse','powerdata_FAD_mouse','-append')
    else
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_FAD_mouse','powerdata_FAD_mouse')
    end
end

%% mouse average
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
    powerdata_average_FADCorr_mouse = [];
    powerdata_FADCorr_mouse = [];
    for n = runs
        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'powerdata_FADCorr','powerdata_average_FADCorr')
        powerdata_FADCorr_mouse = cat(1,powerdata_FADCorr_mouse,squeeze(powerdata_FADCorr));
        powerdata_average_FADCorr_mouse = cat(1,powerdata_average_FADCorr_mouse,squeeze(powerdata_average_FADCorr'));
    end
    powerdata_average_FADCorr_mouse = mean(powerdata_average_FADCorr_mouse,1);
    powerdata_FADCorr_mouse = mean(powerdata_FADCorr_mouse,1);

    if exist(fullfile(saveDir, processedName_mouse),'file')
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_FADCorr_mouse','powerdata_FADCorr_mouse','-append')
    else
        save(fullfile(saveDir, processedName_mouse),'powerdata_average_FADCorr_mouse','powerdata_FADCorr_mouse')
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
    load(fullfile(saveDir, processedName_mouse),'powerdata_FAD_mouse')
    figure
    loglog(hz',powerdata_FAD_mouse)
    title(mouseName)
end

%% mice average
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
powerdata_average_FAD_mice = [];
powerdata_FAD_mice = [];
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
    load(fullfile(saveDir, processedName),'powerdata_average_FAD_mouse','powerdata_FAD_mouse')
    powerdata_average_FAD_mice = cat(1,powerdata_average_FAD_mice,squeeze(powerdata_average_FAD_mouse));
    powerdata_FAD_mice = cat(1,powerdata_FAD_mice,squeeze(powerdata_FAD_mouse));
end
powerdata_average_FAD_mice = mean(powerdata_average_FAD_mice,1);
powerdata_FAD_mice = mean(powerdata_FAD_mice,1);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

if exist(fullfile(saveDir_cat, processedName_mice),'file')
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_FAD_mice','powerdata_FAD_mice','-append')
else
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_FAD_mice','powerdata_FAD_mice')
end


%% Visualization
dr = "#5A0404";
lr = "#FF5C77";

dg = "#12171C";
lg = "#8396A8";
% Awake
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_FAD_mice')
powerdata_FAD_mice_RGECO_awake = powerdata_FAD_mice;
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_FADCorr_mice')
powerdata_FADCorr_mice_RGECO_awake = powerdata_FADCorr_mice;

load("X:\Paper1\WT\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-fc.mat", 'powerdata_FAD_mice', 'powerdata_FADCorr_mice')
powerdata_FAD_mice_WT_awake = powerdata_FAD_mice;
powerdata_FADCorr_mice_WT_awake = powerdata_FADCorr_mice;

figure
loglog(hz',powerdata_FADCorr_mice_RGECO_awake,'color',dr)
hold on
loglog(hz',powerdata_FAD_mice_RGECO_awake,'color',lr)
hold on
loglog(hz',powerdata_FADCorr_mice_WT_awake,'color',dg)
hold on
loglog(hz',powerdata_FAD_mice_WT_awake,'color',lg)
xlim([0.01 10])
legend('Corrected FAF in Thy1-jRGECO1a mice','Raw FAF in Thy1-jRGECO1a mice','Corrected FAF in C57BL/6J mice','Raw FAD in C57BL/6J mice')
title('Awake')
ylim([-inf 10000])
xlabel('Frequency(Hz)')
ylabel('FAF(\DeltaF/F)')
% Anes
load("E:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat", 'powerdata_FAD_mice','powerdata_FADCorr_mice')
powerdata_FAD_mice_RGECO_anes = powerdata_FAD_mice;
powerdata_FADCorr_mice_RGECO_anes = powerdata_FADCorr_mice;

load("X:\Paper1\WT\cat\210830--W30M1-anes-W30M2-anes-W30M3-anes-W31M1-anes-W31M2-anes-fc.mat",'powerdata_FAD_mice','powerdata_FADCorr_mice')
powerdata_FAD_mice_WT_anes = powerdata_FAD_mice;
powerdata_FADCorr_mice_WT_anes = powerdata_FADCorr_mice;

figure
loglog(hz',powerdata_FADCorr_mice_RGECO_anes,'color',dr)
hold on
loglog(hz',powerdata_FAD_mice_RGECO_anes,'color',lr)
hold on
loglog(hz',powerdata_FADCorr_mice_WT_anes,'color',dg)
hold on
loglog(hz',powerdata_FAD_mice_WT_anes,'color',lg)
xlim([0.01 10])
legend('Corrected FAF in Thy1-jRGECO1a mice','Raw FAF in Thy1-jRGECO1a mice','Corrected FAF in C57BL/6J mice','Raw FAF in Thy1-jRGECO1a mice','Raw FAD in C57BL/6J mice')
title('Anesthetized')
ylim([-inf 1000])
xlabel('Frequency(Hz)')
ylabel('FAF(\DeltaF/F)')