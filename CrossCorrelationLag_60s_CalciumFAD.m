

%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
lagTimeTrial_FADCalcium_60s = nan(128,128,10);
lagAmpTrial_FADCalcium_60s = nan(128,128,10);
edgeLen =1;
tZone = 4;
corrThr = 0;

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
    validRange = - edgeLen: round(tZone*sessionInfo.framerate);
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
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        clear xform_FADCorr
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        FAD_filter = squeeze(FAD_filter);
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        FAD_filter = reshape(FAD_filter,128*128,[]);
        %Norm
        Calcium_filter = normRow(Calcium_filter);
        FAD_filter = normRow(FAD_filter);
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        FAD_filter = reshape(FAD_filter,128,128,[]);
        
        for ii = 1:9
            [lagTimeTrial_FADCalcium_60s(:,:,ii), lagAmpTrial_FADCalcium_60s(:,:,ii),~] = mouse.conn.dotLag(...
                FAD_filter(:,:,(ii-1)*60*25+1:ii*60*25),Calcium_filter(:,:,(ii-1)*60*25+1:ii*60*25),...
                edgeLen,validRange,corrThr, true,true);
        end
        [lagTimeTrial_FADCalcium_60s(:,:,10), lagAmpTrial_FADCalcium_60s(:,:,10),~] = mouse.conn.dotLag(...
            FAD_filter(:,:,9*60*25+1:end),Calcium_filter(:,:,9*60*25+1:end),...
            edgeLen,validRange,corrThr, true,true);
        
        lagTimeTrial_FADCalcium_60s = lagTimeTrial_FADCalcium_60s./ sessionInfo.framerate;
        
        lagTimeTrial_FADCalcium_60s_mean = nanmean(lagTimeTrial_FADCalcium_60s,3);
        lagAmpTrial_FADCalcium_60s_mean = nanmean(lagAmpTrial_FADCalcium_60s,3);
        
        
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),...
                'lagTimeTrial_FADCalcium_60s_mean','lagAmpTrial_FADCalcium_60s_mean',...
                'lagTimeTrial_FADCalcium_60s','lagAmpTrial_FADCalcium_60s','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_60s','.mat')),...
                'lagTimeTrial_FADCalcium_60s_mean','lagAmpTrial_FADCalcium_60s_mean',...
                'lagTimeTrial_FADCalcium_60s','lagAmpTrial_FADCalcium_60s','-v7.3')
        end
        
        figure
        subplot(2,1,2)
        imagesc(lagAmpTrial_FADCalcium_60s_mean,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,1,1)
        imagesc(lagTimeTrial_FADCalcium_60s_mean,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.3])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-CrossCorrelation-60s'))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_CrossCorrelation_60s.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_CrossCorrelation_60s.fig')));
        %         for jj = 1:10
        %             figure
        %             subplot(2,1,1)
        %             imagesc(lagTimeTrial_FADCalcium_60s(:,:,jj),[0,2])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('T(s)')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %
        %             subplot(2,1,2)
        %             imagesc(lagAmpTrial_FADCalcium_60s(:,:,jj),[0 1])
        %             colorbar
        %             axis image off
        %             colormap jet
        %             title('r')
        %             hold on;
        %             imagesc(xform_WL,'AlphaData',1-mask);
        %             set(gca,'FontSize',14,'FontWeight','Bold')
        %
        %         end
    end
end
