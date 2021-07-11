import mouse.*

excelFile='V:\CTREM\CTREM.xlsx';
excelRows=[8:11,17:22,27:63];

% excelFile = "M:\Radiation Project\Radiation Project Highlight.xlsx";
% excelRows = 100;
% excelRows = [15 17 18 19 25 26 29 30 35 37 38 39 40 51 56 57 58 59 69 71 72 73 74 85];%[181,183,185,228,232,236];%321:327;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
mask_new = logical(mask_new);
% 
%
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
%     if ischar(excelRaw{10})
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

tLim = [0 2];
rLim = [-1 1];
excelRows=[2:11,17:22,27:63];
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
        if ischar(excelRaw{10})
       runs = str2num(excelRaw{10}); %1:excelRaw{13};
    else
        runs = excelRaw{10};
    end
    lagTimeTrial_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_HbTCalcium_mouse = zeros(128,128,length(runs));    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName_crossLag = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-crossLag','.mat');
        disp('loading lag data')
        load(fullfile(saveDir,processedName_crossLag))
        lagTimeTrial_HbTCalcium_mouse(:,:,n) =  lagTimeTrial_HbTCalcium;
        lagAmpTrial_HbTCalcium_mouse(:,:,n) = lagAmpTrial_HbTCalcium;      
    end
            
    lagTimeTrial_HbTCalcium_mouse_mean = nanmean(lagTimeTrial_HbTCalcium_mouse,3);
    lagAmpTrial_HbTCalcium_mouse_mean = nanmean(lagAmpTrial_HbTCalcium_mouse,3);
    
    figure;
    colormap jet;
    subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold') 
    subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_crossLag_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_crossLag_mean.fig')));
    
    close all
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');

end








excelRows =[15 17 18 19 35];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = 'PreRad WB';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'M:\Radiation Project\cat';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_PreRad(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_PreRad(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_PreRad = mean(lagTimeTrial_HbTCalcium_mice_mean_PreRad);
lagTime_std_PreRad = std(lagTimeTrial_HbTCalcium_mice_mean_PreRad);
lagAmp_mean_PreRad = mean(lagAmpTrial_HbTCalcium_mice_mean_PreRad);
lagAmp_std_PreRad = std(lagAmpTrial_HbTCalcium_mice_mean_PreRad);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_PreRad','lagTime_std_PreRad',...
    'lagAmp_mean_PreRad','lagAmp_std_PreRad')
    


excelRows =[25 26 29 30 51];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = '1wk WB';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'M:\Radiation Project\cat';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_1wk(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_1wk(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_1wk = mean(lagTimeTrial_HbTCalcium_mice_mean_1wk);
lagTime_std_1wk = std(lagTimeTrial_HbTCalcium_mice_mean_1wk);
lagAmp_mean_1wk = mean(lagAmpTrial_HbTCalcium_mice_mean_1wk);
lagAmp_std_1wk = std(lagAmpTrial_HbTCalcium_mice_mean_1wk);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_1wk','lagTime_std_1wk',...
    'lagAmp_mean_1wk','lagAmp_std_1wk')



excelRows =[37 38 39 40 69];
miceCat = '2wk WB';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'M:\Radiation Project\cat';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_2wk(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_2wk(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_2wk = mean(lagTimeTrial_HbTCalcium_mice_mean_2wk);
lagTime_std_2wk = std(lagTimeTrial_HbTCalcium_mice_mean_2wk);
lagAmp_mean_2wk = mean(lagAmpTrial_HbTCalcium_mice_mean_2wk);
lagAmp_std_2wk = std(lagAmpTrial_HbTCalcium_mice_mean_2wk);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_2wk','lagTime_std_2wk',...
    'lagAmp_mean_2wk','lagAmp_std_2wk')



excelRows =[56 57 58 59 85];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = '3wk WB';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'M:\Radiation Project\cat';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_3wk(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_3wk(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_3wk = mean(lagTimeTrial_HbTCalcium_mice_mean_3wk);
lagTime_std_3wk = std(lagTimeTrial_HbTCalcium_mice_mean_3wk);
lagAmp_mean_3wk = mean(lagAmpTrial_HbTCalcium_mice_mean_3wk);
lagAmp_std_3wk = std(lagAmpTrial_HbTCalcium_mice_mean_3wk);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_3wk','lagTime_std_3wk',...
    'lagAmp_mean_3wk','lagAmp_std_3wk')




excelRows =[71 72 73 74 100];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = '4wk WB';

lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));

tLim = [0 1];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'M:\Radiation Project\cat';
mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(saveDir,mask_newName), 'xform_isbrain')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-crossLag.mat')),...
      'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean');
    
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
     lagTimeTrial_HbTCalcium_mice_mean_4wk(mouseInd) = nanmean(lagTimeTrial_HbTCalcium_mouse_mean(mask_new));
    lagAmpTrial_HbTCalcium_mice_mean_4wk(mouseInd) = nanmean(lagAmpTrial_HbTCalcium_mouse_mean(mask_new)); 
    mouseInd = mouseInd+1;
end

lagTimeTrial_HbTCalcium_mice = nanmean(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmean(lagAmpTrial_HbTCalcium_mice,3);
lagTime_mean_4wk = mean(lagTimeTrial_HbTCalcium_mice_mean_4wk);
lagTime_std_4wk = std(lagTimeTrial_HbTCalcium_mice_mean_4wk);
lagAmp_mean_4wk = mean(lagAmpTrial_HbTCalcium_mice_mean_4wk);
lagAmp_std_4wk = std(lagAmpTrial_HbTCalcium_mice_mean_4wk);

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_crossLag_mean.fig')));

save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-crossLag.mat')),...
    'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice',...
    'lagTime_mean_4wk','lagTime_std_4wk',...
    'lagAmp_mean_4wk','lagAmp_std_4wk')






b = bar(1:5,[lagTime_mean_PreRad,lagTime_mean_1wk,lagTime_mean_2wk,lagTime_mean_3wk,lagTime_mean_4wk],0.5);
hold on
er = errorbar(1:5,[lagTime_mean_PreRad,lagTime_mean_1wk,lagTime_mean_2wk,lagTime_mean_3wk,lagTime_mean_4wk],zeros(1,5),[lagTime_std_PreRad,lagTime_std_1wk,lagTime_std_2wk,lagTime_std_3wk,lagTime_std_4wk]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'PreRad','1 wk','2 wk','3 wk', '4 wk'})
ylabel('Lag Time(s)')
title('Radiation Project')

[h_1wk,p_1wk] = ttest(lagTimeTrial_HbTCalcium_mice_mean_1wk,lagTimeTrial_HbTCalcium_mice_mean_PreRad);
[h_2wk,p_2wk] = ttest(lagTimeTrial_HbTCalcium_mice_mean_2wk,lagTimeTrial_HbTCalcium_mice_mean_PreRad);
[h_3wk,p_3wk] = ttest(lagTimeTrial_HbTCalcium_mice_mean_3wk,lagTimeTrial_HbTCalcium_mice_mean_PreRad);
[h_4wk,p_4wk] = ttest(lagTimeTrial_HbTCalcium_mice_mean_4wk,lagTimeTrial_HbTCalcium_mice_mean_PreRad);

sigstar({[1,2]},p_1wk,0,1)
sigstar({[1,3]},p_2wk,0,1)
sigstar({[1,4]},p_3wk,0,1)
sigstar({[1,5]},p_4wk,0,1)

