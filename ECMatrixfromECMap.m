% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted','I')
% load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% xform_isbrain_mice = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
% end
% xform_isbrain_mice = xform_isbrain_mice & fliplr(xform_isbrain_mice);
% gridEFC_jRGECO1a_mice_valid = gridEFC_jRGECO1a_mice;
% gridEFC_jRGECO1a_mice_valid(:,:,logical(1-GoodSeedsidx_new_mice))=[];
% gridEFC_jRGECO1a_mice_valid_sorted = gridEFC_jRGECO1a_mice_valid(:,:,I);
% 
% 
% seedLocation_mice_valid = seedLocation_mice;
% seedLocation_mice_valid(:,logical(1-GoodSeedsidx_new_mice))=[];
% seedLocation_mice_valid_sorted = seedLocation_mice_valid(:,I);
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
%     imagesc(gridEFC_jRGECO1a_mice_valid_sorted(:,:,ii),[-2 2])
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
%         suptitle('N13M309-N13M548-N13M549 Calcium EC sorted -1')
%         jj = 1;
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-sorted-1.png')
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-sorted-1.fig')
%         figure('units','normalized','outerposition',[0 0 1 1])
%         colormap jet
%         suptitle('N13M309-N13M548-N13M549 Calcium EC -2')
%     end
% end
% p = subplot(5,8,39);
% Pos = get(p,'Position');
% h = colorbar;
% ylabel(h, 'z(r)')
% set(p,'Position',Pos)
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-sorted-2.png')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-sorted-2.fig')
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
%     'seedLocation_mice_valid','seedLocation_mice_valid_sorted','-append')
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat',...
%     'gridEFC_jRGECO1a_mice_valid','gridEFC_jRGECO1a_mice_valid_sorted','-append')
seedLocation_mice_valid_sorted_R = nan(2,79);
seedLocation_mice_valid_sorted_R(1,:) = seedLocation_mice_valid_sorted(1,:);
seedLocation_mice_valid_sorted_R(2,:) = 129-seedLocation_mice_valid_sorted(2,:);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
    'seedLocation_mice_valid_sorted_R','-append')


ECMatrix_mice_valid_sorted_L = nan(79,79);
ECMatrix_mice_valid_sorted_R = nan(79,79);

for ii = 1:79
    map = gridEFC_jRGECO1a_mice_valid_sorted(:,:,ii);
    for jj = 1:79        
        x1 = seedLocation_mice_valid_sorted(2,jj);
        y1 = seedLocation_mice_valid_sorted(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        ECMatrix_mice_valid_sorted_L(ii,jj) = nanmean(map(ROI));
    end
end


for ii = 1:79
    map = gridEFC_jRGECO1a_mice_valid_sorted(:,:,ii);
    for jj = 1:79        
        x1 = seedLocation_mice_valid_sorted_R(2,jj);
        y1 = seedLocation_mice_valid_sorted_R(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        ECMatrix_mice_valid_sorted_R(ii,jj) = nanmean(map(ROI));
    end
end
ECMatrix_mice_valid_sorted_LR = nan(79,79*2);
ECMatrix_mice_valid_sorted_LR(:,1:79) = ECMatrix_mice_valid_sorted_L;
ECMatrix_mice_valid_sorted_LR(:,80:end) = ECMatrix_mice_valid_sorted_R;

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_mice_valid_sorted_LR,[-1.4 1.4]);
title('N13M309-N13M548-N13M549-ECMatrix-Calcium-LR')
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
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.fig')


