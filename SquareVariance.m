
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";



% 
% excelRows = [181,183,185,228,232,236,195 202 204 230 234 240];
% % 
% runs = 1:3;
% 
% 
% load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
% load('D:\OIS_Process\noVasculatureMask.mat')
% mask = leftMask+rightMask;
% % 
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
% %                 v_total = var(squeeze(xform_total*10^6),0,3);
% %                 v_FADCorr = var(squeeze(xform_FADCorr*100),0,3);
% %                 v_jrgeco1aCorr = var(squeeze(xform_jrgeco1aCorr*100),0,3);
% %                 
% %                figure('units','normalized','outerposition',[0 0 0.5 0.5]);
% %                 colormap jet;
% %                 subplot(1,3,1); imagesc(v_total,[0,8]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% %                 subplot(1,3,2); imagesc(v_FADCorr,[0,0.4]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% %                 subplot(1,3,3); imagesc(v_jrgeco1aCorr,[0,6]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% %                 
% %                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Variance^2'))
% %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2.png')));
% %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2.fig')));
% %                 
% %                 save(fullfile(saveDir,processedName),'v_total', 'v_FADCorr','v_jrgeco1aCorr','-append');
%                 
%                 
%                 xform_total_ISA =  mouse.freq.filterData(double(xform_total),0.009,0.08,sessionInfo.framerate);
%                 xform_FADCorr_ISA = mouse.freq.filterData(double(xform_FADCorr),0.009,0.08,sessionInfo.framerate);
%                 xform_jrgeco1aCorr_ISA = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.009,0.08,sessionInfo.framerate);
%                 v_total_ISA = var(squeeze(xform_total_ISA*10^6),0,3);
%                 clear xform_total_ISA
%                 v_FADCorr_ISA = var(squeeze(xform_FADCorr_ISA*100),0,3);
%                 clear xform_FADCorr_ISA
%                 v_jrgeco1aCorr_ISA = var(squeeze(xform_jrgeco1aCorr_ISA*100),0,3);
%                 clear xform_jrgeco1aCorr_ISA
%                 
%                figure('units','normalized','outerposition',[0 0 0.5 0.5]);
%                 colormap jet;
%                 subplot(1,3,1); imagesc(v_total_ISA,[0,4]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,2); imagesc(v_FADCorr_ISA,[0,0.15]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,3); imagesc(v_jrgeco1aCorr_ISA,[0,2.5]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Variance^2-ISA'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2_ISA.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2_ISA.fig')));
%                 
%                 save(fullfile(saveDir,processedName),'v_total_ISA', 'v_FADCorr_ISA','v_jrgeco1aCorr_ISA','-append');
% 
%                                 xform_total_Delta =  mouse.freq.filterData(double(xform_total),0.4,4,sessionInfo.framerate);
%                 clear xform_total
%                 xform_FADCorr_Delta = mouse.freq.filterData(double(xform_FADCorr),0.4,4,sessionInfo.framerate);
%                 clear xform_FADCorr
%                 xform_jrgeco1aCorr_Delta = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.4,4,sessionInfo.framerate);
%                 clear xform_jRGECO1aCorr
%                 v_total_Delta = var(squeeze(xform_total_Delta*10^6),0,3);
%                 clear xform_total_Delta 
%                 v_FADCorr_Delta = var(squeeze(xform_FADCorr_Delta*100),0,3);
%                 clear xform_FADCorr_Delta
%                 v_jrgeco1aCorr_Delta = var(squeeze(xform_jrgeco1aCorr_Delta*100),0,3);
%                 clear xform_jrgeco1aCorr_Delta
%                 
%                figure('units','normalized','outerposition',[0 0 0.5 0.5]);
%                 colormap jet;
%                 subplot(1,3,1);imagesc(v_jrgeco1aCorr_Delta,[0,0.8]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,2);imagesc(v_FADCorr_Delta,[0,0.04]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,3);imagesc(v_total_Delta,[0,0.4]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                
%                 
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Variance^2-Delta'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2_Delta.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Variance^2_Delta.fig')));
%                 
%                 save(fullfile(saveDir,processedName),'v_total_Delta', 'v_FADCorr_Delta','v_jrgeco1aCorr_Delta','-append');
% 
%                
%                 
%                 
%                 
%                 close all
%             end
%             close all
%         end
%     end
% end


