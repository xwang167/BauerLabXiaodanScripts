close all;clearvars -except hz;clc

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+ rightMask;

import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
isZTransform = true;
set(0,'defaultaxesfontsize',12);
miceCat = 'Glucose';

info.nVx = 128;
info.nVy = 128;

%
excelRows =321:327;

numMice = length(excelRows);
xform_isbrain_mice = 1;

for run = 1:9;
    
    sessionInfo.miceType = 'jrgeco1a';
    saveDir_cat = 'K:\Glucose\cat';
    
    T_mice = zeros(info.nVy,info.nVx,numMice);
    W_mice = zeros(info.nVy,info.nVx,numMice);
    A_mice = zeros(info.nVy,info.nVx,numMice);
    r_mice = zeros(info.nVy,info.nVx,numMice);
    r2_mice = zeros(info.nVy,info.nVx,numMice);
    
    T_CalciumFAD_mice = zeros(info.nVy,info.nVx,numMice);
    W_CalciumFAD_mice = zeros(info.nVy,info.nVx,numMice);
    A_CalciumFAD_mice = zeros(info.nVy,info.nVx,numMice);
    r_CalciumFAD_mice = zeros(info.nVy,info.nVx,numMice);
    r2_CalciumFAD_mice = zeros(info.nVy,info.nVx,numMice);
    
    
    miceName = [];
    %     miceName_powerdata = [];
    ll = 1;
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        miceName = char(strcat(miceName, '-', mouseName));
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        sessionInfo.darkFrameNum = excelRaw{11};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        systemType =excelRaw{5};
        sessionInfo.darkFrameNum = excelRaw{11};
        sessionInfo.framerate = excelRaw{7};
        %goodRuns = str2num(excelRaw{18});
        if strcmp(char(sessionInfo.miceType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            systemInfo.numLEDs = 3;
        end
        %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
        
        %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain(isinf(xform_isbrain)) = 0;
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'_processed.mat');
        
        
        load(fullfile(saveDir, processedName), 'T','W','A','r','r2',...
            'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD')
        T_mice(:,:,ll) = T;
        W_mice(:,:,ll) = W;
        A_mice(:,:,ll) = A;
        r_mice(:,:,ll) = r;
        r2_mice(:,:,ll) = r2;
        
        T_CalciumFAD_mice(:,:,ll) = T_CalciumFAD;
        W_CalciumFAD_mice(:,:,ll) = W_CalciumFAD;
        A_CalciumFAD_mice(:,:,ll) = A_CalciumFAD;
        r_CalciumFAD_mice(:,:,ll) = r_CalciumFAD;
        r2_CalciumFAD_mice(:,:,ll) =r2_CalciumFAD;
        
        ll = ll+1;
        
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
    
    if exist(fullfile(saveDir_cat, processedName_mice),'file')
    save(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice',...
        'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice','-append')
    else
            save(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice',...
        'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice')
    end
    
    T_mice = nanmedian(T_mice,3);
    W_mice = nanmedian(W_mice,3);
    A_mice = nanmedian(A_mice,3);
    r_mice = nanmedian(r_mice,3);
    r2_mice = nanmedian(r2_mice,3);
    
    T_CalciumFAD_mice = nanmedian(T_CalciumFAD_mice,3);
    W_CalciumFAD_mice = nanmedian(W_CalciumFAD_mice,3);
    A_CalciumFAD_mice = nanmedian(A_CalciumFAD_mice,3);
    r_CalciumFAD_mice = nanmedian(r_CalciumFAD_mice,3);
    r2_CalciumFAD_mice = nanmedian(r2_CalciumFAD_mice,3);
    
    
    
    saveDir_cat ='K:\Glucose\cat\';
    visName = 'Glucose_SeedFC-fc-baseline';
    figure
    subplot(2,3,1)
    imagesc(T_mice,[0,2])
    colorbar
    axis image off
    colormap jet
    title('T(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_mice,[0 3])
    colorbar
    axis image off
    colormap jet
    title('W(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A_mice,[0 0.1])
    colorbar
    axis image off
    colormap jet
    title('A')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4)
    imagesc(r_mice,[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2_mice,[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    suptitle(strcat('Glucose run #',num2str(run),', GammaFitting NVC'))
    set(gca,'FontSize',14,'FontWeight','Bold')
    saveas(gcf,fullfile('K:\Glucose\cat',strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_GammFitting_NVC.png')));
    saveas(gcf,fullfile('K:\Glucose\cat',strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_GammFitting_NVC.fig')));
    
    
    
    figure
    subplot(2,3,1)
    imagesc(T_CalciumFAD_mice,[0,0.2])
    colorbar
    axis image off
    colormap jet
    title('T(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_CalciumFAD_mice,[0 0.06])
    colorbar
    axis image off
    colormap jet
    title('W(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A_CalciumFAD_mice,[0 1.2])
    colorbar
    axis image off
    colormap jet
    title('A')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4)
    imagesc(r_CalciumFAD_mice,[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2_CalciumFAD_mice,[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    suptitle('Awake Calcium FAD Gamma Fitting')
    
    suptitle(strcat('Glucose run #',num2str(run),', GammaFitting NMC'))
    set(gca,'FontSize',14,'FontWeight','Bold')
    saveas(gcf,fullfile('K:\Glucose\cat',strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_GammFitting_NMC.png')));
    saveas(gcf,fullfile('K:\Glucose\cat',strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_GammFitting_NMC.fig')));
    close all
end



xform_isbrain_mice = 1;
miceName = [];
   for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        miceName = char(strcat(miceName, '-', mouseName));
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')       
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
   end

T_AveragedMask = nan(7,9);% mice^run
W_AveragedMask = nan(7,9);

T_CalciumFAD_AveragedMask = nan(7,9);% mice^run
W_CalciumFAD_AveragedMask = nan(7,9);

for run = 1:9
    for ii = 1:7
        processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
        load(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice',...
        'T_CalciumFAD_mice','W_CalciumFAD_mice')
        
        temp = squeeze(T_mice(:,:,ii));
        T_AveragedMask(ii,run) = nanmedian(temp(logical(xform_isbrain_mice.*mask_new)));
        
        temp = squeeze(W_mice(:,:,ii));
        W_AveragedMask(ii,run) = nanmedian(temp(logical(xform_isbrain_mice.*mask_new)));        
        
        temp = squeeze(T_CalciumFAD_mice(:,:,ii));
        T_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(xform_isbrain_mice.*mask_new)));
        
        temp = squeeze(W_CalciumFAD_mice(:,:,ii));
        W_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(xform_isbrain_mice.*mask_new)));
    
    end
end
   


figure
b = bar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_AveragedMask(:,1),1),nanstd(T_AveragedMask(:,2),1),nanstd(T_AveragedMask(:,3),1),...
    nanstd(T_AveragedMask(:,4),1),nanstd(T_AveragedMask(:,5),1),nanstd(T_AveragedMask(:,6),1),...
    nanstd(T_AveragedMask(:,7),1),nanstd(T_AveragedMask(:,8),1),nanstd(T_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NVC')


figure
b = bar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_AveragedMask(:,1),1),nanstd(W_AveragedMask(:,2),1),nanstd(W_AveragedMask(:,3),1),...
    nanstd(W_AveragedMask(:,4),1),nanstd(W_AveragedMask(:,5),1),nanstd(W_AveragedMask(:,6),1),...
    nanstd(W_AveragedMask(:,7),1),nanstd(W_AveragedMask(:,8),1),nanstd(W_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NVC')


figure
b = bar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_CalciumFAD_AveragedMask(:,1),1),nanstd(T_CalciumFAD_AveragedMask(:,2),1),nanstd(T_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,4),1),nanstd(T_CalciumFAD_AveragedMask(:,5),1),nanstd(T_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,7),1),nanstd(T_CalciumFAD_AveragedMask(:,8),1),nanstd(T_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NMC')


figure
b = bar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_CalciumFAD_AveragedMask(:,1),1),nanstd(W_CalciumFAD_AveragedMask(:,2),1),nanstd(W_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,4),1),nanstd(W_CalciumFAD_AveragedMask(:,5),1),nanstd(W_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,7),1),nanstd(W_CalciumFAD_AveragedMask(:,8),1),nanstd(W_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NMC')






T_AveragedMask = nan(7,9);% mice^run
W_AveragedMask = nan(7,9);

T_CalciumFAD_AveragedMask = nan(7,9);% mice^run
W_CalciumFAD_AveragedMask = nan(7,9);

for run = 1:9
    for ii = 1:7
        processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
        load(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice','r_mice',...
        'T_CalciumFAD_mice','W_CalciumFAD_mice','r_CalciumFAD_mice')
        mask = squeeze(r_mice(:,:,ii))>0.3;
        temp = squeeze(T_mice(:,:,ii));
        T_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
        
        temp = squeeze(W_mice(:,:,ii));
        W_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));        
        
        temp = squeeze(T_CalciumFAD_mice(:,:,ii));
        T_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
        
        temp = squeeze(W_CalciumFAD_mice(:,:,ii));
        W_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
    
    end
end
   


figure
b = bar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_AveragedMask(:,1),1),nanstd(T_AveragedMask(:,2),1),nanstd(T_AveragedMask(:,3),1),...
    nanstd(T_AveragedMask(:,4),1),nanstd(T_AveragedMask(:,5),1),nanstd(T_AveragedMask(:,6),1),...
    nanstd(T_AveragedMask(:,7),1),nanstd(T_AveragedMask(:,8),1),nanstd(T_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NVC, r>0.3')


figure
b = bar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_AveragedMask(:,1),1),nanstd(W_AveragedMask(:,2),1),nanstd(W_AveragedMask(:,3),1),...
    nanstd(W_AveragedMask(:,4),1),nanstd(W_AveragedMask(:,5),1),nanstd(W_AveragedMask(:,6),1),...
    nanstd(W_AveragedMask(:,7),1),nanstd(W_AveragedMask(:,8),1),nanstd(W_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NVC, r>0.3')


figure
b = bar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_CalciumFAD_AveragedMask(:,1),1),nanstd(T_CalciumFAD_AveragedMask(:,2),1),nanstd(T_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,4),1),nanstd(T_CalciumFAD_AveragedMask(:,5),1),nanstd(T_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,7),1),nanstd(T_CalciumFAD_AveragedMask(:,8),1),nanstd(T_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NMC, r>0.3')


figure
b = bar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_CalciumFAD_AveragedMask(:,1),1),nanstd(W_CalciumFAD_AveragedMask(:,2),1),nanstd(W_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,4),1),nanstd(W_CalciumFAD_AveragedMask(:,5),1),nanstd(W_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,7),1),nanstd(W_CalciumFAD_AveragedMask(:,8),1),nanstd(W_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NMC, r>0.3')







T_AveragedMask = nan(7,9);% mice^run
W_AveragedMask = nan(7,9);

T_CalciumFAD_AveragedMask = nan(7,9);% mice^run
W_CalciumFAD_AveragedMask = nan(7,9);

for run = 1:9
    for ii = 1:7
        processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
        load(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice','r_mice',...
        'T_CalciumFAD_mice','W_CalciumFAD_mice','r_CalciumFAD_mice')
        mask = squeeze(r_mice(:,:,ii))>0.5;
        temp = squeeze(T_mice(:,:,ii));
        T_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
        
        temp = squeeze(W_mice(:,:,ii));
        W_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));        
        
        temp = squeeze(T_CalciumFAD_mice(:,:,ii));
        T_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
        
        temp = squeeze(W_CalciumFAD_mice(:,:,ii));
        W_CalciumFAD_AveragedMask(ii,run) = nanmedian(temp(logical(mask)));
    
    end
end
   


figure
b = bar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_AveragedMask(:,1),1),nanmedian(T_AveragedMask(:,2),1),nanmedian(T_AveragedMask(:,3),1),...
    nanmedian(T_AveragedMask(:,4),1),nanmedian(T_AveragedMask(:,5),1),nanmedian(T_AveragedMask(:,6),1),...
    nanmedian(T_AveragedMask(:,7),1),nanmedian(T_AveragedMask(:,8),1),nanmedian(T_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_AveragedMask(:,1),1),nanstd(T_AveragedMask(:,2),1),nanstd(T_AveragedMask(:,3),1),...
    nanstd(T_AveragedMask(:,4),1),nanstd(T_AveragedMask(:,5),1),nanstd(T_AveragedMask(:,6),1),...
    nanstd(T_AveragedMask(:,7),1),nanstd(T_AveragedMask(:,8),1),nanstd(T_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NVC, r>0.3')


figure
b = bar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_AveragedMask(:,1),1),nanmedian(W_AveragedMask(:,2),1),nanmedian(W_AveragedMask(:,3),1),...
    nanmedian(W_AveragedMask(:,4),1),nanmedian(W_AveragedMask(:,5),1),nanmedian(W_AveragedMask(:,6),1),...
    nanmedian(W_AveragedMask(:,7),1),nanmedian(W_AveragedMask(:,8),1),nanmedian(W_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_AveragedMask(:,1),1),nanstd(W_AveragedMask(:,2),1),nanstd(W_AveragedMask(:,3),1),...
    nanstd(W_AveragedMask(:,4),1),nanstd(W_AveragedMask(:,5),1),nanstd(W_AveragedMask(:,6),1),...
    nanstd(W_AveragedMask(:,7),1),nanstd(W_AveragedMask(:,8),1),nanstd(W_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NVC, r>0.3')


figure
b = bar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(T_CalciumFAD_AveragedMask(:,1),1),nanmedian(T_CalciumFAD_AveragedMask(:,2),1),nanmedian(T_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,4),1),nanmedian(T_CalciumFAD_AveragedMask(:,5),1),nanmedian(T_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(T_CalciumFAD_AveragedMask(:,7),1),nanmedian(T_CalciumFAD_AveragedMask(:,8),1),nanmedian(T_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(T_CalciumFAD_AveragedMask(:,1),1),nanstd(T_CalciumFAD_AveragedMask(:,2),1),nanstd(T_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,4),1),nanstd(T_CalciumFAD_AveragedMask(:,5),1),nanstd(T_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(T_CalciumFAD_AveragedMask(:,7),1),nanstd(T_CalciumFAD_AveragedMask(:,8),1),nanstd(T_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('T(s)')
title('Time to peak of NMC, r>0.3')


figure
b = bar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],0.5);
hold on
er = errorbar(1:9,[nanmedian(W_CalciumFAD_AveragedMask(:,1),1),nanmedian(W_CalciumFAD_AveragedMask(:,2),1),nanmedian(W_CalciumFAD_AveragedMask(:,3),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,4),1),nanmedian(W_CalciumFAD_AveragedMask(:,5),1),nanmedian(W_CalciumFAD_AveragedMask(:,6),1),...
    nanmedian(W_CalciumFAD_AveragedMask(:,7),1),nanmedian(W_CalciumFAD_AveragedMask(:,8),1),nanmedian(W_CalciumFAD_AveragedMask(:,9),1)],zeros(1,9),...
    [nanstd(W_CalciumFAD_AveragedMask(:,1),1),nanstd(W_CalciumFAD_AveragedMask(:,2),1),nanstd(W_CalciumFAD_AveragedMask(:,3),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,4),1),nanstd(W_CalciumFAD_AveragedMask(:,5),1),nanstd(W_CalciumFAD_AveragedMask(:,6),1),...
    nanstd(W_CalciumFAD_AveragedMask(:,7),1),nanstd(W_CalciumFAD_AveragedMask(:,8),1),nanstd(W_CalciumFAD_AveragedMask(:,9),1)]);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
