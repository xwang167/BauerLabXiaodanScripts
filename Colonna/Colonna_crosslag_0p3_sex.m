import mouse.*
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
excelFile = 'Y:\CTREM\WT.xlsx';
excelRows = 2:15;
miceCat = 'TremWT';

load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
tLim = [0 2];
rLim = [-1 1];
% 
miceName = 'TremWT';
saveDir_cat = 'Y:\CTREM\Group level averages';
a=1;
b=1;
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
    sex = excelRaw{3};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    if strcmp(sex,'Female')
    lagTimeTrial_HbTCalcium_mice_female(:,:,a) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_female(:,:,a) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_WT_female(a) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WT_female(a) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    a = a+1;
    else
    lagTimeTrial_HbTCalcium_mice_male(:,:,b) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_male(:,:,b) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_WT_male(b) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WT_male(b) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    b = b+1;
    end
end

lagTimeTrial_HbTCalcium_mice_female = nanmean(lagTimeTrial_HbTCalcium_mice_female,3);
lagAmpTrial_HbTCalcium_mice_female = nanmean(lagAmpTrial_HbTCalcium_mice_female,3);
lagTime_mean_WT_female = nanmean(lagTimeTrial_HbTCalcium_mice_mean_WT_female);
lagTime_std_WT_female = nanstd(lagTimeTrial_HbTCalcium_mice_mean_WT_female);
lagAmp_mean_WT_female = nanmean(lagAmpTrial_HbTCalcium_mice_mean_WT_female);
lagAmp_std_WT_female = nanstd(lagAmpTrial_HbTCalcium_mice_mean_WT_female);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_female,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Female Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_female,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_female.mat')),...
    'lagTimeTrial_HbTCalcium_mice_female', 'lagAmpTrial_HbTCalcium_mice_female',...
    'lagTime_mean_WT_female','lagTime_std_WT_female',...
    'lagAmp_mean_WT_female','lagAmp_std_WT_female')

lagTimeTrial_HbTCalcium_mice_male = nanmean(lagTimeTrial_HbTCalcium_mice_male,3);
lagAmpTrial_HbTCalcium_mice_male = nanmean(lagAmpTrial_HbTCalcium_mice_male,3);
lagTime_mean_WT_male = nanmean(lagTimeTrial_HbTCalcium_mice_mean_WT_male);
lagTime_std_WT_male = nanstd(lagTimeTrial_HbTCalcium_mice_mean_WT_male);
lagAmp_mean_WT_male = nanmean(lagAmpTrial_HbTCalcium_mice_mean_WT_male);
lagAmp_std_WT_male = nanstd(lagAmpTrial_HbTCalcium_mice_mean_WT_male);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_male,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('male Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_male,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_male.mat')),...
    'lagTimeTrial_HbTCalcium_mice_male', 'lagAmpTrial_HbTCalcium_mice_male',...
    'lagTime_mean_WT_male','lagTime_std_WT_male',...
    'lagAmp_mean_WT_male','lagAmp_std_WT_male')



% excelFile = 'Y:\CTREM\HET.xlsx';
% excelRows = 2:7;
% miceCat = 'TremHet';
% 
% lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
% lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
% 
% tLim = [0 2];
% rLim = [-1 1];
% 
% miceName = 'TremHet';
% mouseInd =1;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{9}; mouseName = string(mouseName);%2
%     saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
%     sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
%     sessionInfo.darkFrameNum = excelRaw{16};%15
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{13};%5;
%     mask_newDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{15};%7
%     mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     load(fullfile(saveDir,mask_newName), 'xform_isbrain')
%     load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
%       'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
%     
%     lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
%     lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
%     mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
%      lagTimeTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
%     lagAmpTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
%     mouseInd = mouseInd+1;
% end
% 
% lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
% lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
% lagTime_mean_Het = nanmean(lagTimeTrial_HbTCalcium_mice_mean_Het);
% lagTime_std_Het = nanstd(lagTimeTrial_HbTCalcium_mice_mean_Het);
% lagAmp_mean_Het = nanmean(lagAmpTrial_HbTCalcium_mice_mean_Het);
% lagAmp_std_Het = nanstd(lagAmpTrial_HbTCalcium_mice_mean_Het);
% 
% figure;
% colormap jet;
% subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
% 
% suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
% saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
% saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));
% 
% save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
%     'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
%     'lagTime_mean_Het','lagTime_std_Het',...
%     'lagAmp_mean_Het','lagAmp_std_Het')



excelFile = 'Y:\CTREM\KO.xlsx';
excelRows = 2:9;
miceCat = 'TremKO';

