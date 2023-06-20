% Generate PeakMap
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,20);
mean_jRGECO1aCorr = mean(xform_jrgeco1aCorr,4);
peakMap = mean(mean_jRGECO1aCorr(:,:,126:250),3)-mean(mean_jRGECO1aCorr(:,:,1:125),3);
imagesc(peakMap)
% Draw ROI
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
[X,Y] = meshgrid(1:128,1:128);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = peakMap.*ROI;
ROI = temp>0.75*max_ROI;
mean_jRGECO1aCorr = reshape(mean_jRGECO1aCorr,128*128,750);

% Time trace inside of ROI
ROI_trace = mean(mean_jRGECO1aCorr(ROI(:),:));

save('X:\Paper1\ExposureTime\FullExpo.mat','ROI_trace');

figure
plot((1:750)/25,ROI_trace_HalfExpo*100,'r')
hold on
plot((1:750)/25,ROI_trace_FullExpo*100,'b')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Corrected jRGECO1a')
legend({'4.5 ms','9.0 ms'})

figure
plot((1:15000)/25,mdata_HalfExpo(2,:)*100,'r')
hold on
plot((1:15000)/25,mdata_FullExpo(2,:)*100,'b')
xlabel('Time(s)')
ylabel('Counts')
title('Raw data counts')
legend('4.5 ms','9.0 ms')