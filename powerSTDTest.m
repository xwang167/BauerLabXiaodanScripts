
close all;clearvars -except hz;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
nVx = 128;
nVy = 128;
excelRows_awake = [181 183 185 228  232  236 ];
excelRows_anes = [ 202 195 204 230 234 240];
runs = 1:3;
load('D:\OIS_Process\noVasculaturemask.mat')
mask_new = logical(mask_new);

power_jrgeco1aCorr_ISA_awake = nan(1,6);
power_jrgeco1aCorr_Delta_awake = nan(1,6);
power_total_ISA_awake = nan(1,6);
power_total_Delta_awake = nan(1,6);
power_FADCorr_ISA_awake = nan(1,6);
power_FADCorr_Delta_awake = nan(1,6);

power_jrgeco1aCorr_ISA_anes = nan(1,6);     
power_jrgeco1aCorr_Delta_anes = nan(1,6);
power_FADCorr_ISA_anes = nan(1,6);
power_FADCorr_Delta_anes = nan(1,6);
power_total_ISA_anes = nan(1,6);
power_total_Delta_anes = nan(1,6);


power_jrgeco1aCorr_ISA_ratio = nan(1,6);
power_jrgeco1aCorr_Delta_ratio = nan(1,6);

power_FADCorr_ISA_ratio = nan(1,6);
power_FADCorr_Delta_ratio = nan(1,6);

power_total_ISA_ratio = nan(1,6);
power_total_Delta_ratio = nan(1,6);

ii = 1;
for excelRow = excelRows_awake
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    goodRuns = str2num(excelRaw{18});
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse), 'total_ISA_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
        'total_Delta_powerMap_mouse','jrgeco1aCorr_Delta_powerMap_mouse','FADCorr_Delta_powerMap_mouse')
    
    power_jrgeco1aCorr_ISA_awake(ii) = mean(jrgeco1aCorr_ISA_powerMap_mouse(mask_new));
    power_jrgeco1aCorr_Delta_awake(ii) = mean(jrgeco1aCorr_Delta_powerMap_mouse(mask_new));
    power_total_ISA_awake(ii) = mean(total_ISA_powerMap_mouse(mask_new));
    power_total_Delta_awake(ii) =mean(total_Delta_powerMap_mouse(mask_new));
    power_FADCorr_ISA_awake(ii) = mean(FADCorr_ISA_powerMap_mouse(mask_new));
    power_FADCorr_Delta_awake(ii) = mean(FADCorr_Delta_powerMap_mouse(mask_new));
    ii =ii+1;
end
 ii = 1;
for excelRow = excelRows_anes
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    goodRuns = str2num(excelRaw{18});
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse), 'total_ISA_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
        'total_Delta_powerMap_mouse','jrgeco1aCorr_Delta_powerMap_mouse','FADCorr_Delta_powerMap_mouse')
    
    power_jrgeco1aCorr_ISA_anes(ii) = mean(jrgeco1aCorr_ISA_powerMap_mouse(mask_new));
    power_jrgeco1aCorr_Delta_anes(ii) = mean(jrgeco1aCorr_Delta_powerMap_mouse(mask_new));
    power_total_ISA_anes(ii) = mean(total_ISA_powerMap_mouse(mask_new));
    power_total_Delta_anes(ii) = mean(total_Delta_powerMap_mouse(mask_new));
    power_FADCorr_ISA_anes(ii) = mean(FADCorr_ISA_powerMap_mouse(mask_new));
    power_FADCorr_Delta_anes(ii) = mean(FADCorr_Delta_powerMap_mouse(mask_new));
    ii =ii+1;
end

power_jrgeco1aCorr_ISA_ratio = power_jrgeco1aCorr_ISA_anes./power_jrgeco1aCorr_ISA_awake;
power_jrgeco1aCorr_Delta_ratio = power_jrgeco1aCorr_Delta_anes./power_jrgeco1aCorr_Delta_awake;

power_FADCorr_ISA_ratio = power_FADCorr_ISA_anes./power_FADCorr_ISA_awake;
power_FADCorr_Delta_ratio = power_FADCorr_Delta_anes./power_FADCorr_Delta_awake;

power_total_ISA_ratio = power_total_ISA_anes./power_total_ISA_awake;
power_total_Delta_ratio = power_total_Delta_anes./power_total_Delta_awake;


power_jrgeco1aCorr_ISA_ratio_std = std(power_jrgeco1aCorr_ISA_ratio);
power_jrgeco1aCorr_Delta_ratio_std = std(power_jrgeco1aCorr_Delta_ratio);

power_FADCorr_ISA_ratio_std = std(power_FADCorr_ISA_ratio);
power_FADCorr_Delta_ratio_std = std(power_FADCorr_Delta_ratio);

power_total_ISA_ratio_std = std(power_total_ISA_ratio);
power_total_Delta_ratio_std = std(power_total_Delta_ratio);

power_jrgeco1aCorr_ISA_ratio_mean = mean(power_jrgeco1aCorr_ISA_ratio);
power_jrgeco1aCorr_Delta_ratio_mean = mean(power_jrgeco1aCorr_Delta_ratio);