xticklabels({'1','2','3','4','5','6','7','8','9'})
xlabel('run #')
ylabel('W(s)')
title('Width of NMC, r>0.3')


figure

cc= jet(9);

for run = 1:9
    
        processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
        load(fullfile(saveDir_cat, processedName_mice),'T_mice','W_mice','A_mice')

    T_mice = nanmedian(T_mice,'all');
    W_mice = nanmedian(W_mice,'all');
    A_mice = nanmedian(A_mice,'all');

    t = 0:0.01:5;
alpha = (T_mice/W_mice)^2*8*log(2);
beta = W_mice^2/(T_mice*8*log(2));
y = A_mice*(t/T_mice).^alpha.*exp((t-T_mice)/(-beta));
    plot(t,y,'color',cc(run,:))
    hold on
    

end
legend('run 1','run 2','run 3','run 4','run 5','run 6','run 7','run 8','run 9')
title('Gamma NVC')
xlabel('Time(s)')
ylabel('Amplitude')
    


figure
cc= jet(9);

for run = 1:9
    
        processedName_CalciumFAD_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
        load(fullfile(saveDir_cat, processedName_CalciumFAD_mice),'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice')

    T_CalciumFAD_mice = nanmedian(T_CalciumFAD_mice,'all');
    W_CalciumFAD_mice = nanmedian(W_CalciumFAD_mice,'all');
    A_CalciumFAD_mice = nanmedian(A_CalciumFAD_mice,'all');

    t = 0:0.001:0.2;
alpha = (T_CalciumFAD_mice/W_CalciumFAD_mice)^2*8*log(2);
beta = W_CalciumFAD_mice^2/(T_CalciumFAD_mice*8*log(2));
y = A_CalciumFAD_mice*(t/T_CalciumFAD_mice).^alpha.*exp((t-T_CalciumFAD_mice)/(-beta));
    plot(t,y,'color',cc(run,:))
    hold on
    

end
legend('run 1','run 2','run 3','run 4','run 5','run 6','run 7','run 8','run 9')
title('Gamma NMC')
xlabel('Time(s)')
ylabel('Amplitude')
    