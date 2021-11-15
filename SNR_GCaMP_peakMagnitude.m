clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [219,222,225];%:450;
runs = 1:3;
max_gcamp_cat = [];
std_gcamp_cat = [];

max_gcamp_blocks_cat = [];
std_gcamp_blocks_cat = [];
saveDir_cat = 'O:\GCaMP\Xiaodan_dpf\cat';
miceName = [];
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
    maskDir = saveDir;
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    
    processedName_ROI = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');
    load(fullfile(saveDir,processedName_ROI),'xform_gcampCorr')
    xform_gcampCorr = reshape(xform_gcampCorr,128,128,600,[]);
    baseline= mean(xform_gcampCorr(:,:,1:100),3);
    baseline = repmat(baseline,1,1,600,10);
    xform_gcampCorr = xform_gcampCorr-baseline;
    peakMap = mean(xform_gcampCorr,4);
    peakMap_ROI = mean(peakMap(:,:,101:200),3);
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
    gcampCorr_ROI_mouse = [];
    for n = runs
        max_gcamp = nan(1,10);
        sd_gcamp = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_gcampCorr')
        xform_gcampCorr = reshape(xform_gcampCorr,128,128,600,[]);
        baseline= mean(xform_gcampCorr(:,:,1:100,:),3);
        baseline = repmat(baseline,1,1,600,1);
        xform_gcampCorr = xform_gcampCorr-baseline;
        
        xform_gcampCorr = reshape(xform_gcampCorr,128*128,600,10);
        gcampCorr_ROI = squeeze(mean(xform_gcampCorr(iROI,:,:),1));
        timeTrace = reshape(gcampCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:6000)/20,timeTrace,'g')
          xlabel('Time(s)')
         ylabel('\DeltaF/F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))
        gcampCorr_ROI_mouse = cat(2,gcampCorr_ROI_mouse,gcampCorr_ROI);
        for ii = 1:10
            max_gcamp = squeeze(max(gcampCorr_ROI(101:200,ii),[],'all'));
            std_gcamp = squeeze(std(gcampCorr_ROI(1:100,ii),0,1));
            %             if mean_gcamp >0
            max_gcamp_cat = [max_gcamp_cat,max_gcamp];
            std_gcamp_cat = [std_gcamp_cat,std_gcamp];
            %             end
        end
    end
    gcampCorr_ROI_mouse = mean(gcampCorr_ROI_mouse,2);
    figure
    plot((1:600)/20,gcampCorr_ROI_mouse,'g')
    xlabel('Time(s)')
    ylabel('\DeltaF/F')
    title(strcat(recDate,'-',mouseName,'-average across blocks'))
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-TimeTrace-AverageAcrossBlock','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-TimeTrace-AverageAcrossBlock','.png')))
    max_gcamp_mouse = max(gcampCorr_ROI_mouse(101:200),[],'all');
    std_gcamp_mouse =std(gcampCorr_ROI_mouse(1:100));
    max_gcamp_blocks_cat = cat(2,max_gcamp_blocks_cat,max_gcamp_mouse);
    std_gcamp_blocks_cat = cat(2,std_gcamp_blocks_cat,std_gcamp_mouse);
end
figure
yyaxis left
plot(max_gcamp_cat,'r-')
hold on
plot(std_gcamp_cat,'g-')
ylim([-0.01 0.09])
ylabel('\DeltaF/F')
hold on
yyaxis right
ylabel('SNR')
plot(max_gcamp_cat./std_gcamp_cat,'b-')
ylim([-20 20])
xlabel('Blocks')
legend('Maximum','standard deviation','SNR')
title(strcat(recDate,'-GCaMP-SNR'))
savefig(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-max-std-ratio','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-max-std-ratio','.png')))


figure
yyaxis left
plot(max_gcamp_blocks_cat,'r-')
hold on
plot(std_gcamp_blocks_cat,'g-')
ylim([-0.01 0.09])
ylabel('\DeltaF/F')
hold on
yyaxis right
ylabel('SNR')
plot(max_gcamp_blocks_cat./std_gcamp_blocks_cat,'b-')
xticks(1:3)

ylim([0 30])
legend('Maximum','standard deviation','SNR')
title(strcat(recDate,'-GCaMP-SNR-averaged across block'))
savefig(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-max-std-ratio-blocks','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',mouseName,'-',sessionType,'-max-std-ratio-blocks','.png')))