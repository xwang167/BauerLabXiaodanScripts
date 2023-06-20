load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitArea.mat',...
    'localInhibitArea','distantInhibitArea','validLocation')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSNR.mat',...
    'snrMap')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSTD.mat',...
    'stdMap')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-BilateralInhibitionMagnitude.mat',...
    'BilatInhibition')

% make to a patched map

brainMaplocalInhibitArea = nan(128,128);
for ii=4:128
    if logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&BilatInhibition(ii)      
            brainMaplocalInhibitArea(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = localInhibitArea(ii);

    end
end

brainMapddistantInhibitArea = nan(128,128);
for ii=1:128
    if  logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))
                brainMapdistantInhibitArea(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = distantInhibitArea(ii);

    end
end

brainMapsnrMap = nan(128,128);
for ii=1:128
    if  ~isnan(localInhibitArea(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))       
                brainMapsnrMap(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = nanmean(snrMap(:,:,ii),'all');

    end
end

brainMapstdMap = nan(128,128);
for ii=1:128
    if  ~isnan(localInhibitArea(ii)) && logical(~isnan(seedLocation_mice_FOV(1,ii)) && logical(~isnan(seedLocation_mice_FOV(2,ii))))&&~isnan(BilatInhibition(ii))  
                brainMapstdMap(seedmapLocs(1,ii)-pitch:seedmapLocs(1,ii)+pitch,seedmapLocs(2,ii)-pitch:seedmapLocs(2,ii)+pitch) = nanmean(stdMap(:,:,ii),'all');

    end
end


brainMapAD = brainMaplocalInhibitArea;
brainMapAD(isnan(brainMaplocalInhibitArea)) = 0;
brainMapAD(~isnan(brainMaplocalInhibitArea)) = 1;

% Visualization
figure;
ax(1) = subplot(221);
imagesc(xform_WL)
hold on
imagesc(brainMaplocalInhibitArea, "AlphaData", brainMapAD);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Local Inhibition Area')
colormap(ax(1), brewermap(256, 'Greens'));
text(seedmapLocs(2,10),seedmapLocs(1,10),'#10')

ax(2) = subplot(222);
imagesc(xform_WL)
hold on
imagesc(brainMapddistantInhibitArea, "AlphaData", brainMapAD);
axis image off
h = colorbar;
ylabel(h, 'Pixels','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('Distant Inhibition Area')
colormap(ax(2),brewermap(256, 'Greens'));

ax(3) = subplot(223);
imagesc(xform_WL)
hold on
imagesc(brainMapsnrMap, "AlphaData", brainMapAD);
axis image off
h = colorbar;
ylabel(h, '\DeltaF/F%','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('SNR')
colormap(ax(3),brewermap(256, 'Greens'));

ax(4) = subplot(224);
imagesc(xform_WL)
hold on
imagesc(brainMapstdMap, "AlphaData", brainMapAD);
axis image off
h = colorbar;
ylabel(h, '\DeltaF/F%','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
title('STD')
colormap(ax(4),brewermap(256, 'Greens'));
sgtitle('jRGECO1a Excitation and Inhibition Pixels')
