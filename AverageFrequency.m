excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =[181,183,185,228,232,236];

awake_freq = nan(6,1);
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
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
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    load(fullfile(saveDir, processedName),'powerdata_FADCorr_mouse','hz')
    awake_freq(ll,1) = sum(hz.*powerdata_FADCorr_mouse')/sum(powerdata_FADCorr_mouse');
    ll = ll+1;
    clear powerdata_FADCorr_mouse
end

excelRows = [195 202 204 230 234 240];
anes_freq = nan(6,1);
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
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
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    load(fullfile(saveDir, processedName),'powerdata_FADCorr_mouse','hz')
    anes_freq(ll,1) = sum(hz.*powerdata_FADCorr_mouse')/sum(powerdata_FADCorr_mouse');
    ll = ll+1;
    clear powerdata_FADCorr_mouse
end