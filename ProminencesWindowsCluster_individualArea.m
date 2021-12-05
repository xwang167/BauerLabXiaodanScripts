% 
% 
% excelFile = "L:\RGECO\RGECO.xlsx";
% excelRows = 2:7;
% 
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = logical(leftMask+rightMask);
% refseeds=GetReferenceSeeds;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     figure('Renderer', 'painters', 'Position', [100 100 1420 370])
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
%         P=burnseeds_5_5([refseeds(3,1),refseeds(3,2)],xform_isbrain);
%         P = reshape(P,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         motor = mean(xform_jrgeco1aCorr(logical(P),:),1);
%         [peakValues,peakLocations,widths,prominences] = findpeaks(motor,(1:length(motor))/25);
%         %         X = NaN(length(peakValues),2);
%         %         X(:,1) = widths;
%         %         X(:,2) = prominences;
%         subplot(1,3,ii)
%         scatter(widths,prominences)
%         ylim([0,1])
%         xlim([0 12])
%         xlabel('peak width(sec)')
%         ylabel('prominences(\DeltaF/F)')
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName, '-Motor'))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_motor','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_motor','.png')))
%    close all
% end
% excelFile = "L:\RGECO\RGECO.xlsx";
% excelRows = 2:7;
% 
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = logical(leftMask+rightMask);
% refseeds=GetReferenceSeeds;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     figure('Renderer', 'painters', 'Position', [100 100 1420 370])
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
%         P=burnseeds_5_5([refseeds(4,1),refseeds(4,2)],xform_isbrain);
%         P = reshape(P,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         somatosensory = mean(xform_jrgeco1aCorr(logical(P),:),1);
%         [peakValues,peakLocations,widths,prominences] = findpeaks(somatosensory,(1:length(somatosensory))/25);
%         %         X = NaN(length(peakValues),2);
%         %         X(:,1) = widths;
%         %         X(:,2) = prominences;
%         subplot(1,3,ii)
%         scatter(widths,prominences)
%         ylim([0,1])
%         xlim([0 7])
%         xlabel('peak width(sec)')
%         ylabel('prominences(\DeltaF/F)')
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName, '-somatosensory'))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_somatosensory','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_somatosensory','.png')))
%     close all
% end

% excelFile = "L:\RGECO\RGECO.xlsx";
% excelRows = 2:7;
% 
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = logical(leftMask+rightMask);
% refseeds=GetReferenceSeeds;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     figure('Renderer', 'painters', 'Position', [100 100 1420 370])
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
%         P=burnseeds_5_5([refseeds(1,1),refseeds(1,2)],xform_isbrain);
%         P = reshape(P,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         frontal = mean(xform_jrgeco1aCorr(logical(P),:),1);
%         [peakValues,peakLocations,widths,prominences] = findpeaks(frontal,(1:length(frontal))/25);
%         %         X = NaN(length(peakValues),2);
%         %         X(:,1) = widths;
%         %         X(:,2) = prominences;
%         subplot(1,3,ii)
%         scatter(widths,prominences)
%         ylim([0,1])
%         xlim([0 10])
%         xlabel('peak width(sec)')
%         ylabel('prominences(\DeltaF/F)')
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName, '-frontal'))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_frontal','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_frontal','.png')))
%     close all
% end


% excelFile = "L:\RGECO\RGECO.xlsx";
% excelRows = 2:7;
% 
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = logical(leftMask+rightMask);
% refseeds=GetReferenceSeeds;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     figure('Renderer', 'painters', 'Position', [100 100 1420 370])
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
%         P=burnseeds_5_5([refseeds(7,1),refseeds(7,2)],xform_isbrain);
%         P = reshape(P,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         visual = mean(xform_jrgeco1aCorr(logical(P),:),1);
%         [peakValues,peakLocations,widths,prominences] = findpeaks(visual,(1:length(visual))/25);
%         %         X = NaN(length(peakValues),2);
%         %         X(:,1) = widths;
%         %         X(:,2) = prominences;
%         subplot(1,3,ii)
%         scatter(widths,prominences)
%         ylim([0,1])
%         xlim([0 10])
%         xlabel('peak width(sec)')
%         ylabel('prominences(\DeltaF/F)')
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName, '-visual'))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_visual','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_visual','.png')))
%     close all
% end


excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:7;

load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
refseeds=GetReferenceSeeds;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 1420 370])
    for ii = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
        P=burnseeds_5_5([refseeds(6,1),refseeds(6,2)],xform_isbrain);
        P = reshape(P,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        Retrosplenial = mean(xform_jrgeco1aCorr(logical(P),:),1);
        [peakValues,peakLocations,widths,prominences] = findpeaks(Retrosplenial,(1:length(Retrosplenial))/25);
        %         X = NaN(length(peakValues),2);
        %         X(:,1) = widths;
        %         X(:,2) = prominences;
        subplot(1,3,ii)
        scatter(widths,prominences)
        ylim([0,1])
        xlim([0 10])
        xlabel('peak width(sec)')
        ylabel('prominences(\DeltaF/F)')
        title(['fc' num2str(ii)])
    end
    suptitle(strcat(recDate,'-',mouseName, '-Retrosplenial'))
    
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_Retrosplenial','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths_Retrosplenial','.png')))
    close all
end


% excelRows = 8:13;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     figure('Renderer', 'painters', 'Position', [100 100 1420 370])
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_isbrain')
%         P=burnseeds([refseeds(3,1),refseeds(3,2)],seedradpix,xform_isbrain);
%         P = reshape(P,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         motor = mean(xform_jrgeco1aCorr(P,:),1);
%         [peakValues,peakLocations,widths,prominences] = findpeaks(motor,(1:length(motor))/25);
%         X = NaN(length(peakValues),2);
%         X(:,1) = widths;
%         X(:,2) = prominences;
%         opts = statset('Display','final');
%         [idx,C] = kmeans(X,2,'Distance','cityblock',...
%             'Replicates',5,'Options',opts);
%         
%         subplot(1,3,ii)
%         plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
%         hold on
%         plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
%         plot(C(:,1),C(:,2),'kx',...
%             'MarkerSize',15,'LineWidth',3)
%         legend('Cluster 1','Cluster 2','Centroids',...
%             'Location','SE')
%         
%         xlabel('peak width(sec)')
%         ylabel('prominences(\DeltaF/F)')
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-kmeans','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-kmean','.png')))
%     close all
% end