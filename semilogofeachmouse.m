%close all;clear all;clc
import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = [2:7];%:450;
Colors = [0 0.4470 0.7410 0.3;0.8500 0.3250 0.0980 0.3;0.9290 0.6940 0.1250 0.3;...
    0.4940 0.1840 0.5560 0.3;0.4660 0.6740 0.1880 0.3;0.3010 0.7450 0.9330 0.3];
figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir,processedName),'powerdata_jrgeco1aCorr_mouse','hz');
   semilogx(hz,10*log10(powerdata_jrgeco1aCorr_mouse/interp1(hz,powerdata_jrgeco1aCorr_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_jrgeco1aCorr_mice')
semilogx(hz,10*log10(powerdata_jrgeco1aCorr_mice/interp1(hz,powerdata_jrgeco1aCorr_mice,0.01)),'m-')
title('Awake RGECO')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\DeltaF/F%)^2/Hz')


figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir,processedName),'powerdata_FADCorr_mouse','hz');
   semilogx(hz,10*log10(powerdata_FADCorr_mouse/interp1(hz,powerdata_FADCorr_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_FADCorr_mice')
semilogx(hz,10*log10(powerdata_FADCorr_mice/interp1(hz,powerdata_FADCorr_mice,0.01)),'g-')
title('Awake FAD')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\DeltaF/F%)^2/Hz')



figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir,processedName),'powerdata_total_mouse','hz');
   semilogx(hz,10*log10(powerdata_total_mouse/interp1(hz,powerdata_total_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_total_mice')
semilogx(hz,10*log10(powerdata_total_mice/interp1(hz,powerdata_total_mice,0.01)),'k-')
title('Awake HbT')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\Delta\muM)^2/Hz')





import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = [8:13];%:450;
Colors = [0 0.4470 0.7410 0.3;0.8500 0.3250 0.0980 0.3;0.9290 0.6940 0.1250 0.3;...
    0.4940 0.1840 0.5560 0.3;0.4660 0.6740 0.1880 0.3;0.3010 0.7450 0.9330 0.3];
figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),'allruns',recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir,processedName),'powerdata_jrgeco1aCorr_mouse','hz');
  semilogx(hz,10*log10(powerdata_jrgeco1aCorr_mouse/interp1(hz,powerdata_jrgeco1aCorr_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\allruns\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat', 'powerdata_jrgeco1aCorr_mice')
semilogx(hz,10*log10(powerdata_jrgeco1aCorr_mice/interp1(hz,powerdata_jrgeco1aCorr_mice,0.01)),'m-')
title('Anesthetized RGECO')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\DeltaF/F%)^2/Hz')


figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),'allruns',recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir,processedName),'powerdata_FADCorr_mouse','hz');
   semilogx(hz,10*log10(powerdata_FADCorr_mouse/interp1(hz,powerdata_FADCorr_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\allruns\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat', 'powerdata_FADCorr_mice')
semilogx(hz,10*log10(powerdata_FADCorr_mice/interp1(hz,powerdata_FADCorr_mice,0.01)),'g-')
title('Anesthetized FAD')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\DeltaF/F%)^2/Hz')



figure
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; 
     saveDir_new = fullfile(string(saveDir),'allruns',recDate);
     saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
   processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
   load(fullfile(saveDir_new,processedName),'powerdata_total_mouse','hz');
   semilogx(hz,10*log10(powerdata_total_mouse/interp1(hz,powerdata_total_mouse,0.01)),'color',Colors(ii,:))
   hold on
   ii = ii+1;
end
hold on
load('L:\RGECO\allruns\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat', 'powerdata_total_mice')
semilogx(hz,10*log10(powerdata_total_mice/interp1(hz,powerdata_total_mice,0.01)),'k-')
title('Anesthetized HbT')
xlim([0.01,10])
xlabel('Frequency(Hz)')
ylabel('dB(\Delta\muM)^2/Hz')