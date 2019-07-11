
fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\M470nm_SPF_pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2};
figure;
plot(lambda,intensity);
xlim([350 550])
xticks(350:50:550);
title('M470nm SPF pol')

fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\TL530nm_pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2};
figure;
plot(lambda,intensity);
xlim([450 650])
xticks(450:50:650);
title('TL530nm pol')


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\East3410OIS1_TL_617_Pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2};
figure;
plot(lambda,intensity);
xlim([550 750])
xticks(550:50:750);
title('East3410OIS1 TL 617 Pol')


fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra\East3410OIS1_TL_625_Pol.txt');
s =textscan(fid,'%f %f');
fclose(fid);
lambda = s{1};
intensity = s{2};
figure;
plot(lambda,intensity);
xlim([550 750])
xticks(550:50:750);
title('East3410OIS1 TL 625 Pol')

fid = fopen('C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\parameters\+bauerParams\prahl_extinct_coef.txt');
s =textscan(fid,'%d %f %f');
fclose(fid);
lambda = s{1};
oxy = s{2};
deoxy = s{3};
figure;
plot(lambda,oxy,'r')
hold on;
plot(lambda,deoxy,'b')
xlim([400 750])
xticks(400:50:750);
title('prahl extinct coef')