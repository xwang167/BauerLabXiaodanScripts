%clear; close all; clc;
load('L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC.mat','HomoFC_FOV')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
%%
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat', 'seedLocation_mice_FOV_sorted')

%% get seedmap v2
load("D:\OIS_Process\Paxinos\AtlasandIsbrain.mat",'xform_WL')
seedmapLocsOG = round(seedLocation_mice_FOV_sorted);

measurementsXW = nan(104,1);
jj = 1;
for ii = 1:160
    if ~isnan(seedmapLocsOG(1,ii))
        measurementsXW(jj) = HomoFC_FOV(seedmapLocsOG(1,ii),seedmapLocsOG(2,ii));
        jj = jj+1;
    end
end

goodseeds = nan(128,128);
goodseedsloc = zeros(2,16*8);

spacing = 6;
ii = 1; kk = 1;
for i=1:8
    for j=1:16
        if seedmapLocsOG(1,ii) ~= 0 && seedmapLocsOG(2,ii) ~= 0
            goodseeds(102-(j-1)*spacing,56-(i-1)*spacing) = 1;
            goodseedsloc(1,ii) = (102+3*spacing)-(j-1)*spacing;%seedmapLocsSorted(1,kk);%108-(j-1)*6;
            goodseedsloc(2,ii) = 56-(i-1)*spacing;%seedmapLocsSorted(2,kk);%56-(i-1)*6;
            disp([num2str(goodseedsloc(1,ii)) ', ' num2str(goodseedsloc(2,ii))])
            kk = kk + 1;
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
    if seedmapLocs(1,i) ~= 0 && seedm%clear; close all; clc;
load("X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-HomoFC-Calcium.mat");
load("X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat");
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
%%


%% get seedmap v2
load("D:\OIS_Process\Paxinos\AtlasandIsbrain.mat",'xform_WL')
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

measurementsXW = nan(79,1);
jj = 1;
for ii = 1:160
    if seedmapLocsOG(1,ii) ~= 0 && seedmapLocsOG(2,ii) ~= 0
        measurementsXW(jj) = HomoFC_valid_mice_FOV(seedmapLocsOG(1,ii),seedmapLocsOG(2,ii));
        jj = jj+1;
    end
end

goodseeds = nan(128,128);
goodseedsloc = zeros(2,16*8);

spacing = 6;
ii = 1; kk = 1;
for i=1:8
    for j=1:16
        if seedmapLocsOG(1,ii) ~= 0 && seedmapLocsOG(2,ii) ~= 0
            goodseeds(102-(j-1)*spacing,56-(i-1)*spacing) = 1;
            goodseedsloc(1,ii) = (102+3*spacing)-(j-1)*spacing;%seedmapLocsSorted(1,kk);%108-(j-1)*6;
            goodseedsloc(2,ii) = 56-(i-1)*spacing;%seedmapLocsSorted(2,kk);%56-(i-1)*6;
            disp([num2str(goodseedsloc(1,ii)) ', ' num2str(goodseedsloc(2,ii))])
            kk = kk + 1;
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
        brainMap(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = measurementsXW(jj);
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
        brainMapOG(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = measurementsXW(jj);
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
brainMapAD(isnan(brainMapAD)) = 0;
brainMapAD(brainMapAD>0) = 1;
imagesc(brainMap, "AlphaData", brainMapAD,[-1.4 1.4]);
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')

subplot(122) 
imagesc(xform_WL)
hold on
brainMapADOG = brainMapOG;
brainMapADOG(isnan(brainMapADOG)) = 0;
brainMapADOG(brainMapADOG>0) = 1;
imagesc(brainMapOG, "AlphaData", brainMapADOG);
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')apLocs(2,i) ~= 0
        brainMap(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = measurementsXW(jj);
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
        brainMapOG(seedmapLocs(1,i)-pitch:seedmapLocs(1,i)+pitch,seedmapLocs(2,i)-pitch:seedmapLocs(2,i)+pitch) = measurementsXW(jj);
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
brainMapAD(isnan(brainMapAD)) = 0;
brainMapAD(brainMapAD>0) = 1;
imagesc(brainMap, "AlphaData", brainMapAD,[-1.4 1.4]);
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')

subplot(122) 
imagesc(xform_WL)
hold on
brainMapADOG = brainMapOG;
brainMapADOG(isnan(brainMapADOG)) = 0;
brainMapADOG(brainMapADOG>0) = 1;
imagesc(brainMapOG, "AlphaData", brainMapADOG);
axis square image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('N13M309-N13M548-N13M549 Calcium HomoFC')