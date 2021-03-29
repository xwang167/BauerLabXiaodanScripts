
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 240;%[195 202 204 230 234 240];%[181,183,185,228,232,236];%321:327;
runs = 3;
load('D:\OIS_Process\noVasculaturemask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')

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
    %     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %     load(fullfile(saveDir,maskName), 'xform_isbrain')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr')
        load(fullfile(saveDir, processedName),'xform_jrgeco1aCorr')
%         load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        
        xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
        xform_total(isinf(xform_total)) = 0;
        xform_total(isnan(xform_total)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        %comparing our NVC measures to Hillman (0.02-2)
        disp('filtering')
        xform_total_filtered = mouse.freq.filterData(double(xform_total),0.02,2,fs);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
        xform_FADCorr_filtered = mouse.freq.filterData(double(xform_FADCorr),0.02,2,fs);
        xform_jrgeco1aCorr_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.02,2,fs);
        edgeLen =1;
        tZone = 4;
        corrThr = 0;
        validRange = - edgeLen: round(tZone*fs);
        tLim = [-2 2];
        tLim_FAD = [0 0.3];
        rLim = [-1 1];
        
        disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
        load('D:\OIS_Process\noVasculaturemask.mat')
        figure
        imagesc(lagTimeTrial_HbTCalcium,[0 2]);colormap jet
        title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(96,45,'filled','k')

        figure
        plot((1:14999)/25,squeeze(xform_jrgeco1aCorr_filtered(45,96,:))*100)
        hold on
        plot((1:14999)/25,squeeze(xform_total_filtered(45,96,:))*10^6)
        
              figure
        plot((1:7500)/25,squeeze(xform_jrgeco1aCorr_filtered(45,96,1:7500))*100)
        hold on
        plot((1:7500)/25,squeeze(xform_total_filtered(45,96,1:7500))*10^6)
        
        [lagTime_HbTCalcium,lagAmp_HbTCalcium,covResultPix_HbTCalcium] = mouse.conn.dotLag(...
            xform_total_filtered(45,96,:),xform_jrgeco1aCorr_filtered(45,96,:),edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_HbTCalcium= lagTimeTrial_HbTCalcium./fs;
        
        
        
        figure
        plot((1:14999)/25,squeeze(xform_jrgeco1aCorr_filtered(99,90,:))*100)
        hold on
        plot((1:14999)/25,squeeze(xform_total_filtered(99,90,:))*10^6)
        
              figure
        plot((1:7500)/25,squeeze(xform_jrgeco1aCorr_filtered(99,90,1:7500))*100)
        hold on
        plot((1:7500)/25,squeeze(xform_total_filtered(99,90,1:7500))*10^6)
        
             [lagTime_HbTCalcium,lagAmp_HbTCalcium,covResultPix_HbTCalcium] = mouse.conn.dotLag(...
            xform_total_filtered(99,90,:),xform_jrgeco1aCorr_filtered(99,90,:),edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_HbTCalcium= lagTimeTrial_HbTCalcium./fs;   
        
        
        figure
        imagesc(lagTimeTrial_FADCalcium,[0 0.3]);colormap jet
        title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(10,72,'filled','k')
 
        [lagTime_FADCalcium,lagAmp_FADCalcium,covResultPix_FADCalcium] = mouse.conn.dotLag(...
            xform_FADCorr_filtered(72,10,:),xform_jrgeco1aCorr_filtered(72,10,:),edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_FADCalcium= lagTimeTrial_FADCalcium./fs;
        
        
        
      
        figure
        imagesc(lagTimeTrial_FADCalcium,[0 0.3]);colormap jet
        title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(8,96,'filled','k')
        
        
 
        [lagTime_FADCalcium,lagAmp_FADCalcium,covResultPix_FADCalcium] = mouse.conn.dotLag(...
            xform_FADCorr_filtered(96,8,:),xform_jrgeco1aCorr_filtered(96,8,:),edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_FADCalcium= lagTimeTrial_FADCalcium./fs;
        
        
        
         figure
        imagesc(lagTimeTrial_FADCalcium,[0 0.3]);colormap jet
        title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(49,95,'filled','w')
        
        
 
        [lagTime_FADCalcium,lagAmp_FADCalcium,covResultPix_FADCalcium] = mouse.conn.dotLag(...
            xform_FADCorr_filtered(95,49,:),xform_jrgeco1aCorr_filtered(95,49,:),edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_FADCalcium= lagTimeTrial_FADCalcium./fs;
        
        
        
        
            figure
        imagesc(lagTimeTrial_HbTFAD,[0 1.5]);colormap jet
        title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(9,98,'filled','w')
        
        figure
        plot((1:14999)/25,squeeze( xform_FADCorr_filtered(98,9,:))*100)
        hold on
        plot((1:14999)/25,squeeze( xform_total_filtered(98,9,:))*10^6)
       xlabel('Time(s)')
       legend('FAD','HbT')
        figure
       plot((1:7500)/25,squeeze( xform_FADCorr_filtered(98,9,1:7500))*100)
        hold on
        plot((1:7500)/25,squeeze( xform_total_filtered(98,9,1:7500))*10^6)
        xlabel('Time(s)')
        legend('FAD','HbT')
        
                [lagTime_HbTFAD,lagAmp_HbTFAD,covResultPix_HbTFAD ]= mouse.conn.dotLag(...
            xform_total_filtered(98,9,:),xform_FADCorr_filtered(98,9,:),edgeLen,validRange,corrThr, true,true);
        lagTime_HbTFAD= lagTime_HbTFAD./fs;
      
   
        
        
        
        
        
            figure
        imagesc(lagTimeTrial_HbTFAD,[0 1.5]);colormap jet
        title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        hold on
        scatter(28,98,'filled','w')
        
        figure
        plot((1:14999)/25,squeeze( xform_FADCorr_filtered(98,28,:))*100)
        hold on
        plot((1:14999)/25,squeeze( xform_total_filtered(98,28,:))*10^6)
       xlabel('Time(s)')
       legend('FAD','HbT')
        figure
       plot((1:7500)/25,squeeze( xform_FADCorr_filtered(98,28,1:7500))*100)
        hold on
        plot((1:7500)/25,squeeze( xform_total_filtered(98,28,1:7500))*10^6)
        xlabel('Time(s)')
        legend('FAD','HbT')
        
                [lagTime_HbTFAD,lagAmp_HbTFAD,covResultPix_HbTFAD ]= mouse.conn.dotLag(...
            xform_total_filtered(98,28,:),xform_FADCorr_filtered(98,28,:),edgeLen,validRange,corrThr, true,true);
        lagTime_HbTFAD= lagTime_HbTFAD./fs;
      
        

        
       

        
        
        close all
    end
end




