% load('L:\RGECO\191028\FilterFirst\191028-R6M1-awake-fc1_processed.mat','lagTime_Projection_Calcium_Delta','lagAmp_Projection_Calcium_Delta')
% load('L:\RGECO\191028\191028-R6M1-awake-fc1_processed.mat','xform_jrgeco1aCorr')
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [183,185,228,232,236];
powerdata_ms_mice = nan(15,2049);
powerdata_rs_mice = nan(15,2049);
ll=1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    %maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %load(fullfile(saveDir,maskName),'xform_isbrain')
    saveDir_new =  fullfile(saveDir,'FilterFirst');
    for n = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        load(fullfile(saveDir_new,processedName),'lagTime_Projection_Calcium_Delta')
        figure
        imagesc(lagTime_Projection_Calcium_Delta,[-0.5 0.5])
        colormap jet
        colorbar
        axis image off
    % ROI of right motor-somatosensory
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        [X,Y] = meshgrid(1:64,1:64);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI_MSR = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI_MSR = prctile(lagTime_Projection_Calcium_Delta(ROI_MSR),99);
        temp = lagTime_Projection_Calcium_Delta.*ROI_MSR;
        ROI_MSR = temp>0.5*max_ROI_MSR;
        hold on;
        contour(ROI_MSR,'k')
    % ROI of left motor-somatosensory    
                [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        [X,Y] = meshgrid(1:64,1:64);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI_MSL = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI_MSL = prctile(lagTime_Projection_Calcium_Delta(ROI_MSL),99);
        temp = lagTime_Projection_Calcium_Delta.*ROI_MSL; 
        ROI_MSL = temp>0.5*max_ROI_MSL;
        hold on;
        contour(ROI_MSL,'k')
        title('jrgeco1aCorr');
        
     % ROI of retrosplenal  
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        [X,Y] = meshgrid(1:64,1:64);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI_RS = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        min_ROI_RS = prctile(lagTime_Projection_Calcium_Delta(ROI_RS),1);
        temp = lagTime_Projection_Calcium_Delta.*ROI_RS;
        ROI_RS = temp<0.75*min_ROI_RS;
        hold on;
        contour(ROI_RS,'r')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-jrgeco1aCorr'));
        
        saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag_ROI.png')));
        saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag_ROI.fig')));
        
        
        ROI_MS = ROI_MSL + ROI_MSR;
        ROI_MS = imresize(ROI_MS,2);
        ROI_RS = imresize(ROI_RS,2);
        
        [hz, powerdata_ms] = QCcheck_CalcPDS(xform_jrgeco1aCorr,25,ROI_MS);
        [hz, powerdata_rs] = QCcheck_CalcPDS(xform_jrgeco1aCorr,25,ROI_RS);
        powerdata_ms_mice(ll,:) = powerdata_ms;
        powerdata_rs_mice(ll,:) = powerdata_rs;
        
        figure;loglog(hz,powerdata_ms,'red')
        hold on
        loglog(hz,powerdata_rs,'b')
        legend('Moter-somatosensory', 'Retrosplenial')
        xlabel('Freqency(Hz)')
        ylabel('Fluor((\DeltaF/F)^2/Hz')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' pwelch for region'))
        saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag-pwelchRegion.png')));
        saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag-pwelchRegion.fig')));
        save(fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat')),'powerdata_ms','powerdata_rs','hz','-append')
        ll = ll+1;
    end
end

saveCat = 'L:\RGECO\cat'; 
powerdata_rs_mice = mean(powerdata_rs_mice,1);
powerdata_ms_mice = mean(powerdata_ms_mice,1);
save(fullfile(saveCat,'191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat'),...
    'powerdata_rs_mice','powerdata_ms_mice','-append')
   figure;loglog(hz,powerdata_ms,'red')
        hold on
        loglog(hz,powerdata_rs,'b')
        legend('Moter-somatosensory', 'Retrosplenial')
        xlabel('Freqency(Hz)')
        ylabel('Fluor((\DeltaF/F)^2/Hz')
title( 'awake mice pwelch for region')
  [P,H] = signrank(powerdata_rs_mice,powerdata_ms_mice);
  saveas(gcf,fullfile(saveCat,['191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_jRGECO1aCorr_ProjLag-pwelchRegion.png']));
        saveas(gcf,fullfile(saveCat,['191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_jRGECO1aCorr_ProjLag-pwelchRegion.fig']));
    
%load('191028-R6M1-anes-fc3_processed.mat', 'lagTimeTrial_0p1LPF_HbTCalcium')
