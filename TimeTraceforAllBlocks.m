load('L:\ROIforGoodBlocks','ROI')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'xform_jrgeco1aCorr_mice_NoGSR')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat', 'xform_FADCorr_mice_NoGSR','xform_datahb_mice_NoGSR')

ibi = logical(reshape(ROI,128*128,1));
HbO_mice = reshape(xform_datahb_mice_NoGSR(:,:,1,:),128*128,750);
HbR_mice = reshape(xform_datahb_mice_NoGSR(:,:,2,:),128*128,750);
HbT_mice = HbO_mice + HbR_mice; 
FAD_mice = reshape(xform_FADCorr_mice_NoGSR,128*128,750);
calcium_mice = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,750);

timetrace_HbO_mice = mean(HbO_mice(ibi,:),1);
timetrace_HbR_mice = mean(HbR_mice(ibi,:),1);
timetrace_HbT_mice = mean(HbT_mice(ibi,:),1);
timetrace_FAD_mice = mean(FAD_mice(ibi,:),1);
timetrace_calcium_mice = mean(calcium_mice(ibi,:),1);

timetrace_HbO_mice = timetrace_HbO_mice-mean(timetrace_HbO_mice(1:125));
timetrace_HbR_mice = timetrace_HbR_mice-mean(timetrace_HbR_mice(1:125));
timetrace_HbT_mice = timetrace_HbT_mice-mean(timetrace_HbT_mice(1:125));
timetrace_FAD_mice = timetrace_FAD_mice-mean(timetrace_FAD_mice(1:125));
timetrace_calcium_mice = timetrace_calcium_mice-mean(timetrace_calcium_mice(1:125));

timetrace_HbO_mice_goodBlocks = timetrace_HbO_mice_goodBlocks-mean(timetrace_HbO_mice_goodBlocks(1:125));
timetrace_HbR_mice_goodBlocks = timetrace_HbR_mice_goodBlocks-mean(timetrace_HbR_mice_goodBlocks(1:125));
timetrace_HbT_mice_goodBlocks = timetrace_HbT_mice_goodBlocks-mean(timetrace_HbT_mice_goodBlocks(1:125));
timetrace_FAD_mice_goodBlocks = timetrace_FAD_mice_goodBlocks-mean(timetrace_FAD_mice_goodBlocks(1:125));
timetrace_calcium_mice_goodBlocks = timetrace_calcium_mice_goodBlocks-mean(timetrace_calcium_mice_goodBlocks(1:125));



figure
plot((1:750)/25,timetrace_calcium_mice*100,'m-')
hold on
plot((1:750)/25,timetrace_FAD_mice*100,'g-')
hold on
yyaxis right
plot((1:750)/25,timetrace_HbO_mice*10^6,'r-')
hold on
plot((1:750)/25,timetrace_HbR_mice*10^6,'b-')
hold on
plot((1:750)/25,timetrace_HbT_mice*10^6,'k-')

hold on
yyaxis left
plot((1:750)/25,timetrace_calcium_mice_goodBlocks,'m--')
hold on
plot((1:750)/25,timetrace_FAD_mice_goodBlocks,'g--')
hold on
yyaxis right
plot((1:750)/25,timetrace_HbO_mice_goodBlocks,'r--')
hold on
plot((1:750)/25,timetrace_HbR_mice_goodBlocks,'b--')
hold on
plot((1:750)/25,timetrace_HbT_mice_goodBlocks,'k--')


figure
yyaxis left
plot((1:750)/25,timetrace_calcium_mice_goodBlocks-timetrace_calcium_mice*100,'m-')
hold on
plot((1:750)/25,timetrace_FAD_mice_goodBlocks-timetrace_FAD_mice*100,'g-')
hold on
yyaxis right
plot((1:750)/25,timetrace_HbO_mice_goodBlocks-timetrace_HbO_mice*10^6,'r-')
hold on
plot((1:750)/25,timetrace_HbR_mice_goodBlocks-timetrace_HbR_mice*10^6,'b-')
hold on
plot((1:750)/25,timetrace_HbT_mice_goodBlocks-timetrace_HbT_mice*10^6,'k-')



