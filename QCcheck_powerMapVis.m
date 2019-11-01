function QCcheck_powerMapVis(powerMap,xform_isbrain,Name)
load('D:\OIS_Process\noVasculatureMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
xform_isbrain(isnan(xform_isbrain)) = 0;
maxVal = max(max(log10(powerMap.*xform_isbrain.*(double(leftMask)+double(rightMask)))));
minVal = min(min(log10(powerMap.*xform_isbrain.*(double(leftMask)+double(rightMask)))));
imagesc(log10(powerMap),[maxVal minVal]);

hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL');
imagesc(WL,'AlphaData',1-xform_isbrain.*cerebralMask);
axis image off
title(Name)
saveas(gcf,(strcat(Name,'_FCpowerMap.png')));
saveas(gcf,(strcat(Name,'_FCpowerMap.fig')));
        
