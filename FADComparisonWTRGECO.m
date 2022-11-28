clear all;close all;clc
load('GoodWL.mat','xform_WL');
load('noVasculatureMask.mat')
mask = leftMask+rightMask;
%% FAD from WT mice
load('X:\Paper\WT\RGECO Emission\cat\210820--W30M1-W30M2-W30M3-stim_processed_mice.mat', 'xform_FADCorr_mice_GSR','xform_FADCorr_mice_NoGSR')
% Generate Peakmap with GSR
peakMap_ROI = mean(xform_FADCorr_mice_GSR(:,:,25*5+1:250),3)*100;
imagesc(peakMap_ROI,[-1.1 1.1])
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
a=colorbar;
set(a,'YTick',[-1.1 0 1.1]);
ylabel(a,'\DeltaF/F%','FontSize',12,'Rotation',270);
% Generate ROI
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
[X,Y] = meshgrid(1:128,1:128);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI_WT = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_ROI(ROI_WT),99);
temp = peakMap_ROI.*ROI_WT;
ROI_WT = temp>0.75*max_ROI;
hold on
contour(ROI_WT,'w')
title('Corrected FAD Peak Map for WT with GSR')

% Time course without GSR
FAD_WT = reshape(xform_FADCorr_mice_NoGSR,128*128,[])*100;
FAD_WT_ROI = mean(FAD_WT(ROI_WT(:),:));
FAD_WT_ROI_subBaseline = FAD_WT_ROI-mean(FAD_WT_ROI(1:125));

% Time course with GSR
FAD_WT_GSR = reshape(xform_FADCorr_mice_GSR,128*128,[])*100;
FAD_WT_GSR_ROI = mean(FAD_WT_GSR(ROI_WT(:),:));
FAD_WT_GSR_ROI_subBaseline = FAD_WT_GSR_ROI-mean(FAD_WT_GSR_ROI(1:125));
figure
plot((1:750)/25,FAD_WT_ROI_subBaseline)
hold on
plot((1:750)/25,FAD_WT_GSR_ROI_subBaseline)


%% FAD from RGECO mice
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'xform_FADCorr_mice_GSR','xform_FADCorr_mice_NoGSR')
% Generate Peakmap with GSR
peakMap_ROI = mean(xform_FADCorr_mice_GSR(:,:,25*5+1:250),3)*100;
figure
imagesc(peakMap_ROI,[-1.1 1.1])
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
a=colorbar;
set(a,'YTick',[-1.1 0 1.1]);
ylabel(a,'\DeltaF/F%','FontSize',12,'Rotation',270);
% Generate ROI
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
[X,Y] = meshgrid(1:128,1:128);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI_RGECO = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_ROI(ROI_RGECO),99);
temp = peakMap_ROI.*ROI_RGECO;
ROI_RGECO = temp>0.75*max_ROI;
hold on
contour(ROI_RGECO,'w')
title('Corrected FAD Peak Map for RGECO with GSR')

% Time course without GSR
FAD_RGECO = reshape(xform_FADCorr_mice_NoGSR,128*128,[])*100;
FAD_RGECO_ROI = mean(FAD_RGECO(ROI_RGECO(:),:));
FAD_RGECO_ROI_subBaseline = FAD_RGECO_ROI-mean(FAD_RGECO_ROI(1:125));

% Time course with GSR
FAD_RGECO_GSR = reshape(xform_FADCorr_mice_GSR,128*128,[])*100;
FAD_RGECO_GSR_ROI = mean(FAD_RGECO_GSR(ROI_RGECO(:),:));
FAD_RGECO_GSR_ROI_subBaseline = FAD_RGECO_GSR_ROI-mean(FAD_RGECO_GSR_ROI(1:125));
figure
plot((1:750)/25,FAD_RGECO_ROI_subBaseline)
hold on
plot((1:750)/25,FAD_RGECO_GSR_ROI_subBaseline)

%% Time course comparison b/w WT and RGECO
% without GSR
stimFrequency = 3;
stimStartTime = 5;
stimduration = 5;
figure
h(1) = plot((1:750)/25,FAD_WT_ROI_subBaseline,'k-')
hold on
h(2) = plot((1:750)/25,FAD_RGECO_ROI_subBaseline,'m')
for ii  = 0:1/stimFrequency:stimduration-1/stimFrequency
    hold on
    line([stimStartTime+ii stimStartTime+ii],[-2 2],'Color','blue');
end
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Time course without GSR')
legend(h,'Wild Type','jRGECO1a')
ylim([-0.5, 1.5])
xlim([0 20])
% With GSR
figure
h(1) = plot((1:750)/25,FAD_WT_GSR_ROI_subBaseline,'k-')
hold on
h(2) = plot((1:750)/25,FAD_RGECO_GSR_ROI_subBaseline,'m')
for ii  = 0:1/stimFrequency:stimduration-1/stimFrequency
    hold on
    line([stimStartTime+ii stimStartTime+ii],[-2 2],'Color','blue');
end
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Time course with GSR')
legend(h,'Wild Type','jRGECO1a')
ylim([-0.5, 1.5])
xlim([0 20])

t_10_WT = (FAD_WT_GSR_ROI_subBaseline(126:134),(1:9)/25,