




import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


%
%
excelRows = [181 183 185  228 232 236 195 202 204 230 234 240]; %[195 202 204 230 234 240];% [181,183,185,228,232,236];%[181,183,185,228,232,236];%321:327;

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')


% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     mask_newDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{7};
%     %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
%     %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
%     load(fullfile(saveDir,maskName),'xform_isbrain')
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName),'xform_datahb_GSR')
%         % %
%         if strcmp(sessionType,'fc')
%             
%             
%             if strcmp(sessionInfo.mouseType,'jrgeco1a')
%                 load(fullfile(saveDir, processedName),'xform_FADCorr_GSR','xform_jrgeco1aCorr_GSR')
%                 xform_total_GSR = squeeze(xform_datahb_GSR(:,:,1,:)+ xform_datahb_GSR(:,:,2,:));
%                 xform_total_GSR(isinf(xform_total_GSR)) = 0;
%                 xform_total_GSR(isnan(xform_total_GSR)) = 0;
%                 xform_FADCorr_GSR(isnan(xform_FADCorr_GSR)) = 0;
%                 xform_FADCorr_GSR(isinf(xform_FADCorr_GSR)) = 0;
%                 xform_jrgeco1aCorr_GSR(isinf(xform_jrgeco1aCorr_GSR)) = 0;
%                 xform_jrgeco1aCorr_GSR(isnan(xform_jrgeco1aCorr_GSR)) = 0;
%                 
%                 
%                 
%                 %%comparing our NVC measures to Hillman (0.02-2)
%                 disp('filtering')
%                 xform_total_GSR_filtered = mouse.freq.filterData(double(xform_total_GSR),0.02,2,fs);
%                 xform_FADCorr_GSR_filtered = mouse.freq.filterData(double(xform_FADCorr_GSR),0.02,2,fs);
%                 xform_jrgeco1aCorr_GSR_filtered = mouse.freq.filterData(double(xform_jrgeco1aCorr_GSR),0.02,2,fs);
%                 edgeLen =1;
%                 tZone = 4;
%                 corrThr = 0;
%                 validRange = - edgeLen: round(tZone*fs);
%                 tLim = [-2 2];
%                 tLim_FAD = [0 0.3];
%                 rLim = [-1 1];
%                 disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
%                 % %
%                 [lagTimeTrial_GSR_0p02_2_HbTCalcium, lagAmpTrial_GSR_0p02_2_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
%                     xform_total_GSR_filtered,xform_jrgeco1aCorr_GSR_filtered,edgeLen,validRange,corrThr, true,true);
%                 lagTimeTrial_GSR_0p02_2_HbTCalcium = lagTimeTrial_GSR_0p02_2_HbTCalcium./fs;
%                 
%                 [lagTimeTrial_GSR_0p02_2_FADCalcium, lagAmpTrial_GSR_0p02_2_FADCalcium,covResult_FADCalcium] = mouse.conn.dotLag(...
%                     xform_FADCorr_GSR_filtered,xform_jrgeco1aCorr_GSR_filtered,edgeLen,validRange,corrThr, true,true);
%                 lagTimeTrial_GSR_0p02_2_FADCalcium= lagTimeTrial_GSR_0p02_2_FADCalcium./fs;
%                 
%                 [lagTimeTrial_GSR_0p02_2_HbTFAD, lagAmpTrial_GSR_0p02_2_HbTFAD,covResult_HbTFAD] = mouse.conn.dotLag(...
%                     xform_total_GSR_filtered,xform_FADCorr_GSR_filtered,edgeLen,validRange,corrThr, true,true);
%                 lagTimeTrial_GSR_0p02_2_HbTFAD= lagTimeTrial_GSR_0p02_2_HbTFAD./fs;
%                 
%                 clear clear xform_total_GSR_filtered xform_FADCorr_GSR_filtered xform_jrgeco1aCorr_GSR_filtered
%                 figure;
%                 colormap jet;
%                 subplot(2,3,1); imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 subplot(2,3,2); imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium,tLim_FAD);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 subplot(2,3,3); imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD,[-1 1]);axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 
%                 subplot(2,3,4); imagesc(lagAmpTrial_GSR_0p02_2_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 subplot(2,3,5); imagesc(lagAmpTrial_GSR_0p02_2_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 subplot(2,3,6); imagesc(lagAmpTrial_GSR_0p02_2_HbTFAD,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
%                 suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' GSR'))
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_GSR.png')));
%                 saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_GSR.fig')));
%                 save(fullfile(saveDir,processedName),'lagTimeTrial_GSR_0p02_2_HbTCalcium', 'lagAmpTrial_GSR_0p02_2_HbTCalcium','lagTimeTrial_GSR_0p02_2_FADCalcium', 'lagAmpTrial_GSR_0p02_2_FADCalcium','lagTimeTrial_GSR_0p02_2_HbTFAD', 'lagAmpTrial_GSR_0p02_2_HbTFAD','-append');
%                 close all
%                 
%             end
%             close all
%         end
%     end
% end



excelRows = [195 202 204 230 234 240]; %[181,183,185,228,232,236];%[195 202 204 181 183 185];[181,183,185,228,232,236];%
miceCat = 'Anes RGECO';

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean = zeros(128,128,length(excelRows));
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean = zeros(128,128,length(excelRows));
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean = zeros(128,128,length(excelRows));

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median = zeros(128,128,length(excelRows));
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median = zeros(128,128,length(excelRows));
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median = zeros(128,128,length(excelRows));



lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["GSR","GSR"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium","HbTFAD"];

tLim = [0 2];
rLim = [-1 1];



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
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    mask_newName_new = strcat(recDate,'-',mouseName,'-Landmarksandmask_new','.mat');
    fs = excelRaw{7};
    %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse = zeros(128,128,length(runs));
    lagTimeTrial_GSR_0p02_2_FADCalcium_mouse = zeros(128,128,length(runs));
    lagAmpTrial_GSR_0p02_2_FADCalcium_mouse = zeros(128,128,length(runs));
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                
                for ii = 1:2
                    for jj = 1:3
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_GSR_0p02_2_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_GSR_0p02_2_',lagSpeciesStrs(jj),'_mouse(:,:,n)','= ',lagParaStrs(ii),'Trial_GSR_0p02_2_',lagSpeciesStrs(jj),';'));
                        
                    end
                end
                
                
                
                
                
            end
            close all
        end
    end
    
    
    lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_mean = nanmean(lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse,3);
    lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_mean = nanmean(lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse,3);
    lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_mean = nanmean(lagTimeTrial_GSR_0p02_2_FADCalcium_mouse,3);
    lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_mean = nanmean(lagAmpTrial_GSR_0p02_2_FADCalcium_mouse,3);
    lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_mean = nanmean(lagTimeTrial_GSR_0p02_2_HbTFAD_mouse,3);
    lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_mean = nanmean(lagAmpTrial_GSR_0p02_2_HbTFAD_mouse,3);
    
    lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_median = nanmedian(lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse,3);
    lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_median = nanmedian(lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse,3);
    lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_median = nanmedian(lagTimeTrial_GSR_0p02_2_FADCalcium_mouse,3);
    lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_median = nanmedian(lagAmpTrial_GSR_0p02_2_FADCalcium_mouse,3);
    lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_median = nanmedian(lagTimeTrial_GSR_0p02_2_HbTFAD_mouse,3);
    lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_median = nanmedian(lagAmpTrial_GSR_0p02_2_HbTFAD_mouse,3);
    
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_mean,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_mean,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean',' GSR'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_GSR_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_GSR_mean.fig')));
    
    figure;
    colormap jet;
    subplot(2,3,1); imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,2); imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_median,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,3); imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_median,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4); imagesc(lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,5); imagesc(lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,3,6); imagesc(lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
    
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median',' GSR'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_GSR_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_GSR_median.fig')));
    
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_mean', 'lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_mean','lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_mean', 'lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_mean','lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_mean', 'lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_mean',...
        'lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_median', 'lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_median','lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_median', 'lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_median','lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_median', 'lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_median',...
        '-append');
    
    
    
    lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_mean;
    lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_mean;
    lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_mean;
    lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_mean;
    lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_mean;
    lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_mean;
    
    
    lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_HbTCalcium_mouse_median;
    lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_HbTCalcium_mouse_median;
    lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_FADCalcium_mouse_median;
    lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_FADCalcium_mouse_median;
    lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median(:,:,mouseInd) = lagTimeTrial_GSR_0p02_2_HbTFAD_mouse_median;
    lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median(:,:,mouseInd) = lagAmpTrial_GSR_0p02_2_HbTFAD_mouse_median;
    
    for ii = 1:2
        for jj = 1:3
            for kk = 1:2
                %eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_GSR_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),char(39),')'));
                eval(strcat(lagParaStrs(ii),'Trial_GSR_0p02_2_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(kk),'(:,:,mouseInd)','= ',lagParaStrs(ii),'Trial_GSR_0p02_2_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),';'));
            end
            
        end
    end
    
    
    
    
    
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean = nanmean(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean,3);
lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean = nanmean(lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean,3);
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean = nanmean(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean,3);
lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean= nanmean(lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean,3);
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean = nanmean(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean,3);
lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean = nanmean(lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean,3);

lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median = nanmedian(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median,3);
lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median = nanmedian(lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median,3);
lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median = nanmedian(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median,3);
lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median= nanmedian(lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median,3);
lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median = nanmedian(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median,3);
lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median = nanmedian(lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median,3);


figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean,[0 0.4]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean,[0 1.5]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-mean',' GSR'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_GSR_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_GSR_mean.fig')));

figure;
colormap jet;
subplot(2,3,1); imagesc(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,2); imagesc(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median,[0 0.8]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,3); imagesc(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median,[0 2]); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4); imagesc(lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,5); imagesc(lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,3,6); imagesc(lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceCat,'-',sessionType,'-median', ' GSR'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_GSR_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_GSR_median.fig')));


save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_mean', 'lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_mean','lagTimeTrial_GSR_0p02_2_FADCalcium_mice_mean', 'lagAmpTrial_GSR_0p02_2_FADCalcium_mice_mean','lagTimeTrial_GSR_0p02_2_HbTFAD_mice_mean', 'lagAmpTrial_GSR_0p02_2_HbTFAD_mice_mean',...
    'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median', 'lagAmpTrial_GSR_0p02_2_HbTCalcium_mice_median','lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median', 'lagAmpTrial_GSR_0p02_2_FADCalcium_mice_median', 'lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median', 'lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median',...
    '-append');

