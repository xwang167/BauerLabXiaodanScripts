function  plotBlockAvg_mouse(gcampCorr_runs_baseline_active,gcamp_runs_baseline_active,green_runs_baseline_active,oxy_runs_baseline_active,deoxy_runs_baseline_active,total_runs_baseline_active,visName,saveDir,sessionInfo,max_oxy,max_gcampCorr,min_green,temp_oxy_max,temp_gcampCorr_max)
        
x = (1:round(sessionInfo.stimrunsize))/sessionInfo.framerate;
plotedit on

figure;
subplot('position',[0.1,0.08,0.4,0.7])
yyaxis left
p1 = plot(x,gcampCorr_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'k-');

ylim([-1.2*max_gcampCorr 1.2*max_gcampCorr])

hold on
yyaxis right
p2 = plot(x,oxy_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'r-');

hold on
yyaxis right
p3 = plot(x,deoxy_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'b-');

ylim([-1.2*max_oxy 1.2*max_oxy])
p4 = plot(x,total_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'y-');
yyaxis left;


hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimrunsize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimrunsize)+i],[-1.2*max_gcampCorr 1.2*max_gcampCorr]);
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

subplot('position',[0.1,0.50,0.4,0.7])
p4 = plot(x,gcampCorr_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'k-');

ylim([1.2*min_green 1.2*max_gcampCorr])

hold on
p5=plot(x,gcamp_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'Color',[0 0.6 0]);

hold on
p6=plot(x,green_runs_baseline_active(1:round(sessionInfo.stimrunsize)),'g-');
hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimrunsize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimrunsize)+i],[1.2*min_green 1.2*max_gcampCorr]);
    hold on
end
ax = gca;
ax.FontSize = 4; 
legend([p6 p5 p4 ],'512nm','G6f(raw)','G6f(corr.)','FontSize',4);
xlabel('Time(s)','FontSize',6)
ylabel('GCaMP6f(\DeltaF/F)','FontSize',6)



annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for  ' ,{' '},visName),'FontWeight','bold','Color',[1 0 0],'FontSize',8);

output=fullfile(saveDir,strcat(visName,'_Vis.jpg'));
orient portrait
print ('-djpeg', '-r1000',output);
figure('visible', 'on');