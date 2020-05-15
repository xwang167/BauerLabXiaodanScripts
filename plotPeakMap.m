 load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
% figure('Position', [50 50 250 200])
%  imagesc(xform_FAD_mice_GSR(:,:,250)*100)
% colormap jet
% hold on
% imagesc(xform_WL,'AlphaData',1-ROI_GSR);
% axis image off
% title('FAD')
% cb = colorbar( 'EastOutside','AxisLocation','out',...
%     'FontSize',15,'fontweight','bold');
% cb.Ruler.MinorTick = 'on';
% set(cb,'YTick',[-1 0  1]);
% ylabel(cb,'\DeltaF/F%','FontSize',12,'fontweight','bold')
% 
% 
%  figure('Position', [50 50 250 200])
%  imagesc(xform_FADCorr_mice_GSR(:,:,250)*100)
% colormap jet
% hold on
% imagesc(xform_WL,'AlphaData',1-ROI_GSR);
% axis image off
% title('Corrected FAD')
% cb = colorbar( 'EastOutside','AxisLocation','out',...
%     'FontSize',15,'fontweight','bold');
% cb.Ruler.MinorTick = 'on';
% set(cb,'YTick',[-1 0  1]);
% ylabel(cb,'\DeltaF/F%','FontSize',12,'fontweight','bold')
% 
% 
% 
% figure('Position', [50 50 250 200])
%  imagesc(xform_jrgeco1a_mice_GSR(:,:,250)*100)
% colormap jet
% hold on
% imagesc(xform_WL,'AlphaData',1-ROI_GSR);
% axis image off
% title('jRGECO1a')
% cb = colorbar( 'EastOutside','AxisLocation','out',...
%     'FontSize',15,'fontweight','bold');
% cb.Ruler.MinorTick = 'on';
% set(cb,'YTick',[-4 0  4]);
% ylabel(cb,'\DeltaF/F%','FontSize',12,'fontweight','bold')
% 
% 
%  figure('Position', [50 50 250 200])
%  imagesc(xform_jrgeco1aCorr_mice_GSR(:,:,250)*100)
% colormap jet
% hold on
% imagesc(xform_WL,'AlphaData',1-ROI_GSR);
% axis image off
% title('Corrected jRGECO1a')
% cb = colorbar( 'EastOutside','AxisLocation','out',...
%     'FontSize',15,'fontweight','bold');
% cb.Ruler.MinorTick = 'on';
% set(cb,'YTick',[-4 0  4]);
% ylabel(cb,'\DeltaF/F%','FontSize',12,'fontweight','bold')


colormap jet
 baseline = mean(xform_jrgeco1aCorr_mice_GSR(:,:,1:125),3);
peakMap_ROI = (mean(xform_jrgeco1aCorr_mice_GSR(:,:,126:250),3)*100-baseline*100);
imagesc(peakMap_ROI,[0 2])
max_ROI = prctile(peakMap_ROI(ROI),99);
threMask = peakMap_ROI>0.90*max_ROI;
axis image off
colorbar
title('Corr jRGECO1a')

hold on;imagesc(xform_WL,'AlphaData',1-mask);
% hold on
% contour(ROI,'k')
set(gca,'FontSize',40,'FontWeight','Bold')




figure
colormap jet
baseline = mean(xform_jrgeco1a_mice_GSR(:,:,1:125),3);
peakMap_ROI = (mean(xform_jrgeco1a_mice_GSR(:,:,126:250),3)*100-baseline*100);
max_ROI = prctile(peakMap_ROI(ROI),99);
threMask = peakMap_ROI>0.90*max_ROI;
imagesc(peakMap_ROI,[0 2])
axis image off
colorbar
title(' jRGECO1a')
hold on;imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',40,'FontWeight','Bold')
% hold on
% contour(ROI,'k')


figure
colormap jet
baseline = mean(xform_FADCorr_mice_GSR(:,:,1:125),3);
peakMap_ROI = (mean(xform_FADCorr_mice_GSR(:,:,126:250),3)*100-baseline*100);
max_ROI = prctile(peakMap_ROI(ROI),99);
threMask = peakMap_ROI>0.80*max_ROI;

imagesc(peakMap_ROI,[-1 1])
axis image off
colorbar
title('Corr FAD')

hold on;imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',40,'FontWeight','Bold')
% hold on
% contour(ROI,'k')

figure
colormap jet
baseline = mean(xform_FAD_mice_GSR(:,:,1:125),3);
peakMap_ROI = (mean(xform_FAD_mice_GSR(:,:,126:250),3)*100-baseline*100);
min_ROI = prctile(peakMap_ROI(ROI),1);
threMask = peakMap_ROI<0.80*min_ROI;
imagesc(peakMap_ROI,[-1 1])
axis image off
colorbar
title('FAD')
hold on;imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',40,'FontWeight','Bold')
% hold on
% contour(ROI,'k')

figure
total = squeeze(xform_datahb_mice_GSR(:,:,1,:)+xform_datahb_mice_GSR(:,:,2,:))*10^6;
colormap jet
baseline = mean(total(:,:,1:125),3);
peakMap_ROI = (mean(total(:,:,126:250),3)-baseline);
max_ROI = prctile(peakMap_ROI(ROI),99);
threMask = peakMap_ROI>0.80*max_ROI;

imagesc(peakMap_ROI,[0 2])
axis image off
colorbar
title('Total')

hold on;imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',40,'FontWeight','Bold')
% hold on
% contour(ROI,'k')