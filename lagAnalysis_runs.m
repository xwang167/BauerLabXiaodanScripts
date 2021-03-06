% close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";




excelRows = [181,183,185,228,232,236];%321:327;

runs = 1;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
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
% 
                xform_total_filtered = mouse.freq.filterData(double(xform_total),0.02,2,fs);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise

                xform_FADCorr_filtered = mouse.freq.filterData(double(xform_FADCorr),0.02,2,fs);
                xform_jrgeco1aCorr_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.02,2,fs);
                edgeLen =1;
                tZone = 4;
                corrThr = 0;
                validRange = - edgeLen: round(tZone*fs);
                tLim = [-2 2];
                tLim_FAD = [0 0.3];
                rLim = [-1 1];
                disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
% % 
                                [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                    xform_total_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true);
                                clear xform_total_filtered
                                lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                
                                [lagTimeTrial_FADCalcium, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
                                    xform_FADCorr_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,true);
                                clear xform_FADCorr_filtered xform_jrgeco1aCorr_filtered
                                lagTimeTrial_FADCalcium= lagTimeTrial_FADCalcium./fs;
                
                                figure;
                                colormap jet;
                                subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                                subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium,tLim_FAD);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                                subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                                subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)))
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.png')));
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.fig')));
                                save(fullfile(saveDir,processedName),'lagTimeTrial_HbTCalcium', 'lagAmpTrial_HbTCalcium','lagTimeTrial_FADCalcium', 'lagAmpTrial_FADCalcium','-append');
                                close all
                %functionally relvenat brain organization (lag with respect to global signal)
%                 ISA = [0.009 0.08];
%                 Delta = [0.4 4];
%                 validRange = -round(tZone*fs): round(tZone*fs);
%                 tLim_ISA = [-1.5 1.5];
% %                 tLim_Delta = [-0.02 0.02];
%                 corrThr = 0;
%                 [lagTime_GS_Calcium_ISA,lagAmp_GS_Calcium_ISA] = calcLagGS(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 [lagTime_GS_FAD_ISA,lagAmp_GS_FAD_ISA] = calcLagGS(xform_FADCorr,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 [lagTime_GS_total_ISA,lagAmp_GS_total_ISA] = calcLagGS(xform_total,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 save(fullfile(saveDir,processedName),'lagTime_GS_total_ISA', 'lagAmp_GS_total_ISA','lagTime_GS_FAD_ISA', 'lagAmp_GS_FAD_ISA','lagTime_GS_Calcium_ISA','lagAmp_GS_Calcium_ISA','-append');
% 
% 
%                 figure;
%                 colormap jet
%                 subplot(2,3,1); imagesc(lagTime_GS_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,2); imagesc(lagTime_GS_FAD_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,3); imagesc(lagTime_GS_total_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,4); imagesc(lagAmp_GS_Calcium_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,5); imagesc(lagAmp_GS_FAD_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,6); imagesc(lagAmp_GS_total_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Lag with GS, ISA'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_ISA.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_ISA.fig')));
% 
% 
%                 [lagTime_GS_total_Delta,lagAmp_GS_total_Delta] = calcLagGS(xform_total,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
%                 [lagTime_GS_FAD_Delta,lagAmp_GS_FAD_Delta] = calcLagGS(xform_FADCorr,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
%                 [lagTime_GS_Calcium_Delta,lagAmp_GS_Calcium_Delta] = calcLagGS(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
% 
%                 save(fullfile(saveDir,processedName),'lagTime_GS_total_Delta', 'lagAmp_GS_total_Delta','lagTime_GS_FAD_Delta', 'lagAmp_GS_FAD_Delta','lagTime_GS_Calcium_Delta','lagAmp_GS_Calcium_Delta','-append');
% 
% 
%                 figure;
%                 colormap jet
%                 subplot(2,3,1); imagesc(lagTime_GS_Calcium_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,2); imagesc(lagTime_GS_FAD_Delta,tLim_Delta/2); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,3); imagesc(lagTime_GS_total_Delta,tLim_Delta/2); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,4); imagesc(lagAmp_GS_Calcium_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,5); imagesc(lagAmp_GS_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,3,6); imagesc(lagAmp_GS_total_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Lag with GS, Delta'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_Delta.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_Delta.fig')));
%                 close all
           end
            close all
        end
    end
end



excelRows = [181,183,185,228,232,236];%[195 202 204 230 234 240];%[195 202 204 181 183 185];
miceCat = 'Awake RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
lagTimeTrial_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagTimeTrial_FADCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_FADCalcium_mice_mean = zeros(128,128,length(excelRows));

lagTimeTrial_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagTimeTrial_FADCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_FADCalcium_mice_median = zeros(128,128,length(excelRows));



lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["ISA","Delta"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium"];

tLim = [0 1.2];
rLim = [-1 1];
tLim_ISA = [-0.25 0.25];
tLim_Delta = [-0.06 0.06];
for ii = 1:2
    for jj = 1:3
        for kk = 1:2
            eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice','=  zeros(128,128,length(excelRows));'));
        end
    end
end


miceName = [];
saveDir_cat = 'D:\RGECO\cat';
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
    maskDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    fs = excelRaw{7};
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    lagTimeTrial_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagTimeTrial_FADCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_FADCalcium_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    for ii = 1:2
        for jj = 1:3
            for kk = 1:2
                eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse','=  zeros(128,128,length(runs));'));
            end
        end
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                
                for ii = 1:2
                    for jj = 1:2
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse(:,:,n)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),';'));
                        
                    end
                end
                
                
                
%                 for ii = 1:2
%                     for jj = 1:3
%                         for kk = 1:2
%                             eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),char(39),')'));
%                             eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse(:,:,n)','= ',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),';'));
%                         end
%                     end
%                 end
%                 
                
                
            end
            close all
        end
    end
    
    
    lagTimeTrial_HbTCalcium_mouse_mean = nanmean(lagTimeTrial_HbTCalcium_mouse,3);
    lagAmpTrial_HbTCalcium_mouse_mean = nanmean(lagAmpTrial_HbTCalcium_mouse,3);
    lagTimeTrial_FADCalcium_mouse_mean = nanmean(lagTimeTrial_FADCalcium_mouse,3);
    lagAmpTrial_FADCalcium_mouse_mean = nanmean(lagAmpTrial_FADCalcium_mouse,3);
    
    lagTimeTrial_HbTCalcium_mouse_median = nanmedian(lagTimeTrial_HbTCalcium_mouse,3);
    lagAmpTrial_HbTCalcium_mouse_median = nanmedian(lagAmpTrial_HbTCalcium_mouse,3);
    lagTimeTrial_FADCalcium_mouse_median = nanmedian(lagTimeTrial_FADCalcium_mouse,3);
    lagAmpTrial_FADCalcium_mouse_median = nanmedian(lagAmpTrial_FADCalcium_mouse,3);
    
    
%     for ii = 1:2
%         for jj = 1:3
%             for kk = 1:2
%                 for ll = 1:2
%                     
%                     eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse_',avgWayStrs(ll),'= nan',avgWayStrs(ll),'(',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse,3);'));
%                     eval(strcat('save(fullfile(saveDir,processedName_mouse), ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse_',avgWayStrs(ll),char(39),',',char(39),'-append',char(39),')'));
%                 end
%             end
%         end
%     end
%     
%     
    figure;
    colormap jet;
    subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mouse_mean,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_mean.fig')));
    
    figure;
    colormap jet;
    subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mouse_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mouse_median,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_median.fig')));
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_HbTCalcium_mouse_mean', 'lagAmpTrial_HbTCalcium_mouse_mean','lagTimeTrial_FADCalcium_mouse_mean', 'lagAmpTrial_FADCalcium_mouse_mean',...
        'lagTimeTrial_HbTCalcium_mouse_median', 'lagAmpTrial_HbTCalcium_mouse_median','lagTimeTrial_FADCalcium_mouse_median', 'lagAmpTrial_FADCalcium_mouse_median',...
        '-append');
    
    