load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
tLim = [0 2];
rLim = [-1 1];
% 
miceName = 'TremKO';
saveDir_cat = 'Y:\CTREM\Group level averages';
a=1;
b=1;
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
    sex = excelRaw{3};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    if strcmp(sex,'Female')
    lagTimeTrial_HbTCalcium_mice_female(:,:,a) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_female(:,:,a) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_KO_female(a) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KO_female(a) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    a = a+1;
    else
    lagTimeTrial_HbTCalcium_mice_male(:,:,b) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_male(:,:,b) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_KO_male(b) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KO_male(b) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    b = b+1;
    end
end

lagTimeTrial_HbTCalcium_mice_female = nanmean(lagTimeTrial_HbTCalcium_mice_female,3);
lagAmpTrial_HbTCalcium_mice_female = nanmean(lagAmpTrial_HbTCalcium_mice_female,3);
lagTime_mean_KO_female = nanmean(lagTimeTrial_HbTCalcium_mice_mean_KO_female);
lagTime_std_KO_female = nanstd(lagTimeTrial_HbTCalcium_mice_mean_KO_female);
lagAmp_mean_KO_female = nanmean(lagAmpTrial_HbTCalcium_mice_mean_KO_female);
lagAmp_std_KO_female = nanstd(lagAmpTrial_HbTCalcium_mice_mean_KO_female);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_female,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Female Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_female,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_female.mat')),...
    'lagTimeTrial_HbTCalcium_mice_female', 'lagAmpTrial_HbTCalcium_mice_female',...
    'lagTime_mean_KO_female','lagTime_std_KO_female',...
    'lagAmp_mean_KO_female','lagAmp_std_KO_female')
lagTimeTrial_HbTCalcium_mice_male = nanmean(lagTimeTrial_HbTCalcium_mice_male,3);
lagAmpTrial_HbTCalcium_mice_male = nanmean(lagAmpTrial_HbTCalcium_mice_male,3);
lagTime_mean_KO_male = nanmean(lagTimeTrial_HbTCalcium_mice_mean_KO_male);
lagTime_std_KO_male = nanstd(lagTimeTrial_HbTCalcium_mice_mean_KO_male);
lagAmp_mean_KO_male = nanmean(lagAmpTrial_HbTCalcium_mice_mean_KO_male);
lagAmp_std_KO_male = nanstd(lagAmpTrial_HbTCalcium_mice_mean_KO_male);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_male,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('male Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_male,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_male.mat')),...
    'lagTimeTrial_HbTCalcium_mice_male', 'lagAmpTrial_HbTCalcium_mice_male',...
    'lagTime_mean_KO_male','lagTime_std_KO_male',...
    'lagAmp_mean_KO_male','lagAmp_std_KO_male')


excelFile = 'Y:\CTREM\WTFAD.xlsx';
excelRows = 2:14;
miceCat = 'TremWTFAD';

load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
tLim = [0 2];
rLim = [-1 1];
% 
miceName = 'TremWTFAD';
saveDir_cat = 'Y:\CTREM\Group level averages';
a=1;
b=1;
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
    sex = excelRaw{3};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    if strcmp(sex,'Female')
    lagTimeTrial_HbTCalcium_mice_female(:,:,a) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_female(:,:,a) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_WTFAD_female(a) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WTFAD_female(a) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    a = a+1;
    else
    lagTimeTrial_HbTCalcium_mice_male(:,:,b) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_male(:,:,b) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_WTFAD_male(b) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WTFAD_male(b) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    b = b+1;
    end
end

lagTimeTrial_HbTCalcium_mice_female = nanmean(lagTimeTrial_HbTCalcium_mice_female,3);
lagAmpTrial_HbTCalcium_mice_female = nanmean(lagAmpTrial_HbTCalcium_mice_female,3);
lagTime_mean_WTFAD_female = nanmean(lagTimeTrial_HbTCalcium_mice_mean_WTFAD_female);
lagTime_std_WTFAD_female = nanstd(lagTimeTrial_HbTCalcium_mice_mean_WTFAD_female);
lagAmp_mean_WTFAD_female = nanmean(lagAmpTrial_HbTCalcium_mice_mean_WTFAD_female);
lagAmp_std_WTFAD_female = nanstd(lagAmpTrial_HbTCalcium_mice_mean_WTFAD_female);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_female,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Female Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_female,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_female.mat')),...
    'lagTimeTrial_HbTCalcium_mice_female', 'lagAmpTrial_HbTCalcium_mice_female',...
    'lagTime_mean_WTFAD_female','lagTime_std_WTFAD_female',...
    'lagAmp_mean_WTFAD_female','lagAmp_std_WTFAD_female')
