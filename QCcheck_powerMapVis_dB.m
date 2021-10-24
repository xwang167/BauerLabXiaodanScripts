function QCcheck_powerMapVis_dB(powerMap,xform_isbrain,saveDir,titleName)
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')

xform_isbrain(isnan(xform_isbrain)) = 0;
maxVal = max(max(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));

figure('Position', [50 50 200 300])
imagesc(10*log10(powerMap/maxVal),[-10 0]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
set(cb,'YTick',[-10 -5 0]);
ylabel(cb,'dB','FontSize',12,'fontweight','bold')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');

imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
 mycolormap = customcolormap(linspace(0,1,11), {'#a60126','#d7302a','#f36e43','#faac5d','#fedf8d','#fcffbf','#d7f08b','#a5d96b','#68bd60','#1a984e','#006936'});
colormap(mycolormap);
axis off;
axis image off
title(titleName,'fontsize',14,'Interpreter', 'none')
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap_dB.png')));
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap_dB.fig')));
        
