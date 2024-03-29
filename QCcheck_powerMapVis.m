function QCcheck_powerMapVis(powerMap,xform_isbrain,unit,saveDir,titleName)
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat")
mask = leftMask_small+rightMask_small;
load('CerebMask.mat')

xform_isbrain(isnan(xform_isbrain)) = 0;
% maxVal = max(max(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
% minVal = min(min(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
maxVal = max(max(log10(powerMap(logical(xform_isbrain.*(double(mask)))))));
minVal = min(min(log10(powerMap(logical(xform_isbrain.*(double(mask)))))));
%figure('Position', [50 50 200 300])
figure
% imagesc(powerMap,[0.5 1.5]);
% colorbar

% imagesc(powerMap,[minVal maxVal]);
% cb = colorbar();
% cb.Ruler.MinorTick = 'on';
% ylabel(cb,[unit,'^2'],'FontSize',12)

imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
%set(cb,'YTick',[-0.25 0 0.25]);
ylabel(cb,['log_1_0(',unit,'^2)'],'FontSize',12,'fontweight','bold')
hold on
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');

imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
 mycolormap = customcolormap(linspace(0,1,11), {'#a60126','#d7302a','#f36e43','#faac5d','#fedf8d','#fcffbf','#d7f08b','#a5d96b','#68bd60','#1a984e','#006936'});
colormap(mycolormap);
axis off;
axis image off
title(titleName,'fontsize',14,'Interpreter', 'none')
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.png')));
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.fig')));
        
