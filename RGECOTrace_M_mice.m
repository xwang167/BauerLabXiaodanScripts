
close all;clearvars;clc

import mouse.*

excelRows =  [367,371,375,397,401,409]+1;%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'J:\PVRGECO\cat' ;






stimStartTime = 5;

nVx = 128;
nVy = 128;

ROI_jrgeco1aCorr_mice_NoGSR_SS = [];
ROI_jrgeco1aCorr_mice_NoGSR_SS_flip = [];
ROI_jrgeco1aCorr_mice_NoGSR_MRing = [];
ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip = [];


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
    
    %     maskDir = saveDir;
    %     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    mouseName = char(mouseName);
    maskDir = rawdataloc;
    maskName = strcat(recDate,'-',mouseName(1:end-7),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain');
    %     xform_isbrain = ones(128,128);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    %xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    %    isbrain_mice = isbrain_mice.*isbrain;
    
    
    
    
    
    if strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
        
        
        disp('loading  Non GRS data')
        
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','ROI_NoGSR')
        
        
        peakMap_ROI = mean(xform_jrgeco1aCorr_mouse_NoGSR(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);
        figure
        colormap jet
        imagesc(peakMap_ROI,[-0.01 0.01])
        axis image off
        colorbar
        [X,Y] = meshgrid(1:128,1:128);
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        MRingROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        min_ROI = prctile(peakMap_ROI(MRingROI),1);
        temp = double(peakMap_ROI).*double(MRingROI);
        MRingROI = temp<min_ROI*0.75;
        MRingROI = MRingROI-ROI_NoGSR;
        MRingROI(MRingROI<0) = 0;
        hold on
        
        contour(ROI_NoGSR,'w')
        hold on
        contour(MRingROI,'k')
        
        
   load(fullfile(saveDir,strcat(recDate,'-',mouseName(1:end-8),'-SS-',mouseName((end-4):end),'-stim_processed_mouse.mat')),'SSRingROI')
   SSROI = SSRingROI;
        hold on
        contour(SSROI,'m')
        
        
        ROI_MRing_flip = flip(MRingROI,2);
        ROI_SS_flip = flip(SSROI,2);
        
        hold on
        contour(ROI_MRing_flip,'r');
        hold on
        contour(ROI_SS_flip,'b')
        
        
        iROI_MRing = logical(reshape(MRingROI,1,[]));
        iROI_SS = logical(reshape(SSROI,1,[]));
        iROI_MRing_flip = logical(reshape(ROI_MRing_flip,1,[]));
        iROI_SS_flip = logical(reshape(ROI_SS_flip,1,[]));
        
        saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.fig')))
        saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.png')))
        
        jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr_mouse_NoGSR,length(iROI_MRing),[]);
        ROI_jrgeco1aCorr_mouse_NoGSR_MRing = mean(jrgeco1aCorr_NoGSR(iROI_MRing,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_MRing = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_MRing,ROI_jrgeco1aCorr_mouse_NoGSR_MRing);
        
        ROI_jrgeco1aCorr_mouse_NoGSR_SS = mean(jrgeco1aCorr_NoGSR(iROI_SS,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_SS = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_SS,ROI_jrgeco1aCorr_mouse_NoGSR_SS );
        
        ROI_jrgeco1aCorr_mouse_NoGSR_MRing_flip = mean(jrgeco1aCorr_NoGSR(iROI_MRing_flip,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip,ROI_jrgeco1aCorr_mouse_NoGSR_MRing_flip );
        
        ROI_jrgeco1aCorr_mouse_NoGSR_SS_flip = mean(jrgeco1aCorr_NoGSR(iROI_SS_flip,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_SS_flip = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_SS_flip,ROI_jrgeco1aCorr_mouse_NoGSR_SS_flip );
        
        clear xform_jrgeco1aCorr_mouse_NoGSR
        
    end
end



ROI_jrgeco1aCorr_mice_NoGSR_MRing = mean(ROI_jrgeco1aCorr_mice_NoGSR_MRing,1);
ROI_jrgeco1aCorr_mice_NoGSR_SS = mean(ROI_jrgeco1aCorr_mice_NoGSR_SS,1);
ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip = mean(ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip,1);
ROI_jrgeco1aCorr_mice_NoGSR_SS_flip = mean(ROI_jrgeco1aCorr_mice_NoGSR_SS_flip,1);


fMax = max(abs(ROI_jrgeco1aCorr_mice_NoGSR_MRing))*100;
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');

if strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
    figure;
    
    x = (1:round( sessionInfo.stimblocksize))/ sessionInfo.framerate;
    
    
    
    plot(x,ROI_jrgeco1aCorr_mice_NoGSR_MRing*100,'k-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_MRing_flip*100,'r-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_SS*100,'m-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_SS_flip*100,'b-');
    
    hold on
    ylabel('Fluorescence(\DeltaF/F%)')
    
    ylim([-1.1*fMax 1.1*fMax])
  
    
    set(findall(gca, 'Type', 'Line'),'LineWidth',1);
    
    
    xlabel('Time(s)','FontSize',12)
    
  
    
    
    
    
    xlim([0 round( sessionInfo.stimblocksize/ sessionInfo.framerate)])
    
    hold on
    
    
    
    
    legend('M Ring','M Ring flip','Somatosensory','Somatosensory flip','location','southeast')
    
    
    %annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',miceName,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
    saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAcverage_NoGSR_DiffLoc.fig')))
    saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAverage_NoGSR_DiffLoc.png')))
end