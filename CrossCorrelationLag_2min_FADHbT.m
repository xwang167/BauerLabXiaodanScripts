

%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_FADCorr','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
excelRows = [2,3,4,5,7,8,11,12,14,15];%[181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%
excelFile = "L:\WT\WT.xlsx";
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
lagTimeTrial_FADHbT_2min = nan(128,128,5);
lagAmpTrial_FADHbT_2min = nan(128,128,5);
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
    
    %     if ~exist(fullfile(saveDir_new,maskName),'file')
    %         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    %         load(fullfile(saveDir,maskName),'xform_isbrain')
    %     else
    %         load(fullfile(saveDir_new,maskName),'xform_isbrain')
    %     end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_isbrain')
        mask = logical(mask_new.*xform_isbrain);
        % Convert to DeltaF/F%
        HbT = double(squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:)))*10^6;
        clear xform_datahb
        FAD = double(xform_FADCorr)                                       *100;
        clear xform_FADCorr
        
        % Pad to full 10mins
        HbT(:,:,end+1) = HbT(:,:,end);
        FAD(:,:,end+1) = FAD(:,:,end);
        
        % Filter
        HbT_filter = filterData(HbT,0.02,2,sessionInfo.framerate);
        clear HbT
        FAD_filter = filterData(FAD,0.02,2,sessionInfo.framerate);
        clear FAD
        
        %         % Resample to 250Hx
        %         HbT_filter = resample(HbT_filter,freq,sessionInfo.framerate);
        %         FAD_filter     = resample(FAD_filter,    freq,sessionInfo.framerate);
        %
        %         % Filter again
        %         HbT_filter = filterData(HbT_filter,0.02,2,freq);
        %         FAD_filter =     filterData(FAD_filter    ,0.02,2,freq);
        
        HbT_filter = reshape(HbT_filter,128*128,[]);
        FAD_filter = reshape(FAD_filter,128*128,[]);
        % Norm
        HbT_filter = normRow(HbT_filter);
        FAD_filter = normRow(FAD_filter);
        
        % Resahpe
        HbT_filter = reshape(HbT_filter,128,128,120*sessionInfo.framerate,[]);
        FAD_filter = reshape(FAD_filter,128,128,120*sessionInfo.framerate,[]);
        
        for ii = 1:5
            [lagTimeTrial_FADHbT_2min(:,:,ii), lagAmpTrial_FADHbT_2min(:,:,ii),~] = mouse.conn.dotLag(...
                HbT_filter(:,:,:,ii),FAD_filter(:,:,:,ii),...
                edgeLen,validRange,corrThr, true,true);
        end
        
        lagTimeTrial_FADHbT_2min = lagTimeTrial_FADHbT_2min./ sessionInfo.framerate;
        
        lagTimeTrial_FADHbT_2min_median = nanmedian(lagTimeTrial_FADHbT_2min,3);
        lagAmpTrial_FADHbT_2min_median = nanmedian(lagAmpTrial_FADHbT_2min,3);
        
        
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                'lagTimeTrial_FADHbT_2min_median','lagAmpTrial_FADHbT_2min_median',...
                'lagTimeTrial_FADHbT_2min','lagAmpTrial_FADHbT_2min','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat')),...
                'lagTimeTrial_FADHbT_2min_median','lagAmpTrial_FADHbT_2min_median',...
                'lagTimeTrial_FADHbT_2min','lagAmpTrial_FADHbT_2min','-v7.3')
        end
        
        figure
        subplot(2,1,2)
        imagesc(lagAmpTrial_FADHbT_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,1,1)
        imagesc(lagTimeTrial_FADHbT_2min_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-HbTFAD-CrossCorrelation-2min'))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_HbTFAD_CrossCorrelation_2min.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_HbTFAD_CrossCorrelation_2min.fig')));
        close all
        %         for jj = 1:10
        %             figure
        %             subplot(2,1,1)
        %             imagesc(lagTimeTrial_FADHbT_2min(:,:,jj),[0,2])
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
        %             imagesc(lagAmpTrial_FADHbT_2min(:,:,jj),[0 1])
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


%% RGECO Awake mice
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =[181,183,185,228,232,236];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = 'Awake RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')


