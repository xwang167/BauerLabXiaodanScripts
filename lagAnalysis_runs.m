close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
%
excelRows = [181 183 185 228 232 236 195 202 204 230 234 240];

runs = 1:3;

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
                
                xform_total_filtered = mouse.freq.filterData(double(xform_total),0.02,2,fs);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
                
                xform_FADCorr_filtered = mouse.freq.filterData(double(xform_FADCorr),0.02,2,fs);
                xform_jrgeco1aCorr_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.02,2,fs);
                edgeLen =3;
                tZone = 4;
                corrThr = 0.3;
                validRange = - edgeLen: round(tZone*fs);
                tLim = [0 1];
                rLim = [-1 1];
                disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
                
                %                 [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                %                     xform_total_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,false);
                %                 clear xform_total_filtered
                %                 lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                %
                %                 [lagTimeTrial_FADCalcium, lagAmpTrial_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
                %                     xform_FADCorr_filtered,xform_jrgeco1aCorr_filtered,edgeLen,validRange,corrThr, true,false);
                %                 clear xform_FADCorr_filtered xform_jrgeco1aCorr_filtered
                %                 lagTimeTrial_FADCalcium= lagTimeTrial_FADCalcium./fs;
                %
                %                 figure;
                %                 colormap jet;
                %                 subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                %                 subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium,tLim);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                %                 subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                %                 subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                %                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)))
                %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.png')));
                %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.fig')));
                %                 save(fullfile(saveDir,processedName),'lagTimeTrial_HbTCalcium', 'lagAmpTrial_HbTCalcium','lagTimeTrial_FADCalcium', 'lagAmpTrial_FADCalcium','-append');
                %                 close all
                %%functionally relvenat brain organization (lag with respect to global signal)
                ISA = [0.009 0.08];
                Delta = [0.4 4];
                validRange = -round(tZone*fs): round(tZone*fs);
                tLim_ISA = [-0.25 0.25];
                tLim_Delta = [-0.05 0.05];
                corrThr = 0.3;
                [lagTime_GS_Calcium_ISA,lagAmp_GS_Calcium_ISA] = calcLagGS(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                [lagTime_GS_FAD_ISA,lagAmp_GS_FAD_ISA] = calcLagGS(xform_FADCorr,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                [lagTime_GS_total_ISA,lagAmp_GS_total_ISA] = calcLagGS(xform_total,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                save(fullfile(saveDir,processedName),'lagTime_GS_total_ISA', 'lagAmp_GS_total_ISA','lagTime_GS_FAD_ISA', 'lagAmp_GS_FAD_ISA','lagTime_GS_Calcium_ISA','lagAmp_GS_Calcium_ISA','-append');
                
                
                figure;
                colormap jet
                subplot(2,3,1); imagesc(lagTime_GS_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,2); imagesc(lagTime_GS_FAD_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,3); imagesc(lagTime_GS_total_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,4); imagesc(lagAmp_GS_Calcium_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,5); imagesc(lagAmp_GS_FAD_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,6); imagesc(lagAmp_GS_total_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Lag with GS, ISA'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_ISA.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_ISA.fig')));
                
                
                [lagTime_GS_total_Delta,lagAmp_GS_total_Delta] = calcLagGS(xform_total,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
                [lagTime_GS_FAD_Delta,lagAmp_GS_FAD_Delta] = calcLagGS(xform_FADCorr,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
                [lagTime_GS_Calcium_Delta,lagAmp_GS_Calcium_Delta] = calcLagGS(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
                
                save(fullfile(saveDir,processedName),'lagTime_GS_total_Delta', 'lagAmp_GS_total_Delta','lagTime_GS_FAD_Delta', 'lagAmp_GS_FAD_Delta','lagTime_GS_Calcium_Delta','lagAmp_GS_Calcium_Delta','-append');
                
                
                figure;
                colormap jet
                subplot(2,3,1); imagesc(lagTime_GS_Calcium_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,2); imagesc(lagTime_GS_FAD_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,3); imagesc(lagTime_GS_total_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,4); imagesc(lagAmp_GS_Calcium_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,5); imagesc(lagAmp_GS_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,6); imagesc(lagAmp_GS_total_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Lag with GS, Delta'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_Delta.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_LagGS_Delta.fig')));
                close all
            end
            close all
        end
    end
end
%

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = [181 183 185 228 232 236];%[195 202 204 181 183 185];

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
lagTimeTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_mice = zeros(128,128,length(excelRows));
lagTimeTrial_FADCalcium_mice = zeros(128,128,length(excelRows));
lagAmpTrial_FADCalcium_mice = zeros(128,128,length(excelRows));
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
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'lagTimeTrial_HbTCalcium', 'lagAmpTrial_HbTCalcium','lagTimeTrial_FADCalcium', 'lagAmpTrial_FADCalcium')
                lagTimeTrial_HbTCalcium_mouse(:,:,n) = lagTimeTrial_HbTCalcium;
                lagAmpTrial_HbTCalcium_mouse(:,:,n) = lagAmpTrial_HbTCalcium;
                lagTimeTrial_FADCalcium_mouse(:,:,n) = lagTimeTrial_FADCalcium;
                lagAmpTrial_FADCalcium_mouse(:,:,n) = lagAmpTrial_FADCalcium;
                
            end
            close all
        end
    end
    lagTimeTrial_HbTCalcium_mouse = nanmedian(lagTimeTrial_HbTCalcium,3);
    lagAmpTrial_HbTCalcium_mouse = nanmedian(lagAmpTrial_HbTCalcium,3);
    lagTimeTrial_FADCalcium_mouse = nanmedian(lagTimeTrial_FADCalcium,3);
    lagAmpTrial_FADCalcium_mouse = nanmedian(lagAmpTrial_FADCalcium,3);
    figure;
    colormap jet;
    subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mouse,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
    subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mouse,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
    subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
    subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag.fig')));
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),'file')
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),'lagTimeTrial_HbTCalcium_mouse', 'lagAmpTrial_HbTCalcium_mouse','lagTimeTrial_FADCalcium_mouse', 'lagAmpTrial_FADCalcium_mouse','-append');
    else
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),'lagTimeTrial_HbTCalcium_mouse', 'lagAmpTrial_HbTCalcium_mouse','lagTimeTrial_FADCalcium_mouse', 'lagAmpTrial_FADCalcium_mouse','-v7.3');
        
    end
    
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),'lagTimeTrial_HbTCalcium_mouse', 'lagAmpTrial_HbTCalcium_mouse','lagTimeTrial_FADCalcium_mouse', 'lagAmpTrial_FADCalcium_mouse');
    %
    lagTimeTrial_HbTCalcium_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_mouse;
    lagAmpTrial_HbTCalcium_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_mouse;
    lagTimeTrial_FADCalcium_mice(:,:,mouseInd) = lagTimeTrial_FADCalcium_mouse;
    lagAmpTrial_FADCalcium_mice(:,:,mouseInd) = lagAmpTrial_FADCalcium_mouse;
    mouseInd = mouseInd+1;
