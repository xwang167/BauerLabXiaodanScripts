clear all;close all;clc
excelFile = 'X:\Paper\PaperExperiment.xlsx';
excelRows = 12:16;
runs = 1:3;
load('X:\Paper\WT\RGECO Emission\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-stim_processed_mice.mat', 'ROI')
FAD_Mice =  nan(750,5);
mouseNames = cell(1,5);
%% plot each run, No GSR
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    systemType = excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    
    colors = {'r-','g-','b-'};
    temp_mouse = nan(750,3);
    figure
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr')
        xform_FADCorr = reshape(xform_FADCorr,128*128,750,10);
        baseline = mean(xform_FADCorr(:,1:125,:),2);
        baseline = repmat(baseline,1,750,1);
        FAD = xform_FADCorr-baseline;
        clear xform_FADCorr
        FAD = mean(FAD,3);
        FAD = mean(FAD(ROI,:));
        temp_mouse(:,n) = FAD;
        plot((1:750)/25,FAD*100,colors{n})
        hold on
    end
    legend('Run 1','Run 2','Run 3')
    title([mouseName,' Corrected FAD No GSR'])
    xlabel('Time(s)')
    ylabel('\DeltaF/F%')
    FAD_Mice(:,ll) = mean(temp_mouse,2);
    mouseNames{ll} = mouseName;
    ll = ll+1;
end

%% Plot Each Mouse, No GSR
figure
for ii = 1:5
    plot((1:750)/25,FAD_Mice(:,ii)*100);
    hold on
end
xlabel('Time(s)')
ylabel('\DeltaF/F%')
legend(mouseNames)
title('Corrected FAD NO GSR')
%% plot each run, GSR
FAD_Mice_GSR =  nan(750,5);
mouseNames = cell(1,5);
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    systemType = excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    
    colors = {'r-','g-','b-'};
    temp_mouse = nan(750,3);
    figure
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr_GSR')
        xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128*128,750,10);
        baseline = mean(xform_FADCorr_GSR(:,1:125,:),2);
        baseline = repmat(baseline,1,750,1);
        FAD = xform_FADCorr_GSR-baseline;
        clear xform_FADCorr_GSR
        FAD = mean(FAD,3);
        FAD = mean(FAD(ROI,:));
        temp_mouse(:,n) = FAD;
        plot((1:750)/25,FAD*100,colors{n})
        hold on
    end
    legend('Run 1','Run 2','Run 3')
    title([mouseName,' Corrected FAD with GSR'])
    xlabel('Time(s)')
    ylabel('\DeltaF/F%')
    FAD_Mice_GSR(:,ll) = mean(temp_mouse,2);
    mouseNames{ll} = mouseName;
    ll = ll+1;
end

%% Plot Each Mouse, No GSR
figure
for ii = 1:5
    plot((1:750)/25,FAD_Mice_GSR (:,ii)*100);
    hold on
end
xlabel('Time(s)')
ylabel('\DeltaF/F%')
legend(mouseNames)

title('Corrected FAD with GSR')

%% Compare WT and RGECO
FAD_WT_NoGSR = mean(FAD_Mice,2);
FAD_WT_GSR = mean(FAD_Mice_GSR,2);
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_FADCorr_mice_GSR','xform_FADCorr_mice_NoGSR','ROI_GSR')

xform_FADCorr_mice_GSR = reshape(xform_FADCorr_mice_GSR,128*128,[]);
xform_FADCorr_mice_NoGSR = reshape(xform_FADCorr_mice_NoGSR,128*128,[]);

FAD_RGECO_GSR = mean(xform_FADCorr_mice_GSR(ROI_GSR(:),:));
FAD_RGECO_NoGSR = mean(xform_FADCorr_mice_NoGSR(ROI_GSR(:),:));

figure
plot((1:750)/25,FAD_WT_NoGSR*100,'k-')
hold on
plot((1:750)/25,FAD_RGECO_NoGSR*100,'m-')
legend('WT','RGECO')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Corrected FAD without GSR')

figure
plot((1:750)/25,FAD_WT_GSR*100,'k-')
hold on
plot((1:750)/25,FAD_RGECO_GSR*100,'m-')
legend('WT','RGECO')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Corrected FAD with GSR')
%% W30M1 W30M2 individual blocks
%% W30M3 W31M1 W31M2 individual blocks
excelRows = [12,15,16];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    systemType = excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr_GSR')
        xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128*128,750,10);
        baseline = mean(xform_FADCorr_GSR(:,1:125,:),2);
        baseline = repmat(baseline,1,750,1);
        FAD = xform_FADCorr_GSR-baseline;
        clear xform_FADCorr_GSR
        FAD = squeeze(mean(FAD(ROI,:,:)));
      for ii = 1:10
        figure('units','normalized','outerposition',[0 0 1 0.5]);     
        xline(5.04,'g-','Alpha',0.3)
        hold on
        plot((1:750)/25,FAD(:,ii)*100,'k-')
        xlabel('Time(s)')
        ylabel('\DeltaF/F%')
        title([strcat(mouseName,' run #',num2str(n)),strcat(' block #',num2str(ii))])
        saveas(gcf,strcat('X:\Paper\WT\RGECO Emission\GSR_NoBigInitialPeak\',mouseName,'-stim',num2str(n),'-block',num2str(ii),'-GSR.fig'))
        saveas(gcf,strcat('X:\Paper\WT\RGECO Emission\GSR_NoBigInitialPeak\',mouseName,'-stim',num2str(n),'-block',num2str(ii),'-GSR.png'))
        close all
      end
    end
end
