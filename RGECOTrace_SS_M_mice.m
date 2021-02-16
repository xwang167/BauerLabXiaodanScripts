
close all;clearvars;clc

import mouse.*

excelRows =  [367,371,375,397,401,409];%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'J:\PVRGECO\cat' ;






stimStartTime = 5;

nVx = 128;
nVy = 128;

ROI_jrgeco1aCorr_mice_NoGSR_SSRing = [];
ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip = [];
ROI_jrgeco1aCorr_mice_NoGSR_M = [];
ROI_jrgeco1aCorr_mice_NoGSR_M_flip = [];


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
    maskName = strcat(recDate,'-',mouseName(1:end-8),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
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
        
        SSRingROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        min_ROI = prctile(peakMap_ROI(SSRingROI),1);
        temp = double(peakMap_ROI).*double(SSRingROI);
        SSRingROI = temp<min_ROI*0.75;
        save(fullfile(saveDir,processedName_mouse),'SSRingROI', '-append')
        SSRingROI = SSRingROI-ROI_NoGSR;
        SSRingROI(SSRingROI<0) = 0;
        hold on
        
        contour(ROI_NoGSR,'w')
        hold on
        contour(SSRingROI,'m')
        
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        MROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        min_ROI = prctile(peakMap_ROI(MROI),1);
        temp = double(peakMap_ROI).*double(MROI);
        MROI = temp<min_ROI*0.75;
        hold on
        contour(MROI,'k')
        
        
        ROI_SSRing_flip = flip(SSRingROI,2);
        ROI_M_flip = flip(MROI,2);
        
        hold on
        contour(ROI_SSRing_flip,'b');
        hold on
        contour(ROI_M_flip,'r')
        
        
        iROI_SSRing = logical(reshape(SSRingROI,1,[]));
        iROI_M = logical(reshape(MROI,1,[]));
        iROI_SSRing_flip = logical(reshape(ROI_SSRing_flip,1,[]));
        iROI_M_flip = logical(reshape(ROI_M_flip,1,[]));
        
        saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.fig')))
        saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.png')))
        
        jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr_mouse_NoGSR,length(iROI_SSRing),[]);
        ROI_jrgeco1aCorr_mouse_NoGSR_SSRing = mean(jrgeco1aCorr_NoGSR(iROI_SSRing,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_SSRing = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_SSRing,ROI_jrgeco1aCorr_mouse_NoGSR_SSRing);
        
        ROI_jrgeco1aCorr_mouse_NoGSR_M = mean(jrgeco1aCorr_NoGSR(iROI_M,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_M = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_M,ROI_jrgeco1aCorr_mouse_NoGSR_M );
        
        ROI_jrgeco1aCorr_mouse_NoGSR_SSRing_flip = mean(jrgeco1aCorr_NoGSR(iROI_SSRing_flip,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip,ROI_jrgeco1aCorr_mouse_NoGSR_SSRing_flip );
        
        ROI_jrgeco1aCorr_mouse_NoGSR_M_flip = mean(jrgeco1aCorr_NoGSR(iROI_M_flip,:),1);
        ROI_jrgeco1aCorr_mice_NoGSR_M_flip = cat(1,ROI_jrgeco1aCorr_mice_NoGSR_M_flip,ROI_jrgeco1aCorr_mouse_NoGSR_M_flip );
        
        clear xform_jrgeco1aCorr_mouse_NoGSR
        
    end
end



ROI_jrgeco1aCorr_mice_NoGSR_SSRing = mean(ROI_jrgeco1aCorr_mice_NoGSR_SSRing,1);
ROI_jrgeco1aCorr_mice_NoGSR_M = mean(ROI_jrgeco1aCorr_mice_NoGSR_M,1);
ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip = mean(ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip,1);
ROI_jrgeco1aCorr_mice_NoGSR_M_flip = mean(ROI_jrgeco1aCorr_mice_NoGSR_M_flip,1);


fMax = max(abs(ROI_jrgeco1aCorr_mice_NoGSR_SSRing))*100;
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');

if strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
    figure;
    
    x = (1:round( sessionInfo.stimblocksize))/ sessionInfo.framerate;
    
    
    
    plot(x,ROI_jrgeco1aCorr_mice_NoGSR_SSRing*100,'m-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_SSRing_flip*100,'b-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_M*100,'k-');
    
    hold on
     plot(x,ROI_jrgeco1aCorr_mice_NoGSR_M_flip*100,'r-');
    
    hold on
    ylabel('Fluorescence(\DeltaF/F%)')
    
    ylim([-1.1*fMax 1.1*fMax])
  
    
    set(findall(gca, 'Type', 'Line'),'LineWidth',1);
    
    
    xlabel('Time(s)','FontSize',12)
    
    ylabel('Hb(\Delta\muM)','FontSize',12)
    
    
    
    
    xlim([0 round( sessionInfo.stimblocksize/ sessionInfo.framerate)])
    
    hold on
    
    
    
    
    legend('SS Ring','SS Ring flip','Motor','Motor flip','location','southeast')
    
    
    %annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',miceName,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
    saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAcverage_NoGSR_DiffLoc.fig')))
    saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAverage_NoGSR_DiffLoc.png')))
end