excelRows = [181,183,185,228,232,236];%[195 202 204 230 234 240];%[195 202 204 181 183 185];
miceCat = 'Awake';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
v_total_ISA_mice = zeros(128,128,length(excelRows));
v_FADCorr_ISA_mice = zeros(128,128,length(excelRows));
v_jrgeco1aCorr_ISA_mice = zeros(128,128,length(excelRows));
v_total_Delta_mice = zeros(128,128,length(excelRows));
v_FADCorr_Delta_mice = zeros(128,128,length(excelRows));
v_jrgeco1aCorr_Delta_mice = zeros(128,128,length(excelRows));

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
    v_total_ISA_mouse = zeros(128,128,length(runs));
    v_FADCorr_ISA_mouse = zeros(128,128,length(runs));
    v_jrgeco1aCorr_ISA_mouse = zeros(128,128,length(runs));
    
    v_total_Delta_mouse = zeros(128,128,length(runs));
    v_FADCorr_Delta_mouse = zeros(128,128,length(runs));
    v_jrgeco1aCorr_Delta_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                load(fullfile(saveDir,processedName),'v_total_ISA', 'v_FADCorr_ISA','v_jrgeco1aCorr_ISA');
                
                v_total_ISA_mouse(:,:,n) = v_total_ISA;
                v_FADCorr_ISA_mouse(:,:,n) = v_FADCorr_ISA;
                v_jrgeco1aCorr_ISA_mouse(:,:,n) = v_jrgeco1aCorr_ISA;
                
                                load(fullfile(saveDir,processedName),'v_total_Delta', 'v_FADCorr_Delta','v_jrgeco1aCorr_Delta');
                
                v_total_Delta_mouse(:,:,n) = v_total_Delta;
                v_FADCorr_Delta_mouse(:,:,n) = v_FADCorr_Delta;
                v_jrgeco1aCorr_Delta_mouse(:,:,n) = v_jrgeco1aCorr_Delta;
                
                
            end
            
        end
    end
    
    
    v_total_ISA_mouse = nanmean(v_total_ISA_mouse,3);
    v_FADCorr_ISA_mouse= nanmean(v_FADCorr_ISA_mouse,3);
    v_jrgeco1aCorr_ISA_mouse= nanmean(v_jrgeco1aCorr_ISA_mouse,3);
    
    
        
    v_total_Delta_mouse = nanmean(v_total_Delta_mouse,3);
    v_FADCorr_Delta_mouse= nanmean(v_FADCorr_Delta_mouse,3);
    v_jrgeco1aCorr_Delta_mouse= nanmean(v_jrgeco1aCorr_Delta_mouse,3);
    

    
    figure;
    colormap jet;
    subplot(1,3,1); imagesc(v_jrgeco1aCorr_ISA_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
     subplot(1,3,2); imagesc(v_FADCorr_ISA_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(1,3,3); imagesc(v_total_ISA_mouse); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
   
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'Variance^2-ISA'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2_ISA.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2_ISA.fig')));
    
    
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'v_total_ISA_mouse', 'v_FADCorr_ISA_mouse','v_jrgeco1aCorr_ISA_mouse','-append');
    
    v_total_ISA_mice(:,:,mouseInd) = v_total_ISA_mouse;
    v_FADCorr_ISA_mice(:,:,mouseInd) = v_FADCorr_ISA_mouse;
    v_jrgeco1aCorr_ISA_mice(:,:,mouseInd) = v_jrgeco1aCorr_ISA_mouse;
    
    figure;
    colormap jet;
    subplot(1,3,1); imagesc(v_jrgeco1aCorr_Delta_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
     subplot(1,3,2); imagesc(v_FADCorr_Delta_mouse);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(1,3,3); imagesc(v_total_Delta_mouse); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
   
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'Variance^2-Delta'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2_Delta.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Variance^2_Delta.fig')));
    
    
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'v_total_Delta_mouse', 'v_FADCorr_Delta_mouse','v_jrgeco1aCorr_Delta_mouse','-append');
    
    v_total_Delta_mice(:,:,mouseInd) = v_total_Delta_mouse;
    v_FADCorr_Delta_mice(:,:,mouseInd) = v_FADCorr_Delta_mouse;
    v_jrgeco1aCorr_Delta_mice(:,:,mouseInd) = v_jrgeco1aCorr_Delta_mouse;
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

v_total_ISA_mice = nanmean(v_total_ISA_mice,3);
v_FADCorr_ISA_mice = nanmean(v_FADCorr_ISA_mice,3);
v_jrgeco1aCorr_ISA_mice = nanmean(v_jrgeco1aCorr_ISA_mice,3);



  
%                 colormap jet;
%                 subplot(1,3,1); imagesc(v_total,[0,8]); axis image off;h = colorbar;ylabel(h,'(\Delta\muM)^2');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,2); imagesc(v_FADCorr,[0,0.4]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%                 subplot(1,3,3); imagesc(v_jrgeco1aCorr,[0,6]);axis image off;h = colorbar;ylabel(h,'(\DeltaF/F%)^2');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%      

%  figure('units','normalized','outerposition',[0 0 0.5 0.5]);
% colormap jet;
% subplot(1,3,1); imagesc(log10(v_jrgeco1aCorr_ISA_mice),[-2.2,-1.2]);axis image off;h = colorbar;ylabel(h,'log_10((\DeltaF/F%)^2))');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,3,2); imagesc(log10(v_FADCorr_ISA_mice),[-3.3 -2.3]);axis image off;h = colorbar;ylabel(h,'log_10((\DeltaF/F%)^2)');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,3,3); imagesc(log10(v_total_ISA_mice),[-2.4 -1.4]); axis image off;h = colorbar;ylabel(h,'log_10((\Delta\muM)^2)');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
figure('units','normalized','outerposition',[0 0 0.5 0.5]);
colormap jet;
subplot(1,3,1); imagesc(log10(v_jrgeco1aCorr_ISA_mice),[-0.8,0.2]);cb =colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-0.8 -0.3 0.2]);axis image off;title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')
subplot(1,3,2); imagesc(log10(v_FADCorr_ISA_mice),[-2 -1]);cb = colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-2 -1.5 -1]);axis image off;title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')
subplot(1,3,3); imagesc(log10(v_total_ISA_mice),[-0.4 0.6]); cb = colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-0.4 0.1 0.6]);axis image off;title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'Variance^2-ISA'))
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2_ISA.png')));
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2_ISA.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'v_total_ISA_mice', 'v_FADCorr_ISA_mice','v_jrgeco1aCorr_ISA_mice','-append');

