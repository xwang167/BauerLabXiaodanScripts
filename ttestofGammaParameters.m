NVC_awake_T = nan(1,6);
NVC_awake_W = nan(1,6);
NVC_awake_r = nan(1,6);

NMC_awake_T = nan(1,6);
NMC_awake_W = nan(1,6);
NMC_awake_r = nan(1,6);

NVC_anes_T = nan(1,6);
NVC_anes_W = nan(1,6);
NVC_anes_r = nan(1,6);

NMC_anes_T = nan(1,6);
NMC_anes_W = nan(1,6);
NMC_anes_r = nan(1,6);

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows_awake = [181 183 185 228  232  236 ];
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
ii=1;
for excelRow=excelRows_awake
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = logical(mask_new.*xform_isbrain);
    processedName_CalciumHbT_2min_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat'));
    load(processedName_CalciumHbT_2min_median_mouse,...
        'T_CalciumHbT_2min_median_mouse','T_CalciumFAD_2min_median_mouse',...
    'W_CalciumHbT_2min_median_mouse','W_CalciumFAD_2min_median_mouse',...
        'r_CalciumHbT_2min_median_mouse','r_CalciumFAD_2min_median_mouse')
    NVC_awake_T(ii) = nanmedian(T_CalciumHbT_2min_median_mouse(mask));
    NVC_awake_W(ii) = nanmedian(W_CalciumHbT_2min_median_mouse(mask));
    NVC_awake_r(ii) = nanmedian(r_CalciumHbT_2min_median_mouse(mask));
    
    NMC_awake_T(ii) = nanmedian(T_CalciumFAD_2min_median_mouse(mask));
    NMC_awake_W(ii) = nanmedian(W_CalciumFAD_2min_median_mouse(mask));
    NMC_awake_r(ii) = nanmedian(r_CalciumFAD_2min_median_mouse(mask));
    
    ii = ii+1;
    
end



excelRows_anes = [ 202 195 204 230 234 240];
ii=1;
for excelRow=excelRows_anes
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = logical(mask_new.*xform_isbrain);
    processedName_CalciumHbT_2min_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat'));
    load(processedName_CalciumHbT_2min_median_mouse,...
        'T_CalciumHbT_2min_median_mouse','T_CalciumFAD_2min_median_mouse',...
    'W_CalciumHbT_2min_median_mouse','W_CalciumFAD_2min_median_mouse',...
        'r_CalciumHbT_2min_median_mouse','r_CalciumFAD_2min_median_mouse')
    NVC_anes_T(ii) = nanmedian(T_CalciumHbT_2min_median_mouse(mask));
    NVC_anes_W(ii) = nanmedian(W_CalciumHbT_2min_median_mouse(mask));
    NVC_anes_r(ii) = nanmedian(r_CalciumHbT_2min_median_mouse(mask));
    
    NMC_anes_T(ii) = nanmedian(T_CalciumFAD_2min_median_mouse(mask));
    NMC_anes_W(ii) = nanmedian(W_CalciumFAD_2min_median_mouse(mask));
    NMC_anes_r(ii) = nanmedian(r_CalciumFAD_2min_median_mouse(mask));
    
    ii = ii+1;
    
end


[h_NVC_T, p_NVC_T] = ttest2(NVC_awake_T, NVC_anes_T, 0.05, 'both', 'unequal');
[h_NVC_W, p_NVC_W] = ttest2(NVC_awake_W, NVC_anes_W, 0.05, 'both', 'unequal');
[h_NVC_r, p_NVC_r] = ttest2(NVC_awake_r, NVC_anes_r, 0.05, 'both', 'unequal');

[h_NMC_T, p_NMC_T] = ttest2(NMC_awake_T, NMC_anes_T, 0.05, 'both', 'unequal');
[h_NMC_W, p_NMC_W] = ttest2(NMC_awake_W, NMC_anes_W, 0.05, 'both', 'unequal');
[h_NMC_r, p_NMC_r] = ttest2(NMC_awake_r, NMC_anes_r, 0.05, 'both', 'unequal');
