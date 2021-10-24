clear all;clc
import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = [16];%:450;
runs = 2;
mean_jrgeco1a_cat = [];
std_jrgeco1a_cat = [];
miceName = [];
saveDir_cat = 'L:\RGECO\cat';
mean_jrgeco1a_blocks_cat = [];
std_jrgeco1a_blocks_cat = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    % maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
    %     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    
    processedName_ROI = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');
    load(fullfile(saveDir,processedName_ROI),'xform_jrgeco1aCorr')
    xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,[]);
    baseline= mean(xform_jrgeco1aCorr(:,:,1:125),3);
    baseline = repmat(baseline,1,1,750,10);
    xform_jrgeco1aCorr = xform_jrgeco1aCorr-baseline;
    peakMap = mean(xform_jrgeco1aCorr,4);
    peakMap_ROI = mean(peakMap(:,:,126:250),3);
    figure
    imagesc(peakMap_ROI)
    [x1,y1] = ginput(1);
    [x2,y2] = ginput(1);
    [X,Y] = meshgrid(1:128,1:128);
    radius = sqrt((x1-x2)^2+(y1-y2)^2);
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    max_ROI = prctile(peakMap_ROI(ROI),99);
    temp = double(peakMap_ROI).*double(ROI);
    ROI = temp>max_ROI*0.75;
    hold on
    contour(ROI)
    iROI = reshape(ROI,1,[]);
    jrgeco1aCorr_ROI_mouse = [];
    for n = runs
        mean_jrgeco1a = nan(1,10);
        sd_jrgeco1a = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,[]);
        baseline= mean(xform_jrgeco1aCorr(:,:,1:125,:),3);
        baseline = repmat(baseline,1,1,750,1);
        xform_jrgeco1aCorr = xform_jrgeco1aCorr-baseline;
        
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,750,10);
        jrgeco1aCorr_ROI = squeeze(mean(xform_jrgeco1aCorr(iROI,:,:),1));
        timeTrace = reshape(jrgeco1aCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:7500)/25,timeTrace,'m')
        xlabel('Time(s)')
        ylabel('?F\F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))
        jrgeco1aCorr_ROI_mouse = cat(2,jrgeco1aCorr_ROI_mouse,jrgeco1aCorr_ROI);
        for ii = 1:10
            mean_jrgeco1a = squeeze(mean(jrgeco1aCorr_ROI(126:250,ii),1));
            std_jrgeco1a = squeeze(std(jrgeco1aCorr_ROI(1:125,ii),0,1));
            %             if mean_jrgeco1a >0
            mean_jrgeco1a_cat = [mean_jrgeco1a_cat,mean_jrgeco1a];
            std_jrgeco1a_cat = [std_jrgeco1a_cat,std_jrgeco1a];
            %             end
        end
    end
    jrgeco1aCorr_ROI_mouse = mean(jrgeco1aCorr_ROI_mouse,2);
    figure
    plot((1:750)/25,jrgeco1aCorr_ROI_mouse,'m')
    xlabel('Time(s)')
    ylabel('?F\F')
    title(strcat(recDate,'-',mouseName,'-average across blocks'))
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-TimeTrace-AverageAcrossBlock','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-TimeTrace-AverageAcrossBlock','.png')))
    mean_jrgeco1a_mouse = mean(jrgeco1aCorr_ROI_mouse(126:250),1);
    std_jrgeco1a_mouse =std(jrgeco1aCorr_ROI_mouse(1:125));
    mean_jrgeco1a_blocks_cat = cat(2,mean_jrgeco1a_blocks_cat,mean_jrgeco1a_mouse);
    std_jrgeco1a_blocks_cat = cat(2,std_jrgeco1a_blocks_cat,std_jrgeco1a_mouse);
end
figure
yyaxis left
plot(mean_jrgeco1a_cat,'r-')
hold on
plot(std_jrgeco1a_cat,'g-')
ylim([-0.01 0.09])
ylabel('?F\F')
hold on
yyaxis right
ylabel('SNR')
plot(mean_jrgeco1a_cat./std_jrgeco1a_cat,'b-')
ylim([-20 20])
legend('mean','standard deviation','SNR')
title(strcat(recDate,'-jrgeco1a-SNR'))
savefig(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio','.png')))


figure
yyaxis left
plot(mean_jrgeco1a_blocks_cat,'r-')
hold on
plot(std_jrgeco1a_blocks_cat,'g-')
ylim([-0.01 0.09])
ylabel('?F\F')
hold on
yyaxis right
ylabel('SNR')
plot(mean_jrgeco1a_blocks_cat./std_jrgeco1a_blocks_cat,'b-')
xticks(1:5)
ylim([-50 50])
legend('mean','standard deviation','SNR')
title(strcat(recDate,'-jrgeco1a-SNR-averaged across block'))
savefig(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio-blocks','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-mean-std-ratio-blocks','.png')))