close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
load('D:\OIS_Process\noVasculatureMask.mat')
excelRows = [195 202 204 230 234 240 181 183 185 228 232 236];
runs = 1:3;
isDetrend = 1;
nVy = 128;
nVx = 128;

sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
sessionInfo.bandtype_Delta = {"Delta",0.4,4};
load('D:\BauerLabXiaodanScripts\GoodWL.mat')
load('D:\OIS_Process\noVasculatureMask.mat')
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
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
%         maskDir = fullfile(rawdataloc,recDate);
%         maskName = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
%         load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
%     else
%         maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%         if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
%             load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
%             load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
%         else
%             maskDir = saveDir;
%             maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%             load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
%         end
%
%     end
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%
%     right_isbrain = zeros(128,128);
%     right_isbrain(:,65:end) = xform_isbrain(:,65:end);
%     right_isbrain_flip = flip(right_isbrain,2);
%
%     left_isbrain = zeros(128,128);
%     left_isbrain(:,1:64)=xform_isbrain(:,1:64);
%
%     left_isbrain = left_isbrain.*right_isbrain_flip;
%     right_isbrain = flip(left_isbrain,2);
%     xform_isbrain_bilateral = left_isbrain+right_isbrain;
%
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
%         total = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
%         clear xform_datahb
%         %GSR
%         jrgeco1aCorr = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
%         clear xform_jrgeco1aCorr
%         FADCorr = mouse.process.gsr(xform_FADCorr,xform_isbrain);
%         clear xform_FADCorr
%         total = mouse.process.gsr(total,xform_isbrain);
%         %Filter
%         jrgeco1aCorr_ISA = mouse.freq.filterData(jrgeco1aCorr,sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
%         jrgeco1aCorr_Delta = mouse.freq.filterData(jrgeco1aCorr,sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
%         clear jrgeco1aCorr
%
%         FADCorr_ISA = mouse.freq.filterData(FADCorr,sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
%         FADCorr_Delta = mouse.freq.filterData(FADCorr,sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
%         clear FADCorr
%
%         total_ISA = mouse.freq.filterData(total,sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
%         total_Delta = mouse.freq.filterData(total,sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
%         clear total
%         %Calculate Bilateral FC Map
%         bilateralFCMap_jrgeco1aCorr_ISA = mouse.conn.bilateralFC(jrgeco1aCorr_ISA);
%         clear jrgeco1aCorr_ISA
%         bilateralFCMap_jrgeco1aCorr_Delta = mouse.conn.bilateralFC(jrgeco1aCorr_Delta);
%         clear jrgeco1aCorr_Delta
%
%         bilateralFCMap_FADCorr_ISA = mouse.conn.bilateralFC(FADCorr_ISA);
%         clear FADCorr_ISA
%         bilateralFCMap_FADCorr_Delta = mouse.conn.bilateralFC(FADCorr_Delta);
%         clear FADCorr_Delta
%
%         bilateralFCMap_total_ISA = mouse.conn.bilateralFC(total_ISA);
%         clear total_ISA
%         bilateralFCMap_total_Delta = mouse.conn.bilateralFC(total_Delta);
%         clear total_Delta
%
%         save(fullfile(saveDir,processedName),'bilateralFCMap_jrgeco1aCorr_ISA','bilateralFCMap_jrgeco1aCorr_Delta',...
%             'bilateralFCMap_FADCorr_ISA','bilateralFCMap_FADCorr_Delta',...
%             'bilateralFCMap_total_ISA','bilateralFCMap_total_Delta','xform_isbrain_bilateral','-append')
%         figure
%         subplot(2,3,1)
%         imagesc(bilateralFCMap_jrgeco1aCorr_ISA,[-1 1])
%         colormap jet
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('Calcium ISA')
%
%         subplot(2,3,2)
%         imagesc(bilateralFCMap_FADCorr_ISA,[-1 1])
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('FAD ISA')
%
%         subplot(2,3,3)
%         imagesc(bilateralFCMap_total_ISA,[-1 1])
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('HBT ISA')
%
%         subplot(2,3,4)
%         imagesc(bilateralFCMap_jrgeco1aCorr_Delta,[-1 1])
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('Calcium Delta')
%
%         subplot(2,3,5)
%         imagesc(bilateralFCMap_FADCorr_Delta_mouse,[-1 1])
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('FAD Delta')
%
%         p = subplot(2,3,6);
%         imagesc(bilateralFCMap_total_Delta,[-1 1])
%         axis image off
%         hold on
%         imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%         title('HbT Delta')
%         p1 = get(gca,'Position');
%         colorbar
%         set(p,'Position',p1)
%         suptitle(visName)
%         savefig(gcf,fullfile(saveDir,strcat(visName,'_','bilateralFCMap','.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(visName,'_','bilateralFCMap','.png')))
%     end
% end

% length_runs = length(runs);
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     rawdataloc = excelRaw{3};
%     info.nVx = 128;
%     info.nVy = 128;
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%
%     bilateralFCMap_jrgeco1aCorr_ISA_mouse = nan(128,128,length_runs);
%     bilateralFCMap_jrgeco1aCorr_Delta_mouse = nan(128,128,length_runs);
%
%     bilateralFCMap_FADCorr_ISA_mouse = nan(128,128,length_runs);
%     bilateralFCMap_FADCorr_Delta_mouse = nan(128,128,length_runs);
%
%     bilateralFCMap_total_ISA_mouse = nan(128,128,length_runs);
%     bilateralFCMap_total_Delta_mouse =nan(128,128,length_runs);
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     visName = strcat(recDate,'-',mouseName,'-',sessionType);
%     for n = runs
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'bilateralFCMap_jrgeco1aCorr_ISA','bilateralFCMap_jrgeco1aCorr_Delta',...
%             'bilateralFCMap_FADCorr_ISA','bilateralFCMap_FADCorr_Delta',...
%             'bilateralFCMap_total_ISA','bilateralFCMap_total_Delta','xform_isbrain_bilateral')
%         bilateralFCMap_jrgeco1aCorr_ISA_mouse(:,:,n) = bilateralFCMap_jrgeco1aCorr_ISA;
%         bilateralFCMap_jrgeco1aCorr_Delta_mouse(:,:,n) = bilateralFCMap_jrgeco1aCorr_Delta;
%
%         bilateralFCMap_FADCorr_ISA_mouse(:,:,n) = bilateralFCMap_FADCorr_ISA;
%         bilateralFCMap_FADCorr_Delta_mouse(:,:,n) = bilateralFCMap_FADCorr_Delta;
%
%         bilateralFCMap_total_ISA_mouse(:,:,n) = bilateralFCMap_total_ISA;
%         bilateralFCMap_total_Delta_mouse(:,:,n) = bilateralFCMap_total_Delta;
%
%     end
%     bilateralFCMap_jrgeco1aCorr_ISA_mouse = mean(bilateralFCMap_jrgeco1aCorr_ISA_mouse,3);
%     bilateralFCMap_jrgeco1aCorr_Delta_mouse = mean(bilateralFCMap_jrgeco1aCorr_Delta_mouse,3);
%
%     bilateralFCMap_FADCorr_ISA_mouse = mean(bilateralFCMap_FADCorr_ISA_mouse,3);
%     bilateralFCMap_FADCorr_Delta_mouse = mean(bilateralFCMap_FADCorr_Delta_mouse,3);
%
%     bilateralFCMap_total_ISA_mouse = mean(bilateralFCMap_total_ISA_mouse,3);
%     bilateralFCMap_total_Delta_mouse = mean(bilateralFCMap_total_Delta_mouse,3);
%
%     save(fullfile(saveDir,processedName_mouse),'bilateralFCMap_jrgeco1aCorr_ISA_mouse','bilateralFCMap_jrgeco1aCorr_Delta_mouse',...
%         'bilateralFCMap_FADCorr_ISA_mouse','bilateralFCMap_FADCorr_Delta_mouse',...
%         'bilateralFCMap_total_ISA_mouse','bilateralFCMap_total_Delta_mouse','xform_isbrain_bilateral','-append')
%     figure
%     subplot(2,3,1)
%     imagesc(bilateralFCMap_jrgeco1aCorr_ISA_mouse,[-1 1])
%     colormap jet
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('Calcium ISA')
%
%     subplot(2,3,2)
%     imagesc(bilateralFCMap_FADCorr_ISA_mouse,[-1 1])
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('FAD ISA')
%
%     subplot(2,3,3)
%     imagesc(bilateralFCMap_total_ISA_mouse,[-1 1])
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('HBT ISA')
%
%     subplot(2,3,4)
%     imagesc(bilateralFCMap_jrgeco1aCorr_Delta_mouse,[-1 1])
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('Calcium Delta')
%
%     subplot(2,3,5)
%     imagesc(bilateralFCMap_FADCorr_Delta_mouse,[-1 1])
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('FAD Delta')
%
%     p = subplot(2,3,6);
%     imagesc(bilateralFCMap_total_Delta_mouse,[-1 1])
%     axis image off
%     hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_bilateral)
%     title('HbT Delta')
%     p1 = get(gca,'Position');
%     colorbar
%     set(p,'Position',p1)
%     suptitle(visName)
%     savefig(gcf,fullfile(saveDir,strcat(visName,'_','bilateralFCMap','.fig')))
%     saveas(gcf,fullfile(saveDir,strcat(visName,'_','bilateralFCMap','.png')))
% end


% 
% excelRows = [181 183 185 228 232 236];
% numMice = length(excelRows);
% xform_isbrain_mice_bilateral = 1;
% saveDir_cat = 'L:\RGECO\cat';
% 
% bilateralFCMap_jrgeco1aCorr_ISA_mice = nan(128,128,numMice);
% bilateralFCMap_jrgeco1aCorr_Delta_mice = nan(128,128,numMice);
% 
% bilateralFCMap_FADCorr_ISA_mice = nan(128,128,numMice);
% bilateralFCMap_FADCorr_Delta_mice = nan(128,128,numMice);
% 
% bilateralFCMap_total_ISA_mice = nan(128,128,numMice);
% bilateralFCMap_total_Delta_mice =nan(128,128,numMice);
% 
% miceName = [];
% ll = 1;
% visName = 'Awake Bilateral Map - 6 mice';
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat';
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     miceName = char(strcat(miceName, '-', mouseName));
%     rawdataloc = excelRaw{3};
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'bilateralFCMap_jrgeco1aCorr_ISA_mouse','bilateralFCMap_jrgeco1aCorr_Delta_mouse',...
%         'bilateralFCMap_FADCorr_ISA_mouse','bilateralFCMap_FADCorr_Delta_mouse',...
%         'bilateralFCMap_total_ISA_mouse','bilateralFCMap_total_Delta_mouse','xform_isbrain_bilateral')
%     
%     bilateralFCMap_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(bilateralFCMap_jrgeco1aCorr_ISA_mouse);
%     bilateralFCMap_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(bilateralFCMap_jrgeco1aCorr_Delta_mouse);
%     
%     bilateralFCMap_FADCorr_ISA_mice(:,:,ll) = atanh(bilateralFCMap_FADCorr_ISA_mouse);
%     bilateralFCMap_FADCorr_Delta_mice(:,:,ll) = atanh(bilateralFCMap_FADCorr_Delta_mouse);
%     
%     bilateralFCMap_total_ISA_mice(:,:,ll) = atanh(bilateralFCMap_total_ISA_mouse);
%     bilateralFCMap_total_Delta_mice(:,:,ll) = atanh(bilateralFCMap_total_Delta_mouse);
%     xform_isbrain_mice_bilateral = xform_isbrain_mice_bilateral.*xform_isbrain_bilateral;
%     ll = ll + 1;
% end
% bilateralFCMap_jrgeco1aCorr_ISA_mice = mean(bilateralFCMap_jrgeco1aCorr_ISA_mice,3);
% bilateralFCMap_jrgeco1aCorr_Delta_mice = mean(bilateralFCMap_jrgeco1aCorr_Delta_mice,3);
% 
% bilateralFCMap_FADCorr_ISA_mice = mean(bilateralFCMap_FADCorr_ISA_mice,3);
% bilateralFCMap_FADCorr_Delta_mice = mean(bilateralFCMap_FADCorr_Delta_mice,3);
% 
% bilateralFCMap_total_ISA_mice = mean(bilateralFCMap_total_ISA_mice,3);
% bilateralFCMap_total_Delta_mice = mean(bilateralFCMap_total_Delta_mice,3);
% 
% save(fullfile(saveDir_cat,processedName_mice),'bilateralFCMap_jrgeco1aCorr_ISA_mice','bilateralFCMap_jrgeco1aCorr_Delta_mice',...
%     'bilateralFCMap_FADCorr_ISA_mice','bilateralFCMap_FADCorr_Delta_mice',...
%     'bilateralFCMap_total_ISA_mice','bilateralFCMap_total_Delta_mice','xform_isbrain_mice_bilateral','-append')
% figure
% subplot(2,3,1)
% imagesc(bilateralFCMap_jrgeco1aCorr_ISA_mice,[-2 2])
% colormap jet
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('Calcium ISA')
% 
% subplot(2,3,2)
% imagesc(bilateralFCMap_FADCorr_ISA_mice,[-2 2])
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('FAD ISA')
% 
% subplot(2,3,3)
% imagesc(bilateralFCMap_total_ISA_mice,[-2 2])
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('HBT ISA')
% 
% subplot(2,3,4)
% imagesc(bilateralFCMap_jrgeco1aCorr_Delta_mice,[-2 2])
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('Calcium Delta')
% 
% subplot(2,3,5)
% imagesc(bilateralFCMap_FADCorr_Delta_mice,[-2 2])
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('FAD Delta')
% 
% p = subplot(2,3,6);
% imagesc(bilateralFCMap_total_Delta_mice,[-2 2])
% axis image off
% hold on
% imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
% title('HbT Delta')
% p1 = get(gca,'Position');
% colorbar
% set(p,'Position',p1)
% suptitle(visName)
% savefig(gcf,fullfile(saveDir_cat,strcat(visName,'_','bilateralFCMap','.fig')))
% saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_','bilateralFCMap','.png')))



excelRows = [195 202 204 230 234 240];
numMice = length(excelRows);
xform_isbrain_mice_bilateral = 1;
saveDir_cat = 'L:\RGECO\cat';

bilateralFCMap_jrgeco1aCorr_ISA_mice = nan(128,128,numMice);
bilateralFCMap_jrgeco1aCorr_Delta_mice = nan(128,128,numMice);

bilateralFCMap_FADCorr_ISA_mice = nan(128,128,numMice);
bilateralFCMap_FADCorr_Delta_mice = nan(128,128,numMice);

bilateralFCMap_total_ISA_mice = nan(128,128,numMice);
bilateralFCMap_total_Delta_mice =nan(128,128,numMice);

miceName = [];
ll = 1;
visName = 'Anes Bilateral Map - 6 mice';
processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat';
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    miceName = char(strcat(miceName, '-', mouseName));
    rawdataloc = excelRaw{3};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse),'bilateralFCMap_jrgeco1aCorr_ISA_mouse','bilateralFCMap_jrgeco1aCorr_Delta_mouse',...
        'bilateralFCMap_FADCorr_ISA_mouse','bilateralFCMap_FADCorr_Delta_mouse',...
        'bilateralFCMap_total_ISA_mouse','bilateralFCMap_total_Delta_mouse','xform_isbrain_bilateral')
    
    bilateralFCMap_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(bilateralFCMap_jrgeco1aCorr_ISA_mouse);
    bilateralFCMap_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(bilateralFCMap_jrgeco1aCorr_Delta_mouse);
    
    bilateralFCMap_FADCorr_ISA_mice(:,:,ll) = atanh(bilateralFCMap_FADCorr_ISA_mouse);
    bilateralFCMap_FADCorr_Delta_mice(:,:,ll) = atanh(bilateralFCMap_FADCorr_Delta_mouse);
    
    bilateralFCMap_total_ISA_mice(:,:,ll) = atanh(bilateralFCMap_total_ISA_mouse);
    bilateralFCMap_total_Delta_mice(:,:,ll) = atanh(bilateralFCMap_total_Delta_mouse);
    xform_isbrain_mice_bilateral = xform_isbrain_mice_bilateral.*xform_isbrain_bilateral;
    ll = ll + 1;
end
bilateralFCMap_jrgeco1aCorr_ISA_mice = mean(bilateralFCMap_jrgeco1aCorr_ISA_mice,3);
bilateralFCMap_jrgeco1aCorr_Delta_mice = mean(bilateralFCMap_jrgeco1aCorr_Delta_mice,3);

bilateralFCMap_FADCorr_ISA_mice = mean(bilateralFCMap_FADCorr_ISA_mice,3);
bilateralFCMap_FADCorr_Delta_mice = mean(bilateralFCMap_FADCorr_Delta_mice,3);

bilateralFCMap_total_ISA_mice = mean(bilateralFCMap_total_ISA_mice,3);
bilateralFCMap_total_Delta_mice = mean(bilateralFCMap_total_Delta_mice,3);

save(fullfile(saveDir_cat,processedName_mice),'bilateralFCMap_jrgeco1aCorr_ISA_mice','bilateralFCMap_jrgeco1aCorr_Delta_mice',...
    'bilateralFCMap_FADCorr_ISA_mice','bilateralFCMap_FADCorr_Delta_mice',...
    'bilateralFCMap_total_ISA_mice','bilateralFCMap_total_Delta_mice','xform_isbrain_mice_bilateral','-append')
figure
subplot(2,3,1)
imagesc(bilateralFCMap_jrgeco1aCorr_ISA_mice,[-2 2])
colormap jet
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('Calcium ISA')

subplot(2,3,2)
imagesc(bilateralFCMap_FADCorr_ISA_mice,[-2 2])
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('FAD ISA')

subplot(2,3,3)
imagesc(bilateralFCMap_total_ISA_mice,[-2 2])
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('HBT ISA')

subplot(2,3,4)
imagesc(bilateralFCMap_jrgeco1aCorr_Delta_mice,[-2 2])
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('Calcium Delta')

subplot(2,3,5)
imagesc(bilateralFCMap_FADCorr_Delta_mice,[-2 2])
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('FAD Delta')

p = subplot(2,3,6);
imagesc(bilateralFCMap_total_Delta_mice,[-2 2])
axis image off
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice_bilateral)
title('HbT Delta')
p1 = get(gca,'Position');
colorbar
set(p,'Position',p1)
suptitle(visName)
savefig(gcf,fullfile(saveDir_cat,strcat(visName,'_','bilateralFCMap','.fig')))
saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_','bilateralFCMap','.png')))



