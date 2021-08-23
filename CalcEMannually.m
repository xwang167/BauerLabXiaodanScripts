data=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\prahl_extinct_coef.txt');
lambda_extCoeff = data(:,1);
extCoeff = squeeze(data(:,2:3));

data2 = dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\East3410OIS1_TL_470_Pol.txt');
lambda_spectrum = data2(:,1);
spectrum = data2(:,2);


% Interpollate from Spectrometer Wavelengths to Reference Wavelengths
spectrum_interp = interp1(lambda_spectrum,...
    spectrum,lambda_extCoeff,'pchip');

% Subtract Spectrum baseline
base = mean(spectrum_interp(1:50));
spectrum_noBaseline = spectrum_interp - base;

% Normalize
spectrum_norm = spectrum_noBaseline./sum(spectrum_noBaseline);

% Zero Out Noise
spectrum_zeroNoise = spectrum_norm;
spectrum_zeroNoise(spectrum_zeroNoise<0.05*max(spectrum_zeroNoise))=0;

% Spectroscopy Matrix
E=extCoeff'*spectrum_zeroNoise;


figure
plot(lambda_extCoeff,extCoeff(:,1),'r')
hold on
plot(lambda_extCoeff,extCoeff(:,2),'b')
yyaxis right
hold on
plot(lambda_spectrum,spectrum,'k-');



figure
scatter(lambda_extCoeff,extCoeff(:,1),10,'r','filled')
hold on
scatter(lambda_extCoeff,extCoeff(:,2),10,'b','filled')
yyaxis right
hold on
scatter(lambda_spectrum,spectrum,10,'k','filled');
hold on
scatter(lambda_extCoeff,spectrum_interp,10,'m','filled');
legend('Oxy ExtCoeff','DeOxy ExtCoeff','Line','Line','Line','Blue Spectrum','Interp Blue Spectrum','Line')
xline(448);
xline(452);
xline(454)
xline(450)