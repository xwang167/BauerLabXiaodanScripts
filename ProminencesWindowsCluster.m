% close all;clear all;clc
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:13;

load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
% 
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 1420 370])
    for ii = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        mask = reshape(mask,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        gs = mean(xform_jrgeco1aCorr(mask,:),1);
        [peakValues,peakLocations,widths,prominences] = findpeaks(gs,(1:length(gs))/25);
        %         X = NaN(length(peakValues),2);
        %         X(:,1) = widths;
        %         X(:,2) = prominences;
        subplot(1,3,ii)
        scatter(widths,prominences)
        xlim([0 12])
        ylim([0 1])
        xlabel('peak width(sec)')
        ylabel('prominences(\DeltaF/F)')
        title(['fc' num2str(ii)])
    end
    suptitle(strcat(recDate,'-',mouseName))
    
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ProminencesWidths','.png')))
    
end

excelRows = 8:13;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 1420 370])
    for ii = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        mask = reshape(mask,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        gs = mean(xform_jrgeco1aCorr(mask,:),1);
        [peakValues,peakLocations,widths,prominences] = findpeaks(gs,(1:length(gs))/25);
        X = NaN(length(peakValues),2);
        X(:,1) = widths;
        X(:,2) = prominences;
        opts = statset('Display','final');
        [idx,C] = kmeans(X,2,'Distance','cityblock',...
            'Replicates',5,'Options',opts);
        
        subplot(1,3,ii)
        plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
        hold on
        plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
        plot(C(:,1),C(:,2),'kx',...
            'MarkerSize',15,'LineWidth',3)
        legend('Cluster 1','Cluster 2','Centroids',...
            'Location','SE')
        
        xlabel('peak width(sec)')
        ylabel('prominences(\DeltaF/F)')
        title(['fc' num2str(ii)])
    end
    suptitle(strcat(recDate,'-',mouseName))
    
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-kmeans','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-kmean','.png')))
   
end