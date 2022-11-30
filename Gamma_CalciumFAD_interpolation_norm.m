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
import mouse.*
sessionInfo.framerate_new = 100;
time_epoch= 3;
t=0:1/sessionInfo.framerate_new:time_epoch-1/sessionInfo.framerate_new;
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 195;%[181 183 185 228 232 236];% 202 195 204 230 234 240];
runs = 1:3;%


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = mask_new;
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
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        
        FAD = xform_FADCorr;
        clear xform_FADCorr
        calcium = squeeze(xform_jrgeco1aCorr);
        clear xform_jrgeco1aCorr
        mask_matrix = repmat(mask,1,1,size(calcium,3));
        calcium = calcium.*mask_matrix;
        FAD = FAD.*mask_matrix;
        calcium(calcium == 0) = nan;
        FAD(FAD==0) = nan;
        %Smooth
        gBox = 20;
        gSigma = 10;
        FAD_smooth = smoothImage(FAD,gBox,gSigma);
        clear FAD
        calcium_smooth = smoothImage(calcium,gBox,gSigma);
        clear calcium
        FAD_filter =  filterData(double(FAD_smooth),0.02,2,sessionInfo.framerate);
        clear FAD_smooth
        Calcium_filter = filterData(double(calcium_smooth),0.02,2,sessionInfo.framerate);
        clear calcium_smooth
        
        T_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        W_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        A_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        r_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        r2_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        %hemoPred_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,60*sessionInfo.framerate_new,19);
        obj_CalciumFAD_1min_smooth_Rolling_interp = nan(128,128,19);
        jj = 1;
        %%
        for ii = 1:30*sessionInfo.framerate:(600-60)*sessionInfo.framerate+1
            
            if jj < 19
                tic
                calcium_interp = zeros(128,128,60*sessionInfo.framerate_new);
                FAD_interp = zeros(128,128,60*sessionInfo.framerate_new);
                for kk = 1:128
                    for ll = 1:128
                        if mask(kk,ll)
                            temp_calcium = squeeze(Calcium_filter(kk,ll,ii:ii+60*sessionInfo.framerate-1)*100);
                            temp_FAD = squeeze(FAD_filter(kk,ll,ii:ii+60*sessionInfo.framerate-1)*100);
                            calcium_interp(kk,ll,:) = interp1(1:60*sessionInfo.framerate,temp_calcium,linspace(1,60*sessionInfo.framerate,60*sessionInfo.framerate_new));
                            FAD_interp(kk,ll,:) = interp1(1:60*sessionInfo.framerate,temp_FAD,linspace(1,60*sessionInfo.framerate,60*sessionInfo.framerate_new));
                        end
                    end
                end
                toc
                   calcium_interp = reshape(calcium_interp,128*128,[]);
                   FAD_interp = reshape(FAD_interp,128*128,[]);
                   calcium_interp = normRow(calcium_interp);
                   FAD_interp = normRow(FAD_interp);
                   calcium_interp = reshape(calcium_interp,128,128,[]);
                   FAD_interp = reshape(FAD_interp,128,128,[]);      
                tic
                [T_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),W_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),A_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),...
                    r_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),r2_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),~,obj_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj)] ...
                    = GammaFit_CalciumFAD(calcium_interp,FAD_interp,t,mask);%hemoPred_CalciumFAD_1min_smooth_Rolling_interp(:,:,:,jj)
                toc
            else
                tic
                numFrames = length(ii:size(Calcium_filter,3))/sessionInfo.framerate*sessionInfo.framerate_new;
                calcium_interp = zeros(128,128,numFrames);
                FAD_interp = zeros(128,128,numFrames);
                for kk = 1:128
                    for ll = 1:128
                        if mask(kk,ll)
                            temp_calcium = squeeze(Calcium_filter(kk,ll,ii:end)*100);
                            temp_FAD = squeeze(FAD_filter(kk,ll,ii:end)*100);
                            calcium_interp(kk,ll,:) = interp1(1:length(temp_calcium),temp_calcium,linspace(1,length(temp_calcium),numFrames));
                            FAD_interp(kk,ll,:) = interp1(1:length(temp_FAD),temp_FAD,linspace(1,length(temp_calcium),numFrames));
                        end
                    end
                end
                %clear Calcium_filter FAD_filter
                toc
                tic
                [T_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),W_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),A_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),...
                    r_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),r2_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj),~,obj_CalciumFAD_1min_smooth_Rolling_interp(:,:,jj)] ...
                    = GammaFit_CalciumFAD(calcium_interp*100,FAD_interp*100,t,mask);
                toc
            end
            
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
                'obj_CalciumFAD_1min_smooth_Rolling_interp_median','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_interp_CalciumFAD','.mat')),...
                'T_CalciumFAD_1min_smooth_Rolling_interp','W_CalciumFAD_1min_smooth_Rolling_interp','A_CalciumFAD_1min_smooth_Rolling_interp','r_CalciumFAD_1min_smooth_Rolling_interp','r2_CalciumFAD_1min_smooth_Rolling_interp','obj_CalciumFAD_1min_smooth_Rolling_interp',...
                'T_CalciumFAD_1min_smooth_Rolling_interp_median','W_CalciumFAD_1min_smooth_Rolling_interp_median','A_CalciumFAD_1min_smooth_Rolling_interp_median','r_CalciumFAD_1min_smooth_Rolling_interp_median','r2_CalciumFAD_1min_smooth_Rolling_interp_median',...
                'obj_CalciumFAD_1min_smooth_Rolling_interp_median','-v7.3')
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
        caxis([0 0.05])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.006])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.15]) %%anes caxis([0 0.07])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-GammaFit-1min-smooth-Rolling-interp'))
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_Interp.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_Interp.fig')));
    end
end


