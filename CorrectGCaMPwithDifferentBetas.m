close all
% close all;clear all;clc
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','xform_jrgeco1aCorr_mice_NoGSR')

peakMap_ROI = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,126:250),3);
figure
colormap jet
imagesc(peakMap_ROI,[-0.04 0.04])
axis image off

[X,Y] = meshgrid(1:128,1:128);

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_ROI(ROI),99);
temp = double(peakMap_ROI).*double(ROI);
ROI_jrgeco1a = temp>max_ROI*0.75;
hold on
ROI_contour = bwperim(ROI_jrgeco1a);
contour( ROI_contour)


ibi_jrgeco1a = reshape(ROI_jrgeco1a,1,[]);
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
jrgeco1aCorr = mean(xform_jrgeco1aCorr(ibi_jrgeco1a,:),1);
baseline = mean(jrgeco1aCorr(1:100));
jrgeco1aCorr = jrgeco1aCorr - baseline;
% % % 
%  load('L:\GCaMP\190506\190506-G7M6-stim1_processed','xform_gcamp','xform_datahb','E_in', 'E_out', 'op_in', 'op_out')
% dpIn = op_in.dpf/2;
% dpOut = op_out.dpf/2;
% % % 
% % load('L:\GCaMP\190506\190506-G7M6-stim1_processed','xform_gcampCorr')
% % xform_gcampCorr = reshape(xform_gcampCorr, 128,128,1200,5);
% % xform_gcampCorr = mean(xform_gcampCorr,4);
% % peakMap = mean(xform_gcampCorr(:,:,101:200),3);
% % imagesc(peakMap,[-0.04 0.04])
% % axis image off
% % colormap jet
% %     hold on
% %     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
% %     barrel = AtlasSeeds == 9;
% %     ROI_barrel =  bwperim(barrel);
% % 
% % 
% %     contour(ROI_barrel,'k')
% % [X,Y] = meshgrid(1:128,1:128);
% % 
% % [x1,y1] = ginput(1);
% % [x2,y2] = ginput(1);
% % 
% % radius = sqrt((x1-x2)^2+(y1-y2)^2);
% % 
% % ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% % max_ROI = prctile(peakMap(ROI),99);
% % temp = double(peakMap).*double(ROI);
% % ROI_NoGSR = temp>max_ROI*0.75;
% % hold on
% % contour( ROI_NoGSR,'r');
% % %load('L:\GCaMP\190506\190506-G7M6-stim1_processed','ROI_NoGSR')
% 
% clear xform_gcampCorr
% ibi =  reshape(ROI_NoGSR,1,[]);
% for Beta = 0.6:0.01:0.69
%     xform_gcampCorr = correctHb_differentBeta(xform_gcamp,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,Beta);
%     xform_gcampCorr = reshape(xform_gcampCorr, 128,128,1200,5);
%     xform_gcampCorr = mean(xform_gcampCorr,4);
%     peakMap = mean(xform_gcampCorr(:,:,101:200),3);
%     figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
%     subplot('position', [0.1 0.1 0.2 0.8])
%     imagesc(peakMap,[-0.015 0.015])
%     axis image off
%     colormap jet
%     %     hold on
%     %     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
%     %     barrel = AtlasSeeds == 9;
%     %     ROI_barrel =  bwperim(barrel);
%     %
%     %
%     %     contour(ROI_barrel,'k')
% %     [X,Y] = meshgrid(1:128,1:128);
% %     
% %     [x1,y1] = ginput(1);
% %     [x2,y2] = ginput(1);
% %     
% %     radius = sqrt((x1-x2)^2+(y1-y2)^2);
% %     
% %     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% %     max_ROI = prctile(peakMap(ROI),99);
% %     temp = double(peakMap).*double(ROI);
% %     ROI_NoGSR = temp>max_ROI*0.75;
%     c = colorbar;
%     c.Ticks = [-0.015 0 0.015];
%     ylabel(c, '\DeltaF/F');
%     ibi =  reshape(ROI_NoGSR,1,[]);
%     hold on
%     contour( ROI_NoGSR,'k');
%     
%     title(strcat('Corrected GCaMP, Beta = ',num2str(Beta)))
%     set(gca,'fontweight','bold','FontSize',14)
%     
%     xform_gcampCorr =  reshape(xform_gcampCorr, 128*128,[]);
%     gcampCorr =  mean(xform_gcampCorr(ibi,:),1);
%     baseline = mean(gcampCorr(1:100));
%     gcampCorr = gcampCorr - baseline;
%     clear xform_gcampCorr
%     subplot('position', [0.45 0.15 0.5 0.7])
%     plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr/4,'m')
%     hold on
%     plot((1:length(gcampCorr))/20,gcampCorr,'g')
%     legend('Corrected RGECO /4','Corrected GCaMP')
%     xlim([0 30])
%     ylim([-0.02 0.02])
%     title(strcat('Corrected GCaMP, Beta = ',num2str(Beta)))
%     xlabel('Time(s)')
%     ylabel('Fluor(\DeltaF/F)')
%     set(gca,'fontweight','bold','FontSize',14)
%     
% end
% 
% 
% 
% excelRows = [124,126,127];
%     
% 
% excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% numMice = length(excelRows);
% 
% miceName = [];
catDir = 'L:\GCaMP\cat' ;
% 
% 
% 
% stimStartTime = 5;
% 
% nVx = 128;
% nVy = 128;
% 
% xform_datahb_mice_NoGSR = [];
% 
% xform_isbrain_mice = ones(nVx ,nVy);
% isbrain_mice = ones(nVx ,nVy);
% for excelRow = excelRows
%     
%     
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
%     
%     rawdataloc = excelRaw{3};
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     info.nVx = 128;
%     info.nVy = 128;
%     sessionInfo.miceType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.stimblocksize = excelRaw{11};
%     sessionInfo.stimbaseline=excelRaw{12};
%     sessionInfo.stimduration = excelRaw{13};
%     sessionInfo.stimFrequency = excelRaw{16};
%     sessionInfo.framerate = excelRaw{7};
%     info.freqout=1;
%     miceName = strcat(miceName,'-',mouseName);
%     
%     %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%     %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
%     
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     
% %     mouseName = char(mouseName);
% %     maskDir = rawdataloc;
% %     maskName = strcat(recDate,'-',mouseName(1:16),mouseName((end-4):end),'-LandmarksAndMask','.mat');
%     
%     load(fullfile(maskDir,maskName),'xform_isbrain');
% %     xform_isbrain = ones(128,128);
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
%     
%     %xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
%     
%     %    isbrain_mice = isbrain_mice.*isbrain;
%     
%         
% 
%         disp('loading processed data')
%         load(fullfile(saveDir, processedName_mouse),'xform_datahb_runs_NoGSR')
%         
%         
%         
%          xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_runs_NoGSR);
%        
% end
%         
% 
%     xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
 processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
