clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    T_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nan(128,128,length(runs));
    W_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nan(128,128,length(runs));
    A_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nan(128,128,length(runs));
    r_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nan(128,128,length(runs));
    r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nan(128,128,length(runs));
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min_NoNorm','.mat')),...
            'T_CalciumFAD_2min_NoNorm','W_CalciumFAD_2min_NoNorm','A_CalciumFAD_2min_NoNorm','r_CalciumFAD_2min_NoNorm','r2_CalciumFAD_2min_NoNorm')
        T_CalciumFAD_2min_NoNorm_R2_0p5 = nan(128,128,5);
        W_CalciumFAD_2min_NoNorm_R2_0p5 = nan(128,128,5);
        A_CalciumFAD_2min_NoNorm_R2_0p5 = nan(128,128,5);
        r_CalciumFAD_2min_NoNorm_R2_0p5 = nan(128,128,5);
        r2_CalciumFAD_2min_NoNorm_R2_0p5 = nan(128,128,5);
        for ii = 1:5
            mask_nan = r2_CalciumFAD_2min_NoNorm(:,:,ii)<0.5;
            
            tmp_T = T_CalciumFAD_2min_NoNorm(:,:,ii);
            tmp_T = reshape(tmp_T,128*128,1);
            tmp_T(mask_nan(:)) = nan;
            T_CalciumFAD_2min_NoNorm_R2_0p5(:,:,ii) = reshape(tmp_T,128,128);
            
            tmp_W = W_CalciumFAD_2min_NoNorm(:,:,ii);
            tmp_W = reshape(tmp_W,128*128,1);
            tmp_W(mask_nan(:)) = nan;
            W_CalciumFAD_2min_NoNorm_R2_0p5(:,:,ii) = reshape(tmp_W,128,128);
            
            tmp_A = A_CalciumFAD_2min_NoNorm(:,:,ii);
            tmp_A = reshape(tmp_A,128*128,1);
            tmp_A(mask_nan(:)) = nan;
            A_CalciumFAD_2min_NoNorm_R2_0p5(:,:,ii) = reshape(tmp_A,128,128);
            
            tmp_r = r_CalciumFAD_2min_NoNorm(:,:,ii);
            tmp_r = reshape(tmp_r,128*128,1);
            tmp_r(mask_nan(:)) = nan;
            r_CalciumFAD_2min_NoNorm_R2_0p5(:,:,ii) = reshape(tmp_r,128,128);
            
            tmp_r2 = r2_CalciumFAD_2min_NoNorm(:,:,ii);
            tmp_r2 = reshape(tmp_r2,128*128,1);
            tmp_r2(mask_nan(:)) = nan;
            r2_CalciumFAD_2min_NoNorm_R2_0p5(:,:,ii) = reshape(tmp_r2,128,128);
        end
        T_CalciumFAD_2min_NoNorm_R2_0p5 = nanmean(T_CalciumFAD_2min_NoNorm_R2_0p5,3);     
        W_CalciumFAD_2min_NoNorm_R2_0p5 = nanmean(W_CalciumFAD_2min_NoNorm_R2_0p5,3);
        A_CalciumFAD_2min_NoNorm_R2_0p5 = nanmean(A_CalciumFAD_2min_NoNorm_R2_0p5,3);
        r_CalciumFAD_2min_NoNorm_R2_0p5 = nanmean(r_CalciumFAD_2min_NoNorm_R2_0p5,3);
        r2_CalciumFAD_2min_NoNorm_R2_0p5 = nanmean(r2_CalciumFAD_2min_NoNorm_R2_0p5,3);
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min_NoNorm_R2_0p5_CalciumFAD','.mat')),...
            'T_CalciumFAD_2min_NoNorm_R2_0p5','W_CalciumFAD_2min_NoNorm_R2_0p5',...
            'A_CalciumFAD_2min_NoNorm_R2_0p5','r_CalciumFAD_2min_NoNorm_R2_0p5','r2_CalciumFAD_2min_NoNorm_R2_0p5')
        
        T_CalciumFAD_2min_NoNorm_R2_0p5_mouse(:,:,n) = T_CalciumFAD_2min_NoNorm_R2_0p5;
        clear T_CalciumFAD_2min_NoNorm_R2_0p5
        W_CalciumFAD_2min_NoNorm_R2_0p5_mouse(:,:,n) = W_CalciumFAD_2min_NoNorm_R2_0p5;
        clear W_CalciumFAD_2min_NoNorm_R2_0p5
        A_CalciumFAD_2min_NoNorm_R2_0p5_mouse(:,:,n) = A_CalciumFAD_2min_NoNorm_R2_0p5;
        clear A_CalciumFAD_2min_NoNorm_R2_0p5
        r_CalciumFAD_2min_NoNorm_R2_0p5_mouse(:,:,n) = r_CalciumFAD_2min_NoNorm_R2_0p5;
        clear r_CalciumFAD_2min_NoNorm_R2_0p5
        r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse(:,:,n) = r2_CalciumFAD_2min_NoNorm_R2_0p5;
        clear r2_CalciumFAD_2min_NoNorm_R2_0p5
    end
    T_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nanmean(T_CalciumFAD_2min_NoNorm_R2_0p5_mouse,3);
    W_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nanmean(W_CalciumFAD_2min_NoNorm_R2_0p5_mouse,3);
    A_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nanmean(A_CalciumFAD_2min_NoNorm_R2_0p5_mouse,3);
    r_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nanmean(r_CalciumFAD_2min_NoNorm_R2_0p5_mouse,3);
    r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse = nanmean(r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse,3);
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min_NoNorm_R2_0p5_CalciumFAD_mouse','.mat')),...
        'T_CalciumFAD_2min_NoNorm_R2_0p5_mouse','W_CalciumFAD_2min_NoNorm_R2_0p5_mouse',...
        'A_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse')
    clear T_CalciumFAD_2min_NoNorm_R2_0p5_mouse W_CalciumFAD_2min_NoNorm_R2_0p5_mouse A_CalciumFAD_2min_NoNorm_R2_0p5_mouse r_CalciumFAD_2min_NoNorm_R2_0p5_mouse r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse
