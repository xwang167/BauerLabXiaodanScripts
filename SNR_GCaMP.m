clear all;clc
import mouse.*
excelFile = "X:\Paper\PaperExperiment.xlsx";
excelRows = 29:31;%:450;
runs = 1:3;
mean_gcamp_cat = [];
std_gcamp_cat = [];

mean_gcamp_blocks_cat = [];
std_gcamp_blocks_cat = [];
saveDir_cat = 'X:\Paper\GCaMP\cat';
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
    
%     processedName_ROI = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');
%     load(fullfile(saveDir,processedName_ROI),'xform_gcampCorr')
%     xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
%     baseline= mean(xform_gcampCorr(:,:,1:125),3);
%     baseline = repmat(baseline,1,1,750,10);
%     xform_gcampCorr = xform_gcampCorr-baseline;
%     peakMap = mean(xform_gcampCorr,4);
%     peakMap_ROI = mean(peakMap(:,:,126:250),3);
%     figure
%     imagesc(peakMap_ROI)
%     hold on
%     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
%     Barrel = AtlasSeeds==9;
%     contour(Barrel)
%     [x1,y1] = ginput(1);
%     [x2,y2] = ginput(1);
%     [X,Y] = meshgrid(1:128,1:128);
%     radius = sqrt((x1-x2)^2+(y1-y2)^2);
%     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%     max_ROI = prctile(peakMap_ROI(ROI),99);
%     temp = double(peakMap_ROI).*double(ROI);
%     ROI = temp>max_ROI*0.75;
%     hold on
%     contour(ROI)
%     iROI = reshape(ROI,1,[]);
   
    for n = runs
        mean_gcamp = nan(1,10);
        std_gcamp = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_gcampCorr','ROI_NoGSR')
        iROI = reshape(ROI_NoGSR,1,[]);
%         load(fullfile(saveDir,processedName),'xform_gcampCorr')
        xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
        baseline= mean(xform_gcampCorr(:,:,1:125,:),3);
        baseline = repmat(baseline,1,1,750,1);
        xform_gcampCorr = xform_gcampCorr-baseline;
        
        xform_gcampCorr = reshape(xform_gcampCorr,128*128,750,10);
        gcampCorr_ROI = squeeze(mean(xform_gcampCorr(iROI,:,:),1));
        timeTrace = reshape(gcampCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:7500)/25,timeTrace,'g')
          xlabel('Time(s)')
         ylabel('\muF/F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))      
        for ii = 1:10
            mean_gcamp = squeeze(mean(gcampCorr_ROI(126:250,ii),1));
            std_gcamp = squeeze(std(gcampCorr_ROI(1:125,ii),0,1));
%             if mean_gcamp >0
            mean_gcamp_cat = [mean_gcamp_cat,mean_gcamp];
            std_gcamp_cat = [std_gcamp_cat,std_gcamp];
%             end
        end
    end
end
figure
yyaxis left
plot(mean_gcamp_cat*100,'r-')
hold on
plot(std_gcamp_cat*100,'g-')
ylim([0 20])
ylabel('\DeltaF/F%')
hold on
yyaxis right
ylabel('SNR')
plot(mean_gcamp_cat./std_gcamp_cat,'b-')
ylim([-20 20])
legend('mean','standard deviation','SNR')
title(strcat(recDate,'-GCaMP-SNR'))
savefig(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio','.png')))


SNR_mouse1 = mean(mean_gcamp_cat(1:30)./std_gcamp_cat(1:30));
SNR_mouse2 = mean(mean_gcamp_cat(31:60)./std_gcamp_cat(31:60));
SNR_mouse3 = mean(mean_gcamp_cat(31:60)./std_gcamp_cat(61:90));




load('X:\XW\Paper\GCaMP\211210\211210-G2M1-stim2_processed.mat','xform_gcampCorr')
xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
baseline= mean(xform_gcampCorr(:,:,1:125),3);
baseline = repmat(baseline,1,1,750,10);
xform_gcampCorr = xform_gcampCorr-baseline;
peakMap = mean(xform_gcampCorr,4);
peakMap_ROI = mean(peakMap(:,:,126:128),3);
figure
imagesc(peakMap_ROI)
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

xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
baseline= mean(xform_gcampCorr(:,:,1:125,:),3);
baseline = repmat(baseline,1,1,750,1);
xform_gcampCorr = xform_gcampCorr-baseline;

xform_gcampCorr = reshape(xform_gcampCorr,128*128,750,10);
gcampCorr_ROI = squeeze(mean(xform_gcampCorr(iROI,:,:),1));
timeTrace = reshape(gcampCorr_ROI,1,[]);
hold on
plot((1:3750)/25,timeTrace(1:3750)*100,'g')






load('X:\XW\Paper\GCaMP\211210\211210-G2M1-stim2_processed.mat','xform_gcampCorr')
xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
baseline= mean(xform_gcampCorr(:,:,1:125),3);
baseline = repmat(baseline,1,1,750,10);
xform_gcampCorr = xform_gcampCorr-baseline;
peakMap = mean(xform_gcampCorr,4);
peakMap_ROI = mean(peakMap(:,:,126:128),3);
figure
imagesc(peakMap_ROI)
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

xform_gcampCorr = reshape(xform_gcampCorr,128,128,750,[]);
baseline= mean(xform_gcampCorr(:,:,1:125,:),3);
baseline = repmat(baseline,1,1,750,1);
xform_gcampCorr = xform_gcampCorr-baseline;

xform_gcampCorr = reshape(xform_gcampCorr,128*128,750,10);
gcampCorr_ROI = squeeze(mean(xform_gcampCorr(iROI,:,:),1));
timeTrace = reshape(gcampCorr_ROI,1,[]);
hold on
plot((1:7500)/25,timeTrace*100,'g')

