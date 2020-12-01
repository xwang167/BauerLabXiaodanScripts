temp_oxy_max = 0.25e-5;
temp_deoxy_max = 0.05e-5;
temp_total_max = 0.2e-5;
temp_greenFluorCorr_max = 0.008;
temp_jrgeco1aCorr_max = 0.03;
numRows = 5;
excelRows = [182 184 186];
numBlock = 10;
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
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    
    
    for n = runs
        goodBlocks = ones(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'goodBlocks')
        
        load(fullfile(saveDir,processedName),'xform_datahb_GSR', 'xform_FADCorr_GSR','xform_jrgeco1aCorr_GSR')
        xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,750,10);
        xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,750,10);
        xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,750,10);
        figure('units','normalized','outerposition',[0.2 0.2 0.8 1]);
        for ii = 1:numBlock
            subplot(numRows,numBlock,ii)
            imagesc(squeeze(mean(xform_datahb_GSR(:,:,1,126:250,ii),4)),[-temp_oxy_max temp_oxy_max]);
            title(strcat('Pres',{' '},num2str(ii)))
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('oxy')
                
            end
            
            subplot(numRows,numBlock,numBlock+ii)
            imagesc(squeeze(mean(xform_datahb_GSR(:,:,2,126:250,ii),4)),[-temp_deoxy_max temp_deoxy_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('deoxy')
            end
            
            
            subplot(numRows,numBlock,2*numBlock+ii)
            imagesc(squeeze(mean(xform_datahb_GSR(:,:,1,126:250,ii),4))+squeeze(mean(xform_datahb_GSR(:,:,2,126:250,ii),4)),[-temp_total_max temp_total_max]);
            colormap jet
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('total')
                
            end
            
            
            subplot(numRows,numBlock,3*numBlock+ii)
            imagesc(squeeze(mean(xform_FADCorr_GSR(:,:,125:250,ii),3)),[-temp_greenFluorCorr_max temp_greenFluorCorr_max]);
            if ii == 1
                ylabel('FADCorr')
            end
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            
            
            
            subplot(numRows,numBlock,4*numBlock+ii)
            
            imagesc(squeeze(mean(xform_jrgeco1aCorr_GSR(:,:,126:250,ii),3)),[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
            axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if ii == 1
                ylabel('jrgeco1aCorr')
                
            end
            colormap jet
        end
        suptitle = strcat(visName,' Peak Map for Each Block');
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_GSR_BlockPeakMap.png')))
        close all
    end
end