function QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,Name)
figure('position',[ 100       358         589         492])
ymaxRight = max(cell2mat(rightData),[],'all');
ymaxLeft = max(cell2mat(leftData),[],'all');
ymax = max(ymaxRight,ymaxLeft);
yminLeft = min(cell2mat(leftData),[],'all');
yminRight = min(cell2mat(rightData),[],'all');

for ii = 1 : size(leftData,1)
    yyaxis left
    semilogx(hz,10*log10(leftData{ii}/interp1(hz,leftData{ii},0.01)),leftLineStyle{ii});
    
    hold on
end
%set(gca, 'YScale', 'log')
%ylim([10^-3 10^2])
% ylim([10^-4 2])
% yticks([10^-4  10^-3 10^-2  10^-1 10^0])
ylim([-30 20])
xticks([0.01 0.1 1 10])
ylabel(leftLabel)

for ii = 1 : size(rightData,1)
    yyaxis right
%     if ii ==1
%         a = loglog(hz,rightData{ii}/interp1(hz,rightData{ii},0.01),rightLineStyle{ii});
%     else
    semilogx(hz,10*log10(rightData{ii}/interp1(hz,rightData{ii},0.01)),rightLineStyle{ii})
%     end
    hold on
end
%uistack(a,'top')
%set(gca, 'YScale', 'log')
ylabel(rightLabel)
%ylim([10^-3 10^2])
% ylim([10^-4 2])
% yticks([10^-4 10^-3 10^-2  10^-1 10^0])
ylim([-30 20])


xlabel('Frequency (Hz)')
title(Name,'fontsize',14,'Interpreter', 'none');
%ytickformat('%.1f');
xlim([10^-2 10])
xticks([0.01 0.1 1 10]);
set(gca,'FontSize',20,'FontWeight','Bold')
 set(findall(gca, 'Type', 'Line'),'LineWidth',2);
%legend(legendName,'location','southwest','FontSize',13)
saveas(gcf,fullfile(saveDir,strcat(Name,'.png')));
saveas(gcf,fullfile(saveDir,strcat(Name,'.fig')));



