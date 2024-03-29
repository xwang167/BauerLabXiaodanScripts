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
        
        HbO = squeeze(xform_datahb(:,:,1,:));
        clear xform_datahb
        calcium = xform_jrgeco1aCorr;
        clear xform_jrgeco1aCorr
        mask_matrix = repmat(mask,1,1,size(calcium,3));
        calcium = calcium.*mask_matrix;
        HbO = HbO.*mask_matrix;
        calcium(calcium == 0) = nan;
        HbO(HbO==0) = nan;
        %Smooth
        gBox = 20;
        gSigma = 10;
        HbO_smooth = smoothImage(HbO,gBox,gSigma);
        clear HbO
        calcium_smooth = smoothImage(calcium,gBox,gSigma);
        clear calcium
        HbO_filter =  filterData(double(HbO_smooth),0.02,2,sessionInfo.framerate);
        clear HbO_smooth
        Calcium_filter = filterData(double(calcium_smooth),0.02,2,sessionInfo.framerate);
        clear calcium_smooth
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbO_filter = reshape(HbO_filter,128*128,[]);
        %downsample
        Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
        HbO_filter=resample(HbO_filter',5,sessionInfo.framerate)';
        
        % reshape
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbO_filter = reshape(HbO_filter,128,128,[]);
        time_epoch=30;
        t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
        T_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        W_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        A_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        r_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        r2_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        hemoPred_CalciumHbO_1min_smooth_Rolling = nan(128,128,60*5,19);
        obj_CalciumHbO_1min_smooth_Rolling = nan(128,128,19);
        jj = 1;
        for ii = 1:30*5:(600-60)*5+1
            tic
            [T_CalciumHbO_1min_smooth_Rolling(:,:,jj),W_CalciumHbO_1min_smooth_Rolling(:,:,jj),A_CalciumHbO_1min_smooth_Rolling(:,:,jj),...
                r_CalciumHbO_1min_smooth_Rolling(:,:,jj),r2_CalciumHbO_1min_smooth_Rolling(:,:,jj),hemoPred_CalciumHbO_1min_smooth_Rolling(:,:,:,jj),obj_CalciumHbO_1min_smooth_Rolling(:,:,jj)] ...
                = GammaFit(Calcium_filter(:,:,ii:ii+60*5-1)*100,...
                HbO_filter(:,:,ii:ii+60*5-1)*10^6,t,mask,'default');
            toc
            jj = jj+1;
        end
        T_CalciumHbO_1min_smooth_Rolling_median = nanmedian(T_CalciumHbO_1min_smooth_Rolling,3);
        W_CalciumHbO_1min_smooth_Rolling_median = nanmedian(W_CalciumHbO_1min_smooth_Rolling,3);
        A_CalciumHbO_1min_smooth_Rolling_median = nanmedian(A_CalciumHbO_1min_smooth_Rolling,3);
        r_CalciumHbO_1min_smooth_Rolling_median = nanmedian(r_CalciumHbO_1min_smooth_Rolling,3);
        r2_CalciumHbO_1min_smooth_Rolling_median = nanmedian(r2_CalciumHbO_1min_smooth_Rolling,3);
        hemoPre_CalciumHbO_1min_smooth_Rolling_median = nanmedian(hemoPred_CalciumHbO_1min_smooth_Rolling,4);
        obj_CalciumHbO_1min_smooth_Rolling_median = nanmedian(obj_CalciumHbO_1min_smooth_Rolling,3);
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
                'T_CalciumHbO_1min_smooth_Rolling','W_CalciumHbO_1min_smooth_Rolling','A_CalciumHbO_1min_smooth_Rolling','r_CalciumHbO_1min_smooth_Rolling','r2_CalciumHbO_1min_smooth_Rolling','hemoPred_CalciumHbO_1min_smooth_Rolling',...
                'T_CalciumHbO_1min_smooth_Rolling_median','W_CalciumHbO_1min_smooth_Rolling_median','A_CalciumHbO_1min_smooth_Rolling_median','r_CalciumHbO_1min_smooth_Rolling_median','r2_CalciumHbO_1min_smooth_Rolling_median',...
                'hemoPre_CalciumHbO_1min_smooth_Rolling_median','obj_CalciumHbO_1min_smooth_Rolling_median','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
                'T_CalciumHbO_1min_smooth_Rolling','W_CalciumHbO_1min_smooth_Rolling','A_CalciumHbO_1min_smooth_Rolling','r_CalciumHbO_1min_smooth_Rolling','r2_CalciumHbO_1min_smooth_Rolling','hemoPred_CalciumHbO_1min_smooth_Rolling',...
                'T_CalciumHbO_1min_smooth_Rolling_median','W_CalciumHbO_1min_smooth_Rolling_median','A_CalciumHbO_1min_smooth_Rolling_median','r_CalciumHbO_1min_smooth_Rolling_median','r2_CalciumHbO_1min_smooth_Rolling_median',...
                'hemoPre_CalciumHbO_1min_smooth_Rolling_median','obj_CalciumHbO_1min_smooth_Rolling_median','-v7.3')
        end
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        imagesc(r_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6)
        imagesc(obj_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        colorbar
        axis image off
        colormap jet
        title('Objective Function')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbO_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.2])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbO-GammaFit-1min-smooth-Rolling'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbO_GammaFit_1min_smooth_Rolling.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbO_GammaFit_1min_smooth_Rolling.fig')));
        close all
    end
end


