    leftData = cell(2,1);
    leftData{1} = powerdata_average_jrgeco1aCorr_mice;
    leftData{2} = powerdata_average_FADCorr_mice;
    
    rightData = cell(1,1);
    rightData{1} = powerdata_average_total_mice;
    
    leftLabel = 'Fluor(dB \DeltaF/F%)^2/Hz)';
    rightLabel = 'Hb(dB \muM^2/Hz)';
    leftLineStyle = {'m-','g-'};
    rightLineStyle= {'k-'};
    legendName = ["Corrected jRGECO1a","Corrected FAD","HbT"];
    saveDir_cat = 'L:\RGECO\cat';
    visName = 'test';
    QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve_average'))
 grid on
 title('Anesthetized')