function photoSwitchVis(excelFile,excelRows,runs,miceName,saveDir_cat,nVx,nVy,ROI)
import mouse.*
processed_mice = zeros(nVy,nVx,3,600,length(excelRows));
mouseInd = 1;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    rawdataloc = excelRaw{3};
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.blockLength = excelRaw{11};
    sessionInfo.stimbaseline = excelRaw{12};
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %    load(fullfile(maskDir_new,maskName_new), 'isbrain')
    %   isbrain = double(isbrain);
    load(fullfile(rawdataloc,recDate,maskName_new),'affineMarkers')
    processed_mouse = zeros(nVy,nVx,3,sessionInfo.blockLength,length(runs));
    disp(mouseName)
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
                
        xform_datahb = reshape(xform_datahb,nVx,nVy,2,sessionInfo.blockLength,[]);
      
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,nVx,nVy,sessionInfo.blockLength,[]);
        
        processed_mouse(:,:,1:2,:,n) = squeeze(mean(xform_datahb,5));
          clear xform_datahb
        processed_mouse(:,:,3,:,n) = squeeze(mean(xform_jrgeco1aCorr,4));
        clear xform_jrgeco1aCorr
        
        disp(['run #' num2str(n)])
    end
    
    processed_mouse = squeeze(mean(processed_mouse,5));
        
    save(fullfile(saveDir,strcat(recDate,mouseName,'processed_mouse')),'processed_mouse');

    processed_mice(:,:,:,:,mouseInd)= processed_mouse;
    mouseInd = mouseInd+1;
end
processed_mice = squeeze(mean(processed_mice,5));
save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'MiceRawData.mat')),'processed_mice')
if ~exist('ROI', 'var')
    peakMap_ROI = processed_mice(:,:,4,sessionInfo.stimbaseline+1);
    if strcmp(sessionInfo.mouseType,'jrgeco1a')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile('K:\RGECO\Raw\awake_ROI.mat'),'ROI_NoGSR')
        ROI = ROI_NoGSR;
    else
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        [x1,y1] = ginput(1);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 5;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),70);
        temp = double(peakMap_ROI).*double(ROI);
        ROI = temp>=max_ROI;
        hold on
        ROI_contour = bwperim(ROI);
        contour( ROI_contour,'k');
        pause;
        nonROI = roipoly();
        ROI(nonROI) = 0;
        figure;
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        hold on
        ROI_contour = bwperim(ROI);
        contour( ROI_contour,'k');
    end
    
end


sessionInfo.stimblocksize = excelRaw{11};
sessionInfo.stimbaseline=excelRaw{12};
sessionInfo.stimduration = excelRaw{13};
sessionInfo.stimFrequency = excelRaw{16};
stimBaselineFrames = sessionInfo.stimbaseline;
stimDurationFrames = sessionInfo.stimduration*sessionInfo.framerate;


texttitle = strcat(miceName,' HbO ', ' under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'HbO'));
quanti_bleedover(processed_mice(:,:,1,:)*10^6,stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,-0.5,0.5,0.5,texttitle,output,'\Delta\muM','processed')


texttitle = strcat(miceName,' HbR ', ' under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'HbR'));
quanti_bleedover(processed_mice(:,:,2,:)*10^6,stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,-0.5,0.5,0.5,texttitle,output,'\Delta\muM','processed')


texttitle = strcat(miceName,' jRGECOCorr ', ' under NonOverlap Mode');
    output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'jRGECOCorr'));
    quanti_bleedover(processed_mice(:,:,3,:)*100,stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,-0.3,0.3,0.3,texttitle,output,'\DeltaF/F%','processed')
clear raw_mice






% texttitle = strcat('Averaged counts for LED1 from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED1-Cam2-'));
% 
%
% texttitle = strcat(mouseName,'Averaged counts for LED2 from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED2-Cam2-'));
% quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^5,8*10^5,500,texttitle,output)
%
% texttitle = strcat(mouseName,'Averaged counts for Fluor from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED3-Cam2-'));
% quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^4,4*10^5,500,texttitle,output)
%
% texttitle = strcat(mouseName,'Averaged counts for Laser from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-Laser-Cam2-'));
% quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2600,5000,10000,texttitle,output)
















