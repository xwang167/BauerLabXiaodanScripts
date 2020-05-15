close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 329:335;

runs = 1:6;
% 
laser_mice = [];
green_mice = [];
red_mice = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;

    xform_Laser_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
 
     

           load(fullfile(saveDir,rawName),'rawdata')
          laser = reshape(rawdata(:,:,4,:),128,128,[],10);
          green = reshape(rawdata(:,:,1,:),128,128,[],10);
          fluor = reshape(rawdata(:,:,3,:),128,128,[],10);
          
           laser = mean(laser,4);
           green = mean(green,4);
           fluor = mean(fluor,4);
           
           
           xform_Laser_mouse = cat(4,xform_Laser_mouse,laser);
    end
    xform_Laser_mouse = mean(xform_Laser_mouse,4);
     save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_Laser_mouse','-append')
     xform_Laser_mice = cat(4,xform_Laser_mice,xform_Laser_mouse);
end
 xform_Laser_mice = mean(xform_Laser_mice,4);




load('K:\BleedOver\Cat\200320-NonChR2-RGECO-Anes-stim-allBlocks.mat', 'xform_datahb_mice')
load('K:\BleedOver\Cat\200320-NonChR2-RGECO-Anes-stim-allBlocks.mat', 'xform_jrgeco1aCorr_mice')
load('K:\BleedOver\Cat\200320-NonChR2-RGECO-Anes-stim-allBlocks.mat', 'ROI')
iROI = reshape(ROI,1,[]);
oxy = reshape(xform_datahb_mice(:,:,1,:),length(iROI),[]);
jrgeco1aCorr = reshape(xform_jrgeco1aCorr_mice,length(iROI),[]);

baseline_oxy = mean(oxy(:,1:100),2);
baseline_jrgeco1aCorr = mean(jrgeco1aCorr(:,1:100),2);

oxy = oxy - repmat(baseline_oxy,1,size(oxy,2));
jrgeco1aCorr = jrgeco1aCorr - repmat(baseline_jrgeco1aCorr,1,size(jrgeco1aCorr,2));


oxy_ROI = mean(oxy(iROI,:),1);
jrgeco1aCorr_ROI = mean(jrgeco1aCorr(iROI,:),1);


oxy_on = zeros(1,length(oxy_ROI)/2);
jrgeco1aCorr_on = zeros(1,length(jrgeco1aCorr_ROI)/2);


oxy_off = zeros(1,length(oxy_ROI)/2);
jrgeco1aCorr_off = zeros(1,length(jrgeco1aCorr_ROI)/2);


for ii = 1: length(oxy_ROI)/2
    oxy_on(1,ii) = oxy_ROI(1,2*ii-1);
    oxy_off(1,ii) = oxy_ROI(1,2*ii);   
   jrgeco1aCorr_on(1,ii) = jrgeco1aCorr_ROI(1,2*ii-1);
   jrgeco1aCorr_off(1,ii) = jrgeco1aCorr_ROI(1,2*ii);  

end

figure
plot((1:300)/10,oxy_on,'r:','LineWidth',2)
hold on
plot((1:300)/10,oxy_off,'k--','LineWidth',2);
title('Oxy')
xlabel('time(s)')
ylabel('\Delta\mu')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure
plot((1:300)/10,oxy_on-oxy_off,'-','LineWidth',2)
title('Oxy: even-odd')
xlabel('time(s)')
ylabel('\Delta\mu')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure;
subplot(1,2,1)
imagesc(reshape(mean(oxy(:,101:2:159),2),128,128),[-1.5e-7 1.5e-7])
colorbar
colormap jet
axis image off
title('Oxy Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(oxy(:,102:2:160),2),128,128),[-1.5e-7 1.5e-7])
colorbar
colormap jet
axis image off
title('Oxy Even PeakMap')



figure;
plot((1:300)/10,jrgeco1aCorr_on,'m:','LineWidth',2);
hold on
plot((1:300)/10,jrgeco1aCorr_off,'k--','LineWidth',2);
title('Corr jRGECO1a')
xlabel('time(s)')
ylabel('\DeltaF/F')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

figure
plot((1:300)/10,jrgeco1aCorr_on-jrgeco1aCorr_off,'-','LineWidth',2)
title('Corr jRGECO1a: even-odd')
xlabel('time(s)')
ylabel('\DeltaF/F')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);



