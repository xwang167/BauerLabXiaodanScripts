clear all;close all;clc
import mouse.*
load('D:\OIS_Process\noVasculatureMask.mat')
nVx = 128;
nVy = 128;
systemInfo.gbox = 5;
systemInfo.gsigma = 1.2;
pkgDir = what('bauerParams');
load('L:\Test\200316-G38M2-LandmarksandMask.mat','I','xform_isbrain')%load('L:\RGECO\Kenny\190627\190627-R5M2286-LandmarksandMask.mat','affineMarkers','xform_isbrain')%
mask = logical(xform_isbrain.*(double(leftMask)+double(rightMask)));
ibi = find(mask == 1);
rawdata  = readtiff('Z:\200316\200316-G38M2-fc1.tif');rawdata = reshape(rawdata,128,128,4,[]);% load('L:\RGECO\190627\190627-R5M2286-fc2.mat')% 
nFrames = 6000;
framerate = 20;
startFrame = 101;
iChannel = [2,4];
title_input = 'Annie GCaMP, GR';
ledFiles = [ "TL_530nm_515LPF_Pol.txt","East3410OIS1_TL_625_Pol.txt"];%ledFiles =  [ "TL_530nm_515LPF_Pol.txt", "East3410OIS1_TL_617_Pol.txt","East3410OIS1_TL_625_Pol.txt"];%
% figure;subplot(2,2,1);imagesc(rawdata(:,:,1,82),[0 2*10^5 ]);axis image off;colormap jet;colorbar;title('Channel 1');
% subplot(2,2,2);imagesc(rawdata(:,:,2,82));axis image off;colormap jet;colorbar;title('Channel 2');
% subplot(2,2,3);imagesc(rawdata(:,:,3,82));axis image off;colormap jet;colorbar;title('Channel 3');
% subplot(2,2,4);imagesc(rawdata(:,:,4,82));axis image off;colormap jet;colorbar;title('Channel 4');

xform_raw = double(process.affineTransform(rawdata(:,:,iChannel,:),I));

clear rawdata

% green = xform_raw(:,:,1,startFrame:end);
% green = reshape(green, 128*128,[]);
% green_timetrace =  mean(green(ibi,:),1); 
% 
% red = xform_raw(:,:,2,startFrame:end);
% red = reshape(red, 128*128,[]);
% red_timetrace =  mean(red(ibi,:),1);
% 
% fft_green = abs(fft(green_timetrace));
% fft_red = abs(fft(red_timetrace));

% 
% figure;
% plot((1:nFrames)/framerate,red_timetrace,'r');
% hold on;plot((1:nFrames)/framerate,green_timetrace,'g');
% xlabel('time(s)');ylabel('Counts')
% 
% figure
% loglog(hz,fft_red,'r')
% title(title_input)
% hold on
% loglog(hz,fft_green,'g');
% xlabel('Frequency(Hz)')
% xlim([0,10])
% title(title_input)




% data = xform_raw(:,:,1,26:end);
% data(isnan(data)) = 0;
% data(isinf(data)) = 0;
% data = transpose(reshape(data,nVx*nVy,[]));
% [Pxx,hz] = pwelch(data,[],[],[],framerate);
% Pxx = Pxx';
% powerdata_green = mean(Pxx(ibi,:),1);
% 
% data = xform_raw(:,:,2,26:end);
% data(isnan(data)) = 0;
% data(isinf(data)) = 0;
% data = transpose(reshape(data,nVx*nVy,[]));
% [Pxx,hz] = pwelch(data,[],[],[],framerate);
% Pxx = Pxx';
% powerdata_red = mean(Pxx(ibi,:),1);
% 
% figure
% loglog(hz,powerdata_red,'r')
% 
% hold on
% loglog(hz,powerdata_green,'g')
% xlim([0.01 10])
% legend('Red Reflectance','Green Reflectance')
% title(title_input)



darkFrameInd = 2:startFrame-1;
darkFrame = squeeze(mean(xform_raw(:,:,:,darkFrameInd),4));
raw_baselineMinus = xform_raw- repmat(darkFrame,1,1,1,size(xform_raw,4));
clear rawdata
raw_baselineMinus(:,:,:,1:startFrame-1)=[];
rawdata = raw_baselineMinus;
clear raw_baselineMinus

