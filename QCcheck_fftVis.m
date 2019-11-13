function QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,Name)
figure
subplot('position',[0.12 0.13 0.6 0.8])
for ii = 1 : size(leftData,1)
    yyaxis left
    loglog(hz,leftData{ii},leftLineStyle{ii})
    hold on
end
set(gca, 'YScale', 'log')
ylabel(leftLabel)


for ii = 1 : size(rightData,1)
    yyaxis right
    loglog(hz,rightData{ii},rightLineStyle{ii})
    hold on
end
set(gca, 'YScale', 'log')
ylabel(rightLabel)
legend(legendName,'location','southwest')
xlabel('Frequency (Hz)')
title(Name,'fontsize',14,'Interpreter', 'none');
ytickformat('%.1f');
xlim([10^-2 10])
saveas(gcf,fullfile(saveDir,strcat(Name,'.png')));
saveas(gcf,fullfile(saveDir,strcat(Name,'.fig')));