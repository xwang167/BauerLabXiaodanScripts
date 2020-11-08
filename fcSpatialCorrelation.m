load(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')

contrasts = ["jrgeco1aCorr","FADCorr","total"];
freqBand = ["ISA","Delta"];
A =  ones(16);
triup = triu(A);
B = ones(1,16);
D = diag(B);
triup = logical(triup-D);

for ii = 1:3
    for jj = 1:2
        eval(strcat('Rs_',contrasts(ii),'_',freqBand(jj),'_mice_norm = normr(transpose(','Rs_',contrasts(ii),'_',freqBand(jj),'_mice(triup)));'))
    end
end

for ii= 1:3
     eval(strcat('Rs_',contrasts(ii),'_mice_spcorr = Rs_',contrasts(ii),'_ISA_mice_norm * transpose(Rs_',contrasts(ii),'_Delta_mice_norm);'))
end

flip_total_ISA = flip(Rs_total_ISA_mice,1);

flip_total_ISA_norm =  normr(transpose(flip_total_ISA(triup)));

corr_self = Rs_total_ISA_mice_norm*transpose(Rs_total_ISA_mice_norm);
corr_withFlip =  Rs_total_ISA_mice_norm*transpose(flip_total_ISA_norm);