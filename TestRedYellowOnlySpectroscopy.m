close all
clear all
clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 413:415;
runsInfo = parseTiffRuns(excelFile,excelRows);
runInd = 0;
runNum = numel(runsInfo);

xform_datahb_mouse = [];
xform_datahb_GSR_mouse = [];
xform_datahb_mice = [];
xform_datahb_GSR_mice = [];
currentExcelRow = runsInfo(1).excelRow;
currentRunInfo = runsInfo(1);
for runInfo = runsInfo % for each run
    runInd = runInd + 1;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    fileDataHb = runInfo.saveHbFile;
    load(fileDataHb,'xform_datahb','xform_isbrain');
    xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
    xform_datahb = reshape(xform_datahb,128,128,2,1200,5);
    baseline = mean(xform_datahb(:,:,:,1:100,:),4);
    xform_datahb = xform_datahb-repmat(baseline,1,1,1,size(xform_datahb,4),1);
    clear baseline
    xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,1200,5);
    baseline_GSR = mean(xform_datahb_GSR(:,:,:,1:100,:),4);
    xform_datahb_GSR = xform_datahb_GSR-repmat(baseline_GSR,1,1,1,size(xform_datahb_GSR,4),1);
    clear baseline_GSR
    xform_datahb = mean(xform_datahb,5);
    xform_datahb_GSR = mean(xform_datahb_GSR,5);
    %     figure
    %     subplot(1,3,1)
    %     imagesc(mean(xform_datahb_GSR(:,:,1,180:220),4),[-0.3*10^-5 0.3*10^-5]);
    %     colorbar
    %     title('HbO')
    %     axis image off
    %     subplot(1,3,2)
    %     imagesc(mean(xform_datahb_GSR(:,:,2,180:220),4),[-0.1*10^-5 0.1*10^-5]);
    %     colorbar
    %     axis image off
    %     title('HbR')
    %     subplot(1,3,3)
    %     axis image off
    %     peakMap = mean(xform_datahb_GSR(:,:,1,180:220)+xform_datahb_GSR(:,:,2,180:220),4);
    %     imagesc(peakMap,[-0.2*10^-5 0.2*10^-5]);
    %     colorbar
    %     title('HbT')
    %     axis image off
    %     colormap jet
    %     suptitle([runInfo.mouseName, '-run',num2str(runInfo.run),'-With GSR'])
    %     pause
    %     saveas(gcf,strcat(runInfo.saveFilePrefix,'-GSR-PeakMap.fig'))
    %     saveas(gcf,strcat(runInfo.saveFilePrefix,'-GSR-PeakMap.png'))
    %     [X,Y] = meshgrid(1:128,1:128);
    %     [x1,y1] = ginput(1);
    %     [x2,y2] = ginput(1);
    %     radius = sqrt((x1-x2)^2+(y1-y2)^2);
    %     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    %     max_ROI = prctile(peakMap(ROI),99);
    %     temp = double(peakMap).*double(ROI);
    %     ROI = temp>max_ROI*0.75;
    %     hold on
    %     ROI_contour = bwperim(ROI);
    %     [~,c] = contour( ROI_contour,'k');
    %     iROI = reshape(ROI,128*128,1);
    %     xform_datahb = reshape(xform_datahb,128*128,2,[]);
    %     datahb_ROI = squeeze(mean(xform_datahb(iROI,:,:),1));
    %     figure
    %     plot(datahb_ROI(1,:),'r');
    %     hold on
    %     plot(datahb_ROI(2,:),'b');
    %     hold on
    %     plot(datahb_ROI(1,:)+datahb_ROI(2,:),'k');
    %     title([runInfo.mouseName, '-run',num2str(runInfo.run), '-Without GSR'])
    %     saveas(gcf,strcat(runInfo.saveFilePrefix,'-NoGSR-TimeTrace.fig'))
    %     saveas(gcf,strcat(runInfo.saveFilePrefix,'-NoGSR-TimeTrace.png'))
    %     xform_datahb = reshape(xform_datahb,128,128,2,[]);
    %     close all
    
    if currentExcelRow == runInfo.excelRow
        xform_datahb_mouse = cat(5, xform_datahb_mouse, xform_datahb);
        xform_datahb_GSR_mouse = cat(5, xform_datahb_GSR_mouse, xform_datahb_GSR);
    end
    
    if currentExcelRow ~= runInfo.excelRow || runInd == numel(runsInfo)
        xform_datahb_mouse = nanmean(xform_datahb_mouse,5);
        xform_datahb_GSR_mouse = nanmean(xform_datahb_GSR_mouse,5);
        save(currentRunInfo.saveFilePrefix(1:(end-1)),'xform_datahb_mouse','xform_datahb_GSR_mouse')
        xform_datahb_mice = cat(5,xform_datahb_mice,xform_datahb_mouse);
        xform_datahb_GSR_mice = cat(5,xform_datahb_GSR_mice,xform_datahb_GSR_mouse);
        figure
        subplot(1,3,1)
        imagesc(mean(xform_datahb_GSR_mouse(:,:,1,180:220),4),[-0.3*10^-5 0.3*10^-5]);
        colorbar
        title('HbO')
        axis image off
        subplot(1,3,2)
        imagesc(mean(xform_datahb_GSR_mouse(:,:,2,180:220),4),[-0.1*10^-5 0.1*10^-5]);
        colorbar
        axis image off
        title('HbR')
        subplot(1,3,3)
        axis image off
        peakMap = mean(xform_datahb_GSR_mouse(:,:,1,180:220)+xform_datahb_GSR_mouse(:,:,2,180:220),4);
        imagesc(peakMap,[-0.2*10^-5 0.2*10^-5]);
        colorbar
        title('HbT')
        axis image off
        colormap jet
        suptitle([currentRunInfo.mouseName,'-With GSR'])
        pause
        saveas(gcf,strcat(currentRunInfo.saveFilePrefix(1:(end-1)),'-GSR-PeakMap.fig'))
        saveas(gcf,strcat(currentRunInfo.saveFilePrefix(1:(end-1)),'-GSR-PeakMap.png'))
        [X,Y] = meshgrid(1:128,1:128);
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap(ROI),99);
        temp = double(peakMap).*double(ROI);
        ROI = temp>max_ROI*0.75;
        hold on
        ROI_contour = bwperim(ROI);
        [~,c] = contour( ROI_contour,'k');
        iROI = reshape(ROI,128*128,1);
        xform_datahb_mouse = reshape(xform_datahb_mouse,128*128,2,[]);
        datahb_ROI = squeeze(mean(xform_datahb_mouse(iROI,:,:),1));
        figure
        plot(datahb_ROI(1,:),'r');
        hold on
        plot(datahb_ROI(2,:),'b');
        hold on
        plot(datahb_ROI(1,:)+datahb_ROI(2,:),'k');
        title([runInfo.mouseName,'-Without GSR'])
        saveas(gcf,strcat(currentRunInfo.saveFilePrefix(1:(end-1)),'-NoGSR-TimeTrace.fig'))
        saveas(gcf,strcat(currentRunInfo.saveFilePrefix(1:(end-1)),'-NoGSR-TimeTrace.png'))
        xform_datahb_mouse = [];
        xform_datahb_GSR_mouse = [];
        currentExcelRow = runInfo.excelRow;
        currentRunInfo = runInfo;
        xform_datahb_mouse = cat(5, xform_datahb_mouse, xform_datahb);
        xform_datahb_GSR_mouse = cat(5, xform_datahb_GSR_mouse, xform_datahb_GSR);
    end
