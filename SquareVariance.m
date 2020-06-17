
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";



% 
% excelRows = [181,183,185,228,232,236,195 202 204 230 234 240];
% 
runs = 1:3;


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{7};
%     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     %load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     load(fullfile(saveDir,maskName),'xform_isbrain')
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName),'xform_datahb')
%         
%         if strcmp(sessionType,'fc')
%             
%             
%             if strcmp(sessionInfo.mouseType,'jrgeco1a')
%                 load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
%                 xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
%                 xform_total(isinf(xform_total)) = 0;
%                 xform_total(isnan(xform_total)) = 0;
%                 xform_FADCorr(isnan(xform_FADCorr)) = 0;
%                 xform_FADCorr(isinf(xform_FADCorr)) = 0;
%                 xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
%                 xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
%                 
%                 v_total = var(squeeze(xform_total*10^6),0,3);
%                 v_FADCorr = var(squeeze(xform_FADCorr*100),0,3);
%                 v_jrgeco1aCorr = var(squeeze(xform_jrgeco1aCorr*100),0,3);
%                 
%                figure('units','normalized','outerposition',[0 0 0.5 0.5]);
%                 colormap jet;
%                 subplot(1,3,1); imagesc(v_total,[0,8]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,2); imagesc(v_FADCorr,[0,0.4]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,3); imagesc(v_jrgeco1aCorr,[0,6]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Variance^2'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2.fig')));
%                 
%                 save(fullfile(saveDir,processedName),'v_total', 'v_FADCorr','v_jrgeco1aCorr','-append');
%                 
%                 close all
%             end
%             close all
%         end
%     end
% end


excelRows = [195 202 204 230 234 240];%[195 202 204 181 183 185];[181,183,185,228,232,236];
miceCat = 'Anes';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
v_total_mice = zeros(128,128,length(excelRows));
v_FADCorr_mice = zeros(128,128,length(excelRows));
v_jrgeco1aCorr_mice = zeros(128,128,length(excelRows));


miceName = [];
saveDir_cat = 'D:\RGECO\cat';
mouseInd =1;
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
    maskDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    fs = excelRaw{7};
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    v_total_mouse = zeros(128,128,length(runs));
    v_FADCorr_mouse = zeros(128,128,length(runs));
    v_jrgeco1aCorr_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                load(fullfile(saveDir,processedName),'v_total', 'v_FADCorr','v_jrgeco1aCorr');
                
                v_total_mouse(:,:,n) = v_total;
                v_FADCorr_mouse(:,:,n) = v_FADCorr;
                v_jrgeco1aCorr_mouse(:,:,n) = v_jrgeco1aCorr;
                
                
            end
            
        end
    end
    
    
    v_total_mouse = nanmean(v_total_mouse,3);
    v_FADCorr_mouse= nanmean(v_FADCorr_mouse,3);
    v_jrgeco1aCorr_mouse= nanmean(v_jrgeco1aCorr_mouse,3);
    
    
    
    
    figure;
    colormap jet;
    subplot(1,3,1); imagesc(v_total_mouse); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(1,3,2); imagesc(v_FADCorr_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(1,3,3); imagesc(v_jrgeco1aCorr_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'Variance^2'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2.fig')));
    
    
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'v_total_mouse', 'v_FADCorr_mouse','v_jrgeco1aCorr_mouse','-append');
    
    v_total_mice(:,:,mouseInd) = v_total_mouse;
    v_FADCorr_mice(:,:,mouseInd) = v_FADCorr_mouse;
    v_jrgeco1aCorr_mice(:,:,mouseInd) = v_jrgeco1aCorr_mouse;
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

v_total_mice = nanmean(v_total_mice,3);
v_FADCorr_mice = nanmean(v_FADCorr_mice,3);
v_jrgeco1aCorr_mice = nanmean(v_jrgeco1aCorr_mice,3);



  
%                 colormap jet;
%                 subplot(1,3,1); imagesc(v_total,[0,8]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,2); imagesc(v_FADCorr,[0,0.4]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,3); imagesc(v_jrgeco1aCorr,[0,6]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%      

 figure('units','normalized','outerposition',[0 0 0.5 0.5]);
colormap jet;
subplot(1,3,1); imagesc(v_total_mice,[0,9]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,3,2); imagesc(v_FADCorr_mice,[0,0.5]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(1,3,3); imagesc(v_jrgeco1aCorr_mice,[0,4]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'Variance^2'))
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2.png')));
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'v_total_mice', 'v_FADCorr_mice','v_jrgeco1aCorr_mice','-append');



mask = logical(mask);
v_total_mice_mean = mean(v_total_mice(mask),'all')
v_FADCorr_mice_mean = mean(v_FADCorr_mice(mask),'all')
v_jrgeco1aCorr_mice_mean = mean(v_jrgeco1aCorr_mice(mask),'all')








