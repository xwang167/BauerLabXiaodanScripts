data=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF580-FDi01 Lot Code 618392-618394.txt');
lambda_580 = data(:,1);
spectrum_580 = squeeze(data(:,2));

data2 = dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-593_LP LotCode A18289-318381_340nm.txt');
lambda_593 = data2(:,1);
spectrum_593 = data2(:,2);

data3 = dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-500_LP LotCode 818104.txt');
lambda_500 = data3(:,1);
spectrum_500 = data3(:,2);

data4 = dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FESH0700_Transmission.txt');
lambda_700 = data4(:,1);
spectrum_700 = data4(:,2)/100;


lambda_400700 = 300:1000;
spectrum_400700 = zeros(1,701);
spectrum_400700(101:401) = 1;

figure
plot(lambda_400700,spectrum_400700,'k')
hold on
plot(lambda_500,spectrum_500,'g')
hold on
plot(lambda_593,spectrum_593,'r')
hold on
plot(lambda_580,spectrum_580,'color',[0.9290, 0.6940, 0.1250])
hold on
plot(lambda_700,spectrum_700,'m')
legend('400-700nm Input','500nm LP','593nm LP','580nm Dichoic','700 SP','location','northwest')
xlim([0 1000])


spectrum_580_interp = interp1(lambda_580,...
    spectrum_580,lambda_593,'pchip');

spectrum_500_interp = interp1(lambda_500,...
    spectrum_500,lambda_593,'pchip');

spectrum_700_interp = interp1(lambda_700,...
    spectrum_700,lambda_593,'pchip');

spectrum_400700_interp = interp1(lambda_400700,...
    spectrum_400700,lambda_593,'pchip');

figure
plot(lambda_593,spectrum_400700_interp,'k')
hold on
plot(lambda_593,spectrum_500_interp,'g')
hold on
plot(lambda_593,spectrum_593,'r')
hold on
plot(lambda_593,spectrum_580_interp,'color',[0.9290, 0.6940, 0.1250])
hold on
plot(lambda_593,spectrum_700_interp,'m')
legend('400-700nm Input','500nm LP','593nm LP','580nm Dichoic','700 SP','location','northwest')
xlim([0 1000])



S700_580_593 = -log10(spectrum_400700_interp.*spectrum_700_interp.*spectrum_580_interp.*spectrum_593);
S580_593 = -log10(spectrum_400700_interp.*spectrum_580_interp.*spectrum_593);

S700_580_500 = -log10(spectrum_400700_interp.*spectrum_700_interp.*(1-spectrum_580_interp).*spectrum_500_interp);
S580_500 = -log10(spectrum_400700_interp.*(1-spectrum_580_interp).*spectrum_500_interp);

figure
plot(lambda_593,S700_580_593,'m')
hold on
plot(lambda_593,S580_593,'k')
legend('700SP,580Di,593LP','580Di,593LP','location','northwest')
ylabel('OD')

figure
plot(lambda_593,S700_580_500,'m')
hold on
plot(lambda_593,S580_500,'k')
legend('700SP,580Di,500LP','580Di,500LP','location','northwest')
ylabel('OD')


% FAD RGECO emission

data5=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\fad_emission.txt');
lambda_FAD = data5(:,1);
spectrum_FAD = squeeze(data5(:,2));
spectrum_FAD = spectrum_FAD/max(spectrum_FAD);
data6=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jrgeco1a_emission.txt');
lambda_rgeco = data6(:,1);
spectrum_rgeco = squeeze(data6(:,2));
spectrum_FAD_interp = interp1(lambda_FAD,...
    spectrum_FAD,lambda_593,'pchip');
spectrum_rgeco_interp = interp1(lambda_rgeco,...
    spectrum_rgeco,lambda_593,'pchip');


SFAD_580_500 = spectrum_FAD_interp.*(1-spectrum_580_interp).*spectrum_500_interp;
SRGECO_580_593 = spectrum_rgeco_interp.*spectrum_580_interp.*spectrum_593;
save('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jRGECO1a_emission_580_593.txt','lambda_593','SRGECO_580_593','-ASCII')
T_RGECO = table(lambda_593,SRGECO_580_593);
writetable(T_RGECO,'C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jRGECO1a_emission_580_593.txt')

T_FAD_580_500 = table(lambda_593,SFAD_580_500);
writetable(T_FAD_580_500,'C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\FAD_emission_580_500.txt')
figure
plot(lambda_593,SFAD_580_500,'g')
hold on
plot(lambda_593,SRGECO_580_593,'m')
legend('FAD after 580 500','jRGECO1a after 580 593','location','southwest')

SFAD_580_500 = -log10(spectrum_FAD_interp.*(1-spectrum_580_interp).*spectrum_500_interp);
SRGECO_580_593 = -log10(spectrum_rgeco_interp.*spectrum_580_interp.*spectrum_593);
figure
plot(lambda_593,SFAD_580_500,'g')
hold on
plot(lambda_593,SRGECO_580_593,'m')
legend('FAD after 580 500','jRGECO1a after 580 593','location','northeast')




% EXCITATION LIGHT

data7=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex470_BP_Pol.txt');
lambda_blueEx = data7(:,1);
spectrum_blueEx = squeeze(data7(:,2));
spectrum_blueEx = spectrum_blueEx/max(spectrum_blueEx);

data8=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol.txt');
lambda_greenEx = data8(:,1);
spectrum_greenEx = squeeze(data8(:,2));
spectrum_greenEx = spectrum_greenEx/max(spectrum_greenEx);

