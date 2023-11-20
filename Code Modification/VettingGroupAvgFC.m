excelFile="X:\CodeModification\TestNewPipeline\Database.xlsx";

Group_xform_isbrain(excelFile,2:4,"X:\CodeModification\TestNewPipeline\EastOIS1_FAD\GroupResults")
GroupAvgFC(excelFile,2:4,"X:\CodeModification\TestNewPipeline\EastOIS1_FAD\GroupResults",[0.01 0.08])
GroupAvgFC(excelFile,2:4,"X:\CodeModification\TestNewPipeline\EastOIS1_FAD\GroupResults",[0.5 4])

Group_xform_isbrain(excelFile,5:7,"X:\CodeModification\TestNewPipeline\EastOIS2_GCaMP\GroupResults")
GroupAvgFC(excelFile,5:7,"X:\CodeModification\TestNewPipeline\EastOIS2_GCaMP\GroupResults",[0.01 0.08])
GroupAvgFC(excelFile,5:7,"X:\CodeModification\TestNewPipeline\EastOIS2_GCaMP\GroupResults",[0.5 4])

Group_xform_isbrain(excelFile,8:13,"X:\CodeModification\TestNewPipeline\EastOIS2_FAD_RGECO\GroupResults")
GroupAvgFC(excelFile,8:13,"X:\CodeModification\TestNewPipeline\EastOIS2_FAD_RGECO\GroupResults",[0.01 0.08])
GroupAvgFC(excelFile,8:13,"X:\CodeModification\TestNewPipeline\EastOIS2_FAD_RGECO\GroupResults",[0.5 4])


load('221122-R66M711-fc1-dataHb.mat', 'runInfo')

load('221122-R66M709-avgFC_Delta.mat', 'bilatFCMap_mouse_avg', 'seedFCMap_mouse_avg', 'seedFC_mouse_avg')

seedFC_group(:,:,:,1) = atanh(seedFC_mouse_avg);
seedFCMap_group(:,:,:,:,1) = atanh(seedFCMap_mouse_avg);
bilatFCMap_group(:,:,:,1) = atanh(bilatFCMap_mouse_avg);


load('221122-R66M710-avgFC_Delta.mat', 'bilatFCMap_mouse_avg', 'seedFCMap_mouse_avg', 'seedFC_mouse_avg')

seedFC_group(:,:,:,2) = atanh(seedFC_mouse_avg);
seedFCMap_group(:,:,:,:,2) = atanh(seedFCMap_mouse_avg);
bilatFCMap_group(:,:,:,2) = atanh(bilatFCMap_mouse_avg);

load('221122-R66M711-avgFC_Delta.mat', 'bilatFCMap_mouse_avg', 'seedFCMap_mouse_avg', 'seedFC_mouse_avg')

seedFC_group(:,:,:,3) = atanh(seedFC_mouse_avg);
seedFCMap_group(:,:,:,:,3) = atanh(seedFCMap_mouse_avg);
bilatFCMap_group(:,:,:,3) = atanh(bilatFCMap_mouse_avg);

seedFC_group = tanh(nanmean(seedFC_group,4));
seedFCMap_group = tanh(nanmean(seedFCMap_group,5));
bilatFCMap_group = tanh(nanmean(bilatFCMap_group,4));


load('Timept1-avgFC_Delta.mat', 'bilatFCMap_group_avg', 'seedFCMap_group_avg', 'seedFC_group_avg')

%% Visualization of seedFC
figure('units','normalized','outerposition',[0 0 1 1])
for ii = 1:5
    subplot(3,5,ii)
    imagesc(seedFC_group(:,:,ii),[-1 1])
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
    imagesc(seedFC_group_avg(:,:,ii),[-1 1])
    axis image
    if ii ==1
        ylabel('Pipeline')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])

    subplot(3,5,10+ii)
    imagesc(seedFC_group(:,:,ii)-seedFC_group_avg(:,:,ii),[-1 1])
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
sgtitle('TimePoint1')

%% Visualization of bilatFCMap
figure('units','normalized','outerposition',[0 0 1 1])
for ii = 1:5
    subplot(3,5,ii)
    imagesc(bilatFCMap_group(:,:,ii),[-1 1])
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
    imagesc(bilatFCMap_group_avg(:,:,ii),[-1 1])
    axis image
    if ii ==1
        ylabel('Pipeline')
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    subplot(3,5,10+ii)
    imagesc(bilatFCMap_group(:,:,ii)-bilatFCMap_group_avg(:,:,ii),[-1 1])
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
sgtitle('TimePoint1')


%% Visualization of seedFCMap
for jj =1:5
    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_group(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('TimePoint1, Mannually calculated,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);

    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_group_avg(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('TimePoint1,Pipeline,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);

    figure('units','normalized','outerposition',[0 0 1 1])
    for ii = 1:16
        subplot(4,4,ii)
        imagesc(seedFCMap_group(:,:,ii,jj)-seedFCMap_group_avg(:,:,ii,jj),[-1 1])
        axis image off
    end
    colormap jet
    sgtitle(strcat('TimePoint1,Manual-Pipeline,',runInfo.Contrasts{jj}))
    h = subplot(4,4,16);
    originalSize = get(gca, 'Position');
    colorbar
    set(h, 'Position', originalSize);
end



