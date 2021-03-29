clear all
close all
clc
excelRows =[181,183,185,228,232,236];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = 'Awake RGECO';
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
GoodRuns = {1:3,3,[];
    1:3,1:3,1:3;
    1:3,1:3,1:3;
    1:3,1:3,[2,3];
    [2,3],[2,3],1:3;
    [],[2,3],1:3};

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_HbTCalcium_mice_mean_GoodRuns = [];
lagAmpTrial_HbTCalcium_mice_mean_GoodRuns = [];
lagTimeTrial_FADCalcium_mice_mean_GoodRuns = [];
lagAmpTrial_FADCalcium_mice_mean_GoodRuns = [];
lagTimeTrial_HbTFAD_mice_mean_GoodRuns = [];
lagAmpTrial_HbTFAD_mice_mean_GoodRuns = [];

lagTimeTrial_HbTCalcium_mice_median_GoodRuns = [];
lagAmpTrial_HbTCalcium_mice_median_GoodRuns = [];
lagTimeTrial_FADCalcium_mice_median_GoodRuns = [];
lagAmpTrial_FADCalcium_mice_median_GoodRuns = [];
lagTimeTrial_HbTFAD_mice_median_GoodRuns = [];
lagAmpTrial_HbTFAD_mice_median_GoodRuns = [];



lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["ISA","Delta"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium","HbTFAD"];

tLim = [0 1.5];
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
    lagTimeTrial_HbTCalcium_mouse = [];
    lagAmpTrial_HbTCalcium_mouse = [];
    lagTimeTrial_FADCalcium_mouse = [];
    lagAmpTrial_FADCalcium_mouse = [];
    lagTimeTrial_HbTFAD_mouse = [];
    lagAmpTrial_HbTFAD_mouse = [];
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    for n = GoodRuns{mouseInd,1}
        if ~isempty(n)
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            disp('loading processed data')
            
            if strcmp(sessionType,'fc')
                
                
                if strcmp(sessionInfo.mouseType,'jrgeco1a')
                    jj = 1;
                    for ii = 1:2
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse',...
                            '= cat(3,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),');'));
                    end
                end
                close all
            end
        end
    end
    for n = GoodRuns{mouseInd,2}
        if ~isempty(n)
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            disp('loading processed data')
            
            if strcmp(sessionType,'fc')
                
                
                if strcmp(sessionInfo.mouseType,'jrgeco1a')
                    jj = 2;
                    for ii = 1:2
                        
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse',...
                            '= cat(3,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),');'));
                        
                    end
                end
                close all
            end
        end
    end
    
    for n = GoodRuns{mouseInd,3}
        if ~isempty(n)
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            disp('loading processed data')
            
            if strcmp(sessionType,'fc')
                
                
                if strcmp(sessionInfo.mouseType,'jrgeco1a')
                    jj = 3;
                    for ii = 1:2
                        
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse',...
                            '= cat(3,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse,',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),');'));
                        
                    end
                end
                close all
            end
        end
    end
    
    lagTimeTrial_HbTCalcium_mouse_mean_GoodRuns = nanmean(lagTimeTrial_HbTCalcium_mouse,3);
    lagAmpTrial_HbTCalcium_mouse_mean_GoodRuns = nanmean(lagAmpTrial_HbTCalcium_mouse,3);
    lagTimeTrial_FADCalcium_mouse_mean_GoodRuns = nanmean(lagTimeTrial_FADCalcium_mouse,3);
    lagAmpTrial_FADCalcium_mouse_mean_GoodRuns = nanmean(lagAmpTrial_FADCalcium_mouse,3);
    lagTimeTrial_HbTFAD_mouse_mean_GoodRuns = nanmean(lagTimeTrial_HbTFAD_mouse,3);
    lagAmpTrial_HbTFAD_mouse_mean_GoodRuns = nanmean(lagAmpTrial_HbTFAD_mouse,3);
    
    lagTimeTrial_HbTCalcium_mouse_median_GoodRuns = nanmedian(lagTimeTrial_HbTCalcium_mouse,3);
    lagAmpTrial_HbTCalcium_mouse_median_GoodRuns = nanmedian(lagAmpTrial_HbTCalcium_mouse,3);
    lagTimeTrial_FADCalcium_mouse_median_GoodRuns = nanmedian(lagTimeTrial_FADCalcium_mouse,3);
    lagAmpTrial_FADCalcium_mouse_median_GoodRuns = nanmedian(lagAmpTrial_FADCalcium_mouse,3);
    lagTimeTrial_HbTFAD_mouse_median_GoodRuns = nanmedian(lagTimeTrial_HbTFAD_mouse,3);
    lagAmpTrial_HbTFAD_mouse_median_GoodRuns = nanmedian(lagAmpTrial_HbTFAD_mouse,3);
    
    
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_HbTCalcium_mouse_mean_GoodRuns,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_FADCalcium_mouse_mean_GoodRuns,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_HbTFAD_mouse_mean_GoodRuns,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_HbTCalcium_mouse_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_FADCalcium_mouse_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_HbTFAD_mouse_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_mean_GoodRuns.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_mean_GoodRuns.fig')));
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_HbTCalcium_mouse_median_GoodRuns,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_FADCalcium_mouse_median_GoodRuns,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_HbTFAD_mouse_median_GoodRuns,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_HbTCalcium_mouse_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_FADCalcium_mouse_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_HbTFAD_mouse_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median_GoodRuns'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_median_GoodRuns.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_median_GoodRuns.fig')));
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean_GoodRuns', 'lagAmpTrial_HbTCalcium_mouse_mean_GoodRuns','lagTimeTrial_FADCalcium_mouse_mean_GoodRuns', 'lagAmpTrial_FADCalcium_mouse_mean_GoodRuns','lagTimeTrial_HbTFAD_mouse_mean_GoodRuns', 'lagAmpTrial_HbTFAD_mouse_mean_GoodRuns',...
        'lagTimeTrial_HbTCalcium_mouse_median_GoodRuns', 'lagAmpTrial_HbTCalcium_mouse_median_GoodRuns','lagTimeTrial_FADCalcium_mouse_median_GoodRuns', 'lagAmpTrial_FADCalcium_mouse_median_GoodRuns','lagTimeTrial_HbTFAD_mouse_median_GoodRuns', 'lagAmpTrial_HbTFAD_mouse_median_GoodRuns',...
        '-append');
    
    
    if ~isempty(lagTimeTrial_HbTCalcium_mouse_mean_GoodRuns)
    lagTimeTrial_HbTCalcium_mice_mean_GoodRuns = cat(3,lagTimeTrial_HbTCalcium_mice_mean_GoodRuns,lagTimeTrial_HbTCalcium_mouse_mean_GoodRuns);
    lagAmpTrial_HbTCalcium_mice_mean_GoodRuns = cat(3,lagAmpTrial_HbTCalcium_mice_mean_GoodRuns,lagAmpTrial_HbTCalcium_mouse_mean_GoodRuns);
     lagTimeTrial_HbTCalcium_mice_median_GoodRuns = cat(3,lagTimeTrial_HbTCalcium_mice_median_GoodRuns,lagTimeTrial_HbTCalcium_mouse_median_GoodRuns);
    lagAmpTrial_HbTCalcium_mice_median_GoodRuns = cat(3,lagAmpTrial_HbTCalcium_mice_median_GoodRuns,lagAmpTrial_HbTCalcium_mouse_median_GoodRuns);
    end
    
    if ~isempty(lagTimeTrial_FADCalcium_mouse_mean_GoodRuns)
    lagTimeTrial_FADCalcium_mice_mean_GoodRuns = cat(3,lagTimeTrial_FADCalcium_mice_mean_GoodRuns,lagTimeTrial_FADCalcium_mouse_mean_GoodRuns);
    lagAmpTrial_FADCalcium_mice_mean_GoodRuns = cat(3,lagAmpTrial_FADCalcium_mice_mean_GoodRuns,lagAmpTrial_FADCalcium_mouse_mean_GoodRuns);
      lagTimeTrial_FADCalcium_mice_median_GoodRuns = cat(3,lagTimeTrial_FADCalcium_mice_median_GoodRuns,lagTimeTrial_FADCalcium_mouse_median_GoodRuns);
    lagAmpTrial_FADCalcium_mice_median_GoodRuns = cat(3,lagAmpTrial_FADCalcium_mice_median_GoodRuns,lagAmpTrial_FADCalcium_mouse_median_GoodRuns);
    end
    
    if~isempty(lagTimeTrial_HbTFAD_mouse_mean_GoodRuns)
    lagTimeTrial_HbTFAD_mice_mean_GoodRuns = cat(3,lagTimeTrial_HbTFAD_mice_mean_GoodRuns,lagTimeTrial_HbTFAD_mouse_mean_GoodRuns);
    lagAmpTrial_HbTFAD_mice_mean_GoodRuns = cat(3,lagAmpTrial_HbTFAD_mice_mean_GoodRuns,lagAmpTrial_HbTFAD_mouse_mean_GoodRuns);
    lagTimeTrial_HbTFAD_mice_median_GoodRuns = cat(3,lagTimeTrial_HbTFAD_mice_median_GoodRuns,lagTimeTrial_HbTFAD_mouse_median_GoodRuns);
    lagAmpTrial_HbTFAD_mice_median_GoodRuns = cat(3,lagAmpTrial_HbTFAD_mice_median_GoodRuns,lagAmpTrial_HbTFAD_mouse_median_GoodRuns);
    end
