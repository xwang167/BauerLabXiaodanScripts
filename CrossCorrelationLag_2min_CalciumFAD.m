

%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%
freq = 250;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
lagTimeTrial_FADCalcium_2min = nan(128,128,5);
lagAmpTrial_FADCalcium_2min = nan(128,128,5);
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
        % Convert to DeltaF/F%
        Calcium = double(squeeze(xform_jrgeco1aCorr))*100;
        clear xform_jrgeco1aCorr
        FAD     = double(xform_FADCorr)              *100;
        clear xform_FADCorr
        
        % Pad to full 10mins
        Calcium(:,:,end+1) = Calcium(:,:,end);
        FAD(:,:,end+1)     = FAD    (:,:,end);
        
        % Filter
        Calcium_filter = filterData(Calcium,0.02,2,sessionInfo.framerate);
        clear Calcium
        FAD_filter     = filterData(FAD    ,0.02,2,sessionInfo.framerate);
        clear FAD

%         % Resample to 250Hx
%         Calcium_filter = resample(Calcium_filter,freq,sessionInfo.framerate);
%         FAD_filter     = resample(FAD_filter,    freq,sessionInfo.framerate);
%         
%         % Filter again
%         Calcium_filter = filterData(Calcium_filter,0.02,2,freq);
%         FAD_filter =     filterData(FAD_filter    ,0.02,2,freq);

        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        FAD_filter     = reshape(FAD_filter,    128*128,[]);
        % Norm
        Calcium_filter = normRow(Calcium_filter);
        FAD_filter     = normRow(FAD_filter);
        
        % Resahpe
        Calcium_filter = reshape(Calcium_filter,128,128,120*sessionInfo.framerate,[]);
        FAD_filter     = reshape(FAD_filter,    128,128,120*sessionInfo.framerate,[]);
        
        for ii = 1:5
            [lagTimeTrial_FADCalcium_2min(:,:,ii), lagAmpTrial_FADCalcium_2min(:,:,ii),~] = mouse.conn.dotLag(...
                FAD_filter(:,:,(ii-1)*120*freq+1:ii*120*freq),Calcium_filter(:,:,(ii-1)*120*freq+1:ii*120*freq),...
                edgeLen,validRange,corrThr, true,true);
        end
        
        lagTimeTrial_FADCalcium_2min = lagTimeTrial_FADCalcium_2min./ sessionInfo.framerate;
        
        lagTimeTrial_FADCalcium_2min_median = nanmedian(lagTimeTrial_FADCalcium_2min,3);
        lagAmpTrial_FADCalcium_2min_median = nanmedian(lagAmpTrial_FADCalcium_2min,3);
        
        
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                'lagTimeTrial_FADCalcium_2min_median','lagAmpTrial_FADCalcium_2min_median',...
                'lagTimeTrial_FADCalcium_2min','lagAmpTrial_FADCalcium_2min','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                'lagTimeTrial_FADCalcium_2min_median','lagAmpTrial_FADCalcium_2min_median',...
                'lagTimeTrial_FADCalcium_2min','lagAmpTrial_FADCalcium_2min','-v7.3')
        end
        
        figure
        subplot(2,1,2)
        imagesc(lagAmpTrial_FADCalcium_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,1,1)
        imagesc(lagTimeTrial_FADCalcium_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.3])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-CrossCorrelation-2min'))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_CrossCorrelation_2min.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_CrossCorrelation_2min.fig')));
        %         for jj = 1:10
        %             figure
        %             subplot(2,1,1)
        %             imagesc(lagTimeTrial_FADCalcium_2min(:,:,jj),[0,2])
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
        %             imagesc(lagAmpTrial_FADCalcium_2min(:,:,jj),[0 1])
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