v_total_Delta_mice = nanmean(v_total_Delta_mice,3);
v_FADCorr_Delta_mice = nanmean(v_FADCorr_Delta_mice,3);
v_jrgeco1aCorr_Delta_mice = nanmean(v_jrgeco1aCorr_Delta_mice,3);

%  figure('units','normalized','outerposition',[0 0 0.5 0.5]);
% colormap jet;
% subplot(1,3,1); imagesc(log10(v_jrgeco1aCorr_Delta_mice),[-2,-1]);axis image off;h = colorbar;ylabel(h,'log_10((\DeltaF/F%)^2)');title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,3,2); imagesc(log10(v_FADCorr_Delta_mice),[-4.2,-3.2]);axis image off;h = colorbar;ylabel(h,'log_10(\DeltaF/F%)^2)');title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% subplot(1,3,3); imagesc(log10(v_total_Delta_mice),[-3.9,-2.9]); axis image off;h = colorbar;ylabel(h,'log_10((\Delta\muM)^2)');title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
% 


  

 figure('units','normalized','outerposition',[0 0 0.5 0.5]);
colormap jet;
subplot(1,3,1); imagesc(log10(v_jrgeco1aCorr_Delta_mice),[-1,0]);cb = colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-1 -0.5 0]);axis image off;title('jRGECO1aCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')
subplot(1,3,2); imagesc(log10(v_FADCorr_Delta_mice),[-2.1,-1.1]);cb = colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-2.1 -1.6 -1.1]);axis image off;title('FADCorr');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')
subplot(1,3,3); imagesc(log10(v_total_Delta_mice),[-1,0]); cb = colorbar('location','southoutside','Axislocation','in');set(cb,'YTick',[-1 -0.5 0]);axis image off;title('HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',20,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'Variance^2-Delta'))
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2_Delta.png')));
saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_Variance^2_Delta.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'v_total_Delta_mice', 'v_FADCorr_Delta_mice','v_jrgeco1aCorr_Delta_mice','-append');


mask = logical(mask);

v_total_ISA_mice_mean = mean(v_total_ISA_mice(mask),'all')
v_FADCorr_ISA_mice_mean = mean(v_FADCorr_ISA_mice(mask),'all')
v_jrgeco1aCorr_ISA_mice_mean = mean(v_jrgeco1aCorr_ISA_mice(mask),'all')

mask = logical(mask);
v_total_Delta_mice_mean = mean(v_total_Delta_mice(mask),'all')
v_FADCorr_Delta_mice_mean = mean(v_FADCorr_Delta_mice(mask),'all')
v_jrgeco1aCorr_Delta_mice_mean = mean(v_jrgeco1aCorr_Delta_mice(mask),'all')








