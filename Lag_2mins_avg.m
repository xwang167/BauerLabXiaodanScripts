excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows =[181,183,185,228,232,236];%[195 202 204 230 234 240]; [195 202 204 181 183 185];
miceCat = 'Awake RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_HbTCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagTimeTrial_FADCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_FADCalcium_2min_median_mice = zeros(128,128,length(excelRows));

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
    lagTimeTrial_HbTCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_HbTCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagTimeTrial_FADCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_FADCalcium_2min_median_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat');
    mask = xform_isbrain.*mask_new;
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'lagTimeTrial_HbTCalcium_2min_median',...
            'lagAmpTrial_HbTCalcium_2min_median','lagTimeTrial_FADCalcium_2min_median','lagAmpTrial_FADCalcium_2min_median')
        
        lagTimeTrial_HbTCalcium_2min_median_mouse(:,:,n) = lagTimeTrial_HbTCalcium_2min_median;
        lagAmpTrial_HbTCalcium_2min_median_mouse(:,:,n) = lagAmpTrial_HbTCalcium_2min_median;
        lagTimeTrial_FADCalcium_2min_median_mouse(:,:,n) = lagTimeTrial_FADCalcium_2min_median;
        lagAmpTrial_FADCalcium_2min_median_mouse(:,:,n) = lagAmpTrial_FADCalcium_2min_median;
    end
    
    
    
    lagTimeTrial_HbTCalcium_2min_median_mouse = nanmedian(lagTimeTrial_HbTCalcium_2min_median_mouse,3);
    lagAmpTrial_HbTCalcium_2min_median_mouse = nanmedian(lagAmpTrial_HbTCalcium_2min_median_mouse,3);
    lagTimeTrial_FADCalcium_2min_median_mouse = nanmedian(lagTimeTrial_FADCalcium_2min_median_mouse,3);
    lagAmpTrial_FADCalcium_2min_median_mouse = nanmedian(lagAmpTrial_FADCalcium_2min_median_mouse,3);
    
    figure;
    colormap jet;
    subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_2min_median_mouse,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
    subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_2min_median_mouse,[0 0.2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-2min'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_2min.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_2min.fig')));
    
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')))
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_HbTCalcium_2min_median_mouse', 'lagAmpTrial_HbTCalcium_2min_median_mouse',...
            'lagTimeTrial_FADCalcium_2min_median_mouse', 'lagAmpTrial_FADCalcium_2min_median_mouse',...
            '-append');
    else
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_HbTCalcium_2min_median_mouse', 'lagAmpTrial_HbTCalcium_2min_median_mouse',...
            'lagTimeTrial_FADCalcium_2min_median_mouse', 'lagAmpTrial_FADCalcium_2min_median_mouse',...
            '-v7.3');
    end
    lagTimeTrial_HbTCalcium_2min_median_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_2min_median_mouse;
    lagAmpTrial_HbTCalcium_2min_median_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_2min_median_mouse;
    lagTimeTrial_FADCalcium_2min_median_mice(:,:,mouseInd) = lagTimeTrial_FADCalcium_2min_median_mouse;
    lagAmpTrial_FADCalcium_2min_median_mice(:,:,mouseInd) = lagAmpTrial_FADCalcium_2min_median_mouse;
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat');

lagTimeTrial_HbTCalcium_2min_median_mice = nanmedian(lagTimeTrial_HbTCalcium_2min_median_mice,3);
lagAmpTrial_HbTCalcium_2min_median_mice = nanmedian(lagAmpTrial_HbTCalcium_2min_median_mice,3);
lagTimeTrial_FADCalcium_2min_median_mice = nanmedian(lagTimeTrial_FADCalcium_2min_median_mice,3);
lagAmpTrial_FADCalcium_2min_median_mice= nanmedian(lagAmpTrial_FADCalcium_2min_median_mice,3);
mask = xform_isbrain_mice.*mask_new;

figure;

subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_2min_median_mice,rLim);colormap jet;axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_2min_median_mice,rLim);colormap jet;axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_2min_median_mice,tLim); cmocean('ice');axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_2min_median_mice,[0 0.2]);cmocean('ice');axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')

sgtitle('Awake Cross Correlation 2min')
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_2min.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_2min.fig')));

if exist(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),'file')
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_HbTCalcium_2min_median_mice', 'lagAmpTrial_HbTCalcium_2min_median_mice',...
        'lagTimeTrial_FADCalcium_2min_median_mice', 'lagAmpTrial_FADCalcium_2min_median_mice',...
        '-append');
else
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_HbTCalcium_2min_median_mice', 'lagAmpTrial_HbTCalcium_2min_median_mice',...
        'lagTimeTrial_FADCalcium_2min_median_mice', 'lagAmpTrial_FADCalcium_2min_median_mice',...
        '-v7.3');
end













