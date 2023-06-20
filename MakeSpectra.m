ChR2 = xlsread("C:\Users\xiaodanwang\Documents\GitHub\newpipeline\Functions_and_Wrappers\+bauerParams\ChR2 Spectrum.csv");

fid = fopen("C:\Users\xiaodanwang\Documents\GitHub\newpipeline\Functions_and_Wrappers\+bauerParams\probeSpectra\gcamp6f_excitation.txt");
gcamp = textscan(fid,'%f %f','headerlines',0);
fclose(fid);

fid = fopen("C:\Users\xiaodanwang\Documents\GitHub\newpipeline\Functions_and_Wrappers\+bauerParams\probeSpectra\jrgeco1a_excitation.txt");
rgeco = textscan(fid,'%f %f','headerlines',0);
fclose(fid);

figure
plot(ChR2(:,1),ChR2(:,2)/max(ChR2(:,2)),'b-')
hold on
plot(gcamp{1,1},gcamp{1,2}/max(gcamp{1,2}),'g-')
xlim([400,600])
ylim([0,1.1])
xlabel('Wavelength(nm)')
ylabel('Relative Intensity')
legend('ChR2 Activation','GCaMP6f Excitation','location','southwest')

figure
plot(ChR2(:,1),ChR2(:,2)/max(ChR2(:,2)),'b-')
hold on
plot(gcamp{1,1},gcamp{1,2}/max(gcamp{1,2}),'g-')
hold on
plot(rgeco{1,1},rgeco{1,2}/max(rgeco{1,2}),'m-')
xlim([400,600])
ylim([0,1.1])
xlabel('Wavelength(nm)')
ylabel('Relative Intensity')
grid on