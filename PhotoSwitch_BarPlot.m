
close all;clearvars;clc

import mouse.*

excelRows =  [367 371 375];%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];



stimStartTime = 5;

nVx = 128;
nVy = 128;

ROI_oxy_mice_NoGSR = zeros(1,length(excelRows));
ROI_deoxy_mice_NoGSR = zeros(1,length(excelRows));
ROI_total_mice_NoGSR = zeros(1, length(excelRows));
ROI_jrgeco1aCorr_mice_NoGSR = zeros(1,length(excelRows));

xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
ii = 1;
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
%     
%         maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    mouseName = char(mouseName);
     maskDir = rawdataloc;
    maskName = strcat(recDate,'-',mouseName(1:7),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain');
    %     xform_isbrain = ones(128,128);

    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
  %  processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-allBlocks','.mat');
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
%        isbrain_mice = isbrain_mice.*isbrain;
%     
    
    
    
    
  
        
        
        disp('loading  Non GRS data')
        
%         load(fullfile(saveDir,processedName_mouse),...
%             'xform_datahb_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','ROI_NoGSR')
%         
%        
              load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','ROI_NoGSR')
%                load(fullfile(saveDir,processedName_mouse),...
%             'xform_datahb_mouse_NoGSR')
       % load(fullfile(saveDir, strcat(recDate,'-',mouseName,'-',sessionType,'1_processed.mat')),'ROI_NoGSR')
        iROI = logical(reshape(ROI_GSR,1,[]));
        
        oxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,1,:),length(iROI),[]);
        ROI_oxy_mouse_NoGSR = mean(mean(oxy_NoGSR(iROI,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+8*sessionInfo.framerate),1),2);
        ROI_oxy_mice_NoGSR(ii) = ROI_oxy_mouse_NoGSR;
        
        deoxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,2,:),length(iROI),[]);
        ROI_deoxy_mouse_NoGSR = mean(mean(deoxy_NoGSR(iROI,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+8*sessionInfo.framerate),1),2);
        ROI_deoxy_mice_NoGSR(ii) = ROI_deoxy_mouse_NoGSR ;
        clear xform_datahb_mouse
 
        ROI_total_mouse_NoGSR = ROI_oxy_mouse_NoGSR + ROI_deoxy_mouse_NoGSR;
        ROI_total_mice_NoGSR(ii) = ROI_total_mouse_NoGSR;
        
        
        jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr_mouse_NoGSR,length(iROI),[]);
        ROI_jrgeco1aCorr_mouse_NoGSR = mean(mean(jrgeco1aCorr_NoGSR(iROI,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),2),1);
        ROI_jrgeco1aCorr_mice_NoGSR(ii) = ROI_jrgeco1aCorr_mouse_NoGSR;
        clear xform_jrgeco1aCorr_mouse_NoGSR
        
        ii = ii+1;
 
end



ROI_oxy_mice_NoGSR_mean = mean(ROI_oxy_mice_NoGSR,2);
ROI_deoxy_mice_NoGSR_mean = mean(ROI_deoxy_mice_NoGSR,2);
ROI_total_mice_NoGSR_mean = mean(ROI_total_mice_NoGSR,2);
ROI_jrgeco1aCorr_mice_NoGSR_mean = mean(ROI_jrgeco1aCorr_mice_NoGSR,2);

ROI_oxy_mice_NoGSR_std = std(ROI_oxy_mice_NoGSR);
ROI_deoxy_mice_NoGSR_std = std(ROI_deoxy_mice_NoGSR);
ROI_total_mice_NoGSR_std = std(ROI_total_mice_NoGSR);
ROI_jrgeco1aCorr_mice_NoGSR_std = std(ROI_jrgeco1aCorr_mice_NoGSR);





X_HbT = 1:4;% PVRGECO ChR2RGECO Thy1RGECO WT
HbT_mean = [-1.4531e-7,4.2602e-7,3.5229e-8,4.9910e-9];
HbT_std = [5.4142e-8,1.7188e-7,7.9367e-8,8.9391e-8];

X_Calcium = 1:3;% PVRGECO ChR2RGECO Thy1RGECO
Calcium_mean = [-0.0083,0.0055,0.0049];
Calcium_std = [0.0045,0.0017,0.0018];

figure
bar(X_HbT,HbT_mean,0.5);
hold on
er = errorbar(X_HbT,HbT_mean,HbT_std);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'ChR2-PV=Thy1-RGECO','ChR2-RGECO','Thy1-RGECO','C57'})
ylabel('HbT(\DeltaM)')
title('HbT Comparison')
set(gca,'fontweight','bold')

figure
bar(X_Calcium,Calcium_mean,0.5);
hold on
er = errorbar(X_Calcium,Calcium_mean,Calcium_std);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'ChR2-PV=Thy1-RGECO','ChR2-RGECO','Thy1-RGECO'})
ylabel('Corrected RGECO(\DeltaF/F)')
title('Corrected RGECO Comparison')
set(gca,'fontweight','bold')





X_HbT = 1:4;% PVRGECO ChR2RGECO Thy1RGECO WT
HbT_mean = [-4.0083e-8,1.6652e-7,7.1182e-8,1.0132e-7];
HbT_std = [2.0164e-7,1.6694e-7,1.071e-7,2.4693e-7];

X_Calcium = 1:3;% PVRGECO ChR2RGECO Thy1RGECO
Calcium_mean = [-0.0047,0.0022,0.0026];
Calcium_std = [0.0018,0.0018,6.6802e-4];

figure
bar(X_HbT,HbT_mean,0.5);
hold on
er = errorbar(X_HbT,HbT_mean,HbT_std);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'ChR2-PV=Thy1-RGECO','ChR2-RGECO','Thy1-RGECO','C57'})
ylabel('HbT(\DeltaM)')
title('HbT Comparison')
set(gca,'fontweight','bold')

figure
bar(X_Calcium,Calcium_mean,0.5);
hold on
er = errorbar(X_Calcium,Calcium_mean,Calcium_std);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'ChR2-PV=Thy1-RGECO','ChR2-RGECO','Thy1-RGECO'})
ylabel('Corrected RGECO(\DeltaF/F)')
title('Corrected RGECO Comparison')
set(gca,'fontweight','bold')








%% No GSR





