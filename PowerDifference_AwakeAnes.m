load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
jrgeco1aCorr_ISA_powerMap_mice_diff = (jrgeco1aCorr_ISA_powerMap_mice_awake - jrgeco1aCorr_ISA_powerMap_mice_anes)./jrgeco1aCorr_ISA_powerMap_mice_anes;
jrgeco1aCorr_Delta_powerMap_mice_diff = (jrgeco1aCorr_Delta_powerMap_mice_awake -jrgeco1aCorr_Delta_powerMap_mice_anes)./jrgeco1aCorr_Delta_powerMap_mice_anes;

FADCorr_ISA_powerMap_mice_diff =  (FADCorr_ISA_powerMap_mice_awake - FADCorr_ISA_powerMap_mice_anes)./FADCorr_ISA_powerMap_mice_anes;
FADCorr_Delta_powerMap_mice_diff = (FADCorr_Delta_powerMap_mice_awake - FADCorr_Delta_powerMap_mice_anes)./FADCorr_Delta_powerMap_mice_anes;

total_ISA_powerMap_mice_diff = (total_ISA_powerMap_mice_awake - total_ISA_powerMap_mice_anes)./total_ISA_powerMap_mice_anes;
total_Delta_powerMap_mice_diff =  (total_Delta_powerMap_mice_awake - total_Delta_powerMap_mice_anes)./total_Delta_powerMap_mice_anes;

figure
imagesc(total_Delta_powerMap_mice_diff*100,[-150 150]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-150 0 150]);
axis image off
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('total Delta Diff')
figure
imagesc(total_ISA_powerMap_mice_diff*100,[-2500 2500]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-2500 0 2500]);
axis image off
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('total ISA Diff')
figure
imagesc(FADCorr_Delta_powerMap_mice_diff*100,[-100,100]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-100 0 100]);
axis image off
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('FADCorr Delta Diff')
figure
imagesc(FADCorr_ISA_powerMap_mice_diff*100,[-400,400]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-400 0 400]);
axis image off
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('FADCorr ISA Diff')
figure
imagesc(jrgeco1aCorr_Delta_powerMap_mice_diff*100,[-200 200]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-200 0 200]);
axis image off
colormap jet
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('jrgeco1aCorr Delta Diff')
figure
imagesc(jrgeco1aCorr_ISA_powerMap_mice_diff*100,[-700 700]);
axis image off
colormap jet
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
set(cb,'YTick',[-700 0 700]);
hold on
imagesc(xform_WL,'AlphaData',1-mask);
title('jrgeco1aCorr ISA Diff')