%@@ -0,0 +1,844 @@

%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% excelRows = [181,183,185,228,232,236,202,195,204,230,234,240]; % excelRows_awake = [181 183 185 228  232  236 ]; excelRows_anes = [ 202 195 204 230 234 240];
% 
% runs = 1:3;%
excelRows = 183;
runs = 3;
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
      tic
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')

        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

        Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
        HbT_filter = squeeze(HbT_filter);
        t = (0:750)./25;
        
%        Calcium_filter = reshape(Calcium_filter,128*128,[]);
%        HbT_filter = reshape(HbT_filter,128*128,[]);
%        Calcium_filter = normRow(Calcium_filter);
%        HbT_filter = normRow(HbT_filter);
%        Calcium_filter = reshape(Calcium_filter,128,128,[]);
%        HbT_filter = reshape(HbT_filter,128,128,[]);

%        
% tic
%         [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_CalciumHbT_Mask(Calcium_filter,HbT_filter,t,mask);
%         toc
%         
%         
        tic 
        [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_CalciumHbT_Mask(Calcium_filter*100,HbT_filter*10^6,t,mask);
        toc
%         save(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred','-append')
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
        imagesc(A,[0 0.07])
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
        suptitle('Normalized')
toc
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.png')));
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit.fig')));

    end
end

% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     T_mouse = [];
%     W_mouse = [];
%     A_mouse = [];
%     r_mouse = [];
%     r2_mouse = [];
%     hemoPred_mouse = [];
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred')
%         T_mouse = cat(3,T_mouse,T);
%         W_mouse = cat(3,W_mouse,W);
%         A_mouse = cat(3,A_mouse,A);
%         r_mouse = cat(3,r_mouse,r);
%         r2_mouse = cat(3,r2_mouse,r2);
%         hemoPred_mouse = cat(4,hemoPred_mouse,hemoPred);
%     end
%     T_mouse = mean(T_mouse,3);
%     W_mouse = mean(W_mouse,3);
%     A_mouse = mean(A_mouse,3);
%     r_mouse = mean(r_mouse,3);
%     r2_mouse = mean(r2_mouse,3);
%     hemoPred_mouse = mean(hemoPred_mouse,4);
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     save(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse','-append')
%     
%     
%     figure
%     subplot(2,3,1)
%     imagesc(T_mouse,[0,2])
%     colorbar
%     axis image off
%     colormap jet
%     title('T(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,2)
%     imagesc(W_mouse,[0 3])
%     colorbar
%     axis image off
%     colormap jet
%     title('W(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,3)
%     imagesc(A_mouse,[0 5])
%     colorbar
%     axis image off
%     colormap jet
%     title('A')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,4)
%     imagesc(r_mouse,[-1 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('r')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,5)
%     imagesc(r2_mouse,[0 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('R^2')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.png')));
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.fig')));
%     
% end
% 
% %Awake
% excelRows = [181,183,185,228,232,236];
% T_mice = [];
% W_mice = [];
% A_mice = [];
% r_mice = [];
% r2_mice = [];
% hemoPred_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     
%     
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse')
%     T_mice = cat(3,T_mice,T_mouse);
%     W_mice = cat(3,W_mice,W_mouse);
%     A_mice = cat(3,A_mice,A_mouse);
%     r_mice = cat(3,r_mice,r_mouse);
%     r2_mice = cat(3,r2_mice,r2_mouse);
%     hemoPred_mice = cat(4,hemoPred_mice,hemoPred_mouse);
% end
% T_mice = mean(T_mice,3);
% W_mice = mean(W_mice,3);
% A_mice = mean(A_mice,3);
% r_mice = mean(r_mice,3);
% r2_mice = mean(r2_mice,3);
% hemoPred_mice = mean(hemoPred_mice,4);
% 
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat';
% save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')
% 
% figure
% subplot(2,3,1)
% imagesc(T_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,2)
% imagesc(W_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,3)
% imagesc(A_mice,[0 5])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,4)
% imagesc(r_mice,[-1 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,5)
% imagesc(r2_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('R^2')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.png')));
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.fig')));




%Anes
excelRows = [202,195,204,230,234,240];
T_mice = [];
W_mice = [];
A_mice = [];
r_mice = [];
r2_mice = [];
hemoPred_mice = [];
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
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse')
    T_mice = cat(3,T_mice,T_mouse);
    W_mice = cat(3,W_mice,W_mouse);
    A_mice = cat(3,A_mice,A_mouse);
    r_mice = cat(3,r_mice,r_mouse);
    r2_mice = cat(3,r2_mice,r2_mouse);
    hemoPred_mice = cat(4,hemoPred_mice,hemoPred_mouse);
end
T_mice = mean(T_mice,3);
W_mice = mean(W_mice,3);
A_mice = mean(A_mice,3);
r_mice = mean(r_mice,3);
r2_mice = mean(r2_mice,3);
hemoPred_mice = mean(hemoPred_mice,4);

processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat';
save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')

figure
subplot(2,3,1)
imagesc(T_mice,[0,2])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_mice,[0 3])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_mice,[0 5])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.fig')));
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     T_mouse = [];
%     W_mouse = [];
%     A_mouse = [];
%     r_mouse = [];
%     r2_mouse = [];
%     hemoPred_mouse = [];
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred')
%         T_mouse = cat(3,T_mouse,T);
%         W_mouse = cat(3,W_mouse,W);
%         A_mouse = cat(3,A_mouse,A);
%         r_mouse = cat(3,r_mouse,r);
%         r2_mouse = cat(3,r2_mouse,r2);
%         hemoPred_mouse = cat(4,hemoPred_mouse,hemoPred);
%     end
%     T_mouse = median(T_mouse,3);
%     W_mouse = median(W_mouse,3);
%     A_mouse = median(A_mouse,3);
%     r_mouse = median(r_mouse,3);
%     r2_mouse = median(r2_mouse,3);
%     hemoPred_mouse = median(hemoPred_mouse,4);
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     save(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse','-append')
%     
%     
%     figure
%     subplot(2,3,1)
%     imagesc(T_mouse,[0,2])
%     colorbar
%     axis image off
%     colormap jet
%     title('T(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,2)
%     imagesc(W_mouse,[0 3])
%     colorbar
%     axis image off
%     colormap jet
%     title('W(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,3)
%     imagesc(A_mouse,[0 5])
%     colorbar
%     axis image off
%     colormap jet
%     title('A')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,4)
%     imagesc(r_mouse,[-1 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('r')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     subplot(2,3,5)
%     imagesc(r2_mouse,[0 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('R^2')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%     
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.png')));
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.fig')));
%     
% end
% % 
% % %Awake
% excelRows = [181,183,185,228,232,236];
% T_mice = [];
% W_mice = [];
% A_mice = [];
% r_mice = [];
% r2_mice = [];
% hemoPred_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     
%     
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse')
%     T_mice = cat(3,T_mice,T_mouse);
%     W_mice = cat(3,W_mice,W_mouse);
%     A_mice = cat(3,A_mice,A_mouse);
%     r_mice = cat(3,r_mice,r_mouse);
%     r2_mice = cat(3,r2_mice,r2_mouse);
%     hemoPred_mice = cat(4,hemoPred_mice,hemoPred_mouse);
% end
% T_mice = median(T_mice,3);
% W_mice = median(W_mice,3);
% A_mice = median(A_mice,3);
% r_mice = median(r_mice,3);
% r2_mice = median(r2_mice,3);
% hemoPred_mice = median(hemoPred_mice,4);
% 
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat';
% save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')
% 
% figure
% subplot(2,3,1)
% imagesc(T_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,2)
% imagesc(W_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,3)
% imagesc(A_mice,[0 5])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,4)
% imagesc(r_mice,[-1 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,5)
% imagesc(r2_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('R^2')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.png')));
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.fig')));
% 
% 
% 
% 
% %Anes
% excelRows = [202,195,204,230,234,240];
% T_mice = [];
% W_mice = [];
% A_mice = [];
% r_mice = [];
% r2_mice = [];
% hemoPred_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     
%     
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'T_mouse','W_mouse','A_mouse','r_mouse','r2_mouse','hemoPred_mouse')
%     T_mice = cat(3,T_mice,T_mouse);
%     W_mice = cat(3,W_mice,W_mouse);
%     A_mice = cat(3,A_mice,A_mouse);
%     r_mice = cat(3,r_mice,r_mouse);
%     r2_mice = cat(3,r2_mice,r2_mouse);
%     hemoPred_mice = cat(4,hemoPred_mice,hemoPred_mouse);
% end
% T_mice = median(T_mice,3);
% W_mice = median(W_mice,3);
% A_mice = median(A_mice,3);
% r_mice = median(r_mice,3);
% r2_mice = median(r2_mice,3);
% hemoPred_mice = median(hemoPred_mice,4);
% 
% processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat';
% save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')
% 
% figure
% subplot(2,3,1)
% imagesc(T_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,2)
% imagesc(W_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,3)
% imagesc(A_mice,[0 5])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,4)
% imagesc(r_mice,[-1 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% 
% subplot(2,3,5)
% imagesc(r2_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('R^2')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.png')));
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.fig')));
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % HbT_filter = reshape(HbT_filter,128,128,[]);
% % Calcium_filter = reshape(Calcium_filter,128,128,[]);
% %
% % for ii = 1:14999%925
% %     subplot(1,3,1)
% %     imagesc(HbT_filter(:,:,ii)*10^6,[-4 4])
% %     title('HbT')
% %     axis image off
% %     colorbar
% %
% %     subplot(1,3,2)
% %     imagesc(hemoPred(:,:,ii),[-4 4])
% %     axis image off
% %     title('Predicted HbT')
% %     colorbar
% %     subplot(1,3,3)
% %     imagesc(HbT_filter(:,:,ii)*10^6 - hemoPred(:,:,ii),[-4 4])
% %     title('HbT-Predicted HbT')
% %     axis image off
% %     colorbar
% %     colormap jet
% %     pause(0.1)
% % end
% %
% % figure
% % peakMap = HbT_filter(:,:,925)*10^6;
% % imagesc(peakMap,[-5 5])
% % colormap jet
% % axis image off
% % [X,Y] = meshgrid(1:128,1:128);
% % [x1,y1] = ginput(1);
% % [x2,y2] = ginput(1);
% % radius = sqrt((x1-x2)^2+(y1-y2)^2);
% % ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% % max_ROI = prctile(peakMap(ROI),99);
% % temp = double(peakMap).*double(ROI);
% % ROI = temp>max_ROI*0.75;
% % hold on
% % ROI_contour = bwperim(ROI);
% % [~,c] = contour( ROI_contour,'r');
% % c.LineWidth = 0.001;
% %
% % HbT_filter = reshape(HbT_filter,128*128,[]);
% % hemoPred = reshape(hemoPred,128*128,[]);
% % iRi = reshape(ROI,128*128,1);
% %
% % HbT = squeeze(mean(HbT_filter(iRi,:),1));
% % hemoPred = reshape(hemoPred,128*128,[]);
% % hemoPred_ROI = squeeze(mean(hemoPred(iRi,:),1));
% %
% % figure
% % plot((1:14999)/25,HbT*10^6,'r')
% % hold on
% % plot((1:14999)/25,hemoPred,'k')
% %
% % legend('HbT','Predicted HbT')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'A_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'T_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'W_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'r2_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'r_mice')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
mask = logical(mask);
A_avg = mean(A_mice(mask),'All');
r2_avg = mean(r2_mice(mask),'All');
r_avg = mean(r_mice(mask), 'All');
T_avg = mean(T_mice(mask), 'All');
W_avg = mean(W_mice(mask), 'All');
A_avg = 0.7477;
r2_avg = 0.3089;
r_avg = 0.5371;
T_avg = 1.3374;
W_avg = 2.1956;