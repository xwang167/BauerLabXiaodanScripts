
     
                
                
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


% 
% 
excelRows = [195 202 204 230 234 240];% [181,183,185,228,232,236];%[181,183,185,228,232,236];%321:327;

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
        load(fullfile(saveDir,processedName),'xform_datahb')
% % 
        if strcmp(sessionType,'fc')


            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
                xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
                xform_total(isinf(xform_total)) = 0;
                xform_total(isnan(xform_total)) = 0;
                xform_FADCorr(isnan(xform_FADCorr)) = 0;
                xform_FADCorr(isinf(xform_FADCorr)) = 0;
                xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
                xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;



                %%comparing our NVC measures to Hillman (0.02-2)
                disp('filtering')
                xform_total_filtered = mouse.freq.filterData(double(xform_total),0.009,0.08,fs);
                xform_FADCorr_filtered = mouse.freq.filterData(double(xform_FADCorr),0.09,0.08,fs);
                xform_jrgeco1aCorr_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.009,0.08,fs);
                edgeLen =1;
                tZone = 4;
                corrThr = 0;
                validRange = - edgeLen: round(tZone*fs);
                tLim = [-2 2];
                tLim_FAD = [0 0.3];
                rLim = [-1 1];
                disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
% % 
                                [lagTimeTrial_ISA_HbTCalcium, lagAmpTrial_ISA_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                    xform_total_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true);                                
                                lagTimeTrial_ISA_HbTCalcium = lagTimeTrial_ISA_HbTCalcium./fs;
                
                                [lagTimeTrial_ISA_FADCalcium, lagAmpTrial_ISA_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
                                    xform_FADCorr_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true);
                                lagTimeTrial_ISA_FADCalcium= lagTimeTrial_ISA_FADCalcium./fs;
                                
                                                                [lagTimeTrial_ISA_HbTFAD, lagAmpTrial_ISA_HbTFAD,covResult_HbTFAD] = mouse.conn.dotLag(...
                                    xform_total_filtered,xform_FADCorr_filtered,edgeLen,validRange,corrThr, true,true);
                                lagTimeTrial_ISA_HbTFAD= lagTimeTrial_ISA_HbTFAD./fs;
                                
                clear clear xform_total_filtered xform_FADCorr_filtered xform_jrgeco1aCorr_filtered
                                figure;
                                colormap jet;
                                subplot(2,3,1); imagesc(lagTimeTrial_ISA_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,2); imagesc(lagTimeTrial_ISA_FADCalcium,tLim_FAD);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,3); imagesc(lagTimeTrial_ISA_HbTFAD,[-1 1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                              
                                subplot(2,3,4); imagesc(lagAmpTrial_ISA_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,5); imagesc(lagAmpTrial_ISA_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,6); imagesc(lagAmpTrial_ISA_HbTFAD,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' ISA'))
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_ISA.png')));
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_ISA.fig')));
                                save(fullfile(saveDir,processedName),'lagTimeTrial_ISA_HbTCalcium', 'lagAmpTrial_ISA_HbTCalcium','lagTimeTrial_ISA_FADCalcium', 'lagAmpTrial_ISA_FADCalcium','lagTimeTrial_ISA_HbTFAD', 'lagAmpTrial_ISA_HbTFAD','-append');
                                close all

           end
            close all
        end
    end
end



excelRows = [181,183,185,228,232,236];%[195 202 204 181 183 185];[181,183,185,228,232,236];%
miceCat = 'Awake RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_ISA_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagTimeTrial_ISA_FADCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_FADCalcium_mice_mean = zeros(128,128,length(excelRows));
lagTimeTrial_ISA_HbTFAD_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_HbTFAD_mice_mean = zeros(128,128,length(excelRows));

lagTimeTrial_ISA_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagTimeTrial_ISA_FADCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_FADCalcium_mice_median = zeros(128,128,length(excelRows));
lagTimeTrial_ISA_HbTFAD_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_ISA_HbTFAD_mice_median = zeros(128,128,length(excelRows));



lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["ISA","ISA"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium","HbTFAD"];

tLim = [0 2];
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
    lagTimeTrial_ISA_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_ISA_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagTimeTrial_ISA_FADCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_ISA_FADCalcium_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');

    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                
                for ii = 1:2
                    for jj = 1:3
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),'_mouse(:,:,n)','= ',lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),';'));
                        
                    end
                end
                
                
                               
                
                
            end
            close all
        end
    end
    
    
    lagTimeTrial_ISA_HbTCalcium_mouse_mean = nanmean(lagTimeTrial_ISA_HbTCalcium_mouse,3);
    lagAmpTrial_ISA_HbTCalcium_mouse_mean = nanmean(lagAmpTrial_ISA_HbTCalcium_mouse,3);
    lagTimeTrial_ISA_FADCalcium_mouse_mean = nanmean(lagTimeTrial_ISA_FADCalcium_mouse,3);
    lagAmpTrial_ISA_FADCalcium_mouse_mean = nanmean(lagAmpTrial_ISA_FADCalcium_mouse,3);
    lagTimeTrial_ISA_HbTFAD_mouse_mean = nanmean(lagTimeTrial_ISA_HbTFAD_mouse,3);
    lagAmpTrial_ISA_HbTFAD_mouse_mean = nanmean(lagAmpTrial_ISA_HbTFAD_mouse,3);
    
    lagTimeTrial_ISA_HbTCalcium_mouse_median = nanmedian(lagTimeTrial_ISA_HbTCalcium_mouse,3);
    lagAmpTrial_ISA_HbTCalcium_mouse_median = nanmedian(lagAmpTrial_ISA_HbTCalcium_mouse,3);
    lagTimeTrial_ISA_FADCalcium_mouse_median = nanmedian(lagTimeTrial_ISA_FADCalcium_mouse,3);
    lagAmpTrial_ISA_FADCalcium_mouse_median = nanmedian(lagAmpTrial_ISA_FADCalcium_mouse,3);
    lagTimeTrial_ISA_HbTFAD_mouse_median = nanmedian(lagTimeTrial_ISA_HbTFAD_mouse,3);
    lagAmpTrial_ISA_HbTFAD_mouse_median = nanmedian(lagAmpTrial_ISA_HbTFAD_mouse,3);
    
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_ISA_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_ISA_FADCalcium_mouse_mean,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_ISA_HbTFAD_mouse_mean,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,4); imagesc(lagAmpTrial_ISA_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_ISA_FADCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_ISA_HbTFAD_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean',' ISA'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_ISA_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_ISA_mean.fig')));
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_ISA_HbTCalcium_mouse_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_ISA_FADCalcium_mouse_median,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
      subplot(2,3,3); imagesc(lagTimeTrial_ISA_HbTFAD_mouse_median,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,4); imagesc(lagAmpTrial_ISA_HbTCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_ISA_FADCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_ISA_HbTFAD_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
        
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median',' ISA'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_ISA_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_ISA_median.fig')));
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_ISA_HbTCalcium_mouse_mean', 'lagAmpTrial_ISA_HbTCalcium_mouse_mean','lagTimeTrial_ISA_FADCalcium_mouse_mean', 'lagAmpTrial_ISA_FADCalcium_mouse_mean','lagTimeTrial_ISA_HbTFAD_mouse_mean', 'lagAmpTrial_ISA_HbTFAD_mouse_mean',...
        'lagTimeTrial_ISA_HbTCalcium_mouse_median', 'lagAmpTrial_ISA_HbTCalcium_mouse_median','lagTimeTrial_ISA_FADCalcium_mouse_median', 'lagAmpTrial_ISA_FADCalcium_mouse_median','lagTimeTrial_ISA_HbTFAD_mouse_median', 'lagAmpTrial_ISA_HbTFAD_mouse_median',...
        '-append');
    

    
    lagTimeTrial_ISA_HbTCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_ISA_HbTCalcium_mouse_mean;
    lagAmpTrial_ISA_HbTCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_ISA_HbTCalcium_mouse_mean;
    lagTimeTrial_ISA_FADCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_ISA_FADCalcium_mouse_mean;
    lagAmpTrial_ISA_FADCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_ISA_FADCalcium_mouse_mean;
        lagTimeTrial_ISA_HbTFAD_mice_mean(:,:,mouseInd) = lagTimeTrial_ISA_HbTFAD_mouse_mean;
    lagAmpTrial_ISA_HbTFAD_mice_mean(:,:,mouseInd) = lagAmpTrial_ISA_HbTFAD_mouse_mean;
    
    
    lagTimeTrial_ISA_HbTCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_ISA_HbTCalcium_mouse_median;
    lagAmpTrial_ISA_HbTCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_ISA_HbTCalcium_mouse_median;
    lagTimeTrial_ISA_FADCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_ISA_FADCalcium_mouse_median;
    lagAmpTrial_ISA_FADCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_ISA_FADCalcium_mouse_median;
        lagTimeTrial_ISA_HbTFAD_mice_median(:,:,mouseInd) = lagTimeTrial_ISA_HbTFAD_mouse_median;
    lagAmpTrial_ISA_HbTFAD_mice_median(:,:,mouseInd) = lagAmpTrial_ISA_HbTFAD_mouse_median;
    
    for ii = 1:2
        for jj = 1:3
            for kk = 1:2
                %eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),char(39),')'));
                eval(strcat(lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(kk),'(:,:,mouseInd)','= ',lagParaStrs(ii),'Trial_ISA_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),';'));
            end
            
        end
    end
    
    

    
    
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTimeTrial_ISA_HbTCalcium_mice_mean = nanmean(lagTimeTrial_ISA_HbTCalcium_mice_mean,3);
lagAmpTrial_ISA_HbTCalcium_mice_mean = nanmean(lagAmpTrial_ISA_HbTCalcium_mice_mean,3);
lagTimeTrial_ISA_FADCalcium_mice_mean = nanmean(lagTimeTrial_ISA_FADCalcium_mice_mean,3);
lagAmpTrial_ISA_FADCalcium_mice_mean= nanmean(lagAmpTrial_ISA_FADCalcium_mice_mean,3);
lagTimeTrial_ISA_HbTFAD_mice_mean = nanmean(lagTimeTrial_ISA_HbTFAD_mice_mean,3);
lagAmpTrial_ISA_HbTFAD_mice_mean = nanmean(lagAmpTrial_ISA_HbTFAD_mice_mean,3);

lagTimeTrial_ISA_HbTCalcium_mice_median = nanmedian(lagTimeTrial_ISA_HbTCalcium_mice_median,3);
lagAmpTrial_ISA_HbTCalcium_mice_median = nanmedian(lagAmpTrial_ISA_HbTCalcium_mice_median,3);
lagTimeTrial_ISA_FADCalcium_mice_median = nanmedian(lagTimeTrial_ISA_FADCalcium_mice_median,3);
lagAmpTrial_ISA_FADCalcium_mice_median= nanmedian(lagAmpTrial_ISA_FADCalcium_mice_median,3);
lagTimeTrial_ISA_HbTFAD_mice_median = nanmedian(lagTimeTrial_ISA_HbTFAD_mice_median,3);
lagAmpTrial_ISA_HbTFAD_mice_median = nanmedian(lagAmpTrial_ISA_HbTFAD_mice_median,3);


figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_ISA_HbTCalcium_mice_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_ISA_FADCalcium_mice_mean,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_ISA_HbTFAD_mice_mean,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_ISA_HbTCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_ISA_FADCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_ISA_HbTFAD_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean',' ISA'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_ISA_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_ISA_mean.fig')));

figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_ISA_HbTCalcium_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_ISA_FADCalcium_mice_median,[0 0.8]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_ISA_HbTFAD_mice_median,[0 2]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_ISA_HbTCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_ISA_FADCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_ISA_HbTFAD_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median', ' ISA'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_ISA_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_ISA_median.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_ISA_HbTCalcium_mice_mean', 'lagAmpTrial_ISA_HbTCalcium_mice_mean','lagTimeTrial_ISA_FADCalcium_mice_mean', 'lagAmpTrial_ISA_FADCalcium_mice_mean','lagTimeTrial_ISA_HbTFAD_mice_mean', 'lagAmpTrial_ISA_HbTFAD_mice_mean',...
    'lagTimeTrial_ISA_HbTCalcium_mice_median', 'lagAmpTrial_ISA_HbTCalcium_mice_median','lagTimeTrial_ISA_FADCalcium_mice_median', 'lagAmpTrial_ISA_FADCalcium_mice_median', 'lagTimeTrial_ISA_HbTFAD_mice_median', 'lagAmpTrial_ISA_HbTFAD_mice_median',...
    '-append');



lagTime_HbTCalcium_ISA = nanmean(lagTimeTrial_ISA_HbTCalcium_mice_median(logical(mask_new)));
lagTime_HbTFAD_ISA = nanmean(lagTimeTrial_ISA_HbTFAD_mice_median(logical(mask_new)));
lagTime_FADCalcium_ISA = nanmean(lagTimeTrial_ISA_FADCalcium_mice_median(logical(mask_new)));
