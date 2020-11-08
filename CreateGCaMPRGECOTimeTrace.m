excelRows = [124,126,127];
    

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'L:\GCaMP\cat' ;



stimStartTime = 5;

nVx = 128;
nVy = 128;

xform_datahb_mice_GSR = [];
xform_datahb_mice_NoGSR = [];

xform_jrgeco1a_mice_GSR = [];
xform_jrgeco1a_mice_NoGSR = [];

xform_jrgeco1aCorr_mice_GSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];

xform_red_mice_GSR = [];
xform_red_mice_NoGSR = [];

%  xform_FAD_mice_GSR = [];
%  xform_FAD_mice_NoGSR = [];
%
% xform_FADCorr_mice_GSR = [];
% xform_FADCorr_mice_NoGSR = [];
%
%
% xform_gcamp_mice_GSR = [];
xform_gcamp_mice_NoGSR = [];
%
% xform_gcampCorr_mice_GSR = [];
xform_gcampCorr_mice_NoGSR = [];
%
% xform_green_mice_GSR = [];
%  xform_green_mice_NoGSR = [];


xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
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
    
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
%     mouseName = char(mouseName);
%     maskDir = rawdataloc;
%     maskName = strcat(recDate,'-',mouseName(1:16),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,maskName),'xform_isbrain');
%     xform_isbrain = ones(128,128);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    %xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    %    isbrain_mice = isbrain_mice.*isbrain;
    
        

        disp('loading processed data')
        load(fullfile(saveDir, processedName_mouse),'xform_gcamp_runs_NoGSR','xform_gcampCorr_runs_NoGSR')
        
        
        
         xform_gcamp_mice_NoGSR = cat(4,xform_gcamp_mice_NoGSR,xform_gcamp_runs_NoGSR);
        xform_gcampCorr_mice_NoGSR = cat(4,xform_gcampCorr_mice_NoGSR,xform_gcampCorr_runs_NoGSR);
end
        

    xform_gcamp_mice_NoGSR = mean(xform_gcamp_mice_NoGSR,4);
    xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,4);
 processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
    save(fullfile(catDir,processedName_mice),'xform_gcamp_mice_NoGSR','xform_gcampCorr_mice_NoGSR');
      
%     clear xform_datahb_mice_GSR   xform_gcamp_mice_GSR xform_gcampCorr_mice_GSR xform_green_mice_GSR
    
    
    
    peakMap_ROI = mean(xform_gcampCorr_mice_NoGSR(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);   
   figure
   colormap jet
    imagesc(peakMap_ROI,[-0.015 0.015])
    axis image off
    
    [X,Y] = meshgrid(1:128,1:128);
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
   
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    max_ROI = prctile(peakMap_ROI(ROI),99);
    temp = double(peakMap_ROI).*double(ROI);
    ROI_gcamp = temp>max_ROI*0.75;
    hold on
    ROI_contour = bwperim(ROI_gcamp);
     contour( ROI_contour)   
    

ibi_gcamp = reshape(ROI_gcamp,1,[]);
xform_gcampCorr = reshape(xform_gcampCorr_mice_NoGSR,128*128,[]);
gcampCorr = mean(xform_gcampCorr(ibi_gcamp,:),1);

xform_gcamp = reshape(xform_gcamp_mice_NoGSR,128*128,[]);
gcamp= mean(xform_gcamp(ibi_gcamp,:),1);


   peakMap_ROI = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);   
   figure
   colormap jet
    imagesc(peakMap_ROI,[-0.03 0.03])
    axis image off
  
    [X,Y] = meshgrid(1:128,1:128);
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
   
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    max_ROI = prctile(peakMap_ROI(ROI),99);
    temp = double(peakMap_ROI).*double(ROI);
    ROI_jrgeco1a = temp>max_ROI*0.75;
    hold on
    ROI_contour = bwperim(ROI_jrgeco1a);
     contour( ROI_contour)   
    

ibi_jrgeco1a = reshape(ROI_jrgeco1a,1,[]);
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
jrgeco1aCorr = mean(xform_jrgeco1aCorr(ibi_jrgeco1a,:),1);

xform_jrgeco1a = reshape(xform_jrgeco1a_mice_NoGSR,128*128,[]);
jrgeco1a= mean(xform_jrgeco1a(ibi_jrgeco1a,:),1);



figure;
plot((1:1200)/20,gcamp,'g');
hold on
plot((1:1200)/20,gcampCorr,'color',[0,0.5,0]);
hold on
plot((1:750)/25,jrgeco1a,'r');
hold on
plot((1:750)/25,jrgeco1aCorr,'m');
xlim([0 30])
legend('GCamP','Corrected GCaMP','RGECO','Corrected RGECO')
ylabel('Fluorescence(\DeltaF/F)');
xlabel('time')
title('Camparison b/w GCaMP and RGECO with Whisker Stimulation')








%% No GSR



