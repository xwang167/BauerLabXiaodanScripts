% %close all
% close all;clear all;clc
import mouse.*
% % load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','xform_jrgeco1aCorr_mice_NoGSR')
% % peakMap_ROI = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,126:250),3);
% % figure
% % colormap jet
% % imagesc(peakMap_ROI,[-0.04 0.04])
% % axis image off
% %
% % [X,Y] = meshgrid(1:128,1:128);
% %
% % [x1,y1] = ginput(1);
% % [x2,y2] = ginput(1);
% %
% % radius = sqrt((x1-x2)^2+(y1-y2)^2);
% %
% % ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% % max_ROI = prctile(peakMap_ROI(ROI),99);
% % temp = double(peakMap_ROI).*double(ROI);
% % ROI_jrgeco1a = temp>max_ROI*0.75;
% % hold on
% % ROI_contour = bwperim(ROI_jrgeco1a);
% % contour( ROI_contour)
% %
% %
% % ibi_jrgeco1a = reshape(ROI_jrgeco1a,1,[]);
% % xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[]);
% % jrgeco1aCorr = mean(xform_jrgeco1aCorr(ibi_jrgeco1a,:),1);
% % baseline = mean(jrgeco1aCorr(1:100));
% % jrgeco1aCorr = jrgeco1aCorr - baseline;
% %
% %
% %
% %
 excelRows = [124,126,127];
%
%
 excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

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
alpha =  0:0.1:1.9;
beta = 0:0.1:1.9;
factorMatrix = cell(length(alpha), length(beta));


for ii = 1:length(alpha)
    for jj = 1:length(beta)
        
        factorMatrix{ii,jj} = [alpha(ii),beta(jj)];
    end
