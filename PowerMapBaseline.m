baselineName = 'K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc-baseline.mat';
load(baselineName,'jrgeco1aCorr_Delta_powerMap_mice_baseline','jrgeco1aCorr_ISA_powerMap_mice_baseline',...
    'FADCorr_Delta_powerMap_mice_baseline','FADCorr_ISA_powerMap_mice_baseline',...
    'total_Delta_powerMap_mice_baseline','total_ISA_powerMap_mice_baseline')
saveDir_cat ='K:\Glucose\cat\';
visName = 'Glucose_SeedFC-fc-baseline';
figure('units','normalized','outerposition',[0 0 0.5 0.7]);
subplot(2,3,1)
powerMapVis(jrgeco1aCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-2,-1)
title('Corr jRGECO1a')

subplot(2,3,2)


powerMapVis(FADCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-3.1,-2.1)
title('Corr FAD')

subplot(2,3,3)

powerMapVis(total_ISA_powerMap_mice_baseline,'(\muM)',-1.7,-0.7)

title('Total')

subplot(2,3,4)
powerMapVis(jrgeco1aCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-3.5,-2.5)


subplot(2,3,5)

powerMapVis(FADCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-4.7,-3.7)


subplot(2,3,6)
powerMapVis(total_Delta_powerMap_mice_baseline,'(\muM)',-4,-3)

suptitle('Glucose Power Map for Baseline')

saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.png'));
saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.fig'));






function powerMapVis(powerMap,unit,minVal,maxVal)
load('D:\OIS_Process\noVasculatureMask.mat')

imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
set(cb,'YTick',[minVal (minVal+maxVal)/2 maxVal]);
ylabel(cb,['log_1_0(',unit,'^2)'],'FontSize',12,'fontweight','bold')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
%title(titleName,'fontsize',14,'Interpreter', 'none')
end