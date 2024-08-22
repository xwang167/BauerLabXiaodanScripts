% load('L:\WhyDeOxyLowSNR\210513-R13M1Baseline-fc1-cam1.mat')
% raw_green = raw_unregistered(:,:,2,21:end);
% load('L:\WhyDeOxyLowSNR\210513-R13M1Baseline-fc1-cam2.mat')
% raw_red = raw_unregistered(:,:,4,21:end);
% raw_green = squeeze(raw_green);
% raw_red = squeeze(raw_red);
% L = size(raw_red,3);
% Fs = 20;
% load('L:\WhyDeOxyLowSNR\210513-R13M1Baseline-LandmarksAndMask.mat','isbrain','xform_isbrain')
% fdata_green = QCcheck_Calcfft(raw_green,isbrain);
% fdata_red = QCcheck_Calcfft(raw_red,isbrain);
%
% f = Fs*(0:(L/2))/L;
% figure
% loglog(f,fdata_green(1:L/2+1),'g')
% hold on
% loglog(f,fdata_red(1:L/2+1),'r')
% title('Raw Jonah FFT')
%
% [hz,pdata_green] = QCcheck_CalcPDS(raw_green,Fs,isbrain);
% [hz,pdata_red] = QCcheck_CalcPDS(raw_red,Fs,isbrain);
%
% figure
% loglog(hz,pdata_green,'g')
% hold on
% loglog(hz,pdata_red,'r')
% title('Raw Jonah pwelch')
%
% load('L:\WhyDeOxyLowSNR\210513-R13M1Baseline-fc1_processed.mat','xform_datahb')
% [hz,pdata_oxy] = QCcheck_CalcPDS(squeeze(xform_datahb(:,:,1,:)),Fs,xform_isbrain);
% [hz,pdata_deoxy] = QCcheck_CalcPDS(squeeze(xform_datahb(:,:,2,:)),Fs,xform_isbrain);
%
% figure
% loglog(hz,pdata_oxy,'r')
% hold on
% loglog(hz,pdata_deoxy,'b')
% legend('Oxy','DeOxy')
% title('Processed Jonah pwelch')
%
%
% load('L:\WhyDeOxyLowSNR\190627-R5M2285-cam1-fc1.mat')
% raw_green = raw_unregistered(:,:,2,26:end);
% load('L:\WhyDeOxyLowSNR\190627-R5M2285-cam2-fc1.mat')
% raw_red = raw_unregistered(:,:,2,26:end);
% raw_green = squeeze(raw_green);
% raw_red = squeeze(raw_red);
% L = size(raw_red,3);
% Fs = 25;
% load('L:\WhyDeOxyLowSNR\190627-R5M2285-LandmarksAndMask.mat','isbrain','xform_isbrain')
% fdata_green = QCcheck_Calcfft(raw_green,isbrain);
% fdata_red = QCcheck_Calcfft(raw_red,isbrain);
% f = Fs*(0:(L/2))/L;
% figure
% loglog(f,fdata_green(1:L/2+1),'g')
% hold on
% loglog(f,fdata_red(1:L/2+1),'r')
% title('Raw Xiaodan FFT')
% close all;clearvars -except hz;clc
% import mouse.*
excelFile = "L:\WhyDeOxyLowSNR\WhyDeOxyLowSNR.xlsx";
nVx = 128;
nVy = 128;
excelRows = 11;%[181 183 185 195 202 204 228 230 232 234 236 240];
runs = 1:3;
length_runs = length(runs);

powerdata_average_oxy_mice = [];
powerdata_oxy_mice = [];


powerdata_average_deoxy_mice = [];
powerdata_deoxy_mice = [];

powerdata_average_total_mice = [];
powerdata_total_mice = [];

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{1};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'xform_isbrain')
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType);
      powerdata_oxy_mouse = [];
        powerdata_deoxy_mouse = [];
        powerdata_total_mouse = [];

        powerdata_average_oxy_mouse = [];
        powerdata_average_deoxy_mouse = [];
        powerdata_average_total_mouse = [];

    for n = runs

        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
        load(fullfile(saveDir, processedName),'powerdata_oxy','powerdata_deoxy','powerdata_total',...
            'powerdata_average_oxy','powerdata_average_deoxy','powerdata_average_total','hz')
        powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
        powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
        powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));

        powerdata_average_oxy_mouse = cat(1,powerdata_average_oxy_mouse,squeeze(powerdata_average_oxy'));
        powerdata_average_deoxy_mouse = cat(1,powerdata_average_deoxy_mouse,squeeze(powerdata_average_deoxy'));
        powerdata_average_total_mouse = cat(1,powerdata_average_total_mouse,squeeze(powerdata_average_total'));
        end
        end
    powerdata_average_oxy_mouse = mean(powerdata_average_oxy_mouse,1);
    powerdata_oxy_mouse = mean(powerdata_oxy_mouse,1);

    powerdata_average_deoxy_mouse = mean(powerdata_average_deoxy_mouse,1);
    powerdata_deoxy_mouse = mean(powerdata_deoxy_mouse,1);

    powerdata_average_total_mouse = mean(powerdata_average_total_mouse,1);
    powerdata_total_mouse = mean(powerdata_total_mouse,1);

    figure
    loglog(hz,powerdata_oxy_mouse,'r')
    hold on
    loglog(hz,powerdata_deoxy_mouse,'b')
    hold on
    loglog(hz,powerdata_total_mouse,'k')
    title('Average last')
    saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.png')));
    saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.fig')));

    figure
    loglog(hz,powerdata_oxy_mouse,'r')
    hold on
    loglog(hz,powerdata_deoxy_mouse,'b')
    hold on
    loglog(hz,powerdata_total_mouse,'k')
    title('Average First')

    saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata_average.png')));
    saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata_average.fig')));

    save(fullfile(saveDir, processedName_mouse),'powerdata_average_deoxy_mouse','powerdata_average_oxy_mouse',...
        'powerdata_average_total_mouse','powerdata_deoxy_mouse','powerdata_oxy_mouse','powerdata_total_mouse','hz')
    powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,squeeze(powerdata_average_oxy_mouse));
    powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));


    powerdata_average_deoxy_mice = cat(1,powerdata_average_deoxy_mice,squeeze(powerdata_average_deoxy_mouse));
    powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));

    powerdata_average_total_mice = cat(1,powerdata_average_total_mice,squeeze(powerdata_average_total_mouse));
    powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
end
powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
powerdata_oxy_mice = mean(powerdata_oxy_mice,1);


powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);

powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
powerdata_total_mice = mean(powerdata_total_mice,1);

figure
loglog(hz,powerdata_oxy_mice,'m')
hold on
loglog(hz,powerdata_deoxy_mice,'c')
hold on
loglog(hz,powerdata_total_mice,'y')
legend('Extended oxy','extended deoxy','extended total')
title('Average last')
saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.png')));
saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.fig')));

figure
loglog(hz,powerdata_average_oxy_mice,'m')
hold on
loglog(hz,powerdata_average_deoxy_mice,'c')
hold on
loglog(hz,powerdata_average_total_mice,'y')
legend('Extended oxy','extended deoxy','extended total')
title('Average First')



excelFile = "L:\WhyDeOxyLowSNR\WhyDeOxyLowSNR.xlsx";
excelRows = 10;
runs = 1:3;
fft_red_mice = [];
fft_green_mice = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
             maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'isbrain')
        else
            maskDir = saveDir;
            maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
            load(fullfile(maskDir,maskName),'isbrain')
        end
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType);
    fft_red_mouse = [];
    fft_green_mouse = [];
    for n = runs
        
        disp('loading processed data')
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');       
        load(fullfile(saveDir,rawName),'rawdata')
        if size(rawdata,4)>15000
            darkFrame = mean(rawdata(:,:,:,1:25),4);
            baseline = repmat(darkFrame, 1,1,1,15000);
            rawdata= rawdata(:,:,:,26:end);
            rawdata= rawdata - baseline;
         
        end
        load('D:\OIS_Process\noVasculatureMask.mat')
ibi=find(isbrain==1);
rawdata=single(reshape(rawdata,128*128,4,[]));
mdata=squeeze(mean(rawdata(ibi,:,:),1));

        info.T1 = size(mdata,2);
        fdata=abs(fft(logmean(mdata),[],2));
        hz=linspace(0,sessionInfo.framerate,info.T1);
        hz_raw = hz;
        fft_red = fdata(4,:);
        fft_green = fdata(3,:);
        figure
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-FFT Raw Data'));
        loglog(hz(1:ceil(info.T1)),fft_red(1:ceil(info.T1)),'r');
        hold on
        loglog(hz(1:ceil(info.T1)),fft_green(1:ceil(info.T1)),'g');
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Rawfft.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Rawfft.fig')));
        fft_red_mouse = cat(1,fft_red_mouse,fft_red);
        fft_green_mouse = cat(1,fft_green_mouse,fft_green);
    end
    fft_red_mouse = mean(fft_red_mouse,1);
    fft_green_mouse = mean(fft_green_mouse,1);
    
    figure
    loglog(hz,fft_red_mouse,'r')
    hold on
    loglog(hz,fft_green_mouse,'g')
   
    title(strcat(recDate,'-',mouseName,'-',sessionType,'-FFT Raw Data'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Rawfft.png')));
   saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Rawfft.fig')));
    
    save(fullfile(saveDir, processedName_mouse),'fft_green_mouse','fft_red_mouse','hz_raw','-append')
    fft_red_mice = cat(1,fft_red_mice,squeeze(fft_red_mouse));
    fft_green_mice = cat(1,fft_green_mice,squeeze(fft_green_mouse));
    
    
end

fft_red_mice = mean(fft_red_mice,1);

fft_green_mice = mean(fft_green_mice,1);


figure
loglog(hz,fft_red_mice,'r')
hold on
loglog(hz,fft_green_mice,'g')
 legend('Non-Extended red','Non-Extended green')
title('Average FFT')
saveas(gcf,fullfile(saveDir,strcat(visName,'fft.png')));
saveas(gcf,fullfile(saveDir,strcat(visName,'fft.fig')));




