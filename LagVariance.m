
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
excelRows = [181,183,185,228,232,236];%321:327;
lagTimeTrial_HbTCalcium_variance_awake = NaN(128,128,18);
lagTimeTrial_FADCalcium_variance_awake = NaN(128,128,18);
lagTimeTrial_HbTFAD_variance_awake = NaN(128,128,18);

lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake = NaN(128,128,18);
lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake = NaN(128,128,18);
lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake = NaN(128,128,18);
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'lagTimeTrial_HbTCalcium','lagTimeTrial_FADCalcium','lagTimeTrial_HbTFAD',...
            'lagTimeTrial_GSR_0p02_2_HbTCalcium','lagTimeTrial_GSR_0p02_2_FADCalcium','lagTimeTrial_GSR_0p02_2_HbTFAD')
        lagTimeTrial_HbTCalcium_variance_awake(:,:,ll) = lagTimeTrial_HbTCalcium;
        lagTimeTrial_FADCalcium_variance_awake(:,:,ll) = lagTimeTrial_FADCalcium;
        lagTimeTrial_HbTFAD_variance_awake(:,:,ll) = lagTimeTrial_HbTFAD;
        
        lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake(:,:,ll) = lagTimeTrial_GSR_0p02_2_HbTCalcium;
        lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake(:,:,ll) = lagTimeTrial_GSR_0p02_2_FADCalcium;
        lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake(:,:,ll) = lagTimeTrial_GSR_0p02_2_HbTFAD;
        ll = ll+1;
    end
    
    
end


lagTimeTrial_HbTCalcium_variance_awake = var(lagTimeTrial_HbTCalcium_variance_awake,0,3,'omitnan');
lagTimeTrial_FADCalcium_variance_awake = var(lagTimeTrial_FADCalcium_variance_awake,0,3,'omitnan');
lagTimeTrial_HbTFAD_variance_awake = var(lagTimeTrial_HbTFAD_variance_awake,0,3,'omitnan');

lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake = var(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake,0,3,'omitnan');
lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake = var(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake,0,3,'omitnan');
lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake = var(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake,0,3,'omitnan');

figure;
subplot(1,3,1);imagesc(lagTimeTrial_HbTCalcium_variance_awake,[0 0.2]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_FADCalcium_variance_awake,[0 0.04]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_HbTFAD_variance_awake,[0 0.1]);axis image off;colorbar;colormap jet;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);title('HbT FAD')
suptitle('Awake No GSR Variance')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake,[0 0.1]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake,[0 0.05]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake,[0 0.2]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT FAD')
suptitle('Awake GSR Variance')

save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat',...
'lagTimeTrial_HbTCalcium_variance_awake','lagTimeTrial_FADCalcium_variance_awake','lagTimeTrial_HbTFAD_variance_awake',...
'lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake','lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake',...
'lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake','-append')



excelRows = [195 202 204 230 234 240];
lagTimeTrial_HbTCalcium_variance_anes = NaN(128,128,18);
lagTimeTrial_FADCalcium_variance_anes = NaN(128,128,18);
lagTimeTrial_HbTFAD_variance_anes = NaN(128,128,18);

lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes = NaN(128,128,18);
lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes = NaN(128,128,18);
lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes = NaN(128,128,18);
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'lagTimeTrial_HbTCalcium','lagTimeTrial_FADCalcium','lagTimeTrial_HbTFAD',...
            'lagTimeTrial_GSR_0p02_2_HbTCalcium','lagTimeTrial_GSR_0p02_2_FADCalcium','lagTimeTrial_GSR_0p02_2_HbTFAD')
        lagTimeTrial_HbTCalcium_variance_anes(:,:,ll) = lagTimeTrial_HbTCalcium;
        lagTimeTrial_FADCalcium_variance_anes(:,:,ll) = lagTimeTrial_FADCalcium;
        lagTimeTrial_HbTFAD_variance_anes(:,:,ll) = lagTimeTrial_HbTFAD;
        
        lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes(:,:,ll) = lagTimeTrial_GSR_0p02_2_HbTCalcium;
        lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes(:,:,ll) = lagTimeTrial_GSR_0p02_2_FADCalcium;
        lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes(:,:,ll) = lagTimeTrial_GSR_0p02_2_HbTFAD;
        ll = ll+1;
    end
    
    
end


lagTimeTrial_HbTCalcium_variance_anes = var(lagTimeTrial_HbTCalcium_variance_anes,0,3,'omitnan');
lagTimeTrial_FADCalcium_variance_anes = var(lagTimeTrial_FADCalcium_variance_anes,0,3,'omitnan');
lagTimeTrial_HbTFAD_variance_anes = var(lagTimeTrial_HbTFAD_variance_anes,0,3,'omitnan');

lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes = var(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes,0,3,'omitnan');
lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes = var(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes,0,3,'omitnan');
lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes = var(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes,0,3,'omitnan');

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
figure;
subplot(1,3,1);imagesc(lagTimeTrial_HbTCalcium_variance_anes,[0 0.2]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_FADCalcium_variance_anes,[0 0.0008]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_HbTFAD_variance_anes,[0 1.2]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT FAD')
suptitle('anes No GSR Variance')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes,[0 0.2]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes,[0 0.02]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colorbar;colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes,[0 0.2]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);;colorbar;colormap jet;title('HbT FAD')
suptitle('anes GSR Variance')

save('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat',...
'lagTimeTrial_HbTCalcium_variance_anes','lagTimeTrial_FADCalcium_variance_anes','lagTimeTrial_HbTFAD_variance_anes',...
'lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes','lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes',...
'lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes','-append')

nanmean(nanmean(lagTimeTrial_HbTCalcium_variance_anes(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_FADCalcium_variance_anes(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_HbTFAD_variance_anes(logical(mask_new)),1),1)

nanmean(nanmean(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes(logical(mask_new)),1),1)

nanmean(nanmean(lagTimeTrial_HbTCalcium_variance_awake(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_FADCalcium_variance_awake(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_HbTFAD_variance_awake(logical(mask_new)),1),1)

nanmean(nanmean(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake(logical(mask_new)),1),1)
nanmean(nanmean(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake(logical(mask_new)),1),1)


 load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_HbTCalcium_mice_mean')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_HbTFAD_mice_mean')
load('191030--R5M2285-R5M2286-R288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_FADCalcium_mice_mean')
lagTimeTrial_HbTCalcium_mice_CNR = lagTimeTrial_HbTCalcium_mice_mean./sqrt(lagTimeTrial_HbTCalcium_variance_awake);
lagTimeTrial_HbTFAD_mice_CNR = lagTimeTrial_HbTFAD_mice_mean./sqrt(lagTimeTrial_HbTFAD_variance_awake);
lagTimeTrial_FADCalcium_mice_CNR = lagTimeTrial_FADCalcium_mice_mean./sqrt(lagTimeTrial_FADCalcium_variance_awake);

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR = lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_awake);
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR = lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_awake);
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR = lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_awake);

save('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat','lagTimeTrial_HbTCalcium_mice_CNR','lagTimeTrial_HbTFAD_mice_CNR',...
   'lagTimeTrial_FADCalcium_mice_CNR', 'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR','lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR','lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR','-append')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_HbTCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_FADCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_HbTFAD_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT FAD')
suptitle('awake No GSR CNR')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR,[0 5]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colorbar;colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR,[0 5]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colorbar;colormap jet;title('HbT FAD')
suptitle('awake GSR CNR')

load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean')
load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean')
load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean')
load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_HbTCalcium_mice_mean')
load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_HbTFAD_mice_mean')
load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'lagTimeTrial_FADCalcium_mice_mean')

load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat',...
'lagTimeTrial_HbTCalcium_variance_anes','lagTimeTrial_FADCalcium_variance_anes','lagTimeTrial_HbTFAD_variance_anes',...
'lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes','lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes',...
'lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes')
lagTimeTrial_HbTCalcium_mice_CNR = lagTimeTrial_HbTCalcium_mice_mean./sqrt(lagTimeTrial_HbTCalcium_variance_anes);
lagTimeTrial_HbTFAD_mice_CNR = lagTimeTrial_HbTFAD_mice_mean./sqrt(lagTimeTrial_HbTFAD_variance_anes);
lagTimeTrial_FADCalcium_mice_CNR = lagTimeTrial_FADCalcium_mice_mean./sqrt(lagTimeTrial_FADCalcium_variance_anes);

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR = lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_HbTCalcium_variance_anes);
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR = lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_HbTFAD_variance_anes);
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR = lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean./sqrt(lagTimeTrial_GSR_0p02_2_FADCalcium_variance_anes);

save('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat','lagTimeTrial_HbTCalcium_mice_CNR','lagTimeTrial_HbTFAD_mice_CNR',...
   'lagTimeTrial_FADCalcium_mice_CNR', 'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR','lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR','lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR','-append')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_HbTCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_FADCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_HbTFAD_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT FAD')
suptitle('anes No GSR CNR')

figure;
subplot(1,3,1);imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_CNR,[0 5]);axis image off;colorbar;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colormap jet;title('HbT Calcium')
subplot(1,3,2);imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_CNR,[0 5]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colorbar;colormap jet;title('FAD Calcium')
subplot(1,3,3);imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_CNR,[0 5]);axis image off;hold on;imagesc(xform_WL,'AlphaData',1-mask_new);colorbar;colormap jet;title('HbT FAD')
suptitle('anes GSR CNR')
