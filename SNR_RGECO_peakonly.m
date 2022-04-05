clear all;clc
import mouse.*
excelFile = "X:\Paper\PaperExperiment.xlsx";
excelRows = [26 27 34];%:450;
runs = 1:3;
peak_rgeco_cat = [];
std_rgeco_cat = [];

saveDir_cat = 'X:\Paper\RGECO\cat';
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
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
    
    %     processedName_ROI = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');
    %     load(fullfile(saveDir,processedName_ROI),'xform_rgecoCorr')
    %     xform_rgecoCorr = reshape(xform_rgecoCorr,128,128,750,[]);
    %     baseline= peak(xform_rgecoCorr(:,:,1:125),3);
    %     baseline = repmat(baseline,1,1,750,10);
    %     xform_rgecoCorr = xform_rgecoCorr-baseline;
    %     peakMap = peak(xform_rgecoCorr,4);
    %     peakMap_ROI = peak(peakMap(:,:,126:250),3);
    %     figure
    %     imagesc(peakMap_ROI)
    %     hold on
    %     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
    %     Barrel = AtlasSeeds==9;
    %     contour(Barrel)
    %     [x1,y1] = ginput(1);
    %     [x2,y2] = ginput(1);
    %     [X,Y] = meshgrid(1:128,1:128);
    %     radius = sqrt((x1-x2)^2+(y1-y2)^2);
    %     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    %     max_ROI = prctile(peakMap_ROI(ROI),99);
    %     temp = double(peakMap_ROI).*double(ROI);
    %     ROI = temp>max_ROI*0.75;
    %     hold on
    %     contour(ROI)
    %     iROI = reshape(ROI,1,[]);
    
    for n = runs
        peak_rgeco = nan(1,10);
        std_rgeco = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','ROI_NoGSR')
        iROI = reshape(ROI_NoGSR,1,[]);
        %         load(fullfile(saveDir,processedName),'xform_rgecoCorr')
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,[]);
        baseline= mean(xform_jrgeco1aCorr(:,:,1:125,:),3);
        baseline = repmat(baseline,1,1,750,1);
        xform_jrgeco1aCorr = xform_jrgeco1aCorr-baseline;
        
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,750,10);
        rgecoCorr_ROI = squeeze(mean(xform_jrgeco1aCorr(iROI,:,:),1));
        timeTrace = reshape(rgecoCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:7500)/25,timeTrace,'m')
        xlabel('Time(s)')
        ylabel('\muF/F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))

        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace.mat')),'timeTrace')
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))
        for ii = 1:10
            [peak_rgeco,loc] =findpeaks(rgecoCorr_ROI(126:250,ii),'MinPeakDistance',5,'MinPeakProminence',0.004);
            %             figure
            %             plot(rgecoCorr_ROI(126:250,ii));
            %             hold on
            %             scatter(loc,peak_rgeco);
            
            if excelRow==27 && n==1 &&  ii == 2
                peak_rgeco(end+1) = 0.087;
            end
            if excelRow==27 && n==2 &&  ii == 2
                peak_rgeco(end+1) = 0.060;
            end
            
            if excelRow==27 && n==3 &&  ii == 4
                peak_rgeco(end+1) = 0.060;
            end
            
            if excelRow==27 && n==3 &&  ii == 5
                peak_rgeco(end+1) = 0.051;
            end
            
            if excelRow==34 && n==1 &&  ii == 2
                peak_rgeco(end+1) = 0.098;
            end
            
            if excelRow==34 && n==1 &&  ii == 4
                peak_rgeco(end+1) = 0.13;
            end
            
            
            if excelRow==34 && n==1 &&  ii == 6
                peak_rgeco(end+1) = 0.11;
            end
            
            if excelRow==34 && n==1 &&  ii == 8
                peak_rgeco(end+1) = 0.12;
            end
            
            if excelRow==34 && n==1 &&  ii == 9
                peak_rgeco(end+1) = 0.092;
            end
            
            if excelRow==34 && n==2 &&  ii == 3
                peak_rgeco(end+1) = 0.071;
            end
            if excelRow==34 && n==3 &&  ii == 2
                peak_rgeco(end+1) = 0.053;
            end
            
            
            if length(peak_rgeco)~=15
                disp('change minpeakpromimence')
                pause
            end
            
            
            peak_rgeco = mean(peak_rgeco);
            std_rgeco = squeeze(std(rgecoCorr_ROI(1:125,ii),0,1));
            %             if peak_rgeco >0
            peak_rgeco_cat = [peak_rgeco_cat,peak_rgeco];
            std_rgeco_cat = [std_rgeco_cat,std_rgeco];
            %             end
        end
    end
end
figure
yyaxis left
plot(peak_rgeco_cat,'r-')
hold on
plot(std_rgeco_cat,'g-')
ylim([-0.01 0.2])
ylabel('\muF/F')
hold on
yyaxis right
ylabel('SNR')
plot(peak_rgeco_cat./std_rgeco_cat,'b-')
ylim([-20 20])
legend('peak','standard deviation','SNR')
title(strcat(recDate,'-RGECO-SNR'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-peak-std-ratio','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-peak-std-ratio','.png')))


SNR_mouse1 = mean(peak_rgeco_cat(1:30)./std_rgeco_cat(1:30));
SNR_mouse2 = mean(peak_rgeco_cat(31:60)./std_rgeco_cat(31:60));
SNR_mouse3 = mean(peak_rgeco_cat(31:60)./std_rgeco_cat(61:90));