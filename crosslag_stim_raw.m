clear ;close all;clc
startInd = 2;
freqLow = 0.02;
calMax = 8;
hbMax  = 2.5;
FADMax = 1;
hrfMax = 0.02;
mrfMax = 0.002;
samplingRate = 25;
freq_new     = 250;
t_kernel = 30;
tZone = 10;
validRange = - round(tZone*freq_new) : round(tZone*freq_new);
maxValidRange = max(abs(validRange));
validInd = (min(validRange)+maxValidRange+1):(maxValidRange+1+max(validRange));


load("E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat",...
    'ROI_NoGSR','xform_jrgeco1a_mice_NoGSR', 'xform_jrgeco1aCorr_mice_NoGSR', 'xform_FAD_mice_NoGSR', 'xform_FADCorr_mice_NoGSR','xform_datahb_mice_NoGSR')

HbT = squeeze(xform_datahb_mice_NoGSR(:,:,1,:)+xform_datahb_mice_NoGSR(:,:,2,:));
clear xform_datahb_mice_NoGSR
HbT = (HbT-mean(HbT(:,:,1:125),3))*10^6;
FAD = (xform_FAD_mice_NoGSR-mean(xform_FAD_mice_NoGSR(:,:,1:125),3))*100;
FAD_corr = (xform_FADCorr_mice_NoGSR-mean(xform_FADCorr_mice_NoGSR(:,:,1:125),3))*100;
clear xform_FAD
xform_jrgeco1aCorr_mice_NoGSR = squeeze(xform_jrgeco1aCorr_mice_NoGSR);
Calcium_corr = (xform_jrgeco1aCorr_mice_NoGSR-mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,1:125),3))*100; % convert to DeltaF/F%
clear xform_jrgeco1aCorr

% Filter 0.02-2Hz, downsample to 10 Hz
% FAD     = filterData(double(FAD),    freqLow,2,samplingRate);
% Calcium = filterData(double(Calcium),freqLow,2,samplingRate);

% Reshape 
HbT          = reshape(HbT         ,128*128,[]);
FAD          = reshape(FAD         ,128*128,[]);
FAD_corr     = reshape(FAD_corr    ,128*128,[]);
Calcium_corr = reshape(Calcium_corr,128*128,[]);

% upsample to 250 Hz
HbT_resample          = resample(HbT         ,freq_new,samplingRate,'Dimension',2);
FAD_resample          = resample(FAD         ,freq_new,samplingRate,'Dimension',2);
FAD_corr_resample     = resample(FAD_corr    ,freq_new,samplingRate,'Dimension',2);
Calcium_corr_resample = resample(Calcium_corr,freq_new,samplingRate,'Dimension',2);
%% Calculate HRF and MRI
HbT_ROI          = mean(HbT_resample         (ROI_NoGSR(:),:));
FAD_ROI          = mean(FAD_resample         (ROI_NoGSR(:),:));
FAD_corr_ROI     = mean(FAD_corr_resample    (ROI_NoGSR(:),:));
Calcium_corr_ROI = mean(Calcium_corr_resample(ROI_NoGSR(:),:));


% Lag for NMC,NVC
[covResult_NMC_corrCalciumrawFAF, lags_NMC_corrCalciumrawFAF]  = xcorr(FAD_ROI,     Calcium_corr_ROI,maxValidRange,'coeff');
[covResult_NMC_corrCalciumcorrFAF,lags_NMC_corrCalciumcorrFAF] = xcorr(FAD_corr_ROI,Calcium_corr_ROI,maxValidRange,'coeff');
[covResult_NVC_corrCalcium,       lags_NVC_corrCalcium]        = xcorr(HbT_ROI,     Calcium_corr_ROI,maxValidRange,'coeff');

% vectorize cross correlation
crossLagY_NMC_corrCalciumrawFAF  = covResult_NMC_corrCalciumrawFAF (validInd);
crossLagY_NMC_corrCalciumcorrFAF = covResult_NMC_corrCalciumcorrFAF(validInd);
crossLagY_NVC_corrCalcium        = covResult_NVC_corrCalcium       (validInd);

crossLagX_NMC_corrCalciumrawFAF  = lags_NMC_corrCalciumrawFAF (validInd)/freq_new;
crossLagX_NMC_corrCalciumcorrFAF = lags_NMC_corrCalciumcorrFAF(validInd)/freq_new;
crossLagX_NVC_corrCalcium        = lags_NVC_corrCalcium       (validInd)/freq_new;


%% Visualization for cross lag for NMC
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
plot((1:t_kernel*freq_new)/freq_new,FAD_ROI,'g')
hold on
plot((1:t_kernel*freq_new)/freq_new,Calcium_corr_ROI,'m')
legend('Raw FAF','Corrected jRGECO1a')
ylim([-calMax calMax])
ylabel('\DeltaF/F%')
xlabel('Time(s)')
grid on
title('No Filter')
subplot(1,2,2)
plot(crossLagX_NMC_corrCalciumrawFAF,crossLagY_NMC_corrCalciumrawFAF,'k')
xlim([-1 4])
xlabel('Time(s)')
grid on
title("Cross Correlation between Raw FAF and Corrected Calcium")
sgtitle('Raw FAF and Corrected Calcium')


figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
plot((1:t_kernel*freq_new)/freq_new,FAD_corr_ROI,'g')
hold on
plot((1:t_kernel*freq_new)/freq_new,Calcium_corr_ROI,'m')
legend('Corrected FAF','Corrected jRGECO1a')
ylim([-calMax calMax])
ylabel('\DeltaF/F%')
xlabel('Time(s)')
grid on
title('No Filter')
subplot(1,2,2)
plot(crossLagX_NMC_corrCalciumcorrFAF,crossLagY_NMC_corrCalciumcorrFAF,'k')
xlabel('Time(s)')
grid on
title("Cross Correlation between Corrected FAF and Corrected Calcium")
sgtitle('Corrected FAF and Corrected Calcium')

figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
plot((1:t_kernel*freq_new)/freq_new,HbT_ROI,'k')
hold on
plot((1:t_kernel*freq_new)/freq_new,Calcium_corr_ROI,'m')
legend('HbT','Corrected jRGECO1a')
ylim([-calMax calMax])
ylabel('\DeltaF/F% or \Delta\muM')
xlabel('Time(s)')
grid on
title('No Filter')
subplot(1,2,2)
plot(crossLagX_NVC_corrCalcium,crossLagY_NVC_corrCalcium,'k')
xlabel('Time(s)')
grid on
title("Cross Correlation between HbT and Corrected Calcium")
sgtitle('HbT and Corrected Calcium')


figure
plot(crossLagX_NMC_corrCalciumrawFAF,crossLagY_NMC_corrCalciumrawFAF,'r')
hold on
plot(crossLagX_NMC_corrCalciumcorrFAF,crossLagY_NMC_corrCalciumcorrFAF,'b')
hold on
plot(crossLagX_NVC_corrCalcium,crossLagY_NVC_corrCalcium,'k')
grid on
legend('b/t Corrected Calcium and Raw FAF','b/t Corrected Calcium and Corrected FAF',...
    'b/t Corrected Calcium and HbT')
xlabel('Time(s)')
ylabel('Correlation')