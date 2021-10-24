close all;clear all;clc
import mouse.*
excelFile = "X:\XW\Radiation Project\Hippocampus\Radiation Project_Hippocampus.xlsx";
excelRows = [2:31];%:450;

 for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile('J:\Radiation Project\Processed Data',recDate,wlName),'isbrain','xformn_isbrain')
    save(fullfile('X:\XW\Radiation Project\Hippocampus',recDate,wlName),'isbrain','xformn_isbrain')
 end
