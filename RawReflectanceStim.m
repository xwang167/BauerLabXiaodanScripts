% load('L:\RGECO\190627\190627-R5M2286-stim1.mat', 'rawdata')
% load('L:\RGECO\190627\190627-R5M2286-stim1_processed.mat','xform_jrgeco1aCorr')
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,10);
% xform_jrgeco1aCorr = mean(xform_jrgeco1aCorr,4);
% peakMap_ROI = mean(xform_jrgeco1aCorr(:,:,126:250),3);
% figure
% colormap jet
imagesc(peakMap_ROI,[-0.02,0.02])
axis image off

[X,Y] = meshgrid(1:128,1:128);

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_ROI(ROI),99);
temp = double(peakMap_ROI).*double(ROI);
ROI = temp>max_ROI*0.75;
hold on
ROI_contour = bwperim(ROI);
contour( ROI_contour)
ibi = reshape(ROI,1,[]);

 red = squeeze(rawdata(:,:,4,26:end));
green = squeeze(rawdata(:,:,3,26:end));
red = reshape(red,128,128,750,10);
green = reshape(green,128,128,750,10);
red = mean(red,4);
green = mean(green,4);

red = reshape(red,128*128,[]);
red = mean(red(ibi,:),1);
green = reshape(green,128*128,[]);
green = mean(green(ibi,:),1);

figure
plot((1:750)/25,red,'r')
hold on
plot((1:750)/25,green,'g')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
legend('red reflectance','green reflectance')