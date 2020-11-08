clear all;close all;clc
import mouse.*
load('D:\OIS_Process\noVasculatureMask.mat')
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185  228 232 236];
nVx = 128;
nVy = 128;
nFrames = 14999;
framerate = 25;

        powerdata_100_oxy_mice = [];
    powerdata_100_deoxy_mice = [];
    powerdata_100_total_mice = [];
    powerdata_100_rgeco_mice = [];
    title_input = 'Xiaodan Pwelch';
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
    powerdata_100_oxy_mouse = [];
   powerdata_100_deoxy_mouse = [];
    powerdata_100_total_mouse = [];
    powerdata_100_rgeco_mouse = [];
       processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
              
       data = squeeze(xform_jrgeco1aCorr);
        data(:,:,end+1) = data(:,:,end);
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
        data = transpose(reshape(data,128*128,[]));
        nFrames = size(data,2);
        window = 100*framerate;
        powerdata_100_rgeco = pwelch(data,window,window/2,[],framerate);
        powerdata_100_rgeco = powerdata_100_rgeco';
        powerdata_100_rgeco = mean(powerdata_100_rgeco(ibi,:),1);
        
           data = squeeze(xform_datahb(:,:,1,:));
        data(:,:,end+1) = data(:,:,end);
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
       data = transpose(reshape(data,128*128,[]));
        nFrames = size(data,2);
        window = 100*framerate;
        powerdata_100_oxy = pwelch(data,window,window/2,[],framerate);
        powerdata_100_oxy = powerdata_100_oxy';
        powerdata_100_oxy = mean(powerdata_100_oxy(ibi,:),1);
        
        data = squeeze(xform_datahb(:,:,2,:));
        data(:,:,end+1) = data(:,:,end);
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
              data = transpose(reshape(data,128*128,[]));
        nFrames = size(data,2);
        window = 100*framerate;
        powerdata_100_deoxy = pwelch(data,window,window/2,[],framerate);
        powerdata_100_deoxy = powerdata_100_deoxy';
        powerdata_100_deoxy = mean(powerdata_100_deoxy(ibi,:),1);
        
        data = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
        data(:,:,end+1) = data(:,:,end);
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
                     data = transpose(reshape(data,128*128,[]));
        nFrames = size(data,2);
        window = 100*framerate;
        [powerdata_100_total,hz] = pwelch(data,window,window/2,[],framerate);
        powerdata_100_total = powerdata_100_total';
        powerdata_100_total = mean(powerdata_100_total(ibi,:),1);
        
      
        save(fullfile(saveDir,processedName),'powerdata_100_oxy','powerdata_100_deoxy','powerdata_100_total','powerdata_100_rgeco','-append')
  
        powerdata_100_oxy_mouse = cat(1,powerdata_100_oxy_mouse,powerdata_100_oxy);
        powerdata_100_deoxy_mouse = cat(1,powerdata_100_deoxy_mouse,powerdata_100_deoxy);
        powerdata_100_total_mouse = cat(1,powerdata_100_total_mouse,powerdata_100_total);
    powerdata_100_rgeco_mouse = cat(1,powerdata_100_rgeco_mouse,powerdata_100_rgeco);
    end
    powerdata_100_oxy_mouse = mean(powerdata_100_oxy_mouse,1);
    powerdata_100_deoxy_mouse = mean(powerdata_100_deoxy_mouse,1);
    powerdata_100_total_mouse = mean(powerdata_100_total_mouse,1);
    powerdata_100_rgeco_mouse = mean(powerdata_100_rgeco_mouse,1);
    save(fullfile(saveDir,processedName_mouse),'powerdata_100_oxy_mouse','powerdata_100_deoxy_mouse','powerdata_100_total_mouse','-append')
save(fullfile(saveDir,processedName_mouse),'powerdata_100_rgeco_mouse','-append')


        powerdata_100_oxy_mice = cat(1,powerdata_100_oxy_mice,powerdata_100_oxy_mouse);
    powerdata_100_deoxy_mice =  cat(1,powerdata_100_deoxy_mice,powerdata_100_deoxy_mouse);
    powerdata_100_total_mice =  cat(1,powerdata_100_oxy_mice,powerdata_100_oxy_mouse);
    
    powerdata_100_rgeco_mice =  cat(1,powerdata_100_rgeco_mice,powerdata_100_rgeco_mouse);
%     
%             powerdata_100_oxy_mice = cat(1,powerdata_100_oxy_mice,powerdata_100_oxy_mouse);
%     powerdata_100_deoxy_mice =  cat(1,powerdata_100_deoxy_mice,powerdata_100_deoxy_mouse);
%     powerdata_100_total_mice =  cat(1,powerdata_100_oxy_mice,powerdata_100_oxy_mouse);
end   
    
    powerdata_100_oxy_mice = mean(powerdata_100_oxy_mice,1);
    powerdata_100_deoxy_mice = mean(powerdata_100_deoxy_mice,1);
    powerdata_100_total_mice = mean(powerdata_100_total_mice,1);
powerdata_100_rgeco_mice = mean(powerdata_100_rgeco_mice,1);
%     powerdata_100_oxy_mice = mean(powerdata_100_oxy_mice,1);
%     powerdata_100_deoxy_mice = mean(powerdata_100_deoxy_mice,1);
%     powerdata_100_total_mice = mean(powerdata_100_total_mice,1);
    
   
    figure
    loglog(hz',powerdata_100_oxy_mice/interp1(hz',powerdata_100_oxy_mice,0.01),'r')
    hold on
    loglog(hz',powerdata_100_deoxy_mice/interp1(hz',powerdata_100_deoxy_mice,0.01),'b')
    hold on
    loglog(hz',powerdata_100_total_mice/interp1(hz',powerdata_100_total_mice,0.01),'k')
    hold on
    loglog(hz',powerdata_100_rgeco_mice/interp1(hz',powerdata_100_rgeco_mice,0.01),'m')
    
    xlim([0.01 12.5])
    legend('Oxy','DeOxy','Total','RGECO')
    title(strcat('Pwelch'))
    
    figure
    loglog(hz,powerdata_100_oxy_mice/interp1(hz,powerdata_100_oxy_mice,0.01),'r')
    hold on
    loglog(hz,powerdata_100_total_mice/interp1(hz,powerdata_100_total_mice,0.01),'k')
    hold on
    loglog(hz,powerdata_100_deoxy_mice/interp1(hz,powerdata_100_deoxy_mice,0.01),'b')
    
    
    
    xlim([0.01 12.5])
    legend('Oxy','Total','DeOxy')
    title(strcat(title_input,',fft'))
    
    figure
    
    
    loglog(hz,powerdata_100_total_mice/interp1(hz,powerdata_100_total_mice,0.01),'k')
    hold on
    loglog(hz,powerdata_100_deoxy_mice/interp1(hz,powerdata_100_deoxy_mice,0.01),'b')
    hold on
    loglog(hz,powerdata_100_oxy_mice/interp1(hz,powerdata_100_oxy_mice,0.01),'r')
    
    
    xlim([0.01 12.5])
    legend('Total','DeOxy','Oxy')
    title(strcat(title_input,',fft'))