%     for ii = 1:2
%         for jj = 1:2
%             figure;colormap jet;
%             subplot(2,3,1); eval(strcat('imagesc(lagTime_GS_Calcium_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,2); eval(strcat('imagesc(lagTime_GS_FAD_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             
%             subplot(2,3,3); eval(strcat('imagesc(lagTime_GS_total_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,4); eval(strcat('imagesc(lagAmp_GS_Calcium_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,5); eval(strcat('imagesc(lagAmp_GS_FAD_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,6); eval(strcat('imagesc(lagAmp_GS_total_',bandStrs(ii),'_mouse_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'Lag with GS, ',bandStrs(ii),',',avgWayStrs(jj) ))
%             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.png')));
%             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.fig')));
%             
%             
%         end
%     end
    
    lagTimeTrial_HbTCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_mean;
    lagAmpTrial_HbTCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_mean;
    lagTimeTrial_FADCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_FADCalcium_mouse_mean;
    lagAmpTrial_FADCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_FADCalcium_mouse_mean;
    
    
    lagTimeTrial_HbTCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse_median;
    lagAmpTrial_HbTCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse_median;
    lagTimeTrial_FADCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_FADCalcium_mouse_median;
    lagAmpTrial_FADCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_FADCalcium_mouse_median;
    
    for ii = 1:2
        for jj = 1:2
            for kk = 1:2
                %eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),char(39),')'));
                eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(kk),'(:,:,mouseInd)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),';'));
            end
            
        end
    end
    
    
    
    for ii = 1:2
        for jj = 1:3
            for kk = 1:2
                for ll = 1:2
                    eval(strcat('load(fullfile(saveDir, processedName_mouse), ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse_',avgWayStrs(ll),char(39),')'));
                    eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(ll),'(:,:,mouseInd)','= ',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mouse_',avgWayStrs(ll),';'));
                end
            end
        end
    end
    
    
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTimeTrial_HbTCalcium_mice_mean = nanmean(lagTimeTrial_HbTCalcium_mice_mean,3);
lagAmpTrial_HbTCalcium_mice_mean = nanmean(lagAmpTrial_HbTCalcium_mice_mean,3);
lagTimeTrial_FADCalcium_mice_mean = nanmean(lagTimeTrial_FADCalcium_mice_mean,3);
lagAmpTrial_FADCalcium_mice_mean= nanmean(lagAmpTrial_FADCalcium_mice_mean,3);

lagTimeTrial_HbTCalcium_mice_median = nanmedian(lagTimeTrial_HbTCalcium_mice_median,3);
lagAmpTrial_HbTCalcium_mice_median = nanmedian(lagAmpTrial_HbTCalcium_mice_median,3);
lagTimeTrial_FADCalcium_mice_median = nanmedian(lagTimeTrial_FADCalcium_mice_median,3);
lagAmpTrial_FADCalcium_mice_median= nanmedian(lagAmpTrial_FADCalcium_mice_median,3);


% for ii = 1:2
%     for jj = 1:3
%         for kk = 1:2
%             for ll = 1:2
%                 eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(ll),'= nan',avgWayStrs(ll),'(',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(ll),',3);'));
%                 eval(strcat('save(fullfile(saveDir_cat,processedName_mice),',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(ll),char(39),',',char(39),'-append',char(39),')'));
%             end
%         end
%     end
% end

figure;
colormap jet;
subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mice_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mice_mean,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_mean.fig')));

figure;
colormap jet;
subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mice_median,[0 0.1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_median.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_HbTCalcium_mice_mean', 'lagAmpTrial_HbTCalcium_mice_mean','lagTimeTrial_FADCalcium_mice_mean', 'lagAmpTrial_FADCalcium_mice_mean',...
    'lagTimeTrial_HbTCalcium_mice_median', 'lagAmpTrial_HbTCalcium_mice_median','lagTimeTrial_FADCalcium_mice_median', 'lagAmpTrial_FADCalcium_mice_median',...
    '-append');



% for ii = 1:2
%     for jj = 1:2
%         figure;colormap jet;
%         subplot(2,3,1); eval(strcat('imagesc(lagTime_GS_Calcium_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         subplot(2,3,2); eval(strcat('imagesc(lagTime_GS_FAD_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         
%         subplot(2,3,3); eval(strcat('imagesc(lagTime_GS_total_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         subplot(2,3,4); eval(strcat('imagesc(lagAmp_GS_Calcium_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         subplot(2,3,5); eval(strcat('imagesc(lagAmp_GS_FAD_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         subplot(2,3,6); eval(strcat('imagesc(lagAmp_GS_total_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%         axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         
%         suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'Lag with GS, ',bandStrs(ii),',',avgWayStrs(jj) ))
%         saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.png')));
%         saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.fig')));
%         
%         
%     end
% end







%  calcium_filtered = mouse.freq.filterData(double(y{20}),0.02,2,fs);
%  total_filtered = mouse.freq.filterData(double(y{16}),0.02,2,fs);
%  FAD_filtered = mouse.freq.filterData(double(y{19}),0.02,2,fs);
%
%  plot(x{20},calcium_filtered,'m')
%  hold on
%  plot(x{20},FAD_filtered,'g')
%  hold on
%  plot(x{20},total_filtered,'r')
%  [lagTime_HbTCalcium,lagAmp_HbTCalcium,covResult_HbTCalcium]...
%             = mouse.conn.findLag(total_filtered,double(y{20}),false,true,validRange,...
%             edgeLen,corrThr);
%      lagTime_HbTCalcium = lagTime_HbTCalcium/fs;
%
%       [lagTime_FADCalcium,lagAmp_FADCalcium,covResult_FADCalcium]...
%             = mouse.conn.findLag(FAD_filtered,calcium_filtered,false,true,validRange,...
%             edgeLen,corrThr);
%      lagTime_FADCalcium = lagTime_FADCalcium/fs;
%
%
%
%

% function [lagTime_GS,lagAmp_GS] = calcLagGS(data,minFreq,maxFreq,fs,edgeLen,validRange,corrThr)
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = leftMask+rightMask;
% for ii = 1:length(data)
%     data(:,:,ii) = data(:,:,ii).*double(mask);
% end
% data_filtered = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
% clear data
% mask = logical(mask);
% data = reshape(data_filtered,[],size(data_filtered,3));
% data = data(mask,:);
% gs = sum(data,1)./size(nonzeros(mask),1);
% clear data;
% %gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,fs);
% gs_matrix = zeros(size(data_filtered,1),size(data_filtered,2),size(data_filtered,3));
% for ii = 1:size(data_filtered,1)
%     for jj = 1:size(data_filtered,2)
%         gs_matrix(ii,jj,:) = gs;
%     end
% end
% [lagTime_GS,lagAmp_GS,~] = mouse.conn.dotLag(...
%     data_filtered,gs_matrix,edgeLen,validRange,corrThr,true,true);
% lagTime_GS = lagTime_GS./fs;
% end


