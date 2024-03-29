
close all;clearvars;clc

import mouse.*

excelFile = "X:\Paper1\PaperExperiment.xlsx";
excelRows =29:31;

numMice = length(excelRows);

stimStartTime = 5;

nVx = 128;
nVy = 128;

xform_datahb_mice_GSR = [];
xform_datahb_mice_NoGSR = [];

xform_gcamp_mice_GSR = [];
xform_gcamp_mice_NoGSR = [];

xform_gcampCorr_mice_GSR = [];
xform_gcampCorr_mice_NoGSR = [];

xform_green_mice_GSR = [];
xform_green_mice_NoGSR = [];

xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
miceName = [];
for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
   sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    
 maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_correction11_mouse','.mat');
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    disp('loading  GSR data')
    sessionInfo.stimblocksize = excelRaw{11};
%     load(fullfile(saveDir,processedName_mouse),...
%         'xform_gcampCorr_mouse_GSR','xform_green_mouse_GSR','xform_gcamp_mouse_GSR','xform_datahb_mouse_GSR')
%     
%     xform_gcampCorr_mice_GSR = cat(4,xform_gcampCorr_mice_GSR,xform_gcampCorr_mouse_GSR);
%     clear xform_gcampCorr_mouse_GSR
%     
%     xform_gcamp_mice_GSR = cat(4,xform_gcamp_mice_GSR,xform_gcamp_mouse_GSR);
%     clear xform_gcamp_mouse_GSR
%     
%     xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_mouse_GSR);
%     clear xform_gcamp_mouse_GSR
%    
%     xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
%     
    disp('loading  Non GRS data')
%    load(fullfile(saveDir,processedName_mouse),...
%         'xform_datahb_mouse_NoGSR')

    load(fullfile(saveDir,processedName_mouse),...
        'xform_gcampCorr_mouse_NoGSR','xform_green_mouse_NoGSR','xform_gcamp_mouse_NoGSR')
    
    xform_gcampCorr_mice_NoGSR = cat(4,xform_gcampCorr_mice_NoGSR,xform_gcampCorr_mouse_NoGSR);
    clear xform_gcampCorr_mouse_NoGSR
    
    xform_gcamp_mice_NoGSR = cat(4,xform_gcamp_mice_NoGSR,xform_gcamp_mouse_NoGSR);
    clear xform_gcamp_mouse_NoGSR
    
    xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_mouse_NoGSR);
    clear xform_green_mouse_NoGSR
    %
%     xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
%     clear xform_ddatahb_mouse_NoGSR       
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_correction11_mice','.mat');
% 
% xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
%xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
% 
% xform_gcamp_mice_GSR = mean(xform_gcamp_mice_GSR,4);
xform_gcamp_mice_NoGSR = mean(xform_gcamp_mice_NoGSR,4);

% xform_gcampCorr_mice_GSR = mean(xform_gcampCorr_mice_GSR,4);
xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,4);
% 
% xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);

catDir = 'X:\Paper1\GCaMP\cat';
% save(fullfile(catDir,processedName_mice),...
%     'xform_datahb_mice_GSR','xform_datahb_mice_NoGSR',...
%     'xform_gcamp_mice_GSR','xform_gcamp_mice_NoGSR',...
%     'xform_gcampCorr_mice_GSR', 'xform_gcampCorr_mice_NoGSR',...
%      'xform_green_mice_GSR', 'xform_green_mice_NoGSR','xform_isbrain_mice')
save(fullfile(catDir,processedName_mice),'xform_gcamp_mice_NoGSR',...
 'xform_gcampCorr_mice_NoGSR','xform_green_mice_NoGSR','xform_isbrain_mice')

% peak map
baseline = mean(xform_gcampCorr_mice_NoGSR(:,:,1:125),3);
peakMap_NoGSR = mean(xform_gcampCorr_mice_NoGSR(:,:,126:250),3);
peakMap_NoGSR = peakMap_NoGSR-baseline;
figure
imagesc(peakMap_NoGSR)
axis image off
colormap jet
% ROI
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
[X,Y] = meshgrid(1:128,1:128);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_NoGSR(ROI),99);
temp = peakMap_NoGSR.*ROI;
ROI_NoGSR = temp>0.75*max_ROI;
        
save(fullfile(catDir,processedName_mice),'ROI_NoGSR','-append')
