% clear all;close all;clc
% load('D:\RGECO\191028\191028-R6M1-awake-fc1_processed.mat', 'xform_jrgeco1aCorr')
% fs = 25;
% data1 = squeeze(xform_jrgeco1aCorr(56,111,:));
% data1 = data1';
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = leftMask+rightMask;
% mask = logical(mask);
% mask = mask(:);
% 
% origSize = size(xform_jrgeco1aCorr);
% 
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr, numel(mask),  origSize(end));
% gs = squeeze(nanmean(xform_jrgeco1aCorr(mask(:), :), 1));
% clear xform_jrgeco1aCorr
% edgeLen = 1;
% tZone = 4;
% ISA = [0.009 0.08];
% Delta = [0.4 4];
% validRange = -round(tZone*fs): round(tZone*fs);
% corrThr = 0.3;
% 
%  
%  [lagTime_noDownsample_ISA,lagAmp_noDownsample_ISA,covResult_noDownsample_ISA,sign_noDownsample_ISA,lags_noDownsample_ISA,covResult_all_noDownsample_ISA,lags_all_noDownsample_ISA,Pxx_noDownsample_ISA,hz_noDownsample_ISA] ...
%     = noDownsample(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);
% 
% 
% 
% figure
% scatter(lags_noDownsample_ISA/fs,covResult_noDownsample_ISA,70,'b','d','lineWidth',2)
% hold on;scatter(lagTime_noDownsample_ISA/fs,lagAmp_noDownsample_ISA,70,'b','d','filled')
% % hold on
% % scatter(lags_downSampleFirst_ISA/1,covResult_downSampleFirst_ISA,'filled','b','d')
% %legend('Filter First','Downsample First','Filter First Lagtime','Downsample First Lagtime','location','southeast')
% xlabel('time(s)')
% ylabel('Correlation')
% title('ISA')
% set(gca,'FontSize',14,'FontWeight','Bold')
% set(gca,'lineWidth',2)
% load('191028-R6M1-awake-fc1_processed.mat', 'lagTime_GS_total_ISA')
% 
% figure
%  imagesc(lagTime_GS_total_ISA,[-1.5,1.5])
% colormap jet
% axis image off
% X = 30:5:50;
% Y = 40*ones(1,5);
% hold on
% scatter(X,Y)
% scatter(X,Y,'filled','k')
% title('Total LagGS ISA Lag Time')
% 
% load('191028-R6M1-awake-fc1_processed.mat', 'lagAmp_GS_total_ISA')
% figure
% imagesc(lagAmp_GS_total_ISA,[-1,1])
% colormap jet
% axis image off
% X = 30:5:50;
% Y = 40*ones(1,5);
% hold on
% scatter(X,Y)
% scatter(X,Y,'filled','k')
% title('Total LagGS ISA Lag Amp')

 [lagTime_noDownsample_ISA,lagAmp_noDownsample_ISA,covResult_noDownsample_ISA,sign_noDownsample_ISA,lags_noDownsample_ISA,covResult_all_noDownsample_ISA,lags_all_noDownsample_ISA,Pxx_noDownsample_ISA,hz_noDownsample_ISA] ...
    = noDownsample(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);
load('D:\RGECO\191028\191028-R6M1-awake-fc1_processed.mat', 'xform_datahb');
load('191028-R6M1-awake-fc1_processed.mat', 'lagAmp_GS_total_ISA')
load('191028-R6M1-awake-fc1_processed.mat', 'lagTime_GS_total_ISA')
total = xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:);
clear xform_datahb
y = 53;
fs = 25;
origSize = size(total);
load('D:\OIS_Process\noVasculaturemask.mat')
X = 15:5:50;
mask = mask_new;
total1 = reshape(total, numel(mask),  origSize(end));
gs = squeeze(nanmean(total1(mask(:), :), 1));
clear total1
for x = X
data1 = squeeze(total(y,x,:));
data1 = data1';
edgeLen = 1;
tZone = 4;
ISA = [0.009 0.08];
validRange = -round(tZone*fs): round(tZone*fs);
corrThr = 0;
 
 [lagTime_noDownsample_ISA,lagAmp_noDownsample_ISA,covResult_noDownsample_ISA,sign_noDownsample_ISA,lags_noDownsample_ISA,covResult_all_noDownsample_ISA,lags_all_noDownsample_ISA,Pxx_noDownsample_ISA,hz_noDownsample_ISA] ...
    = noDownsample(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);

figure('units','normalized','outerposition',[0 0 0.6 0.6])
subplot(1,3,1);
imagesc(lagTime_GS_total_ISA,[-1.5,1.5])
colormap jet
axis image off
hold on
scatter(x,y,'filled','k')
title('Lagtime(s)')

subplot(1,3,2)
imagesc(lagAmp_GS_total_ISA,[-1,1])
colormap jet
axis image off
hold on
scatter(x,y,'filled','k')
title('Total LagGS ISA Lag Amp')
subplot(1,3,3)
scatter(lags_noDownsample_ISA/fs,covResult_noDownsample_ISA,70,'b','d','lineWidth',2)
hold on;scatter(lagTime_noDownsample_ISA/fs,lagAmp_noDownsample_ISA,70,'r','d','filled')
ylim([0,1])
xlim([-4,4])
% hold on
% scatter(lags_downSampleFirst_ISA/1,covResult_downSampleFirst_ISA,'filled','b','d')
%legend('Filter First','Downsample First','Filter First Lagtime','Downsample First Lagtime','location','southeast')
xlabel('time(s)')
ylabel('Correlation')
set(gca,'FontSize',14,'FontWeight','Bold')
set(gca,'lineWidth',2)
suptitle('Total LagGS ISA')
end



function [lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all,Pxx,hz] = noDownsample(data,gs,minFreq,maxFreq,fs,validRange,edgeLen,corrThr)
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,fs);
[Pxx,hz] = pwelch(data,[],[],[],fs);
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
    data,gs,true,true,validRange,edgeLen,corrThr);
end