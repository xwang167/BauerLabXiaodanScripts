clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = mask_new;

%% 0.2 mice
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nan(128,128,length(runs));
    W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nan(128,128,length(runs));
    A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nan(128,128,length(runs));
    r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nan(128,128,length(runs));
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nan(128,128,length(runs));
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling','W_CalciumHbT_1min_smooth_Rolling','A_CalciumHbT_1min_smooth_Rolling','r_CalciumHbT_1min_smooth_Rolling','r2_CalciumHbT_1min_smooth_Rolling')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nan(128,128,5);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nan(128,128,5);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nan(128,128,5);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nan(128,128,5);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nan(128,128,5);
        for ii = 1:19
            mask_nan = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii)<0.2;
            
            tmp_T = T_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_T = reshape(tmp_T,128*128,1);
            tmp_T(mask_nan(:)) = nan;
            T_CalciumHbT_1min_smooth_Rolling_R2_0p2(:,:,ii) = reshape(tmp_T,128,128);
            
            tmp_W = W_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_W = reshape(tmp_W,128*128,1);
            tmp_W(mask_nan(:)) = nan;
            W_CalciumHbT_1min_smooth_Rolling_R2_0p2(:,:,ii) = reshape(tmp_W,128,128);
            
            tmp_A = A_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_A = reshape(tmp_A,128*128,1);
            tmp_A(mask_nan(:)) = nan;
            A_CalciumHbT_1min_smooth_Rolling_R2_0p2(:,:,ii) = reshape(tmp_A,128,128);
            
            tmp_r = r_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r = reshape(tmp_r,128*128,1);
            tmp_r(mask_nan(:)) = nan;
            r_CalciumHbT_1min_smooth_Rolling_R2_0p2(:,:,ii) = reshape(tmp_r,128,128);
            
            tmp_r2 = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r2 = reshape(tmp_r2,128*128,1);
            tmp_r2(mask_nan(:)) = nan;
            r2_CalciumHbT_1min_smooth_Rolling_R2_0p2(:,:,ii) = reshape(tmp_r2,128,128);
        end
        T_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2,3);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2,3);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2,3);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2,3);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p2 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2,3);
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_R2_0p2','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling_R2_0p2','W_CalciumHbT_1min_smooth_Rolling_R2_0p2',...
            'A_CalciumHbT_1min_smooth_Rolling_R2_0p2','r_CalciumHbT_1min_smooth_Rolling_R2_0p2','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse(:,:,n) = T_CalciumHbT_1min_smooth_Rolling_R2_0p2;
        W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse(:,:,n) = W_CalciumHbT_1min_smooth_Rolling_R2_0p2;
        A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse(:,:,n) = A_CalciumHbT_1min_smooth_Rolling_R2_0p2;
        r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse(:,:,n) = r_CalciumHbT_1min_smooth_Rolling_R2_0p2;
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse(:,:,n) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p2;
    end
    T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse,3);
    W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse,3);
    A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse,3);
    r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse,3);
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse,3);
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p2_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse')
end

excelRows = [181 183 185 228 232 236];
T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p2_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p2_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice')


excelRows = [ 195 202 204 230 234 240];
T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p2_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p2_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice')