raw_detrend = temporalDetrendAdam(rawdata);
raw_detrend = process.smoothImage(raw_detrend,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
raw_detrend(isnan(raw_detrend)) = 0;

muspFcn = @(x,y) (40*(x/500).^-1.16)'*y; 
[op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',ledFiles));
 
 
  BaselineFunction  = @(x) mean(x,numel(size(x)));
  baselineValues = BaselineFunction(raw_detrend);
     xform_datahb = mouse.process.procOIS(raw_detrend,baselineValues,op.dpf,E);
xform_datahb = process.smoothImage(xform_datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
% xform_datahb = resampledata(xform_datahb,25,9,10^-5);

data = xform_datahb(:,:,1,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,128*128,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_oxy = mean(Pxx(ibi,:),1);

data = xform_datahb(:,:,2,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,128*128,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_deoxy = mean(Pxx(ibi,:),1);


data = xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,128*128,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_total = mean(Pxx(ibi,:),1);


figure
loglog(hz,powerdata_oxy/interp1(hz,powerdata_oxy,0.01),'r')
hold on
loglog(hz,powerdata_deoxy/interp1(hz,powerdata_deoxy,0.01),'b')
hold on
loglog(hz,powerdata_total/interp1(hz,powerdata_total,0.01),'k')


xlim([0.01 10])
legend('Oxy','DeOxy','Total')
title(strcat(title_input,',Pwelch'))



hz = linspace(0,framerate,nFrames);
data = xform_datahb(:,:,1,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = reshape(data,128*128,[]);
data = data(ibi,:);
fft_oxy = zeros(length(ibi),nFrames);
for ii = 1: length(ibi)
    fft_oxy = abs(fft(data(ii,:)));
end
fft_oxy = mean(fft_oxy,1);

data = xform_datahb(:,:,2,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = reshape(data,128*128,[]);
data = data(ibi,:);
fft_deoxy = zeros(length(ibi),nFrames);
for ii = 1: length(ibi)
    fft_deoxy = abs(fft(data(ii,:)));
end
fft_deoxy = mean(fft_deoxy,1);


data = xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = reshape(data,128*128,[]);
data = data(ibi,:);
fft_total = zeros(length(ibi),nFrames);
for ii = 1: length(ibi)
    fft_total = abs(fft(data(ii,:)));
end
fft_total = mean(fft_total,1);


figure
loglog(hz,fft_oxy/interp1(hz,fft_oxy,0.01),'r')
hold on
loglog(hz,fft_deoxy/interp1(hz,fft_deoxy,0.01),'b')
hold on
loglog(hz,fft_total/interp1(hz,fft_total,0.01),'k')


xlim([0.01 10])
legend('Oxy','DeOxy','Total')
title(strcat(title_input,',fft'))

figure
loglog(hz,fft_oxy/interp1(hz,fft_oxy,0.01),'r')
hold on
loglog(hz,fft_total/interp1(hz,fft_total,0.01),'k')
hold on
loglog(hz,fft_deoxy/interp1(hz,fft_deoxy,0.01),'b')



xlim([0.01 10])
legend('Oxy','Total','DeOxy')
title(strcat(title_input,',fft'))

figure


loglog(hz,fft_total/interp1(hz,fft_total,0.01),'k')
hold on
loglog(hz,fft_deoxy/interp1(hz,fft_deoxy,0.01),'b')
hold on
loglog(hz,fft_oxy/interp1(hz,fft_oxy,0.01),'r')


xlim([0.01 10])
legend('Total','DeOxy','Oxy')
title(strcat(title_input,',fft'))


red = rawdata(:,:,4,26:end);
red = reshape(red, 128*128,[]);
red_timetrace =  mean(red(ibi,:),1);



green = rawdata(:,:,3,26:end);
green = reshape(green, 128*128,[]);
green_timetrace =  mean(green(ibi,:),1);

fft_green = abs(fft(green_timetrace));
hz = linspace(0,20,15000);
figure;plot(red_timetrace)
loglog(abs(fft(red_timetrace)),'r')
hold on
loglog(hz,fft_green,'g');
xlim([0,10])
plot(fft_green)
semilogy(fft_green)


load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(double(leftMask)+double(rightMask));
ibi = find(mask == 1);

rawdata  = readtiff('X:\200108\200108-G38M1-fc1.tif');
rawdata = reshape(rawdata,128,128,4,[]);
green = rawdata(:,:,2,101:end);
green = reshape(green, 128*128,[]);
green_timetrace =  mean(green(ibi,:),1);

red = rawdata(:,:,4,101:end);
red = reshape(red, 128*128,[]);
red_timetrace =  mean(red(ibi,:),1);

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
exampleTiff(excelFile,392)
              