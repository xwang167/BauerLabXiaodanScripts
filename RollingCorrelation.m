close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 183;

runs = 1;
load('D:\OIS_Process\noVasculatureMask.mat','mask_new')
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
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
       maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr')
        xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
        calcium = reshape(xform_jrgeco1aCorr,128*128,[]);
        clear xform_jrgeco1aCorr
        total = reshape(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:),128*128,[]);
        clear xform_datahb
        FAD = reshape(xform_FADCorr,128*128,[]);
        clear xform_FADCorr
        nFrames = size(calcium,2);
%         total = mouse.freq.filterData(double(total),0.009,0.08,25);
% FAD = mouse.freq.filterData(double(squeeze(FAD)),0.009,0.08,25);
% calcium = mouse.freq.filterData(double(calcium),0.009,0.08,25);
        
        load(fullfile(saveDir,processedName),'lagTimeTrial_FADCalcium', 'lagTimeTrial_HbTCalcium')
        ibi = logical(reshape(mask_new,128*128,1));
        lagTimeTrial_FADCalcium = reshape(lagTimeTrial_FADCalcium,128*128,1);
        lagTimeTrial_HbTCalcium = reshape(lagTimeTrial_HbTCalcium,128*128,1);
        lag_FAD = nanmean(lagTimeTrial_FADCalcium(ibi));
        lag_Total = nanmean(lagTimeTrial_HbTCalcium(ibi));
        t = (1:nFrames)/sessionInfo.framerate;
        t_FAD = lag_FAD+(1/sessionInfo.framerate):(1/sessionInfo.framerate):nFrames/sessionInfo.framerate;
        t_Total = lag_Total+(1/sessionInfo.framerate):(1/sessionInfo.framerate):nFrames/sessionInfo.framerate;
        
        FAD_interp = zeros(128*128,length(t_FAD));
        Total_interp = zeros(128*128,length(t_Total));
        for ii = 1:128*128
            FAD_interp(ii,:) = interp1(t,FAD(ii,:),t_FAD);
            Total_interp(ii,:) = interp1(t,total(ii,:),t_Total);
        end
        ibi = logical(reshape(mask_new,128*128,1));
        r_FAD = zeros(1,length(t_FAD));
        r_Total = zeros(1, length(t_Total));
        for jj = 1:length(r_FAD)
            r_FAD(jj) = normr(FAD_interp(ibi,jj)')*transpose(normr(calcium(ibi,jj)'));
        end
        for jj = 1:length(r_Total)
            r_Total(jj) = normr(Total_interp(ibi,jj)')*transpose(normr(calcium(ibi,jj)'));
        end
        
        
        gs_calcium = mean(calcium(ibi,:),1);
        gs_FAD_rolling = mean(FAD_interp(ibi,:),1);
        gs_Total_rolling = mean(Total_interp(ibi,:),1);
        gs_FAD = mean(FAD(ibi,:),1);
        gs_Total = mean(total(ibi,:,1));
        figure
        subplot(3,1,1)
        
        plot((1:5000)/25,normr(gs_calcium(1:5000)),'m')
        hold on
        plot((1:5000)/25,normr(gs_FAD(1:5000))-0.05,'g')
        hold on
        plot((1:5000)/25,normr(gs_Total(1:5000))-0.13,'k')
       hold on
        plot((1:5000)/25,normr(gs_calcium(1:5000)),'m')
        hold on
        plot((1:5000)/25,normr(gs_FAD_rolling(1:5000))+0.06,'g')
        hold on
        plot((1:5000)/25,normr(gs_Total_rolling(1:5000))+0.10,'k')
        hold on
        title('Upper rolled, lower original')
        subplot(3,1,2)
       
        imagesc(r_FAD(1:5000),[-1,1])
         title('r between Calcium and Rolled FAD')
         axis off
        subplot(3,1,3)
        imagesc(r_Total(1:5000),[-1,1])
         title('r between Calcium and Rolled Total')
         axis off
        
    end
