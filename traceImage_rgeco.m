function  traceImage_rgeco(downSampledBlocks1,downSampledBlocks2,downSampledBlocks_red,name1,name2,name_red,active1,active2,active_red,color1,color2,color_red,ROI_contour,yunit,stimduration,stimblocksize,stimFrequency,framerate,stimbaseline,stimStartTime,stimEndTime,xform_isbrain,maxVal)
x = linspace(0,stimblocksize/framerate,length(active1));
figure('units','normalized','outerposition',[0 0 1 1]);
subplot('position',[0.05,0.08,0.55,0.35])
plot(x,active1,'color',color1);
hold on
plot(x,active2,'color',color2);
hold on
minimum = min([active1 active2],[],'all');
maxmum = max([active1 active2],[],'all');
ylim([ 1.1*minimum 1.1*maxmum])

yyaxis right
plot(x,active_red,'color',color_red);
ylim([ 1.1*minimum/5 1.1*maxmum/5])
hold on

set(findall(gca, 'Type', 'Line'),'LineWidth',2);

% for i  = 0:1/stimFrequency:stimduration-1/stimFrequency
%     line([stimbaseline/framerate+i stimbaseline/framerate+i],[ 1.1*minimum 1.1*maxmum]);
%     hold on
% end

ax = gca;
ax.FontSize = 8;
xlim([0 round(stimblocksize/framerate)])

[max1] = max(abs(active1(round(framerate*stimStartTime):round(framerate*stimEndTime))));
[max2] = max(abs(active2(round(framerate*stimStartTime):round(framerate*stimEndTime))));
[max3] = max(abs(active_red(round(framerate*stimStartTime):round(framerate*stimEndTime))));





lgd =legend(name1,name2,name_red);
lgd.FontSize = 14;
xlabel('Time(s)','FontSize',20,'FontWeight','bold')
ylabel(yunit,'FontSize',20,'FontWeight','bold')

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')

subplot('position',[0.8,0.1,0.2,0.25])

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL')
for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.80 0.07 0.12]);
    imagesc(downSampledBlocks1(:,:,b), [-1.1*maxVal(1) 1.1*maxVal(1)]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.80 0.07 0.12]);
    end
    axis image off
    hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
    
    if b == stimStartTime
        ylabel(name1,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end

for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.64 0.07 0.12]);
    imagesc(downSampledBlocks2(:,:,b), [-1.1*maxVal(2) 1.1*maxVal(2)]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.64 0.07 0.12]);
    end
    axis image off;
%     set(gca, 'XTick', []);
%     set(gca, 'YTick', []);
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
    
    if b==stimStartTime
        ylabel(name2,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end



for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.48 0.07 0.12]);
    imagesc(downSampledBlocks_red(:,:,b), [-1.1*maxVal(3) 1.1*maxVal(3)]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.48 0.07 0.12]);
    end
    axis image off;
     hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)

    if b==stimStartTime
        ylabel(name_red,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end
if isempty(maxVal)
max1 = max(abs(downSampledBlocks1(:,:,stimEndTime)),[],'all');
max2 = max(abs(downSampledBlocks2(:,:,stimEndTime)),[],'all');
max3 = max(abs(downSampledBlocks_red(:,:,stimEndTime)),[],'all');
else
    max1 = maxVal(1);
    max2 = maxVal(2);
    max3 = maxVal(3);
end
subplot('position',[0.79,0.27,0.13,0.18])
imagesc(downSampledBlocks1(:,:,stimEndTime),...
    [-max1,max1])
colorbar
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
hold on
contour(ROI_contour,'k')
axis image off
title(strcat(name1,'(',yunit,')'));

subplot('position',[0.64,0.05,0.13,0.18])
imagesc(downSampledBlocks2(:,:,stimEndTime),...
    [-max2,max2])
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
colorbar
hold on
contour(ROI_contour,'k')
axis image off
title(strcat(name2,'(',yunit,')'));


subplot('position',[0.79,0.05,0.13,0.18])

imagesc(downSampledBlocks_red(:,:,stimEndTime),...
    [-max3,max3])
colorbar
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
hold on
contour(ROI_contour,'k')
axis image off
title(strcat(name_red,'(',yunit,')'))
colormap jet


% 
% figure
% 
% mask = poly2mask(ROI_contour);
% imagesc(downSampledBlocks1(:,:,stimEndTime),...
%     [min(downSampledBlocks1(:,:,stimEndTime),[],'all'),max(downSampledBlocks1(:,:,stimEndTime),[],'all')])
% colorbar
%  hold on
%     imagesc(WL,'AlphaData',1-mask)
% axis image off
% title(name1);
% 
% figure
% mask = poly2mask(ROI_contour);
% imagesc(downSampledBlocks2(:,:,stimEndTime),...
%     [min(downSampledBlocks2(:,:,stimEndTime),[],'all'),max(downSampledBlocks2(:,:,stimEndTime),[],'all')])
% colorbar
%  hold on
%     imagesc(WL,'AlphaData',1-mask)
% axis image off
% title(name2);
% 


colormap jet


end



