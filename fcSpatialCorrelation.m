


saveDir_cat = 'L:\RGECO\cat';
processedName_mice_awake = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc';
processedName_mice_anes = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc';
load(fullfile(saveDir_cat, processedName_mice_awake),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')

contrasts = ["jrgeco1aCorr","FADCorr","total"];
freqBand = ["ISA","Delta"];
A =  ones(16);
triup = triu(A,1);


%%%no need to normalize

for ii = 1:3
    for jj = 1:2
        eval(strcat('Rs_',contrasts(ii),'_',freqBand(jj),'_mice = normr(transpose(','Rs_',contrasts(ii),'_',freqBand(jj),'_mice(triup)));'))
    end
end

for ii= 1:3
     eval(strcat('Rs_',contrasts(ii),'_mice_spcorr = Rs_',contrasts(ii),'_ISA_mice_norm * transpose(Rs_',contrasts(ii),'_Delta_mice_norm);'))
end

for ii = 1:3
  
        eval(strcat('R_',contrasts(ii),'_mice_spcorr = normr(transpose(','Rs_',contrasts(ii),'_',freqBand(jj),'_mice(triup)));'))
 
end

for ii = 1:3
    
           for ii = 1:16
           end
 
end