lagTimeTrial_HbTCalcium_mice_male = nanmean(lagTimeTrial_HbTCalcium_mice_male,3);
lagAmpTrial_HbTCalcium_mice_male = nanmean(lagAmpTrial_HbTCalcium_mice_male,3);
lagTime_mean_WTFAD_male = nanmean(lagTimeTrial_HbTCalcium_mice_mean_WTFAD_male);
lagTime_std_WTFAD_male = nanstd(lagTimeTrial_HbTCalcium_mice_mean_WTFAD_male);
lagAmp_mean_WTFAD_male = nanmean(lagAmpTrial_HbTCalcium_mice_mean_WTFAD_male);
lagAmp_std_WTFAD_male = nanstd(lagAmpTrial_HbTCalcium_mice_mean_WTFAD_male);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_male,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('male Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_male,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_male.mat')),...
    'lagTimeTrial_HbTCalcium_mice_male', 'lagAmpTrial_HbTCalcium_mice_male',...
    'lagTime_mean_WTFAD_male','lagTime_std_WTFAD_male',...
    'lagAmp_mean_WTFAD_male','lagAmp_std_WTFAD_male')



excelFile = 'Y:\CTREM\HetFAD.xlsx';
excelRows = 2:7;
miceCat = 'TremHetFAD';

load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
tLim = [0 2];
rLim = [-1 1];
% 
miceName = 'TremHetFAD';
saveDir_cat = 'Y:\CTREM\Group level averages';
a=1;
b=1;
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
    sex = excelRaw{3};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    if strcmp(sex,'Female')
    lagTimeTrial_HbTCalcium_mice_female(:,:,a) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_female(:,:,a) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_HetFAD_female(a) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_HetFAD_female(a) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    a = a+1;
    else
    lagTimeTrial_HbTCalcium_mice_male(:,:,b) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_male(:,:,b) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_HetFAD_male(b) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_HetFAD_male(b) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    b = b+1;
    end
end

lagTimeTrial_HbTCalcium_mice_female = nanmean(lagTimeTrial_HbTCalcium_mice_female,3);
lagAmpTrial_HbTCalcium_mice_female = nanmean(lagAmpTrial_HbTCalcium_mice_female,3);
lagTime_mean_HetFAD_female = nanmean(lagTimeTrial_HbTCalcium_mice_mean_HetFAD_female);
lagTime_std_HetFAD_female = nanstd(lagTimeTrial_HbTCalcium_mice_mean_HetFAD_female);
lagAmp_mean_HetFAD_female = nanmean(lagAmpTrial_HbTCalcium_mice_mean_HetFAD_female);
lagAmp_std_HetFAD_female = nanstd(lagAmpTrial_HbTCalcium_mice_mean_HetFAD_female);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_female,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Female Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_female,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_female.mat')),...
    'lagTimeTrial_HbTCalcium_mice_female', 'lagAmpTrial_HbTCalcium_mice_female',...
    'lagTime_mean_HetFAD_female','lagTime_std_HetFAD_female',...
    'lagAmp_mean_HetFAD_female','lagAmp_std_HetFAD_female')
lagTimeTrial_HbTCalcium_mice_male = nanmean(lagTimeTrial_HbTCalcium_mice_male,3);
lagAmpTrial_HbTCalcium_mice_male = nanmean(lagAmpTrial_HbTCalcium_mice_male,3);
lagTime_mean_HetFAD_male = nanmean(lagTimeTrial_HbTCalcium_mice_mean_HetFAD_male);
lagTime_std_HetFAD_male = nanstd(lagTimeTrial_HbTCalcium_mice_mean_HetFAD_male);
lagAmp_mean_HetFAD_male = nanmean(lagAmpTrial_HbTCalcium_mice_mean_HetFAD_male);
lagAmp_std_HetFAD_male = nanstd(lagAmpTrial_HbTCalcium_mice_mean_HetFAD_male);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_male,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('male Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_male,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_male.mat')),...
    'lagTimeTrial_HbTCalcium_mice_male', 'lagAmpTrial_HbTCalcium_mice_male',...
    'lagTime_mean_HetFAD_male','lagTime_std_HetFAD_male',...
    'lagAmp_mean_HetFAD_male','lagAmp_std_HetFAD_male')

excelFile = 'Y:\CTREM\KOFAD.xlsx';
excelRows = 2:10;
miceCat = 'TremKOFAD';

load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
tLim = [0 2];
rLim = [-1 1];
% 
miceName = 'TremKOFAD';
saveDir_cat = 'Y:\CTREM\Group level averages';
a=1;
b=1;
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
    sex = excelRaw{3};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    if strcmp(sex,'Female')
    lagTimeTrial_HbTCalcium_mice_female(:,:,a) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_female(:,:,a) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_KOFAD_female(a) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KOFAD_female(a) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    a = a+1;
    else
    lagTimeTrial_HbTCalcium_mice_male(:,:,b) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_male(:,:,b) = lagAmpTrial_HbTCalcium_mouse_mean;
    mask_new = logical((lagAmpTrial_HbTCalcium_mouse_mean>0.3).*mask);
    lagTimeTrial_HbTCalcium_mice_mean_KOFAD_male(b) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KOFAD_male(b) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    b = b+1;
    end
