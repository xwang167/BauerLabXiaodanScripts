time_epoch=30;
t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

%% auc
excelRows = [181 183 185 228 232 236];
AUC_awake = zeros(1,6);
ii = 1;
miceName = [];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-', mouseName);
    miceName = char(miceName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    T = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    W = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    A = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    alpha = (T/W)^2*8*log(2);
    beta = W^2/(T*8*log(2));
    y = A*(t/T).^alpha.*exp((t-T)/(-beta));
    AUC_awake(ii) = trapz(t,y);
    ii = ii+1;
end



excelRows = [ 195 202 204 230 234 240];
AUC_anes = zeros(1,6);
ii = 1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-', mouseName);
    miceName = char(miceName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    T = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    W = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    A = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,'all');
    alpha = (T/W)^2*8*log(2);
    beta = W^2/(T*8*log(2));
    y = A*(t/T).^alpha.*exp((t-T)/(-beta));
    AUC_anes(ii) = trapz(t,y);
    ii = ii+1;
end



%% Bar plot

ML = (AtlasSeeds == 4) + (AtlasSeeds==5);
SSWbL = AtlasSeeds==9;
SSHeadL = AtlasSeeds==6;
VL = (AtlasSeeds == 16) + (AtlasSeeds==17) + (AtlasSeeds==18);
PL = (AtlasSeeds == 13) + (AtlasSeeds==14) + (AtlasSeeds==15);


MR = (AtlasSeeds == 24) + (AtlasSeeds==25);
SSWbR = AtlasSeeds==29;
SSHeadR = AtlasSeeds==26;
VR = (AtlasSeeds == 36) + (AtlasSeeds==37) + (AtlasSeeds==38);
PR = (AtlasSeeds == 33) + (AtlasSeeds==34) + (AtlasSeeds==35);

excelRows = [181 183 185 228 232 236];
ML_awake = zeros(1,6);
SSWbL_awake = zeros(1,6);
SSHeadL_awake = zeros(1,6);
VL_awake = zeros(1,6);
PL_awake = zeros(1,6);

MR_awake = zeros(1,6);
SSWbR_awake = zeros(1,6);
SSHeadR_awake = zeros(1,6);
VR_awake = zeros(1,6);
PR_awake = zeros(1,6);

ii = 1;
miceName = [];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-', mouseName);
    miceName = char(miceName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    
    ML_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*ML,'all');
    SSWbL_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSWbL,'all');
    SSHeadL_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSHeadL,'all');
    VL_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*VL,'all');
    PL_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*PL,'all');
    
    MR_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*MR,'all');
    SSWbR_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSWbR,'all');
    SSHeadR_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSHeadR,'all');
    VR_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*VR,'all');
    PR_awake(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*PR,'all');
    ii = ii+1;
end

data_awake = [mean(ML_awake),mean(SSHeadL_awake),mean(SSWbL_awake),mean(PL_awake),mean(VL_awake),...
    mean(MR_awake),mean(SSHeadR_awake),mean(SSWbR_awake),mean(PR_awake),mean(VR_awake)];
error_awake = [std(ML_awake),std(SSHeadL_awake),std(SSWbL_awake),std(PL_awake),std(VL_awake),...
    std(MR_awake),std(SSHeadR_awake),std(SSWbR_awake),std(PR_awake),std(VR_awake)];




excelRows = [ 195 202 204 230 234 240];
ML_anes = zeros(1,6);
SSWbL_anes = zeros(1,6);
SSHeadL_anes = zeros(1,6);
VL_anes = zeros(1,6);
PL_anes = zeros(1,6);

MR_anes = zeros(1,6);
SSWbR_anes = zeros(1,6);
SSHeadR_anes = zeros(1,6);
VR_anes = zeros(1,6);
PR_anes = zeros(1,6);

ii = 1;
miceName = [];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-', mouseName);
    miceName = char(miceName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    
    ML_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*ML,'all');
    SSWbL_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSWbL,'all');
    SSHeadL_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSHeadL,'all');
    VL_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*VL,'all');
    PL_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*PL,'all');
    
    MR_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*MR,'all');
    SSWbR_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSWbR,'all');
    SSHeadR_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*SSHeadR,'all');
    VR_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*VR,'all');
    PR_anes(ii) = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse.*PR,'all');
    ii = ii+1;
end
data_anes = [mean(ML_anes),mean(SSHeadL_anes),mean(SSWbL_anes),mean(PL_anes),mean(VL_anes),...
    mean(MR_anes),mean(SSHeadR_anes),mean(SSWbR_anes),mean(PR_anes),mean(VR_anes)];
error_anes = [std(ML_anes),std(SSHeadL_anes),std(SSWbL_anes),std(PL_anes),std(VL_anes),...
    std(MR_anes),std(SSHeadR_anes),std(SSWbR_anes),std(PR_anes),std(VR_anes)];

data = cat(1,data_awake,data_anes);
error = cat(1,error_awake,error_anes);

figure
hBar = bar(data);
hold on
for k1 = 1:size(data,2)
    ctr(k1,:) = bsxfun(@plus, hBar(k1).XData, hBar(k1).XOffset');   % Note: ‘XOffset’ Is An Undocumented Feature, This Selects The ‘bar’ Centres
    ydt(k1,:) = hBar(k1).YData;                                     % Individual Bar Heights
end
hold on
errorbar(ctr, ydt, error.', '.r')
PPx=categorical({'Awake','Anesthetized'});
mylegend = legend('ML','SSHeadL', 'SSWbL', 'PL','VL','MR','SSHeadR', 'SSWbR', 'PR','VR','location','northwest');
mylegend.NumColumns = 2;
ylim([0,0.2])
xticklabels({'Awake','Anesthetized'})
ylabel('T(s)')