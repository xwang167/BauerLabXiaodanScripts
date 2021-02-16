load('190627-R5M2285-fc2_processed.mat', 'lagTimeTrial_FADCalcium')
load('190627-R5M2285-fc2_processed.mat', 'xform_jrgeco1aCorr_GSR')
load('190627-R5M2285-fc2_processed.mat', 'xform_FADCorr_GSR')
fs =25;
time = (1:14999)/fs;
xform_FADCorr_GSR_filtered = mouse.freq.filterData(double(xform_FADCorr_GSR),0.02,2,fs);
xform_jrgeco1aCorr_GSR_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr_GSR),0.02,2,fs);
edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
[lagTimeTrial_FADCalcium, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
    xform_FADCorr_GSR_filtered(:,:,200*25:500*25),xform_jrgeco1aCorr_GSR_filtered(:,:,200*25:500*25),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_FADCalcium = lagTimeTrial_FADCalcium./25;
imagesc(lagTimeTrial_FADCalcium,[0 1])
colormap jet
hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
axis image off
colorbar

[lagTimeTrial_FADCalcium_old, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
    xform_FADCorr_GSR_filtered(:,:,200*25:end),xform_jrgeco1aCorr_GSR_filtered(:,:,200*25:end),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_FADCalcium = lagTimeTrial_FADCalcium./25;
imagesc(lagTimeTrial_FADCalcium,[0 1])
colormap jet
hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
axis image off
colorbar

[lagTimeTrial_FADCalcium_new, lagAmpTrial_FADCalcium,covResult_FADCalcium] = dotLag_xw(...
    xform_FADCorr_GSR_filtered,xform_jrgeco1aCorr_GSR_filtered,edgeLen,validRange,corrThr, true,true,0.5*fs);

[lagTimeTrial_FADCalcium, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
    xform_FADCorr_GSR_filtered,xform_jrgeco1aCorr_GSR_filtered,edgeLen,validRange,corrThr, true,true);
lagTimeTrial_FADCalcium = lagTimeTrial_FADCalcium./25;
imagesc(lagTimeTrial_FADCalcium,[0 1])
colormap jet
hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
axis image off
colorbar



figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(56,107,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(56,107,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')
xlabel('Time(s)')
edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);

[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,107,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,107,:)),...
    true,true,validRange,...
    edgeLen,corrThr);

[lagTime,lagAmp,,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,107,200*25:500*25)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,107,200*25:500*25)),...
    true,true,validRange,...
    edgeLen,corrThr);





uiopen('L:\RGECO\190627\190627-R5M2285-fc2_Lag_GSR.fig',1)
time = (1:14999)/25;
hold on
scatter(102,56,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(56,102,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(56,102,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,102,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,102,:)),...
    true,true,validRange,...
    edgeLen,corrThr);


[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,102,200*25:end)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,102,200*25:end)),...
    true,true,validRange,...
    edgeLen,corrThr);


uiopen('L:\RGECO\190627\190627-R5M2285-fc2_Lag_GSR.fig',1)
time = (1:14999)/25;
hold on
scatter(97,56,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(56,97,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(56,97,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResult,sign,lags]...
    = findLag_xw(squeeze(xform_FADCorr_GSR_filtered(56,97,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,97,:)),...
    true,true,validRange,...
    edgeLen,corrThr,fs*0.5);
[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,97,200*25:end)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,97,200*25:end)),...
    true,true,validRange,...
    edgeLen,corrThr);


uiopen('L:\RGECO\190627\190627-R5M2285-fc2_Lag_GSR.fig',1)
time = (1:14999)/25;
hold on
scatter(92,56,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(56,92,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(56,92,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,92,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,92,:)),...
    true,true,validRange,...
    edgeLen,corrThr);

[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,92,200*25:end)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,92,200*25:end)),...
    true,true,validRange,...
    edgeLen,corrThr);

uiopen('L:\RGECO\190627\190627-R5M2285-fc2_Lag_GSR.fig',1)
time = (1:14999)/25;
hold on
scatter(87,56,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(56,87,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(56,87,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,87,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,87,:)),...
    true,true,validRange,...
    edgeLen,corrThr);

[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,87,200*25:500*25)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,87,200*25:500*25)),...
    true,true,validRange,...
    edgeLen,corrThr);





load('L:\RGECO\191030\191030-R6M2497-awake-fc1_processed.mat', 'lagTimeTrial_FADCalcium','xform_jrgeco1aCorr','xform_FADCorr')
fs =25;
time = (1:14999)/fs;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_FADCorr_filtered = mouse.freq.filterData(double(xform_FADCorr),0.02,2,fs);
xform_jrgeco1aCorr_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.02,2,fs);
edgeLen =1;
tZone = 4;

[lagTimeTrial_FADCalcium_old_NoGSR, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
    xform_FADCorr_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true);
lagTimeTrial_FADCalcium = lagTimeTrial_FADCalcium./25;
figure
imagesc(lagTimeTrial_FADCalcium_old/25,[0 1])
colormap jet
hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
axis image off
colorbar
title('Old')

[lagTimeTrial_FADCalcium_new_NoGSR, lagAmpTrial_FADCalcium,covResult_FADCalcium] = dotLag_xw(...
    xform_FADCorr_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true,fs);
figure
imagesc(lagTimeTrial_FADCalcium_new_NoGSR/25,[0 1])
colormap jet
hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
axis image off
colorbar
title('New')

[lagTime,lagAmp,covResult,sign,lags]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_filtered(97,112,:)),...
    squeeze(xform_jrgeco1aCorr_filtered(97,112,:)),...
    true,true,validRange,...
    edgeLen,corrThr);