load('D:\OIS_Process\noVasculatureMask.mat')


lagTime_HbTCalcium_GSR_0p02_2 = nanmean(lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median(logical(mask_new)));
lagTime_HbTFAD_GSR_0p02_2 = nanmean(lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median(logical(mask_new)));
lagTime_FADCalcium_GSR_0p02_2 = nanmean(lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median(logical(mask_new)));

lagTime_HbTCalcium = nanmean(lagTimeTrial_HbTCalcium_mice_median(logical(mask_new)));
lagTime_HbTFAD = nanmean(lagTimeTrial_HbTFAD_mice_median(logical(mask_new)));
lagTime_FADCalcium = nanmean(lagTimeTrial_FADCalcium_mice_median(logical(mask_new)));

load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_ISA_FADCalcium_mice_median')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_ISA_HbTCalcium_mice_median')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_ISA_HbTFAD_mice_median')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagAmpTrial_GSR_0p02_2_HbTFAD_mice_median')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median')
load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat', 'lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median')

figure
GSRdivideNoGSR_HbTCalcium = lagTimeTrial_GSR_0p02_2_HbTCalcium_mice_median./lagTimeTrial_HbTCalcium_mice_median;
imagesc(GSRdivideNoGSR_HbTCalcium,[0.5 1.5])
colormap jet
colorbar
title('GSR/NoGSR HbT Calcium')
axis image off
set(gca,'FontSize',14,'FontWeight','Bold')

figure
GSRdivideNoGSR_FADCalcium = lagTimeTrial_GSR_0p02_2_FADCalcium_mice_median./lagTimeTrial_FADCalcium_mice_median;
imagesc(GSRdivideNoGSR_FADCalcium,[0.5 1.5])
colormap jet
colorbar
title('GSR/NoGSR FAD Calcium')
axis image off
set(gca,'FontSize',14,'FontWeight','Bold')

figure
GSRdivideNoGSR_HbTFAD = lagTimeTrial_GSR_0p02_2_HbTFAD_mice_median./lagTimeTrial_HbTFAD_mice_median;
imagesc(GSRdivideNoGSR_HbTFAD,[0.5 1.5])
colormap jet
colorbar
title('GSR/NoGSR HbT FAD')
axis image off
set(gca,'FontSize',14,'FontWeight','Bold')