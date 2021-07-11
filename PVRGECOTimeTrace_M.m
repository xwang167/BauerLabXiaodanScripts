%load('J:\PVRGECO\cat\201130--N4M326-M-opto3-N4M330-M-opto3-N7M804-M-opto3-N8M861-M-opto3-N8M864-M-opto3-A48M343-M-opto3-stim_processed_mice.mat')
load('200916--N4M326-M-opto3-N4M330-M-opto3-N7M804-M-opto3-stim_processed_mice.mat')
%load('201130--N4M326-SS-opto3-N4M330-SS-opto3-N7M804-SS-opto3-N8M861-SS-opto3-N8M864-SS-opto3-A48M343-SS-opto3-stim_processed_mice.mat')
peakMap = mean(xform_jrgeco1aCorr_mice_GSR(:,:,140:160),3);
figure
imagesc(peakMap,[-0.006 0.006])
axis image off
colorbar
colormap jet

[X,Y] = meshgrid(1:128,1:128);

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
min_ROI = prctile(peakMap(ROI),1);
temp = double(peakMap).*double(ROI);
Motor_ROI = temp<min_ROI*0.90;
hold on
contour( Motor_ROI,'k')


[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
min_ROI = prctile(peakMap(ROI),1);
temp = double(peakMap).*double(ROI);
Motor_ROI_flip = temp<min_ROI*0.90;
hold on
contour(Motor_ROI_flip,'r')

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = double(peakMap).*double(ROI);
SS_ROI = temp>max_ROI*0.90;
hold on
contour( SS_ROI,'m')





[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = double(peakMap).*double(ROI);
SS_ROI_flip = temp>max_ROI*0.90;
hold on
contour(SS_ROI_flip,'b')

figure
t = (1:600)/20;
Motor_ROI = reshape(Motor_ROI,1,[]);
xform_jrgeco1aCorr_mice_NoGSR = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
Motor = mean(xform_jrgeco1aCorr_mice_NoGSR(Motor_ROI,:),1);
plot(t,Motor,'k')

Motor_flip = mean(xform_jrgeco1aCorr_mice_NoGSR(Motor_ROI_flip,:),1);
hold on
plot(t, Motor_flip,'r')


SS_ROI = reshape(SS_ROI,1,[]);
SS = mean(xform_jrgeco1aCorr_mice_NoGSR(SS_ROI,:),1);
hold on
plot(t,SS,'m')

SS_ROI_flip= reshape(SS_ROI_flip,1,[]);
SS_contra = mean(xform_jrgeco1aCorr_mice_NoGSR(SS_ROI_flip,:),1);
hold on
plot(t,SS_contra,'b')
legend('Motor','Motor Contralateral','SS','SS Contralateral','location','southeast')
title('NoGSR')


% figure
% t = (1:600)/20;
% Motor_ROI = reshape(Motor_ROI,1,[]);
% xform_jrgeco1aCorr_mice_GSR = reshape(xform_jrgeco1aCorr_mice_GSR,128*128,[]);
% Motor = mean(xform_jrgeco1aCorr_mice_GSR(Motor_ROI,:),1);
% plot(t,Motor,'k')
% 
% Motor_flip = mean(xform_jrgeco1aCorr_mice_GSR(Motor_ROI_flip,:),1);
% hold on
% plot(t, Motor_flip,'r')
% 
% 
% SS_ROI = reshape(SS_ROI,1,[]);
% SS = mean(xform_jrgeco1aCorr_mice_GSR(SS_ROI,:),1);
% hold on
% plot(t,SS,'m')
% 
% SS_ROI_flip= reshape(SS_ROI_flip,1,[]);
% SS_contra = mean(xform_jrgeco1aCorr_mice_GSR(SS_ROI_flip,:),1);
% hold on
% plot(t,SS_contra,'b')
% legend('Motor','Motor Contralateral','SS','SS Contralateral','location','southeast')
% title('GSR')