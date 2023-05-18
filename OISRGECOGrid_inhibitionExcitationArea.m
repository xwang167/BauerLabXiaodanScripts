load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitionMap.mat',...
    'inhibitionMap_Calcium_NoGSR_mice')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-SeedLocation.mat',...
    'seedLocation_mice_FOV')
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
%%

localInhibitArea = nan(1,160);
distantInhibitArea = nan(1,160);
totalArea = zeros(1,160);
validLocation = nan(1,160);
ipsiInhibitionPix = nan(1,160);
ipsiExcitationPix = nan(1,160);
contraInhibitionPix = nan(1,160);
contraExcitationPix = nan(1,160);
for location = 1:160
    X_center = round(seedLocation_mice_FOV(2,location));
    Y_center = round(seedLocation_mice_FOV(1,location));
    if ~isnan(seedLocation_mice_FOV(1,location))
        if mask(Y_center,X_center)
            % find the most inhibition site around the laser spot(not necessary align with each other)
            [X,Y] = meshgrid(1:128,1:128);
            radius = 6;
            ROI = sqrt((X-seedLocation_mice_FOV(2,location)).^2+(Y-seedLocation_mice_FOV(1,location)).^2)<radius;
            peakMap = inhibitionMap_Calcium_NoGSR_mice(:,:,location);
            peakMap(~ROI) = nan;
            [M,I] = min(peakMap,[],'all');
            % If there is inhibtion
            if M<0
                temp = inhibitionMap_Calcium_NoGSR_mice(:,:,location);
                % only consider pixels that is not vasculature
                temp_left = temp;
                temp_right = temp;
                temp_left(logical(1-leftMask)) = nan;
                temp_right(logical(1-rightMask)) = nan;
                ipsiInhibitionPix(location)   = length(find(temp_left<0));
                ipsiExcitationPix(location)   = length(find(temp_left>0));
                contraInhibitionPix(location) = length(find(temp_right<0));
                contraExcitationPix(location) = length(find(temp_right>0));
            end
        end
    end
end
save('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitionExcitationArea.mat',...
    'ipsiInhibitionPix','ipsiExcitationPix','contraInhibitionPix','contraExcitationPix')

%%
goodseedsloc = zeros(2,16*8);

spacing = 7;
ii = 1;
for i=1:8
    for j=1:16
        if ~isnan(ipsiInhibitionPix(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))
            goodseedsloc(1,ii) = round((102+3*(spacing-1))-(j-1)*(spacing-1));%seedmapLocsSorted(1,kk);%108-(j-1)*6;
            goodseedsloc(2,ii) = round(56-(i-1)*spacing);%seedmapLocsSorted(2,kk);%56-(i-1)*6;
            disp([num2str(goodseedsloc(1,ii)) ', ' num2str(goodseedsloc(2,ii))])
        end
        ii = ii + 1;
    end
end

excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = strcat(miceName,'-',runInfo.mouseName);
end


load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'));
seedmapLocsOG = round(seedLocation_mice_FOV);
seedmapLocs = goodseedsloc;
pitch = 2;
%%
% make to a patched map
brainMapipsiInhibitionPix = nan(128,128);
for ii=1:128
    if  ~isnan(ipsiInhibitionPix(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))
        brainMapipsiInhibitionPix(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = ipsiInhibitionPix(ii);
    end
end

brainMapcontraInhibitionPix = nan(128,128);
for ii=1:128
    if  ~isnan(ipsiInhibitionPix(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))
        brainMapcontraInhibitionPix(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = contraInhibitionPix(ii);
    end
end

brainMapipsiExcitationPix = nan(128,128);
for ii=1:128
    if  ~isnan(ipsiExcitationPix(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))
        brainMapipsiExcitationPix(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = ipsiExcitationPix(ii);
    end
end

brainMapcontraExcitationPix = nan(128,128);
for ii=1:128
    if  ~isnan(ipsiExcitationPix(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))
        brainMapcontraExcitationPix(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = contraExcitationPix(ii);
    end
end

brainMapAD = brainMapipsiInhibitionPix;
brainMapAD(isnan(brainMapipsiInhibitionPix)) = 0;
brainMapAD(~isnan(brainMapipsiInhibitionPix)) = 1;


% Visualization
figure;
ax(1) = subplot(221);
imagesc(xform_WL)
hold on
imagesc(brainMapipsiInhibitionPix, "AlphaData", brainMapAD,[0 4460]);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Ipsilateral Inhibition Number')
colormap(ax(1), brewermap(256, 'Blues'));
text(seedmapLocs(2,10),seedmapLocs(1,10),'#10')
ax(2) = subplot(222);
imagesc(xform_WL)
hold on
imagesc(brainMapcontraInhibitionPix, "AlphaData", brainMapAD,[0 4460]);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Contralateral Inhibition Number')
colormap(ax(2),brewermap(256, 'Blues'));

ax(3) = subplot(223);
imagesc(xform_WL)
hold on
imagesc(brainMapipsiExcitationPix, "AlphaData", brainMapAD,[0 4460]);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Ipsilateral Excitation Number')
colormap(ax(3),brewermap(256, 'Reds'));

ax(4) = subplot(224);
imagesc(xform_WL)
hold on
imagesc(brainMapcontraExcitationPix, "AlphaData", brainMapAD,[0 4460]);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Contralateral Excitation Number')
colormap(ax(4),brewermap(256, 'Reds'));
sgtitle('jRGECO1a Excitation and Inhibition Pixels')