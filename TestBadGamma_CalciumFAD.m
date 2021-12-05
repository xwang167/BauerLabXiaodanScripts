close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 195;
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
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr','T_CalciumFAD')
        
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        clear xform_FADCorr
        %FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        t = (0:75)./25;
        %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,FAD_filter*10^6,t);
        %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,FAD_filter,t);
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        FAD_filter = reshape(FAD_filter,128*128,[]);
        Calcium_filter = normRow(Calcium_filter);
        FAD_filter = normRow(FAD_filter);
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        FAD_filter = reshape(FAD_filter,128,128,[]);
        %[T_CalciumFAD,W_CalciumFAD,A_CalciumFAD,r_CalciumFAD,r2_CalciumFAD,hemoPred_CalciumFAD] = interSpeciesGammaFit_CalciumFAD(Calcium_filter,FAD_filter,t);
        %index_bad = {[21,86],[22,86],[23,86],[24,86],[25,86],[26,86],[27,86],[28,86],[29,86],[30,86],[31,86]};
        %index_bad = {[83,89],[36,68],[15,84],[42,91]};
        index_bad = {[84,87],[85,87],[86,87],[87,87],[88,87],[89,87],[90,87]};
        T_bad = nan(1,length(index_bad));
        W_bad = nan(1,length(index_bad));
        r_bad = nan(1,length(index_bad));
        for ii = 1:length(index_bad)
            index_range = 1:14999;
            figure('Renderer', 'painters', 'Position', [100 100 1500 800])
            subplot('position', [0.05 0.55 0.2 0.4]);
            imagesc(T_CalciumFAD,[0 0.11])
            colormap jet
          
            axis image off
            colorbar
            hold on
            scatter(index_bad{ii}(1),index_bad{ii}(2),'w','filled')
            title('T(s)')
            t = (0:75)/25;
            [T,W,A,r,r2,FADPred] = interSpeciesGammaFit_CalciumFAD_Mask(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),index_range),...
                FAD_filter(index_bad{ii}(2),index_bad{ii}(1),index_range),t,1);
            
            T = T(1,1);
            W = W(1,1);
            A = A(1,1);
            r = r(1,1);
            T_bad(ii) = T;
            W_bad(ii) = W;
            r_bad(ii) = r;
            alpha = (T/W)^2*8*log(2);
            beta = W^2/(T*8*log(2));
            t = 0:0.001:3;
            y = A*(t/T).^alpha.*exp((t-T)/(-beta));
           
            subplot('position', [0.3 0.55 0.65 0.4]);
            plot(t,y);
             xlabel('Times(s)')
            ylabel('Amplitude')
             xlim([0 0.2])
            title(strcat('T = ',num2str(round(T,3)),'s, W = ',num2str(round(W,3)),'s, r = ',num2str(round(r,3))))
            subplot('position', [0.05 0.06 0.9 0.4]);
            plot((1:length(index_range))/25,squeeze(Calcium_filter(index_bad{ii}(2),index_bad{ii}(1),index_range)),'m-')
            hold on
            plot((1:length(index_range))/25,squeeze(FAD_filter(index_bad{ii}(2),index_bad{ii}(1),index_range)),'k-')
            hold on
            plot((1:length(index_range))/25,squeeze(FADPred(1,1,:)),'g-')
            legend('Calcium','FAD','Predicted FAD')
            suptitle(strcat(recDate,', ',mouseName,', fc',num2str(n),', Calcium FAD'))
            xlabel('Time(s)')
            ylabel('Normalized')
            xlim([0,30])
            
        end
%         save('X:\XW\GammaFit\mouse2.mat','T_bad','W_bad','r_bad','recDate','mouseName','n',...
%             'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD','hemoPred_CalciumFAD')
    end
end