%load
load('221122-R66M711-fc3-dataFluor.mat', 'xform_datafluorCorr')
load('221122-R66M711-LandmarksAndMask.mat', 'xform_isbrain')
%% 
refseeds=GetReferenceSeeds;
radius = round(0.25/10*128); % in pixels
[X,Y] = meshgrid(1:128,1:128);

timeTrace = nan(length(refseeds),length(xform_datafluorCorr));
data_isa = filterData(xform_datafluorCorr,0.01,0.08,20,xform_isbrain);
clear xform_datafluorCorr
data_isa = gsr(data_isa,xform_isbrain);
%% Biateral FC
bilatMap = nan(128,128);
for row = 1:128
    for column = 1:128
        bilatMap(row,column) = corr(squeeze(data_isa(row,column,:)),squeeze(data_isa(row,129-column,:)));
    end
end

figure
subplot(1,3,1)
imagesc(bilatMap,[-1 1])
colormap jet
axis image off
colorbar
title('Manual')

subplot(1,3,2)
load('221122-R66M711-fc3-bilateralFC-0p01-0p08.mat', 'bilatFCMap')
imagesc(bilatFCMap(:,:,4),[-1 1])
axis image off
colorbar
title('Pipeline')

subplot(1,3,3)
imagesc(bilatMap-bilatFCMap(:,:,4),[-1 1])
title('Manual-Pipeline')
axis image off
colorbar

sgtitle('Calcium, ISA')

%%
data_isa = reshape(data_isa,128*128,[]);
for seedInd = 1:length(refseeds)
    ROI= sqrt((X-refseeds(seedInd,1)).^2+(Y-refseeds(seedInd,2)).^2)<radius;
    timeTrace(seedInd,:) = mean(data_isa(ROI(:),:));
end

%% fc Seed map
seedMap = nan(1,size(data_isa,2));
for pix = 1: size(data_isa,1)
    seedMap(pix)= corr(transpose(data_isa(pix,:)),transpose(timeTrace(1,:)));
end

seedMap = reshape(seedMap,128,128);
figure
subplot(1,3,1)
imagesc(seedMap,[-1 1])
colormap jet
axis image off
colorbar
title('Manual')

subplot(1,3,2)
load('221122-R66M711-fc3-seedFC-0p01-0p08.mat', 'seedFCMap')
imagesc(seedFCMap(:,:,1,4),[-1 1])
axis image off
colorbar
title('Pipeline')

subplot(1,3,3)
imagesc(seedMap-seedFCMap(:,:,1,4),[-1 1])
title('Manual-Pipeline')
axis image off
colorbar

sgtitle('Calcium, ISA, Fr-L')
%% fc seed matrix
clear data_isa
fcMatrix = nan(length(refseeds),length(refseeds));
for ii = 1:length(refseeds)
    for jj = 1:length(refseeds)
        fcMatrix(ii,jj) = corr(transpose(timeTrace(ii,:)),transpose(timeTrace(jj,:)));
    end
end

subplot(1,3,1)
imagesc(fcMatrix,[-1 1])
colormap jet
axis image off
colorbar
title('Manual')

subplot(1,3,2)
load('221122-R66M711-fc3-seedFC-0p01-0p08.mat', 'seedFC')
imagesc(seedFC(:,:,4),[-1 1])
axis image off
colorbar
title('Pipeline')

subplot(1,3,3)
imagesc(fcMatrix-seedFC(:,:,4),[-1 1])
title('Manual-Pipeline')
axis image off
colorbar
sgtitle('Calcium, ISA')