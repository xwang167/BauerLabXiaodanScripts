load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
% load('L:\RGECO\190707\190707-R5M2286-anes-fc2_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% [~,~,~,ps]=spectrogram(gs,750,375,750,25,'yaxis');
% title('Aensthetized 2286')
% colormap jet
% ylim([0.4 4])
%
% figure
% load('L:\RGECO\190627\190627-R5M2286-fc1_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% spectrogram(gs,750,375,750,25,'yaxis')
% title('awake')
% colormap jet
% ylim([0.4 4])
%
% figure
% load('L:\RGECO\190710\190710-R5M2285-anes-fc3_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% spectrogram(gs,750,375,750,25,'yaxis')
% title('Aensthetized 2285')
% colormap jet
% ylim([0.4 4])
%
%
%
% figure
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = logical(leftMask+rightMask);
% load('L:\RGECO\190707\190707-R5M2286-anes-fc2_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% spectrogram(gs,250,125,250,25,'yaxis')
% title('Aensthetized 2286')
% colormap jet
% ylim([0.4 4])
%
% figure
% load('L:\RGECO\190627\190627-R5M2286-fc1_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% spectrogram(gs,250,125,250,25,'yaxis')
% title('awake')
% colormap jet
% ylim([0.4 4])
%
% figure
% load('L:\RGECO\190710\190710-R5M2285-anes-fc3_processed.mat','xform_jrgeco1aCorr')
% mask = reshape(mask,[],1);
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% gs = mean(xform_jrgeco1aCorr(mask,:),1);
% spectrogram(gs,250,125,250,25,'yaxis')
% title('Aensthetized 2285')
% colormap jet
% ylim([0.4 4])
% 
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:13;

load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
% mask = imresize(mask, 0.5);

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 1420 740])
    ps_mouse = []; 
    for ii = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
        ps_mask = [];
        tic
        for jj = 1:size(xform_jrgeco1aCorr,1)
            for ll = 1:size(xform_jrgeco1aCorr,1)
                  if mask(jj,ll)
                      timetrace = squeeze(xform_jrgeco1aCorr(jj,ll,:));
                      [~,f,t,ps] = spectrogram(timetrace,750,375,750,25,'yaxis');
                      ps_mask = cat(3,ps_mask,ps);
                  end
            end
        end
        toc
        ps_mask = mean(ps_mask,3);
        ps_mouse = cat(2,ps_mouse,ps_mask);
    end
    
    figure
    imagesc(10*log10(flip(ps_mouse)))
    xticks(0:19:114)    
    xticklabels({'0','5','10','15','20','25','30'})
    
    yticks(flip(376:-60.16:75.2))   
    yticklabels(flip({'0','2','4','6','8','10'}))
    ylim([75.2 376])
    colormap jet
    hfig = gcf;
    hfig.CurrentAxes.CLim = [-80 -20];
    xlabel('Time(minutes)')
    ylabel('Frequency(Hz)')
    h = colorbar;
    ylabel(h, 'Power/Frequency(dB/Hz)')
    title(strcat(recDate,'-',mouseName,'-each pixel then average aross brain'))
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_eachpix','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_eachpix','.png')))
    close all
end

% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
%         mask = reshape(mask,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         gs = mean(xform_jrgeco1aCorr(mask,:),1);
%         [~,f,t,ps] = spectrogram(gs,750,375,750,25,'yaxis');
%         ps_db = 10*log10(ps);
%         ps_db_mean = mean(ps_db,2);
%         ps_db_std = std(ps_db,0,2);
%         figure
%         subplot(2,1,1)
%         plot(f,ps_db_mean)
%         xlabel('Frequence(Hz)')
%         ylabel('mean(dB/Hz)')
%         title('mean')
%         subplot(2,1,2)
%         plot(f,ps_db_std)
%         xlabel('Frequence(Hz)')
%         ylabel('standard deviation(dB/Hz)')
%         title('standard deviation')
%         suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii)))        
%         savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'-Spectrogram_mean_std','.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'-Spectrogram_mean_std','.png')))
%     end   
%     close all
% end
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     for ii = 1:3
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
%         mask = reshape(mask,[],1);
%         xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
%         gs = median(xform_jrgeco1aCorr(mask,:),1);
%         [~,f,t,ps] = spectrogram(gs,750,375,750,25,'yaxis');
%         ps_db = 10*log10(ps);
%         ps_db_median = median(ps_db,2);
%         ps_db_25 =  quantile(ps_db,0.25,2);
%         ps_db_75 =  quantile(ps_db,0.75,2);
%         figure
%         plot(f,ps_db_median,'k-')
%         hold on
%         plot(f,ps_db_25,'r:')
%         hold on
%         plot(f,ps_db_75,'r:')
%         xticks(1:14)
%         grid on
%         xlabel('Frequence(Hz)')
%         ylabel('Power/frequency(dB/Hz)')       
%         legend('Median','25th quantile','75th quantile')
%         xlim([0 12.5])
%         title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii)))        
%         savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'-Spectrogram_median_25_75','.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'-Spectrogram_median_25_75','.png')))
%     end   
%     close all
% end



excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 13;

load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 500 300])
    gs3 = [];
    for ii = 2:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        mask = reshape(mask,[],1);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        gs = mean(xform_jrgeco1aCorr(mask,:),1);
        gs3 = [gs3,gs];    
        disp(strcat(recDate,'-',mouseName))
    end
%     spectrogram(gs3,750,375,750,25,'yaxis')
%     ylim([0 10])
%     colormap jet
%     hfig = gcf;
%     hfig.CurrentAxes.CLim = [-80 -20];
%     title(strcat(recDate,'-',mouseName))
%     
%     savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_thirtyMinutes','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_thirtyMinutes','.png')))
%     close all
end

