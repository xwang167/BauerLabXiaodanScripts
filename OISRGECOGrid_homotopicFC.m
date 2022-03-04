clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
    'seedLocation_mice_valid')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')

HomoFC_valid_mice = nan(128,128,3);
numMouse = 1;
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),...
        'gridEvokeTimeTrace_jRGECO1a_valid_L','gridEvokeTimeTrace_jRGECO1a_valid_R')
    HomoFC_valid= nan(128,128);
    for ii = 1:79
        x1 = seedLocation_mice_valid(2,ii);
        y1 = seedLocation_mice_valid(1,ii);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        HomoFC_valid(ROI) = corr(gridEvokeTimeTrace_jRGECO1a_valid_L(:,ii),...           
            gridEvokeTimeTrace_jRGECO1a_valid_R(:,ii));
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-homoFC-Calcium.mat'),...
        'HomoFC_valid')
    HomoFC_valid_mice(:,:,numMouse) = atanh(HomoFC_valid);
    numMouse = numMouse + 1;
    figure
    colormap jet
    imagesc(HomoFC_valid,[-1 1])
    mask = isnan(HomoFC_valid);
    hold on
    imagesc(xform_WL,'AlphaData',mask);
    axis image off
    h = colorbar;
    ylabel(h, 'r','fontsize',10,'FontWeight','bold')
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
    title([runInfo.mouseName,'-HomoFC-Calcium'])
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-HomoFC-Calcium.png'))
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-HomoFC-Calcium.fig'))
    close all
end

HomoFC_valid_mice = mean(HomoFC_valid_mice,3);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium','HomoFC_valid_mice')
figure
colormap jet
imagesc(HomoFC_valid_mice,[-1 1])
mask = isnan(HomoFC_valid_mice);
hold on
imagesc(xform_WL,'AlphaData',mask);
axis image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
suptitle('N13M309-N13M548-N13M549 Calcium HomoFC')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium.fig')