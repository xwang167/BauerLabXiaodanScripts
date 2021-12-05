clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
load('D:\OIS_Process\noVasculatureMask.mat')
excelRows = [181,183,185,228,232,236];%321:327;
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    fs = excelRaw{7};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    xform_mask = xform_isbrain;
    
    for n = runs
      processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
      load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr_GSR')
      xform_jrgeco1aCorr_GSR = squeeze(xform_jrgeco1aCorr_GSR);
      xform_jrgeco1aCorr_GSR = resampledata_ori(xform_jrgeco1aCorr_GSR,25,16.8,10^(-5));
      eval(strcat('Calcium_run',num2str(n),'= reshape(xform_jrgeco1aCorr_GSR,128,128,168,[]);'))        
    end    
    save(strcat('L:\RGECO\',mouseName,'.mat'),'Calcium_run1','Calcium_run2','Calcium_run3','xform_mask')
end
    