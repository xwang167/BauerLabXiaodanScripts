clear all;close all;clc
import mouse.*
load('D:\OIS_Process\noVasculatureMask.mat')
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =321:327;% [181 183 185  228 232 236];%[182,184,186,233,237]; %
framerate = 20;
nVx = 128;
nVy = 128;
nFrames = 7500;

    fft_pieces_oxy_mice = [];
    fft_pieces_deoxy_mice = [];
    fft_pieces_total_mice = [];
     fft_pieces_rgeco_mice = [];
     
        powerdata_average_oxy_mice = [];
    powerdata_average_deoxy_mice = [];
    powerdata_average_total_mice = [];
    title_input = 'Xiaodan FFT';
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
    fft_pieces_oxy_mouse = [];
    fft_pieces_deoxy_mouse = [];
    fft_pieces_total_mouse = [];
    fft_pieces_rgeco_mouse = [];
       processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
              %load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
       data = squeeze(xform_jrgeco1aCorr);
        data(:,:,end+1) = data(:,:,end);
        if length(xform_jrgeco1aCorr) ==11998
            data(:,:,end+1) = data(:,:,end);
        end
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
        data = reshape(data,128*128,[]);
        data = data(ibi,:);
        nFrames = size(data,2);
        window = 100*framerate;
        nPiece = nFrames/(100*framerate);
        fft_pieces_rgeco = zeros(length(ibi),window,nPiece);
        
        for ii = 1: length(ibi)
            for jj = 1: nPiece
            fft_pieces_rgeco(ii,:,jj) = abs(fft(data(ii,(1+(jj-1)*window/2):((jj-1)*window/2+window))));
            end
        end
        fft_pieces_rgeco = squeeze(mean(fft_pieces_rgeco,1));
        fft_pieces_rgeco = mean(fft_pieces_rgeco,2);
        
        data = squeeze(xform_datahb(:,:,1,:));
        data(:,:,end+1) = data(:,:,end);
                if length(xform_jrgeco1aCorr) ==11998
            data(:,:,end+1) = data(:,:,end);
        end
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
        data = reshape(data,128*128,[]);
        data = data(ibi,:);
        nFrames = size(data,2);
        window = 100*framerate;
        nPiece = nFrames/(100*framerate);
        fft_pieces_oxy = zeros(length(ibi),window,nPiece);
        
        for ii = 1: length(ibi)
            for jj = 1: nPiece
            fft_pieces_oxy(ii,:,jj) = abs(fft(data(ii,(1+(jj-1)*window/2):((jj-1)*window/2+window))));
            end
        end
        fft_pieces_oxy = squeeze(mean(fft_pieces_oxy,1));
        fft_pieces_oxy = mean(fft_pieces_oxy,2);
        
        data = squeeze(xform_datahb(:,:,2,:));
        data(:,:,end+1) = data(:,:,end);
                if length(xform_jrgeco1aCorr) ==11998
            data(:,:,end+1) = data(:,:,end);
        end
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
        data = reshape(data,128*128,[]);
        data = data(ibi,:);
        fft_pieces_deoxy = zeros(length(ibi),window,nPiece);
        
        for ii = 1: length(ibi)
            for jj = 1: nPiece
            fft_pieces_deoxy(ii,:,jj) = abs(fft(data(ii,(1+(jj-1)*window/2):((jj-1)*window/2+window))));
            end
        end
        fft_pieces_deoxy = squeeze(mean(fft_pieces_deoxy,1));
        fft_pieces_deoxy = mean(fft_pieces_deoxy,2);
        
        data = squeeze(xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:));
        data(:,:,end+1) = data(:,:,end);
                if length(xform_jrgeco1aCorr) ==11998
            data(:,:,end+1) = data(:,:,end);
        end
        data(isnan(data)) = 0;
        data(isinf(data)) = 0;
        data = reshape(data,128*128,[]);
        data = data(ibi,:);
         fft_pieces_total = zeros(length(ibi),window,nPiece);
        
        for ii = 1: length(ibi)
            for jj = 1: nPiece
            fft_pieces_total(ii,:,jj) = abs(fft(data(ii,(1+(jj-1)*window/2):((jj-1)*window/2+window))));
            end
        end
        fft_pieces_total = squeeze(mean(fft_pieces_total,1));
        fft_pieces_total = mean(fft_pieces_total,2);
        
        save(fullfile(saveDir,processedName),'fft_pieces_oxy','fft_pieces_deoxy','fft_pieces_total','fft_pieces_rgeco','-append')
        save(fullfile(saveDir,processedName),'fft_pieces_rgeco','-append')
        
        fft_pieces_oxy_mouse = cat(2,fft_pieces_oxy_mouse,fft_pieces_oxy);
        fft_pieces_deoxy_mouse = cat(2,fft_pieces_deoxy_mouse,fft_pieces_deoxy);
        fft_pieces_total_mouse = cat(2,fft_pieces_total_mouse,fft_pieces_total);
    fft_pieces_rgeco_mouse = cat(2,fft_pieces_rgeco_mouse,fft_pieces_rgeco);
    end
    fft_pieces_oxy_mouse = mean(fft_pieces_oxy_mouse,2);
    fft_pieces_deoxy_mouse = mean(fft_pieces_deoxy_mouse,2);
    fft_pieces_total_mouse = mean(fft_pieces_total_mouse,12);
    save(fullfile(saveDir,processedName_mouse),'fft_pieces_oxy_mouse','fft_pieces_deoxy_mouse','fft_pieces_total_mouse','-v7.3')
