figure
imagesc(jrgeco1aCorr_ISA_powerMap_mice)
colormap jet
title('ISA jrgeco1aCorr map in linear scale')
axis image off
ylabel('(\DeltaF/F%)^2')
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
set(cb,'YTick',[10^(-1.8)  10^(-0.8)]);
ylabel(cb,'(\DeltaF/F%)^2')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);