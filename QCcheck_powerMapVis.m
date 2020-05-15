function QCcheck_powerMapVis(powerMap,xform_isbrain,unit,saveDir,titleName)
load('D:\OIS_Process\noVasculatureMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')

xform_isbrain(isnan(xform_isbrain)) = 0;
% maxVal = max(max(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
% minVal = min(min(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
maxVal = max(max(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
minVal = min(min(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
figure('Position', [50 50 200 300])
% imagesc(powerMap,[0.5 1.5]);
% colorbar

% imagesc(powerMap,[minVal maxVal]);
% cb = colorbar();
% cb.Ruler.MinorTick = 'on';
% ylabel(cb,[unit,'^2'],'FontSize',12)

imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','in',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
%set(cb,'YTick',[-0.25 0 0.25]);
ylabel(cb,['log_1_0(',unit,'^2)'],'FontSize',12,'fontweight','bold')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
title(titleName,'fontsize',14,'Interpreter', 'none')
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.png')));
saveas(gcf,fullfile(saveDir,strcat(titleName,'_FCpowerMap.fig')));
        
