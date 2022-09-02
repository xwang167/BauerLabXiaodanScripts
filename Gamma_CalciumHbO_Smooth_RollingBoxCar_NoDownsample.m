clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181];
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
    mask = logical(mask_new.*xform_isbrain);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
        clear xform_datahb
        calcium = xform_jrgeco1aCorr;
        clear xform_jrgeco1aCorr
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
        HbT_filter =  filterData(double(HbT_smooth),0.02,2,sessionInfo.framerate);
        clear HbT_smooth
        Calcium_filter = filterData(double(calcium_smooth),0.02,2,sessionInfo.framerate);
        clear calcium_smooth
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        %downsample
        
        % reshape
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        time_epoch=30;
        t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(25/sessionInfo.framerate));%% force it to be 5 hz
        T_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
        W_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
        A_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
        r_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
        r2_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
%        hemoPred_CalciumHbT_1min_smooth_Rolling = nan(128,128,14999,19);
        obj_CalciumHbT_1min_smooth_Rolling = nan(128,128,19);
        jj = 1;
        for ii = 1:30*25:(600-60)*25
            tic
            [T_CalciumHbT_1min_smooth_Rolling(:,:,jj),W_CalciumHbT_1min_smooth_Rolling(:,:,jj),A_CalciumHbT_1min_smooth_Rolling(:,:,jj),...
                r_CalciumHbT_1min_smooth_Rolling(:,:,jj),r2_CalciumHbT_1min_smooth_Rolling(:,:,jj),~,obj_CalciumHbT_1min_smooth_Rolling(:,:,jj)] ...
                = GammaFit(Calcium_filter(:,:,ii:ii+60*25-1)*100,...
                HbT_filter(:,:,ii:ii+60*25-1)*10^6,t,mask,'default');
            toc
            jj = jj+1;
        end
        ii = (600-60)*25+1;
        [T_CalciumHbT_1min_smooth_Rolling(:,:,jj),W_CalciumHbT_1min_smooth_Rolling(:,:,jj),A_CalciumHbT_1min_smooth_Rolling(:,:,jj),...
                r_CalciumHbT_1min_smooth_Rolling(:,:,jj),r2_CalciumHbT_1min_smooth_Rolling(:,:,jj),~,obj_CalciumHbT_1min_smooth_Rolling(:,:,jj)] ...
                = GammaFit(Calcium_filter(:,:,ii:end)*100,...
                HbT_filter(:,:,ii:end)*10^6,t,mask,'default');
            
        T_CalciumHbT_1min_smooth_Rolling_median = nanmedian(T_CalciumHbT_1min_smooth_Rolling,3);
        W_CalciumHbT_1min_smooth_Rolling_median = nanmedian(W_CalciumHbT_1min_smooth_Rolling,3);
        A_CalciumHbT_1min_smooth_Rolling_median = nanmedian(A_CalciumHbT_1min_smooth_Rolling,3);
        r_CalciumHbT_1min_smooth_Rolling_median = nanmedian(r_CalciumHbT_1min_smooth_Rolling,3);
        r2_CalciumHbT_1min_smooth_Rolling_median = nanmedian(r2_CalciumHbT_1min_smooth_Rolling,3);
        %hemoPre_CalciumHbT_1min_smooth_Rolling_median = nanmedian(hemoPred_CalciumHbT_1min_smooth_Rolling,4);
        obj_CalciumHbT_1min_smooth_Rolling_median = nanmedian(obj_CalciumHbT_1min_smooth_Rolling,3);
        
  
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        imagesc(r_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6)
        imagesc(obj_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        colorbar
        axis image off
        colormap jet
        title('Objective Function')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbT_1min_smooth_Rolling_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.2])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-1min-smooth-Rolling-NoDownsample'))
     end
end


