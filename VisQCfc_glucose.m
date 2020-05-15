recDate = '200313';
miceName = '-R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3';
sessionType = 'fc';
saveDir_cat = 'K:\Glucose\cat';
processedName_baseline = strcat(recDate,'-',miceName,'-',sessionType,'_baseline','.mat');


for run =9;
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
       visName = strcat(miceName,"-",sessionType,num2str(run));
    load(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
        'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
        'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
        'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
        'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
        'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
        'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
        'hz','xform_isbrain_mice')

         
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
visName = strcat(miceName,"-",sessionType,'_baseline');
    load(fullfile(saveDir_cat, processedName_baseline),'R_total_ISA_baseline','R_jrgeco1aCorr_ISA_baseline','R_FADCorr_ISA_baseline',...
        'R_total_Delta_baseline','R_jrgeco1aCorr_Delta_baseline','R_FADCorr_Delta_baseline',...
        'Rs_total_ISA_baseline','Rs_jrgeco1aCorr_ISA_baseline','Rs_FADCorr_ISA_baseline',...
        'Rs_total_Delta_baseline','Rs_jrgeco1aCorr_Delta_baseline','Rs_FADCorr_Delta_baseline',...
        'powerdata_average_oxy_baseline','powerdata_average_deoxy_baseline','powerdata_average_total_baseline','powerdata_average_jrgeco1aCorr_baseline','powerdata_average_FADCorr_baseline',...
        'powerdata_oxy_baseline','powerdata_deoxy_baseline','powerdata_total_baseline','powerdata_jrgeco1aCorr_baseline','powerdata_FADCorr_baseline',...
        'total_ISA_powerMap_baseline','jrgeco1aCorr_ISA_powerMap_baseline','FADCorr_ISA_powerMap_baseline',...
        'total_Delta_powerMap_baseline','jrgeco1aCorr_Delta_powerMap_baseline','FADCorr_Delta_powerMap_baseline',...
        'hz','xform_isbrain_mice')
            QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
