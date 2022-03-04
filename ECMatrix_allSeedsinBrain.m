% clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% load('Z:\220210\220210-m.mat')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
%  xform_isbrain_union = zeros(128,128,3);
%  numMouse = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain_union(:,:,numMouse) = xform_isbrain;
%     numMouse = numMouse+1;
% end
% xform_isbrain_union = mean(xform_isbrain_union,3);
% xform_isbrain_union(xform_isbrain_union>0) = 1;
% xform_isbrain_union = xform_isbrain_union & fliplr(xform_isbrain_union);
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain = xform_isbrain & fliplr(xform_isbrain);
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
%     load(runInfo.saveMaskFile,'GoodSeedsidx')
%     GoodSeedsidx_FOV = GoodSeedsidx;
%     gridEFC_jRGECO1a_FOV = nan(128,128,160);
%     gridevokeTimeTrace_jRGECO1a = nan(runInfo.samplingRate*runInfo.blockLen,160);
%     jj = 1;
%     for ii = 1:totalSubFileNum
%         load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
%         AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
%         numBlock = size(AvgMovie_jRGECO1a,4);
%         kk = 1;
%         while kk < numBlock+1
%             if GoodSeedsidx(m(jj)) == 1
%                 laser_location = gridLaser_mouse(:,:,m(jj));
%                 [M,I_1] = max(laser_location,[],'all','linear');
%                 [row,col] = ind2sub([128 128],I_1);
%                 x1 = col;
%                 y1 = row;
%                 [X,Y] = meshgrid(1:128,1:128);
%                 radius = 3;
%                 ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%                 if M < 10000 || xform_isbrain(row,col) == 0
%                     GoodSeedsidx_FOV(m(jj)) = 0;
%                     disp([runInfo.mouseName,'#' num2str(m(jj)) ])
%                 else
%                     movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
%                     [gridEFC_jRGECO1a_FOV(:,:,m(jj)),gridevokeTimeTrace_jRGECO1a_FOV(:,m(jj))] = seedFCMap_xw(movie_jRGECO1a,logical(ROI));
%                     figure
%                     colormap jet
%                     subplot(1,2,1)
%                     imagesc(gridEFC_jRGECO1a_FOV(:,:,m(jj)),[-1 1])
%                     axis image off
%                     colorbar
%                     hold on
%                     contour(ROI,'w')
%                     hold on;
%                     imagesc(xform_WL,'AlphaData',1-xform_isbrain);
%                     title('Effective Connectivity')
%                     subplot(1,2,2)
%                     plot((1:runInfo.samplingRate*runInfo.blockLen)/runInfo.samplingRate,...
%                         gridevokeTimeTrace_jRGECO1a_FOV(:,m(jj)),'m');
%                     title('Evoked Time Trace')
%                     suptitle([runInfo.mouseName, ' ', 'Position #',num2str(m(jj))])
%                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace_FOV.fig'))
%                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace_FOV.png'))
%                     close all
%
%                 end
%                 kk = kk+1;
%             end
%             jj = jj+1;
%         end
%
%     end
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEFC_jRGECO1a_FOV','-append')
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),'gridevokeTimeTrace_jRGECO1a_FOV','-append')
%     save(runInfo.saveMaskFile,'GoodSeedsidx_FOV','-append')
%
% end

% %% EC averaged across mice
% gridEFC_jRGECO1a_mice_FOV = nan(128,128,160,3);
% mouseInd = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo=runsInfo(1);
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEFC_jRGECO1a_FOV')
%     gridEFC_jRGECO1a_mice_FOV(:,:,:,mouseInd) = atanh(gridEFC_jRGECO1a_FOV);
%     mouseInd = mouseInd+1;
% end
% 
% gridEFC_jRGECO1a_mice_FOV = nanmean(gridEFC_jRGECO1a_mice_FOV,4);
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat','gridEFC_jRGECO1a_mice_FOV','-append')
%
% % for ii = 1:160
% %     imagesc(gridEFC_jRGECO1a_mice_FOV(:,:,ii),[-2 2])
% %     pause
% % end
%
% %% how many seeds inside union of xform_isbrains
% GoodSeedsidx_FOV_mice =nan(160,3);
% numMouse = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo=runsInfo(1);
%     load(runInfo.saveMaskFile,'GoodSeedsidx_FOV')
%     GoodSeedsidx_FOV_mice(:,numMouse) = GoodSeedsidx_FOV;
%     numMouse = numMouse+1;
% end
% GoodSeedsidx_FOV_mice = mean(GoodSeedsidx_FOV_mice,2);
% GoodSeedsidx_FOV_mice(GoodSeedsidx_FOV_mice>0)=1;
%
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_FOV_mice','-append')
%
% %how many valid frames in gridEFC
% numValid = 0;
% for ii = 1:160
%     if ~isnan(gridEFC_jRGECO1a_mice_FOV(64,64,ii))
%         numValid = numValid+1;
%     end
% end
%
%

% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridLaser_mice.mat','gridLaser_mice')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_FOV_mice')
% seedLocation_FOV = nan(2,3,160);
% seedLocation_mice_FOV = nan(2,160);
% for ii = 1:160
%     if GoodSeedsidx_FOV_mice(ii)
%         load('X:\XW\PVChR2-Thy1RGECO\220208\220208-N13M309-LandmarksandMask.mat', 'GoodSeedsidx_FOV')
%         if GoodSeedsidx_FOV(ii) == 1
%             [~,I_1] = max(gridLaser_mice(:,:,ii,1),[],'all','linear');
%             [row_1,col_1] = ind2sub([128 128],I_1);
%             seedLocation_FOV(1,1,ii) = row_1;
%             seedLocation_FOV(2,1,ii) = col_1;
%         end
% 
%         load('X:\XW\PVChR2-Thy1RGECO\220210\220210-N13M549-LandmarksandMask.mat', 'GoodSeedsidx_FOV')
%         if GoodSeedsidx_FOV(ii) == 1
%             [~,I_2] = max(gridLaser_mice(:,:,ii,2),[],'all','linear');
%             [row_2,col_2] = ind2sub([128 128],I_2);
%             seedLocation_FOV(1,2,ii) = row_2;
%             seedLocation_FOV(2,2,ii) = col_2;
%         end
% 
%         load('X:\XW\PVChR2-Thy1RGECO\220212\220212-N13M548-LandmarksandMask.mat', 'GoodSeedsidx_FOV')
%         if GoodSeedsidx_FOV(ii) == 1
%             [~,I_3] = max(squeeze(gridLaser_mice(:,:,ii,3)),[],'all','linear');
%             [row_3,col_3] = ind2sub([128 128],I_3);
%             seedLocation_FOV(1,3,ii) = row_3;
%             seedLocation_FOV(2,3,ii) = col_3;
%         end
%         seedLocation_mice_FOV(1,ii) = nanmean(seedLocation_FOV(1,:,ii),2);
%         seedLocation_mice_FOV(2,ii)= nanmean(seedLocation_FOV(2,:,ii),2);
% 
%     end
% end
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice_FOV','-append')

% %% EC Map
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice_FOV')
% jj = 1;
% figure('units','normalized','outerposition',[0 0 1 1])
% colormap jet
% [X,Y] = meshgrid(1:128,1:128);
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat')
% num = 1;
% for ii = 1:160
%     if ~isnan(gridEFC_jRGECO1a_mice_FOV(64,64,ii))
%         x1 = seedLocation_mice_FOV(2,ii);
%         y1 = seedLocation_mice_FOV(1,ii);
%         radius = 3;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         subplot(5,8,jj)
%         imagesc(gridEFC_jRGECO1a_mice_FOV(:,:,ii),[-2 2])
%         hold on
%         contour(ROI,'w')
%         hold on;
%         imagesc(xform_WL,'AlphaData',logical(1-xform_isbrain_union));
%         title(['Position #',num2str(ii)])
%         axis image off
%         jj = jj+1;
%         if jj == 41
%             p = subplot(5,8,40);
%             Pos = get(p,'Position');
%             h = colorbar;
%             ylabel(h, 'z(r)')
%             set(p,'Position',Pos)
%             suptitle(strcat('N13M309-N13M548-N13M549 Calcium EC -',num2str(num)))            
%             jj = 1;
%             saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-1.png')
%             saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-1.fig')
%             num = num+1;
%             figure('units','normalized','outerposition',[0 0 1 1])
%             colormap jet
%         end
%     end
% end
% p = subplot(5,8,36);
% Pos = get(p,'Position');
% h = colorbar;
% ylabel(h, 'z(r)')
% set(p,'Position',Pos)
% suptitle('N13M309-N13M548-N13M549 Calcium EC -3')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-3.png')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-3.fig')

% %%find index to sort the matrix in the order of functional regions
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice')
% load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
% atlasIndx = nan(1,160);
% atlasIndx_valid_FOV = nan(1,116);
% seedLocation_mice_valid_FOV = nan(2,116);
% jj = 1;
% for ii = 1:160
%     if ~isnan(seedLocation_mice_FOV(1,ii))
%         seedLocation_mice_valid_FOV(:,jj) = round(seedLocation_mice_FOV(:,ii));
%         atlasIndx(ii) = AtlasSeedsFilled(seedLocation_mice_valid_FOV(1,jj),...
%             seedLocation_mice_valid_FOV(2,jj));
%         if atlasIndx(ii)==0
%             atlasIndx(ii) = NaN;
%         end
%         atlasIndx_valid_FOV(jj) = atlasIndx(ii);
%         jj = jj+1;
%     end
% end

