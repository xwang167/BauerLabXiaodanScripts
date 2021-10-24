runs = 1:3;
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =  [181 183 185 228 232 236];
RGECO_mice_awake_variance = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    RGECO_mouse_variance = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    
    xform_isbrain = logical(xform_isbrain);
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr');
        ibi = logical(reshape(xform_isbrain,[],1));
        xform_jrgeco1aCorr =  reshape(xform_jrgeco1aCorr,128*128,[]);
        jrgeco1a_variance = var(squeeze(xform_jrgeco1aCorr(ibi,:)),0,2);
        clear xform_jrgeco1aCorr
        RGECO_variance = mean(jrgeco1a_variance);
        RGECO_mouse_variance = [RGECO_mouse_variance,RGECO_variance];
    end
    clear xform_isbrain
    RGECO_mouse_variance = mean(RGECO_mouse_variance);
    RGECO_mice_awake_variance = [RGECO_mice_awake_variance,RGECO_mouse_variance];
end
RGECO_mice_awake_mean = mean(RGECO_mice_awake_variance);

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [ 195 202 204 230 234 240];
RGECO_mice_anes_variance = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    RGECO_mouse_variance = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    xform_isbrain = logical(xform_isbrain);
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');;
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr');
        ibi = logical(reshape(xform_isbrain,[],1));
        xform_jrgeco1aCorr =  reshape(xform_jrgeco1aCorr,128*128,[]);
        jrgeco1a_variance = var(squeeze(xform_jrgeco1aCorr(ibi,:)),0,2);
        clear xform_jrgeco1aCorr
        RGECO_variance = mean(jrgeco1a_variance);
        RGECO_mouse_variance = [RGECO_mouse_variance,RGECO_variance];
    end
            clear xform_isbrain
    RGECO_mouse_variance = mean(RGECO_mouse_variance);
    RGECO_mice_anes_variance = [RGECO_mice_anes_variance,RGECO_mouse_variance];
end
RGECO_mice_anes_variance_mean = mean(RGECO_mice_anes_variance);



excelFile = "L:\RGECO\RGECO.xlsx";
excelRows =  [14:18];
RGECO_mice_awake_evoke_variance = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    RGECO_mouse_variance = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    xform_isbrain = logical(xform_isbrain);
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr');
        ibi = logical(reshape(xform_isbrain,[],1));
        xform_jrgeco1aCorr =  reshape(xform_jrgeco1aCorr,128*128,[]);
        jrgeco1a_variance = var(squeeze(xform_jrgeco1aCorr(ibi,:)),0,2);
        clear xform_jrgeco1aCorr
        RGECO_variance = mean(jrgeco1a_variance);
        RGECO_mouse_variance = [RGECO_mouse_variance,RGECO_variance];
    end
            clear xform_isbrain
    RGECO_mouse_variance = mean(RGECO_mouse_variance);
    RGECO_mice_awake_evoke_variance = [RGECO_mice_awake_evoke_variance,RGECO_mouse_variance];
end
RGECO_mice_awake_evoke_variance_mean = mean(RGECO_mice_awake_evoke_variance);



excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = [19:22];
RGECO_mice_anes_evoke_variance = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    GreenReflectance_mouse = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    xform_isbrain = logical(xform_isbrain);
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');;
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr');
        ibi = logical(reshape(xform_isbrain,[],1));
        xform_jrgeco1aCorr =  reshape(xform_jrgeco1aCorr,128*128,[]);
        jrgeco1a_variance = var(squeeze(xform_jrgeco1aCorr(ibi,:)),0,2);
        clear xform_jrgeco1aCorr
        RGECO_variance = mean(jrgeco1a_variance);
        RGECO_mouse_variance = [RGECO_mouse_variance,RGECO_variance];
    end
            clear xform_isbrain
    RGECO_mouse_variance = mean(RGECO_mouse_variance);
    RGECO_mice_anes_evoke_variance = [RGECO_mice_anes_evoke_variance,RGECO_mouse_variance];
end
RGECO_mice_anes_evoke_variance_mean = mean(RGECO_mice_anes_evoke_variance);