%% 0.3 mice
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nan(128,128,length(runs));
    W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nan(128,128,length(runs));
    A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nan(128,128,length(runs));
    r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nan(128,128,length(runs));
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nan(128,128,length(runs));
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling','W_CalciumHbT_1min_smooth_Rolling','A_CalciumHbT_1min_smooth_Rolling','r_CalciumHbT_1min_smooth_Rolling','r2_CalciumHbT_1min_smooth_Rolling')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nan(128,128,5);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nan(128,128,5);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nan(128,128,5);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nan(128,128,5);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nan(128,128,5);
        for ii = 1:19
            mask_nan = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii)<0.3;
            
            tmp_T = T_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_T = reshape(tmp_T,128*128,1);
            tmp_T(mask_nan(:)) = nan;
            T_CalciumHbT_1min_smooth_Rolling_R2_0p3(:,:,ii) = reshape(tmp_T,128,128);
            
            tmp_W = W_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_W = reshape(tmp_W,128*128,1);
            tmp_W(mask_nan(:)) = nan;
            W_CalciumHbT_1min_smooth_Rolling_R2_0p3(:,:,ii) = reshape(tmp_W,128,128);
            
            tmp_A = A_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_A = reshape(tmp_A,128*128,1);
            tmp_A(mask_nan(:)) = nan;
            A_CalciumHbT_1min_smooth_Rolling_R2_0p3(:,:,ii) = reshape(tmp_A,128,128);
            
            tmp_r = r_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r = reshape(tmp_r,128*128,1);
            tmp_r(mask_nan(:)) = nan;
            r_CalciumHbT_1min_smooth_Rolling_R2_0p3(:,:,ii) = reshape(tmp_r,128,128);
            
            tmp_r2 = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r2 = reshape(tmp_r2,128*128,1);
            tmp_r2(mask_nan(:)) = nan;
            r2_CalciumHbT_1min_smooth_Rolling_R2_0p3(:,:,ii) = reshape(tmp_r2,128,128);
        end
        T_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3,3);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3,3);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3,3);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3,3);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p3 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3,3);
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_R2_0p3','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling_R2_0p3','W_CalciumHbT_1min_smooth_Rolling_R2_0p3',...
            'A_CalciumHbT_1min_smooth_Rolling_R2_0p3','r_CalciumHbT_1min_smooth_Rolling_R2_0p3','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse(:,:,n) = T_CalciumHbT_1min_smooth_Rolling_R2_0p3;
        W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse(:,:,n) = W_CalciumHbT_1min_smooth_Rolling_R2_0p3;
        A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse(:,:,n) = A_CalciumHbT_1min_smooth_Rolling_R2_0p3;
        r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse(:,:,n) = r_CalciumHbT_1min_smooth_Rolling_R2_0p3;
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse(:,:,n) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p3;
    end
    T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse,3);
    W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse,3);
    A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse,3);
    r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse,3);
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse,3);
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p3_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse')
end

excelRows = [181 183 185 228 232 236];
T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p3_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p3_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice')


excelRows = [ 195 202 204 230 234 240];
T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p3_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p3_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice')

%% 0.4 mice
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nan(128,128,length(runs));
    W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nan(128,128,length(runs));
    A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nan(128,128,length(runs));
    r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nan(128,128,length(runs));
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nan(128,128,length(runs));
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling','W_CalciumHbT_1min_smooth_Rolling','A_CalciumHbT_1min_smooth_Rolling','r_CalciumHbT_1min_smooth_Rolling','r2_CalciumHbT_1min_smooth_Rolling')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nan(128,128,5);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nan(128,128,5);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nan(128,128,5);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nan(128,128,5);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nan(128,128,5);
        for ii = 1:19
            mask_nan = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii)<0.4;
            
            tmp_T = T_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_T = reshape(tmp_T,128*128,1);
            tmp_T(mask_nan(:)) = nan;
            T_CalciumHbT_1min_smooth_Rolling_R2_0p4(:,:,ii) = reshape(tmp_T,128,128);
            
            tmp_W = W_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_W = reshape(tmp_W,128*128,1);
            tmp_W(mask_nan(:)) = nan;
            W_CalciumHbT_1min_smooth_Rolling_R2_0p4(:,:,ii) = reshape(tmp_W,128,128);
            
            tmp_A = A_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_A = reshape(tmp_A,128*128,1);
            tmp_A(mask_nan(:)) = nan;
            A_CalciumHbT_1min_smooth_Rolling_R2_0p4(:,:,ii) = reshape(tmp_A,128,128);
            
            tmp_r = r_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r = reshape(tmp_r,128*128,1);
            tmp_r(mask_nan(:)) = nan;
            r_CalciumHbT_1min_smooth_Rolling_R2_0p4(:,:,ii) = reshape(tmp_r,128,128);
            
            tmp_r2 = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r2 = reshape(tmp_r2,128*128,1);
            tmp_r2(mask_nan(:)) = nan;
            r2_CalciumHbT_1min_smooth_Rolling_R2_0p4(:,:,ii) = reshape(tmp_r2,128,128);
        end
        T_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4,3);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4,3);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4,3);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4,3);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p4 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4,3);
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_R2_0p4','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling_R2_0p4','W_CalciumHbT_1min_smooth_Rolling_R2_0p4',...
            'A_CalciumHbT_1min_smooth_Rolling_R2_0p4','r_CalciumHbT_1min_smooth_Rolling_R2_0p4','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse(:,:,n) = T_CalciumHbT_1min_smooth_Rolling_R2_0p4;
        W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse(:,:,n) = W_CalciumHbT_1min_smooth_Rolling_R2_0p4;
        A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse(:,:,n) = A_CalciumHbT_1min_smooth_Rolling_R2_0p4;
        r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse(:,:,n) = r_CalciumHbT_1min_smooth_Rolling_R2_0p4;
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse(:,:,n) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p4;
    end
    T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse,3);
    W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse,3);
    A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse,3);
    r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse,3);
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse,3);
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p4_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse')
end

