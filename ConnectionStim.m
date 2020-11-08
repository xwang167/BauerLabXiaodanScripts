
close all;clearvars;clc
excelRows = 366; %[182,184,186,237];%182,184,186,203,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
stimStartTime = 5;

nVx = 128;
nVy = 128;
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
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    info.freqout=1;
    
    
    %maskDir = saveDir;
    %maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    maskDir = rawdataloc;
    maskName = strcat(recDate,'-N4M326-opto3-LandmarksAndMask','.mat');
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain','isbrain');
    
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
%     load(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR',...
%         'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','ROI_NoGSR');
        load(fullfile(saveDir,processedName_mouse),...
        'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','ROI_NoGSR');
    
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','-append');
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','-append');
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
   
    texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering-Contralateral');
    
    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR-Contralateral'));
    numDesample = size(xform_red_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
%     disp('QC on non GSR stim')
%     peakMap_ROI = mean(xform_jrgeco1aCorr_mouse_NoGSR(:,:, sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);
%     figure
%     imagesc(peakMap_ROI*1000)
%       axis image off
%     colormap jet
%     [X,Y] = meshgrid(1:128,1:128);
%     
%     [x1,y1] = ginput(1);
%     [x2,y2] = ginput(1);
%     
%     radius = sqrt((x1-x2)^2+(y1-y2)^2);
%     
%     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%     max_ROI = prctile(peakMap_ROI(ROI),99);
%     temp = double(peakMap_ROI).*double(ROI);
%     ROI_NoGSR = temp>max_ROI*0.75;
%     hold on
%     ROI_contour = bwperim(ROI_NoGSR);
%      contour( ROI_contour,'r');


%     figure
%     imagesc(peakMap_ROI*1000)
%       axis image off
%     colormap jet
%     hold on
%     ROI_contour = bwperim(flip(ROI_NoGSR,2));
%      contour( ROI_contour,'r');

%   
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','ROI.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','ROI.png')))
end
%             if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
    [],[],[],xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
    xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,flip(ROI_NoGSR,2));
%             else
%                 QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
%                     xform_FAD_mouse_NoGSR/3,xform_FADCorr_mouse_NoGSR/3,xform_green_mouse_NoGSR/3,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
%                     isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%             end
%             clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR



%%
texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering','-Contralateral');
output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR','-Contralateral'));


disp('QC on GSR stim')
% QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_GSR(:,:,2,:))*10^6,...
%     [],[],[],xform_jrgeco1a_mouse_GSR*100,xform_jrgeco1aCorr_mouse_GSR*100,xform_red_mouse_GSR*100,...
%     xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,flip(ROI_NoGSR,2));
% 
clear xform_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR
close all


end