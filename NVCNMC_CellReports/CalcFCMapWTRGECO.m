
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_newOrder.mat')
R_FADCorr_Delta_mice_RGECO = R_FADCorr_Delta_mice;
clear R_FADCorr_Delta_mice
R_FADCorr_ISA_mice_RGECO = R_FADCorr_ISA_mice;
clear R_FADCorr_ISA_mice
R_jrgeco1aCorr_Delta_mice_RGECO =  R_jrgeco1aCorr_Delta_mice;
clear R_jrgeco1aCorr_Delta_mice
R_jrgeco1aCorr_ISA_mice_RGECO = R_jrgeco1aCorr_ISA_mice;
clear R_jrgeco1aCorr_ISA_mice
R_total_Delta_mice_RGECO = R_total_Delta_mice;
clear R_total_Delta_mice
R_total_ISA_mice_RGECO = R_total_ISA_mice;
clear R_total_ISA_mice
Rs_FADCorr_Delta_mice_RGECO = Rs_FADCorr_Delta_mice;
clear Rs_FADCorr_Delta_mice
Rs_FADCorr_ISA_mice_RGECO = Rs_FADCorr_ISA_mice;
clear Rs_FADCorr_ISA_mice
Rs_jrgeco1aCorr_Delta_mice_RGECO = Rs_jrgeco1aCorr_Delta_mice;
clear Rs_jrgeco1aCorr_Delta_mice
Rs_jrgeco1aCorr_ISA_mice_RGECO = Rs_jrgeco1aCorr_ISA_mice;
clear Rs_jrgeco1aCorr_ISA_mice
Rs_total_Delta_mice_RGECO = Rs_total_Delta_mice;
clear Rs_total_Delta_mice
Rs_total_ISA_mice_RGECO = Rs_total_ISA_mice;
clear Rs_total_ISA_mice
load('X:\XW\Paper\WT\cat\210820--W30M1-W30M2-W30M3-fc.mat', 'R_FADCorr_Delta_mice', 'R_FADCorr_ISA_mice', 'R_jrgeco1aCorr_Delta_mice', 'R_jrgeco1aCorr_ISA_mice', 'R_total_Delta_mice', 'R_total_ISA_mice', 'Rs_FADCorr_Delta_mice', 'Rs_FADCorr_ISA_mice', 'Rs_jrgeco1aCorr_Delta_mice', 'Rs_jrgeco1aCorr_ISA_mice', 'Rs_total_Delta_mice', 'Rs_total_ISA_mice')

 refseeds=GetReferenceSeeds;   
    xform_isbrain_mice =ones(128,128);
    xform_isbrain_mice(isnan(R_total_Delta_mice(:,:,1))) = 0;   
    xform_isbrain_mice(isnan(R_total_Delta_mice_RGECO(:,:,1))) = 0;
    visName = 'Awake WT-RGECO';
    saveDir_cat = 'X:\XW\Paper\WT\cat';
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice-R_jrgeco1aCorr_ISA_mice_RGECO, Rs_jrgeco1aCorr_ISA_mice-Rs_jrgeco1aCorr_ISA_mice_RGECO,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice-R_FADCorr_ISA_mice_RGECO, Rs_FADCorr_ISA_mice-Rs_FADCorr_ISA_mice_RGECO,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_ISA_mice-R_total_ISA_mice_RGECO, Rs_total_ISA_mice-Rs_total_ISA_mice_RGECO,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice-R_jrgeco1aCorr_Delta_mice_RGECO, Rs_jrgeco1aCorr_Delta_mice-Rs_jrgeco1aCorr_Delta_mice_RGECO,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice-R_FADCorr_Delta_mice_RGECO, Rs_FADCorr_Delta_mice-Rs_FADCorr_Delta_mice_RGECO,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_Delta_mice-R_total_Delta_mice_RGECO, Rs_total_Delta_mice-Rs_total_Delta_mice_RGECO,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    close all
    
    
load('191030--R5M2285-anes-R5M2286-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_newOrder.mat')
R_FADCorr_Delta_mice_RGECO = R_FADCorr_Delta_mice;
clear R_FADCorr_Delta_mice
R_FADCorr_ISA_mice_RGECO = R_FADCorr_ISA_mice;
clear R_FADCorr_ISA_mice
R_jrgeco1aCorr_Delta_mice_RGECO =  R_jrgeco1aCorr_Delta_mice;
clear R_jrgeco1aCorr_Delta_mice
R_jrgeco1aCorr_ISA_mice_RGECO = R_jrgeco1aCorr_ISA_mice;
clear R_jrgeco1aCorr_ISA_mice
R_total_Delta_mice_RGECO = R_total_Delta_mice;
clear R_total_Delta_mice
R_total_ISA_mice_RGECO = R_total_ISA_mice;
clear R_total_ISA_mice
Rs_FADCorr_Delta_mice_RGECO = Rs_FADCorr_Delta_mice;
clear Rs_FADCorr_Delta_mice
Rs_FADCorr_ISA_mice_RGECO = Rs_FADCorr_ISA_mice;
clear Rs_FADCorr_ISA_mice
Rs_jrgeco1aCorr_Delta_mice_RGECO = Rs_jrgeco1aCorr_Delta_mice;
clear Rs_jrgeco1aCorr_Delta_mice
Rs_jrgeco1aCorr_ISA_mice_RGECO = Rs_jrgeco1aCorr_ISA_mice;
clear Rs_jrgeco1aCorr_ISA_mice
Rs_total_Delta_mice_RGECO = Rs_total_Delta_mice;
clear Rs_total_Delta_mice
Rs_total_ISA_mice_RGECO = Rs_total_ISA_mice;
clear Rs_total_ISA_mice
 load('X:\XW\Paper\WT\cat\210820--W30M1-anes-W30M2-anes-W30M3-anes-fc.mat', 'R_FADCorr_Delta_mice', 'R_FADCorr_ISA_mice', 'R_jrgeco1aCorr_Delta_mice', 'R_jrgeco1aCorr_ISA_mice', 'R_total_Delta_mice', 'R_total_ISA_mice', 'Rs_FADCorr_Delta_mice', 'Rs_FADCorr_ISA_mice', 'Rs_jrgeco1aCorr_Delta_mice', 'Rs_jrgeco1aCorr_ISA_mice', 'Rs_total_Delta_mice', 'Rs_total_ISA_mice')

  refseeds=GetReferenceSeeds;   
    xform_isbrain_mice =ones(128,128);
    xform_isbrain_mice(isnan(R_total_Delta_mice(:,:,1))) = 0;   
    xform_isbrain_mice(isnan(R_total_Delta_mice_RGECO(:,:,1))) = 0;
    visName = 'Anes WT-RGECO';
    saveDir_cat = 'X:\XW\Paper\WT\cat';
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice-R_jrgeco1aCorr_ISA_mice_RGECO, Rs_jrgeco1aCorr_ISA_mice-Rs_jrgeco1aCorr_ISA_mice_RGECO,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice-R_FADCorr_ISA_mice_RGECO, Rs_FADCorr_ISA_mice-Rs_FADCorr_ISA_mice_RGECO,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_ISA_mice-R_total_ISA_mice_RGECO, Rs_total_ISA_mice-Rs_total_ISA_mice_RGECO,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice-R_jrgeco1aCorr_Delta_mice_RGECO, Rs_jrgeco1aCorr_Delta_mice-Rs_jrgeco1aCorr_Delta_mice_RGECO,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice-R_FADCorr_Delta_mice_RGECO, Rs_FADCorr_Delta_mice-Rs_FADCorr_Delta_mice_RGECO,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_Delta_mice-R_total_Delta_mice_RGECO, Rs_total_Delta_mice-Rs_total_Delta_mice_RGECO,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    close all