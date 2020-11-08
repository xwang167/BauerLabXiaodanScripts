clear all;close all;clc
import mouse.*
load('D:\OIS_Process\noVasculatureMask.mat')
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236];
nVx = 128;
nVy = 128;
nFrames = 14999;
framerate = 25;
    fft_oxy_mice = [];
    fft_deoxy_mice = [];
    fft_total_mice = [];
        powerdata_average_oxy_mice = [];
    powerdata_average_deoxy_mice = [];
    powerdata_average_total_mice = [];
    title_input = 'Xiaodan';
    runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
     if exist(fullfile(maskDir,maskName),'file')
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    else
         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
    end

    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    mask = logical(xform_isbrain.*(double(leftMask)+double(rightMask)));
    ibi = find(mask == 1);
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    fft_oxy_mouse = [];
    fft_deoxy_mouse = [];
    fft_total_mouse = [];
       processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        
        load(fullfile(saveDir,processedName),'xform_datahb')
        
       
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
        save(fullfile(saveDir,processedName),'fft_oxy','fft_deoxy','fft_total','-append')
        


        fft_oxy_mouse = cat(1,fft_oxy_mouse,fft_oxy);
        fft_deoxy_mouse = cat(1,fft_deoxy_mouse,fft_deoxy);
        fft_total_mouse = cat(1,fft_total_mouse,fft_total);
    
    end
    fft_oxy_mouse = mean(fft_oxy_mouse,1);
    fft_deoxy_mouse = mean(fft_deoxy_mouse,1);
    fft_total_mouse = mean(fft_total_mouse,1);
    save(fullfile(saveDir,processedName_mouse),'fft_oxy_mouse','fft_deoxy_mouse','fft_total_mouse','-append')
    load(fullfile(saveDir,processedName_mouse),'powerdata_average_oxy_mouse','powerdata_average_deoxy_mouse','powerdata_average_total_mouse','hz')
    hz_powerdata= hz;
        fft_oxy_mice = cat(1,fft_oxy_mice,fft_oxy_mouse);
    fft_deoxy_mice =  cat(1,fft_deoxy_mice,fft_deoxy_mouse);
    fft_total_mice =  cat(1,fft_oxy_mice,fft_oxy_mouse);
    
            powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,powerdata_average_oxy_mouse);
    powerdata_average_deoxy_mice =  cat(1,powerdata_average_deoxy_mice,powerdata_average_deoxy_mouse);
    powerdata_average_total_mice =  cat(1,powerdata_average_oxy_mice,powerdata_average_oxy_mouse);
end   
    
    fft_oxy_mice = mean(fft_oxy_mice,1);
    fft_deoxy_mice = mean(fft_deoxy_mice,1);
    fft_total_mice = mean(fft_total_mice,1);
    powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
    powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
    powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
    
     hz = linspace(0,framerate,nFrames);    
    figure
    loglog(hz,fft_oxy_mice/interp1(hz,fft_oxy_mice,0.01),'r')
    hold on
    loglog(hz,fft_deoxy_mice/interp1(hz,fft_deoxy_mice,0.01),'b')
    hold on
    loglog(hz,fft_total_mice/interp1(hz,fft_total_mice,0.01),'k')
    
    
    xlim([0.01 12.5])
    legend('Oxy','DeOxy','Total')
    title(strcat(title_input,',fft'))
    
    figure
    loglog(hz,fft_oxy_mice/interp1(hz,fft_oxy_mice,0.01),'r')
    hold on
    loglog(hz,fft_total_mice/interp1(hz,fft_total_mice,0.01),'k')
    hold on
    loglog(hz,fft_deoxy_mice/interp1(hz,fft_deoxy_mice,0.01),'b')
    
    
    
    xlim([0.01 12.5])
    legend('Oxy','Total','DeOxy')
    title(strcat(title_input,',fft'))
    
    figure
    
    
    loglog(hz,fft_total_mice/interp1(hz,fft_total_mice,0.01),'k')
    hold on
    loglog(hz,fft_deoxy_mice/interp1(hz,fft_deoxy_mice,0.01),'b')
    hold on
    loglog(hz,fft_oxy_mice/interp1(hz,fft_oxy_mice,0.01),'r')
    
    
    xlim([0.01 12.5])
    legend('Total','DeOxy','Oxy')
    title(strcat(title_input,',fft'))
    
    
   
    
    
  
