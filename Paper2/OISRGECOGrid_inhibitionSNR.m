excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitArea.mat',...
    'validLocation')
snrMap = nan(128,128,160);
for location = 1:160
    if ~isnan(validLocation(location))
        inhibtionMaps_mice = nan(128,128,10);
        mouseInd = 1;
        for excelRow = excelRows
            runsInfo = parseRuns_xw(excelFile,excelRow);
            runInfo = runsInfo(1);
            load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap')
            inhibtionMaps_mice(:,:,mouseInd) = inhibitionMap(:,:,location);
            mouseInd = mouseInd+1;
        end
        temp_std = nanstd(inhibtionMaps_mice,0,3);
        temp_mean = nanmean(inhibtionMaps_mice,3);
        temp = temp_mean./temp_std;
        temp(logical(1-mask)) = nan;
        snrMap(:,:,location) = temp;
    end
end

save('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSNR.mat',...
    'snrMap')


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