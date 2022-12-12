%clear; close all; clc;
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = strcat(miceName,'-',runInfo.mouseName);
end


load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'));
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'));

%% get seedmap v2
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\AtlasandIsbrain.mat")
for ii = 1:160
    if logical(~isnan(seedLocation_mice_FOV(1,ii)) && ~isnan(seedLocation_mice_FOV(2,ii)))
        if AtlasSeedsFilled(round(seedLocation_mice_FOV(1,ii)),round(seedLocation_mice_FOV(2,ii)))==0
            seedLocation_mice_FOV(1,ii) = nan;
            seedLocation_mice_FOV(2,ii) = nan;
        end
    end
end

seedLocation_mice_FOV(isnan(seedLocation_mice_FOV)) = 0;
seedmapLocsOG = round(seedLocation_mice_FOV);

inhibition = nan(101,1);
jj = 1;
for ii = 1:160
    if seedmapLocsOG(1,ii) ~= 0 && seedmapLocsOG(2,ii) ~= 0
        x1 = seedmapLocsOG(2,ii);
        y1 = seedmapLocsOG(1,ii);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = reshape(ROI,1,[]);
        inhibitionMap_Calcium_NoGSR_mice = reshape(inhibitionMap_Calcium_NoGSR_mice,128*128,[]);
        inhibition(jj) = nanmedian(inhibitionMap_Calcium_NoGSR_mice(ROI,ii));
        jj = jj+1;
    end
end

goodseedsloc = zeros(2,16*8);

spacing = 7;
ii = 1;
for i=1:8
    for j=1:16
        if seedmapLocsOG(1,ii) ~= 0 && seedmapLocsOG(2,ii) ~= 0
            goodseedsloc(1,ii) = round((102+3*(spacing-1))-(j-1)*(spacing-1));%seedmapLocsSorted(1,kk);%108-(j-1)*6;
            goodseedsloc(2,ii) = round(56-(i-1)*spacing);%seedmapLocsSorted(2,kk);%56-(i-1)*6;
            disp([num2str(goodseedsloc(1,ii)) ', ' num2str(goodseedsloc(2,ii))])
        end
        ii = ii + 1;
    end
end

figure;
brainMap = nan(128,128);
seedmapLocs = goodseedsloc;
pitch = 2;
jj = 1;
for i=1:length(seedmapLocs)
    if seedmapLocs(1,i) ~= 0 && seedmapLocs(2,i) ~= 0
        brainMap(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = inhibition(jj);
        jj = jj + 1;
    end
end


subplot(121)
imagesc(brainMap,[-1.4 1.4]);
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')

subplot(122)
brainMapOG = nan(128,128);
seedmapLocs = seedmapLocsOG;
pitch = 2;
jj = 1;
for i=1:length(seedmapLocs)
    if seedmapLocs(1,i) ~= 0 && seedmapLocs(2,i) ~= 0
        brainMapOG(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = inhibition(jj);
        jj = jj + 1;
    end
end
imagesc(brainMapOG)
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')


figure;
subplot(121)
colormap jet
imagesc(xform_WL)
hold on
brainMapAD = brainMap;
brainMapAD(isnan(brainMap)) = 0;
brainMapAD(~isnan(brainMap)) = 1;
imagesc(brainMap, "AlphaData", brainMapAD,[-1.5 1.5]);
axis square image off
h = colorbar;
ylabel(h, 'Calcium(\DeltaF/F%)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Calcium Inhibition Magnitude')

subplot(122)
imagesc(xform_WL)
hold on
brainMapADOG = brainMapOG;
brainMapADOG(isnan(brainMapOG)) = 0;
brainMapADOG(~isnan(brainMapOG)) = 1;
imagesc(brainMapOG, "AlphaData", brainMapADOG,[-1.5 1.5]);
axis square image off
h = colorbar;
ylabel(h, 'Calcium(\DeltaF/F%)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Calcium Inhibition Magnitude, Actual Location')
sgtitle(miceName(2:end))