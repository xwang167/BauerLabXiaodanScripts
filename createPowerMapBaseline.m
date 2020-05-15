% baselineName = 'K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc-baseline.mat';
% 
% 
% jrgeco1aCorr_Delta_powerMap_mice_baseline = [];
% jrgeco1aCorr_ISA_powerMap_mice_baseline = [];
% 
% FADCorr_Delta_powerMap_mice_baseline = [];
% FADCorr_ISA_powerMap_mice_baseline = [];
% 
% total_Delta_powerMap_mice_baseline = [];
% total_ISA_powerMap_mice_baseline = [];
% 
% for ii = 1:3
%     name = strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat');
%     load(name, 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice', 'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'total_Delta_powerMap_mice','total_ISA_powerMap_mice','xform_isbrain_mice')
%     
%     jrgeco1aCorr_ISA_powerMap_mice_baseline = cat(3,jrgeco1aCorr_ISA_powerMap_mice_baseline,jrgeco1aCorr_ISA_powerMap_mice);
%     jrgeco1aCorr_Delta_powerMap_mice_baseline = cat(3,jrgeco1aCorr_Delta_powerMap_mice_baseline,jrgeco1aCorr_Delta_powerMap_mice);
%     
%     FADCorr_ISA_powerMap_mice_baseline = cat(3,FADCorr_ISA_powerMap_mice_baseline,FADCorr_ISA_powerMap_mice);
%     FADCorr_Delta_powerMap_mice_baseline = cat(3,FADCorr_Delta_powerMap_mice_baseline,FADCorr_Delta_powerMap_mice);
%     
%     total_ISA_powerMap_mice_baseline = cat(3,total_ISA_powerMap_mice_baseline,total_ISA_powerMap_mice);
%     total_Delta_powerMap_mice_baseline = cat(3,total_Delta_powerMap_mice_baseline,total_Delta_powerMap_mice);
%     
% end
% 
% jrgeco1aCorr_ISA_powerMap_mice_baseline = mean(jrgeco1aCorr_ISA_powerMap_mice_baseline,3);
% jrgeco1aCorr_Delta_powerMap_mice_baseline = mean(jrgeco1aCorr_Delta_powerMap_mice_baseline,3);
% 
% FADCorr_ISA_powerMap_mice_baseline = mean(FADCorr_ISA_powerMap_mice_baseline,3);
% FADCorr_Delta_powerMap_mice_baseline = mean(FADCorr_Delta_powerMap_mice_baseline,3);
% 
% total_ISA_powerMap_mice_baseline = mean(total_ISA_powerMap_mice_baseline,3);
% total_Delta_powerMap_mice_baseline = mean(total_Delta_powerMap_mice_baseline,3);


saveDir_cat ='K:\Glucose\cat\';
visName = 'Glucose_SeedFC-fc-baseline';
figure('units','normalized','outerposition',[0 0 0.5 0.7]);
    subplot(2,3,1)
    powerMapVis(jrgeco1aCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-2,-1)
    title('Corr jRGECO1a')
    
    subplot(2,3,2)
    
    
    powerMapVis(FADCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-2,-1)
     title('Corr FAD')
    
    subplot(2,3,3)
    
    powerMapVis(total_ISA_powerMap_mice_baseline,'(\muM)',-1.5,-0.5)
    
    title('Total')
    
    subplot(2,3,4)
     powerMapVis(jrgeco1aCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-3.5,-2.5)
    
    
    subplot(2,3,5)
    
    powerMapVis(FADCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-3.5,-2.5)
    
    
    subplot(2,3,6)
     powerMapVis(total_Delta_powerMap_mice_baseline,'(\muM)',-3,-2)
     
     suptitle('Glucose Power Map for Baseline')
     
     saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.png'));
     saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.fig'));


save(baselineName,'jrgeco1aCorr_Delta_powerMap_mice_baseline','jrgeco1aCorr_ISA_powerMap_mice_baseline',...
    'FADCorr_Delta_powerMap_mice_baseline','FADCorr_ISA_powerMap_mice_baseline',...
    'total_Delta_powerMap_mice_baseline','total_ISA_powerMap_mice_baseline')





function powerMapVis(powerMap,unit,minVal,maxVal)
load('D:\OIS_Process\noVasculatureMask.mat')

imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
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
%title(titleName,'fontsize',14,'Interpreter', 'none')
end