lagTimeTrial_FADHbT_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_FADHbT_2min_median_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'L:\RGECO\cat';
mouseInd =1;
xform_isbrain_mice = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    lagTimeTrial_FADHbT_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_FADHbT_2min_median_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat');
    mask = xform_isbrain.*mask_new;
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'lagTimeTrial_FADHbT_2min_median','lagAmpTrial_FADHbT_2min_median')
        lagTimeTrial_FADHbT_2min_median_mouse(:,:,n) = lagTimeTrial_FADHbT_2min_median;
        lagAmpTrial_FADHbT_2min_median_mouse(:,:,n) = lagAmpTrial_FADHbT_2min_median;
    end
    
    
    
    lagTimeTrial_FADHbT_2min_median_mouse = nanmedian(lagTimeTrial_FADHbT_2min_median_mouse,3);
    lagAmpTrial_FADHbT_2min_median_mouse = nanmedian(lagAmpTrial_FADHbT_2min_median_mouse,3);
    
    figure;
    colormap jet;
    subplot(2,1,2); imagesc(lagAmpTrial_FADHbT_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,1,1); imagesc(lagTimeTrial_FADHbT_2min_median_mouse,[0 2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-2min'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FADHbT_Lag_2min.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FADHbT_Lag_2min.fig')));
    
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')))
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_FADHbT_2min_median_mouse', 'lagAmpTrial_FADHbT_2min_median_mouse',...
            '-append');
    else
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_FADHbT_2min_median_mouse', 'lagAmpTrial_FADHbT_2min_median_mouse',...
            '-v7.3');
    end
    lagTimeTrial_FADHbT_2min_median_mice(:,:,mouseInd) = lagTimeTrial_FADHbT_2min_median_mouse;
    lagAmpTrial_FADHbT_2min_median_mice(:,:,mouseInd) = lagAmpTrial_FADHbT_2min_median_mouse;
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat');

lagTimeTrial_FADHbT_2min_median_mice = nanmedian(lagTimeTrial_FADHbT_2min_median_mice,3);
lagAmpTrial_FADHbT_2min_median_mice= nanmedian(lagAmpTrial_FADHbT_2min_median_mice,3);
mask = xform_isbrain_mice.*mask_new;

figure;

subplot(2,1,2); imagesc(lagAmpTrial_FADHbT_2min_median_mice,rLim);colormap jet;axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,1,1); imagesc(lagTimeTrial_FADHbT_2min_median_mice,[0 2]);cmocean('ice');axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')

sgtitle('RGECO Awake Cross Correlation 2min')
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FADHbT_Lag_2min.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FADHbT_Lag_2min.fig')));

if exist(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),'file')
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_FADHbT_2min_median_mice', 'lagAmpTrial_FADHbT_2min_median_mice',...
        '-append');
else
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_FADHbT_2min_median_mice', 'lagAmpTrial_FADHbT_2min_median_mice',...
        '-v7.3');
end


%% RGECO Anes mice
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [195 202 204 230 234 240]; %[195 202 204 181 183 185];
miceCat = 'Anes RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_FADHbT_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_FADHbT_2min_median_mice = zeros(128,128,length(excelRows));

tLim = [0 2];
rLim = [-1 1];

miceName = [];
saveDir_cat = 'L:\RGECO\cat';
mouseInd =1;
xform_isbrain_mice = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    lagTimeTrial_FADHbT_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_FADHbT_2min_median_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat');
    mask = xform_isbrain.*mask_new;
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'lagTimeTrial_FADHbT_2min_median','lagAmpTrial_FADHbT_2min_median')
        
        lagTimeTrial_FADHbT_2min_median_mouse(:,:,n) = lagTimeTrial_FADHbT_2min_median;
        lagAmpTrial_FADHbT_2min_median_mouse(:,:,n) = lagAmpTrial_FADHbT_2min_median;
    end
    
    
    lagTimeTrial_FADHbT_2min_median_mouse = nanmedian(lagTimeTrial_FADHbT_2min_median_mouse,3);
    lagAmpTrial_FADHbT_2min_median_mouse = nanmedian(lagAmpTrial_FADHbT_2min_median_mouse,3);
    
    figure;
    colormap jet;
    subplot(2,1,2); imagesc(lagAmpTrial_FADHbT_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,1,1); imagesc(lagTimeTrial_FADHbT_2min_median_mouse,[0 2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
    
    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-2min'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FADHbT_Lag_2min.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FADHbT_Lag_2min.fig')));
    
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')))
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_FADHbT_2min_median_mouse', 'lagAmpTrial_FADHbT_2min_median_mouse',...
            '-append');
    else
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_FADHbT_2min_median_mouse', 'lagAmpTrial_FADHbT_2min_median_mouse',...
            '-v7.3');
    end
    lagTimeTrial_FADHbT_2min_median_mice(:,:,mouseInd) = lagTimeTrial_FADHbT_2min_median_mouse;
    lagAmpTrial_FADHbT_2min_median_mice(:,:,mouseInd) = lagAmpTrial_FADHbT_2min_median_mouse;
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat');

lagTimeTrial_FADHbT_2min_median_mice = nanmedian(lagTimeTrial_FADHbT_2min_median_mice,3);
lagAmpTrial_FADHbT_2min_median_mice= nanmedian(lagAmpTrial_FADHbT_2min_median_mice,3);
mask = xform_isbrain_mice.*mask_new;

figure;
colormap jet;
subplot(2,1,2); imagesc(lagAmpTrial_FADHbT_2min_median_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,1,1); imagesc(lagTimeTrial_FADHbT_2min_median_mice,[0 2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')


sgtitle('RGECO Anes Cross Correlation 2min')
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FADHbT_Lag_2min.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FADHbT_Lag_2min.fig')));

if exist(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),'file')
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_FADHbT_2min_median_mice', 'lagAmpTrial_FADHbT_2min_median_mice',...
        '-append');
else
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_FADHbT_2min_median_mice', 'lagAmpTrial_FADHbT_2min_median_mice',...
        '-v7.3');
end




