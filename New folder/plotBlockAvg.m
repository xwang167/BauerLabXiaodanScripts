function  plotBlockAvg(gcampCorr_blocks_baseline_active,gcamp_blocks_baseline_active,green_blocks_baseline_active,oxy_blocks_baseline_active,deoxy_blocks_baseline_active,total_blocks_baseline_active,visName,saveDir,sessionInfo,xform_isbrain,mask_oxy,mask_gcampCorr,max_oxy,max_gcampCorr,min_green,roi_contour,mask_oxy_contour,mask_gcampCorr_contour,AvgOxy_stim,temp_oxy_max,AvggcampCorr_stim,temp_gcampCorr_max)
        
x = (1:round(sessionInfo.stimblocksize/2))/sessionInfo.framerate;
plotedit on

figure;
subplot('position',[0.1,0.08,0.4,0.35])
yyaxis left
p1 = plot(x,gcampCorr_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'k-');

ylim([-1.2*max_gcampCorr 1.2*max_gcampCorr])

hold on
yyaxis right
p2 = plot(x,oxy_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'r-');

hold on
yyaxis right
p3 = plot(x,deoxy_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'b-');

ylim([-1.2*max_oxy 1.2*max_oxy])
p4 = plot(x,total_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'y-');
yyaxis left;


hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-1.2*max_gcampCorr 1.2*max_gcampCorr]);
    hold on
end
ax = gca;
ax.FontSize = 4; 

legend([p2 p3 p4 p1 ],'HbO_2','HbR','HbTotal','G6f(corr.)','FontSize',4);
xlabel('Time(s)','FontSize',6)
yyaxis left;
ylabel('GCaMP6f(\DeltaF/F)','FontSize',6);
yyaxis right
ylabel('HBO_2,HbR(\DeltaM)','FontSize',6)

subplot('position',[0.1,0.50,0.4,0.35])
p4 = plot(x,gcampCorr_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'k-');

ylim([1.2*min_green 1.2*max_gcampCorr])

hold on
p5=plot(x,gcamp_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'Color',[0 0.6 0]);

hold on
p6=plot(x,green_blocks_baseline_active(1:round(sessionInfo.stimblocksize/2)),'g-');
hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[1.2*min_green 1.2*max_gcampCorr]);
    hold on
end
ax = gca;
ax.FontSize = 4; 
legend([p6 p5 p4 ],'512nm','G6f(raw)','G6f(corr.)','FontSize',4);
xlabel('Time(s)','FontSize',6)
ylabel('GCaMP6f(\DeltaF/F)','FontSize',6)

subplot('position',[0.6,0.08,0.35,0.35])
imagesc(AvgOxy_stim,[-1.5*temp_oxy_max 1.5*temp_oxy_max])
hold on
contour(roi_contour,'r')
hold on
contour(mask_oxy_contour,'k')

title('oxy 75% to oxy, deoxy, total' )

subplot('position',[0.6,0.5,0.35,0.35])
imagesc(AvggcampCorr_stim,[-1.5*temp_gcampCorr_max 1.5*temp_gcampCorr_max])
hold on
contour(roi_contour,'r')
hold on
contour(mask_gcampCorr_contour,'k')

title('gcampCorr 75% to gcampCorr, gcamp, green' )

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for  ' ,{' '},visName),'FontWeight','bold','Color',[1 0 0],'FontSize',8);

output=fullfile(saveDir,strcat(visName,'_Vis.jpg'));
orient portrait
print ('-djpeg', '-r1000',output);
figure('visible', 'on');