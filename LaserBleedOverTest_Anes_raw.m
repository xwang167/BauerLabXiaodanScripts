close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 297:303;

runs = 1:6;
% 
laser_mice = [];
green_mice = [];
red_mice = [];
fluor_mice = [];
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

    laser_mouse = [];
    red_mouse = [];
    green_mouse = [];
    fluor_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
 
     

           load(fullfile(saveDir,rawName),'rawdata')
          laser = reshape(rawdata(:,:,4,:),128,128,[],10);
          green = reshape(rawdata(:,:,1,:),128,128,[],10);
          red = reshape(rawdata(:,:,2,:),128,128,[],10);
          fluor = reshape(rawdata(:,:,3,:),128,128,[],10);
          clear rawdata
           laser = mean(laser,4);
           green = mean(green,4);
           red = mean(red,4);
           fluor = mean(fluor,4);
           
           laser_mouse = cat(4,laser_mouse,laser);
           green_mouse = cat(4,green_mouse,green);
           red_mouse = cat(4,red_mouse,red);
           fluor_mouse = cat(4,fluor_mouse,fluor);
    end
    laser_mouse = mean(laser_mouse,4);
     laser_mice = cat(4,laser_mice,laser_mouse);
     
         green_mouse = mean(green_mouse,4);
     green_mice = cat(4,green_mice,green_mouse);
     
         red_mouse = mean(red_mouse,4);
     red_mice = cat(4,red_mice,red_mouse);
     
         fluor_mouse = mean(fluor_mouse,4);
     fluor_mice = cat(4,fluor_mice,fluor_mouse);
end
 laser_mice = mean(laser_mice,4);
 green_mice = mean(green_mice,4);
 red_mice = mean(red_mice,4);
fluor_mice = mean(fluor_mice,4);

peakMap_ROI = mean(laser_mice(:,:,101:2:159),3);

        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        maximum = max(max(peakMap_ROI));
        [y1,x1]=find(peakMap_ROI==maximum);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 5;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),75);
        temp = double(peakMap_ROI).*double(ROI);
        ROI = temp>=max_ROI;
        hold on
        ROI_contour = bwperim(ROI);
        contour( ROI_contour,'k');

iROI = reshape(logical(ROI),1,[]);




laser = reshape(laser_mice,length(iROI),[]);
green = reshape(green_mice,length(iROI),[]);
red = reshape(red_mice,length(iROI),[]);
fluor = reshape(fluor_mice,length(iROI),[]);

baseline_laser = mean(laser(:,1:100),2);
baseline_green = mean(green(:,1:100),2);
baseline_red= mean(red(:,1:100),2);
baseline_fluor = mean(fluor(:,1:100),2);

laser = laser - repmat(baseline_laser,1,size(laser,2));
green = green - repmat(baseline_green,1,size(green,2));
red = red - repmat(baseline_red,1,size(red,2));
fluor = fluor - repmat(baseline_fluor,1,size(fluor,2));



laser_ROI = mean(laser(iROI,:),1);
green_ROI = mean(green(iROI,:),1);
red_ROI = mean(red(iROI,:),1);
fluor_ROI = mean(fluor(iROI,:),1);


laser_on = zeros(1,length(laser_ROI)/2);
green_on = zeros(1,length(green_ROI)/2);
red_on = zeros(1,length(red_ROI)/2);
fluor_on = zeros(1,length(fluor_ROI)/2);



laser_off = zeros(1,length(laser_ROI)/2);
green_off = zeros(1,length(green_ROI)/2);
red_off = zeros(1,length(red_ROI)/2);
fluor_off = zeros(1,length(fluor_ROI)/2);

for ii = 1: length(laser_ROI)/2
    laser_on(1,ii) = laser_ROI(1,2*ii-1);
    laser_off(1,ii) = laser_ROI(1,2*ii); 
    
   green_on(1,ii) = green_ROI(1,2*ii-1);
   green_off(1,ii) = green_ROI(1,2*ii); 
   
       red_on(1,ii) = red_ROI(1,2*ii-1);
    red_off(1,ii) = red_ROI(1,2*ii); 
    
   fluor_on(1,ii) = fluor_ROI(1,2*ii-1);
   fluor_off(1,ii) = fluor_ROI(1,2*ii); 

end

figure
plot((1:300)/10,laser_on,'r:','LineWidth',2)
hold on
plot((1:300)/10,laser_off,'k--','LineWidth',2);
title('laser')
xlabel('time(s)')
ylabel('\Deltan')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure
plot((1:300)/10,laser_on-laser_off,'-','LineWidth',2)
title('laser: even-odd')
xlabel('time(s)')
ylabel('\Deltan')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure;
subplot(1,2,1)
imagesc(reshape(mean(laser(:,101:2:159),2),128,128),[0 15000])
colorbar
colormap jet
axis image off
title('laser Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(laser(:,102:2:160),2),128,128),[0 15000])
colormap jet
axis image off
title('laser Even PeakMap')



figure;
plot((1:300)/10,green_on,'g:','LineWidth',2);
hold on
plot((1:300)/10,green_off,'k--','LineWidth',2);
title('Green')
xlabel('time(s)')
ylabel('\Deltan')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

figure
plot((1:300)/10,green_on-green_off,'-','LineWidth',2)
title('Green: even-odd')
xlabel('time(s)')
ylabel('\Deltan')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);




figure;
subplot(1,2,1)
imagesc(reshape(mean(green(:,101:2:159),2),128,128),[0 500])
colorbar
colormap jet
axis image off
title('green Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(green(:,102:2:160),2),128,128),[0 500])
colorbar
colormap jet
axis image off
title('green Even PeakMap')




figure
plot((1:300)/10,red_on,'r:','LineWidth',2)
hold on
plot((1:300)/10,red_off,'k--','LineWidth',2);
title('red')
xlabel('time(s)')
ylabel('\Deltan')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure
plot((1:300)/10,red_on-red_off,'-','LineWidth',2)
title('red: even-odd')
xlabel('time(s)')
ylabel('\\Deltan')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);


figure;
subplot(1,2,1)
imagesc(reshape(mean(red(:,101:2:159),2),128,128),[0 250])
colorbar
colormap jet
axis image off
title('red Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(red(:,102:2:160),2),128,128),[0 250])
colorbar
colormap jet
axis image off
title('red Even PeakMap')



figure;
plot((1:300)/10,fluor_on,'m:','LineWidth',2);
hold on
plot((1:300)/10,fluor_off,'k--','LineWidth',2);
title('jRGECO1a')
xlabel('time(s)')
ylabel('\Deltan')
legend('odd frames','even frames')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

figure
plot((1:300)/10,fluor_on-fluor_off,'-','LineWidth',2)
title('jRGECO1a: even-odd')
xlabel('time(s)')
ylabel('\Deltan')
set(gca,'FontSize',14,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);



figure;
subplot(1,2,1)
imagesc(reshape(mean(fluor(:,101:2:159),2),128,128),[-100 400])
colorbar
colormap jet
axis image off
title('jRGECO1a Odd PeakMap')

subplot(1,2,2)
imagesc(reshape(mean(fluor(:,102:2:160),2),128,128),[-100 400])
colorbar
colormap jet
axis image off
title('jRGECO1a Even PeakMap')






 

 

