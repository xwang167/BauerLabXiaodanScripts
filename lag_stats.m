%% RGECO Awake mice
excelFile = "X:\RGECO\DataBase_Xiaodan_5.xlsx";
excelRows =[181,183,185,228,232,236];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
saveDir_cat = 'D:\RGECO\cat';
lag_rgeco_awake = getLag(excelFile,excelRows,saveDir_cat);


%% RGECO Anes mice
excelFile = "X:\RGECO\DataBase_Xiaodan_5.xlsx";
excelRows =[202 195 204 230 234 240];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
saveDir_cat = 'D:\RGECO\cat';
lag_rgeco_anes = getLag(excelFile,excelRows,saveDir_cat);

%% WT Awake mice
excelFile = "X:\WT\WT.xlsx";
excelRows =[2,4,7,11,14];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
saveDir_cat = 'X:\WT\cat';
lag_WT1_awake = getLag(excelFile,excelRows,saveDir_cat);

%% WT Anes mice
excelFile = "X:\WT\WT.xlsx";
excelRows = [3,5,8,12,15]; %[195 202 204 181 183 185];
saveDir_cat = 'X:\WT\cat';
lag_WT1_anes = getLag(excelFile,excelRows,saveDir_cat);

%% WT Awake mice 2nd cohort
excelFile = "X:\WT_Paper1\WT_Paper1.xlsx";
excelRows =[2,6,10,14,18,22];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
saveDir_cat = 'X:\WT_Paper1\cat';
lag_WT2_awake = getLag(excelFile,excelRows,saveDir_cat);

%% WT Anes mice 2nd cohort
excelFile = "X:\WT_Paper1\WT_Paper1.xlsx";
excelRows = [4,8,12,16,20,22]; %[195 202 204 181 183 185];
saveDir_cat = 'X:\WT_Paper1\cat';
lag_WT2_anes = getLag(excelFile,excelRows,saveDir_cat);

%% stats
[h_rgeco_WT1_awake, p_rgeco_WT1_awake]= ttest2(lag_rgeco_awake,lag_WT1_awake, 0.05, 'both', 'unequal');
[h_rgeco_WT2_awake, p_rgeco_WT2_awake]= ttest2(lag_rgeco_awake,lag_WT2_awake, 0.05, 'both', 'unequal');
[h_WT1_WT2_awake,   p_WT1_WT2_awake]  = ttest2(lag_WT1_awake,lag_WT2_awake, 0.05, 'both', 'unequal');

[h_rgeco_WT1_anes, p_rgeco_WT1_anes]= ttest2(lag_rgeco_anes,lag_WT1_anes, 0.05, 'both', 'unequal');
[h_rgeco_WT2_anes, p_rgeco_WT2_anes]= ttest2(lag_rgeco_anes,lag_WT2_anes, 0.05, 'both', 'unequal');
[h_WT1_WT2_anes,   p_WT1_WT2_anes]  = ttest2(lag_WT1_anes,lag_WT2_anes, 0.05, 'both', 'unequal');


[h_ks_rgeco_WT1_awake, p_ks_rgeco_WT1_awake]= kstest2(lag_rgeco_awake,lag_WT1_awake);
[h_ks_rgeco_WT2_awake, p_ks_rgeco_WT2_awake]= kstest2(lag_rgeco_awake,lag_WT2_awake);
[h_ks_WT1_WT2_awake,   p_ks_WT1_WT2_awake]  = kstest2(lag_WT1_awake,lag_WT2_awake);

[h_ks_rgeco_WT1_anes, p_ks_rgeco_WT1_anes]= kstest2(lag_rgeco_anes,lag_WT1_anes);
[h_ks_rgeco_WT2_anes, p_ks_rgeco_WT2_anes]= kstest2(lag_rgeco_anes,lag_WT2_anes);
[h_ks_WT1_WT2_anes,   p_ks_WT1_WT2_anes]  = kstest2(lag_WT1_anes,lag_WT2_anes);

[p_mw_rgeco_WT1_awake, h_mw_rgeco_WT1_awake]= ranksum(lag_rgeco_awake,lag_WT1_awake);
[p_mw_rgeco_WT2_awake, h_mw_rgeco_WT2_awake]= ranksum(lag_rgeco_awake,lag_WT2_awake);
[p_mw_WT1_WT2_awake,   h_mw_WT1_WT2_awake]  = ranksum(lag_WT1_awake,lag_WT2_awake);

[p_mw_rgeco_WT1_anes, h_mw_rgeco_WT1_anes]= ranksum(lag_rgeco_anes,lag_WT1_anes);
[p_mw_rgeco_WT2_anes, h_mw_rgeco_WT2_anes]= ranksum(lag_rgeco_anes,lag_WT2_anes);
[p_mw_WT1_WT2_anes,   h_mw_WT1_WT2_anes]  = ranksum(lag_WT1_anes,lag_WT2_anes);

%% vis
compareContrasts = cell(1,3);
compareContrasts{1} = [lag_rgeco_awake',lag_rgeco_anes'];% pad mice with air with nan to match size
compareContrasts{2} = [lag_WT1_awake',lag_WT1_anes'];
compareContrasts{3} = [lag_WT2_awake',lag_WT2_anes'];
labels ={'Thy1-jRGECO1a','WT1','WT2'};
grpLabels = {'Awakes','Anesthetized'};
figure
boxplotGroup(compareContrasts,'Colors',[1 0 1; 0 0 0; 0 0 1],'GroupType','betweenGroups','SecondaryLabels',grpLabels,'interGroupSpace',2)
set(gca,'xtick',[])
ylabel('Lag(s)')
title('Lag Comparison')
hold on
h = zeros(3, 1);
h(1) = plot(NaN,NaN,'Color',[1,0,1],'LineWidth',2);
h(2) = plot(NaN,NaN,'Color',[0,0,0],'LineWidth',2);
h(3) = plot(NaN,NaN,'Color',[0 0 1],'LineWidth',2);
legend(h, 'Thy1-jRGECO1a','WT1','WT2','LineWidth',2,'location','northwest');

function lag_mice = getLag(excelFile,excelRows,saveDir_cat)
lag_mice = zeros(1,6);
miceName = [];
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRows(end)),':V',num2str(excelRows(end))]);
recDate = excelRaw{1};recDate = string(recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat');
load(fullfile(saveDir_cat,processedName_mice),'mask');

mouseInd =1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat');
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),'lagTimeTrial_FADHbT_2min_median_mouse');
    lagTimeTrial_FADHbT_2min_median_mouse = reshape(lagTimeTrial_FADHbT_2min_median_mouse,1,128*128);
    lag_mice(mouseInd) = median(lagTimeTrial_FADHbT_2min_median_mouse(logical(mask(:))));
    mouseInd = mouseInd +1;
end
end




