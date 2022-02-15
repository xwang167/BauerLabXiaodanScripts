load('X:\XW\FilteredSpectra\FilteredEmission\WT\cat\210830--W30M3-W30M1-W30M2-W31M1-W31M2-stim_processed_mice.mat', 'xform_jrgeco1aCorr_mice_NoGSR')
%load('X:\XW\FilteredSpectra\FilteredEmission\WT\cat\210830--W30M3-W30M1-W30M2-W31M1-W31M2-stim_processed_mice.mat', 'xform_FADCorr_mice_NoGSR')
% peakMap = squeeze(mean(xform_FADCorr_mice_NoGSR(:,:,126:250),3));
% imagesc(peakMap,[-0.015 0.015]);
% [x1,y1] = ginput(1);
% [x2,y2] = ginput(1);
% [X,Y] = meshgrid(1:128,1:128);
% radius = sqrt((x1-x2)^2+(y1-y2)^2);
% ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% max_ROI = prctile(peakMap(ROI),99);
% temp = double(peakMap).*double(ROI);
% ROI = temp>max_ROI*0.95;
% hold on
% contour(ROI,'k')
% h = colorbar;
% colormap jet
% iROI = reshape(ROI,1,[]);
% xform_jrgeco1aCorr_mice_NoGSR = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
% 
% jrgeco1aCorr_timetrace = mean(xform_jrgeco1aCorr_mice_NoGSR(iROI,:),1);
% jrgeco1aCorr_timetrace = jrgeco1aCorr_timetrace-mean(jrgeco1aCorr_timetrace(1:125));
% mean_evoke_Corr_cam2 = mean(jrgeco1aCorr_timetrace(126:250));
% figure
% plot((1:750)/250,jrgeco1aCorr_timetrace,'r-')
% load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'xform_jrgeco1aCorr_mice_NoGSR')
% load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'ROI_NoGSR')
% iROI = reshape(ROI_NoGSR,1,[]);
% xform_jrgeco1aCorr_mice_NoGSR = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
% 
% jrgeco1aCorr_timetrace = mean(xform_jrgeco1aCorr_mice_NoGSR(iROI,:),1);
% jrgeco1aCorr_timetrace = jrgeco1aCorr_timetrace-mean(jrgeco1aCorr_timetrace(1:125));
% mean_evoke_Corr_rgeco = mean(jrgeco1aCorr_timetrace(126:250));
% hold on
% plot((1:750)/250,jrgeco1aCorr_timetrace,'m-')

figure
load('X:\XW\Paper\WT\RGECO Emission\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-stim_processed_mice.mat', 'xform_jrgeco1a_mice_NoGSR','ROI')
iROI = reshape(ROI,1,[]);
xform_jrgeco1a_mice_NoGSR_WT = reshape(xform_jrgeco1a_mice_NoGSR,128*128,[]);
jrgeco1a_timetrace_WT= mean(xform_jrgeco1a_mice_NoGSR_WT(iROI,:),1);
jrgeco1a_timetrace_WT = jrgeco1a_timetrace_WT-mean(jrgeco1a_timetrace_WT(1:125));
mean_evoke_WT = mean(jrgeco1a_timetrace_WT(126:250));
hold on
plot((1:750)/25,jrgeco1a_timetrace_WT,'k-')


load('X:\XW\Paper\WT\RGECO Emission\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-stim_processed_mice','xform_red_mice_NoGSR')
xform_red_mice_NoGSR_WT = reshape(xform_red_mice_NoGSR,128*128,[]);
red_timetrace = mean(xform_red_mice_NoGSR_WT(iROI,:),1);
red_timetrace = red_timetrace-mean(red_timetrace(1:125));
mean_evoke_WT = mean(red_timetrace(126:250));
hold on
plot((1:750)/25,red_timetrace,'r-')




load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'xform_jrgeco1a_mice_NoGSR','ROI_GSR')
iROI = reshape(ROI_GSR,1,[]);
xform_jrgeco1a_mice_NoGSR_rgeco = reshape(xform_jrgeco1a_mice_NoGSR,128*128,[]);
jrgeco1a_timetrace = mean(xform_jrgeco1a_mice_NoGSR_rgeco(iROI,:),1);
jrgeco1a_timetrace = jrgeco1a_timetrace-mean(jrgeco1a_timetrace(1:125));
mean_evoke_rgeco = mean(jrgeco1a_timetrace(126:250));
hold on
plot((1:750)/25,jrgeco1a_timetrace,'m-')

legend('WT Camera 2','WT 625nm reflectance','RGECO','location','northeast')

xlabel('Time(s)')
ylabel('\DeltaF/F or \DeltaR/R')



a1 = jrgeco1a_timetrace_WT(130)/jrgeco1a_timetrace(130);
a2 = jrgeco1a_timetrace_WT(137)/jrgeco1a_timetrace(137);
a3 = jrgeco1a_timetrace_WT(146)/jrgeco1a_timetrace(146);

a4 = jrgeco1a_timetrace_WT(154)/jrgeco1a_timetrace(154);
a5 = jrgeco1a_timetrace_WT(163)/jrgeco1a_timetrace(163);
a6 = jrgeco1a_timetrace_WT(171)/jrgeco1a_timetrace(171);

a7 = jrgeco1a_timetrace_WT(180)/jrgeco1a_timetrace(180);
a8 = jrgeco1a_timetrace_WT(188)/jrgeco1a_timetrace(188);
a9 = jrgeco1a_timetrace_WT(196)/jrgeco1a_timetrace(196);

a10 = jrgeco1a_timetrace_WT(205)/jrgeco1a_timetrace(205);
a11 = jrgeco1a_timetrace_WT(213)/jrgeco1a_timetrace(213);
a12 = jrgeco1a_timetrace_WT(221)/jrgeco1a_timetrace(221);


a13 = jrgeco1a_timetrace_WT(230)/jrgeco1a_timetrace(230);
a14 = jrgeco1a_timetrace_WT(238)/jrgeco1a_timetrace(238);
a15 = jrgeco1a_timetrace_WT(246)/jrgeco1a_timetrace(246);


RGECO = mean([jrgeco1a_timetrace(130) jrgeco1a_timetrace(137) jrgeco1a_timetrace(146) jrgeco1a_timetrace(154) jrgeco1a_timetrace(163) jrgeco1a_timetrace(171) jrgeco1a_timetrace(180) jrgeco1a_timetrace(188) jrgeco1a_timetrace(196) jrgeco1a_timetrace(205) jrgeco1a_timetrace(213) jrgeco1a_timetrace(221) jrgeco1a_timetrace(230) jrgeco1a_timetrace(238) jrgeco1a_timetrace(246)]);
WT = mean([jrgeco1a_timetrace_WT(130) jrgeco1a_timetrace_WT(137) jrgeco1a_timetrace_WT(146) jrgeco1a_timetrace_WT(154) jrgeco1a_timetrace_WT(163) jrgeco1a_timetrace_WT(171) jrgeco1a_timetrace_WT(180) jrgeco1a_timetrace_WT(188) jrgeco1a_timetrace_WT(196) jrgeco1a_timetrace_WT(205) jrgeco1a_timetrace_WT(213) jrgeco1a_timetrace_WT(221) jrgeco1a_timetrace_WT(230) jrgeco1a_timetrace_WT(238) jrgeco1a_timetrace_WT(246)]);