excelRows = [181 183 185 228 232 236];
T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p4_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p4_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice')


excelRows = [ 195 202 204 230 234 240];
T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p4_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p4_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice')



%% 0.5 mice
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nan(128,128,length(runs));
    W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nan(128,128,length(runs));
    A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nan(128,128,length(runs));
    r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nan(128,128,length(runs));
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nan(128,128,length(runs));
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling','W_CalciumHbT_1min_smooth_Rolling','A_CalciumHbT_1min_smooth_Rolling','r_CalciumHbT_1min_smooth_Rolling','r2_CalciumHbT_1min_smooth_Rolling')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nan(128,128,5);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nan(128,128,5);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nan(128,128,5);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nan(128,128,5);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nan(128,128,5);
        for ii = 1:19
            mask_nan = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii)<0.5;
            
            tmp_T = T_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_T = reshape(tmp_T,128*128,1);
            tmp_T(mask_nan(:)) = nan;
            T_CalciumHbT_1min_smooth_Rolling_R2_0p5(:,:,ii) = reshape(tmp_T,128,128);
            
            tmp_W = W_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_W = reshape(tmp_W,128*128,1);
            tmp_W(mask_nan(:)) = nan;
            W_CalciumHbT_1min_smooth_Rolling_R2_0p5(:,:,ii) = reshape(tmp_W,128,128);
            
            tmp_A = A_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_A = reshape(tmp_A,128*128,1);
            tmp_A(mask_nan(:)) = nan;
            A_CalciumHbT_1min_smooth_Rolling_R2_0p5(:,:,ii) = reshape(tmp_A,128,128);
            
            tmp_r = r_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r = reshape(tmp_r,128*128,1);
            tmp_r(mask_nan(:)) = nan;
            r_CalciumHbT_1min_smooth_Rolling_R2_0p5(:,:,ii) = reshape(tmp_r,128,128);
            
            tmp_r2 = r2_CalciumHbT_1min_smooth_Rolling(:,:,ii);
            tmp_r2 = reshape(tmp_r2,128*128,1);
            tmp_r2(mask_nan(:)) = nan;
            r2_CalciumHbT_1min_smooth_Rolling_R2_0p5(:,:,ii) = reshape(tmp_r2,128,128);
        end
        T_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5,3);
        W_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5,3);
        A_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5,3);
        r_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5,3);
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p5 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5,3);
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_R2_0p5','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling_R2_0p5','W_CalciumHbT_1min_smooth_Rolling_R2_0p5',...
            'A_CalciumHbT_1min_smooth_Rolling_R2_0p5','r_CalciumHbT_1min_smooth_Rolling_R2_0p5','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5')
        T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse(:,:,n) = T_CalciumHbT_1min_smooth_Rolling_R2_0p5;
        W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse(:,:,n) = W_CalciumHbT_1min_smooth_Rolling_R2_0p5;
        A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse(:,:,n) = A_CalciumHbT_1min_smooth_Rolling_R2_0p5;
        r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse(:,:,n) = r_CalciumHbT_1min_smooth_Rolling_R2_0p5;
        r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse(:,:,n) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p5;
    end
    T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,3);
    W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,3);
    A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,3);
    r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,3);
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse,3);
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
        'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
