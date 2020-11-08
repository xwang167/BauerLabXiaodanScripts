
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";




excelRows =  [181,183,185,228,232,236];%321:327;

runs = 1:3;


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

xform_WL = imresize(xform_WL,0.5);
mask = imresize(mask,0.5);
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
%                 load(fullfile(saveDir, processedName),'xform_FADCorr')
%                 %                 load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
%                 %                 xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
%                 %                 xform_total(isinf(xform_total)) = 0;
%                 %                 xform_total(isnan(xform_total)) = 0;
%                 xform_FADCorr(isnan(xform_FADCorr)) = 0;
%                 xform_FADCorr(isinf(xform_FADCorr)) = 0;
%                 %                 xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
%                 %                 xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
%                 %
%                 
%                 
%                 %functionally relvenat brain organization (lag with respect to global signal)
%                 edgeLen =1;
%                 tZone = 4;
%                 
%                 ISA = [0.009 0.08];
%                 Delta = [0.4 4];
%                 validRange = -round(tZone*fs): round(tZone*fs);
%                 tLim_ISA = [-1.5 1.5];
%                 tLim_Delta = [-0.05 0.05];
%                 corrThr = 0;
%                 rLim = [-1 1];
%                 %                 tic;
%                 %                 [lagTime_Projection_Calcium_ISA,lagAmp_Projection_Calcium_ISA] = calcProjectionlag(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 %                 toc;
%                 %                 [lagTime_Projection_FAD_ISA,lagAmp_Projection_FAD_ISA] = calcProjectionlag(xform_FADCorr,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 %                 [lagTime_Projection_total_ISA,lagAmp_Projection_total_ISA] = calcProjectionlag(xform_total,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
%                 %                 save(fullfile(saveDir,processedName),'lagTime_Projection_total_ISA', 'lagAmp_Projection_total_ISA','lagTime_Projection_FAD_ISA', 'lagAmp_Projection_FAD_ISA','lagTime_Projection_Calcium_ISA','lagAmp_Projection_Calcium_ISA','-append');
%                 
%                 
%                 %                 figure;
%                 %                 colormap jet
%                 %                 subplot(2,3,1); imagesc(lagTime_Projection_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 subplot(2,3,2); imagesc(lagTime_Projection_FAD_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 subplot(2,3,3); imagesc(lagTime_Projection_total_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 subplot(2,3,4); imagesc(lagAmp_Projection_Calcium_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 subplot(2,3,5); imagesc(lagAmp_Projection_FAD_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 subplot(2,3,6); imagesc(lagAmp_Projection_total_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 %                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Projection lag, ISA'))
%                 %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Projlag_ISA.png')));
%                 %                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Projlag_ISA.fig')));
%                 %
%                 tic;
%                 %                 [lagTime_Projection_total_Delta,lagAmp_Projection_total_Delta] = calcProjectionlag(xform_total,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
%                 %                 toc;
%                 [lagTime_Projection_FAD_Delta,lagAmp_Projection_FAD_Delta] = calcProjectionLag(xform_FADCorr,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
%                 %                 [lagTime_Projection_Calcium_Delta,lagAmp_Projection_Calcium_Delta] = calcProjectionlag(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
%                 toc
%                 
%                 save(fullfile(saveDir,processedName),'lagTime_Projection_FAD_Delta', 'lagAmp_Projection_FAD_Delta','-append');
%                 
%                 %save(fullfile(saveDir,processedName),'lagTime_Projection_total_Delta', 'lagAmp_Projection_total_Delta','lagTime_Projection_FAD_Delta', 'lagAmp_Projection_FAD_Delta','lagTime_Projection_Calcium_Delta','lagAmp_Projection_Calcium_Delta','-append');
%                 figure
%                 colormap jet
%                 subplot(2,1,1)
%                 imagesc(lagTime_Projection_FAD_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 subplot(2,1,2)
%                 imagesc(lagAmp_Projection_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_Projlag_Delta.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_Projlag_Delta.fig')));
%             end
%             close all
%         end
%     end
% end


excelRows =[181,183,185,228,232,236]; %[195 202 204 230 234 240];%[195 202 204 181 183 185];;%;[181,183,185,228,232,236]
miceCat = 'Awake';

runs = 1:3;

lagTime_Projection_FAD_ISA_mice_mean = zeros(64,64,length(excelRows));
lagAmp_Projection_FAD_ISA_mice_mean = zeros(64,64,length(excelRows));
lagTime_Projection_FAD_Delta_mice_mean = zeros(64,64,length(excelRows));
lagAmp_Projection_FAD_Delta_mice_mean = zeros(64,64,length(excelRows));

lagTime_Projection_FAD_ISA_mice_median = zeros(64,64,length(excelRows));
lagAmp_Projection_FAD_ISA_mice_median = zeros(64,64,length(excelRows));
lagTime_Projection_FAD_Delta_mice_median = zeros(64,64,length(excelRows));
lagAmp_Projection_FAD_Delta_mice_median = zeros(64,64,length(excelRows));




rLim = [-1 1];
tLim_ISA = [-1 1];
tLim_Delta = [-0.005 0.005];
lagParaStrs = ["lagTime","lagAmp"];
bandStrs = ["ISA","Delta"];
avgWayStrs = ["mean","median"];
miceName = [];
saveDir_cat = 'L:\RGECO\cat';
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
    
    if excelRow ==230
        runs = 1;
    end
    if excelRow ==250
        runs = [1,2];
    end
    lagTime_Projection_FAD_ISA_mouse = zeros(64,64,length(runs));
    lagAmp_Projection_FAD_ISA_mouse = zeros(64,64,length(runs));
    lagTime_Projection_FAD_Delta_mouse = zeros(64,64,length(runs));
    lagAmp_Projection_FAD_Delta_mouse = zeros(64,64,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    for n = runs
        
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                
                
                
                for ii = 1:2
                    for kk = 2
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'_Projection_FAD_',bandStrs(kk),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'_Projection_FAD_',bandStrs(kk),'_mouse(:,:,n)','= ',lagParaStrs(ii),'_Projection_FAD_',bandStrs(kk),';'));
                    end
                end
                
                
                
            end
            close all
        end
    end
    
    
    lagTime_Projection_FAD_ISA_mouse_mean = nanmean(lagTime_Projection_FAD_ISA_mouse,3);
    lagAmp_Projection_FAD_ISA_mouse_mean = nanmean(lagAmp_Projection_FAD_ISA_mouse,3);
    lagTime_Projection_FAD_Delta_mouse_mean = nanmean(lagTime_Projection_FAD_Delta_mouse,3);
    lagAmp_Projection_FAD_Delta_mouse_mean = nanmean(lagAmp_Projection_FAD_Delta_mouse,3);
    
    lagTime_Projection_FAD_ISA_mouse_median = nanmedian(lagTime_Projection_FAD_ISA_mouse,3);
    lagAmp_Projection_FAD_ISA_mouse_median = nanmedian(lagAmp_Projection_FAD_ISA_mouse,3);
    lagTime_Projection_FAD_Delta_mouse_median = nanmedian(lagTime_Projection_FAD_Delta_mouse,3);
    lagAmp_Projection_FAD_Delta_mouse_median = nanmedian(lagAmp_Projection_FAD_Delta_mouse,3);
    
    
    
    figure;
    colormap jet
    subplot(2,2,1); imagesc(lagTime_Projection_FAD_ISA_mouse_mean,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,2); imagesc(lagTime_Projection_FAD_Delta_mouse_mean,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,3); imagesc(lagAmp_Projection_FAD_ISA_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmp_Projection_FAD_Delta_mouse_mean,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'FAD Projection lag Mean'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FAD_Projlag_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FAD_Projlag_mean.fig')));
    figure;
    colormap jet
    subplot(2,2,1); imagesc(lagTime_Projection_FAD_ISA_mouse_median,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,2); imagesc(lagTime_Projection_FAD_Delta_mouse_median,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,3); imagesc(lagAmp_Projection_FAD_ISA_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4); imagesc(lagAmp_Projection_FAD_Delta_mouse_median,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'FAD Projection lag median'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FAD_Projlag_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_FAD_Projlag_median.fig')));
    
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTime_Projection_FAD_ISA_mouse_mean', 'lagAmp_Projection_FAD_ISA_mouse_mean','lagTime_Projection_FAD_Delta_mouse_mean', 'lagAmp_Projection_FAD_Delta_mouse_mean',...
        'lagTime_Projection_FAD_ISA_mouse_median', 'lagAmp_Projection_FAD_ISA_mouse_median','lagTime_Projection_FAD_Delta_mouse_median', 'lagAmp_Projection_FAD_Delta_mouse_median',...
        '-append');
    
    
    
    
    lagTime_Projection_FAD_ISA_mice_mean(:,:,mouseInd) = lagTime_Projection_FAD_ISA_mouse_mean;
    lagAmp_Projection_FAD_ISA_mice_mean(:,:,mouseInd) = lagAmp_Projection_FAD_ISA_mouse_mean;
    lagTime_Projection_FAD_Delta_mice_mean(:,:,mouseInd) = lagTime_Projection_FAD_Delta_mouse_mean;
    lagAmp_Projection_FAD_Delta_mice_mean(:,:,mouseInd) = lagAmp_Projection_FAD_Delta_mouse_mean;
    
    
    lagTime_Projection_FAD_ISA_mice_median(:,:,mouseInd) = lagTime_Projection_FAD_ISA_mouse_median;
    lagAmp_Projection_FAD_ISA_mice_median(:,:,mouseInd) = lagAmp_Projection_FAD_ISA_mouse_median;
    lagTime_Projection_FAD_Delta_mice_median(:,:,mouseInd) = lagTime_Projection_FAD_Delta_mouse_median;
    lagAmp_Projection_FAD_Delta_mice_median(:,:,mouseInd) = lagAmp_Projection_FAD_Delta_mouse_median;
    
    
    
    
    
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTime_Projection_FAD_Delta_mice_mean = nanmean(lagTime_Projection_FAD_Delta_mice_mean,3);
lagAmp_Projection_FAD_Delta_mice_mean= nanmean(lagAmp_Projection_FAD_Delta_mice_mean,3);

lagTime_Projection_FAD_Delta_mice_median = nanmedian(lagTime_Projection_FAD_Delta_mice_median,3);
lagAmp_Projection_FAD_Delta_mice_median= nanmedian(lagAmp_Projection_FAD_Delta_mice_median,3);

tLim_Delta = [-0.05 0.05];
figure;
colormap jet
subplot(2,1,1); imagesc(lagTime_Projection_FAD_Delta_mice_mean,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,1,2); imagesc(lagAmp_Projection_FAD_Delta_mice_mean,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'FAD Projection lag Mean'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FAD_Projlag_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FAD_Projlag_mean.fig')));
figure;
colormap jet
subplot(2,1,1); imagesc(lagTime_Projection_FAD_Delta_mice_median,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,1,2); imagesc(lagAmp_Projection_FAD_Delta_mice_median,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'FAD Projection lag median'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FAD_Projlag_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_FAD_Projlag_median.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTime_Projection_FAD_ISA_mice_mean', 'lagAmp_Projection_FAD_ISA_mice_mean','lagTime_Projection_FAD_Delta_mice_mean', 'lagAmp_Projection_FAD_Delta_mice_mean',...
    'lagTime_Projection_FAD_ISA_mice_median', 'lagAmp_Projection_FAD_ISA_mice_median','lagTime_Projection_FAD_Delta_mice_median', 'lagAmp_Projection_FAD_Delta_mice_median',...
    '-append');