end
% %
% 
% 
% 
% for ii = 20
% %      eval(strcat('gcampCorrMatrix_mice_',num2str(ii),' = zeros(128,128,1200,length(beta),length(excelRows));'));
% %     k = 1;
%     for excelRow = excelRows
%         systemInfo.gbox = 5;
%         systemInfo.gsigma = 1.2;
%         
%         [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
%         
%         rawdataloc = excelRaw{3};
%         recDate = excelRaw{1}; recDate = string(recDate);
%         mouseName = excelRaw{2}; mouseName = string(mouseName);
%         saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%         
%         sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%         sessionInfo.darkFrameNum = excelRaw{15};
%         info.nVx = 128;
%         info.nVy = 128;
%         sessionInfo.miceType = excelRaw{17};
%         systemType =excelRaw{5};
%         sessionInfo.stimblocksize = excelRaw{11};
%         sessionInfo.stimbaseline=excelRaw{12};
%         sessionInfo.stimduration = excelRaw{13};
%         sessionInfo.stimFrequency = excelRaw{16};
%         sessionInfo.framerate = excelRaw{7};
%         info.freqout=1;
%         miceName = strcat(miceName,'-',mouseName);
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         
%         load(fullfile(maskDir,maskName),'xform_isbrain');
%         %processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
%        
%         
%         disp('loading processed data')
%         
%         
%     eval(strcat('gcampCorrMatrix_mouse_',num2str(ii),' = zeros(128,128,1200,length(beta),3);'));
%    
%         
%         for n =  1:3
%             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%             load(fullfile(saveDir,processedName),'xform_datahb','xform_gcamp','E_in', 'E_out', 'op_in', 'op_out')
%             dpIn = op_in.dpf/2;
%             dpOut = op_out.dpf/2;
%             eval(strcat('gcampCorrMatrix_',num2str(ii),' = zeros(128,128,1200, length(beta));'));
%             for jj = 1:length(beta)
%                 xform_gcampCorr = correctHb_differentBeta(xform_gcamp,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,factorMatrix{ii,jj}(1),factorMatrix{ii,jj}(2));
%                 xform_gcampCorr = process.smoothImage(xform_gcampCorr,systemInfo.gbox,systemInfo.gsigma);
%                 xform_gcampCorr = reshape(xform_gcampCorr,128,128,1200,[]);
%                 xform_gcampCorr = mean(xform_gcampCorr,4);
%                 eval(strcat('gcampCorrMatrix_',num2str(ii),'(:,:,:,jj) = xform_gcampCorr;'));
%                 disp(num2str(factorMatrix{ii,jj}))
%             end
%             
%             eval(strcat('gcampCorrMatrix_mouse_',num2str(ii),'(:,:,:,:,n) = gcampCorrMatrix_',num2str(ii),';'))
%             correctName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_Correction','.mat');
%             if ii == 1
%                 eval(strcat('save(fullfile(saveDir,correctName),',char(39),'gcampCorrMatrix_',num2str(ii),char(39),',',char(39),'-v7.3',char(39),');'))
%             else
%                 eval(strcat('save(fullfile(saveDir,correctName),',char(39),'gcampCorrMatrix_',num2str(ii),char(39),',',char(39),'-append',char(39),');'))
%             end
%            eval(strcat('clear gcampCorrMatrix_',num2str(ii)))
%         end
%         eval(strcat('gcampCorrMatrix_mouse_',num2str(ii),' = mean(gcampCorrMatrix_mouse_',num2str(ii),',5);'))
%         processedName_mouse_Correct =strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse_Correction','.mat');
%         
%         if ii ==1
%             eval(strcat('save(fullfile(saveDir,processedName_mouse_Correct),',char(39),'gcampCorrMatrix_mouse_',num2str(ii),char(39),',',char(39),'-v7.3',char(39),');'))
%         else
%             eval(strcat('save(fullfile(saveDir,processedName_mouse_Correct),',char(39),'gcampCorrMatrix_mouse_',num2str(ii),char(39),',',char(39),'-append',char(39),');'))
%         end
% eval(strcat('clear gcampCorrMatrix_mouse_',num2str(ii)))
%         eval(strcat('gcampCorrMatrix_mice_',num2str(ii),'(:,:,:,:,k) = gcampCorrMatrix_mouse_',num2str(ii),';'));
%         k = k+1;
%     end
% %     eval(strcat('gcampCorrMatrix_mice_',num2str(ii),' = mean(gcampCorrMatrix_mice_',num2str(ii),',5);'));
% %     
% %     
% %     catDir = 'L:\GCaMP\cat' ;
% %     eval(strcat('save(fullfile(catDir,',char(39),'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat',char(39),'),',char(39),'gcampCorrMatrix_mice_',num2str(ii),char(39),',',char(39),'-append',char(39),');'));
% %      eval(strcat('clear gcampCorrMatrix_mice_',num2str(ii)))
% end


% clear all;
% 
load(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice.mat'),'xform_gcampCorr_mice_NoGSR')
peakMap_g = mean(xform_gcampCorr_mice_NoGSR(:,:,101:200),3);
figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);

imagesc(peakMap_g,[-0.02 0.02])
colorbar
axis image off
colormap jet
hold on
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
barrel = AtlasSeeds == 9;
ROI_barrel =  bwperim(barrel);

contour(ROI_barrel,'k')
[X,Y] = meshgrid(1:128,1:128);

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_g(ROI),99);
temp = double(peakMap_g).*double(ROI);
ROI_NoGSR = temp>max_ROI*0.75; hold on
hold on
contour( ROI_NoGSR,'k');
ibi = reshape(ROI_NoGSR,1,[]);
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
jrgeco1aCorr =  resampledata(jrgeco1aCorr,25,20,10^-5);



