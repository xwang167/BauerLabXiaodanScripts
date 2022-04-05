import mouse.*
excelFile = "X:\Paper\PaperExperiment.xlsx";
excelRows = 29:31;%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;
mdata_mice = nan(7500,9);
ii = 1;
%%%%process raw to trace
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    
    systemType = excelRaw{5};
    
    sessionInfo.hbSpecies = 2:3;
    sessionInfo.fluorSpecies = 1;
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'isbrain')
    
    isbrain(isnan(isbrain)) = 0;
    isbrain = logical(isbrain);
    
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        disp(mouseName)
        disp('loading raw data')
        load(fullfile(saveDir,rawName),'mdata')
        mdata_mice(:,ii) = mdata(1,:);
        ii = ii+1;
    end
end

A = mean(mdata_mice,2);
B = mean(A);



%% RGECO
import mouse.*
excelFile = "X:\Paper\PaperExperiment.xlsx";
excelRows =  [26 27 34];%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;
mdata_mice = nan(7500,9);
ii = 1;
%%%%process raw to trace
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    
    systemType = excelRaw{5};
    
    sessionInfo.hbSpecies = 2:3;
    sessionInfo.fluorSpecies = 1;
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'isbrain')
    
    isbrain(isnan(isbrain)) = 0;
    isbrain = logical(isbrain);
    
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        disp(mouseName)
        disp('loading raw data')
        load(fullfile(saveDir,rawName),'mdata')
        mdata_mice(:,ii) = mdata(2,:);
        ii = ii+1;
    end
end

A = mean(mdata_mice,2);
B = mean(A);