%load(fullfile(saveDir,processedName_mouse),'fft_pieces_rgeco_mouse','fft_pieces_oxy_mouse','fft_pieces_deoxy_mouse','fft_pieces_total_mouse')
save(fullfile(saveDir,processedName_mouse),'fft_pieces_rgeco_mouse','-append')

  %  load(fullfile(saveDir,processedName_mouse),'powerdata_average_oxy_mouse','powerdata_average_deoxy_mouse','powerdata_average_total_mouse','hz')
   % hz_powerdata= hz;
        fft_pieces_oxy_mice = cat(2,fft_pieces_oxy_mice,fft_pieces_oxy_mouse);
    fft_pieces_deoxy_mice =  cat(2,fft_pieces_deoxy_mice,fft_pieces_deoxy_mouse);
    fft_pieces_total_mice =  cat(2,fft_pieces_oxy_mice,fft_pieces_oxy_mouse);
    
    fft_pieces_rgeco_mice =  cat(2,fft_pieces_rgeco_mice,fft_pieces_rgeco_mouse);
%     
%             powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,powerdata_average_oxy_mouse);
%     powerdata_average_deoxy_mice =  cat(1,powerdata_average_deoxy_mice,powerdata_average_deoxy_mouse);
%     powerdata_average_total_mice =  cat(1,powerdata_average_oxy_mice,powerdata_average_oxy_mouse);
end   
    
    fft_pieces_oxy_mice = mean(fft_pieces_oxy_mice,2);
    fft_pieces_deoxy_mice = mean(fft_pieces_deoxy_mice,2);
    fft_pieces_total_mice = mean(fft_pieces_total_mice,2);
fft_pieces_rgeco_mice = mean(fft_pieces_rgeco_mice,2);
%     powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
%     powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
%     powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
    
     hz = linspace(0,framerate,window);    
    figure
    loglog(hz,fft_pieces_oxy_mice/interp1(hz,fft_pieces_oxy_mice,0.01),'r')
    hold on
    loglog(hz,fft_pieces_deoxy_mice/interp1(hz,fft_pieces_deoxy_mice,0.01),'b')
    hold on
    loglog(hz,fft_pieces_total_mice/interp1(hz,fft_pieces_total_mice,0.01),'k')
    hold on
    loglog(hz,fft_pieces_rgeco_mice/interp1(hz,fft_pieces_rgeco_mice,0.01),'m')
    
    xlim([0.01 12.5])
    legend('Oxy','DeOxy','Total','RGECO')
    title(strcat('fft with pieces'))
    
    figure
    loglog(hz,fft_pieces_oxy_mice/interp1(hz,fft_pieces_oxy_mice,0.01),'r')
    hold on
    loglog(hz,fft_pieces_total_mice/interp1(hz,fft_pieces_total_mice,0.01),'k')
    hold on
    loglog(hz,fft_pieces_deoxy_mice/interp1(hz,fft_pieces_deoxy_mice,0.01),'b')
    
    
    
    xlim([0.01 12.5])
    legend('Oxy','Total','DeOxy')
    title(strcat(title_input,',fft'))
    
    figure
    
    
    loglog(hz,fft_pieces_total_mice/interp1(hz,fft_pieces_total_mice,0.01),'k')
    hold on
    loglog(hz,fft_pieces_deoxy_mice/interp1(hz,fft_pieces_deoxy_mice,0.01),'b')
    hold on
    loglog(hz,fft_pieces_oxy_mice/interp1(hz,fft_pieces_oxy_mice,0.01),'r')
    
    
    xlim([0.01 12.5])
    legend('Total','DeOxy','Oxy')
    title(strcat(title_input,',fft'))