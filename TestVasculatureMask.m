clear all;close all;clc;
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = [319 320];

% make mask and transform matrix
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; 
    
    sessionInfo.framerate = excelRaw{7};
   sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain','WL','I')

 I.OF = I.OF*128;
 I.tent = I.tent*128;
 I.bregma = I.bregma*128;
[xform_WL]=Affine(I, WL, 'New');
figure
    imagesc(xform_WL);
    [x,y] = ginput(1);
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    
    load(fullfile(saveDir,processedName),'xform_datahb')
     createVasculatureMask(xform_datahb, sessionInfo.framerate,xform_isbrain,[x,y],'Manual Pick');
end