end
xform_datahb_mice = nanmean(xform_datahb_mice,5);
xform_datahb_GSR_mice = nanmean(xform_datahb_GSR_mice,5);


figure
subplot(1,3,1)
imagesc(mean(xform_datahb_GSR_mice(:,:,1,180:220),4),[-0.3*10^-5 0.3*10^-5]);
colorbar
title('HbO')
axis image off
subplot(1,3,2)
imagesc(mean(xform_datahb_GSR_mice(:,:,2,180:220),4),[-0.1*10^-5 0.1*10^-5]);
colorbar
axis image off
title('HbR')
subplot(1,3,3)
axis image off
peakMap = mean(xform_datahb_GSR_mice(:,:,1,180:220)+xform_datahb_GSR_mice(:,:,2,180:220),4);
imagesc(peakMap,[-0.2*10^-5 0.2*10^-5]);
colorbar
title('HbT')
axis image off
colormap jet
suptitle('G6M2-G7M6-G7M7-With GSR')
pause
saveas(gcf,strcat('M:\GCaMP\cat\','190506-G6M2-G7M6-G7M7-GSR-PeakMap.fig'))
saveas(gcf,strcat('M:\GCaMP\cat\','190506-G6M2-G7M6-G7M7-GSR-PeakMap.png'))
[X,Y] = meshgrid(1:128,1:128);
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = double(peakMap).*double(ROI);
ROI = temp>max_ROI*0.75;
hold on
ROI_contour = bwperim(ROI);
[~,c] = contour( ROI_contour,'k');
iROI = reshape(ROI,128*128,1);
xform_datahb = reshape(xform_datahb,128*128,2,[]);
datahb_ROI = squeeze(mean(xform_datahb(iROI,:,:),1));
figure
plot(datahb_ROI(1,:),'r');
hold on
plot(datahb_ROI(2,:),'b');
hold on
plot(datahb_ROI(1,:)+datahb_ROI(2,:),'k');
title('G6M2-G7M6-G7M7-Without GSR')
saveas(gcf,strcat('M:\GCaMP\','190506-G6M2-G7M6-G7M7-NoGSR-TimeTrace.fig'))
saveas(gcf,strcat('M:\GCaMP\','190506-G6M2-G7M6-G7M7-NoGSR-TimeTrace.png'))