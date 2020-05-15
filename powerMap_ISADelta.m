for ii = 1:9
    
    saveDir_cat = 'K:\Glucose\cat\';
    load(strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat'),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
        'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
        'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
        'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice','xform_isbrain_mice')
   visName = strcat('Glucose_SeedFC-fc',num2str(ii));
  refseeds=GetReferenceSeeds;
                refseeds = refseeds(1:14,:);
                refseeds(3,1) = 42;
                refseeds(3,2) = 88;
                refseeds(4,1) = 87;
                refseeds(4,2) = 88;
                refseeds(9,1) = 18;
                refseeds(9,2) = 66;
                refseeds(10,1) = 111;
                refseeds(10,2) = 66;
        
      QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)

end




for ii = 1:9
    load(strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat'),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
        'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
   
  figure('units','normalized','outerposition',[0 0 0.5 0.7]);
    subplot(2,3,1)
    powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-2,-1)
    title('Corr jRGECO1a')
    
    subplot(2,3,2)
    
    
    powerMapVis(FADCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-2,-1)
     title('Corr FAD')
    
    subplot(2,3,3)
    
    powerMapVis(total_ISA_powerMap_mice,'(\muM)',-1.5,-0.5)
    
    title('Total')
    
    subplot(2,3,4)
     powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-3.5,-2.5)
    
    
    subplot(2,3,5)
    
    powerMapVis(FADCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-3.5,-2.5)
    
    
    subplot(2,3,6)
     powerMapVis(total_Delta_powerMap_mice,'(\muM)',-3,-2)
     
     suptitle(strcat('Glucose Power Map',num2str(ii)))
     
     saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(ii),'.png'));
     saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(ii),'fig'));
end







function powerMapVis(powerMap,unit,minVal,maxVal)
load('D:\OIS_Process\noVasculatureMask.mat')
%xform_isbrain(isnan(xform_isbrain)) = 0;
% maxVal = max(max(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
% minVal = min(min(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask))))));
% maxVal = max(max(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
% minVal = min(min(log10(powerMap(logical(xform_isbrain.*(double(leftMask)+double(rightMask)))))));
% figure('Position', [50 50 200 300])
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
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
%title(titleName,'fontsize',14,'Interpreter', 'none')
end



        