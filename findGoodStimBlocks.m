clear all;close all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','ROI_NoGSR')
totalBlocksNum = 0;
excelRows = [182 184 186 229 233 237];
ll = 1;
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
    %     maskName_new = strcat(recDate,'-N8M864-1hz-opto3-LandmarksAndMask','.mat');
    %     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %     %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %     load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    %     xform_isbrain = double(xform_isbrain);
    %     if ~isempty(find(isnan(xform_isbrain), 1))
    %         xform_isbrain(isnan(xform_isbrain))=0;
    %     end
    xform_datahb_GSR_mouse_goodBlocks = [];
    xform_FADCorr_GSR_mouse_goodBlocks = [];
    xform_jrgeco1aCorr_GSR_mouse_goodBlocks = [];
    for n = runs
        goodBlocks = ones(1,10);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        try
            load(fullfile(saveDir,processedName),'xform_datahb_GSR',...
                'xform_FADCorr_GSR','xform_jrgeco1aCorr_GSR',...
                'xform_FAD_GSR','xform_jrgeco1a')
            for ii = 1:size(xform_datahb_GSR,4)
                xform_isbrain(isinf(xform_datahb_GSR(:,:,1,ii))) = 0;
                xform_isbrain(isnan(xform_datahb_GSR(:,:,1,ii))) = 0;
                
            end
            xform_datahb_GSR(isinf(xform_datahb_GSR)) = 0;
            xform_datahb_GSR(isnan(xform_datahb_GSR)) = 0;
            %             load('D:\OIS_Process\noVasculatureMask.mat')
            %
            %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            stimStartTime = 5;
            xform_oxy = reshape(xform_datahb_GSR(:,:,1,:),128*128,750,10);
            xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128*128,750,10);
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128*128,750,10);
            
            for ii = 1:10      
                timetrace_jrgeco1aCorr = mean(xform_jrgeco1aCorr_GSR(ROI_NoGSR,:,ii),1);
                %                   figure
                %     plot(timetrace_jrgeco1aCorr);title(['FAD',num2str(ii)]);
                mean_jrgeco1aCorr = mean(timetrace_jrgeco1aCorr(126:250));
                std_jrgeco1aCorr= std(timetrace_jrgeco1aCorr(1:125));
                if mean_jrgeco1aCorr<2*std_jrgeco1aCorr
                    goodBlocks(ii) = 0;
                    figure
                    plot(timetrace_jrgeco1aCorr)
                end
            end
            totalBlocksNum = totalBlocksNum + sum(goodBlocks);
            goodBlocks = logical(goodBlocks)
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,750,10);
            xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,750,10);
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,750,10);
            xform_datahb_GSR_mouse_goodBlocks = cat(5,xform_datahb_GSR_mouse_goodBlocks,xform_datahb_GSR(:,:,:,:,goodBlocks));
            xform_FADCorr_GSR_mouse_goodBlocks = cat(4,xform_FADCorr_GSR_mouse_goodBlocks,xform_FADCorr_GSR(:,:,:,goodBlocks));
            xform_jrgeco1aCorr_GSR_mouse_goodBlocks = cat(4,xform_jrgeco1aCorr_GSR_mouse_goodBlocks,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks));
            save(fullfile(saveDir,processedName),'goodBlocks','-append')
        catch
            disp(['Did not load file',processedName]);
        end
    end
    
    xform_datahb_GSR_mouse_goodBlocks = nanmean(xform_datahb_GSR_mouse_goodBlocks,5);
    xform_FADCorr_GSR_mouse_goodBlocks = nanmean(xform_FADCorr_GSR_mouse_goodBlocks,4);
    xform_jrgeco1aCorr_GSR_mouse_goodBlocks = nanmean(xform_jrgeco1aCorr_GSR_mouse_goodBlocks,4);
    
    imagesc(xform_jrgeco1aCorr_GSR_mouse_goodBlocks(:,:,1));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    if exist(fullfile(saveDir, processedName_mouse))
    save(fullfile(saveDir, processedName_mouse),'xform_datahb_GSR_mouse_goodBlocks','xform_FADCorr_GSR_mouse_goodBlocks','xform_jrgeco1aCorr_GSR_mouse_goodBlocks','-append')
    else
         save(fullfile(saveDir, processedName_mouse),'xform_datahb_GSR_mouse_goodBlocks','xform_FADCorr_GSR_mouse_goodBlocks','xform_jrgeco1aCorr_GSR_mouse_goodBlocks')

    end
    
    if ~isnan(xform_datahb_GSR_mouse_goodBlocks(64,64,1,1))
        xform_datahb_GSR_mice_goodBlocks(:,:,:,:,ll) =xform_datahb_GSR_mouse_goodBlocks;
        xform_FADCorr_GSR_mice_goodBlocks(:,:,:,ll) = xform_FADCorr_GSR_mouse_goodBlocks;
        xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,:,ll) = xform_jrgeco1aCorr_GSR_mouse_goodBlocks;
    end
    ll = ll+1;
end


xform_datahb_GSR_mice_goodBlocks = mean(xform_datahb_GSR_mice_goodBlocks,5);
xform_FADCorr_GSR_mice_goodBlocks = mean(xform_FADCorr_GSR_mice_goodBlocks,4);
xform_jrgeco1aCorr_GSR_mice_goodBlocks = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks,4);


jrgeco1aCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_GSR)/0.01,sessionInfo.framerate,[1,4]);

xform_jrgeco1aCorr_GSR_mice_goodBlocks = reshape(xform_jrgeco1aCorr_GSR_mice_goodBlocks,[],750);
timetrace = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(ROI_NoGSR,:),1);
baseline = mean(timetrace(1:125));
timetrace = timetrace-baseline;
TF = islocalmax(timetrace);
TF(1:125) = 0;
TF(251:end) = 0;
figure
time = (1:750)/25;
plot(time, timetrace)
hold on
plot(time,TF/30)

xform_jrgeco1aCorr_GSR_mice_goodBlocks = reshape(xform_jrgeco1aCorr_GSR_mice_goodBlocks,128,128,[]);
peakMap_localMax = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,TF),3);
figure
imagesc(peakMap_localMax,[-0.02 0.02])
colorbar
axis image off
title('only peaks')
colormap jet

peakMap = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,126:250),3);
figure
imagesc(peakMap,[-0.02,0.02])
colorbar
colormap jet
axis image off
title('from 5s to 10s')
% xform_jrgeco1aCorr_GSR_mice_NoGSR = reshape(xform_jrgeco1aCorr_GSR_mice_NoGSR,[],750);
% timetrace = mean(xform_jrgeco1aCorr_GSR_mice_NoGSR(ROI_NoGSR,:),1);
% baseline = mean(timetrace(1:125));
% timetrace = timetrace-baseline;
% TF = islocalmax(timetrace);
% TF(1:125) = 0;
% TF(251:end) = 0;
% figure
% time = (1:750)/25;
% plot(time, timetrace)
% hold on
% plot(time,TF/30)
%
% xform_jrgeco1aCorr_GSR_mice_NoGSR = reshape(xform_jrgeco1aCorr_GSR_mice_NoGSR,128,128,[]);
% peakMap_localMax = mean(xform_jrgeco1aCorr_GSR_mice_NoGSR(:,:,TF),3);
% figure
% imagesc(peakMap_localMax,[-0.03 0.03])
% colormap jet




