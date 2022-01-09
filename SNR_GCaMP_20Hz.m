clear all;clc
import mouse.*
excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 36:38;%:450;
runs = 1:3;
mean_gcamp_cat = [];
std_gcamp_cat = [];

mean_gcamp_blocks_cat = [];
std_gcamp_blocks_cat = [];
saveDir_cat = 'X:\XW\Paper\hemoGCaMP\cat';
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    % maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
    %     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskDir = saveDir;
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    
    processedName_ROI = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');
    load(fullfile(saveDir,processedName_ROI),'xform_gcampCorr')
    xform_gcampCorr = reshape(xform_gcampCorr,128,128,600,[]);
    baseline= mean(xform_gcampCorr(:,:,1:100),3);
    baseline = repmat(baseline,1,1,600,size(xform_gcampCorr,4));
    xform_gcampCorr = xform_gcampCorr-baseline;
    peakMap = mean(xform_gcampCorr,4);
    peakMap_ROI = mean(peakMap(:,:,101:200),3);
    figure
    imagesc(peakMap_ROI)
    hold on
    load('D:\OIS_Process\atlas.mat','AtlasSeeds')
    Barrel = AtlasSeeds==9;
    contour(Barrel)
    [x1,y1] = ginput(1);
    [x2,y2] = ginput(1);
    [X,Y] = meshgrid(1:128,1:128);
    radius = sqrt((x1-x2)^2+(y1-y2)^2);
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    max_ROI = prctile(peakMap_ROI(ROI),99);
    temp = double(peakMap_ROI).*double(ROI);
    ROI = temp>max_ROI*0.75;
    hold on
    contour(ROI)
    iROI = reshape(ROI,1,[]);
    
    for n = runs
        mean_gcamp = nan(1,10);
        std_gcamp = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_gcampCorr','ROI_NoGSR')
%         iROI = reshape(ROI_NoGSR,1,[]);
         load(fullfile(saveDir,processedName),'xform_gcampCorr')
        xform_gcampCorr = reshape(xform_gcampCorr,128,128,600,[]);
        baseline= mean(xform_gcampCorr(:,:,1:100,:),3);
        baseline = repmat(baseline,1,1,600,1);
        xform_gcampCorr = xform_gcampCorr-baseline;
        
        xform_gcampCorr = reshape(xform_gcampCorr,128*128,600,size(xform_gcampCorr,4));
        gcampCorr_ROI = squeeze(mean(xform_gcampCorr(iROI,:,:),1));
        timeTrace = reshape(gcampCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:length(timeTrace))/20,timeTrace,'g')
          xlabel('Time(s)')
         ylabel('\muF/F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))
        
        for ii = 1:size(xform_gcampCorr,3)
            mean_gcamp = squeeze(mean(gcampCorr_ROI(101:200,ii),1));
            std_gcamp = squeeze(std(gcampCorr_ROI(1:100,ii),0,1));
%             if mean_gcamp >0
            mean_gcamp_cat = [mean_gcamp_cat,mean_gcamp];
            std_gcamp_cat = [std_gcamp_cat,std_gcamp];
%             end
        end
    end
 end
figure
yyaxis left
plot(mean_gcamp_cat,'r-')
hold on
plot(std_gcamp_cat,'g-')
ylim([-0.01 0.09])
ylabel('\muF/F')
hold on
yyaxis right
ylabel('SNR')
plot(mean_gcamp_cat./std_gcamp_cat,'b-')
ylim([-20 20])
legend('mean','standard deviation','SNR')
title(strcat(recDate,'-GCaMP-SNR'))

SNR_mouse1 = mean(mean_gcamp_cat(1:27)./std_gcamp_cat(1:27));
SNR_mouse2 = mean(mean_gcamp_cat(28:54)./std_gcamp_cat(28:54));
SNR_mouse3 = mean(mean_gcamp_cat(55:81)./std_gcamp_cat(55:81));