end

excelRows = [181 183 185 228 232 236];
T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
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
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice')


excelRows = [ 195 202 204 230 234 240];
T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nan(128,128,length(excelRows));
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
        'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
    T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:,:,ii) = r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse;
    ii = ii+1;
end
T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mice','.mat')),...
    'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice')



%% 0.2 maps
load('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling_R2_0p2_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice')

figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1.5])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.3])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.2')

t = (0:750)/25;
T_awake_0p2 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
W_awake_0p2 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
A_awake_0p2 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
r_awake_0p2 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
r2_awake_0p2 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');

T_awake_0p2_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
W_awake_0p2_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
A_awake_0p2_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
r_awake_0p2_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
r2_awake_0p2_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));

pixelMrf_awake_0p2 = hrfGamma(t,T_awake_0p2,W_awake_0p2,A_awake_0p2);

%% 0.3 maps
load('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling_R2_0p3_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice')

figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1.5])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.3])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.3')

T_awake_0p3 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
W_awake_0p3 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
A_awake_0p3 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
r_awake_0p3 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
r2_awake_0p3 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');

T_awake_0p3_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
W_awake_0p3_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
A_awake_0p3_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
r_awake_0p3_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
r2_awake_0p3_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));

pixelMrf_awake_0p3 = hrfGamma(t,T_awake_0p3,W_awake_0p3,A_awake_0p3);

%% 0.4 map
load('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling_R2_0p4_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice',...
     'r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice')
 

figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1.5])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.3])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.4')

T_awake_0p4 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
W_awake_0p4 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
A_awake_0p4 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
r_awake_0p4 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
r2_awake_0p4 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');

T_awake_0p4_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
W_awake_0p4_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
A_awake_0p4_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
r_awake_0p4_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
r2_awake_0p4_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
pixelMrf_awake_0p4 = hrfGamma(t,T_awake_0p4,W_awake_0p4,A_awake_0p4);

%% 0.5 maps
load('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling_R2_0p5_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice',...
     'r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice')

figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1.5])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.3])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.5')

T_awake_0p5 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
W_awake_0p5 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
A_awake_0p5 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
r_awake_0p5 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
r2_awake_0p5 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');

T_awake_0p5_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
W_awake_0p5_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
A_awake_0p5_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
r_awake_0p5_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
r2_awake_0p5_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));

pixelMrf_awake_0p5 = hrfGamma(t,T_awake_0p5,W_awake_0p5,A_awake_0p5);




% Anes

%% 0.2 maps
load('191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_1min_smooth_Rolling_R2_0p2_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice')
figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 3])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.1])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.2')


T_anes_0p2 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
W_anes_0p2 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
A_anes_0p2 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
r_anes_0p2 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');
r2_anes_0p2 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice,'all');

T_anes_0p2_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
W_anes_0p2_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
A_anes_0p2_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
r_anes_0p2_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
r2_anes_0p2_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p2_mice(:));
pixelMrf_anes_0p2 = hrfGamma(t,T_anes_0p2,W_anes_0p2,A_anes_0p2);

%% 0.3 maps
load('191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_1min_smooth_Rolling_R2_0p3_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice')
figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 3])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.1])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.3')


T_anes_0p3 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
W_anes_0p3 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
A_anes_0p3 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
r_anes_0p3 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');
r2_anes_0p3 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice,'all');

T_anes_0p3_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
W_anes_0p3_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
A_anes_0p3_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
r_anes_0p3_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
r2_anes_0p3_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p3_mice(:));
pixelMrf_anes_0p3 = hrfGamma(t,T_anes_0p3,W_anes_0p3,A_anes_0p3);

%% 0.4 maps
load('191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_1min_smooth_Rolling_R2_0p4_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice')

figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 3])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.1])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.4')

T_anes_0p4 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
W_anes_0p4 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
A_anes_0p4 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
r_anes_0p4 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');
r2_anes_0p4 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice,'all');