power_FADCorr_ISA_ratio_mean = mean(power_FADCorr_ISA_ratio);
power_FADCorr_Delta_ratio_mean = mean(power_FADCorr_Delta_ratio);

power_total_ISA_ratio_mean = mean(power_total_ISA_ratio);
power_total_Delta_ratio_mean = mean(power_total_Delta_ratio);




figure('position',[ 1182 340 260 250])
b_ISA = bar(1:3,[power_jrgeco1aCorr_ISA_ratio_mean, power_FADCorr_ISA_ratio_mean, power_total_ISA_ratio_mean],0.5,'LineWidth',2);
b_ISA.FaceColor = 'flat';
b_ISA.CData(1,:) = [1 0 1];
b_ISA.CData(2,:) = [0 1 0];
b_ISA.CData(3,:) = [0 0 0];
hold on
er = errorbar(1:3,[power_jrgeco1aCorr_ISA_ratio_mean, power_FADCorr_ISA_ratio_mean, power_total_ISA_ratio_mean],...
    zeros(size(1:3)),[power_jrgeco1aCorr_ISA_ratio_std, power_FADCorr_ISA_ratio_std, power_total_ISA_ratio_std],'LineWidth',2);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  


hold off
%xticklabels({'Corrected jRGECO1a','Corrected FAD','HbT'})
xlim([0.5,3.5])
ylim([0,0.9])
yticks([0 0.2 0.4 0.6 0.8])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14,'FontWeight','Bold')
%xlabel('Contrasts')
%ylabel('Awake/Anesthetized Power Ratio')
title('ISA')
set(gca,'LineWidth',2)




figure('position',[ 1182 340 260 300])
b_Delta = bar(1:3,[power_jrgeco1aCorr_Delta_ratio_mean, power_FADCorr_Delta_ratio_mean, power_total_Delta_ratio_mean],0.5,'LineWidth',2);
b_Delta.FaceColor = 'flat';
b_Delta.CData(1,:) = [1 0 1];
b_Delta.CData(2,:) = [0 1 0];
b_Delta.CData(3,:) = [0 0 0];
hold on
er = errorbar(1:3,[power_jrgeco1aCorr_Delta_ratio_mean, power_FADCorr_Delta_ratio_mean, power_total_Delta_ratio_mean],...
    zeros(size(1:3)),[power_jrgeco1aCorr_Delta_ratio_std, power_FADCorr_Delta_ratio_std, power_total_Delta_ratio_std],'LineWidth',2);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

hold off
%xticklabels({'Corrected jRGECO1a','Corrected FAD','HbT'})
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14,'FontWeight','Bold')
%xlabel('Contrasts')
%ylabel('Awake/Anesthetized Power Ratio')
xlim([0.5,3.5])
title('Delta')
ylim([0 70])
set(gca,'LineWidth',2)
hold on
xlimVal = get(gca,'xlim');
plot(xlimVal,[1 1],'r--','LineWidth',2)


yticks([5 10 20 35 40 50 60 70])
%breakyaxis([4.5 33])

 %breakyaxis([5 33])

breakyaxis([6 32])
set(gca,'yscale','log')

%yticks([1 5 25 30 35 40 45 47])
xlimVal = get(gca,'xlim');
hold on



 
 
%  power_jrgeco1aCorr_ISA_awake = nan(1,6);
% power_jrgeco1aCorr_Delta_awake = nan(1,6);
% power_total_ISA_awake = nan(1,6);
% power_total_Delta_awake = nan(1,6);
% power_FADCorr_ISA_awake = nan(1,6);
% power_FADCorr_Delta_awake = nan(1,6);
% 
% power_jrgeco1aCorr_ISA_anes = nan(1,6);     
% power_jrgeco1aCorr_Delta_anes = nan(1,6);
% power_FADCorr_ISA_anes = nan(1,6);
% power_FADCorr_Delta_anes = nan(1,6);
% power_total_ISA_anes = nan(1,6);
% power_total_Delta_anes = nan(1,6);

 
 [h_jrgeco1aCorr_ISA,p_jrgeco1aCorr_ISA] = ttest(power_jrgeco1aCorr_ISA_awake,power_jrgeco1aCorr_ISA_anes);
 [h_FADCorr_ISA,p_FADCorr_ISA] = ttest(power_FADCorr_ISA_awake,power_FADCorr_ISA_anes);
  [h_total_ISA,p_total_ISA] = ttest(power_total_ISA_awake,power_total_ISA_anes);

 [h_jrgeco1aCorr_Delta,p_jrgeco1aCorr_Delta] = ttest(power_jrgeco1aCorr_Delta_awake,power_jrgeco1aCorr_Delta_anes);
 [h_FADCorr_Delta,p_FADCorr_Delta] = ttest(power_FADCorr_Delta_awake,power_FADCorr_Delta_anes);
  [h_total_Delta,p_total_Delta] = ttest(power_total_Delta_awake,power_total_Delta_anes);
