directory = "C:\Users\xiaodanwang\Documents\GitHub\newpipeline_new\Functions_and_Wrappers\+bauerParams\";
[spectra_jRGECOEmission, wavelength_jRGECOEmission] = getSpectra(strcat(directory,"probeSpectra\jrgeco1a_emission.txt"));
[spectra_700, wavelength_700] = getSpectra(strcat(directory,"filterTransmission\FESH0700_Transmission.txt"));
[spectra_580, wavelength_580] = getSpectra(strcat(directory,"filterTransmission\FF580-FDi01 Lot Code 618392-618394.txt"));
[spectra_593, wavelength_593] = getSpectra(strcat(directory,"filterTransmission\FF01-593_LP LotCode A18289-318381.txt"));

figure
plot(wavelength_jRGECOEmission{1},spectra_jRGECOEmission{1},'m')
hold on
yyaxis right
plot(wavelength_700{1},spectra_700{1},'-','color',[0.6350 0.0780 0.1840])
hold on
plot(wavelength_580{1},spectra_580{1}*100,'-','color',[0.9290 0.6940 0.1250])
hold on
plot(wavelength_593{1},spectra_593{1}*100,'r-')
xlim([200 800])
xlabel('Wavelength (nm)')
ylabel('Transmission(%)')
yyaxis left
ylabel('Emission Light')
legend('RGECO Emit','700nm SP', '580 Di','593nm LP','location','northwest')

wavelength = 340:0.5:710;
spectra_jRGECOEmission_interp = interp1(wavelength_jRGECOEmission{1},spectra_jRGECOEmission{1},wavelength);
spectra_700_interp = interp1(wavelength_700{1},spectra_700{1},wavelength);
spectra_580_interp = interp1(wavelength_580{1},spectra_580{1},wavelength);
spectra_593_interp = interp1(wavelength_593{1},spectra_593{1},wavelength);


figure
plot(wavelength,spectra_jRGECOEmission_interp,'m')
hold on
yyaxis right
plot(wavelength,spectra_700_interp,'-','color',[0.6350 0.0780 0.1840])
hold on
plot(wavelength,spectra_580_interp*100,'-','color',[0.9290 0.6940 0.1250])
hold on
plot(wavelength,spectra_593_interp*100,'r-')
xlabel('Wavelength (nm)')
ylabel('Transmission(%)')
yyaxis left
ylabel('Emission Light')

spectra_jRGECOEmission_700_580_593 = spectra_jRGECOEmission_interp.*spectra_700_interp.*spectra_580_interp.*spectra_593_interp;
figure
plot(wavelength,spectra_jRGECOEmission_700_5800_593,'k-')
xlabel('Wavelength (nm)')
data = cat(2,wavelength',spectra_jRGECOEmission_700_580_593');
save('C:\Users\xiaodanwang\Documents\GitHub\newpipeline_new\Functions_and_Wrappers\+bauerParams\probeSpectra\jregeco1a_emission_700_580_593.txt',...
    'data', '-ASCII')

load('220704-N24M778-WhiskerOnly-stim1-dataHb.mat', 'xform_datahb')
load('220704-N24M778-WhiskerOnly-stim1-dataFluor.mat', 'xform_datafluor')
load('220704-N24M778-WhiskerOnly-stim1-dataFluor.mat', 'E_in', 'op_in')
dpIn = op_in.dpf/2;
[op_out_filter, E_out_filter] = getHbOpticalProperties("C:\Users\xiaodanwang\Documents\GitHub\newpipeline_new\Functions_and_Wrappers\+bauerParams\probeSpectra\jregeco1a_emission_700_580_593.txt");
dpOut_filter = op_out_filter.dpf/2;

xform_datafluorCorr_filter = correctHb_differentBeta(xform_datafluor,xform_datahb,[E_in(1) E_out_filter(1)],[E_in(2) E_out_filter(2)],dpIn,dpOut_filter,1,1);
xform_datafluorCorr_filter = reshape(xform_datafluorCorr_filter,128,128,600,10);
xform_datafluorCorr_filter_average = mean(xform_datafluorCorr_filter,4);

load('220704-N24M778-WhiskerOnly-LandmarksandMask.mat', 'xform_StimROIMask')

xform_datafluorCorr_filter_average = reshape(xform_datafluorCorr_filter_average,128*128,[]);
ROI_filter = xform_datafluorCorr_filter_average(logical(xform_StimROIMask(:)),:);
ROI_filter = mean(ROI_filter,1);
ROI_filter = (ROI_filter-mean(ROI_filter(1:100)))*100; 


load('220704-N24M778-WhiskerOnly-stim1-dataFluor.mat', 'xform_datafluorCorr')
xform_datafluorCorr = reshape(xform_datafluorCorr,128,128,600,10);
xform_datafluorCorr_average = mean(xform_datafluorCorr,4);
xform_datafluorCorr_average = reshape(xform_datafluorCorr_average,128*128,[]);
ROI = xform_datafluorCorr_average(logical(xform_StimROIMask(:)),:);
ROI = mean(ROI,1);
ROI = (ROI-mean(ROI(1:100)))*100;

figure
plot((1:600)/20,ROI, 'r-')
hold on
plot((1:600)/20,ROI_filter,'k-')
xlabel('Time(s)')
ylabel('\DeltaF/F%')


figure
plot((1:600)/20,ROI_filter./ROI, 'b')
xlabel('Time(s)')
ylabel('Filtered/Non-fitlered')


figure
plot((1:600)/20,ROI_filter-ROI, 'm')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Filter - Non-filter')

