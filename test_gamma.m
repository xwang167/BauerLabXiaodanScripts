
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');
%clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181]; %183 185 228 232 236 202 195 204 230 234 240];
runs = 1;%:3;%

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
        T_CalciumFAD_2min = nan(128,128,5);
        W_CalciumFAD_2min = nan(128,128,5);
        A_CalciumFAD_2min = nan(128,128,5);
        r_CalciumFAD_2min = nan(128,128,5);
        r2_CalciumFAD_2min = nan(128,128,5);
        hemoPred_CalciumFAD_2min = nan(128,128,3000,5);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        clear xform_FADCorr
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        
        time_epoch = 30;
        t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(25/sessionInfo.framerate));
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        FAD_filter = reshape(FAD_filter,128*128,[]);
        
%         Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
%         FAD_filter=resample(FAD_filter',5,sessionInfo.framerate)';
        
        %Norm
        Calcium_filter = normRow(Calcium_filter);
        FAD_filter = normRow(FAD_filter);
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        FAD_filter = reshape(FAD_filter,128,128,[]);
        
        for ii = 1:4
            tic
            [T_CalciumFAD_2min(:,:,ii),W_CalciumFAD_2min(:,:,ii),A_CalciumFAD_2min(:,:,ii),...
                r_CalciumFAD_2min(:,:,ii),r2_CalciumFAD_2min(:,:,ii),hemoPred_CalciumFAD_2min(:,:,:,ii)] ...
                = interSpeciesGammaFit_CalciumFAD_Mask(Calcium_filter(:,:,(ii-1)*120*25+1:ii*120*25),...
                FAD_filter(:,:,(ii-1)*120*25+1:ii*120*25),t,mask);
            toc
        end
        [T_CalciumFAD_2min(:,:,5),W_CalciumFAD_2min(:,:,5),A_CalciumFAD_2min(:,:,5),...
            r_CalciumFAD_2min(:,:,5),r2_CalciumFAD_2min(:,:,5),hemoPred_CalciumFAD_2min(:,:,1:2999,5)] ...
            = interSpeciesGammaFit_CalciumFAD_Mask(Calcium_filter(:,:,4*120*25+1:end),FAD_filter(:,:,4*120*25+1:end),t,mask);%14999 not dividible by 3000
        
        T_CalciumFAD_2min_median = nanmedian(T_CalciumFAD_2min,3);
        W_CalciumFAD_2min_median = nanmedian(W_CalciumFAD_2min,3);
        A_CalciumFAD_2min_median = nanmedian(A_CalciumFAD_2min,3);
        r_CalciumFAD_2min_median = nanmedian(r_CalciumFAD_2min,3);
        r2_CalciumFAD_2min_median = nanmedian(r2_CalciumFAD_2min,3);
        %          if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),'file')
        %          save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
        %              'T_CalciumFAD_2min','W_CalciumFAD_2min','A_CalciumFAD_2min','r_CalciumFAD_2min','r2_CalciumFAD_2min','hemoPred_CalciumFAD_2min',...
        %              'T_CalciumFAD_2min_median','W_CalciumFAD_2min_median','A_CalciumFAD_2min_median','r_CalciumFAD_2min_median','r2_CalciumFAD_2min_median','-append')
        %          else
        %              save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
        %              'T_CalciumFAD_2min','W_CalciumFAD_2min','A_CalciumFAD_2min','r_CalciumFAD_2min','r2_CalciumFAD_2min','hemoPred_CalciumFAD_2min',...
        %              'T_CalciumFAD_2min_median','W_CalciumFAD_2min_median','A_CalciumFAD_2min_median','r_CalciumFAD_2min_median','r2_CalciumFAD_2min_median','-v7.3')
        %          end
        figure
        subplot(2,3,4)
        imagesc(r_CalciumFAD_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumFAD_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumFAD_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.3])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumFAD_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.06])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumFAD_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1.4])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-GammaFit-2min-NoDownsample'))
        
        %             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_2min-downsample.png')));
        %             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_2min-downsample.fig')));
        
        
        %         for jj = 1:10
        %             figure
        %             subplot(2,3,1)
        %             imagesc(T_CalciumFAD_2min_median,[0,2])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('T(s)')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %             subplot(2,3,2)
        %             imagesc(W_CalciumFAD_2min_median,[0 3])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('W(s)')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %             subplot(2,3,3)
        %             imagesc(A_CalciumFAD_2min_median,[0 0.07])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('A')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %             subplot(2,3,4)
        %             imagesc(r_CalciumFAD_2min_median,[0 1])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('r')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %             subplot(2,3,5)
        %             imagesc(r2_CalciumFAD_2min_median,[0 1])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('R^2')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %         end
    end
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit.png')));
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit.fig')));
    
end


