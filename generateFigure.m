% Generate peak map of GSR data, time trace of non GSR data
function [pix_calcium, pix_FAD, pix_HbT,calcium_dynamics,FAD_dynamics,HbT_dynamics] = ...
    generateFigure(data_gsr,data_nogsr,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain_intersect,condition)
% based on block average, range around FWHM
peakMap_calcium = squeeze(mean(data_gsr(:,:,calciumStart:calciumEnd,4),3));
peakMap_FAD = squeeze(mean(data_gsr(:,:,FADStart:FADEnd,5),3));
peakMap_HbT = squeeze(mean(data_gsr(:,:,HbTStart:HbTEnd,3),3));

figure('units','normalized','outerposition',[0 0 1 1])
ax1 = subplot(2,3,1);
imagesc(peakMap_calcium,'AlphaData',xform_isbrain_intersect)
clim([-1.2 1.2])
colormap(ax1,brewermap(256, 'RdPu'));
colorbar
axis image off


ax2 = subplot(2,3,2);
imagesc(peakMap_FAD,'AlphaData',xform_isbrain_intersect)
clim([-0.3 0.3])
colormap(ax2,brewermap(256, 'Greens'));
colorbar
axis image off


ax3 = subplot(2,3,3);
imagesc(peakMap_HbT,'AlphaData',xform_isbrain_intersect)
clim([-1 1])
colormap(ax3,brewermap(256, 'Greys'));
colorbar
axis image off

sgtitle(condition,'FontWeight','Bold')

% Click on the centroid for calcium
[x,y,~] = clicksubplot;
subplot(231)
hold on
scatter(x,y,'filled','b')

subplot(232)
hold on
scatter(x,y,'filled','b')

subplot(233)
hold on
scatter(x,y,'filled','b')

% circle with radius = 1 mm, same centroid from clicking on calcium       
radius = 128/10;
[X,Y] = meshgrid(1:128,1:128);
ROI = sqrt((X-x).^2+(Y-y).^2)<radius;

subplot(231)
hold on
contour(ROI,'b')

subplot(232)
hold on
contour(ROI,'b')

subplot(233)
hold on
contour(ROI,'b')

% calcium top 50%
max_ROI_calcium = max(peakMap_calcium(ROI));
temp = peakMap_calcium.*ROI;
ROI_calcium = temp>0.50*max_ROI_calcium;

% since there might be multiple discontinous regions, find the bigger region
CC= bwconncomp(ROI_calcium);
% number of different connected regions
numRegions = length(CC.PixelIdxList);
numPix = nan(1,numRegions);
for ii = 1: numRegions
    numPix(ii) = length(CC.PixelIdxList{ii});
end
[~,I] = max(numPix);
pix_calcium = length(CC.PixelIdxList{I});
biggerRegion_calcium = zeros(1,128*128);
biggerRegion_calcium(CC.PixelIdxList{I}) = 1;
biggerRegion_calcium = logical(biggerRegion_calcium);
biggerRegion_calcium = reshape(biggerRegion_calcium,128,128);
subplot(231)
hold on
contour(biggerRegion_calcium,'r')
title(strcat('Calcium, Area =',num2str(pix_calcium),'pix'),'Color','m')


% FAD top 50%
max_ROI_FAD = max(peakMap_FAD(ROI));
temp = peakMap_FAD.*ROI;
ROI_FAD = temp>0.50*max_ROI_FAD;

% since there might be multiple discontinous regions, find the bigger region
CC= bwconncomp(ROI_FAD);
% number of different connected regions
numRegions = length(CC.PixelIdxList);
numPix = nan(1,numRegions);
for ii = 1: numRegions
    numPix(ii) = length(CC.PixelIdxList{ii});
end
[~,I] = max(numPix);
pix_FAD = length(CC.PixelIdxList{I});
biggerRegion_FAD = zeros(1,128*128);
biggerRegion_FAD(CC.PixelIdxList{I}) = 1;
biggerRegion_FAD = logical(biggerRegion_FAD);
biggerRegion_FAD = reshape(biggerRegion_FAD,128,128);
subplot(232)
hold on
contour(biggerRegion_FAD,'r')
title(strcat('FAD, Area =',num2str(pix_FAD),'pix'),'Color','g')

% HbT top 50%
max_ROI_HbT = max(peakMap_HbT(ROI));
temp = peakMap_HbT.*ROI;
ROI_HbT = temp>0.50*max_ROI_HbT;

% since there might be multiple discontinous regions, find the bigger region
CC= bwconncomp(ROI_HbT);
% number of different connected regions
numRegions = length(CC.PixelIdxList);
numPix = nan(1,numRegions);
for ii = 1: numRegions
    numPix(ii) = length(CC.PixelIdxList{ii});
end
[~,I] = max(numPix);
pix_HbT = length(CC.PixelIdxList{I});
biggerRegion_HbT = zeros(1,128*128);
biggerRegion_HbT(CC.PixelIdxList{I}) = 1;
biggerRegion_HbT = logical(biggerRegion_HbT);
biggerRegion_HbT= reshape(biggerRegion_HbT,128,128);
subplot(233)
hold on
contour(biggerRegion_HbT,'r')
title(strcat('HbT, Area =',num2str(pix_HbT),'pix'),'Color','k')

% plot dynamics
% Movie for each contrast without GSR
calcium = reshape(data_nogsr(:,:,:,4),128*128,[]);
FAD = reshape(data_nogsr(:,:,:,5),128*128,[]);
HbT = reshape(data_nogsr(:,:,:,3),128*128,[]);

% reshape
biggerRegion_calcium = reshape(biggerRegion_calcium,1,[]);
biggerRegion_FAD = reshape(biggerRegion_FAD,1,[]);
biggerRegion_HbT = reshape(biggerRegion_HbT,1,[]);

% dynamics
calcium_dynamics = mean(calcium(biggerRegion_calcium,:));
FAD_dynamics = mean(FAD(biggerRegion_FAD,:));
HbT_dynamics = mean(HbT(biggerRegion_HbT,:));

subplot(2,3,4)
plot(calcium_dynamics,'m')
xticks([0,50,60,150,200])
xticklabels({'-5','0','1','10','15'});
xlim([0 200])
xline(calciumStart)
xline(calciumEnd)
xlabel('Time(s)')
ylabel('\DeltaF/F%')

subplot(2,3,5)
plot(FAD_dynamics,'g')
xticks([0,50,60,150,200])
xticklabels({'-5','0','1','10','15'});
xlim([0 200])
xline(FADStart)
xline(FADEnd)
xlabel('Time(s)')
ylabel('\DeltaF/F%')

subplot(2,3,6)
plot(HbT_dynamics,'k')
xticks([0,50,60,150,200])
xticklabels({'-5','0','1','10','15'});
xlim([0 200])
xline(HbTStart)
xline(HbTEnd)
xlabel('Time(s)')
ylabel('\Delta\muM')
end