close all;clear all;clc
import mouse.*
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
runs =1:3;
xform_isbrain_mice = 1;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
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

%%
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};

    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        disp('loading raw data')
        tmp=matfile(fullfile(saveDir, rawName));  
        raw_FAD=squeeze(tmp.rawdata(:,:,1,:));
        if length(raw_FAD)>15000
            dark_FAD = squeeze(mean(raw_FAD(:,:,1:sessionInfo.darkFrameNum/4),3));
            dark_FAD = repmat(dark_FAD,1,1,length(raw_FAD));
            raw_FAD = raw_FAD-dark_FAD;
            raw_FAD(:,:,1:sessionInfo.darkFrameNum/4) = [];
        end
        
        raw_Calcium=squeeze(tmp.rawdata(:,:,2,:));
        if length(raw_Calcium)>15000
            dark_Calcium = squeeze(mean(raw_Calcium(:,:,1:sessionInfo.darkFrameNum/4),3));
            dark_Calcium = repmat(dark_Calcium,1,1,length(raw_Calcium));
            raw_Calcium = raw_Calcium-dark_Calcium;
            raw_Calcium(:,:,1:sessionInfo.darkFrameNum/4) = [];
        end

        raw_FAD = median(raw_FAD,3);
        raw_Calcium = median(raw_Calcium,3);
        save(fullfile(saveDir, rawName),'raw_FAD','raw_Calcium','-append')
    end
    close all
end

%% mouse average
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    rawName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_raw','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_raw');
    powerdata_average_FAD_mouse = [];
    powerdata_FAD_mouse = [];
    raw_FAD_mouse     = nan(128,128,3);
    raw_Calcium_mouse = nan(128,128,3);
    for n = runs
        disp('loading raw data')
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir, rawName),'raw_FAD','raw_Calcium')
        raw_FAD_mouse(:,:,n)     = raw_FAD;
        raw_Calcium_mouse(:,:,n) = raw_Calcium;
    end
    raw_FAD_mouse = median(raw_FAD_mouse,3);
    raw_Calcium_mouse = median(raw_Calcium_mouse,3);

    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers')
    end
    xform_raw_FAD_mouse = affineTransform(raw_FAD_mouse,affineMarkers);
    xform_raw_Calcium_mouse = affineTransform(raw_Calcium_mouse,affineMarkers);
    save(fullfile(saveDir, rawName_mouse),'xform_raw_FAD_mouse','xform_raw_Calcium_mouse','-append')
end
%% mouse visualization
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.mouseType = excelRaw{17};
    rawName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_raw','.mat');
    load(fullfile(saveDir, rawName_mouse),'xform_raw_FAD_mouse','xform_raw_Calcium_mouse')
    figure
    subplot(1,2,1)
    imagesc(xform_raw_FAD_mouse)
    colorbar
    axis image off
    title('FAD baseline')
    colorbar
    subplot(1,2,2)
    imagesc(xform_raw_Calcium_mouse)
    colorbar
    axis image off
    title('Calcium baseline')   
    sgtitle(mouseName)
    colorbar
end

%% mice average
%excelRows = [202 195 204 230 234 240];
excelRows = [181 183 185 228 232 236];
saveDir_cat = "E:\RGECO\cat\";
set(0,'defaultaxesfontsize',12);
info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
xform_isbrain_mice = 1;
xform_raw_FAD_mice     = nan(128,128,6);
xform_raw_Calcium_mice = nan(128,128,6);
ll = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    rawName = strcat(recDate,'-',mouseName,'-',sessionType,'_raw.mat');
    load(fullfile(saveDir, rawName),'xform_raw_FAD_mouse','xform_raw_Calcium_mouse')
    xform_raw_FAD_mice(:,:,ll)     = xform_raw_FAD_mouse;
    xform_raw_Calcium_mice(:,:,ll) = xform_raw_Calcium_mouse;
    ll = ll+1;
end
xform_raw_FAD_mice = median(xform_raw_FAD_mice,3);
xform_raw_Calcium_mice = median(xform_raw_Calcium_mice,3);
rawName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_raw.mat');
save(fullfile(saveDir_cat, rawName_mice),'xform_raw_FAD_mice','xform_raw_Calcium_mice')

%% visualization
load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')
load("GoodWL.mat")
mask = AtlasSeeds.*xform_isbrain_mice;
mask(isnan(mask)) = 0;
% Exclude FRP an PL
mask(mask==1)  = 0;
mask(mask==2)  = 0;
mask(mask==5)  = 0;
mask(mask==26) = 0;
mask(mask==27) = 0;
mask(mask==30) = 0;
mask(mask>1) = 1;

