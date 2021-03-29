saveDir_cat = 'L:\RGECO\cat';
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
% 
% load(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
%     'lagTimeTrial_HbTCalcium_mice_mean', 'lagAmpTrial_HbTCalcium_mice_mean','lagTimeTrial_FADCalcium_mice_mean', 'lagAmpTrial_FADCalcium_mice_mean','lagTimeTrial_HbTFAD_mice_mean', 'lagAmpTrial_HbTFAD_mice_mean',...
%     'lagTimeTrial_HbTCalcium_mice_median', 'lagAmpTrial_HbTCalcium_mice_median','lagTimeTrial_FADCalcium_mice_median', 'lagAmpTrial_FADCalcium_mice_median', 'lagTimeTrial_HbTFAD_mice_median', 'lagAmpTrial_HbTFAD_mice_median');
% 
% figure('units','normalized','outerposition',[0 0 1 1]);
% colormap jet;
% sumImag = lagTimeTrial_HbTFAD_mice_median + lagTimeTrial_FADCalcium_mice_median;
% subplot(1,5,1); imagesc(lagTimeTrial_HbTFAD_mice_median,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,5,2); imagesc(lagTimeTrial_FADCalcium_mice_median,[0 0.2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,5,3); imagesc(lagTimeTrial_HbTCalcium_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,5,4); imagesc(sumImag,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('sum');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,5,5); imagesc(lagTimeTrial_HbTCalcium_mice_median-sumImag,[0 0.3]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium - sum');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% 
% suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median',' 0.02-2Hz'))
% saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.png')));
% saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.fig')));


 load('D:\OIS_Process\noVasculaturemask.mat')

load(fullfile(saveDir_cat,'191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat'),...
    'lagTimeTrial_HbTCalcium_mice_mean', 'lagAmpTrial_HbTCalcium_mice_mean','lagTimeTrial_FADCalcium_mice_mean', 'lagAmpTrial_FADCalcium_mice_mean','lagTimeTrial_HbTFAD_mice_mean', 'lagAmpTrial_HbTFAD_mice_mean',...
    'lagTimeTrial_HbTCalcium_mice_median', 'lagAmpTrial_HbTCalcium_mice_median','lagTimeTrial_FADCalcium_mice_median', 'lagAmpTrial_FADCalcium_mice_median', 'lagTimeTrial_HbTFAD_mice_median', 'lagAmpTrial_HbTFAD_mice_median');

figure('units','normalized','outerposition',[0 0 1 1]);
colormap jet;
 title('191030-Anes RGECO fc median 0.02-2')
sumImag = lagTimeTrial_HbTFAD_mice_median + lagTimeTrial_FADCalcium_mice_median;
subplot(1,5,1); imagesc(lagTimeTrial_HbTFAD_mice_median,[0 1.2]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,5,2); imagesc(lagTimeTrial_FADCalcium_mice_median,[0 0.11]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,5,3); imagesc(lagTimeTrial_HbTCalcium_mice_median,[0 1.2]); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,5,4); imagesc(sumImag,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('sum');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,5,5); imagesc(lagTimeTrial_HbTCalcium_mice_median-sumImag,[0 0.3]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium - sum');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median',' 0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.fig')));



  