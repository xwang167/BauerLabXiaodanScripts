clear all;close all;clc
excelRows = 2:11;
miceName = [];
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
for excelRow = excelRows
     runsInfo = parseRuns_xw(excelFile,excelRow);
     runInfo = runsInfo(1);
  miceName = strcat(miceName,'-',runInfo.mouseName);
end

excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),...
    'seedLocation_mice_valid_sorted_FOV')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix.mat'),...
     'ECMatrix_mice_valid_sorted_LR_FOV')

HomoFC_valid_mice_FOV = nan(128,128);

    for ii = 1:98
        x1 = seedLocation_mice_valid_sorted_FOV(2,ii);
        y1 = seedLocation_mice_valid_sorted_FOV(1,ii);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        HomoFC_valid_mice_FOV(ROI) = ECMatrix_mice_valid_sorted_LR_FOV(ii,ii+98);
    end

save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-HomoFC-Calcium'),'HomoFC_valid_mice_FOV')
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
sgtitle([miceName(2:end) 'Calcium HomoFC'])
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-HomoFC-Calcium-FOV.png'))
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-HomoFC-Calcium-FOV.fig'))