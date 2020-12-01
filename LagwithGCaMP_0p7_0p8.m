
close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = 4;
load('D:\OIS_Process\noVasculatureMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
miceName = [];
catDir = 'L:\GCaMP\cat' ;


% stimStartTime = 5;
%
% nVx = 128;
% nVy = 128;
%
% %
% xform_isbrain_mice = ones(nVx ,nVy);
% isbrain_mice = ones(nVx ,nVy);
%
% %

excelRows = [120,133,139,123,122];

for excelRow = excelRows
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,maskName),'xform_isbrain');
    %processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    
    
    
    
    for n =  1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb','xform_gcampCorr_0p7_0p8','E_in', 'E_out', 'op_in', 'op_out')
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
          
        xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
        clear xform_datahb
        xform_total(isinf(xform_total)) = 0;
        xform_total(isnan(xform_total)) = 0;
        xform_gcampCorr_0p7_0p8(isinf(xform_gcampCorr_0p7_0p8)) = 0;
        xform_gcampCorr_0p7_0p8(isnan(xform_gcampCorr_0p7_0p8)) = 0;
        
        
        
        %%comparing our NVC measures to Hillman (0.02-2)
        disp('filtering')
        %
        xform_total_filtered = mouse.freq.filterData(double(xform_total),0.02,2,sessionInfo.framerate );% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
        
        xform_gcampCorr_filtered = mouse.freq.filterData(double(xform_gcampCorr_0p7_0p8),0.02,2,sessionInfo.framerate );
        edgeLen =1;
        tZone = 4;
        corrThr = 0;
        validRange = - edgeLen: round(tZone*sessionInfo.framerate);
        tLim = [-2 2];
        rLim = [-1 1];
        disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
        % %
        [lagTimeTrial_HbTCalcium_0p7_0p8, lagAmpTrial_HbTCalcium_0p7_0p8,covResult_HbTCalcium_0p7_0p8] = mouse.conn.dotLag(...
            xform_total_filtered,xform_gcampCorr_filtered,edgeLen,validRange,corrThr, true,true);
        lagTimeTrial_HbTCalcium_0p7_0p8 = lagTimeTrial_HbTCalcium_0p7_0p8./sessionInfo.framerate;
        
        clear clear xform_total_filtered  xform_gcampCorr_filtered
        figure;
        colormap jet;
        subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_0p7_0p8,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_0p7_0p8,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_0p7_0p8'))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_0p7_0p8.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag_0p7_0p8.fig')));
        save(fullfile(saveDir,processedName),'lagTimeTrial_HbTCalcium_0p7_0p8', 'lagAmpTrial_HbTCalcium_0p7_0p8','-append');
        close all
    end
end
%     eval(strcat('gcampCorrMatrix_mice_',num2str(ii),' = mean(gcampCorrMatrix_mice_',num2str(ii),',5);'));
%
%
%     catDir = 'L:\GCaMP\cat' ;
%     eval(strcat('save(fullfile(catDir,',char(39),'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat',char(39),'),',char(39),'gcampCorrMatrix_mice_',num2str(ii),char(39),',',char(39),'-append',char(39),');'));
%      eval(strcat('clear gcampCorrMatrix_mice_',num2str(ii)))
runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean = zeros(128,128,length(excelRows));


lagTimeTrial_HbTCalcium_0p7_0p8_mice_median = zeros(128,128,length(excelRows));
lagAmpTrial_HbTCalcium_0p7_0p8_mice_median = zeros(128,128,length(excelRows));



