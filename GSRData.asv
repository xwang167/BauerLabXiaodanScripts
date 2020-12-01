close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = leftMask + rightMask;
excelRows = [181 183 185  228 232 236 195 202 204 230 234 240];

runs = 1:3;
isDetrend = 1;
nVy = 128;
nVx = 128;


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
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    for n= runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_datahb',...
%             'xform_jrgeco1aCorr','xform_jrgeco1a','xform_FADCorr','xform_FAD')
         
          load(fullfile(saveDir,processedName),'xform_datahb',...
            'xform_jrgeco1aCorr','xform_FADCorr')      
                xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
                xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
                %xform_jrgeco1a_GSR =  mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
        xform_FADCorr_GSR =  mouse.process.gsr(xform_FADCorr,xform_isbrain);
        %xform_FAD_GSR =  mouse.process.gsr(xform_FAD,xform_isbrain);
%         save(fullfile(saveDir,processedName),'xform_datahb_GSR',...
%             'xform_jrgeco1aCorr_GSR','xform_jrgeco1a_GSR','xform_FADCorr_GSR','xform_FAD_GSR','-append')
        save(fullfile(saveDir,processedName),'xform_datahb_GSR',...
            'xform_jrgeco1aCorr_GSR','xform_FADCorr_GSR','-append')
%         save(fullfile(saveDir,processedName),'xform_FADCorr_GSR','xform_FAD_GSR','-append')
        
    end
end
