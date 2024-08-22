excelRows = [ 181 183 185 228 232 236 202 195 204 230 234 240];
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
saveDir_cat = "E:\RGECO\cat\";
% excelRows = 4:4:24;
% excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
% saveDir_cat = "X:\Paper1\WT_Paper1\cat\";
% excelFile = "X:\Paper1\WT\WT.xlsx";
% excelRows = [2,4,7,11,14];
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
    title(mouseName)
end

%% mice average awake
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
excelRows = [ 181 183 185 228 232 236 ];
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
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1a_mice','powerdata_average_jrgeco1a_mice','-append')
else
    save(fullfile(saveDir_cat, processedName_mice),'powerdata_jrgeco1a_mice','powerdata_average_jrgeco1a_mice')
end

%% mice average anes
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
excelRows = [ 202 195 204 230 234 240 ];
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
