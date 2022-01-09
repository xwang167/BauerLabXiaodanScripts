clear all
close all
clc
import mouse.*
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
mask = logical(leftMask+rightMask);



excelFile = 'Y:\CTREM\WT.xlsx';
excelRows = 2:15;
miceName = 'TremWT';
saveDir_cat = 'Y:\CTREM\Group level averages\AvgAcrossMice';
[spectraAllMice,runFreq,speciesList] = examplePowerAnalysis_ISA(excelFile, excelRows);
powerMap_ISA = zeros(128,128,length(speciesList),length(excelRows));
powerMap_Delta = zeros(128,128,length(speciesList),length(excelRows));
powerMap_ISA_avg = zeros(length(excelRows),length(speciesList));
powerMap_Delta_avg = zeros(length(excelRows),length(speciesList));
for ind = 1:length(excelRows)
    for ind2 = 1:length(speciesList)
        bandFreq_ISA = runFreq{ind2} >= 0.009 & runFreq{ind2} <= 0.08;
        powerMap_ISA(:,:,ind2,ind) = mean(spectraAllMice{ind,ind2}(:,:,bandFreq_ISA),3);
        temp_ISA = squeeze(powerMap_ISA(:,:,ind2,ind));
        powerMap_ISA_avg(ind,ind2) = mean(temp_ISA(mask));
        
        bandFreq_Delta = runFreq{ind2} >= 0.4 & runFreq{ind2} <= 4;
        powerMap_Delta(:,:,ind2,ind) = mean(spectraAllMice{ind,ind2}(:,:,bandFreq_Delta),3);
        temp_Delta = squeeze(powerMap_Delta(:,:,ind2,ind));
        powerMap_Delta_avg(ind,ind2) = mean(temp_Delta(mask));
        
        
        spectraLog10 = log10(spectraAllMice{ind,ind2});
        spectraLogBand = spectraLog10(:,:,bandFreq_Delta);
        meanSpectraLogBand = mean(spectraLogBand,3);
    end
end




excelFile = 'Y:\CTREM\HET.xlsx';
excelRows = 2:7;
miceCat = 'TremHet';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremHet';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask));
    lagAmpTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask));
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_Het = mean(lagTimeTrial_HbTCalcium_mice_mean_Het);
lagTime_std_Het = std(lagTimeTrial_HbTCalcium_mice_mean_Het);
lagAmp_mean_Het = mean(lagAmpTrial_HbTCalcium_mice_mean_Het);
lagAmp_std_Het = std(lagAmpTrial_HbTCalcium_mice_mean_Het);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_Het','lagTime_std_Het',...
    'lagAmp_mean_Het','lagAmp_std_Het')



excelFile = 'Y:\CTREM\KO.xlsx';
excelRows = 2:9;
miceCat = 'TremKO';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremKO';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_HbTCalcium_mice_mean_KO(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask));
    lagAmpTrial_HbTCalcium_mice_mean_KO(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask));
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_KO = mean(lagTimeTrial_HbTCalcium_mice_mean_KO);
lagTime_std_KO = std(lagTimeTrial_HbTCalcium_mice_mean_KO);
lagAmp_mean_KO = mean(lagAmpTrial_HbTCalcium_mice_mean_KO);
lagAmp_std_KO = std(lagAmpTrial_HbTCalcium_mice_mean_KO);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_KO','lagTime_std_KO',...
    'lagAmp_mean_KO','lagAmp_std_KO')


%
excelFile = 'Y:\CTREM\WTFAD.xlsx';
excelRows = 2:14;
miceCat = 'TremWTFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremWTFAD';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_HbTCalcium_mice_mean_WTFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask));
    lagAmpTrial_HbTCalcium_mice_mean_WTFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask));
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_WTFAD = mean(lagTimeTrial_HbTCalcium_mice_mean_WTFAD);
lagTime_std_WTFAD = std(lagTimeTrial_HbTCalcium_mice_mean_WTFAD);
lagAmp_mean_WTFAD = mean(lagAmpTrial_HbTCalcium_mice_mean_WTFAD);
lagAmp_std_WTFAD = std(lagAmpTrial_HbTCalcium_mice_mean_WTFAD);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_WTFAD','lagTime_std_WTFAD',...
    'lagAmp_mean_WTFAD','lagAmp_std_WTFAD')




