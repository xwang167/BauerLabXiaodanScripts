excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =  [181 183 185 228 232 236];
RGECO_mice_awake = [];
runs = 1:3;
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
    RGECO_mouse = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'isbrain')
    end
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata');
        ibi=find(isbrain==1);
        raw_green = squeeze(rawdata(:,:,3,:));
        raw_green = reshape(raw_green,128*128,[]);
        mdata=squeeze(mean(raw_green(ibi,:),1));
        RGECO = mean(mdata);
        RGECO_mouse = [RGECO_mouse,RGECO];
    end
    RGECO_mouse = mean(RGECO_mouse);
    RGECO_mice_awake = [RGECO_mice_awake,RGECO_mouse];
end
RGECO_mice_awake_mean = mean(RGECO_mice_awake);

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [ 202 195 204 230 234 240];
RGECO_mice_anes = [];
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
    RGECO_mouse = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'isbrain')
    end
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata');
        ibi=find(isbrain==1);
        raw_green = squeeze(rawdata(:,:,3,:));
        raw_green = reshape(raw_green,128*128,[]);
        mdata=squeeze(mean(raw_green(ibi,:),1));
        RGECO = mean(mdata);
        RGECO_mouse = [RGECO_mouse,RGECO];
    end
    RGECO_mouse = mean(RGECO_mouse);
    RGECO_mice_anes = [RGECO_mice_anes,RGECO_mouse];
end
RGECO_mice_RGECO_anes_mean = mean(RGECO_mice_RGECO_anes);

excelFile = "L:\RGECO\RGECO.xlsx";
excelRows =  [14:18];
GreenReflectance_mice_RGECO_awake_evoke = [];
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
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'isbrain')
    end
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata');
        ibi=find(isbrain==1);
        raw_green = squeeze(rawdata(:,:,3,:));
        raw_green = reshape(raw_green,128*128,[]);
        mdata=squeeze(mean(raw_green(ibi,:),1));
        GreenReflectance = mean(mdata);
        GreenReflectance_mouse = [GreenReflectance_mouse,GreenReflectance];
    end
    GreenReflectance_mouse = mean(GreenReflectance_mouse);
    GreenReflectance_mice_RGECO_awake_evoke = [GreenReflectance_mice_RGECO_awake_evoke,GreenReflectance_mouse];
end
GreenReflectance_mice_RGECO_awake_evoke_mean = mean(GreenReflectance_mice_RGECO_awake_evoke);


excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = [19:22];
GreenReflectance_mice_RGECO_anes_evoke = [];
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
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'isbrain')
    end
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata');
        ibi=find(isbrain==1);
        raw_green = squeeze(rawdata(:,:,3,:));
        raw_green = reshape(raw_green,128*128,[]);
        mdata=squeeze(mean(raw_green(ibi,:),1));
        GreenReflectance = mean(mdata);
        GreenReflectance_mouse = [GreenReflectance_mouse,GreenReflectance];
    end
    GreenReflectance_mouse = mean(GreenReflectance_mouse);
    GreenReflectance_mice_RGECO_anes_evoke = [GreenReflectance_mice_RGECO_anes_evoke,GreenReflectance_mouse];
end
GreenReflectance_mice_RGECO_anes_evoke_mean = mean(GreenReflectance_mice_RGECO_anes_evoke);

