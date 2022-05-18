
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
T_CalciumHbT_2min_NoNorm = nan(128,128,5);
W_CalciumHbT_2min_NoNorm = nan(128,128,5);
A_CalciumHbT_2min_NoNorm = nan(128,128,5);
r_CalciumHbT_2min_NoNorm = nan(128,128,5);
r2_CalciumHbT_2min_NoNorm = nan(128,128,5);
hemoPred_CalciumHbT_2min_NoNorm = nan(128,128,600,5);
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
    mask = logical(mask_new.*xform_isbrain);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);
        clear xform_datahb
        Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);
        clear xform_jrgeco1aCorr
        HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
        clear Hb_filter
        HbT_filter = squeeze(HbT_filter);
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        %downsample
        Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
        HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';
        
        % reshape
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        time_epoch=30;
        t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
        
        
        for ii = 1:5
            tic
            [T_CalciumHbT_2min_NoNorm(:,:,ii),W_CalciumHbT_2min_NoNorm(:,:,ii),A_CalciumHbT_2min_NoNorm(:,:,ii),...
                r_CalciumHbT_2min_NoNorm(:,:,ii),r2_CalciumHbT_2min_NoNorm(:,:,ii),hemoPred_CalciumHbT_2min_NoNorm(:,:,:,ii)] ...
                = interSpeciesGammaFit_CalciumHbT_Mask_NoNorm(Calcium_filter(:,:,(ii-1)*120*5+1:ii*120*5)*100,...
                HbT_filter(:,:,(ii-1)*120*5+1:ii*120*5)*10^6,t,mask);
            toc
        end
        T_CalciumHbT_2min_NoNorm_median = nanmedian(T_CalciumHbT_2min_NoNorm,3);
        W_CalciumHbT_2min_NoNorm_median = nanmedian(W_CalciumHbT_2min_NoNorm,3);
        A_CalciumHbT_2min_NoNorm_median = nanmedian(A_CalciumHbT_2min_NoNorm,3);
        r_CalciumHbT_2min_NoNorm_median = nanmedian(r_CalciumHbT_2min_NoNorm,3);
        r2_CalciumHbT_2min_NoNorm_median = nanmedian(r2_CalciumHbT_2min_NoNorm,3);
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min_NoNorm','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min_NoNorm','.mat')),...
                'T_CalciumHbT_2min_NoNorm','W_CalciumHbT_2min_NoNorm','A_CalciumHbT_2min_NoNorm','r_CalciumHbT_2min_NoNorm','r2_CalciumHbT_2min_NoNorm','hemoPred_CalciumHbT_2min_NoNorm',...
                'T_CalciumHbT_2min_NoNorm_median','W_CalciumHbT_2min_NoNorm_median','A_CalciumHbT_2min_NoNorm_median','r_CalciumHbT_2min_NoNorm_median','r2_CalciumHbT_2min_NoNorm_median','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min_NoNorm','.mat')),...
                'T_CalciumHbT_2min_NoNorm','W_CalciumHbT_2min_NoNorm','A_CalciumHbT_2min_NoNorm','r_CalciumHbT_2min_NoNorm','r2_CalciumHbT_2min_NoNorm','hemoPred_CalciumHbT_2min_NoNorm',...
                'T_CalciumHbT_2min_NoNorm_median','W_CalciumHbT_2min_NoNorm_median','A_CalciumHbT_2min_NoNorm_median','r_CalciumHbT_2min_NoNorm_median','r2_CalciumHbT_2min_NoNorm_median','-v7.3')
        end
        figure
        subplot(2,3,4)
        imagesc(r_CalciumHbT_2min_NoNorm_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbT_2min_NoNorm_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbT_2min_NoNorm_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbT_2min_NoNorm_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbT_2min_NoNorm_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.2])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-2min-NoNorm'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_2min_NoNorm.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_2min_NoNorm.fig')));  
    end
end

