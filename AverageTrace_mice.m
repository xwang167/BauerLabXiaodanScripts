
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

ROI_oxy_mice_NoGSR = [];

ROI_deoxy_mice_NoGSR = [];

ROI_jrgeco1a_mice_NoGSR = [];

ROI_jrgeco1aCorr_mice_NoGSR = [];

ROI_red_mice_NoGSR = [];



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
    maskName = strcat(recDate,'-',mouseName(1:16),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
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
   
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    min_ROI = prctile(peakMap_ROI(ROI),1);
    temp = double(peakMap_ROI).*double(ROI);
    ROI = temp<min_ROI*0.75;
    ROI = ROI-ROI_NoGSR;
    ROI(ROI<0) = 0;
    hold on

contour(ROI_NoGSR,'r')
hold on
contour(ROI,'k')
     
     saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.fig')))
     saveas(gcf,fullfile(saveDir,strcat(mouseName,'RingROI_NoGSR.png')))

     
     
iROI = logical(reshape(ROI,1,[]));
    

      
       oxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,1,:),length(iROI),[]); 
       ROI_oxy_mouse_NoGSR = mean(oxy_NoGSR(iROI,:),1);       
       ROI_oxy_mice_NoGSR = cat(1,ROI_oxy_mice_NoGSR,ROI_oxy_mouse_NoGSR );
        
            
       deoxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,2,:),length(iROI),[]); 
       ROI_deoxy_mouse_NoGSR = mean(deoxy_NoGSR(iROI,:),1);       
       ROI_deoxy_mice_NoGSR = cat(1,ROI_deoxy_mice_NoGSR,ROI_deoxy_mouse_NoGSR );
        clear xform_datahb_mouse_NoGSR
        
        
               jrgeco1a_NoGSR = reshape(xform_jrgeco1a_mouse_NoGSR,length(iROI),[]); 
       ROI_jrgeco1a_mouse_NoGSR = mean(jrgeco1a_NoGSR(iROI,:),1);       
       ROI_jrgeco1a_mice_NoGSR = cat(1,ROI_jrgeco1a_mice_NoGSR,ROI_jrgeco1a_mouse_NoGSR );
        clear xform_jrgeco1a_mouse_NoGSR
        
               jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr_mouse_NoGSR,length(iROI),[]); 
       ROI_jrgeco1aCorr_mouse_NoGSR = mean(jrgeco1aCorr_NoGSR(iROI,:),1);       
       ROI_jrgeco1aCorr_mice_NoGSR = cat(1,ROI_jrgeco1aCorr_mice_NoGSR,ROI_jrgeco1aCorr_mouse_NoGSR );
        clear xform_jrgeco1aCorr_mouse_NoGSR
        
        
            
       red_NoGSR = reshape(xform_red_mouse_NoGSR,length(iROI),[]); 
       ROI_red_mouse_NoGSR = mean(red_NoGSR(iROI,:),1);       
       ROI_red_mice_NoGSR = cat(1,ROI_red_mice_NoGSR,ROI_red_mouse_NoGSR );
        clear xform_red_mouse_NoGSR
        
    end
end


ROI_oxy_mice_NoGSR = mean(ROI_oxy_mice_NoGSR,1);
ROI_deoxy_mice_NoGSR = mean(ROI_deoxy_mice_NoGSR,1);
ROI_total_mice_NoGSR = ROI_oxy_mice_NoGSR + ROI_deoxy_mice_NoGSR;


cMax = max(abs([ROI_oxy_mice_NoGSR,ROI_deoxy_mice_NoGSR,ROI_total_mice_NoGSR]),[],'all')*10^6;




ROI_jrgeco1a_mice_NoGSR = mean(ROI_jrgeco1a_mice_NoGSR,1);
ROI_jrgeco1aCorr_mice_NoGSR = mean(ROI_jrgeco1aCorr_mice_NoGSR,1);
ROI_red_mice_NoGSR = mean(ROI_red_mice_NoGSR,1);

fMax = max(abs(ROI_jrgeco1aCorr_mice_NoGSR))*100;
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');

if strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
   figure;

x = (1:round( sessionInfo.stimblocksize))/ sessionInfo.framerate;


    
    plot(x,ROI_jrgeco1aCorr_mice_NoGSR*100,'m-');
    
    hold on
   ylabel('Fluorescence(\DeltaF/F%)')

ylim([-1.1*fMax 1.1*fMax])
yyaxis right

plot(x,ROI_oxy_mice_NoGSR*10^6,'r-');

hold on

plot(x,ROI_deoxy_mice_NoGSR*10^6,'b-');

hold on

plot(x,ROI_total_mice_NoGSR*10^6,'Color','k');

set(findall(gca, 'Type', 'Line'),'LineWidth',1);


xlabel('Time(s)','FontSize',12)

ylabel('Hb(\Delta\muM)','FontSize',12)

ylim([-1.1*cMax 1.1*cMax])



xlim([0 round( sessionInfo.stimblocksize/ sessionInfo.framerate)])

hold on



    
legend('jRGECO1aCorr','HbO','HbR','Total','location','southeast')
    

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',miceName,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
     saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAcverage_NoGSR.fig')))
     saveas(gcf,fullfile(catDir,strcat(mouseName,'TimeTraceAverage_NoGSR.png')))
end
















%% No GSR




