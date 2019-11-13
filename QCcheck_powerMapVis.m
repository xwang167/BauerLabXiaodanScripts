function QCcheck_powerMapVis(powerMap,xform_isbrain,unit,saveDir,titleName)
load('D:\OIS_Process\noVasculatureMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')

xform_isbrain(isnan(xform_isbrain)) = 0;
maxVal = max(max(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
minVal = min(min(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
figure
imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar();
cb.Ruler.MinorTick = 'on';
ylabel(cb,['log10(',unit,'^2)'],'FontSize',12)
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL');
imagesc(WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
title(titleName,'fontsize',14,'Interpreter', 'none')
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.png')));
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.fig')));
        
