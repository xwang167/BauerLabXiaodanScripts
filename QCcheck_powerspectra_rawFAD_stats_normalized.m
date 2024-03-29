% excelRows = [ 195 202 204 230 234 240];
% excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
% saveDir_cat = "E:\RGECO\cat\";
% excelRows = 4:4:24;
% excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
% saveDir_cat = "X:\Paper1\WT_Paper1\cat\";
%% mice for WT awake
load("X:\Paper1\WT\210818\210818-W30M1-anes-fc_processed.mat",'hz')
excelFile = "X:\Paper1\WT\WT.xlsx";
excelRows = [2,4,7,11,14];
saveDir_cat = "X:\Paper1\WT\cat\";
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
powerdata_FADCorr_mice_all_norm = [];
powerdata_FAD_mice_all_norm = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_FAD_mouse','powerdata_FADCorr_mouse')
    powerdata_FAD_mice_all_norm = cat(1,powerdata_FAD_mice_all_norm,squeeze(powerdata_FAD_mouse)/interp1(hz,powerdata_FAD_mouse,0.01));
    powerdata_FADCorr_mice_all_norm = cat(1,powerdata_FADCorr_mice_all_norm,squeeze(powerdata_FADCorr_mouse)/interp1(hz,powerdata_FADCorr_mouse,0.01));
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
save(fullfile(saveDir_cat, processedName_mice),'powerdata_FADCorr_mice_all_norm','powerdata_FAD_mice_all_norm','-append')

%% mice for WT anes
excelFile = "X:\Paper1\WT\WT.xlsx";
excelRows = [3,5,8,12,15];
saveDir_cat = "X:\Paper1\WT\cat\";
numMice = length(excelRows);
powerdata_FADCorr_mice_all_norm = [];
powerdata_FAD_mice_all_norm = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_FAD_mouse','powerdata_FADCorr_mouse')
    powerdata_FAD_mice_all_norm = cat(1,powerdata_FAD_mice_all_norm,squeeze(powerdata_FAD_mouse)/interp1(hz,powerdata_FAD_mouse,0.01));
    powerdata_FADCorr_mice_all_norm = cat(1,powerdata_FADCorr_mice_all_norm,squeeze(powerdata_FADCorr_mouse)/interp1(hz,powerdata_FADCorr_mouse,0.01));
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
save(fullfile(saveDir_cat, processedName_mice),'powerdata_FADCorr_mice_all_norm','powerdata_FAD_mice_all_norm','-append')

%% mice for RGECO awake
excelRows = [181 183 185 228 232 236 ];
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
saveDir_cat = "E:\RGECO\cat\";

numMice = length(excelRows);
powerdata_FADCorr_mice_all_norm = [];
powerdata_FAD_mice_all_norm = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_FAD_mouse','powerdata_FADCorr_mouse')
    powerdata_FAD_mice_all_norm = cat(1,powerdata_FAD_mice_all_norm,squeeze(powerdata_FAD_mouse)/interp1(hz,powerdata_FAD_mouse,0.01));
    powerdata_FADCorr_mice_all_norm = cat(1,powerdata_FADCorr_mice_all_norm,squeeze(powerdata_FADCorr_mouse)/interp1(hz,powerdata_FADCorr_mouse,0.01));
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
save(fullfile(saveDir_cat, processedName_mice),'powerdata_FADCorr_mice_all_norm','powerdata_FAD_mice_all_norm','-append')


%% mice for RGECO anes
excelRows = [ 195 202 204 230 234 240];
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
saveDir_cat = "E:\RGECO\cat\";

numMice = length(excelRows);
powerdata_FADCorr_mice_all_norm = [];
powerdata_FAD_mice_all_norm = [];
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir, processedName),'powerdata_FAD_mouse','powerdata_FADCorr_mouse')
    powerdata_FAD_mice_all_norm = cat(1,powerdata_FAD_mice_all_norm,squeeze(powerdata_FAD_mouse)/interp1(hz,powerdata_FAD_mouse,0.01));
    powerdata_FADCorr_mice_all_norm = cat(1,powerdata_FADCorr_mice_all_norm,squeeze(powerdata_FADCorr_mouse)/interp1(hz,powerdata_FADCorr_mouse,0.01));
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
save(fullfile(saveDir_cat, processedName_mice),'powerdata_FADCorr_mice_all_norm','powerdata_FAD_mice_all_norm','-append')




%% Visualization

dr = [90 4 4]/255;
lr = [255 92 119]/255;

