close all;clear;clc
import mouse.*
excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
excelRows = [3,7,11,15,19,23];%:450;
saveDir_cat = 'X:\Paper1\WT_Paper1\cat';
runs = 1:3;
max_FAD_cat = [];
std_FAD_cat = [];
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    for n = runs
        peak_FAD = nan(1,10);
        std_FAD = nan(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr')

        xform_FADCorr = reshape(xform_FADCorr,128,128,750,[]);
        baseline= mean(xform_FADCorr(:,:,1:125,:),3);
        baseline = repmat(baseline,1,1,750,1);
        xform_FADCorr = xform_FADCorr-baseline;        
        load(fullfile(saveDir,processedName),'ROI_NoGSR') 
        if ~exist('ROI_NoGSR','var')
            peakMap = mean(xform_FADCorr,4);
            peakMap_ROI = mean(peakMap(:,:,126:250),3);
            figure
            imagesc(peakMap_ROI,[-0.01 0.01])
            hold on
            load('C:\Users\Xiaodan Wang\Documents\GitHub\OIS_Process\atlas.mat','AtlasSeeds')
            Barrel = AtlasSeeds==9;
            contour(Barrel,'w')
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
            ROI_NoGSR= ROI;
            save(fullfile(saveDir,processedName),'ROI_NoGSR','-append')
        end
        iROI = reshape(ROI_NoGSR,1,[]);
        clear ROI_NoGSR
        xform_FADCorr = reshape(xform_FADCorr,128*128,750,10);
        FADCorr_ROI = squeeze(mean(xform_FADCorr(iROI,:,:),1));
        timeTrace_FADCorr = reshape(FADCorr_ROI,1,[]);
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        plot((1:7500)/25,timeTrace_FADCorr,'m')
        xlabel('Time(s)')
        ylabel('\DeltaF/F')
        title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace'))

        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace.mat')),'timeTrace_FADCorr')
        savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-TimeTrace','.png')))
        close all
        for ii = 1:10
            max_FAD = max(FADCorr_ROI(126:250,ii));      
            std_FAD = squeeze(std(FADCorr_ROI(1:125,ii),0,1));
            max_FAD_cat = [max_FAD_cat,max_FAD];
            std_FAD_cat = [std_FAD_cat,std_FAD];
        end
    end
end
figure
plot(sort(max_FAD_cat./std_FAD_cat),'b-')
ylabel('SNR')
hold on
title('WT','Color','m')
xlabel('Block Number')
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-SNR','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'-SNR','.png')))

% save
saveName = 'X:\Paper1\WT_Paper1\cat\FAD_quantification.mat';
save(saveName,'max_FAD_cat','std_FAD_cat')