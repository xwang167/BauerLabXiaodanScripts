excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 297;

% make mask and transform matrix
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    sessionInfo.framerate = excelRaw{7};
    maskDir = fullfile(rawdataloc,recDate);
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'xform_isbrain',WL)
    imagesc(WL)
    [x,y] = ginput(1);
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1_processed','.mat');
    
    load(fullfile(saveDir,processedName),'xform_datahb')
     createVasculatureMask(xform_datahb, sessionInfo.framerate,xform_isbrain,[x,y],'Manual Pick');
end