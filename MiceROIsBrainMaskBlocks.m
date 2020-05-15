clear all;close all;clc;
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 336:343;

recDate = "200320";
miceName = 'ChR2-RGECO-Anes';
saveDir_cat = 'K:\OptoRGECO\Cat';
load(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim.mat')),'peakMap_ROI_mice')
runs = 1:6;
goodBlocksNum = 0;
goodBlocksNum_GSR = 0;
imagesc(peakMap_ROI_mice)
colormap jet
axis image off
xform_isbrain_mice= 1;
%colors = {'r','m','g','b','y','k','w','c'};
ii = 0;

ROIs = zeros(128,128);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    rawdataloc = excelRaw{3};
    maskDir_new = fullfile(rawdataloc,recDate);
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
    
    xform_isbrain = double(xform_isbrain);
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim.mat')),'ROI_GSR')
    ROIs = ROIs+ROI_GSR;
    %hold on
    %[C,h] = contour( ROI_GSR,colors{ii});
    %h.LineWidth = 1;
    ii = ii+1;
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks');
        if ~isempty(goodBlocks)
            goodBlocksNum = goodBlocksNum + size(goodBlocks);
        end
        if ~isempty(goodBlocks_GSR)
            goodBlocksNum_GSR = goodBlocksNum_GSR + size(goodBlocks_GSR);
        end
    end
    
end
ROIs = ROIs./ii;
imagesc(ROIs)
axis image off
colorbar
title(miceName)
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-ROIs.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-ROIs.png')))

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim.mat')),'goodBlocksNum','goodBlocksNum_GSR','xform_isbrain_mice','-append')