T_anes_0p4_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
W_anes_0p4_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
A_anes_0p4_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
r_anes_0p4_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
r2_anes_0p4_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p4_mice(:));
pixelMrf_anes_0p4 = hrfGamma(t,T_anes_0p4,W_anes_0p4,A_anes_0p4);

%% 0.5 maps
load('191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_1min_smooth_Rolling_R2_0p5_mice.mat',...
    'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice',...
    'r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice', 'r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice')
figure
subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([-1 1])
axis image off
colormap jet
title('r')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 1])
axis image off
colormap jet
title('R^2')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 2])
axis image off
cmocean('ice')
title('T(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 3])
axis image off
cmocean('ice')
title('W(s)')
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'AlphaData',mask)
cb=colorbar;
caxis([0 0.1])
axis image off
cmocean('ice')
title('A')
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes-CalciumHbT-GammaFit-1min-Smooth-Rolling, R^2>0.5')


T_anes_0p5 = nanmean(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
W_anes_0p5 = nanmean(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
A_anes_0p5 = nanmean(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
r_anes_0p5 = nanmean(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');
r2_anes_0p5 = nanmean(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice,'all');

T_anes_0p5_Std = nanstd(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
W_anes_0p5_Std = nanstd(W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
A_anes_0p5_Std = nanstd(A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
r_anes_0p5_Std = nanstd(r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));
r2_anes_0p5_Std = nanstd(r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mice(:));

pixelMrf_anes_0p5 = hrfGamma(t,T_anes_0p5,W_anes_0p5,A_anes_0p5);

figure
plot(t,pixelMrf_awake_0p2,'r--')
hold on
plot(t,pixelMrf_awake_0p3,'m--')
hold on
plot(t,pixelMrf_awake_0p4,'b--')
hold on
plot(t,pixelMrf_awake_0p5,'k--')
hold on
plot(t,pixelMrf_anes_0p2,'ro')
hold on
plot(t,pixelMrf_anes_0p3,'mo')
hold on
plot(t,pixelMrf_anes_0p4,'bo')
hold on
plot(t,pixelMrf_anes_0p5,'ko')
xlim([0 5])
legend('awake R^2>0.2','awake R^2>0.3','awake R^2>0.4','awake R^2>0.5','anes R^2>0.2','anes R^2>0.3','anes R^2>0.4','anes R^2>0.5')
xlabel('Time(s)')



% excelRows = [ 195 202 204 230 234 240];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     miceName = strcat(miceName,'-', mouseName);
%     miceName = char(miceName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_R2_0p5_mouse','.mat')),...
%         'T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','W_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse',...
%         'A_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse','r2_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse')
%     figure
%     imagesc(T_CalciumHbT_1min_smooth_Rolling_R2_0p5_mouse)
%     
% end
%% bar plot for T
model_series = [T_awake_0p2, T_anes_0p2;
                T_awake_0p3, T_anes_0p3;
                T_awake_0p4, T_anes_0p4;
                T_awake_0p5, T_anes_0p5];
            
model_error = [ T_awake_0p2_Std, T_anes_0p2_Std;
                T_awake_0p3_Std, T_anes_0p3_Std;
                T_awake_0p4_Std, T_anes_0p4_Std;
                T_awake_0p5_Std, T_anes_0p5_Std];
figure
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars

errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
set(gca, 'XTickLabel', {'R^2>0.2','R^2>0.3','R^2>0.4','R^2>0.5'})
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;

labels1 = strings(1,4);
for ii = 1:4
    labels1(ii) = sprintf("%0.2f",b(1).YData(ii));
end
text(xtips1,ytips1+0.2,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;

for ii = 1:4
    labels2(ii) = sprintf("%0.2f",b(2).YData(ii));
end

text(xtips2,ytips2+0.1,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Awake','Anesthetized','location','northwest')
ylim([0 1.9])
ylabel('Time(s)')
title('Time to Peak')
%% bar plot for W
model_series = [W_awake_0p2, W_anes_0p2;
                W_awake_0p3, W_anes_0p3;
                W_awake_0p4, W_anes_0p4;
                W_awake_0p5, W_anes_0p5];
            
model_error = [ W_awake_0p2_Std, W_anes_0p2_Std;
                W_awake_0p3_Std, W_anes_0p3_Std;
                W_awake_0p4_Std, W_anes_0p4_Std;
                W_awake_0p5_Std, W_anes_0p5_Std];
figure
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars

errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
set(gca, 'XTickLabel', {'R^2>0.2','R^2>0.3','R^2>0.4','R^2>0.5'})
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;

labels1 = strings(1,4);
for ii = 1:4
    labels1(ii) = sprintf("%0.2f",b(1).YData(ii));
end
text(xtips1,ytips1+0.15,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;

for ii = 1:4
    labels2(ii) = sprintf("%0.2f",b(2).YData(ii));
end

text(xtips2,ytips2+0.15,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Awake','Anesthetized','location','northwest')
ylabel('Time(s)')
title('Width at Half Maximum')
ylim([0 2.6])

%% bar for A
model_series = [A_awake_0p2, A_anes_0p2;
                A_awake_0p3, A_anes_0p3;
                A_awake_0p4, A_anes_0p4;
                A_awake_0p5, A_anes_0p5];
            
model_error = [ A_awake_0p2_Std, A_anes_0p2_Std;
                A_awake_0p3_Std, A_anes_0p3_Std;
                A_awake_0p4_Std, A_anes_0p4_Std;
                A_awake_0p5_Std, A_anes_0p5_Std];
figure
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars

errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
set(gca, 'XTickLabel', {'R^2>0.2','R^2>0.3','R^2>0.4','R^2>0.5'})
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;

labels1 = strings(1,4);
for ii = 1:4
    labels1(ii) = sprintf("%0.2f",b(1).YData(ii));
end
text(xtips1,ytips1+0.04,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;

for ii = 1:4
    labels2(ii) = sprintf("%0.2f",b(2).YData(ii));
end

text(xtips2,ytips2+0.01,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Awake','Anesthetized','location','northwest')
ylabel('\muM/(\DeltaF/F%)')
title('Amplitude')
ylim([0 0.32])

%% r
model_series = [r_awake_0p2, r_anes_0p2;
                r_awake_0p3, r_anes_0p3;
                r_awake_0p4, r_anes_0p4;
                r_awake_0p5, r_anes_0p5];
            
model_error = [ r_awake_0p2_Std, r_anes_0p2_Std;
                r_awake_0p3_Std, r_anes_0p3_Std;
                r_awake_0p4_Std, r_anes_0p4_Std;
                r_awake_0p5_Std, r_anes_0p5_Std];
figure
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars

errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
set(gca, 'XTickLabel', {'R^2>0.2','R^2>0.3','R^2>0.4','R^2>0.5'})
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;

labels1 = strings(1,4);
for ii = 1:4
    labels1(ii) = sprintf("%0.2f",b(1).YData(ii));
end
text(xtips1,ytips1+0.08,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;

for ii = 1:4
    labels2(ii) = sprintf("%0.2f",b(2).YData(ii));
end

text(xtips2,ytips2+0.03,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Awake','Anesthetized','location','northwest')
title('Correlation Coefficient')
ylim([0 1])

%% r2
model_series = [r2_awake_0p2, r2_anes_0p2;
                r2_awake_0p3, r2_anes_0p3;
                r2_awake_0p4, r2_anes_0p4;
                r2_awake_0p5, r2_anes_0p5];
            
model_error = [ r2_awake_0p2_Std, r2_anes_0p2_Std;
                r2_awake_0p3_Std, r2_anes_0p3_Std;
                r2_awake_0p4_Std, r2_anes_0p4_Std;
                r2_awake_0p5_Std, r2_anes_0p5_Std];
figure
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars

errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
set(gca, 'XTickLabel', {'R^2>0.2','R^2>0.3','R^2>0.4','R^2>0.5'})
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;

labels1 = strings(1,4);
for ii = 1:4
    labels1(ii) = sprintf("%0.2f",b(1).YData(ii));
end
text(xtips1,ytips1+0.12,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;

for ii = 1:4
    labels2(ii) = sprintf("%0.2f",b(2).YData(ii));
end

text(xtips2,ytips2+0.035,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Awake','Anesthetized','location','northwest')
title('R^2')
ylim([0 0.8])