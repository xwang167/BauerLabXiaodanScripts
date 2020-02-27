function quanti_bleedover(data,stimBaselineFrames,stimDurationFrames,numBlocks,framerate,ROI,minVal,maxVal,diffMax,texttitle,output,yLabel,rawOrProc)
nVx = size(data,2);
nVy = size(data,1);
data4 = reshape(data,nVy,nVx,[],numBlocks);

clear data

avgBlocks = squeeze(mean(data4,4));
clear data4


avgBaseline = mean(avgBlocks(:,:,1:stimBaselineFrames),3);
avgStim = mean(avgBlocks(:,:,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames),3);
avgAfter = mean(avgBlocks(:,:,stimBaselineFrames+stimDurationFrames+1:end),3);


figure('units','normalized','outerposition',[0 0 1 1]);

subplot(2,3,1);imagesc(avgBaseline,[minVal maxVal]);axis image off;title('before');colorbar;
set(gca,'FontSize',16)
subplot(2,3,2);imagesc(avgStim,[minVal maxVal]);axis image off;title('on');colorbar;
set(gca,'FontSize',16)
subplot(2,3,3);imagesc(avgAfter,[minVal maxVal]);axis image off;title('after');colorbar;
set(gca,'FontSize',16)
subplot(2,3,4);imagesc(avgStim-avgBaseline,[-diffMax diffMax]);axis image off;title('On-before');colorbar;hold on;ROI_contour = bwperim(ROI);contour( ROI_contour,'k');
set(gca,'FontSize',16)
colormap jet

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

iROI = reshape(ROI,1,[]);

avgBlocks2 = reshape(avgBlocks,length(iROI),[]);
avgBlocks_active = squeeze(mean(avgBlocks2(iROI,:),1));

before_ROI = mean(avgBlocks_active(1:stimBaselineFrames));
on_ROI = mean(avgBlocks_active(stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames));
after_ROI = mean(avgBlocks_active(stimBaselineFrames+stimDurationFrames+1:end));
% avgBlocks_active_baseline = avgBlocks_active-before_ROI;
% dFF = avgBlocks_active_baseline/before_ROI*100;

subplot(2,3,5);
x = (1:length( avgBlocks_active))/ framerate;
plot(x,avgBlocks_active,'g-');

stimStart = stimBaselineFrames/framerate;
stimEnd = (stimBaselineFrames+stimDurationFrames)/framerate;

line([stimStart stimStart],[0.999*min(avgBlocks_active) 1.0001*max(avgBlocks_active)])

line([stimEnd stimEnd],[0.999*min(avgBlocks_active) 1.0001*max(avgBlocks_active)])
ylim([0.999*min(avgBlocks_active) 1.0001*max(avgBlocks_active)])

xlabel('Time(s)','FontSize',20,'fontweight','bold')
ylabel(yLabel,'FontSize',20,'fontweight','bold') %%'Averaged Counts in ROI'
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',16)


annotation('textbox',...
    [0.7 0.15 0.2 0.2],...
    'String',...
    {['before = ' num2str(before_ROI) '; '],...
    ['on = ' num2str(on_ROI) ';' ],...
    ['after = ' num2str(after_ROI) ';'],...
    [],...
    ['on/before = ' num2str(on_ROI/before_ROI) ';' ],...
    ['after/before = ' num2str(after_ROI/before_ROI) ';' ]},...
    'FontSize',24,...
    'FontName','Arial',...
    'LineStyle','--',...
    'EdgeColor',[1 1 0],...
    'LineWidth',2,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color',[0 0 0]);
saveas(gcf,strcat(output,rawOrProc,'DataPlot.fig'))
saveas(gcf,strcat(output,rawOrProc,'DataPlot.png'))

end