end

lagTimeTrial_HbTCalcium_mice_female = nanmean(lagTimeTrial_HbTCalcium_mice_female,3);
lagAmpTrial_HbTCalcium_mice_female = nanmean(lagAmpTrial_HbTCalcium_mice_female,3);
lagTime_mean_KOFAD_female = nanmean(lagTimeTrial_HbTCalcium_mice_mean_KOFAD_female);
lagTime_std_KOFAD_female = nanstd(lagTimeTrial_HbTCalcium_mice_mean_KOFAD_female);
lagAmp_mean_KOFAD_female = nanmean(lagAmpTrial_HbTCalcium_mice_mean_KOFAD_female);
lagAmp_std_KOFAD_female = nanstd(lagAmpTrial_HbTCalcium_mice_mean_KOFAD_female);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_female,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Female Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_female,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_female.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_female.mat')),...
    'lagTimeTrial_HbTCalcium_mice_female', 'lagAmpTrial_HbTCalcium_mice_female',...
    'lagTime_mean_KOFAD_female','lagTime_std_KOFAD_female',...
    'lagAmp_mean_KOFAD_female','lagAmp_std_KOFAD_female')
lagTimeTrial_HbTCalcium_mice_male = nanmean(lagTimeTrial_HbTCalcium_mice_male,3);
lagAmpTrial_HbTCalcium_mice_male = nanmean(lagAmpTrial_HbTCalcium_mice_male,3);
lagTime_mean_KOFAD_male = nanmean(lagTimeTrial_HbTCalcium_mice_mean_KOFAD_male);
lagTime_std_KOFAD_male = nanstd(lagTimeTrial_HbTCalcium_mice_mean_KOFAD_male);
lagAmp_mean_KOFAD_male = nanmean(lagAmpTrial_HbTCalcium_mice_mean_KOFAD_male);
lagAmp_std_KOFAD_male = nanstd(lagAmpTrial_HbTCalcium_mice_mean_KOFAD_male);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice_male,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('male Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice_male,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean_male.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag_male.mat')),...
    'lagTimeTrial_HbTCalcium_mice_male', 'lagAmpTrial_HbTCalcium_mice_male',...
    'lagTime_mean_KOFAD_male','lagTime_std_KOFAD_male',...
    'lagAmp_mean_KOFAD_male','lagAmp_std_KOFAD_male')





figure
model_series = [lagTime_mean_WT_female,lagTime_mean_WT_male;
    lagTime_mean_KO_female,lagTime_mean_KO_male;lagTime_mean_WTFAD_female,lagTime_mean_WTFAD_male;...
    lagTime_mean_HetFAD_female,lagTime_mean_HetFAD_male;lagTime_mean_KOFAD_female,lagTime_mean_KOFAD_male];
model_error = [lagTime_std_WT_female,lagTime_std_WT_male;
    lagTime_std_KO_female,lagTime_std_KO_male;lagTime_std_WTFAD_female,lagTime_std_WTFAD_male;...
    lagTime_std_HetFAD_female,lagTime_std_HetFAD_male;lagTime_std_KOFAD_female,lagTime_std_KOFAD_male];
b = bar(model_series, 'grouped');
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
xticklabels({'Trem WT','Trem KO','TremWT FAD', 'TremHet FAD', 'TremKO FAD'})
ylabel('Lag Time(s)')
title('Colonna Project')

[h_WT,p_WT] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT_female,lagTimeTrial_HbTCalcium_mice_mean_WT_male,0.05, 'both', 'unequal');
[h_KO,p_KO] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_KO_female,lagTimeTrial_HbTCalcium_mice_mean_KO_male,0.05, 'both', 'unequal');
[h_WTFAD,p_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WTFAD_female,lagTimeTrial_HbTCalcium_mice_mean_WTFAD_male,0.05, 'both', 'unequal');
[h_HetFAD,p_HetFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_HetFAD_female,lagTimeTrial_HbTCalcium_mice_mean_HetFAD_male,0.05, 'both', 'unequal');
[h_KOFAD,p_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_KOFAD_female,lagTimeTrial_HbTCalcium_mice_mean_KOFAD_male,0.05, 'both', 'unequal');

% 
% sigstar({[1,2]},p_WT,0,1)
% sigstar({[4,6]},p_WTFAD_KOFAD,0,1)
% sigstar({[1,3]},p_WT_KO,0,1)