%     save(fullfile(catDir,processedName_mice),'xform_datahb_mice_NoGSR','-append');
% 
 load(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice.mat'),'xform_gcampCorr_mice_NoGSR')
% %  load(fullfile(catDir,processedName_mice),'xform_gcamp_mice_NoGSR');
% %      load('L:\GCaMP\190506\190506-G7M6-stim1_processed','E_in', 'E_out', 'op_in', 'op_out')
% %      
% 
peakMap = mean(xform_gcampCorr_mice_NoGSR(:,:,101:200),3);
    figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap,[-0.02 0.02])
colorbar
axis image off
colormap jet
%     hold on
%     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
%     barrel = AtlasSeeds == 9;
%     ROI_barrel =  bwperim(barrel);
% 
% 
%     contour(ROI_barrel,'k')
[X,Y] = meshgrid(1:128,1:128);

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = double(peakMap).*double(ROI);
ROI_NoGSR = temp>max_ROI*0.75; hold on
hold on
contour( ROI_NoGSR,'k');
% ibi = reshape(ROI_NoGSR,1,[]);
%     xform_gcampCorr_mice_NoGSR =  reshape(xform_gcampCorr_mice_NoGSR, 128*128,[]);
%     gcampCorr =  mean(xform_gcampCorr_mice_NoGSR(ibi,:),1);
%     baseline = mean(gcampCorr(1:100));
%     gcampCorr = gcampCorr - baseline;
%     
% %     
%     oxy = reshape(xform_datahb_mice_NoGSR(:,:,1,:), 128*128,[]);
%     deoxy = reshape(xform_datahb_mice_NoGSR(:,:,2,:), 128*128,[]);
%     oxy = mean(oxy(ibi,:),1);
%     deoxy = mean(deoxy(ibi,:),1);
%         subplot('position', [0.45 0.15 0.5 0.7])
%     plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr/4,'m')
%     hold on
%     plot((1:length(gcampCorr))/20,gcampCorr,'g')
%      ylim([-0.02 0.02])
%        ylabel('Fluor(\DeltaF/F)')
%     
%        hold on
%        yyaxis right
%     plot((1:length(oxy))/20,oxy*10^6,'r') 
%            hold on
%     plot((1:length(deoxy))/20,deoxy*10^6,'b') 
%    
%       ylim([-15 15])
%        ylabel('Hb(\Delta\muM)')
%     legend('Corrected RGECO /4','Corrected GCaMP','HbO','HbR')
%     xlim([0 30])
%    
%     title(strcat('Corrected, then averaged'))
%     xlabel('Time(s)')
%   
%     set(gca,'fontweight','bold','FontSize',14)
    
