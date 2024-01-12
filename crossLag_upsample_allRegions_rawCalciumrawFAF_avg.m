clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
freq_new = 250;
t_kernel = 30;
t = (0:t_kernel*freq_new-1)/freq_new ;

load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

% Overlapped brain mask
xform_isbrain_mice = 1;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    disp(strcat(mouseName,', run #1'))
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end   
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
end
% Region inside of mouse brain

mask = AtlasSeeds.*xform_isbrain_mice;
mask(isnan(mask)) = 0;
% total number of pixels in all interested regions
pixelNum = zeros(1,50);
for region = 1:50
    mask_region = zeros(128,128);
    mask_region(mask == region) = 1;
    pixelNum(region) = sum(mask_region,'all');
end
pixelNumTotal = sum(pixelNum);

% total number of pixels in all interested regions
pixelNum = zeros(1,50);
for region = 1:50
    mask_region = zeros(128,128);
    mask_region(mask == region) = 1;
    pixelNum(region) = sum(mask_region,'all');
end

% Average cross correlation
excelRows_awake = [181 183 185 228 232 236];
excelRows_anes  = [202 195 204 230 234 240];

%% Calculate Cross lag for the whole brain
%% Concatinate the matrix
for condition = {'awake','anes'}
    mouseInd =1;
    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        eval(strcat('crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions = [];'))
        for n = 1:3
            disp(strcat(mouseName,', run #',num2str(n)))
            load(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC_rawCalciumrawFAF.mat')),'crossLagY_NMC_rawCalciumrawFAF')
            % catMRF
            eval(strcat( 'crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions = cat(1,crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions,crossLagY_NMC_rawCalciumrawFAF);'))   
        end
        eval(strcat('crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions = nanmedian(crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions);'))
        eval(strcat('crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},'_allRegions(mouseInd,:,:) = crossLagY_NMC_rawCalciumrawFAF_mouse_',condition{1},'_allRegions;'))
        mouseInd = mouseInd+1;
    end
end

%% Averaged cross lag for each mouse, then averaged across mice

for condition = {'awake','anes'}
    mouseInd =1;
    % Initialization
    eval(strcat('crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},'=zeros(6,5001);'))

    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        % initialization
        disp([condition])
        for region = 1:50
            %Weight crossLagY based on the number of pixels inside of
            % reigonal mask.
            eval(strcat('temp = squeeze(crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},'_allRegions(mouseInd,:,region))*pixelNum(region)/pixelNumTotal;'))
            eval(strcat('crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},'(mouseInd,:)= crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},'(mouseInd,:)+temp;'))
            clear temp
        end
        mouseInd = mouseInd+1;
    end
end

load(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF',strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC_rawCalciumrawFAF.mat')),'crossLagX_NMC_rawCalciumrawFAF')
save('E:\RGECO\cat\crossLag_allRegions_rawCalciumrawFAF.mat','crossLagX_NMC_rawCalciumrawFAF','crossLagY_NMC_rawCalciumrawFAF_mice_awake','crossLagY_NMC_rawCalciumrawFAF_mice_anes')
%% Visualization
load("GoodWL.mat")
mask(isnan(mask)) = 0;
ii = 1;   
figure('units','normalized','outerposition',[0 0 1 1])
for condition = {'awake','anes'}
    subplot(1,2,ii)
    eval(strcat('plot_distribution_prctile(crossLagX_NMC_rawCalciumrawFAF(1,:,1),crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},',',char(39),'Color',char(39),',[1 0 0])'))
    title(condition)
    xlabel('Time(s)')
    set(gca,'FontSize',14,'FontWeight','Bold')
    grid on
    ii = ii+1;
end
sgtitle('Between corrected jRGECO1a and raw FAF')
%%visualization to compare
load('E:\RGECO\cat\crossLag_allRegions.mat',...
    'crossLagY_NMC_mice_awake','crossLagY_NMC_mice_anes',...
    'crossLagY_NVC_mice_awake','crossLagY_NVC_mice_anes')
ii = 1;   
figure('units','normalized','outerposition',[0 0 1 1])
for condition = {'awake','anes'}
    subplot(1,2,ii)
    eval(strcat('plot_distribution_prctile(crossLagX_NMC_rawCalciumrawFAF(1,:,1),crossLagY_NMC_rawCalciumrawFAF_mice_',condition{1},',',char(39),'Color',char(39),',[1 0 0])'))
    hold on 
    eval(strcat('plot_distribution_prctile(crossLagX_NMC_rawCalciumrawFAF(1,:,1),crossLagY_NMC_mice_',condition{1},',',char(39),'Color',char(39),',[0 0 1])'))
    hold on
    eval(strcat('plot_distribution_prctile(crossLagX_NMC_rawCalciumrawFAF(1,:,1),crossLagY_NVC_mice_',condition{1},',',char(39),'Color',char(39),',[0 0 0])'))
    title(condition)
    xlabel('Time(s)')
    xlim([-10 10])
    set(gca,'FontSize',14,'FontWeight','Bold')
    grid on
    ii = ii+1;
end




