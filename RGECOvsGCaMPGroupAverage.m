close all;clear;clc
load('GoodWL.mat','xform_WL')
load('noVasculatureMask.mat')

load('X:\Paper1\RGECO\cat\211220--R21M1-R23M1-RM1-stim_processed_mice.mat', 'xform_jrgeco1aCorr_mice_NoGSR', 'xform_isbrain_mice')
baseline_rgeco = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,1:125),3);
xform_jrgeco1aCorr_mice_NoGSR = xform_jrgeco1aCorr_mice_NoGSR-baseline_rgeco;
mask_rgeco = logical(xform_isbrain_mice.*(leftMask+rightMask));

load('X:\Paper1\GCaMP\cat\211210--G1M1-G1M2-G2M1-stim_correction11_mice.mat',  'xform_gcampCorr_mice_NoGSR', 'xform_isbrain_mice')
baseline_gcamp = mean(xform_gcampCorr_mice_NoGSR(:,:,1:125),3);
xform_gcampCorr_mice_NoGSR = xform_gcampCorr_mice_NoGSR-baseline_gcamp;

mask_gcamp = logical(xform_isbrain_mice.*(leftMask+rightMask));

peakMap_rgeco = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,126:250),3)*100;
peakMap_gcamp = mean(xform_gcampCorr_mice_NoGSR(:,:,126:250),3)   *100;

max_rgecco = max(peakMap_rgeco(mask_rgeco));
max_gcamp  = max(peakMap_gcamp(mask_gcamp));


% peak map with GSR for corrected rgeco and gcamp, colormap -spectral
figure
subplot(121)
imagesc(peakMap_rgeco,[-max_rgecco max_rgecco]);
hold on
imagesc(xform_WL,'AlphaData',1-mask_rgeco)
colorbar
axis image off
colormap(brewermap(256, '-Spectral'));
title('Thy1-jRGECO1a','Color','m')


subplot(122)
imagesc(peakMap_gcamp,[-max_gcamp max_gcamp]);
hold on
imagesc(xform_WL,'AlphaData',1-mask_gcamp)
colorbar
axis image off
colormap(brewermap(256, '-Spectral'));
title('Thy1-GCaMP6f','Color',[107,142,35]/255)

%% generate ROI
figure
subplot(121)
imagesc(peakMap_rgeco,[-max_rgecco max_rgecco]);
hold on
imagesc(xform_WL,'AlphaData',1-mask_rgeco)
colorbar
axis image off
colormap(brewermap(256, '-Spectral'));
title('Thy1-jRGECO1a','Color','m')


subplot(122)
imagesc(peakMap_gcamp,[-max_gcamp max_gcamp]);
hold on
imagesc(xform_WL,'AlphaData',1-mask_gcamp)
colorbar
axis image off
colormap(brewermap(256, '-Spectral'));
title('Thy1-GCaMP6f','Color',[107,142,35]/255)


ROI_rgeco = getROI('rgeco',peakMap_rgeco);  
ROI_gcamp = getROI('gcamp',peakMap_gcamp); 

subplot(121)
hold on
contour(ROI_rgeco,'k')

subplot(122)
hold on
contour(ROI_gcamp,'Color','k')

% time course without GSR for corrected rgeco and gcamp,color, 'm', olivedrab
% [107,142,35]/255

rgeco = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
clear xform_jrgeco1aCorr_mice_NoGSR
rgeco_timetrace = mean(rgeco(ROI_rgeco(:),:));

gcamp = reshape(xform_gcampCorr_mice_NoGSR,128*128,[]);
clear xform_gcampCorr_mice_NoGSR
gcamp_timetrace = mean(gcamp(ROI_gcamp(:),:));


% plot
figure
plot((1:750)/25,rgeco_timetrace,'m')
hold on
plot((1:750)/25,gcamp_timetrace,'Color',[107,142,35]/255)
legend('jRGECO1a','GCaMP')
ylabel('Fluorescence(\DeltaF/F)')
xlabel('Time(s)')
function ROI = getROI(species,peakMap)
f = msgbox(strcat("Click center for", species));        
[x1,y1] = clicksubplot;
close(f)
f = msgbox(strcat("Click edge for", species)); 
[x2,y2] = clicksubplot;
close(f)

[X,Y] = meshgrid(1:128,1:128);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;

max_ROI = prctile(peakMap(ROI),99);

temp = peakMap.*ROI;

ROI = temp>0.75*max_ROI;
end
