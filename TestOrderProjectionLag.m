clear all;close all;clc
load('J:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_jrgeco1aCorr')
fs = 25;
data1 = squeeze(xform_jrgeco1aCorr(41,46,:));
data1 = data1';
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
mask = logical(mask);
mask = mask(:);

origSize = size(xform_jrgeco1aCorr);

xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr, numel(mask),  origSize(end));
gs = squeeze(nanmean(xform_jrgeco1aCorr(mask(:), :), 1));
clear xform_jrgeco1aCorr
edgeLen =3;
tZone = 4;
ISA = [0.009 0.08];
Delta = [0.4 4];
validRange = -round(tZone*fs): round(tZone*fs);
corrThr = 0.3;

% 
[lagTime_filterFirst_ISA,lagAmp_filterFirst_ISA,covResult_filterFirst_ISA,sign_filterFirst_ISA,lags_filterFirst_ISA,covResult_all_filterFirst_ISA,lags_all_filterFirst_ISA,Pxx_filterFirst_ISA,hz_filterFirst_ISA] ...
    = filterFirst(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);
[lagTime_filterFirst_Delta,lagAmp_filterFirst_Delta,covResult_filterFirst_Delta,sign_filterFirst_Delta,lags_filterFirst_Delta,covResult_all_filterFirst_Delta,lags_all_filterFirst_Delta,Pxx_filterFirst_Delta,hz_filterFirst_Delta] ...
    = filterFirst(data1,gs,Delta(1),Delta(2),fs,validRange,edgeLen,corrThr);

[lagTime_downSampleFirst_ISA,lagAmp_downSampleFirst_ISA,covResult_downSampleFirst_ISA,sign_downSampleFirst_ISA,lags_downSampleFirst_ISA,covResult_all_downSampleFirst_ISA,lags_all_downSampleFirst_ISA,Pxx_downSampleFirst_ISA,hz_downSampleFirst_ISA] ...
    = downSampleFirst(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);
 [lagTime_downSampleFirst_Delta,lagAmp_downSampleFirst_Delta,covResult_downSampleFirst_Delta,sign_downSampleFirst_Delta,lags_downSampleFirst_Delta,covResult_all_downSampleFirst_Delta,lags_all_downSampleFirst_Delta,Pxx_downSampleFirst_Delta,hz_downSampleFirst_Delta] ...
     = downSampleFirst(data1,gs,Delta(1),Delta(2),fs,validRange,edgeLen,corrThr);
 
%  [lagTime_noDownsample_ISA,lagAmp_noDownsample_ISA,covResult_noDownsample_ISA,sign_noDownsample_ISA,lags_noDownsample_ISA,covResult_all_noDownsample_ISA,lags_all_noDownsample_ISA,Pxx_noDownsample_ISA,hz_noDownsample_ISA] ...
%     = noDownsample(data1,gs,ISA(1),ISA(2),fs,validRange,edgeLen,corrThr);
% [lagTime_noDownsample_Delta,lagAmp_noDownsample_Delta,covResult_noDownsample_Delta,sign_noDownsample_Delta,lags_noDownsample_Delta,covResult_all_noDownsample_Delta,lags_all_noDownsample_Delta,Pxx_noDownsample_Delta,hz_noDownsample_Delta] ...
%     = noDownsample(data1,gs,Delta(1),Delta(2),fs,validRange,edgeLen,corrThr);



figure
scatter(lags_all_filterFirst_Delta/10,covResult_all_filterFirst_Delta,100,'r','o','lineWidth',2)
% hold on
hold on;scatter(lagTime_filterFirst_Delta/10,lagAmp_filterFirst_Delta,100,'r','o','filled')
% scatter(lags_filterFirst_Delta/10,covResult_filterFirst_Delta,'filled','r','o')
hold on
scatter(lags_downSampleFirst_Delta/10,covResult_downSampleFirst_Delta,70,'b','d','lineWidth',2)
% hold on
% scatter(lags_downSampleFirst_Delta/10,covResult_downSampleFirst_Delta,'filled','b','d')
hold on;scatter(lagTime_downSampleFirst_Delta/10,lagAmp_downSampleFirst_Delta,70,'b','d','filled')

