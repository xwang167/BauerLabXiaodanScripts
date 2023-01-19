clear all;close all;clc
import mouse.*
excelFile = "A:\XW\RGECO\DataBase_Xiaodan_2.xlsx";
excelRows = [195];% 183 185 228 232 236 202 195 204 230 234 240];
runs = 1;%:3;%

load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat','xform_WL')
load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
sessionInfo.framerate_new = 12.5;
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
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr','xform_isbrain')
        mask = logical(mask_new.*xform_isbrain);
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
        clear xform_datahb
        HbT(:,:,end+1) = HbT(:,:,end);
        calcium = xform_jrgeco1aCorr;
        clear xform_jrgeco1aCorr
        calcium(:,:,end+1) = calcium(:,:,end);
        mask_matrix = repmat(mask,1,1,size(calcium,3));
        calcium = calcium.*mask_matrix;
        HbT = HbT.*mask_matrix;
        calcium(calcium == 0) = nan;
        HbT(HbT==0) = nan;
        %Smooth
        gBox = 20;
        gSigma = 10;
        HbT_smooth = smoothImage(HbT,gBox,gSigma);
        clear HbT
        calcium_smooth = smoothImage(calcium,gBox,gSigma);
        clear calcium
        HbT_filter =  filterData(double(HbT_smooth),0.01,5,sessionInfo.framerate);
        clear HbT_smooth
        Calcium_filter = filterData(double(calcium_smooth),0.01,5,sessionInfo.framerate);
        clear calcium_smooth
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);

        %downsample
        Calcium_filter=resample(Calcium_filter',sessionInfo.framerate_new*2,sessionInfo.framerate*2)';
        HbT_filter=resample(HbT_filter',sessionInfo.framerate_new*2,sessionInfo.framerate*2)';
        % reshape
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        time_epoch=60;
        t=linspace(0,time_epoch-1/sessionInfo.framerate_new,time_epoch*sessionInfo.framerate_new);
        T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        hemoPred_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,60*sessionInfo.framerate_new,19);
        obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5 = nan(128,128,19);
        jj = 1;
        for ii = 1:30*sessionInfo.framerate_new:(600-60)*sessionInfo.framerate_new+1
            tic
            [T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj),W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj),A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj),...
                r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj),r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj),hemoPred_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,:,jj),obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5(:,:,jj)] ...
                = GammaFit(Calcium_filter(:,:,ii:ii+60*sessionInfo.framerate_new-1)*100,...
                HbT_filter(:,:,ii:ii+60*sessionInfo.framerate_new-1)*10^6,t,mask,'default');
            toc
            jj = jj+1;
        end
        T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        hemoPre_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(hemoPred_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,4);
        obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median = nanmedian(obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5,3);
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_60epoch_0p01_5','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_60epoch_0p01_5','.mat')),...
                'T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','hemoPred_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5',...
                'T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median',...
                'hemoPre_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_60epoch_0p01_5','.mat')),...
                'T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5','hemoPred_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5',...
                'T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median',...
                'hemoPre_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median','-v7.3')
        end
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        imagesc(r_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6)
        imagesc(obj_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        colorbar
        axis image off
        colormap jet
        title('Objective Function')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbT_1min_smooth_Rolling_60epoch_0p01_5_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.05])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-1min-smooth-Rolling-60epoch-0p01-5'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_1min_smooth_Rolling_60epoch_0p01_5.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_1min_smooth_Rolling_60epoch_0p01_5.fig')));
    end
end