spectrum_blueEx_interp = interp1(lambda_blueEx,...
    spectrum_blueEx,lambda_593,'pchip');
spectrum_greenEx_interp = interp1(lambda_greenEx,...
    spectrum_greenEx,lambda_593,'pchip');

figure
plot(lambda_593,spectrum_blueEx_interp,'b')
hold on
plot(lambda_593,spectrum_greenEx_interp,'g')
legend('Blue Excitation Light','Green Excitation Light')
ylim([0 1])

SblueEx_580_500 = spectrum_blueEx_interp.*(1-spectrum_580_interp).*spectrum_500_interp;
SgreenEx_580_593 = spectrum_greenEx_interp.*spectrum_580_interp.*spectrum_593;

T_blue_580_500 = table(lambda_593,SblueEx_580_500);
writetable(T_blue_580_500,'C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\TwoCam_Mightex470_BP_Pol_580_500.txt')


T_green_580_593 = table(lambda_593,SgreenEx_580_593);
writetable(T_green_580_593,'C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\TwoCam_Mightex525_BP_Pol_580_593.txt')



figure
plot(lambda_593,SblueEx_580_500,'b')
hold on
plot(lambda_593,SgreenEx_580_593,'g')
legend('blueEx after 580 500','greenEx after 580 593','location','northwest')

SblueEx_580_500 = -log10(spectrum_blueEx_interp.*(1-spectrum_580_interp).*spectrum_500_interp);
SgreenEx_580_593 = -log10(spectrum_greenEx_interp.*spectrum_580_interp.*spectrum_593);
figure
plot(lambda_593,SblueEx_580_500,'b')
hold on
plot(lambda_593,SgreenEx_580_593,'g')
legend('blueEx after 580 500','greenEx after 580 593','location','northeast')


%Reflectance light
data9=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol.txt');
lambda_green = data9(:,1);
spectrum_green = squeeze(data9(:,2));
spectrum_green = spectrum_green/max(spectrum_green);

data10=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_TL625_Pol.txt');
lambda_red = data10(:,1);
spectrum_red = squeeze(data10(:,2));
spectrum_red = spectrum_red/max(spectrum_red);

figure
plot(lambda_green,spectrum_green,'g')
hold on
plot(lambda_red,spectrum_red,'r')
legend('Green LED','Red LED')
ylim([0 1])

data11=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol_500-580.txt');
lambda_green_filter = data11(:,1);
spectrum_green_filter = squeeze(data11(:,2));
spectrum_green_filter = spectrum_green_filter/max(spectrum_green_filter);

data12=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_TL625_Pol_Longer593.txt');
lambda_red_filter = data12(:,1);
spectrum_red_filter = squeeze(data12(:,2));
spectrum_red_filter = spectrum_red_filter/max(spectrum_red_filter);
figure
plot(lambda_green_filter,spectrum_green_filter,'g')
hold on
plot(lambda_red_filter,spectrum_red_filter,'r')
legend('Green Reflectance','Red Reflectance')

spectrum_green_filter = -log10(spectrum_green_filter);
spectrum_red_filter = -log10(spectrum_red_filter);
figure
plot(lambda_green_filter,spectrum_green_filter,'g')
hold on
plot(lambda_red_filter,spectrum_red_filter,'r')
legend('Green Reflectance','Red Reflectance')
ylabel('OD')

% FAD
data13=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\fad_excitation.txt');
lambda_FADEx = data13(:,1);
spectrum_FADEx = squeeze(data13(:,2));
spectrum_FADEx = spectrum_FADEx./max(spectrum_FADEx);

SFAD_580_593 = spectrum_FAD_interp.*spectrum_580_interp.*spectrum_593;

T_FAD_580_593 = table(lambda_593,SFAD_580_593);
writetable(T_FAD_580_593,'C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\FAD_emission_580_593.txt')
figure
plot(lambda_593,SFAD_580_593,'g')
hold on
plot(lambda_593,spectrum_greenEx_interp,'k')
hold on
plot(lambda_FADEx,spectrum_FADEx,'b')
legend('FAD Camera 2 Filter','Green Ex','FAD Ex')


%RGECO vs. YFP
data14=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\YFP_excitation.txt');
lambda_YFPEx = data14(:,1);
spectrum_YFPEx = squeeze(data14(:,2));
spectrum_YFPEx = spectrum_YFPEx./max(spectrum_YFPEx);


data15=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\YFP_emission.txt');
lambda_YFPEm = data15(:,1);
spectrum_YFPEm = squeeze(data15(:,2));
spectrum_YFPEm = spectrum_YFPEm./max(spectrum_YFPEm);


data16=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jrgeco1a_excitation.txt');
lambda_RGECOEx = data16(:,1);
spectrum_RGECOEx = squeeze(data16(:,2));
spectrum_RGECOEx = spectrum_RGECOEx./max(spectrum_RGECOEx);


figure
plot(lambda_YFPEx,spectrum_YFPEx,'--','color',[1 0.5 0])
hold on
plot(lambda_YFPEm,spectrum_YFPEm,'-','color',[1 0.5 0])
hold on
plot(lambda_RGECOEx,spectrum_RGECOEx,'m--')
hold on
plot(lambda_rgeco,spectrum_rgeco,'m-')
legend('YFP Excitation','YFP Emission','RGECO Excitation','RGECO Emission','location','northwest')

data17=dlmread('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol_580_593.txt');
lambda = data17(:,1);
greenEx_Filtered = data17(:,2);