dg = [18 23 28]/255;
lg = [131 150 168]/255;
% Awake
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_FAD_mice_all_norm')
powerdata_FAD_mice_RGECO_awake_all = powerdata_FAD_mice_all_norm;
powerdata_FAD_mice_RGECO_awake_ISA = mean(powerdata_FAD_mice_all_norm(:,3:14),2);
powerdata_FAD_mice_RGECO_awake_inter = mean(powerdata_FAD_mice_all_norm(:,14:66),2);
powerdata_FAD_mice_RGECO_awake_Delta = mean(powerdata_FAD_mice_all_norm(:,66:656),2);

load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'powerdata_FADCorr_mice_all_norm')
powerdata_FADCorr_mice_RGECO_awake_all = powerdata_FADCorr_mice_all_norm;
powerdata_FADCorr_mice_RGECO_awake_ISA = mean(powerdata_FADCorr_mice_all_norm(:,3:14),2);
powerdata_FADCorr_mice_RGECO_awake_inter = mean(powerdata_FADCorr_mice_all_norm(:,14:66),2);
powerdata_FADCorr_mice_RGECO_awake_Delta = mean(powerdata_FADCorr_mice_all_norm(:,66:656),2);

load("X:\Paper1\WT\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-fc.mat", 'powerdata_FAD_mice_all_norm', 'powerdata_FADCorr_mice_all_norm')
powerdata_FAD_mice_WT_awake_all = powerdata_FAD_mice_all_norm;
powerdata_FAD_mice_WT_awake_ISA = mean(powerdata_FAD_mice_all_norm(:,3:14),2);
powerdata_FAD_mice_WT_awake_inter = mean(powerdata_FAD_mice_all_norm(:,14:66),2);
powerdata_FAD_mice_WT_awake_Delta = mean(powerdata_FAD_mice_all_norm(:,66:656),2);

powerdata_FADCorr_mice_WT_awake_all = powerdata_FADCorr_mice_all_norm;
powerdata_FADCorr_mice_WT_awake_ISA = mean(powerdata_FADCorr_mice_all_norm(:,3:14),2);
powerdata_FADCorr_mice_WT_awake_inter = mean(powerdata_FADCorr_mice_all_norm(:,14:66),2);
powerdata_FADCorr_mice_WT_awake_Delta = mean(powerdata_FADCorr_mice_all_norm(:,66:656),2);

[h_FAD_awake_ISA,p_FAD_awake_ISA] = ttest2(powerdata_FAD_mice_RGECO_awake_ISA,powerdata_FAD_mice_WT_awake_ISA);
[h_FADCorr_awake_ISA,p_FADCorr_awake_ISA] = ttest2(powerdata_FADCorr_mice_RGECO_awake_ISA,powerdata_FADCorr_mice_WT_awake_ISA);

[h_FAD_awake_inter,p_FAD_awake_inter] = ttest2(powerdata_FAD_mice_RGECO_awake_inter,powerdata_FAD_mice_WT_awake_inter);
[h_FADCorr_awake_inter,p_FADCorr_awake_inter] = ttest2(powerdata_FADCorr_mice_RGECO_awake_inter,powerdata_FADCorr_mice_WT_awake_inter);

[h_FAD_awake_Delta,p_FAD_awake_Delta] = ttest2(powerdata_FAD_mice_RGECO_awake_Delta,powerdata_FAD_mice_WT_awake_Delta);
[h_FADCorr_awake_Delta,p_FADCorr_awake_Delta] = ttest2(powerdata_FADCorr_mice_RGECO_awake_Delta,powerdata_FADCorr_mice_WT_awake_Delta);