excelFile = 'Y:\CTREM\HETFAD.xlsx';
excelRows = 2:7;
miceCat = 'TremHetFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremHetFAD';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_HbTCalcium_mice_mean_HetFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask));
    lagAmpTrial_HbTCalcium_mice_mean_HetFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask));
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_HetFAD = mean(lagTimeTrial_HbTCalcium_mice_mean_HetFAD);
lagTime_std_HetFAD = std(lagTimeTrial_HbTCalcium_mice_mean_HetFAD);
lagAmp_mean_HetFAD = mean(lagAmpTrial_HbTCalcium_mice_mean_HetFAD);
lagAmp_std_HetFAD = std(lagAmpTrial_HbTCalcium_mice_mean_HetFAD);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_HetFAD','lagTime_std_HetFAD',...
    'lagAmp_mean_HetFAD','lagAmp_std_HetFAD')


excelFile = 'Y:\CTREM\KOFAD.xlsx';
excelRows = 2:10;
miceCat = 'TremKOFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremKOFAD';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_HbTCalcium_mice_mean_KOFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask));
    lagAmpTrial_HbTCalcium_mice_mean_KOFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask));
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_KOFAD = mean(lagTimeTrial_HbTCalcium_mice_mean_KOFAD);
lagTime_std_KOFAD = std(lagTimeTrial_HbTCalcium_mice_mean_KOFAD);
lagAmp_mean_KOFAD = mean(lagAmpTrial_HbTCalcium_mice_mean_KOFAD);
lagAmp_std_KOFAD = std(lagAmpTrial_HbTCalcium_mice_mean_KOFAD);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_KOFAD','lagTime_std_KOFAD',...
    'lagAmp_mean_KOFAD','lagAmp_std_KOFAD')







figure
b = bar(1:6,[lagTime_mean_WT,lagTime_mean_Het,lagTime_mean_KO,lagTime_mean_WTFAD,lagTime_mean_HetFAD,lagTime_mean_KOFAD],0.5);
hold on
er = errorbar(1:6,[lagTime_mean_WT,lagTime_mean_Het,lagTime_mean_KO,lagTime_mean_WTFAD,lagTime_mean_HetFAD,lagTime_mean_KOFAD],zeros(1,6),...
    [lagTime_std_WT,lagTime_std_Het,lagTime_std_KO,lagTime_std_WTFAD,lagTime_std_HetFAD,lagTime_std_KOFAD]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'Trem WT','Trem Het','Trem KO','TremWT FAD', 'TremHet FAD', 'TremKO FAD'})
ylabel('Lag Time(s)')
title('Colonna Project')

% [h_WT_WTFAD,p_WT_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_WTFAD,0.05, 'both', 'unequal');
% [h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WTFAD,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');
% [h_WT_KO,p_WT_KO] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_KO,0.05, 'both', 'unequal');
[h_WT_Het,p_WT_Het] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_Het,0.05, 'both', 'unequal');
[h_WT_KO,p_WT_KO] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_KO,0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_WTFAD,0.05, 'both', 'unequal');
[h_WT_HetFAD,p_WT_HetFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_HetFAD,0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');

[h_Het_KO,p_Het_KO] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_Het,lagTimeTrial_HbTCalcium_mice_mean_KO,0.05, 'both', 'unequal');
[h_Het_WTFAD,p_Het_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_Het,lagTimeTrial_HbTCalcium_mice_mean_WTFAD,0.05, 'both', 'unequal');
[h_Het_HetFAD,p_Het_HetFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_Het,lagTimeTrial_HbTCalcium_mice_mean_HetFAD,0.05, 'both', 'unequal');
[h_Het_KOFAD,p_Het_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_Het,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');

[h_KO_WTFAD,p_KO_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_KO,lagTimeTrial_HbTCalcium_mice_mean_WTFAD,0.05, 'both', 'unequal');
[h_KO_HetFAD,p_KO_HetFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_KO,lagTimeTrial_HbTCalcium_mice_mean_HetFAD,0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_KO,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');

[h_WTFAD_HetFAD,p_WTFAD_HetFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WTFAD,lagTimeTrial_HbTCalcium_mice_mean_HetFAD,0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WTFAD,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');

[h_HetFAD_KOFAD,p_HetFAD_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_HetFAD,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');


% sigstar({[1,4]},p_WT_WTFAD,0,1)
% sigstar({[4,6]},p_WTFAD_KOFAD,0,1)
% sigstar({[1,3]},p_WT_KO,0,1)
