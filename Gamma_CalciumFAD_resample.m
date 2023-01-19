% % reasonable gamma
% for sampleRate = 25:25:1000
% t = (0:sampleRate*30)/sampleRate;
% pixelMrf = hrfGamma(t,0.0743,0.0623,0.1726);
% figure
% plot(t,pixelMrf,'.')
% title(['FrameRate = ',num2str(sampleRate)])
% xlim([0 0.5])
% end
%interpolate
clear all;close all;clc

sessionInfo.framerate_new =250;
time_epoch= 60;
t=0:1/sessionInfo.framerate_new:time_epoch-1/sessionInfo.framerate_new;
excelFile = "A:\XW\RGECO\DataBase_Xiaodan_2.xlsx";
excelRows = [185 228 232 236 195 204 230 234 240];%181 202 183 needs to do 185
runs = 1:3;%

load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat','xform_WL')
load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.framerate = excelRaw{7};
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_isbrain')
        mask = logical(mask_new.*xform_isbrain);
        FAD = xform_FADCorr*100;
        clear xform_FADCorr
        calcium = squeeze(xform_jrgeco1aCorr)*100;
        clear xform_jrgeco1aCorr
        calcium(:,:,end+1) = calcium(:,:,end);
        FAD(:,:,end+1) = FAD(:,:,end);
        
        mask_matrix = repmat(mask,1,1,size(calcium,3));
        calcium = calcium.*mask_matrix;
        FAD = FAD.*mask_matrix;

        %Smooth
        gBox = 20;
        gSigma = 10;
        FAD_smooth = smoothImage(FAD,gBox,gSigma);
        clear FAD
        calcium_smooth = smoothImage(calcium,gBox,gSigma);
        clear calcium
        FAD_smooth =  filterData(double(FAD_smooth),0.02,2,sessionInfo.framerate);
        calcium_smooth = filterData(double(calcium_smooth),0.02,2,sessionInfo.framerate);
        tic
        calcium_resample = resample(calcium_smooth,sessionInfo.framerate_new,sessionInfo.framerate,'Dimension',3);
        clear calcium_smooth
        FAD_resample = resample(FAD_smooth,sessionInfo.framerate_new,sessionInfo.framerate,'Dimension',3);
        toc
        clear FAD_smooth
        tic
        FAD_filter =  filterData(double(FAD_resample),0.02,2,sessionInfo.framerate_new);
        clear FAD_resample
        calcium_filter = filterData(double(calcium_resample),0.02,2,sessionInfo.framerate_new);
        clear calcium_resample
        toc
        T_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        W_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        A_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        r_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        r2_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        FADPred_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,60*sessionInfo.framerate_new,19);
        obj_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        jj = 1;
        %%
        for ii = 1:30*sessionInfo.framerate_new:(600-60)*sessionInfo.framerate_new+1
            tic
            [T_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),W_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),A_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),...
                r_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),r2_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),FADPred_CalciumFAD_1min_smooth_Rolling_interp(:,:,:,jj),obj_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj)] ...
                = GammaFit_CalciumFAD(calcium_filter(:,:,ii:ii+time_epoch*sessionInfo.framerate_new-1),FAD_filter(:,:,ii:ii+time_epoch*sessionInfo.framerate_new-1),t,mask);%hemoPred_CalciumFAD_1min_smooth_Rolling_interp(:,:,:,jj)
            toc
            jj = jj+1;
        end
        %%
        T_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(T_CalciumFAD_1min_smooth_Rolling_interp,3);
        W_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(W_CalciumFAD_1min_smooth_Rolling_interp,3);
        A_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(A_CalciumFAD_1min_smooth_Rolling_interp,3);
        r_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(r_CalciumFAD_1min_smooth_Rolling_interp,3);
        r2_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(r2_CalciumFAD_1min_smooth_Rolling_interp,3);
        %hemoPre_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(hemoPred_CalciumFAD_1min_smooth_Rolling_interp,4);
        obj_CalciumFAD_1min_smooth_Rolling_interp_median = nanmedian(obj_CalciumFAD_1min_smooth_Rolling_interp,3);
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_interp_CalciumFAD','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_interp_CalciumFAD','.mat')),...
                'T_CalciumFAD_1min_smooth_Rolling_interp','W_CalciumFAD_1min_smooth_Rolling_interp','A_CalciumFAD_1min_smooth_Rolling_interp','r_CalciumFAD_1min_smooth_Rolling_interp','r2_CalciumFAD_1min_smooth_Rolling_interp','obj_CalciumFAD_1min_smooth_Rolling_interp',...
                'T_CalciumFAD_1min_smooth_Rolling_interp_median','W_CalciumFAD_1min_smooth_Rolling_interp_median','A_CalciumFAD_1min_smooth_Rolling_interp_median','r_CalciumFAD_1min_smooth_Rolling_interp_median','r2_CalciumFAD_1min_smooth_Rolling_interp_median',...
                'obj_CalciumFAD_1min_smooth_Rolling_interp_median','FADPred_CalciumFAD_1min_smooth_Rolling_interp','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_interp_CalciumFAD','.mat')),...
                'T_CalciumFAD_1min_smooth_Rolling_interp','W_CalciumFAD_1min_smooth_Rolling_interp','A_CalciumFAD_1min_smooth_Rolling_interp','r_CalciumFAD_1min_smooth_Rolling_interp','r2_CalciumFAD_1min_smooth_Rolling_interp','obj_CalciumFAD_1min_smooth_Rolling_interp',...
                'T_CalciumFAD_1min_smooth_Rolling_interp_median','W_CalciumFAD_1min_smooth_Rolling_interp_median','A_CalciumFAD_1min_smooth_Rolling_interp_median','r_CalciumFAD_1min_smooth_Rolling_interp_median','r2_CalciumFAD_1min_smooth_Rolling_interp_median',...
                'obj_CalciumFAD_1min_smooth_Rolling_interp_median','FADPred_CalciumFAD_1min_smooth_Rolling_interp','-v7.3')
        end
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6)
        imagesc(obj_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        colorbar
        axis image off
        colormap jet
        title('Objective Function')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.4])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.4])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.04]) %%anes caxis([0 0.07])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-GammaFit-1min-smooth-Rolling-interp'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.fig')));
        close all
    end
end


