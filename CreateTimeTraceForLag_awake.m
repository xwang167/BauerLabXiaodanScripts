load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
load('D:\OIS_Process\noVasculatureMask.mat');
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
mask = leftMask+rightMask;
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
% Hb_filter = mouse.freq.lowpass(double(xform_datahb),0.4,25);
% FAD_filter = mouse.freq.lowpass(double(squeeze(xform_FADCorr)),0.4,25);
% Calcium_filter = mouse.freq.lowpass(double(squeeze(xform_jrgeco1aCorr)),0.4,25);
%
% Hb_filter = double(xform_datahb);
% FAD_filter = double(squeeze(xform_FADCorr));
% Calcium_filter = double(squeeze(xform_jrgeco1aCorr));

Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
% Calcium = normRow(transpose(squeeze(mean(mean(Calcium_filter(71:75,17:21,:)*100,1),2))));
% FAD = normRow(transpose(squeeze(mean(mean(FAD_filter(71:75,17:21,:)*100,1),2))));
% HbT = normRow(transpose(squeeze(mean(mean(HbT_filter(71:75,17:21,:)*10^6,1),2))));
Calcium = transpose(squeeze(mean(mean(Calcium_filter(71:75,17:21,:)*100,1),2)));
FAD = transpose(squeeze(mean(mean(FAD_filter(71:75,17:21,:)*100,1),2)));
HbT = transpose(squeeze(mean(mean(HbT_filter(71:75,17:21,:)*10^6,1),2)));
figure
time = (1:1+60*25)/25;
h(1) = plot(time,Calcium(3769+251:3769+251+60*25),'m-');
hold on
h(2) = plot(time,FAD(3769+251:3769+251+60*25)*4,'g-');
hold on
ylabel('Fluorescence(\DeltaF/F%)')
%ylim([-2.5 2.5])
yyaxis right
h(3) = plot(time,HbT(3769+251:3769+251+60*25),'k-');
ylabel('Hb(\Delta\muM)') 
xlabel('time(s)')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
xlim([0,30])
ylim([-5 10])
% ylim([-0.025 0.045])
ROI = zeros(128,128);
ROI(71:75,17:21) =1;
yyaxis left
ylim([-5 10])
patch([13.64,13.64+90/25,13.64+90/25,13.64],[-5 -5 10 10],[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5)
legend(h,{'Corrected jRGECO1a','Corrected FADx4','HbT'},'location','northwest','FontSize',14,'FontWeight','Bold')
% 
% 


figure
ax = subplot(3,10,1);
imagesc(Calcium_filter(:,:,4360).*mask*100,[-5 5]);axis image off;
hold on;
contour(ROI,'k')
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
ylabel('Calcium')
title([num2str(13.64),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,11);
imagesc(FAD_filter(:,:,4360)*100.*mask,[-0.5 0.5]);axis image off;
hold on
contour(ROI,'k')
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
ylabel('FAD')
colormap(ax,viridis)

ax = subplot(3,10,21);
imagesc(Hb_filter(:,:,1,4360).*mask*10^6,[-9 9 ]);axis image off;
ylabel('HbT')
hold on
contour(ROI,'k')
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)



ax = subplot(3,10,2);
imagesc(Calcium_filter(:,:,4360+10).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+10/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,12);
imagesc(FAD_filter(:,:,4360+10)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,22);
imagesc(Hb_filter(:,:,1,4360+10).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)



ax = subplot(3,10,3);
imagesc(Calcium_filter(:,:,4360+10*2).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+20/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,13);
imagesc(FAD_filter(:,:,4360+10*2)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,23);
imagesc(Hb_filter(:,:,1,4360+10*2).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)



ax = subplot(3,10,4);
imagesc(Calcium_filter(:,:,4360+10*2).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+30/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,14);
imagesc(FAD_filter(:,:,4360+10*2)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,24);
imagesc(Hb_filter(:,:,1,4360+10*2).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)


ax = subplot(3,10,5);
imagesc(Calcium_filter(:,:,4360+10*3).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+40/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,15);
imagesc(FAD_filter(:,:,4360+10*3)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,25);
imagesc(Hb_filter(:,:,1,4360+10*3).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)


ax = subplot(3,10,6);
imagesc(Calcium_filter(:,:,4360+10*4).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+50/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,16);
imagesc(FAD_filter(:,:,4360+10*4)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,26);
imagesc(Hb_filter(:,:,1,4360+10*4).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)


ax = subplot(3,10,7);
imagesc(Calcium_filter(:,:,4360+10*5).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+60/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,17);
imagesc(FAD_filter(:,:,4360+10*5)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,27);
imagesc(Hb_filter(:,:,1,4360+10*5).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)


ax = subplot(3,10,8);
imagesc(Calcium_filter(:,:,4360+10*6).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+70/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,18);
imagesc(FAD_filter(:,:,4360+10*6)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,28);
imagesc(Hb_filter(:,:,1,4360+10*6).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax, jet)


ax = subplot(3,10,9);
imagesc(Calcium_filter(:,:,4360+10*7).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
title([num2str(13.64+80/25),'s'],'FontSize',20)
colormap(ax,magma)

ax = subplot(3,10,19);
imagesc(FAD_filter(:,:,4360+10*7)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)

ax = subplot(3,10,29);
imagesc(Hb_filter(:,:,1,4360+10*7).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
colormap(ax,viridis)
colormap(ax, jet)


ax = subplot(3,10,10);
imagesc(Calcium_filter(:,:,4360+10*8).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-5 0 5])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
title([num2str(13.64+90/25),'s'],'FontSize',20)
colormap(ax,magma)

ax =subplot(3,10,20);
imagesc(FAD_filter(:,:,4360+10*8)*100.*mask,[-0.5 0.5]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-0.5 0 0.5])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax,viridis)

ax = subplot(3,10,30);
imagesc(Hb_filter(:,:,1,4360+10*8).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(xform_WL,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-9 0 9])
ylabel(cb,'\Delta\muM','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax, jet)