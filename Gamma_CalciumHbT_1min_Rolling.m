
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181];
runs = 2;%

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
        T_CalciumHbT_1min_Rolling = nan(128,128,19);
        W_CalciumHbT_1min_Rolling = nan(128,128,19);
        A_CalciumHbT_1min_Rolling = nan(128,128,19);
        r_CalciumHbT_1min_Rolling = nan(128,128,19);
        r2_CalciumHbT_1min_Rolling = nan(128,128,19);
        hemoPred_CalciumHbT_1min_Rolling = nan(128,128,60*5,19);
        obj_CalciumHbT_1min_Rolling = nan(128,128,19);
        jj = 1;
        for ii = 1:30*5:(600-60)*5+1
            tic
            [T_CalciumHbT_1min_Rolling(:,:,jj),W_CalciumHbT_1min_Rolling(:,:,jj),A_CalciumHbT_1min_Rolling(:,:,jj),...
                r_CalciumHbT_1min_Rolling(:,:,jj),r2_CalciumHbT_1min_Rolling(:,:,jj),hemoPred_CalciumHbT_1min_Rolling(:,:,:,jj),obj_CalciumHbT_1min_Rolling(:,:,jj)] ...
                = GammaFit(Calcium_filter(:,:,ii:ii+60*5-1)*100,...
                HbT_filter(:,:,ii:ii+60*5-1)*10^6,t,mask,'default');
            toc
            jj = jj+1;
        end
        T_CalciumHbT_1min_Rolling_median = nanmedian(T_CalciumHbT_1min_Rolling,3);
        W_CalciumHbT_1min_Rolling_median = nanmedian(W_CalciumHbT_1min_Rolling,3);
        A_CalciumHbT_1min_Rolling_median = nanmedian(A_CalciumHbT_1min_Rolling,3);
        r_CalciumHbT_1min_Rolling_median = nanmedian(r_CalciumHbT_1min_Rolling,3);
        r2_CalciumHbT_1min_Rolling_median = nanmedian(r2_CalciumHbT_1min_Rolling,3);
        hemoPre_CalciumHbT_1min_Rolling_median = nanmedian(hemoPred_CalciumHbT_1min_Rolling,4);
        obj_CalciumHbT_1min_Rolling_median = nanmedian(obj_CalciumHbT_1min_Rolling,3);
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_Rolling','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_Rolling','.mat')),...
                'T_CalciumHbT_1min_Rolling','W_CalciumHbT_1min_Rolling','A_CalciumHbT_1min_Rolling','r_CalciumHbT_1min_Rolling','r2_CalciumHbT_1min_Rolling','hemoPred_CalciumHbT_1min_Rolling',...
                'T_CalciumHbT_1min_Rolling_median','W_CalciumHbT_1min_Rolling_median','A_CalciumHbT_1min_Rolling_median','r_CalciumHbT_1min_Rolling_median','r2_CalciumHbT_1min_Rolling_median',...
                'hemoPre_CalciumHbT_1min_Rolling_median','obj_CalciumHbT_1min_Rolling_median','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_Rolling','.mat')),...
                'T_CalciumHbT_1min_Rolling','W_CalciumHbT_1min_Rolling','A_CalciumHbT_1min_Rolling','r_CalciumHbT_1min_Rolling','r2_CalciumHbT_1min_Rolling','hemoPred_CalciumHbT_1min_Rolling',...
                'T_CalciumHbT_1min_Rolling_median','W_CalciumHbT_1min_Rolling_median','A_CalciumHbT_1min_Rolling_median','r_CalciumHbT_1min_Rolling_median','r2_CalciumHbT_1min_Rolling_median',...
                'hemoPre_CalciumHbT_1min_Rolling_median','obj_CalciumHbT_1min_Rolling_median','-v7.3')
        end
        figure
        subplot(2,3,4)
        imagesc(r_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6)
        imagesc(obj_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        colorbar
        axis image off
        colormap jet
        title('Objective Function')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbT_1min_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.2])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-1min-Rolling'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_1min_Rolling.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_1min_Rolling.fig')));  
    end
end