%legend('Filter First','Downsample First','Filter First Lagtime','Downsample First Lagtime')
xlabel('time(s)')
ylabel('Correlation')
title('Delta')
set(gca,'FontSize',14,'FontWeight','Bold')
figure
scatter(lags_all_filterFirst_ISA/1,covResult_all_filterFirst_ISA,100,'r','o','lineWidth',2)
hold on;scatter(lagTime_filterFirst_ISA/1,lagAmp_filterFirst_ISA,100,'r','o','filled')
% hold on
% scatter(lags_filterFirst_ISA/1,covResult_filterFirst_ISA,'filled','r','o')
hold on
scatter(lags_downSampleFirst_ISA/1,covResult_downSampleFirst_ISA,70,'b','d','lineWidth',2)
hold on;scatter(lagTime_downSampleFirst_ISA/1,lagAmp_downSampleFirst_ISA,70,'b','d','filled')
% hold on
% scatter(lags_downSampleFirst_ISA/1,covResult_downSampleFirst_ISA,'filled','b','d')
%legend('Filter First','Downsample First','Filter First Lagtime','Downsample First Lagtime','location','southeast')
xlabel('time(s)')
ylabel('Correlation')
title('ISA')
set(gca,'FontSize',14,'FontWeight','Bold')
set(gca,'lineWidth',2)


% figure
% subplot(2,1,1)
% plot(hz_filterFirst_ISA,Pxx_filterFirst_ISA,'r')
% hold on
% plot(hz_downSampleFirst_ISA,Pxx_downSampleFirst_ISA,'b')
% legend('Filter First','Downsample First')
% xlabel('Frequency(Hz)')
% ylabel('Pxx')
% set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(2,1,2)
% plot(hz_downSampleFirst_ISA,Pxx_filterFirst_ISA./Pxx_downSampleFirst_ISA)
% xlabel('Frequency(Hz)')
% ylabel('filterFirst/downSampleFirst')
% 
% set(gca,'FontSize',14,'FontWeight','Bold')
% suptitle('ISA')
% figure
% subplot(2,1,1)
% plot(hz_filterFirst_Delta,Pxx_filterFirst_Delta,'r')
% hold on
% plot(hz_downSampleFirst_Delta,Pxx_downSampleFirst_Delta,'b')
% legend('Filter First','Downsample First')
% xlabel('Frequency(Hz)')
% ylabel('Pxx')
% set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(2,1,2)
% plot(hz_downSampleFirst_Delta,Pxx_filterFirst_Delta./Pxx_downSampleFirst_Delta)
% xlabel('Frequency(Hz)')
% ylabel('filterFirst/downSampleFirst')
% ylim([0,2])
% set(gca,'FontSize',14,'FontWeight','Bold')
% suptitle('Delta')
function [lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all,Pxx,hz] = filterFirst(data,gs,minFreq,maxFreq,fs,validRange,edgeLen,corrThr)
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,fs);
if maxFreq == 4
    outFreq = 10;
else
    outFreq = 1;
end
data = resampledata(data,fs,outFreq,10^-5);
gs = resampledata(gs,fs,outFreq,10^-5);
[Pxx,hz] = pwelch(data,[],[],[],outFreq);
validRange = validRange*outFreq/fs;
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
    data,gs,true,true,validRange,edgeLen,corrThr);
end

function [lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all,Pxx,hz] = downSampleFirst(data,gs,minFreq,maxFreq,fs,validRange,edgeLen,corrThr)
if maxFreq == 4
    outFreq = 10;
else
    outFreq = 1;
end
data = resampledata(data,fs,outFreq,10^-5);
gs = resampledata(gs,fs,outFreq,10^-5);

data = mouse.freq.filterData(double(data),minFreq,maxFreq,outFreq);
gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,outFreq);
[Pxx,hz] = pwelch(data,[],[],[],outFreq);
validRange = validRange*outFreq/fs;
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
    data,gs,true,true,validRange,edgeLen,corrThr);
end

function [lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all,Pxx,hz] = noDownsample(data,gs,minFreq,maxFreq,fs,validRange,edgeLen,corrThr)
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
gs = mouse.freq.filterData(double(gs),minFreq,maxFreq,fs);
[Pxx,hz] = pwelch(data,[],[],[],fs);
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
    data,gs,true,true,validRange,edgeLen,corrThr);
end