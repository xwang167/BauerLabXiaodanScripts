
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
T_CalciumHbT_60s = nan(128,128,10);
W_CalciumHbT_60s = nan(128,128,10);
A_CalciumHbT_60s = nan(128,128,10);
r_CalciumHbT_60s = nan(128,128,10);
r2_CalciumHbT_60s = nan(128,128,10);
hemoPred_CalciumHbT_60s = nan(128,128,1500,10);
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
        
        Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
        clear xform_datahb
        %FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
        clear Hb_filter
        HbT_filter = squeeze(HbT_filter);
        t = (0:750)./25;
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        %Norm
        Calcium_filter = normRow(Calcium_filter);
        HbT_filter = normRow(HbT_filter);
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        
        for ii = 1:9
            tic
            [T_CalciumHbT_60s(:,:,ii),W_CalciumHbT_60s(:,:,ii),A_CalciumHbT_60s(:,:,ii),r_CalciumHbT_60s(:,:,ii),r2_CalciumHbT_60s(:,:,ii),hemoPred_CalciumHbT_60s(:,:,:,ii)] = interSpeciesGammaFit_CalciumHbT_Mask(Calcium_filter(:,:,(ii-1)*60*25+1:ii*60*25),HbT_filter(:,:,(ii-1)*60*25+1:ii*60*25),t,mask);
            toc
        end
        [T_CalciumHbT_60s(:,:,10),W_CalciumHbT_60s(:,:,10),A_CalciumHbT_60s(:,:,10),r_CalciumHbT_60s(:,:,10),r2_CalciumHbT_60s(:,:,10),hemoPred_CalciumHbT_60s(:,:,1:1499,10)] = interSpeciesGammaFit_CalciumHbT_Mask(Calcium_filter(:,:,9*60*25+1:end),HbT_filter(:,:,9*60*25+1:end),t,mask);%14999 not dividible by 1500
        T_CalciumHbT_60s_mean = nanmean(T_CalciumHbT_60s,3);
        W_CalciumHbT_60s_mean = nanmean(W_CalciumHbT_60s,3);
        A_CalciumHbT_60s_mean = nanmean(A_CalciumHbT_60s,3);
        r_CalciumHbT_60s_mean = nanmean(r_CalciumHbT_60s,3);
        r2_CalciumHbT_60s_mean = nanmean(r2_CalciumHbT_60s,3);
         if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),'file')
         save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),...
             'T_CalciumHbT_60s','W_CalciumHbT_60s','A_CalciumHbT_60s','r_CalciumHbT_60s','r2_CalciumHbT_60s','hemoPred_CalciumHbT_60s',...
             'T_CalciumHbT_60s_mean','W_CalciumHbT_60s_mean','A_CalciumHbT_60s_mean','r_CalciumHbT_60s_mean','r2_CalciumHbT_60s_mean','-append')
         else
             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),...
             'T_CalciumHbT_60s','W_CalciumHbT_60s','A_CalciumHbT_60s','r_CalciumHbT_60s','r2_CalciumHbT_60s','hemoPred_CalciumHbT_60s',...
             'T_CalciumHbT_60s_mean','W_CalciumHbT_60s_mean','A_CalciumHbT_60s_mean','r_CalciumHbT_60s_mean','r2_CalciumHbT_60s_mean','-v7.3')
         end
            figure
            subplot(2,3,4)
            imagesc(r_CalciumHbT_60s_mean,'AlphaData',mask)
            cb=colorbar;
            caxis([-1 1])
            axis image off
            colormap jet
            title('r')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,5)
            imagesc(r2_CalciumHbT_60s_mean,'AlphaData',mask)
            cb=colorbar;
            caxis([0 1])
            axis image off
            colormap jet
            title('R^2')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,1)
            imagesc(T_CalciumHbT_60s_mean,'AlphaData',mask)
            cb=colorbar;
            caxis([0 2])
            axis image off
            cmocean('ice')
            title('T(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,2)
            imagesc(W_CalciumHbT_60s_mean,'AlphaData',mask)
            cb=colorbar;
            caxis([0 3])
            axis image off
            cmocean('ice')
            title('W(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,3)
            imagesc(A_CalciumHbT_60s_mean,'AlphaData',mask)
             cb=colorbar;
            caxis([0 0.07])
            axis image off
            cmocean('ice')
            title('A')
            set(gca,'FontSize',14,'FontWeight','Bold')           
            suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-60s'))
           
            saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_60s.png')));
            saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_60s.fig')));

        
%         for jj = 1:10
%             figure
%             subplot(2,3,1)
%             imagesc(T_CalciumHbT_60s_mean,[0,2])
%             colorbar
%             axis image off
%             colormap jet
%             title('T(s)')
%             hold on;
%             imagesc(xform_WL,'AlphaData',1-mask);
%             set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,2)
%             imagesc(W_CalciumHbT_60s_mean,[0 3])
%             colorbar
%             axis image off
%             colormap jet
%             title('W(s)')
%             hold on;
%             imagesc(xform_WL,'AlphaData',1-mask);
%             set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,3)
%             imagesc(A_CalciumHbT_60s_mean,[0 0.07])
%             colorbar
%             axis image off
%             colormap jet
%             title('A')
%             hold on;
%             imagesc(xform_WL,'AlphaData',1-mask);
%             set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,4)
%             imagesc(r_CalciumHbT_60s_mean,[0 1])
%             colorbar
%             axis image off
%             colormap jet
%             title('r')
%             hold on;
%             imagesc(xform_WL,'AlphaData',1-mask);
%             set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,5)
%             imagesc(r2_CalciumHbT_60s_mean,[0 1])
%             colorbar
%             axis image off
%             colormap jet
%             title('R^2')
%             hold on;
%             imagesc(xform_WL,'AlphaData',1-mask);
%             set(gca,'FontSize',14,'FontWeight','Bold')
%         end
    end
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.png')));
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.fig')));

end


