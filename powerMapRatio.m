for ii = 1:9
    load(strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat'),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
        'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
    
    figure('units','normalized','outerposition',[0 0 0.5 0.7]);
    subplot(2,3,1)
    powerMapRatioVis(jrgeco1aCorr_ISA_powerMap_mice./jrgeco1aCorr_ISA_powerMap_mice_baseline,0.5,1.5)
    title('Corr jRGECO1a')
    
    subplot(2,3,2)
    powerMapRatioVis(FADCorr_ISA_powerMap_mice./FADCorr_ISA_powerMap_mice_baseline,0.5,1.5)
    title('Corr FAD')
    
    subplot(2,3,3)
    powerMapRatioVis(total_ISA_powerMap_mice./total_ISA_powerMap_mice_baseline,0.5,1.5)
    title('Total')
    
    subplot(2,3,4)
    powerMapRatioVis(jrgeco1aCorr_Delta_powerMap_mice./jrgeco1aCorr_Delta_powerMap_mice_baseline,0.5,1.5)
    
    
    subplot(2,3,5)
    
    powerMapRatioVis(FADCorr_Delta_powerMap_mice./FADCorr_Delta_powerMap_mice_baseline,0.5,1.5)
    
    
    subplot(2,3,6)
    powerMapRatioVis(total_Delta_powerMap_mice./total_Delta_powerMap_mice_baseline,0.5,1.5)
    
    suptitle(strcat('Glucose Power Map Ratio over Baseline, fc',num2str(ii)));
    saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMapRatio-fc',num2str(ii),'.png'));
    saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMapRatio-fc',num2str(ii),'fig'));
end

function powerMapRatioVis(powerMapRatio,minVal,maxVal)
load('D:\OIS_Process\noVasculatureMask.mat')
imagesc(powerMapRatio,[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
%set(cb,'YTick',[-0.25 0 0.25]);
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
%title(titleName,'fontsize',14,'Interpreter', 'none')
end


