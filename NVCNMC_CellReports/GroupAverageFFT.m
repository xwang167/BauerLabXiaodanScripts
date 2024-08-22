excelFile = "L:\WhyDeOxyLowSNR\WhyDeOxyLowSNR.xlsx";
excelRows = 12;
runs = 1:3;
fdata_oxy_mice = [];
fdata_deoxy_mice = [];
fft_total_mice = [];
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
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'xform_isbrain')
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType);
    fdata_oxy_mouse = [];
    fdata_deoxy_mouse = [];
    fdata_total_mouse = [];
    Fs = 20;
    for n = runs
        disp('loading processed data')
         %processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-datahb','.mat');
        load(fullfile(saveDir, processedName),'xform_datahb')
        oxy = squeeze(xform_datahb(:,:,1,:));
        deoxy = squeeze(xform_datahb(:,:,2,:));
        total = squeeze(xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:));
        T1 = size(oxy,3);
        
        fdata_oxy = QCcheck_Calcfft(oxy,xform_isbrain);
        fdata_deoxy = QCcheck_Calcfft(deoxy,xform_isbrain);
        fdata_total = QCcheck_Calcfft(total,xform_isbrain);
        save(fullfile(saveDir, processedName),'fdata_oxy','fdata_deoxy','fdata_total','-append')
        
        hz=linspace(0,sessionInfo.framerate,T1);
        figure
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-FFT Processed Data'));
%         loglog(hz(1:ceil(T1)),fdata_oxy(1:ceil(T1)),'m');
%         hold on
%         loglog(hz(1:ceil(T1)),fdata_deoxy(1:ceil(T1)),'c');
%         hold on
%         loglog(hz(1:ceil(T1)),fdata_total(1:ceil(T1)),'y');
%         legend('Extended Oxy','Extended DeOxy','Extended Total','location','southwest')
%         title('Extended')
    loglog(hz,fdata_oxy(1:ceil(T1)),'r')
    hold on
    loglog(hz,fdata_deoxy(1:ceil(T1)),'b')
    hold on
    loglog(hz(1:ceil(T1)),fdata_total(1:ceil(T1)),'k');
    %legend('Extended Oxy','Extended DeOxy','Extended Total')
        legend('Non-Extended Oxy','Non-Extended DeOxy','Non-Extended Total','location','southwest')
        title('Non-Extended')
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Hbfft.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Hbfft.fig')));
        fdata_oxy_mouse = cat(1,fdata_oxy_mouse,fdata_oxy);
        fdata_deoxy_mouse = cat(1,fdata_deoxy_mouse,fdata_deoxy);
        fdata_total_mouse = cat(1,fdata_total_mouse,fdata_total);
       
    end
    fdata_oxy_mouse = mean(fdata_oxy_mouse,1);
    fdata_deoxy_mouse = mean(fdata_deoxy_mouse,1);
    fdata_total_mouse = mean(fdata_total_mouse,1);
    figure
    loglog(hz,fdata_oxy_mouse,'r')
    hold on
    loglog(hz,fdata_deoxy_mouse,'b')
    hold on
    loglog(hz(1:ceil(T1)),fdata_total_mouse(1:ceil(T1)),'k');
    %legend('Extended Oxy','Extended DeOxy','Extended Total')
%         legend('Non-Extended Oxy','Non-Extended DeOxy','Non-Extended Total','location','southwest')
%         title('Non-Extended')
legend('Oxy','DeOxy','Total','location','southwest')
title('EastOI1')
    %title(strcat(recDate,'-',mouseName,'-',sessionType,'-FFT Processed Data'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Hbfft.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Hbfft.fig')));
    
    save(fullfile(saveDir, processedName_mouse),'fdata_deoxy_mouse','fdata_oxy_mouse','fdata_total_mouse','-append')
%     fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fft_oxy_mouse));
%     fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy_mouse));
%     fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_deoxy_mouse));
%     
end

% fdata_oxy_mice = mean(fdata_oxy_mice,1);
% fdata_deoxy_mice = mean(fdata_deoxy_mice,1);
% fft_total_mice = mean(fft_total_mice,1);
% 
% figure
% loglog(hz,fdata_oxy_mice,'r')
% hold on
% loglog(hz,fdata_deoxy_mice,'b')
% hold on
% loglog(Hz,fft_total,'k')
% title('FFT, average last')
% saveas(gcf,fullfile(saveDir,strcat(visName,'Hbfft.png')));
% saveas(gcf,fullfile(saveDir,strcat(visName,'Hbfft.fig')));

