close all;clearvars;clc
excelFile = "X:\Paper1\WT_Paper1\WT_Paper1.xlsx";
excelRows = [3,7,11,15,19,23];%:450;
catDir = 'X:\Paper1\WT_Paper1\cat';
% excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
% excelRows = [182 184 186 229 233 237];
% catDir = 'E:\RGECO\cat' ;
runs = 1:3;
numMice = length(excelRows);
miceName = [];
xform_FAD_mice_NoGSR = [];
for excelRow = excelRows 
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);   
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
   % saveDir_corrected = fullfile('X:\XW\FilteredSpectra\FilteredEmissionFilteredExcitation\WT',recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');    
    disp('loading  Non GRS data')    
    load(fullfile(saveDir,processedName_mouse),'xform_FAD_mouse_NoGSR')
    xform_FAD_mice_NoGSR = cat(4,xform_FAD_mice_NoGSR,xform_FAD_mouse_NoGSR);
    clear xform_FAD_mouse_NoGSR
    %
    
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
xform_FAD_mice_NoGSR = mean(xform_FAD_mice_NoGSR,4);
save(fullfile(catDir,processedName_mice),'xform_FAD_mice_NoGSR','-append')

%% Visualization
load('X:\Paper1\WT_Paper1\cat\230104--M10M1-M10M749-M10M750-M10M760-M11M751-M10M761-stim_processed_mice.mat',...
    'xform_FADCorr_mice_NoGSR', 'ROI_NoGSR', 'xform_FAD_mice_NoGSR')

xform_FADCorr_mice_NoGSR = reshape(xform_FADCorr_mice_NoGSR,128*128,[]);
xform_FAD_mice_NoGSR = reshape(xform_FAD_mice_NoGSR,128*128,[]);

FADCorr_WT = mean(xform_FADCorr_mice_NoGSR(ROI_NoGSR(:),:));
FAD_WT = mean(xform_FAD_mice_NoGSR(ROI_NoGSR(:),:));


load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'ROI_NoGSR', 'xform_FADCorr_mice_NoGSR', 'xform_FAD_mice_NoGSR')

xform_FADCorr_mice_NoGSR = reshape(xform_FADCorr_mice_NoGSR,128*128,[]);
xform_FAD_mice_NoGSR = reshape(xform_FAD_mice_NoGSR,128*128,[]);

FADCorr_RGECO = mean(xform_FADCorr_mice_NoGSR(ROI_NoGSR(:),:));
FAD_RGECO = mean(xform_FAD_mice_NoGSR(ROI_NoGSR(:),:));

figure
plot((1:750)/25,FADCorr_RGECO*100,'r')
hold on
plot((1:750)/25,FADCorr_WT*100,'k')
hold on
plot((1:750)/25,(FAD_RGECO-mean(FAD_RGECO(1:125)))*100,'m')
hold on
plot((1:750)/25,(FAD_WT-mean(FAD_WT(1:125)))*100,'b')
legend('Corrected FAD in Thy1-jRGECO1a mice','Corrected FAD in WT mice','Raw FAD in Thy1-jRGECO1a mice','Raw FAD in WT mice')
