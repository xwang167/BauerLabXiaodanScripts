>> excelFile="X:\CodeModification\TestNewPipeline\Database.xlsx";
excelRows=[2:13];
MouseAvgFC(excelFile,excelRows,[0.01 0.08])
MouseAvgFC(excelFile,excelRows,[0.5 4])


seedFC_mouse = nan(16,16,5,3);
seedFCMap_mouse = nan(128,128,16,5,3);
bilatFCMap_mouse = nan(128,128,5,3);

load('221122-R66M711-fc1-dataHb.mat', 'runInfo')

load('221122-R66M711-fc1-seedFC-0p5-4.mat', 'seedFC', 'seedFCMap')
load('221122-R66M711-fc1-bilateralFC-0p5-4.mat', 'bilatFCMap')

seedFC_mouse(:,:,:,1) = atanh(seedFC);
seedFCMap_mouse(:,:,:,:,1) = atanh(seedFCMap);
bilatFCMap_mouse(:,:,:,1) = atanh(bilatFCMap);


load('221122-R66M711-fc2-seedFC-0p5-4.mat', 'seedFC', 'seedFCMap')
load('221122-R66M711-fc2-bilateralFC-0p5-4.mat', 'bilatFCMap')

seedFC_mouse(:,:,:,2) = atanh(seedFC);
seedFCMap_mouse(:,:,:,:,2) = atanh(seedFCMap);
bilatFCMap_mouse(:,:,:,2) = atanh(bilatFCMap);

load('221122-R66M711-fc3-seedFC-0p5-4.mat', 'seedFC', 'seedFCMap')
load('221122-R66M711-fc3-bilateralFC-0p5-4.mat', 'bilatFCMap')

seedFC_mouse(:,:,:,3) = atanh(seedFC);
seedFCMap_mouse(:,:,:,:,3) = atanh(seedFCMap);
bilatFCMap_mouse(:,:,:,3) = atanh(bilatFCMap);

seedFC_mouse = tanh(nanmean(seedFC_mouse,4));
seedFCMap_mouse = tanh(nanmean(seedFCMap_mouse,5));
bilatFCMap_mouse = tanh(nanmean(bilatFCMap_mouse,4));


load('221122-R66M711-avgFC_Delta.mat', 'bilatFCMap_mouse_avg', 'seedFCMap_mouse_avg', 'seedFC_mouse_avg')

% Visualization of seedFC
figure('units','normalized','outerposition',[0 0 1 1])
for ii = 1:5
    subplot(3,5,ii)
    imagesc(seedFC_mouse(:,:,ii),[-1 1])
    axis image
    title(runInfo.Contrasts{ii})
    if ii ==1
        ylabel('Manually calculated')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])

    subplot(3,5,5+ii)
    imagesc(seedFC_mouse_avg(:,:,ii),[-1 1])
    axis image
    if ii ==1
        ylabel('Pipeline')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])

    subplot(3,5,10+ii)
    imagesc(seedFC_mouse(:,:,ii)-seedFC_mouse_avg(:,:,ii),[-1 1])
    axis image
    if ii ==1
        ylabel('Manual - Pipeline')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    colormap jet
end
h = subplot(3,5,15);
originalSize = get(gca, 'Position');
colorbar
set(h, 'Position', originalSize);
sgtitle('R66M711')

% Visualization of bilatFCMap
figure('units','normalized','outerposition',[0 0 1 1])
for ii = 1:5
    subplot(3,5,ii)
    imagesc(bilatFCMap_mouse(:,:,ii),[-1 1])
    axis image
    title(runInfo.Contrasts{ii})
    if ii ==1
        ylabel('Manually calculated')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    subplot(3,5,5+ii)
    imagesc(bilatFCMap_mouse_avg(:,:,ii),[-1 1])
    axis image
    if ii ==1
        ylabel('Pipeline')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    subplot(3,5,10+ii)
    imagesc(bilatFCMap_mouse(:,:,ii)-bilatFCMap_mouse_avg(:,:,ii),[-1 1])
    axis image
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    if ii ==1
        ylabel('Manual - Pipeline')
    end
    colormap jet
end
h = subplot(3,5,15);
originalSize = get(gca, 'Position');
colorbar
set(h, 'Position', originalSize);
sgtitle('R66M711')


% Visualization of seedFCMap
for jj =1:5
    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_mouse(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('R66M711, Mannually calculated,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);

    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_mouse_avg(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('R66M711,Pipeline,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);

    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_mouse(:,:,ii,jj)-seedFCMap_mouse_avg(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('R66M711,Manual-Pipeline,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);
end