excelRows = [195 202 204 230 234 240]; %[195 202 204 181 183 185];
miceCat = 'Anes RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_HbTCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagTimeTrial_FADCalcium_2min_median_mice = zeros(128,128,length(excelRows));
lagAmpTrial_FADCalcium_2min_median_mice = zeros(128,128,length(excelRows));

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
    lagTimeTrial_HbTCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_HbTCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagTimeTrial_FADCalcium_2min_median_mouse = zeros(128,128,length(runs));
    lagAmpTrial_FADCalcium_2min_median_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat');
    mask = xform_isbrain.*mask_new;
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'lagTimeTrial_HbTCalcium_2min_median',...
            'lagAmpTrial_HbTCalcium_2min_median','lagTimeTrial_FADCalcium_2min_median','lagAmpTrial_FADCalcium_2min_median')
        
        lagTimeTrial_HbTCalcium_2min_median_mouse(:,:,n) = lagTimeTrial_HbTCalcium_2min_median;
        lagAmpTrial_HbTCalcium_2min_median_mouse(:,:,n) = lagAmpTrial_HbTCalcium_2min_median;
        lagTimeTrial_FADCalcium_2min_median_mouse(:,:,n) = lagTimeTrial_FADCalcium_2min_median;
        lagAmpTrial_FADCalcium_2min_median_mouse(:,:,n) = lagAmpTrial_FADCalcium_2min_median;
    end
    
    
    
    lagTimeTrial_HbTCalcium_2min_median_mouse = nanmedian(lagTimeTrial_HbTCalcium_2min_median_mouse,3);
    lagAmpTrial_HbTCalcium_2min_median_mouse = nanmedian(lagAmpTrial_HbTCalcium_2min_median_mouse,3);
    lagTimeTrial_FADCalcium_2min_median_mouse = nanmedian(lagTimeTrial_FADCalcium_2min_median_mouse,3);
    lagAmpTrial_FADCalcium_2min_median_mouse = nanmedian(lagAmpTrial_FADCalcium_2min_median_mouse,3);
    
    figure;
    colormap jet;
    subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_2min_median_mouse,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_2min_median_mouse,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
    subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_2min_median_mouse,[0 0.2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')

    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-2min'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_2min.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_2min.fig')));
    
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')))
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_HbTCalcium_2min_median_mouse', 'lagAmpTrial_HbTCalcium_2min_median_mouse',...
            'lagTimeTrial_FADCalcium_2min_median_mouse', 'lagAmpTrial_FADCalcium_2min_median_mouse',...
            '-append');
    else
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat')),...
            'lagTimeTrial_HbTCalcium_2min_median_mouse', 'lagAmpTrial_HbTCalcium_2min_median_mouse',...
            'lagTimeTrial_FADCalcium_2min_median_mouse', 'lagAmpTrial_FADCalcium_2min_median_mouse',...
            '-v7.3');
    end
    lagTimeTrial_HbTCalcium_2min_median_mice(:,:,mouseInd) = lagTimeTrial_HbTCalcium_2min_median_mouse;
    lagAmpTrial_HbTCalcium_2min_median_mice(:,:,mouseInd) = lagAmpTrial_HbTCalcium_2min_median_mouse;
    lagTimeTrial_FADCalcium_2min_median_mice(:,:,mouseInd) = lagTimeTrial_FADCalcium_2min_median_mouse;
    lagAmpTrial_FADCalcium_2min_median_mice(:,:,mouseInd) = lagAmpTrial_FADCalcium_2min_median_mouse;
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat');

lagTimeTrial_HbTCalcium_2min_median_mice = nanmedian(lagTimeTrial_HbTCalcium_2min_median_mice,3);
lagAmpTrial_HbTCalcium_2min_median_mice = nanmedian(lagAmpTrial_HbTCalcium_2min_median_mice,3);
lagTimeTrial_FADCalcium_2min_median_mice = nanmedian(lagTimeTrial_FADCalcium_2min_median_mice,3);
lagAmpTrial_FADCalcium_2min_median_mice= nanmedian(lagAmpTrial_FADCalcium_2min_median_mice,3);
mask = xform_isbrain_mice.*mask_new;

figure;
colormap jet;
subplot(2,2,3); imagesc(lagAmpTrial_HbTCalcium_2min_median_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,4); imagesc(lagAmpTrial_FADCalcium_2min_median_mice,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,2,1); imagesc(lagTimeTrial_HbTCalcium_2min_median_mice,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')
subplot(2,2,2); imagesc(lagTimeTrial_FADCalcium_2min_median_mice,[0 0.2]);axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold');cmocean('ice')


sgtitle('Anes Cross Correlation 2min')
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_2min.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_2min.fig')));

if exist(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),'file')
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_HbTCalcium_2min_median_mice', 'lagAmpTrial_HbTCalcium_2min_median_mice',...
        'lagTimeTrial_FADCalcium_2min_median_mice', 'lagAmpTrial_FADCalcium_2min_median_mice',...
        '-append');
else
    save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_2min.mat')),...
        'lagTimeTrial_HbTCalcium_2min_median_mice', 'lagAmpTrial_HbTCalcium_2min_median_mice',...
        'lagTimeTrial_FADCalcium_2min_median_mice', 'lagAmpTrial_FADCalcium_2min_median_mice',...
        '-v7.3');
end