end


calcium = reshape(calcium, 128,128,[]);
FAD_interp = reshape(FAD_interp, 128, 128, []);
Total_interp = reshape(Total_interp, 128,128,[]);
% figure
% for ii = 1914:1963;
%     subplot(1,3,1)
%     imagesc(calcium(:,:,ii),[-0.01 0.01]);
%     subplot(1,3,2)
%     imagesc(FAD_interp(:,:,ii),[-0.01 0.01]);
%     subplot(1,3,3)
%     imagesc(Total_interp(:,:,ii),[-2e-6 2e-6]);
%     pause
%     
% end

WB = 255*ones(128,128,3);

figure
ax = subplot(3,10,1);
imagesc(calcium(:,:,1914).*mask_new*100,[-5 5]);axis image off;
hold on;
%contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask_new)
ylabel('Calcium')
title([num2str(1914/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,11);
imagesc(FAD_interp(:,:,1914)*100.*mask_new,[-1 1]);axis image off;
hold on
%contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask_new)
ylabel('FAD')
colormap(ax,viridis)

ax = subplot(3,10,21);
imagesc(Total_interp(:,:,1914).*mask_new*10^6,[-2 2 ]);axis image off;
ylabel('HbT')
hold on
%contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)



ax = subplot(3,10,2);
imagesc(calcium(:,:,1914+5).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,12);
imagesc(FAD_interp(:,:,1914+5)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,22);
imagesc(Total_interp(:,:,1914+5).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)



ax = subplot(3,10,3);
imagesc(calcium(:,:,1914+5*2).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*2)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,13);
imagesc(FAD_interp(:,:,1914+5*2)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,23);
imagesc(Total_interp(:,:,1914+5*2).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)



ax = subplot(3,10,4);
imagesc(calcium(:,:,1914+5*2).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*2)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,14);
imagesc(FAD_interp(:,:,1914+5*2)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,24);
imagesc(Total_interp(:,:,1914+5*2).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)


ax = subplot(3,10,5);
imagesc(calcium(:,:,1914+5*3).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*3)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,15);
imagesc(FAD_interp(:,:,1914+5*3)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,25);
imagesc(Total_interp(:,:,1914+5*3).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)


ax = subplot(3,10,6);
imagesc(calcium(:,:,1914+5*4).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*4)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,16);
imagesc(FAD_interp(:,:,1914+5*4)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,26);
imagesc(Total_interp(:,:,1914+5*4).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)


ax = subplot(3,10,7);
imagesc(calcium(:,:,1914+5*5).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*5)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,17);
imagesc(FAD_interp(:,:,1914+5*5)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,27);
imagesc(Total_interp(:,:,1914+5*5).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)


ax = subplot(3,10,8);
imagesc(calcium(:,:,1914+5*6).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*6)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,18);
imagesc(FAD_interp(:,:,1914+5*6)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,28);
imagesc(Total_interp(:,:,1914+5*6).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax, cividis)


ax = subplot(3,10,9);
imagesc(calcium(:,:,1914+5*7).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
title([num2str((1914+5*7)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax = subplot(3,10,19);
imagesc(FAD_interp(:,:,1914+5*7)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)

ax = subplot(3,10,29);
imagesc(Total_interp(:,:,1914+5*7).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
colormap(ax,viridis)
colormap(ax, cividis)


ax = subplot(3,10,10);
imagesc(calcium(:,:,1914+5*7).*mask_new*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-10 0 10])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
title([num2str((1914+5*7)/25),'s'],'FontSize',20)
colormap(ax,inferno)

ax =subplot(3,10,20);
imagesc(FAD_interp(:,:,1914+5*8)*100.*mask_new,[-1 1]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-1 0 1])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax,viridis)

ax = subplot(3,10,30);
imagesc(Total_interp(:,:,1914+5*8).*mask_new*10^6,[-2 2 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask_new)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-3 0 3])
ylabel(cb,'\Delta\muM','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax, cividis)


