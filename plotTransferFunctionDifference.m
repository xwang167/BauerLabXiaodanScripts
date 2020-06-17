fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FESH0700_Transmission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2}/100;
transmission_700 = interp1(lambda,transmission,340:760);
OD = -log10(transmission);
figure;
h(1) = plot(lambda,OD,'r');
xlim([350 750])
xticks(350:50:750);


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF580-FDi01 Lot Code 618392-618394.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
transmission_580 = interp1(lambda,transmission,340:760);
OD = -log10(transmission);
hold on
h(2) = plot(lambda,OD,'y');
xlim([350 750])
xticks(350:50:750);


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-593_LP LotCode A18289-318381.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
transmission_593 = interp1(lambda,transmission,340:760);
OD = -log10(transmission);
hold on
h(3) = plot(lambda,OD,'Color',[ 0.9300 0.4100 0.1700]);
xlim([350 750])
xticks(350:50:750);

fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-500_LP LotCode 818104.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
transmission_500 = interp1(lambda,transmission,340:760);
OD = -log10(transmission);
hold on
h(4)= plot(lambda,OD,'g');
xlim([350 750])

transfer2_after = transmission_593.*transmission_580.*transmission_700;
transfer2_before = transmission_593.*transmission_580;
transfer1_after = transmission_500.*(1-transmission_580).*transmission_700;

transfer1_before = transmission_500.*(1-transmission_580);


figure;
plot(340:760,((transfer1_before-transfer1_after)./transfer1_before)*100,'k','linewidth',4)
hold on
fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\fad_emission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2}*220;
plot(lambda,intensity,'Color',[0,0.3,0]);
hold on
fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2}/12000;
hold on
plot(lambda,intensity,'Color','g');

xlabel('wavelength')
ylabel('%')
set(gca,'FontSize',14,'FontWeight','Bold')
xlim([350 750])
ylim([0 5])
legend('Diff in Transfer', 'FAD emission', 'Green LED','location','northwest')
title('Cam1')








figure;
plot(340:760,((transfer2_before-transfer2_after)./transfer2_before)*100,'k','linewidth',4)
hold on
fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jrgeco1a_emission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2}*5;
plot(lambda,intensity,'m');
hold on
fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TwoCam_TL625_Pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2}/10000;
hold on
plot(lambda,intensity,'Color','r');

xlabel('wavelength(nm)')
ylabel('%')
set(gca,'FontSize',14,'FontWeight','Bold')
xlim([350 750])
ylim([0 5])
legend('Diff in Transfer', 'RGECO emission', 'RED LED','location','northwest')
title('Cam2')




fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF580-FDi01 Lot Code 618392-618394.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
OD = -log10(1-transmission);
hold on
plot(lambda,OD,'y');
xlim([350 750])
xticks(350:50:750);


xticks(350:50:750);
xlim([350 750])
xticks(350:50:750);
legend(h(1:4),'700nm SP','580nm Di',' 593nm LP','500 LP','location','northeast')
ylabel('OD')
xlabel('wavelength')
set(gca,'FontSize',14,'FontWeight','Bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
title('Optical Density')
ylim([0 8])









fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FESH0700_Transmission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2}/100;
OD = -log10(transmission);
figure;
plot(lambda,transmission,'r');


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF580-FDi01 Lot Code 618392-618394.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
OD = -log10(transmission);
hold on
plot(lambda,transmission,'y');
xlim([350 750])
xticks(350:50:750);


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-593_LP LotCode A18289-318381.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
OD = -log10(transmission);
hold on
plot(lambda,transmission,'Color',[ 0.9300 0.4100 0.1700]);
xlim([350 750])
xticks(350:50:750);

fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\filterTransmission\FF01-500_LP LotCode 818104.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
transmission = s{2};
OD = -log10(transmission);
hold on
plot(lambda,transmission,'g');
xlim([350 750])
xticks(350:50:750);

ylabel('Transmission')
xlabel('Wavelength')
set(gca,'FontSize',14,'FontWeight','Bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\jrgeco1a_emission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2};
hold on
plot(lambda,intensity,'m');
xlim([350 750])
xticks(350:50:750);

fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\probeSpectra\fad_emission.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2}*44;
hold on
plot(lambda,intensity,'Color',[0,0.8,0]);
xlim([350 750])
xticks(350:50:750);
legend('700nm SP','580nm Di',' 593nm LP','500 LP','jRGECO1a','FAD','location','southwest')
title('Transmission')