figure;
subplot(1,2,1)
imagesc(reshape(mean(jrgeco1aCorr(:,101:2:159),2),128,128),[-0.003 0.003])
colorbar
colormap jet
axis image off
title('Corr jRGECO1aCorr Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(jrgeco1aCorr(:,102:2:160),2),128,128),[-0.003 0.003])
colorbar
colormap jet
axis image off
title('Corr jRGECO1aCorr Even PeakMap')








load('K:\BleedOver\Cat\200320-NonChR2-RGECO-Anes-stim-allBlocks.mat', 'xform_datahb_mice_GSR_filtered')
load('K:\BleedOver\Cat\200320-NonChR2-RGECO-Anes-stim-allBlocks.mat', 'xform_jrgeco1aCorr_mice_GSR')

iROI = reshape(ROI,1,[]);
oxy = reshape(xform_datahb_mice_GSR_filtered(:,:,1,:),length(iROI),[]);
jrgeco1aCorr = reshape(xform_jrgeco1aCorr_mice_GSR,length(iROI),[]);


baseline_oxy = mean(oxy(:,1:100),2);
baseline_jrgeco1aCorr = mean(jrgeco1aCorr(:,1:100),2);


oxy = oxy - repmat(baseline_oxy,1,size(oxy,2));
jrgeco1aCorr = jrgeco1aCorr - repmat(baseline_jrgeco1aCorr,1,size(jrgeco1aCorr,2));



oxy_ROI = mean(oxy(iROI,:),1);
jrgeco1aCorr_ROI = mean(jrgeco1aCorr(iROI,:),1);


oxy_on = zeros(1,length(oxy_ROI)/2);
jrgeco1aCorr_on = zeros(1,length(jrgeco1aCorr_ROI)/2);


oxy_off = zeros(1,length(oxy_ROI)/2);
jrgeco1aCorr_off = zeros(1,length(jrgeco1aCorr_ROI)/2);


for ii = 1: length(oxy_ROI)/2
    oxy_on(1,ii) = oxy_ROI(1,2*ii-1);
    oxy_off(1,ii) = oxy_ROI(1,2*ii);   
   jrgeco1aCorr_on(1,ii) = jrgeco1aCorr_ROI(1,2*ii-1);
   jrgeco1aCorr_off(1,ii) = jrgeco1aCorr_ROI(1,2*ii);  

   
end

figure
plot((1:300)/10,oxy_on,'r:','LineWidth',2)
hold on
plot((1:300)/10,oxy_off,'k--','LineWidth',2);
title('Oxy GSR')
xlabel('time(s)')
ylabel('\Delta\mu')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure
plot((1:300)/10,oxy_on-oxy_off,'-','LineWidth',2)
title('Oxy GSR: even-odd')
xlabel('time(s)')
ylabel('\Delta\mu')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure;
subplot(1,2,1)
imagesc(reshape(mean(oxy(:,101:2:159),2),128,128),[-1.5e-7 1.5e-7])
colorbar
colormap jet
axis image off
title('Oxy GSR Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(oxy(:,102:2:160),2),128,128),[-1.5e-7 1.5e-7])
colorbar
colormap jet
axis image off
title('Oxy GSR Even PeakMap')



figure;
plot((1:300)/10,jrgeco1aCorr_on,'m:','LineWidth',2);
hold on
plot((1:300)/10,jrgeco1aCorr_off,'k--','LineWidth',2);
title('Corr jRGECO1a GSR')
xlabel('time(s)')
ylabel('\DeltaF/F')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

figure
plot((1:300)/10,jrgeco1aCorr_on-jrgeco1aCorr_off,'-','LineWidth',2)
title('Corr jRGECO1a GSR: even-odd')
xlabel('time(s)')
ylabel('\DeltaF/F')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);



figure;
subplot(1,2,1)
imagesc(reshape(mean(jrgeco1aCorr(:,101:2:159),2),128,128),[-0.003 0.003])
colorbar
colormap jet
axis image off
title('Corr jRGECO1aCorr GSR Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(jrgeco1aCorr(:,102:2:160),2),128,128),[-0.003 0.003])
colorbar
colormap jet
axis image off
title('Corr jRGECO1aCorr GSR Even PeakMap')





