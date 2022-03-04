clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
    'seedLocation_mice_valid_sorted_FOV')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
     'ECMatrix_mice_valid_sorted_LR_FOV')

HomoFC_valid_mice_FOV = nan(128,128);

    for ii = 1:105
        x1 = seedLocation_mice_valid_sorted_FOV(2,ii);
        y1 = seedLocation_mice_valid_sorted_FOV(1,ii);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        HomoFC_valid_mice_FOV(ROI) = ECMatrix_mice_valid_sorted_LR_FOV(ii,ii+105);
    end

save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium','HomoFC_valid_mice_FOV','-append')
figure
colormap jet
imagesc(HomoFC_valid_mice_FOV,[-1.4 1.4])
mask = isnan(HomoFC_valid_mice_FOV);
hold on
imagesc(xform_WL,'AlphaData',logical(mask));
axis image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
suptitle('N13M309-N13M548-N13M549 Calcium HomoFC')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium-FOV.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium-FOV.fig')