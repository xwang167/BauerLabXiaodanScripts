% excelFile = "L:\WhyDeOxyLowSNR\WhyDeOxyLowSNR.xlsx";
% excelRows = 12;
% runs = 1:3;
% fft_red_mice = [];
% fft_green_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{14};
%     rawdataloc = excelRaw{3};
%     info.nVx = 128;
%     info.nVy = 128;
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     load(fullfile(saveDir,maskName),'isbrain')
%     
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     visName = strcat(recDate,'-',mouseName,'-',sessionType);
%     fft_red_mouse = [];
%     fft_green_mouse = [];
%     for n = runs
%         
%         disp('loading processed data')
%         rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
%         rawdata = readtiff(fullfile(rawdataloc,recDate,rawName));
%         rawdata = reshape(rawdata,128,128,4,[]);
%         
%         darkFrame = mean(rawdata(:,:,:,1:sessionInfo.darkFrameNum),4);
%         baseline = repmat(darkFrame, 1,1,1,size(rawdata,4)-sessionInfo.darkFrameNum);
%         rawdata= rawdata(:,:,:,sessionInfo.darkFrameNum+1:end);
%         rawdata= double(rawdata) - baseline;
%         
%         load('D:\OIS_Process\noVasculatureMask.mat')
%         ibi=find(isbrain==1);
%         rawdata=single(reshape(rawdata,128*128,4,[]));
%         mdata=squeeze(mean(rawdata(ibi,:,:),1));
%         
%         info.T1 = size(mdata,2);
%         fdata=abs(fft(logmean(mdata),[],2));
%         hz=linspace(0,sessionInfo.framerate,info.T1);
%         hz_raw = hz;
%         fft_red = fdata(4,:);
%         fft_green = fdata(2,:);
%         figure
%         title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-FFT Raw Data'));
%         loglog(hz(1:ceil(info.T1)),fft_red(1:ceil(info.T1)),'r');
%         hold on
%         loglog(hz(1:ceil(info.T1)),fft_green(1:ceil(info.T1)),'g');
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Rawfft.png')));
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Rawfft.fig')));
%         fft_red_mouse = cat(1,fft_red_mouse,fft_red);
%         fft_green_mouse = cat(1,fft_green_mouse,fft_green);
%     end
%     fft_red_mouse = mean(fft_red_mouse,1);
%     fft_green_mouse = mean(fft_green_mouse,1);
%     
%     figure
%     loglog(hz,fft_red_mouse,'r')
%     hold on
%     loglog(hz,fft_green_mouse,'g')
%     
%     title(strcat(recDate,'-',mouseName,'-',sessionType,'-FFT Raw Data'))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Rawfft.png')));
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Rawfft.fig')));
%     
%     save(fullfile(saveDir, processedName_mouse),'fft_green_mouse','fft_red_mouse','hz_raw')
%     fft_red_mice = cat(1,fft_red_mice,squeeze(fft_red_mouse));
%     fft_green_mice = cat(1,fft_green_mice,squeeze(fft_green_mouse));
%     
%     
% end
% 
% fft_red_mice = mean(fft_red_mice,1);
% 
% fft_green_mice = mean(fft_green_mice,1);
% 
% 
% figure
% loglog(hz,fft_red_mice,'r')
% hold on
% loglog(hz,fft_green_mice,'g')
% title('EastOIS1 FFT')
% saveas(gcf,fullfile(saveDir,strcat(visName,'fft.png')));
% saveas(gcf,fullfile(saveDir,strcat(visName,'fft.fig')));

excelFile = "L:\WhyDeOxyLowSNR\WhyDeOxyLowSNR.xlsx";
nVx = 128;
nVy = 128;
excelRows = 12;%[181 183 185 195 202 204 228 230 232 234 236 240];
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
    sessionInfo.darkFrameNum = excelRaw{15};
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
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-datahb','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            load(fullfile(saveDir, processedName),'xform_datahb')
            total = xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:);
               [hz,powerdata_total] = QCcheck_CalcPDS(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_oxy] = QCcheck_CalcPDS((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_deoxy] = QCcheck_CalcPDS(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                                    [~,powerdata_average_total] = QCcheck_CalcPDSAverage(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_oxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,1,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_deoxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
          
            save(fullfile(saveDir, processedName),'powerdata_oxy','powerdata_deoxy','powerdata_total',...
            'powerdata_average_oxy','powerdata_average_deoxy','powerdata_average_total','hz','-append')        
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
loglog(hz,powerdata_oxy_mice,'r')
hold on
loglog(hz,powerdata_deoxy_mice,'b')
hold on
loglog(hz,powerdata_total_mice,'k')
legend('Oxy','Deoxy','Total')
title('Average last')
saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.png')));
saveas(gcf,fullfile(saveDir,strcat(visName,'powerdata.fig')));

figure
loglog(hz,powerdata_average_oxy_mice,'r')
hold on
loglog(hz,powerdata_average_deoxy_mice,'b')
hold on
loglog(hz,powerdata_average_total_mice,'k')
legend('Oxy','Deoxy','Total')
title('Average First')