end
lagTimeTrial_HbTCalcium_mice = nanmedian(lagTimeTrial_HbTCalcium_mice,3);
lagAmpTrial_HbTCalcium_mice = nanmedian(lagAmpTrial_HbTCalcium_mice,3);
lagTimeTrial_FADCalcium_mice = nanmedian(lagTimeTrial_FADCalcium_mice,3);
lagAmpTrial_FADCalcium_mice= nanmedian(lagAmpTrial_FADCalcium_mice,3);
figure;
colormap jet;
subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');
subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_mice,[0 0.3]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');
subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');
subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');
suptitle(strcat(recDate,'-',miceName,'-',sessionType))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag.fig')));
save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),'lagTimeTrial_HbTCalcium_mice', 'lagAmpTrial_HbTCalcium_mice','lagTimeTrial_FADCalcium_mice', 'lagAmpTrial_FADCalcium_mice');

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

function [lagTime_GS,lagAmp_GS] = calcLagGS(data,minFreq,maxFreq,fs,edgeLen,validRange,corrThr)
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
for ii = 1:length(data)
    data(:,:,ii) = data(:,:,ii).*double(mask);
end
data_filtered = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
clear data
mask = logical(mask);
data = reshape(data_filtered,[],size(data_filtered,3));
data = data(mask,:);
gs = sum(data,1)./size(nonzeros(mask),1);
clear data;
%gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,fs);
gs_matrix = zeros(size(data_filtered,1),size(data_filtered,2),size(data_filtered,3));
for ii = 1:size(data_filtered,1)
    for jj = 1:size(data_filtered,2)
        gs_matrix(ii,jj,:) = gs;
    end
end
[lagTime_GS,lagAmp_GS,~] = mouse.conn.dotLag(...
    data_filtered,gs_matrix,edgeLen,validRange,corrThr,true,false);
lagTime_GS = lagTime_GS./fs;
end