%      load('L:\GCaMP\190506\190506-G7M6-stim1_processed','E_in', 'E_out', 'op_in', 'op_out')
% dpIn = op_in.dpf/2;
% dpOut = op_out.dpf/2;
% 
%     peakMap_beta = zeros(128,128,21);
%     timeTrace_beta =  zeros(12,1200);
%     ii = 1;
Beta = 0:0.1:2;
%     
%   for Beta = 0:0.1:2
%     xform_gcampCorr_mice_NoGSR = correctHb_differentBeta(xform_gcamp_mice_NoGSR,xform_datahb_mice_NoGSR,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,Beta,Beta);;
%     peakMap = mean(xform_gcampCorr_mice_NoGSR(:,:,101:200),3);
%     peakMap_beta(:,:,ii) = peakMap;
%     
%     xform_gcampCorr_mice_NoGSR =  reshape(xform_gcampCorr_mice_NoGSR, 128*128,[]);
%     gcampCorr =  mean(xform_gcampCorr_mice_NoGSR(ibi,:),1);
%     baseline = mean(gcampCorr(1:100));
%     gcampCorr = gcampCorr - baseline;
%     timeTrace_beta(ii,:) = gcampCorr;
%     ii = ii+1;
%     
% end
% save(fullfile(catDir,processedName_mice),'peakMap_beta','timeTrace_beta','-append');
catDir = 'L:\GCaMP\cat' ;
load(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice.mat'),'peakMap_beta','timeTrace_beta');

for ii = 1:9;
    
      figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap_beta(:,:,ii),[-0.02 0.02])
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr/4,'m')
    hold on
    plot((1:length(timeTrace_beta))/20,timeTrace_beta(ii,:),'g')
    legend('Corrected RGECO /4','Corrected GCaMP')
    xlim([0 30])
    ylim([-0.02 0.02])
    title(strcat('Corrected GCaMP, Beta = ',num2str(Beta(ii))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    pause
end



for ii = 10:12;
    
      figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap_beta(:,:,ii),[-0.02 0.02])
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr/4,'m')
    hold on
    plot((1:length(timeTrace_beta))/20,timeTrace_beta(ii,:),'g')
    legend('Corrected RGECO /4','Corrected GCaMP')
    xlim([0 30])
    ylim([-0.03 0.03])
    title(strcat('Corrected GCaMP, Beta = ',num2str(Beta(ii))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    pause
end


for ii = 13:15;
    
      figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap_beta(:,:,ii),[-0.05 0.05])
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr,'m')
    hold on
    plot((1:length(timeTrace_beta))/20,timeTrace_beta(ii,:),'g')
    legend('Corrected RGECO ','Corrected GCaMP')
    xlim([0 30])
    ylim([-0.05 0.05])
    title(strcat('Corrected GCaMP, Beta = ',num2str(Beta(ii))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    pause
end

for ii = 16:21;
    
      figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap_beta(:,:,ii),[-0.06 0.06])
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/25,jrgeco1aCorr,'m')
    hold on
    plot((1:length(timeTrace_beta))/20,timeTrace_beta(ii,:),'g')
    legend('Corrected RGECO ','Corrected GCaMP')
    xlim([0 30])
    ylim([-0.08 0.08])
    title(strcat('Corrected GCaMP, Beta = ',num2str(Beta(ii))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    pause
end

