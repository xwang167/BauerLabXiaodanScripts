% excelFile = 'L:\RGECO\RGECO.xlsx';
% load(which('AtlasandIsbrain.mat'))
% AtlasSeedsFilled(:,65:end)=AtlasSeedsFilled(:,65:end)+20;
% AtlasSeedsFilled(AtlasSeedsFilled==20) = 0;
% imagesc(AtlasSeedsFilled)
% load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
%     'seedLocation_mice_FOV')
% load('N13M309-N13M548-N13M549-GoodSeedsNew.mat', 'GoodSeedsidx_FOV_mice')
% atlasIndx_FOV = nan(1,160);
% seedLocation_mice_FOV = round(seedLocation_mice_FOV);
% seedLocation_mice_FOV(:,logical(1-GoodSeedsidx_FOV_mice)) = nan;
% for ii = 1:160
%     if ~isnan(seedLocation_mice_FOV(1,ii))
%     atlasIndx_FOV(ii) = AtlasSeedsFilled(seedLocation_mice_FOV(1,ii),seedLocation_mice_FOV(2,ii));
%     end
% end
% atlasIndx_FOV(atlasIndx_FOV ==0)=nan;
% seedLocation_mice_FOV(:,isnan(atlasIndx_FOV)) = nan;
% [atlasIndx_FOV_sorted,I_FOV_sorted] = sort(atlasIndx_FOV); 
% seedLocation_mice_FOV_sorted = seedLocation_mice_FOV(:,I_FOV_sorted);
% seedLocation_mice_FOV_R_sorted = seedLocation_mice_FOV_sorted;
% seedLocation_mice_FOV_R_sorted(2,:) = 129-seedLocation_mice_FOV_R_sorted(2,:);
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat',...
%     'atlasIndx_FOV','atlasIndx_FOV_sorted','I_FOV_sorted','-append')
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
%     'seedLocation_mice_FOV','seedLocation_mice_FOV_sorted','seedLocation_mice_FOV_R_sorted','-append')
% excelRows = 2:7;
% [X,Y] = meshgrid(1:128,1:128);
% radius = 3;
% runs = 1:3;
% FCSeedMatrix_L_FOV_mice = nan(160,160,18);
% FCSeedMatrix_R_FOV_mice = nan(160,160,18);
% numRun = 1;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
%     else
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain')
%     end
%     
%     for n = runs
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile('L:\RGECO\',recDate,processedName),'xform_jrgeco1aCorr')
%         xform_jrgeco1aCorr = gsr(squeeze(xform_jrgeco1aCorr),xform_isbrain);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         timetrace_seeds_L = nan(14999,160);
%         timetrace_seeds_R = nan(14999,160);
%         
%         for ii = 1:160
%             x1 = seedLocation_mice_FOV_sorted(2,ii);
%             y1 = seedLocation_mice_FOV_sorted(1,ii);         
%             ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%             ROI = ROI(:);
%             if ~isnan(x1)||mean(xform_isbrain(ROI))==1
%             temp = mean(xform_jrgeco1aCorr(ROI,:),1);
%             temp = filterData(temp,0.4,4,25);
%             timetrace_seeds_L(:,ii) = temp;
%             end
%             
%             x2 = seedLocation_mice_FOV_R_sorted(2,ii);
%             y2 = seedLocation_mice_FOV_R_sorted(1,ii);
%             ROI = sqrt((X-x2).^2+(Y-y2).^2)<radius;
%             ROI = ROI(:);
%             if ~isnan(x1)||mean(xform_isbrain(ROI))==1
%             temp2 = mean(xform_jrgeco1aCorr(ROI,:),1);
%             temp2 = filterData(temp2,0.4,4,25);
%             timetrace_seeds_R(:,ii) = temp2;
%             end
%         end
%         FCSeedMatrix_L_FOV = nan(160);
%         FCSeedMatrix_R_FOV = nan(160);
%         for jj = 1:160
%             for kk = 1:160
%                 FCSeedMatrix_L_FOV(jj,kk) = corr(timetrace_seeds_L(:,jj),...
%                     timetrace_seeds_L(:,kk));
%                 
%                 FCSeedMatrix_R_FOV(jj,kk) = corr(timetrace_seeds_L(:,jj),...
%                     timetrace_seeds_R(:,kk));
%             end
%         end
%         save(fullfile('L:\RGECO',recDate,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'FCSeedMatrix','.mat')),...
%             'FCSeedMatrix_L_FOV', 'FCSeedMatrix_R_FOV');
%         FCSeedMatrix_L_FOV_mice(:,:,numRun) = atanh(FCSeedMatrix_L_FOV);
%         FCSeedMatrix_R_FOV_mice(:,:,numRun) = atanh(FCSeedMatrix_R_FOV);
%         numRun = numRun+ 1;
%         figure
%         imagesc(FCSeedMatrix_L_FOV)
%     end
% end
% FCSeedMatrix_L_FOV_mice = nanmean(FCSeedMatrix_L_FOV_mice,3);
% FCSeedMatrix_R_FOV_mice = nanmean(FCSeedMatrix_R_FOV_mice,3);
% save(fullfile('L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake_FCSeedMatrix'),...
%     'FCSeedMatrix_L_FOV_mice','FCSeedMatrix_R_FOV_mice')
% 
%  HomoFC_FOV= nan(128,128);
%     for ii = 1:160
%         x1 = seedLocation_mice_FOV_sorted(2,ii);
%         y1 = seedLocation_mice_FOV_sorted(1,ii);
%         if ~isnan(x1)
%         [X,Y] = meshgrid(1:128,1:128);
%         radius = 3;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         HomoFC_FOV(ROI) = FCSeedMatrix_R_FOV_mice(ii,ii);
%         end
%     end
  atlasIndx_FOV_sorted_valid = atlasIndx_FOV_sorted;
  atlasIndx_FOV_sorted_valid(isnan(atlasIndx_FOV_sorted)) = [];
  FCSeedMatrix_L_FOV_mice_valid = FCSeedMatrix_L_FOV_mice;
  FCSeedMatrix_L_FOV_mice_valid(isnan(atlasIndx_FOV_sorted),:) = [];
  FCSeedMatrix_L_FOV_mice_valid(:,isnan(atlasIndx_FOV_sorted)) = [];
  FCSeedMatrix_R_FOV_mice_valid = FCSeedMatrix_R_FOV_mice;
  FCSeedMatrix_R_FOV_mice_valid(isnan(atlasIndx_FOV_sorted),:) = [];
  FCSeedMatrix_R_FOV_mice_valid(:,isnan(atlasIndx_FOV_sorted)) = [];
  FCSeedMatrix_LR_FOV_mice_valid = nan(104,104*2);
  FCSeedMatrix_LR_FOV_mice_valid(:,1:104) = FCSeedMatrix_L_FOV_mice_valid;
  FCSeedMatrix_LR_FOV_mice_valid(:,105:end) = FCSeedMatrix_R_FOV_mice_valid;
  
  
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(real(FCSeedMatrix_LR_FOV_mice_valid),[-1.4 1.4]);
title('R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image

 [C, ia, ic] = unique(atlasIndx_FOV_sorted_valid);
seednames_sorted = cell(1,17*2);
for ii = 1:17
    seednames_sorted{ii} = seednames{atlasIndx_FOV_sorted_valid(ia(ii))};
    seednames_sorted{ii+17} = seednames{atlasIndx_FOV_sorted_valid(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+104])
xticklabels(seednames_sorted)
xtickangle(90)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR-FOV.png')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-FCMatrix-Calcium-LR-FOV.fig')


load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
figure
colormap jet
imagesc(HomoFC_FOV,[-1.4 1.4])
mask = isnan(HomoFC_FOV);
hold on
imagesc(xform_WL,'AlphaData',mask);
axis image off
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
suptitle('N13M309-N13M548-N13M549 Calcium HomoFC')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC-Calcium-FOV.png')
saveas(gcf,'L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC-Calcium-FOV.fig')
save('L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-R6M1-R6M2497-HomoFC.mat','HomoFC_FOV','-append')