% [atlasIndx_valid_sorted_FOV,I_FOV] = sort(atlasIndx_valid_FOV);
% seedLocation_mice_valid_sorted_FOV = seedLocation_mice_valid_FOV(:,I_FOV);
% seedLocation_mice_valid_sorted_FOV(:,isnan(atlasIndx_valid_sorted_FOV)) = [];
% I_FOV_noNan = I_FOV;
% I_FOV_noNan(isnan(atlasIndx_valid_sorted_FOV)) = [];
% atlasIndx_valid_sorted_FOV_noNan = atlasIndx_valid_sorted_FOV;
% atlasIndx_valid_sorted_FOV_noNan(isnan(atlasIndx_valid_sorted_FOV)) = [];
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted_FOV','I_FOV','I_FOV_noNan','atlasIndx_valid_FOV','atlasIndx_valid_sorted_FOV_noNan')
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice_valid_FOV','seedLocation_mice_valid_sorted_FOV','-append')
% % 
% 


% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat','gridEFC_jRGECO1a_mice_FOV')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice_FOV')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_FOV_mice')
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted_FOV','I_FOV')
% load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% 
% gridEFC_jRGECO1a_mice_valid_FOV = gridEFC_jRGECO1a_mice_FOV;
% gridEFC_jRGECO1a_mice_valid_FOV(:,:,logical(1-GoodSeedsidx_FOV_mice))=[];
% gridEFC_jRGECO1a_mice_valid_sorted_FOV = gridEFC_jRGECO1a_mice_valid_FOV(:,:,I_FOV);
% 
% gridEFC_jRGECO1a_mice_valid_sorted_FOV(:,:,isnan(atlasIndx_valid_sorted_FOV)) = [];
% 
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat',...
%     'gridEFC_jRGECO1a_mice_valid_FOV','gridEFC_jRGECO1a_mice_valid_FOV','-append')

% 
% 
% seedLocation_mice_valid_sorted_R_FOV = nan(2,105);
% seedLocation_mice_valid_sorted_R_FOV(1,:) = seedLocation_mice_valid_sorted_FOV(1,:);
% seedLocation_mice_valid_sorted_R_FOV(2,:) = 129-seedLocation_mice_valid_sorted_FOV(2,:);
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
%     'seedLocation_mice_valid_sorted_R_FOV','-append')

%  [X,Y] = meshgrid(1:128,1:128);
% ECMatrix_mice_valid_sorted_L_FOV = nan(105,105);
% ECMatrix_mice_valid_sorted_R_FOV = nan(105,105);
% 
% for ii = 1:105
%     map = gridEFC_jRGECO1a_mice_valid_sorted_FOV(:,:,ii);
%     for jj = 1:105     
%         x1 = seedLocation_mice_valid_sorted_FOV(2,jj);
%         y1 = seedLocation_mice_valid_sorted_FOV(1,jj);
%         radius = 3;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         ROI = ROI(:);
%         map = reshape(map,128*128,[]);
%         ECMatrix_mice_valid_sorted_L_FOV(ii,jj) = nanmean(map(ROI));
%     end
% end


% for ii = 1:105
%     map = gridEFC_jRGECO1a_mice_valid_sorted_FOV(:,:,ii);
%     for jj = 1:105       
%         x1 = seedLocation_mice_valid_sorted_R_FOV(2,jj);
%         y1 = seedLocation_mice_valid_sorted_R_FOV(1,jj);
%         radius = 3;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         ROI = ROI(:);
%         map = reshape(map,128*128,[]);
%         ECMatrix_mice_valid_sorted_R_FOV(ii,jj) = nanmean(map(ROI));
%     end
% end
% ECMatrix_mice_valid_sorted_LR_FOV = nan(105,105*2);
% ECMatrix_mice_valid_sorted_LR_FOV(:,1:105) = ECMatrix_mice_valid_sorted_L_FOV;
% ECMatrix_mice_valid_sorted_LR_FOV(:,106:end) = ECMatrix_mice_valid_sorted_R_FOV;

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_mice_valid_sorted_LR_FOV,[-1.4 1.4]);
title('N13M309-N13M548-N13M549-ECMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image
 [C, ia, ic] = unique(atlasIndx_valid_sorted_FOV_noNan);
seednames_sorted = cell(1,18*2);
for ii = 1:18
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
    seednames_sorted{ii+18} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+105])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR-FOV.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR-FOV.fig')
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
     'ECMatrix_mice_valid_sorted_LR_FOV','-append')





