%     for ii = 1:2
%         for jj = 1:3
%             for kk = 1:2
%                 %eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),char(39),')'));
%                 eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(kk),'(:,:,mouseInd)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),';'));
%             end
%             
%         end
%     end
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTimeTrial_HbTCalcium_mice_mean_GoodRuns = nanmean(lagTimeTrial_HbTCalcium_mice_mean_GoodRuns,3);
lagAmpTrial_HbTCalcium_mice_mean_GoodRuns = nanmean(lagAmpTrial_HbTCalcium_mice_mean_GoodRuns,3);
lagTimeTrial_FADCalcium_mice_mean_GoodRuns = nanmean(lagTimeTrial_FADCalcium_mice_mean_GoodRuns,3);
lagAmpTrial_FADCalcium_mice_mean_GoodRuns= nanmean(lagAmpTrial_FADCalcium_mice_mean_GoodRuns,3);
lagTimeTrial_HbTFAD_mice_mean_GoodRuns = nanmean(lagTimeTrial_HbTFAD_mice_mean_GoodRuns,3);
lagAmpTrial_HbTFAD_mice_mean_GoodRuns = nanmean(lagAmpTrial_HbTFAD_mice_mean_GoodRuns,3);

lagTimeTrial_HbTCalcium_mice_median_GoodRuns = nanmedian(lagTimeTrial_HbTCalcium_mice_median_GoodRuns,3);
lagAmpTrial_HbTCalcium_mice_median_GoodRuns = nanmedian(lagAmpTrial_HbTCalcium_mice_median_GoodRuns,3);
lagTimeTrial_FADCalcium_mice_median_GoodRuns = nanmedian(lagTimeTrial_FADCalcium_mice_median_GoodRuns,3);
lagAmpTrial_FADCalcium_mice_median_GoodRuns= nanmedian(lagAmpTrial_FADCalcium_mice_median_GoodRuns,3);
lagTimeTrial_HbTFAD_mice_median_GoodRuns = nanmedian(lagTimeTrial_HbTFAD_mice_median_GoodRuns,3);
lagAmpTrial_HbTFAD_mice_median_GoodRuns = nanmedian(lagAmpTrial_HbTFAD_mice_median_GoodRuns,3);


figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_HbTCalcium_mice_mean_GoodRuns,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_FADCalcium_mice_mean_GoodRuns,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_HbTFAD_mice_mean_GoodRuns,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_HbTCalcium_mice_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_FADCalcium_mice_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_HbTFAD_mice_mean_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_mean_GoodRuns.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_mean_GoodRuns.fig')));

figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_HbTCalcium_mice_median_GoodRuns,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_FADCalcium_mice_median_GoodRuns,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_HbTFAD_mice_median_GoodRuns,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_HbTCalcium_mice_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_FADCalcium_mice_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_HbTFAD_mice_median_GoodRuns,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median_GoodRuns',' 0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median_GoodRuns.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median_GoodRuns.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_HbTCalcium_mice_mean_GoodRuns', 'lagAmpTrial_HbTCalcium_mice_mean_GoodRuns','lagTimeTrial_FADCalcium_mice_mean_GoodRuns', 'lagAmpTrial_FADCalcium_mice_mean_GoodRuns','lagTimeTrial_HbTFAD_mice_mean_GoodRuns', 'lagAmpTrial_HbTFAD_mice_mean_GoodRuns',...
    'lagTimeTrial_HbTCalcium_mice_median_GoodRuns', 'lagAmpTrial_HbTCalcium_mice_median_GoodRuns','lagTimeTrial_FADCalcium_mice_median_GoodRuns', 'lagAmpTrial_FADCalcium_mice_median_GoodRuns', 'lagTimeTrial_HbTFAD_mice_median_GoodRuns', 'lagAmpTrial_HbTFAD_mice_median_GoodRuns',...
    '-append');



lagTime_HbTCalcium = nanmean(lagTimeTrial_HbTCalcium_mice_median_GoodRuns(logical(mask_new)));
lagTime_HbTFAD = nanmean(lagTimeTrial_HbTFAD_mice_median_GoodRuns(logical(mask_new)));
lagTime_FADCalcium = nanmean(lagTimeTrial_FADCalcium_mice_median_GoodRuns(logical(mask_new)));