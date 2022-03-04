% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-PeakMap-Laser.mat','gridPeakMaps_jrgeco1aCorr_mice')
 load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat')
% load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% 
% 
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice')
% atlasIndx = nan(1,160);
% atlasIndx_valid = nan(1,79);
% seedLocation_mice_valid = nan(2,79);
% jj = 1;
% for ii = 1:160
%     if ~isnan(seedLocation_mice(1,ii))
%         seedLocation_mice_valid(:,jj) = round(seedLocation_mice(:,ii));
%         atlasIndx(ii) = AtlasSeedsFilled(seedLocation_mice_valid(1,jj),...
%             seedLocation_mice_valid(2,jj));
%         atlasIndx_valid(jj) = atlasIndx(ii);
%         jj = jj+1;
%     end
% end
% [atlasIndx_valid_sorted,I] = sort(atlasIndx_valid);
% seedLocation_mice_valid_sorted = seedLocation_mice_valid(:,I);
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted','I','atlasIndx_valid','-append')
% 
% 
% xform_isbrain_mice = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
% end
% xform_isbrain_mice = xform_isbrain_mice & fliplr(xform_isbrain_mice);
% 
% gridPeakMaps_jrgeco1aCorr_mice_valid = gridPeakMaps_jrgeco1aCorr_mice;
% gridPeakMaps_jrgeco1aCorr_mice_valid(:,:,logical(1-GoodSeedsidx_new_mice))=[];
% gridPeakMaps_jrgeco1aCorr_mice_valid_sorted = gridPeakMaps_jrgeco1aCorr_mice_valid(:,:,I);
% 
% 
% jj = 1;
% figure('units','normalized','outerposition',[0 0 1 1])
% [X,Y] = meshgrid(1:128,1:128);
% for ii = 1:79
%     x1 = seedLocation_mice_valid_sorted(2,ii);
%     y1 = seedLocation_mice_valid_sorted(1,ii);
%     radius = 3;
%     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%     subplot(5,8,jj)
%     imagesc(gridPeakMaps_jrgeco1aCorr_mice_valid_sorted(:,:,ii)*100,[-0.5 0.5])
%     hold on
%     contour(ROI,'w')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
%     title(num2str(atlasIndx_valid_sorted(ii)))
%     axis image off
%     if jj ==40
%         p = subplot(5,8,40);
%         Pos = get(p,'Position');
%         h = colorbar;
%         ylabel(h, 'z(r)')
%         set(p,'Position',Pos)
%     end
%     colormap jet
%     jj = jj+1;
%     if jj==41
%         suptitle('N13M309-N13M548-N13M549 Calcium Evoke Response sorted -1')
%         jj = 1;
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-1.png')
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-1.fig')
%         figure('units','normalized','outerposition',[0 0 1 1])
%         colormap jet
%         suptitle('N13M309-N13M548-N13M549 Calcium Evoke Response -2')
%     end
% end
% p = subplot(5,8,39);
% Pos = get(p,'Position');
% h = colorbar;
% ylabel(h, 'z(r)')
% set(p,'Position',Pos)
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-2.png')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-2.fig')
% 
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridPeakMaps.mat',...
%     'gridPeakMaps_jrgeco1aCorr_mice_valid','gridPeakMaps_jrgeco1aCorr_mice_valid_sorted')

EvokeResponseMatrix_mice_valid_sorted_L = nan(79,79);
EvokeResponseMatrix_mice_valid_sorted_R = nan(79,79);
% 
for ii = 1:79
    map = gridPeakMaps_jrgeco1aCorr_mice_valid_sorted(:,:,ii);
    for jj = 1:79        
        x1 = seedLocation_mice_valid_sorted(2,jj);
        y1 = seedLocation_mice_valid_sorted(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        EvokeResponseMatrix_mice_valid_sorted_L(ii,jj) = nanmean(map(ROI));
    end
end

for ii = 1:79
    map = gridPeakMaps_jrgeco1aCorr_mice_valid_sorted(:,:,ii);
    for jj = 1:79        
        x1 = seedLocation_mice_valid_sorted_R(2,jj);
        y1 = seedLocation_mice_valid_sorted_R(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        EvokeResponseMatrix_mice_valid_sorted_R(ii,jj) = nanmean(map(ROI));
    end
end
EvokeResponseMatrix_mice_valid_sorted_LR = nan(79,79*2);
EvokeResponseMatrix_mice_valid_sorted_LR(:,1:79) = EvokeResponseMatrix_mice_valid_sorted_L;
EvokeResponseMatrix_mice_valid_sorted_LR(:,80:end) = EvokeResponseMatrix_mice_valid_sorted_R;

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(EvokeResponseMatrix_mice_valid_sorted_LR*100,[-0.5 0.5]);
title('N13M309-N13M548-N13M549-EvokeResponseMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image
 [C, ia, ic] = unique(atlasIndx_valid_sorted);
seednames_sorted = cell(1,17*2);
for ii = 1:17
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted(ia(ii))};
    seednames_sorted{ii+17} = seednames{atlasIndx_valid_sorted(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+79])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponseMatrix-Calcium-LR.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponseMatrix-Calcium-LR.fig')


