data=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\fad_emission.txt');
lambda_FAD = data(:,1);
spectrum_FAD = squeeze(data(:,2));
data2=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jrgeco1a_emission.txt');
lambda_rgeco = data2(:,1);
spectrum_rgeco = squeeze(data2(:,2));

figure
plot(lambda_FAD,spectrum_FAD/max(spectrum_FAD),'g')
hold on
plot(lambda_rgeco,spectrum_rgeco,'m')
title('Emission Spectra')
legend('FAD','jRGECO1a')