load("E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_raw.mat")
raw_FAD_mice_awake     = xform_raw_FAD_mice;
raw_Calcium_mice_awake = xform_raw_Calcium_mice;

load("E:\RGECO\cat\191030--R5M2285-anes-R5M2286-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_raw.mat")
raw_FAD_mice_anes     = xform_raw_FAD_mice;
raw_Calcium_mice_anes = xform_raw_Calcium_mice;
figure
subplot(2,2,1)
imagesc(raw_Calcium_mice_awake,[0 80000])
colorbar
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
title('Calcium Awake')
subplot(2,2,2)
imagesc(raw_FAD_mice_awake,[0 95000])
colorbar
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
title('FAF awake')

subplot(2,2,3)
imagesc(raw_Calcium_mice_anes,[0 80000])
colorbar
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
title('Calcium Anesthetized')
subplot(2,2,4)
imagesc(raw_FAD_mice_anes,[0 95000])
colorbar
hold on
imagesc(xform_WL,'AlphaData',1-mask);
axis image off
colormap(brewermap(256, '-Spectral'))
title('FAF Anesthetized')


%% Regional difference
load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')
% median
% table of comparison between M SS P V RS A

mask = AtlasSeeds.*xform_isbrain_mice;
mask(isnan(mask)) = 0;
% Exclude FRP an PL
mask(mask==1)  = 0;
mask(mask==2)  = 0;
mask(mask==5)  = 0;
mask(mask==26) = 0;
mask(mask==27) = 0;
mask(mask==30) = 0;

mask_region_ind = cell(1,6);
mask_region_ind{1} = [3,4,28,29];
mask_region_ind{2} = [6:13,31:38];
mask_region_ind{3} = [14,19,20,39,44,45];
mask_region_ind{4} = [15:18,40:43];
mask_region_ind{5} = [21:23,46:48];
mask_region_ind{6} = [24,25,49,50];

mask_combined = zeros(128*128,6);
mask_combined(ismember(mask,mask_region_ind{1}),1) = 1; % motor
mask_combined(ismember(mask,mask_region_ind{2}),2) = 1; % Somatosensory
mask_combined(ismember(mask,mask_region_ind{3}),3) = 1; % Parietal
mask_combined(ismember(mask,mask_region_ind{4}),4) = 1; % Visual
mask_combined(ismember(mask,mask_region_ind{5}),5) = 1; % Retrosplenial
mask_combined(ismember(mask,mask_region_ind{6}),6) = 1; % Auditory
mask_combined = logical(reshape(mask_combined,128,128,6));

excelRows_awake = [181 183 185 228 232 236];
excelRows_anes = [202 195 204 230 234 240];
% Calculate T W A r for each mouse for each combined region
for contrast = {'FAD','Calcium'}
    for condition = {'awake','anes'}
        eval(strcat('raw_',contrast{1},'_',condition{1},'_combined = nan(6,6);'))% mouse*combined region
        eval(strcat('raw_',contrast{1},'_',condition{1},'_brain = nan(6,1);'))% mouse*combined region
        mouseInd = 1;
        for mouseInd = 1:6
            eval(strcat('excelRow = excelRows_',condition{1},'(mouseInd);'))
            [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
            recDate = excelRaw{1}; recDate = string(recDate);
            mouseName = excelRaw{2}; mouseName = string(mouseName);;
            saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
            sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,'_raw.mat');
            load(fullfile(saveDir, rawName),'xform_raw_FAD_mouse','xform_raw_Calcium_mouse')
            for ii = 1:6
                eval(strcat('raw_',contrast{1},'_',condition{1},'_combined(mouseInd,ii)', ...
                    '= mean(xform_raw_',contrast{1},'_mouse(squeeze(mask_combined(:,:,ii))));'))% mouse*combined region
            end
            eval(strcat('raw_',contrast{1},'_',condition{1},'_brain = mean(raw_',contrast{1},'_',condition{1},'_combined,2);'))% mouse*combined region
        end
    end
end


% Calculate h and p
for contrast = {'FAD','Calcium'}
    for condition = {'awake','anes'}
        eval(strcat('p_raw_',contrast{1},'_',condition{1},'_combined_brain = nan(6,1);'))
        eval(strcat('h_raw_',contrast{1},'_',condition{1},'_combined_brain = zeros(6,1);'))
        for ii = 1:6
            eval(strcat('[h_raw_',contrast{1},'_',condition{1},'_combined_brain(ii),',...
                'p_raw_',contrast{1},'_',condition{1},'_combined_brain(ii)] = ',...
                ' ttest(','raw_',contrast{1},'_',condition{1},'_combined(:,ii),',...
                'raw_',contrast{1},'_',condition{1},'_brain,',...
                char(39),'Tail',char(39),',',char(39),'both',char(39),');'))
        end

    end
end





