import mouse.*
% excelFile='V:\CTREM\CTREM.xlsx';
% excelRows=[8:11,17:22,27:63];
% 
% % excelFile = "M:\Radiation Project\Radiation Project Highlight.xlsx";
% % excelRows = 100;
% % excelRows = [15 17 18 19 25 26 29 30 35 37 38 39 40 51 56 57 58 59 69 71 72 73 74 85];%[181,183,185,228,232,236];%321:327;
% load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
% load('D:\OIS_Process\noVasculaturemask.mat')
% mask_new = logical(mask_new);
% % 
% %
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
%     load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
%         if ischar(excelRaw{10})
%        runs = str2num(excelRaw{10}); %1:excelRaw{13};
%     else
%         runs = excelRaw{10};
%     end
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName_dataHb = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataHb','.mat');
%         processedName_dataFluor = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataFluor','.mat');
%         processedName_crossLag = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-crossLag','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName_dataHb),'xform_datahb')
%         load(fullfile(saveDir,processedName_dataFluor),'xform_datafluorCorr')
%         
%         xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
%         xform_total(isinf(xform_total)) = 0;
%         xform_total(isnan(xform_total)) = 0;
%         
%         xform_datafluorCorr(isinf(xform_datafluorCorr)) = 0;
%         xform_datafluorCorr(isnan(xform_datafluorCorr)) = 0;
%         
% 
%         %%comparing our NVC measures to Hillman (0.02-2)
%         disp('filtering')
%         %
%         xform_total_filtered = mouse.freq.filterData(double(xform_total),0.02,2,fs);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
%         xform_datafluorCorr_filtered = mouse.freq.filterData(double(xform_datafluorCorr),0.02,2,fs);
%         edgeLen =1;
%         tZone = 4;
%         corrThr = 0;
%         validRange = - edgeLen: round(tZone*fs);
%         tLim = [0 2];
%         rLim = [-1 1];
%         disp(strcat('Lag analysis on ', recDate, ' ', mouseName, ' run#', num2str(n)))
%         % %
%         [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
%             xform_total_filtered,xform_datafluorCorr_filtered,edgeLen,validRange,corrThr, true,true);
%         lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
%         
%         
%         clear xform_total_filtered xform_FADCorr_filtered xform_jrgeco1aCorr_filtered
%         figure;
%         colormap jet;
%         subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%         subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%         suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_crossLag.png')));
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_crossLag.fig')));
%         save(fullfile(saveDir,processedName_crossLag),'lagTimeTrial_HbTCalcium', 'lagAmpTrial_HbTCalcium');
%         close all
%         
%     end
% end
% 
% tLim = [0 2];
% rLim = [-1 1];
% excelRows=[2:11,17:22,27:63];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{7};
%     mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     load(fullfile(saveDir,mask_newName), 'xform_isbrain')
%     runs = 1:excelRaw{13};
%     lagTimeTrial_HbTCalcium_mouse = zeros(128,128,length(runs));
%     lagAmpTrial_HbTCalcium_mouse = zeros(128,128,length(runs));    
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName_crossLag = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-crossLag','.mat');
%         disp('loading lag data')
%         load(fullfile(saveDir,processedName_crossLag))
%         lagTimeTrial_HbTCalcium_mouse(:,:,n) =  lagTimeTrial_HbTCalcium;
%         lagAmpTrial_HbTCalcium_mouse(:,:,n) = lagAmpTrial_HbTCalcium;      
%     end
%             
%     lagTimeTrial_HbTCalcium_mouse_mean = nanmean(lagTimeTrial_HbTCalcium_mouse,3);
%     lagAmpTrial_HbTCalcium_mouse_mean = nanmean(lagAmpTrial_HbTCalcium_mouse,3);
%     
%     figure;
%     colormap jet;
%     subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold') 
%     subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
%     suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean'))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_crossLag_mean.png')));
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_crossLag_mean.fig')));
%     
%     close all
%     save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
%         'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
% 
% end


excelFile = 'V:\CTREM\WT.xlsx';
excelRows = 2:15;
miceCat = 'TremWT';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = 'TremWT';
saveDir_cat = 'V:\CTREM\Group level averages';
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
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_WT(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WT(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_WT = mean(lagTimeTrial_HbTCalcium_mice_mean_WT);
lagTime_std_WT = std(lagTimeTrial_HbTCalcium_mice_mean_WT);
lagAmp_mean_WT = mean(lagAmpTrial_HbTCalcium_mice_mean_WT);
lagAmp_std_WT = std(lagAmpTrial_HbTCalcium_mice_mean_WT);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_WT','lagTime_std_WT',...
    'lagAmp_mean_WT','lagAmp_std_WT')
    


excelFile = 'V:\CTREM\HET.xlsx';
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
     lagTimeTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_Het(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
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
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_Het','lagTime_std_Het',...
    'lagAmp_mean_Het','lagAmp_std_Het')



excelFile = 'V:\CTREM\KO.xlsx';
excelRows = 2:8;
miceCat = 'TremKO';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
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
     lagTimeTrial_HbTCalcium_mice_mean_KO(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KO(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
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
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_KO','lagTime_std_KO',...
    'lagAmp_mean_KO','lagAmp_std_KO')



excelFile = 'V:\CTREM\WTFAD.xlsx';
excelRows = 2:14;
miceCat = 'TremWTFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
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
     lagTimeTrial_HbTCalcium_mice_mean_WTFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_WTFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
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
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_WTFAD','lagTime_std_WTFAD',...
    'lagAmp_mean_WTFAD','lagAmp_std_WTFAD')




excelFile = 'V:\CTREM\HETFAD.xlsx';
excelRows = 2:7;
miceCat = 'TremHetFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
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
     lagTimeTrial_HbTCalcium_mice_mean_HetFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_HetFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
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
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_HetFAD','lagTime_std_HetFAD',...
    'lagAmp_mean_HetFAD','lagAmp_std_HetFAD')


excelFile = 'V:\CTREM\KOFAD.xlsx';
excelRows = 2:7;
miceCat = 'TremKOFAD';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
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
     lagTimeTrial_HbTCalcium_mice_mean_KOFAD(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_KOFAD(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
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
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

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
er = errorbar(1:6,[lagTime_mean_WT,lagTime_mean_Het,lagTime_mean_KO,lagTime_mean_WTFAD,lagTime_mean_HetFAD,lagTime_mean_KOFAD],zeros(1,6),[lagTime_std_WT,lagTime_std_Het,lagTime_std_KO,lagTime_std_WTFAD,lagTime_std_HetFAD,lagTime_std_KOFAD]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'Trem WT','Trem Het','Trem KO','TremWT FAD', 'TremHet FAD', 'TremKO FAD'})
ylabel('Lag Time(s)')
title('Colonna Project')

[h_WT_WTFAD,p_WT_WTFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_WTFAD,0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WTFAD,lagTimeTrial_HbTCalcium_mice_mean_KOFAD,0.05, 'both', 'unequal');
[h_WT_KO,p_WT_KO] = ttest2(lagTimeTrial_HbTCalcium_mice_mean_WT,lagTimeTrial_HbTCalcium_mice_mean_KO,0.05, 'both', 'unequal');

sigstar({[1,4]},p_WT_WTFAD,0,1)
sigstar({[4,6]},p_WTFAD_KOFAD,0,1)
sigstar({[1,3]},p_WT_KO,0,1)
