
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 183; 
runs = 3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
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
    maskDir = saveDir;

    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end

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
        t = (1:750)./25;
       %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,HbT_filter*10^6,t);
       %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,HbT_filter,t);
       Calcium_filter = reshape(Calcium_filter,128*128,[]);
       HbT_filter = reshape(HbT_filter,128*128,[]);
       Calcium_filter = normRow(Calcium_filter);
       HbT_filter = normRow(HbT_filter);
       Calcium_filter = reshape(Calcium_filter,128,128,[]);
       HbT_filter = reshape(HbT_filter,128,128,[]);
       T_bad = nan(1,7);
       W_bad = nan(1,7);
       r_bad = nan(1,7);
       
       index_bad = {[39,80],[40,79],[40,78],[40,77],[40,76],[41,76],[42,76]};
       for ii = 1:7
          figure('Renderer', 'painters', 'Position', [100 100 1500 800])
           subplot('position', [0.05 0.55 0.2 0.4]);
           imagesc(T_norm,[0 2])
           hold on
           imagesc(xform_WL,'AlphaData',1-mask);
           axis image off
           hold on
           scatter(index_bad{ii}(1),index_bad{ii}(2),'k')
           title('T(s)')
           t = (1:750)/25;
           [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),:),...
           HbT_filter(index_bad{ii}(2),index_bad{ii}(1),:),t);
            T = T(1,1);
            W = W(1,1);
            A = A(1,1);
            r = r(1,1);
            alpha = (T/W)^2*8*log(2);
            beta = W^2/(T*8*log(2));
            t = 0:0.001:30;
            y = A*(t/T).^alpha.*exp((t-T)/(-beta));
            subplot('position', [0.3 0.55 0.65 0.4]);
            plot(t,y);
            title(strcat('T = ',num2str(T),', W = ',num2str(W),', r = ',num2str(r)))
            subplot('position', [0.05 0.05 0.9 0.4]);
            plot((1:14999)/25,squeeze(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),:)),'m-')
            hold on
            plot((1:14999)/25,squeeze(HbT_filter(index_bad{ii}(2),index_bad{ii}(1),:)),'k-')
            suptitle(strcat(recDate,', ',mouseName(, )))
       end
       
       %save(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred','-append')
        figure
        subplot(2,3,1)
        imagesc(T,[0,2])
        colorbar
        axis image off
        colormap jet
        title('T(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,2)
        imagesc(W,[0 3])
        colorbar
        axis image off
        colormap jet
        title('W(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,3)
        imagesc(A,[0 5])
        colorbar
        axis image off
        colormap jet
        title('A')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,4)
        imagesc(r,[-1 1])
        colorbar
        axis image off
        colormap jet
        title('r')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,5)
        imagesc(r2,[0 1])
        colorbar
        axis image off
        colormap jet
        title('R^2')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.fig')));

    end
end