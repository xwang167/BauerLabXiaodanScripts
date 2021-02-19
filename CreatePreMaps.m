clear all
close all
clc
excelRows = [182,184,186,233,237];%,203,205,231,235,241];%182,184,186,203,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;

stimStartTime = 5;
temp_oxy_max = 15;
temp_deoxy_max = 10;
temp_total_max = 8;
temp_FAD_max = 1;
temp_jrgeco1aCorr_max = 6;
numRows = 5;
total_ROI_NoGSR = zeros(1,15);
FAD_ROI_NoGSR = zeros(1,15);
calcium_ROI_NoGSR = zeros(1,15);
jj = 1;

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
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName))
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_FADCorr','xform_datahb')
        numBlock = size(xform_FADCorr,3)/sessionInfo.stimblocksize;
        duruationFrames = sessionInfo.stimduration*sessionInfo.framerate;
        oxy = squeeze(xform_datahb(:,:,1,:));
        deoxy = squeeze(xform_datahb(:,:,2,:));
        clear xform_datahb
        total = oxy+deoxy;
        calcium = squeeze(xform_jrgeco1aCorr);
        clear xform_jrgeco1aCorr
        FAD = squeeze(xform_FADCorr);
        clear xform_FADCorr
        
        calcium = reshape(calcium,size(calcium,1),size(calcium,2),[],numBlock)*100;
        FAD = reshape(FAD,size(FAD,1),size(FAD,2),[],numBlock)*100;
        oxy = reshape(oxy,size(oxy,1),size(oxy,2),[],numBlock)*10^6;
        deoxy = reshape(deoxy,size(deoxy,1),size(deoxy,2),[],numBlock)*10^6;
        total = reshape(total,size(total,1),size(total,2),[],numBlock)*10^6;
        calcium_blocks = squeeze(mean(calcium,4));
        
        peakMap_ROI_NoGSR = mean(calcium_blocks(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames),3);
        figure
        imagesc(peakMap_ROI_NoGSR.*xform_isbrain,[-3 3])
        colormap jet
        colorbar
        axis image off
        [x1,y1] = ginput(1);
        
        [x2,y2] = ginput(1);
        
        [X,Y] = meshgrid(1:128,1:128);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        ROI_NoGSR = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        
        max_ROI_NoGSR = prctile(peakMap_ROI_NoGSR(ROI_NoGSR),99);
        
        temp = peakMap_ROI_NoGSR.*ROI_NoGSR;
        
        ROI_NoGSR = temp>0.75*max_ROI_NoGSR;
        title('jrgeco1aCorr');
        
        colormap jet
         figure('units','normalized','outerposition',[0 0 1 1]);
        for ii = 1:numBlock
           
            p1 = subplot(numRows,numBlock,ii);
            oxy_stimTime = squeeze(mean(oxy(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));            
           imagesc(oxy_stimTime,[-temp_oxy_max temp_oxy_max]);
            title(strcat('Pres',{' '},num2str(ii)))
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('oxy')
            end
            if ii == numBlock
                Pos1 = get(p1,'Position');
                colorbar
                set(p1,'Position',Pos1)
            end
            hold on
            contour( ROI_NoGSR,'k');
            p2=subplot(numRows,numBlock,numBlock+ii);
            imagesc(squeeze(mean(deoxy(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('deoxy')
            end
            if ii == numBlock
                Pos2 = get(p2,'Position');
                colorbar
                set(p2,'Position',Pos2)
            end
            hold on
            contour( ROI_NoGSR,'k');
            p3 = subplot(numRows,numBlock,2*numBlock+ii);
            total_stimTime = squeeze(mean(total(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            total_ROI_NoGSR(jj) = mean(total_stimTime(ROI_NoGSR));
            imagesc(total_stimTime,[-temp_total_max temp_total_max]);
            colormap jet
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('total')
                
            end
            if ii == numBlock
                Pos3 = get(p3,'Position');
                colorbar
                set(p3,'Position',Pos3)
            end
            hold on
            contour( ROI_NoGSR,'k');
            
            p4=subplot(numRows,numBlock,3*numBlock+ii);
            FAD_stimTime = squeeze(mean(FAD(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            FAD_ROI_NoGSR(jj) = mean(FAD_stimTime(ROI_NoGSR));
            imagesc(FAD_stimTime,[-temp_FAD_max temp_FAD_max]);
            if ii == 1
                
                ylabel('FADCorr')
            end
            if ii == numBlock
                Pos4 = get(p4,'Position');
                colorbar
                set(p4,'Position',Pos4)
            end
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            hold on
            contour( ROI_NoGSR,'k');
            p5 = subplot(numRows,numBlock,4*numBlock+ii);
            calcium_stimTime = squeeze(mean(calcium(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            calcium_ROI_NoGSR(jj) = mean(calcium_stimTime(ROI_NoGSR));
            imagesc(calcium_stimTime,[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('jrgeco1aCorr')
            end
            if ii == numBlock
                Pos5 = get(p5,'Position');
                colorbar
                set(p5,'Position',Pos5)
            end
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            hold on
            contour( ROI_NoGSR,'k');
            jj = jj + 1;
        end
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' NoGSR BlockPeakMap'))
        output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoGSR_BlockPeakMap'));
        saveas(gcf,strcat(output,'.fig'))
        
        saveas(gcf,strcat(output,'.png'))
        
        save(fullfile(saveDir,processedName),'ROI_NoGSR','-append')
        pause(0.1)
        close all
    end
end

save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'calcium_ROI_NoGSR','FAD_ROI_NoGSR','total_ROI_NoGSR','-append')





stimStartTime = 5;
temp_oxy_max = 15;
temp_deoxy_max = 10;
temp_total_max = 10;
temp_FAD_max = 1.5;
temp_jrgeco1aCorr_max = 6;
numRows = 5;
total_ROI_GSR = zeros(1,15);
FAD_ROI_GSR = zeros(1,15);
calcium_ROI_GSR = zeros(1,15);
jj = 1;

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
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName))
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr_GSR','xform_FADCorr_GSR','xform_datahb_GSR')
        numBlock = size(xform_FADCorr,3)/sessionInfo.stimblocksize;
        duruationFrames = sessionInfo.stimduration*sessionInfo.framerate;
        oxy = squeeze(xform_datahb_GSR(:,:,1,:));
        deoxy = squeeze(xform_datahb_GSR(:,:,2,:));
        clear xform_datahb_GSR
        total = oxy+deoxy;
        calcium = squeeze(xform_jrgeco1aCorr_GSR);
        clear xform_jrgeco1aCorr_GSR
        FAD = squeeze(xform_FADCorr_GSR);
        clear xform_FADCorr_GSR
        
        calcium = reshape(calcium,size(calcium,1),size(calcium,2),[],numBlock)*100;
        FAD = reshape(FAD,size(FAD,1),size(FAD,2),[],numBlock)*100;
        oxy = reshape(oxy,size(oxy,1),size(oxy,2),[],numBlock)*10^6;
        deoxy = reshape(deoxy,size(deoxy,1),size(deoxy,2),[],numBlock)*10^6;
        total = reshape(total,size(total,1),size(total,2),[],numBlock)*10^6;
        calcium_blocks = squeeze(mean(calcium,4));
        
        peakMap_ROI_GSR = mean(calcium_blocks(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames),3);
        figure
        imagesc(peakMap_ROI_GSR.*xform_isbrain,[min(peakMap_ROI_GSR.*xform_isbrain,[],'all') max(peakMap_ROI_GSR.*xform_isbrain,[],'all')])
        colormap jet
        colorbar
        axis image off
        [x1,y1] = ginput(1);
        
        [x2,y2] = ginput(1);
        
        [X,Y] = meshgrid(1:128,1:128);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        ROI_GSR = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        
        max_ROI_GSR = prctile(peakMap_ROI_GSR(ROI_GSR),99);
        
        temp = peakMap_ROI_GSR.*ROI_GSR;
        
        ROI_GSR = temp>0.75*max_ROI_GSR;
        title('jrgeco1aCorr');
        
        colormap jet
        for ii = 1:numBlock
            figure('units','normalized','outerposition',[0 0 1 1]);
            p1 = subplot(numRows,numBlock,ii);
            oxy_stimTime = squeeze(mean(oxy(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));            
           imagesc(oxy_stimTime,[-temp_oxy_max temp_oxy_max]);
            title(strcat('Pres',{' '},num2str(ii)))
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('oxy')
            end
            if ii == numBlock
                Pos1 = get(p1,'Position');
                colorbar
                set(p1,'Position',Pos1)
            end
            hold on
            contour( ROI_GSR,'k');
            p2=subplot(numRows,numBlock,numBlock+ii);
            imagesc(squeeze(mean(deoxy(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('deoxy')
            end
            if ii == numBlock
                Pos2 = get(p2,'Position');
                colorbar
                set(p2,'Position',Pos2)
            end
            hold on
            contour( ROI_GSR,'k');
            p3 = subplot(numRows,numBlock,2*numBlock+ii);
            total_stimTime = squeeze(mean(total(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            total_ROI_GSR(jj) = mean(total_stimTime(ROI_GSR));
            imagesc(total_stimTime,[-temp_total_max temp_total_max]);
            colormap jet
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('total')
                
            end
            if ii == numBlock
                Pos3 = get(p3,'Position');
                colorbar
                set(p3,'Position',Pos3)
            end
            hold on
            contour( ROI_GSR,'k');
            
            p4=subplot(numRows,numBlock,3*numBlock+ii);
            FAD_stimTime = squeeze(mean(FAD(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            FAD_ROI_GSR(jj) = mean(FAD_stimTime(ROI_GSR));
            imagesc(FAD_stimTime,[-temp_FAD_max temp_FAD_max]);
            if ii == 1
                
                ylabel('FADCorr')
            end
            if ii == numBlock
                Pos4 = get(p4,'Position');
                colorbar
                set(p4,'Position',Pos4)
            end
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            hold on
            contour( ROI_GSR,'k');
            p5 = subplot(numRows,numBlock,4*numBlock+ii);
            calcium_stimTime = squeeze(mean(calcium(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            calcium_ROI_GSR(jj) = mean(calcium_stimTime(ROI_GSR));
            imagesc(calcium_stimTime,[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('jrgeco1aCorr')
            end
            if ii == numBlock
                Pos5 = get(p5,'Position');
                colorbar
                set(p5,'Position',Pos5)
            end
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            hold on
            contour( ROI_GSR,'k');
            jj = jj + 1;
        end
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' GSR BlockPeakMap'))
        output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_GSR_BlockPeakMap'));
        saveas(gcf,strcat(output,'.fig'))
        
        saveas(gcf,strcat(output,'.png'))
        
        save(fullfile(saveDir,processedName),'ROI_GSR','-append')
        
    end
end

save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'calcium_ROI_GSR','FAD_ROI_GSR','total_ROI_GSR','-append')





