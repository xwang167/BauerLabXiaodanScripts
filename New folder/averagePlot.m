clear all
load('D:\ProcessedData\181031\181031-GcampM2-stim1-Affine_GSR_NewDetrend.mat')
time = 1:5039;
time = time./16.8;
xform_gcampCorrAvg = mouse.preprocess.blockAvg(gcamp6all(:,:,1,:),time,30,60);
plot(squeeze(xform_gcampCorrAvg(79,95,1,:)),'g')
xform_hbOAvg = mouse.preprocess.blockAvg(oxy,time,30,60);
hold on
plot(squeeze(xform_hbOAvg(79,95,:)),'r')
xform_gcampAvg = mouse.preprocess.blockAvg(gcamp6,time,30,60);
plot(squeeze(xform_gcampAvg(79,95,:)))
xform_hbRAvg = mouse.preprocess.blockAvg(deoxy,time,30,60);
hold on
plot(squeeze(xform_hbRAvg(79,95,:)),'b')