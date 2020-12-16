load('190627-R5M2285-fc2_processed.mat', 'lagTimeTrial_FADCalcium')
load('190627-R5M2285-fc2_processed.mat', 'xform_jrgeco1aCorr_GSR')
load('190627-R5M2285-fc2_processed.mat', 'xform_FADCorr_GSR')
fs =25;
time = (1:14999)/fs;
xform_FADCorr_GSR_filtered = mouse.freq.filterData(double(xform_FADCorr_GSR),0.02,2,fs);
xform_jrgeco1aCorr_GSR_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr_GSR),0.02,2,fs);
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

[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,107,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,107,:)),...
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


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,97,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,97,:)),...
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


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,102,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,102,:)),...
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


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,92,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,92,:)),...
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


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(56,87,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(56,87,:)),...
    true,true,validRange,...
    edgeLen,corrThr);






load('190707-R5M2286-anes-fc1_processed.mat', 'lagTimeTrial_FADCalcium')
load('190707-R5M2286-anes-fc1_processed.mat', 'xform_jrgeco1aCorr_GSR')
load('190707-R5M2286-anes-fc1_processed.mat', 'xform_FADCorr_GSR')
fs =25;
time = (1:14999)/fs;
xform_FADCorr_GSR_filtered = mouse.freq.filterData(double(xform_FADCorr_GSR),0.02,2,fs);
xform_jrgeco1aCorr_GSR_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr_GSR),0.02,2,fs);
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(81,10,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(81,10,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')
xlabel('Time(s)')
edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);

[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(81,10,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(81,10,:)),...
    true,true,validRange,...
    edgeLen,corrThr);

 uiopen('L:\RGECO\190707\190707-R5M2286-anes-fc1_Lag_GSR.fig',1)
time = (1:14999)/25;
hold on
scatter(20,81,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(81,20,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(81,20,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(81,20,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(81,20,:)),...
    true,true,validRange,...
    edgeLen,corrThr);



 uiopen('L:\RGECO\190707\190707-R5M2286-anes-fc1_Lag_GSR.fig',1)
hold on
scatter(15,81,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(81,15,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(81,15,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(81,15,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(81,15,:)),...
    true,true,validRange,...
    edgeLen,corrThr);


 uiopen('L:\RGECO\190707\190707-R5M2286-anes-fc1_Lag_GSR.fig',1)
hold on
scatter(25,81,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(81,25,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(81,25,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(81,25,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(81,25,:)),...
    true,true,validRange,...
    edgeLen,corrThr);

 uiopen('L:\RGECO\190707\190707-R5M2286-anes-fc1_Lag_GSR.fig',1)
hold on
scatter(30,81,'filled','k')
figure
plot(time,normr(transpose(squeeze(xform_FADCorr_GSR_filtered(81,30,:)))),'g')
hold on
plot(time,normr(transpose(squeeze(xform_jrgeco1aCorr_GSR_filtered(81,30,:)))),'m')
legend('Normalized Corrected FAD','Normalized Corrected RGECO')


[lagTime,lagAmp,covResultPix]...
    = mouse.conn.findLag(squeeze(xform_FADCorr_GSR_filtered(81,30,:)),...
    squeeze(xform_jrgeco1aCorr_GSR_filtered(81,30,:)),...
    true,true,validRange,...
    edgeLen,corrThr);