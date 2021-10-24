

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
%         
%         subplot(1,3,ii)
%         plot((1:750)/25,motor(1:750))
%         xlabel('Time(sec)')
%         ylabel('Fluorescence(\DeltaF/F)')
%         ylim([-0.1 0.5])
%         title(['fc' num2str(ii)])
%     end
%     suptitle(strcat(recDate,'-',mouseName, '-Motor'))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_motor','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_motor','.png')))
%    close all
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
        P=burnseeds_5_5([refseeds(4,1),refseeds(4,2)],xform_isbrain);
        P = reshape(P,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        somatosensory = mean(xform_jrgeco1aCorr(logical(P),:),1);
        %         X = NaN(length(peakValues),2);
        %         X(:,1) = widths;
        %         X(:,2) = prominences;
        subplot(1,3,ii)
        plot((1:750)/25,somatosensory(1:750))
        xlabel('Time(sec)')
        ylabel('Fluorescence(\DeltaF/F)')
        ylim([-0.1 0.5])
        title(['fc' num2str(ii)])
        
    end
    suptitle(strcat(recDate,'-',mouseName, '-somatosensory'))
    
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_somatosensory','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_somatosensory','.png')))
    close all
end

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
        P=burnseeds_5_5([refseeds(1,1),refseeds(1,2)],xform_isbrain);
        P = reshape(P,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        frontal = mean(xform_jrgeco1aCorr(logical(P),:),1);
        subplot(1,3,ii)
        plot((1:750)/25,frontal(1:750))
        xlabel('Time(sec)')
        ylabel('Fluorescence(\DeltaF/F)')
        ylim([-0.1 0.5])
        title(['fc' num2str(ii)])
    end
    suptitle(strcat(recDate,'-',mouseName, '-frontal'))
    
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_frontal','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-ClusterTimeTrace_frontal','.png')))
    close all
end
