load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', ...
    'Rs_FADCorr_Delta_mice', 'Rs_FADCorr_ISA_mice', 'Rs_FADCorr_inter_mice', ...
    'Rs_jrgeco1aCorr_Delta_mice', 'Rs_jrgeco1aCorr_ISA_mice', 'Rs_jrgeco1aCorr_inter_mice',...
    'Rs_total_Delta_mice', 'Rs_total_ISA_mice', 'Rs_total_inter_mice')

Awake_RGECO = nan(3,16*16);
Awake_RGECO(1,:) = reshape(Rs_jrgeco1aCorr_ISA_mice,1,[]);
Awake_RGECO(2,:) = reshape(Rs_jrgeco1aCorr_inter_mice,1,[]);
Awake_RGECO(3,:) = reshape(Rs_jrgeco1aCorr_Delta_mice,1,[]);
Awake_RGECO = real(Awake_RGECO);
Awake_RGECO_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_RGECO_Rho(ii,jj) =corr(Awake_RGECO(ii,:)' ,Awake_RGECO(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_RGECO_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('RGECO Awake')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('RGECO Awake')
 
 
 
 Awake_FAD = nan(3,16*16);
Awake_FAD(1,:) = reshape(Rs_FADCorr_ISA_mice,1,[]);
Awake_FAD(2,:) = reshape(Rs_FADCorr_inter_mice,1,[]);
Awake_FAD(3,:) = reshape(Rs_FADCorr_Delta_mice,1,[]);
Awake_FAD = real(Awake_FAD);
Awake_FAD_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_FAD_Rho(ii,jj) =corr(Awake_FAD(ii,:)' ,Awake_FAD(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_FAD_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('FAD Awake')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('FAD Awake')
 
 
 
 
 Awake_HbT = nan(3,16*16);
Awake_HbT(1,:) = reshape(Rs_total_ISA_mice,1,[]);
Awake_HbT(2,:) = reshape(Rs_total_inter_mice,1,[]);
Awake_HbT(3,:) = reshape(Rs_total_Delta_mice,1,[]);
Awake_HbT = real(Awake_HbT);
Awake_HbT_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_HbT_Rho(ii,jj) =corr(Awake_HbT(ii,:)' ,Awake_HbT(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_HbT_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('HbT Awake')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('HbT Awake')
 
 
 
 
 
 load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat', ...
     'Rs_FADCorr_Delta_mice', 'Rs_FADCorr_ISA_mice', 'Rs_FADCorr_inter_mice',...
     'Rs_jrgeco1aCorr_Delta_mice', 'Rs_jrgeco1aCorr_ISA_mice', 'Rs_jrgeco1aCorr_inter_mice', 'Rs_total_Delta_mice', 'Rs_total_ISA_mice', 'Rs_total_inter_mice')
 
Anes_RGECO = nan(3,16*16);
Anes_RGECO(1,:) = reshape(Rs_jrgeco1aCorr_ISA_mice,1,[]);
Anes_RGECO(2,:) = reshape(Rs_jrgeco1aCorr_inter_mice,1,[]);
Anes_RGECO(3,:) = reshape(Rs_jrgeco1aCorr_Delta_mice,1,[]);
Anes_RGECO = real(Anes_RGECO);
Anes_RGECO_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Anes_RGECO_Rho(ii,jj) =corr(Anes_RGECO(ii,:)' ,Anes_RGECO(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Anes_RGECO_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('RGECO Anes')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('RGECO Anes')
 
 
 
 Anes_FAD = nan(3,16*16);
Anes_FAD(1,:) = reshape(Rs_FADCorr_ISA_mice,1,[]);
Anes_FAD(2,:) = reshape(Rs_FADCorr_inter_mice,1,[]);
Anes_FAD(3,:) = reshape(Rs_FADCorr_Delta_mice,1,[]);
Anes_FAD = real(Anes_FAD);
Anes_FAD_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Anes_FAD_Rho(ii,jj) =corr(Anes_FAD(ii,:)' ,Anes_FAD(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Anes_FAD_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('FAD Anes')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('FAD Anes')

 
 
 
 
 
 
 
 
 Awake_Anes_RGECO_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_Anes_RGECO_Rho(ii,jj) =corr(Awake_RGECO(ii,:)' ,Anes_RGECO(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_Anes_RGECO_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('RGECO Anes')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('RGECO Awake')
 
 
 
 
 
  Awake_Anes_FAD_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_Anes_FAD_Rho(ii,jj) =corr(Awake_FAD(ii,:)' ,Anes_FAD(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_Anes_FAD_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('FAD Anes')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('FAD Awake')
 
 

 

Awake_Anes_HbT_Rho = nan(3,3);

for ii = 1:3
    for jj = 1:3
         Awake_Anes_HbT_Rho(ii,jj) =corr(Awake_HbT(ii,:)' ,Anes_HbT(jj,:)','Type','Spearman');
    end
end

figure
 imagesc(Awake_Anes_HbT_Rho,[0 1])
 colormap  jet
 axis image
 colorbar
 xticks(1:3)
 xticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 xlabel('HbT Anes')
 yticks(1:3)
 yticklabels({'0.009-0.08 Hz','0.08-0.4 Hz','0.4-4 hz'})
 ylabel('HbT Awake')