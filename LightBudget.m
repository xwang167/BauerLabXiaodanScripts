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



S700_580_593 = spectrum_400700_interp.*spectrum_700_interp.*spectrum_580_interp.*spectrum_593;
S580_593 = spectrum_400700_interp.*spectrum_580_interp.*spectrum_593;

S700_580_500 = spectrum_400700_interp.*spectrum_700_interp.*(1-spectrum_580_interp).*spectrum_500_interp;
S580_500 = spectrum_400700_interp.*(1-spectrum_580_interp).*spectrum_500_interp;

figure
plot(lambda_593,S700_580_593,'m')
hold on
plot(lambda_593,S580_593,'k')
legend('700SP,580Di,593LP','580Di,593LP','location','northwest')

figure
plot(lambda_593,S700_580_500,'m')
hold on
plot(lambda_593,S580_500,'k')
legend('700SP,580Di,500LP','580Di,500LP','location','northwest')