% peakMap = zeros(128,128,20,20);
% timeTrace= zeros(600,20,20);
% r = zeros(20,20);
% for ii = 1:20
%     for jj = 1:20
%         eval(strcat('load(fullfile(catDir,',char(39),'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat',char(39),'),',char(39),'gcampCorrMatrix_mice_',num2str(ii),char(39),'),'))
%         eval(strcat('peakMap_temp = mean(gcampCorrMatrix_mice_',num2str(ii),'(:,:,101:200,jj),3);'))
%         peakMap(:,:,ii,jj) = peakMap_temp;
%         eval(strcat('gcampCorr =  reshape(gcampCorrMatrix_mice_',num2str(ii),'(:,:,:,jj), 128*128,[]);'))
%         gcampCorr =  mean(gcampCorr(ibi,:),1);
%         baseline = mean(gcampCorr(1:100));
%         gcampCorr = gcampCorr - baseline;
%         timeTrace(:,ii,jj) = gcampCorr(1:600);
%         r(ii,jj)=normRow(gcampCorr(100:220))*(normRow(jrgeco1aCorr(100:220)))';
%     end
% end
% 
% save(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat'),'peakMap','timeTrace','r','-append')

load(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat'),'peakMap','timeTrace','r')
for ii = 1:20;
    for jj = ii:ii+1;
    
      figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap(:,:,ii,jj)/max(max(peakMap(:,:,ii,jj))),[-1 1])
title('')
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/20,jrgeco1aCorr/jrgeco1aCorr(104),'m')
    hold on
    if timeTrace(105,ii,jj)>timeTrace(104,ii,jj)
    plot((1:length(timeTrace(:,ii,jj)))/20,timeTrace(:,ii,jj)/timeTrace(105,ii,jj),'g')
    else
         plot((1:length(timeTrace(:,ii,jj)))/20,timeTrace(:,ii,jj)/timeTrace(104,ii,jj),'g')
    end
    legend('Corrected RGECO Norm by First Peak','Corrected GCaMP Norm by first peak')
    xlim([0 30])
    title(strcat('Corrected GCaMP, alpha = ',num2str(factorMatrix{ii,jj}(1)),', beta = ',num2str(factorMatrix{ii,jj}(2)),', r = ',num2str(r(ii,jj))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    pause
    close all
    end
end

ii = 16;
jj = 1;


         figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    subplot('position', [0.1 0.1 0.2 0.8])
imagesc(peakMap(:,:,ii,jj)/max(max(peakMap(:,:,ii,jj))),[-1 1])
title('')
axis image off
colormap jet
colorbar
    hold on
    contour(ROI_NoGSR,'k')
     subplot('position', [0.45 0.15 0.5 0.7])
    plot((1:length(jrgeco1aCorr))/20,jrgeco1aCorr/jrgeco1aCorr(104),'m')
    hold on
    if timeTrace(105,ii,jj)>timeTrace(104,ii,jj)
    plot((1:length(timeTrace(:,ii,jj)))/20,timeTrace(:,ii,jj)/timeTrace(105,ii,jj),'g')
    else
         plot((1:length(timeTrace(:,ii,jj)))/20,timeTrace(:,ii,jj)/timeTrace(104,ii,jj),'g')
    end
    legend('Corrected RGECO Norm by First Peak','Corrected GCaMP Norm by first peak')
    xlim([0 30])
    title(strcat('Corrected GCaMP, alpha = ',num2str(factorMatrix{ii,jj}(1)),', beta = ',num2str(factorMatrix{ii,jj}(2)),', r = ',num2str(r(ii,jj))))
    xlabel('Time(s)')
    ylabel('Fluor(\DeltaF/F)')
    set(gca,'fontweight','bold','FontSize',14)
    


figure
imagesc(r)
axis image
colormap jet
title('Correlation')
yticks(1:2:20)
yticklabels({'0','0.2','0.4','0.6','0.8','1.0','1.2','1.4','1.6','1.8','2.0'})
xticks(1:2:20)
xticklabels({'0','0.2','0.4','0.6','0.8','1.0','1.2','1.4','1.6','1.8','2.0'})

ylabel('alpha')
xlabel('beta')
title('Correlation')
ylabel('alpha')



