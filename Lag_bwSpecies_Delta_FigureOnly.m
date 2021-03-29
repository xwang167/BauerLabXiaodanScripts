




import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


%
%
excelRows = [195 202 204 230 234 240];%[181,183,185,228,232,236];%321:327;

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'lagTimeTrial_Delta_HbTCalcium', 'lagAmpTrial_Delta_HbTCalcium',...
            'lagTimeTrial_Delta_FADCalcium', 'lagAmpTrial_Delta_FADCalcium','lagTimeTrial_Delta_HbTFAD', 'lagAmpTrial_Delta_HbTFAD');
 
                edgeLen =1;
                tZone = 4;
                corrThr = 0;
                validRange = - edgeLen: round(tZone*fs);
                tLim = [0 1.3];
                tLim_FAD = [0 0.1];
                rLim = [-1 1];
                figure;
                colormap jet;
                subplot(2,3,1); imagesc(lagTimeTrial_Delta_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                subplot(2,3,2); imagesc(lagTimeTrial_Delta_FADCalcium,tLim_FAD);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                subplot(2,3,3); imagesc(lagTimeTrial_Delta_HbTFAD,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                
                subplot(2,3,4); imagesc(lagAmpTrial_Delta_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                subplot(2,3,5); imagesc(lagAmpTrial_Delta_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                subplot(2,3,6); imagesc(lagAmpTrial_Delta_HbTFAD,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' Delta'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_Delta.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_Delta.fig')));
                close all
            
    end
end



excelRows = [195 202 204 230 234 240];%[195 202 204 181 183 185];[181,183,185,228,232,236];%
miceCat = 'Anes RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')




lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["ISA","Delta"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium","HbTFAD"];

tLim = [0 1.3];
rLim = [-1 1];



miceName = [];
saveDir_cat = 'L:\RGECO\cat';
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
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    mask_newName_new = strcat(recDate,'-',mouseName,'-Landmarksandmask_new','.mat');
    fs = excelRaw{7};
    %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_Delta_HbTCalcium_mouse_mean', 'lagAmpTrial_Delta_HbTCalcium_mouse_mean',...
        'lagTimeTrial_Delta_FADCalcium_mouse_mean', 'lagAmpTrial_Delta_FADCalcium_mouse_mean',...
        'lagTimeTrial_Delta_HbTFAD_mouse_mean', 'lagAmpTrial_Delta_HbTFAD_mouse_mean',...
        'lagTimeTrial_Delta_HbTCalcium_mouse_median', 'lagAmpTrial_Delta_HbTCalcium_mouse_median',...
        'lagTimeTrial_Delta_FADCalcium_mouse_median', 'lagAmpTrial_Delta_FADCalcium_mouse_median',...
        'lagTimeTrial_Delta_HbTFAD_mouse_median', 'lagAmpTrial_Delta_HbTFAD_mouse_median');
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_Delta_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_Delta_FADCalcium_mouse_mean,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_Delta_HbTFAD_mouse_mean,[0 0.1]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_Delta_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_Delta_FADCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_Delta_HbTFAD_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean',' Delta'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_Delta_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_Delta_mean.fig')));
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_Delta_HbTCalcium_mouse_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_Delta_FADCalcium_mouse_median,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_Delta_HbTFAD_mouse_median,[0 0.1]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_Delta_HbTCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_Delta_FADCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_Delta_HbTFAD_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median',' Delta'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_Delta_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_Delta_median.fig')));

end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');


load(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_Delta_HbTCalcium_mice_mean', 'lagAmpTrial_Delta_HbTCalcium_mice_mean','lagTimeTrial_Delta_FADCalcium_mice_mean', 'lagAmpTrial_Delta_FADCalcium_mice_mean','lagTimeTrial_Delta_HbTFAD_mice_mean', 'lagAmpTrial_Delta_HbTFAD_mice_mean',...
    'lagTimeTrial_Delta_HbTCalcium_mice_median', 'lagAmpTrial_Delta_HbTCalcium_mice_median','lagTimeTrial_Delta_FADCalcium_mice_median', 'lagAmpTrial_Delta_FADCalcium_mice_median', 'lagTimeTrial_Delta_HbTFAD_mice_median', 'lagAmpTrial_Delta_HbTFAD_mice_median');

figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_Delta_HbTCalcium_mice_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_Delta_FADCalcium_mice_mean,[0 0.05]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_Delta_HbTFAD_mice_mean,[0 0.06]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_Delta_HbTCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_Delta_FADCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_Delta_HbTFAD_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean',' Delta'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_Delta_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_Delta_mean.fig')));

figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_Delta_HbTCalcium_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_Delta_FADCalcium_mice_median,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_Delta_HbTFAD_mice_median,[0 0.1]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_Delta_HbTCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_Delta_FADCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_Delta_HbTFAD_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median', ' Delta'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_Delta_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_Delta_median.fig')));

lagTime_HbTCalcium_Delta = nanmean(lagTimeTrial_Delta_HbTCalcium_mice_median(logical(mask_new)));
lagTime_HbTFAD_Delta = nanmean(lagTimeTrial_Delta_HbTFAD_mice_median(logical(mask_new)));
lagTime_FADCalcium_Delta = nanmean(lagTimeTrial_Delta_FADCalcium_mice_median(logical(mask_new)));
