runs = 1:3;%
excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = [3,7,10];%:450;
RedEmissionLightlevel_mice_WT = [];
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
    RedEmissionLightlevel_mouse = [];
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'mdata');
        RedEmissionLightlevel = mean(mdata(2,:),2);
        RedEmissionLightlevel_mouse = [RedEmissionLightlevel_mouse,RedEmissionLightlevel];
    end
    RedEmissionLightlevel_mouse = mean(RedEmissionLightlevel_mouse);
    RedEmissionLightlevel_mice_WT = [RedEmissionLightlevel_mice_WT,RedEmissionLightlevel_mouse];
end
RedEmissionLightlevel_mice_WT = mean(RedEmissionLightlevel_mice_WT);



excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =  [181 183 185 228 232 236];
RedEmissionLightlevel_mice_RGECO = [];
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
    RedEmissionLightlevel_mouse = [];
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
        raw_rgeco = squeeze(rawdata(:,:,2,:));
        raw_rgeco = reshape(raw_rgeco,128*128,[]);
        mdata=squeeze(mean(raw_rgeco(ibi,:),1));
        RedEmissionLightlevel = mean(mdata);
        RedEmissionLightlevel_mouse = [RedEmissionLightlevel_mouse,RedEmissionLightlevel];
    end
    RedEmissionLightlevel_mouse = mean(RedEmissionLightlevel_mouse);
    RedEmissionLightlevel_mice_RGECO = [RedEmissionLightlevel_mice_RGECO,RedEmissionLightlevel_mouse];
end
RedEmissionLightlevel_mice_RGECO = mean(RedEmissionLightlevel_mice_RGECO);




excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = [5,8,11];%:450;
RedEmissionLightlevel_mice_WT_anes = [];
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
    RedEmissionLightlevel_mouse = [];
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'mdata');
        RedEmissionLightlevel = mean(mdata(2,:),2);
        RedEmissionLightlevel_mouse = [RedEmissionLightlevel_mouse,RedEmissionLightlevel];
    end
    RedEmissionLightlevel_mouse = mean(RedEmissionLightlevel_mouse);
    RedEmissionLightlevel_mice_WT_anes = [RedEmissionLightlevel_mice_WT_anes,RedEmissionLightlevel_mouse];
end
RedEmissionLightlevel_mice_WT_anes = mean(RedEmissionLightlevel_mice_WT_anes);



excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [ 202 195 204 230 234 240];
RedEmissionLightlevel_mice_RGECO_anes = [];
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
    RedEmissionLightlevel_mouse = [];
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
        raw_rgeco = squeeze(rawdata(:,:,2,:));
        raw_rgeco = reshape(raw_rgeco,128*128,[]);
        mdata=squeeze(mean(raw_rgeco(ibi,:),1));
        RedEmissionLightlevel = mean(mdata);
        RedEmissionLightlevel_mouse = [RedEmissionLightlevel_mouse,RedEmissionLightlevel];
    end
    RedEmissionLightlevel_mouse = mean(RedEmissionLightlevel_mouse);
    RedEmissionLightlevel_mice_RGECO_anes = [RedEmissionLightlevel_mice_RGECO_anes,RedEmissionLightlevel_mouse];
end
RedEmissionLightlevel_mice_RGECO_anes = mean(RedEmissionLightlevel_mice_RGECO_anes);