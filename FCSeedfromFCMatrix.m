% load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat',...
%     'xform_isbrain_mice')
% xform_isbrain_mice_awake = xform_isbrain_mice;
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat',...
%     'xform_isbrain_mice')
% xform_isbrain_mice_anes = xform_isbrain_mice;
% xform_isbrain_mice = xform_isbrain_mice_awake.*xform_isbrain_mice_anes;
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = (leftMask+rightMask).*xform_isbrain_mice;
% mask = imresize(mask,0.5);
% mask(mask<0.5) = 0;
% mask = logical(mask);
%
% load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_fcMatrix_mice.mat',...
%     'FCMatrix_Calcium_Delta_old_mice', 'FCMatrix_Calcium_ISA_old_mice')
%mask = transpose(mask);
% for ii = 1:2262
%     map=zeros(64);
%     map(mask)=FCMatrix_Calcium_Delta_old_mice(ii,:)';
%     imagesc(transpose(real(map)),[-1.4 1.4])
%     pause
% end

% kk = 1;
% location = nan(1,64*64);
% for ii = 1:64
%     for jj = 1:64
%         if mask(ii,jj)
%             ind = sub2ind([64 64],ii,jj);
%             location(1,ind)=kk;
%             kk = kk+1;
%         end
%     end
% end



%mask =  transpose(mask);
% FC_valid_sorted_L = nan(79);
% map = nan(64);
% for ii = 1:79
%     row = round(seedLocation_mice_valid_sorted(1,ii)/2);
%     col = round(seedLocation_mice_valid_sorted(2,ii)/2);
%     ind = sub2ind([64 64],row,col);
%     ind_matrix = location(ind);
%     temp = FCMatrix_Calcium_Delta_old_mice(ind_matrix,:);
%     map(mask) = temp;
%     map = reshape(map,64,64);
%     map = transpose(map);
%     for jj = 1:79
%         x1 = round(seedLocation_mice_valid_sorted(2,jj)/2);
%         y1 = round(seedLocation_mice_valid_sorted(1,jj)/2);
%         [X,Y] = meshgrid(1:64,1:64);
%         radius = 1.5;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         ROI = ROI(:);
%         map = map(:);
%         FC_valid_sorted_L(ii,jj) = nanmean(map(ROI));
%     end
% end

% FC_valid_sorted_R = nan(79);
% map = nan(64);
% for ii = 1:79
%     row = round(seedLocation_mice_valid_sorted(1,ii)/2);
%     col = round(seedLocation_mice_valid_sorted(2,ii)/2);
%     ind = sub2ind([64 64],row,col);
%     ind_matrix = location(ind);
%     temp = FCMatrix_Calcium_Delta_old_mice(ind_matrix,:);
%     map(mask) = temp;
%     map = reshape(map,64,64);
%     map = transpose(map);
%     for jj = 1:79
%         x1 = round(seedLocation_mice_valid_sorted_R(2,jj)/2);
%         y1 = round(seedLocation_mice_valid_sorted_R(1,jj)/2);
%         [X,Y] = meshgrid(1:64,1:64);
%         radius = 1.5;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         ROI = ROI(:);
%         map = map(:);
%         FC_valid_sorted_R(ii,jj) = nanmean(map(ROI));
%     end
% end
% 
% FC_valid_sorted_LR = nan(79,79*2);
% FC_valid_sorted_LR(:,1:79) = FC_valid_sorted_L;
% FC_valid_sorted_LR(:,80:end) = FC_valid_sorted_R;
% save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fcMatrix_sorted.mat',...
%     'FC_valid_sorted_L','FC_valid_sorted_R','FC_valid_sorted_LR');
% 
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fcMatrix_sorted.mat',...
    'FC_valid_sorted_L','FC_valid_sorted_R','FC_valid_sorted_LR');
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(real(FC_valid_sorted_LR),[-1.4 1.4]);
title('R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted','I','atlasIndx_valid')

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
xtickangle(90)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR.png')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR.fig')

homotopicMap = nan(128,128);
for ii = 1:79
        x1 = round(seedLocation_mice_valid_sorted(2,ii));
        y1 = round(seedLocation_mice_valid_sorted(1,ii));
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        homotopicMap(ROI) = FC_valid_sorted_R(ii,ii);      
end
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
figure
colormap jet
imagesc(homotopicMap,[-1.4 1.4])
mask = isnan(homotopicMap);
hold on
imagesc(xform_WL,'AlphaData',mask);
axis image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
suptitle('N13M309-N13M548-N13M549 Calcium HomoFC')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC-Calcium.png')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC-Calcium.fig')
save('L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC.mat','homotopicMap')