lagParaStrs = ["lagTime","lagAmp"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium_0p7_0p8"];

tLim = [0 1.5];
rLim = [-1 1];



miceName = [];
saveDir_cat = 'L:\GCaMP\cat';
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
    sessionInfo.framerate = excelRaw{7};
    %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    lagTimeTrial_HbTCalcium_0p7_0p8_mouse = zeros(128,128,length(runs));
    lagAmpTrial_HbTCalcium_0p7_0p8_mouse = zeros(128,128,length(runs));
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');

    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            
            
        
                
                
                for ii = 1:2
                    for jj = 1
                        eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
                        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse(:,:,n)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),';'));
                        
                    end
                end
                
                
                               
     
            close all
        end
    end
    
    
    lagTimeTrial_HbTCalcium_0p7_0p8_mouse_mean = nanmean(lagTimeTrial_HbTCalcium_0p7_0p8_mouse,3);
    lagAmpTrial_HbTCalcium_0p7_0p8_mouse_mean = nanmean(lagAmpTrial_HbTCalcium_0p7_0p8_mouse,3);
    
    lagTimeTrial_HbTCalcium_0p7_0p8_mouse_median = nanmedian(lagTimeTrial_HbTCalcium_0p7_0p8_mouse,3);
    lagAmpTrial_HbTCalcium_0p7_0p8_mouse_median = nanmedian(lagAmpTrial_HbTCalcium_0p7_0p8_mouse,3);
       
    
    
    figure;
    colormap jet;
    subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_0p7_0p8_mouse_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
  
    subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_0p7_0p8_mouse_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
     suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-mean_0p7_0p8'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_0p7_0p8_mean.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_0p7_0p8_mean.fig')));
    
    figure;
    colormap jet;
    subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_0p7_0p8_mouse_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
   
    subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_0p7_0p8_mouse_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
       
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType,'-median_0p7_0p8'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_0p7_0p8_median.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_Lag_0p7_0p8_median.fig')));
    
    if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),'file')
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_HbTCalcium_0p7_0p8_mouse_mean', 'lagAmpTrial_HbTCalcium_0p7_0p8_mouse_mean',...
        'lagTimeTrial_HbTCalcium_0p7_0p8_mouse_median', 'lagAmpTrial_HbTCalcium_0p7_0p8_mouse_median',...
        '-append');
    else
          save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat')),...
        'lagTimeTrial_HbTCalcium_0p7_0p8_mouse_mean', 'lagAmpTrial_HbTCalcium_0p7_0p8_mouse_mean',...
        'lagTimeTrial_HbTCalcium_0p7_0p8_mouse_median', 'lagAmpTrial_HbTCalcium_0p7_0p8_mouse_median',...
        '-v7.3');
    end

    
    lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean(:,:,mouseInd) = lagTimeTrial_HbTCalcium_0p7_0p8_mouse_mean;
    lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean(:,:,mouseInd) = lagAmpTrial_HbTCalcium_0p7_0p8_mouse_mean;
   
    
    lagTimeTrial_HbTCalcium_0p7_0p8_mice_median(:,:,mouseInd) = lagTimeTrial_HbTCalcium_0p7_0p8_mouse_median;
    lagAmpTrial_HbTCalcium_0p7_0p8_mice_median(:,:,mouseInd) = lagAmpTrial_HbTCalcium_0p7_0p8_mouse_median;
    for ii = 1:2
        for jj = 1
            for kk = 1:2
                %eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),char(39),')'));
                eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(kk),'(:,:,mouseInd)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mouse_',avgWayStrs(kk),';'));
            end
            
        end
    end
    
    

    
    
    
    mouseInd = mouseInd+1;
end

processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');

lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean = nanmean(lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean,3);
lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean = nanmean(lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean,3);

lagTimeTrial_HbTCalcium_0p7_0p8_mice_median = nanmedian(lagTimeTrial_HbTCalcium_0p7_0p8_mice_median,3);
lagAmpTrial_HbTCalcium_0p7_0p8_mice_median = nanmedian(lagAmpTrial_HbTCalcium_0p7_0p8_mice_median,3);


figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')

suptitle(strcat(recDate,'-',miceName,'-',sessionType,'-mean_0p7_0p8','0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_0p7_0p8_mean.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_0p7_0p8_mean.fig')));

figure;
colormap jet;
subplot(2,1,1); imagesc(lagTimeTrial_HbTCalcium_0p7_0p8_mice_median,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
subplot(2,1,2); imagesc(lagAmpTrial_HbTCalcium_0p7_0p8_mice_median,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);set(gca,'FontSize',14,'FontWeight','Bold')
suptitle(strcat(recDate,'-',miceName,'-',sessionType,'-median_0p7_0p8',' 0.02-2Hz'))
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_0p7_0p8_median.png')));
saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_Lag_0p7_0p8_median.fig')));

if exist(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),'file')
save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean', 'lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean',...
    'lagTimeTrial_HbTCalcium_0p7_0p8_mice_median', 'lagAmpTrial_HbTCalcium_0p7_0p8_mice_median',...
    '-append');
else
save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat')),...
    'lagTimeTrial_HbTCalcium_0p7_0p8_mice_mean', 'lagAmpTrial_HbTCalcium_0p7_0p8_mice_mean',...
    'lagTimeTrial_HbTCalcium_0p7_0p8_mice_median', 'lagAmpTrial_HbTCalcium_0p7_0p8_mice_median',...
    '-v7.3');
end


lagTime_HbTCalcium_0p7_0p8 = nanmean(lagTimeTrial_HbTCalcium_0p7_0p8_mice_median(logical(mask_new)));

