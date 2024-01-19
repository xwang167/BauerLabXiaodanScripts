clear all;close all;clc
excelFile="X:\Paper2\Hemi_Thy1_jRGECO1a_leftGrid\Control_Hemi_Thy1_jRGECO1a_leftGrid.xlsx";
excelRows = 2:9;
catDir = "X:\Paper2\Hemi_Thy1_jRGECO1a_leftGrid\cat\";
miceName = [];
for excelRow = excelRows
     runsInfo = parseRuns_xw(excelFile,excelRow);
     runInfo = runsInfo(1);
  miceName = strcat(miceName,'-',runInfo.mouseName);
end
load(strcat(catDir,miceName(2:end),'-SeedLocation.mat'),...
    'seedLocation_mice_valid')
load('AtlasandIsbrain.mat','xform_WL')

HomoFC_valid_mice = nan(128,128,3);
numMouse = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
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
save(strcat(catDir,miceName(2:end),'-HomoFC-Calcium.mat'),'HomoFC_valid_mice')
figure
colormap jet
imagesc(HomoFC_valid_mice,[-1.4 1.4])
mask = isnan(HomoFC_valid_mice);
hold on
imagesc(xform_WL,'AlphaData',mask);
axis image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
sgtitle(strcat(miceName(2:end),'Calcium HomoFC'))
saveas(gcf,strcat(catDir,miceName(2:end),'-HomoFC-Calcium.png'))
saveas(gcf,strcat(catDir,miceName(2:end),'-HomoFC-Calcium.fig'))