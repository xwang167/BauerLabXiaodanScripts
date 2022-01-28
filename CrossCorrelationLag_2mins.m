
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
lagTimeTrial_HbTCalcium_2min = nan(128,128,5);
lagAmpTrial_HbTCalcium_2min = nan(128,128,5);
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
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        %Norm
        Calcium_filter = normRow(Calcium_filter);
        HbT_filter = normRow(HbT_filter);
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        
        for ii = 1:4
            [lagTimeTrial_HbTCalcium_2min(:,:,ii), lagAmpTrial_HbTCalcium_2min(:,:,ii),~] = mouse.conn.dotLag(...
                HbT_filter(:,:,(ii-1)*120*25+1:ii*120*25),Calcium_filter(:,:,(ii-1)*120*25+1:ii*120*25),...
                edgeLen,validRange,corrThr, true,true);
        end
        [lagTimeTrial_HbTCalcium_2min(:,:,5), lagAmpTrial_HbTCalcium_2min(:,:,5),~] = mouse.conn.dotLag(...
            HbT_filter(:,:,5*120*25+1:end),Calcium_filter(:,:,5*120*25+1:end),...
            edgeLen,validRange,corrThr, true,true);
        
        lagTimeTrial_HbTCalcium_2min = lagTimeTrial_HbTCalcium_2min./ sessionInfo.framerate;
        
        lagTimeTrial_HbTCalcium_2min_median = nanmedian(lagTimeTrial_HbTCalcium_2min,3);
        lagAmpTrial_HbTCalcium_2min_median = nanmedian(lagAmpTrial_HbTCalcium_2min,3);
        
        
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                'lagTimeTrial_HbTCalcium_2min_median','lagAmpTrial_HbTCalcium_2min_median',...
                'lagTimeTrial_HbTCalcium_2min','lagAmpTrial_HbTCalcium_2min','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                     'lagTimeTrial_HbTCalcium_2min_median','lagAmpTrial_HbTCalcium_2min_median',...
                     'lagTimeTrial_HbTCalcium_2min','lagAmpTrial_HbTCalcium_2min','-v7.3')      
        end
        
            figure
            subplot(2,1,2)
            imagesc(lagAmpTrial_HbTCalcium_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([-1 1])
            axis image off
            colormap jet
            title('r')
            set(gca,'FontSize',14,'FontWeight','Bold')
            subplot(2,1,1)
            imagesc(lagTimeTrial_HbTCalcium_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([0 2])
            axis image off
            cmocean('ice')
            title('T(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')        
            suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-CrossCorrelation-2min'))
          saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_CrossCorrelation_2min.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_CrossCorrelation_2min.fig')));

%         for jj = 1:10
%             figure
%             subplot(2,1,1)
%             imagesc(lagTimeTrial_HbTCalcium_2min(:,:,jj),[0,2])
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
%             imagesc(lagAmpTrial_HbTCalcium_2min(:,:,jj),[0 1])
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
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.png')));
    %         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.fig')));
    %         save(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred','-append')
end


