%clear all
close all
clc
excelRows = [182,184,186,229,233,237];%;%182,184,186,203,   [203 231 235 241];% 
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
stimStartTime = 5;
total_ROI_NoGSR = zeros(1,120);
FAD_ROI_NoGSR = zeros(1,120);
calcium_ROI_NoGSR = zeros(1,120);
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
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_FADCorr','xform_datahb','ROI_NoGSR')
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
         for ii = 1:numBlock
            MeanFrame=squeeze(mean(calcium(:,:,1:sessionInfo.stimbaseline,ii),3));
            calcium = calcium - repmat(MeanFrame,1,1,size(calcium,3),1);
            
            MeanFrame=squeeze(mean(FAD(:,:,1:sessionInfo.stimbaseline,ii),3));
            FAD = FAD - repmat(MeanFrame,1,1,size(FAD,3),1);
            
            MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,ii),3));
            oxy = oxy - repmat(MeanFrame,1,1,size(oxy,3),1);
            
            MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,ii),3));
            deoxy = deoxy - repmat(MeanFrame,1,1,size(deoxy,3),1);
            
            MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,ii),3));
            total = total - repmat(MeanFrame,1,1,size(total,3),1);
        end

        for ii = 1:numBlock
           
            total_stimTime = squeeze(mean(total(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            total_ROI_NoGSR(jj) = mean(total_stimTime(ROI_NoGSR));
           
            FAD_stimTime = squeeze(mean(FAD(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            FAD_ROI_NoGSR(jj) = mean(FAD_stimTime(ROI_NoGSR));
        
            calcium_stimTime = squeeze(mean(calcium(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            calcium_ROI_NoGSR(jj) = mean(calcium_stimTime(ROI_NoGSR));
            jj = jj+1;
        end
    end
end

excelRows = [182,184,186,233,229,237];% [203 231 235 241];%
stimStartTime = 5;
total_ROI_GSR = nan(1,120);
FAD_ROI_GSR = nan(1,120);
calcium_ROI_GSR = nan(1,120);
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
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr_GSR','xform_FADCorr_GSR','xform_datahb_GSR','ROI_GSR')

        numBlock = size(xform_FADCorr_GSR,3)/sessionInfo.stimblocksize;
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
        
        
         for ii = 1:numBlock
            MeanFrame=squeeze(mean(calcium(:,:,1:sessionInfo.stimbaseline,ii),3));
            calcium = calcium - repmat(MeanFrame,1,1,size(calcium,3),1);
            
            MeanFrame=squeeze(mean(FAD(:,:,1:sessionInfo.stimbaseline,ii),3));
            FAD = FAD - repmat(MeanFrame,1,1,size(FAD,3),1);
            
            MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,ii),3));
            oxy = oxy - repmat(MeanFrame,1,1,size(oxy,3),1);
            
            MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,ii),3));
            deoxy = deoxy - repmat(MeanFrame,1,1,size(deoxy,3),1);
            
            MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,ii),3));
            total = total - repmat(MeanFrame,1,1,size(total,3),1);
        end
        
       
        for ii = 1:numBlock
            
           
            total_stimTime = squeeze(mean(total(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            total_ROI_GSR(jj) = mean(total_stimTime(ROI_GSR));
                      
            FAD_stimTime = squeeze(mean(FAD(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            FAD_ROI_GSR(jj) = mean(FAD_stimTime(ROI_GSR));
            
            calcium_stimTime = squeeze(mean(calcium(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+duruationFrames,ii),3));           
            calcium_ROI_GSR(jj) = mean(calcium_stimTime(ROI_GSR));
            jj = jj + 1;
        end

    end
end
save('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat','FAD_ROI_NoGSR', 'calcium_ROI_NoGSR', 'total_ROI_NoGSR', 'FAD_ROI_GSR', 'calcium_ROI_GSR', 'total_ROI_GSR','-append')
%save('191030--R5M2285-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-stim_processed_mice.mat', 'FAD_ROI_NoGSR', 'calcium_ROI_NoGSR', 'total_ROI_NoGSR', 'FAD_ROI_GSR', 'calcium_ROI_GSR', 'total_ROI_GSR','-append')

