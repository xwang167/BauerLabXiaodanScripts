
close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 185;
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
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr','FADCorr_ISA_powerMap')
        
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
%         figure
%         imagesc(FADCorr_ISA_powerMap,[0 0.005])
%         cb = colorbar( 'SouthOutside','AxisLocation','out',...
%             'FontSize',15,'fontweight','bold');
%         cb.Ruler.MinorTick = 'on';
%         ylabel(cb,'\DeltaF/F','FontSize',12,'fontweight','bold')
%         colormap jet
%         hold on
%         mask = roipoly(FADCorr_ISA_powerMap);
        mask = logical(mask_new.*xform_isbrain);
        tic
        [T_norm,W_norm,A_norm,r_norm,r2_norm,hemoPred_norm] = interSpeciesGammaFit_testCalciumHbT_Mask(Calcium_filter,HbT_filter,t,mask);
        toc
        figure
        imagesc(T_norm,[0 2])
        hold on
        imagesc(xform_WL,'AlphaData',1-mask_new);
        axis image off
        title('T(s)')
        colormap jet
        cb = colorbar( 'SouthOutside','AxisLocation','out',...
            'FontSize',15,'fontweight','bold');
        cb.Ruler.MinorTick = 'on';
        ylabel(cb,'Time(s)','FontSize',12,'fontweight','bold')
        %index_bad = {[43,80],[41,82]};
        % mouse2: index_bad = {[40,74],[43,76],[41,77],[40,78],[39,78]};
       % index_bad = {[39,80],[40,79],[40,78],[40,77],[40,76],[41,76],[42,76]};
       index_bad = {[107,64],[118,79],[102,53],[115,79]};
        T_bad = nan(1,length(index_bad));
        W_bad = nan(1,length(index_bad));
        r_bad = nan(1,length(index_bad));
        
        for ii = 1:length(index_bad)
            index_range = 1:14999;
            figure('Renderer', 'painters', 'Position', [100 100 1500 800])
            subplot('position', [0.05 0.55 0.2 0.4]);
            imagesc(T_norm,[0 2])
            colormap jet
            hold on
            imagesc(xform_WL,'AlphaData',1-mask_new);
            axis image off
            
            hold on
            scatter(index_bad{ii}(1),index_bad{ii}(2),'k')
            title('T(s)')
            t = (1:750)/25;
            [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_testCalciumHbT(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),index_range),...
                HbT_filter(index_bad{ii}(2),index_bad{ii}(1),index_range),t);
            
            T = T(1,1);
            W = W(1,1);
            A = A(1,1);
            r = r(1,1);
            T_bad(ii) = T;
            W_bad(ii) = W;
            r_bad(ii) = r;
            alpha = (T/W)^2*8*log(2);
            beta = W^2/(T*8*log(2));
            t = 0:0.001:30;
            y = A*(t/T).^alpha.*exp((t-T)/(-beta));
            subplot('position', [0.3 0.55 0.65 0.4]);
            plot(t,y);
            xlabel('Times(s)')
            ylabel('Amplitude')
            title(strcat('T = ',num2str(T),', W = ',num2str(W),', r = ',num2str(r)))
            subplot('position', [0.05 0.06 0.9 0.4]);
            plot((1:length(index_range))/25,squeeze(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),index_range)),'m-')
            hold on
            plot((1:length(index_range))/25,squeeze(HbT_filter(index_bad{ii}(2),index_bad{ii}(1),index_range)),'k-')
            hold on
            plot((1:length(index_range))/25,squeeze(hemoPred(1,1,:)),'g-')
            legend('Calcium','HbT','Predicted HbT')
            suptitle(strcat(recDate,', ',mouseName,', fc',num2str(n)))
            xlabel('Time(s)')
            ylabel('Normalized')
            
        end
        save('X:\XW\GammaFit\mouse2.mat','T_bad','W_bad','r_bad','recDate','mouseName','n',...
            'T_norm','W_norm','A_norm','r_norm','r2_norm','hemoPred_norm')
    end
end



