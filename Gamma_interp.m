clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181]; %excelRows_anes = [ 202 195 204 230 234 240];[181 183 185 228 232 236 

runs = 1;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')

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
    if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        maskDir = fullfile(rawdataloc,recDate);
    else
        maskDir = saveDir;
    end
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = mask_new.*xform_isbrain;
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        FAD_2 = nan(size(xform_FADCorr,1),size(xform_FADCorr,2),size(xform_FADCorr,3)*2);
        RGECO_2 = nan(size(xform_jrgeco1aCorr,1),size(xform_jrgeco1aCorr,2),size(xform_jrgeco1aCorr,3)*2);
        for ii = size(xform_FADCorr,1)
            for jj = size(xform_jrgeco1aCorr,2)
                FAD_2(ii,jj,:) = interp1(1:length(xform_FADCorr),squeeze(xform_FADCorr(ii,jj,:)),0.5:0.5:length(xform_FADCorr),'spline');
                RGECO_2(ii,jj,:) = interp1(1:length(xform_jrgeco1aCorr),squeeze(xform_jrgeco1aCorr(ii,jj,:)),0.5:0.5:length(xform_jrgeco1aCorr),'spline');
            end
        end
        clear xform_FADCorr xform_jrgeco1aCorr
        
        FAD_filter = filterData(double(FAD_2),0.02,2,50);      
        Calcium_filter = filterData(double(squeeze(RGECO_2)),0.02,2,50);
        t = (0:50*3)./50;
        [T_CalciumFAD_2,W_CalciumFAD_2,A_CalciumFAD_2,r_CalciumFAD_2,r2_CalciumFAD_2,FADPred_CalciumFAD_2] = interSpeciesGammaFit_CalciumFAD_Mask_nan(Calcium_filter,FAD_filter,t,mask);
        saveName =  strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_nan.mat');
        save(fullfile(saveDir,saveName),'T_CalciumFAD_2','W_CalciumFAD_2','A_CalciumFAD_2','r_CalciumFAD_2','r2_CalciumFAD_2','FADPred_CalciumFAD_2','-append')
        
        figure
        subplot(2,3,1)
        imagesc(T_CalciumFAD_2,[0,0.2])
        colorbar
        axis image off
        colormap jet
        title('T(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumFAD_2,[0 0.06])
        colorbar
        axis image off
        colormap jet
        title('W(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumFAD_2,[0 1])
        colorbar
        axis image off
        colormap jet
        title('A')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,4)
        imagesc(r_CalciumFAD_2,[-1 1])
        colorbar
        axis image off
        colormap jet
        title('r')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumFAD_2,[0 1])
        colorbar
        axis image off
        colormap jet
        title('R^2')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_nan2.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_nan2.fig')));
        %close all
    end
end