load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_jrgeco1aCorr_mice_NoGSR', 'xform_datahb_mice_NoGSR', 'xform_isbrain_mice', 'ROI_NoGSR')
%
% %filter
% 
% calcium_filter = filterData(xform_jrgeco1aCorr_mice_NoGSR,0.02,5,25,xform_isbrain_mice);
% 
% HbT =  squeeze(xform_datahb_mice_NoGSR(:,:,1,:) + xform_datahb_mice_NoGSR(:,:,2,:));
% HbT_filter = filterData(HbT,0.02,5,25,xform_isbrain_mice);
% 
% HbO =  squeeze(xform_datahb_mice_NoGSR(:,:,1,:));
% HbO_filter = filterData(HbO,0.03,5,25,xform_isbrain_mice);
% 
% HbR =  squeeze(xform_datahb_mice_NoGSR(:,:,2,:));
% HbR_filter = filterData(HbR,0.02,5,25,xform_isbrain_mice);
% 
% %downsample
% calcium_resample = resample(calcium_filter,10,25,'Dimension',3);
% HbT_resample = resample(HbT_filter,10,25,'Dimension',3);
% HbO_resample = resample(HbO_filter,10,25,'Dimension',3);
% HbR_resample = resample(HbR_filter,10,25,'Dimension',3);
% 
% % reshape to 128*128,frames
% calcium_resample = reshape(calcium_resample,128*128,[]);
% HbT_resample = reshape(HbT_resample,128*128,[]);
% HbO_resample = reshape(HbO_resample,128*128,[]);
% HbR_resample = reshape(HbR_resample,128*128,[]);
% 
% % Time trace of activation region
% calcium_ROI = mean(calcium_resample(ROI_NoGSR(:),:),1)*100;
% HbT_ROI = mean(HbT_resample(ROI_NoGSR(:),:),1)*10^6;
% HbO_ROI = mean(HbO_resample(ROI_NoGSR(:),:),1)*10^6;
% HbR_ROI = mean(HbR_resample(ROI_NoGSR(:),:),1)*10^6;
% 
% % baseline subtract
% calcium_baselineSub = calcium_ROI - mean(calcium_ROI(1:50));
% HbT_baselineSub = HbT_ROI - mean(HbT_ROI(1:50));
% HbO_baselineSub = HbO_ROI - mean(HbO_ROI(1:50));
% HbR_baselineSub = HbR_ROI - mean(HbR_ROI(1:50));
% 
% figure
% plot((1:300)/10,calcium_baselineSub,'m-')
% hold on
% plot((1:300)/10,HbT_baselineSub,'k-')
% hold on
% plot((1:300)/10,HbO_baselineSub,'r-')
% hold on
% plot((1:300)/10,HbR_baselineSub,'b-')
% legend('jRGECO1a','HbT','HbO','HbR')
% xlabel('Time(s)')
% ylabel('\DeltaF/F% or \Delta\muM')
% title('Filter from 0.02 to 5 Hz, resample to 10Hz')

HbT =  squeeze(xform_datahb_mice_NoGSR(:,:,1,:) + xform_datahb_mice_NoGSR(:,:,2,:));
HbO =  squeeze(xform_datahb_mice_NoGSR(:,:,1,:));
HbR =  squeeze(xform_datahb_mice_NoGSR(:,:,2,:));
clear xform_datahb_mice_NoGSR
calcium = xform_jrgeco1aCorr_mice_NoGSR;
clear xform_jrgeco1aCorr_mice_NoGSR

% reshape to 128*128,frames
HbT = reshape(HbT,128*128,[]);
HbO = reshape(HbO,128*128,[]);
HbR = reshape(HbR,128*128,[]);
calcium = reshape(calcium,128*128,[]);

% Time trace of activation region

HbT_ROI = mean(HbT(ROI_NoGSR(:),:),1)*10^6;
HbO_ROI = mean(HbO(ROI_NoGSR(:),:),1)*10^6;
HbR_ROI = mean(HbR(ROI_NoGSR(:),:),1)*10^6;
calcium_ROI = mean(calcium(ROI_NoGSR(:),:),1)*100;

% baseline subtract
calcium_baselineSub = calcium_ROI - mean(calcium_ROI(1:50));
HbT_baselineSub = HbT_ROI - mean(HbT_ROI(1:125));
HbO_baselineSub = HbO_ROI - mean(HbO_ROI(1:125));
HbR_baselineSub = HbR_ROI - mean(HbR_ROI(1:125));

figure
plot((1:750)/25,calcium_baselineSub,'m-')
hold on
plot((1:750)/25,HbT_baselineSub,'k-')
hold on
plot((1:750)/25,HbO_baselineSub,'r-')
hold on
plot((1:750)/25,HbR_baselineSub,'b-')

time_epoch=30;
t=linspace(0,time_epoch,time_epoch*25);%% force it to be 5 hz
disp('Gamma-ing')

he = HemodynamicsError(t,calcium_baselineSub(130:246),calcium_baselineSub(130:246));

fcn = @(param)he.fcn(param);

options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
[x,pixHrfParam,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[1.6,1.8,0.02],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3)); % %T, W, A
pixHemoPred = conv(calcium_baselineSub,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(calcium_baselineSub));

pixelHrf = hrfGamma(t,0.35,0.07,0.5); % %T, W, A
pixHemoPred = conv(calcium_baselineSub,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(calcium_baselineSub));
figure
plot((1:750)/25,calcium_baselineSub,'m-')
hold on
plot((1:750)/25,HbT_baselineSub,'k-')
hold on
plot((1:750)/25,pixHemoPred,'g-')

title('[T,W,A] = [0.35,0.07,0.5]')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \Delta\muM')
legend('jRGECO1a','HbT actual','HbT pred')