figure
plot_distribution_prctile(hz',powerdata_FADCorr_mice_RGECO_awake_all,'color',dr)
hold on
plot_distribution_prctile(hz',powerdata_FAD_mice_RGECO_awake_all,'color',lr)
hold on
plot_distribution_prctile(hz',powerdata_FADCorr_mice_WT_awake_all,'color',dg)
hold on
plot_distribution_prctile(hz',powerdata_FAD_mice_WT_awake_all,'color',lg)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlim([0.01 10])
% legend('Corrected FAF in Thy1-jRGECO1a mice','Raw FAF in Thy1-jRGECO1a mice','Corrected FAF in C57BL/6J mice','Raw FAD in C57BL/6J mice')
title('Awake')
xlabel('Frequency(Hz)')
ylabel('FAF(\DeltaF/F)')
% Anes
load("E:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat", 'powerdata_FAD_mice_all_norm','powerdata_FADCorr_mice_all_norm')
powerdata_FAD_mice_RGECO_anes_all = powerdata_FAD_mice_all_norm;
powerdata_FAD_mice_RGECO_anes_ISA = mean(powerdata_FAD_mice_all_norm(:,3:14),2);
powerdata_FAD_mice_RGECO_anes_inter = mean(powerdata_FAD_mice_all_norm(:,14:66),2);
powerdata_FAD_mice_RGECO_anes_Delta = mean(powerdata_FAD_mice_all_norm(:,66:656),2);

powerdata_FADCorr_mice_RGECO_anes_all = powerdata_FADCorr_mice_all_norm;
powerdata_FADCorr_mice_RGECO_anes_ISA = mean(powerdata_FADCorr_mice_all_norm(:,3:14),2);
powerdata_FADCorr_mice_RGECO_anes_inter = mean(powerdata_FADCorr_mice_all_norm(:,14:66),2);
powerdata_FADCorr_mice_RGECO_anes_Delta = mean(powerdata_FADCorr_mice_all_norm(:,66:656),2);

load("X:\Paper1\WT\cat\210830--W30M1-anes-W30M2-anes-W30M3-anes-W31M1-anes-W31M2-anes-fc.mat",'powerdata_FAD_mice_all_norm','powerdata_FADCorr_mice_all_norm')
powerdata_FAD_mice_WT_anes_all = powerdata_FAD_mice_all_norm;
powerdata_FAD_mice_WT_anes_ISA = mean(powerdata_FAD_mice_all_norm(:,3:14),2);
powerdata_FAD_mice_WT_anes_inter = mean(powerdata_FAD_mice_all_norm(:,14:66),2);
powerdata_FAD_mice_WT_anes_Delta = mean(powerdata_FAD_mice_all_norm(:,66:656),2);

powerdata_FADCorr_mice_WT_anes_all = powerdata_FADCorr_mice_all_norm;
powerdata_FADCorr_mice_WT_anes_ISA = mean(powerdata_FADCorr_mice_all_norm(:,3:14),2);
powerdata_FADCorr_mice_WT_anes_inter = mean(powerdata_FADCorr_mice_all_norm(:,14:66),2);
powerdata_FADCorr_mice_WT_anes_Delta = mean(powerdata_FADCorr_mice_all_norm(:,66:656),2);

[h_FAD_anes_ISA,p_FAD_anes_ISA] = ttest2(powerdata_FAD_mice_RGECO_anes_ISA,powerdata_FAD_mice_WT_anes_ISA);
[h_FADCorr_anes_ISA,p_FADCorr_anes_ISA] = ttest2(powerdata_FADCorr_mice_RGECO_anes_ISA,powerdata_FADCorr_mice_WT_anes_ISA);

[h_FAD_anes_inter,p_FAD_anes_inter] = ttest2(powerdata_FAD_mice_RGECO_anes_inter,powerdata_FAD_mice_WT_anes_inter);
[h_FADCorr_anes_inter,p_FADCorr_anes_inter] = ttest2(powerdata_FADCorr_mice_RGECO_anes_inter,powerdata_FADCorr_mice_WT_anes_inter);

[h_FAD_anes_Delta,p_FAD_anes_Delta] = ttest2(powerdata_FAD_mice_RGECO_anes_Delta,powerdata_FAD_mice_WT_anes_Delta);
[h_FADCorr_anes_Delta,p_FADCorr_anes_Delta] = ttest2(powerdata_FADCorr_mice_RGECO_anes_Delta,powerdata_FADCorr_mice_WT_anes_Delta);


figure
plot_distribution_prctile(hz',powerdata_FADCorr_mice_RGECO_anes_all,'color',dr)
hold on
plot_distribution_prctile(hz',powerdata_FAD_mice_RGECO_anes_all,'color',lr)
hold on
plot_distribution_prctile(hz',powerdata_FADCorr_mice_WT_anes_all,'color',dg)
hold on
plot_distribution_prctile(hz',powerdata_FAD_mice_WT_anes_all,'color',lg)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlim([0.01 10])
% legend('Corrected FAF in Thy1-jRGECO1a mice','Raw FAF in Thy1-jRGECO1a mice','Corrected FAF in C57BL/6J mice','Raw FAD in C57BL/6J mice')
title('Anesthetized')
xlabel('Frequency(Hz)')
ylabel('FAF(\DeltaF/F)')