end

excelRows = [181 183 185 228 232 236];
T_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
W_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
A_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
r_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
r2_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min_NoNorm_R2_0p5_CalciumFAD_mouse','.mat')),...
        'T_CalciumFAD_2min_NoNorm_R2_0p5_mouse','W_CalciumFAD_2min_NoNorm_R2_0p5_mouse',...
        'A_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse')
    T_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = T_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear T_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    W_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = W_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear W_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    A_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = A_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear A_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    r_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = r_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear r_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    r2_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    ii = ii+1;
end
T_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(T_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
W_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(W_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
A_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(A_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
r_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(r_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
r2_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(r2_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_2min_NoNorm_R2_0p5_CalciumFAD_mice','.mat')),...
    'T_CalciumFAD_2min_NoNorm_R2_0p5_mice','W_CalciumFAD_2min_NoNorm_R2_0p5_mice',...
    'A_CalciumFAD_2min_NoNorm_R2_0p5_mice','r_CalciumFAD_2min_NoNorm_R2_0p5_mice','r2_CalciumFAD_2min_NoNorm_R2_0p5_mice')
clear T_CalciumFAD_2min_NoNorm_R2_0p5_mice W_CalciumFAD_2min_NoNorm_R2_0p5_mice A_CalciumFAD_2min_NoNorm_R2_0p5_mice r_CalciumFAD_2min_NoNorm_R2_0p5_mice r2_CalciumFAD_2min_NoNorm_R2_0p5_mice

excelRows = [ 195 202 204 230 234 240];
T_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
W_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
A_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
r_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
r2_CalciumFAD_2min_NoNorm_R2_0p5_mice = nan(128,128,length(excelRows));
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
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min_NoNorm_R2_0p5_CalciumFAD_mouse','.mat')),...
        'T_CalciumFAD_2min_NoNorm_R2_0p5_mouse','W_CalciumFAD_2min_NoNorm_R2_0p5_mouse',...
        'A_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r_CalciumFAD_2min_NoNorm_R2_0p5_mouse','r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse')
       T_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = T_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear T_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    W_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = W_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear W_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    A_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = A_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear A_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    r_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = r_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    clear r_CalciumFAD_2min_NoNorm_R2_0p5_mouse
    r2_CalciumFAD_2min_NoNorm_R2_0p5_mice(:,:,ii) = r2_CalciumFAD_2min_NoNorm_R2_0p5_mouse;
    ii = ii+1;
end
T_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(T_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
W_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(W_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
A_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(A_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
r_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(r_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);
r2_CalciumFAD_2min_NoNorm_R2_0p5_mice = nanmean(r2_CalciumFAD_2min_NoNorm_R2_0p5_mice,3);

save(fullfile('L:\RGECO\cat',strcat(recDate,'-',miceName(2:end),'-',sessionType,'_2min_NoNorm_R2_0p5_CalciumFAD_mice','.mat')),...
    'T_CalciumFAD_2min_NoNorm_R2_0p5_mice','W_CalciumFAD_2min_NoNorm_R2_0p5_mice',...
    'A_CalciumFAD_2min_NoNorm_R2_0p5_mice','r_CalciumFAD_2min_NoNorm_R2_0p5_mice','r2_CalciumFAD_2min_NoNorm_R2_0p5_mice')

