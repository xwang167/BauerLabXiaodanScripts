% %close all
close all;clear all;clc
import mouse.*

excelRows = [124,126,127];
%
%
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'L:\GCaMP\cat' ;



Alpha =  0.5:0.01:1;
Beta = 0.5:0.01:1;
factorMatrix = cell(length(Alpha), length(Beta));


for ii = 1:length(Alpha)
    for jj = 1:length(Beta)
        
        factorMatrix{ii,jj} = [Alpha(ii),Beta(jj)];
    end
end
% %
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
nROI = nnz(ibi);
gcampCorr_ROI_Matrix_mice = zeros(nROI,1200,length(Alpha),length(Beta),length(excelRows));
k = 1;
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
    
    
    disp('loading processed data')
    
    
    gcampCorr_ROI_Matrix_mouse = zeros(nROI,1200,length(Alpha),length(Beta),3);
    
    
    for n =  1:3
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_gcamp','E_in', 'E_out', 'op_in', 'op_out')
        xform_datahb = reshape(xform_datahb,128*128,2,[]);
        xform_gcamp = reshape(xform_gcamp,128*128,[]);
        datahb_ROI = xform_datahb(ibi,:,:);
        gcamp_ROI = xform_gcamp(ibi,:);
        clear xform_datahb xform_gcamp
        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        gcampCorr_ROI_Matrix = zeros(nROI,1200, length(Alpha), length(Beta));
        for ii = 1:length(Alpha)
      
            for jj = 1:length(Beta)
                alpha = factorMatrix{ii,jj}(1);
                beta = factorMatrix{ii,jj}(2);
                gcamp_ROI = reshape(gcamp_ROI,1,nROI,6000);
                datahb_ROI = reshape(datahb_ROI,1,nROI,2,6000);
                gcampCorr_ROI = correctHb_differentBeta(gcamp_ROI,datahb_ROI,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,alpha,beta);
                %gcampCorr_ROI = process.smoothImage(gcampCorr_ROI,systemInfo.gbox,systemInfo.gsigma);
                gcampCorr_ROI = reshape(gcampCorr_ROI,nROI,1200,[]);
                gcampCorr_ROI = mean(gcampCorr_ROI,3);
                gcampCorr_ROI_Matrix(:,:,ii,jj) = gcampCorr_ROI;
                disp(num2str(factorMatrix{ii,jj}))
            end
        end
        
        gcampCorr_ROI_Matrix_mouse(:,:,:,:,n) = gcampCorr_ROI_Matrix;
        correctName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_Correction','.mat');

    end
   gcampCorr_ROI_Matrix_mouse = mean(gcampCorr_ROI_Matrix_mouse,5);
  
 
 
   gcampCorr_ROI_Matrix_mice(:,:,:,:,k) = gcampCorr_ROI_Matrix_mouse;
   k=k+1;
end
gcampCorr_ROI_Matrix_mice = mean(gcampCorr_ROI_Matrix_mice,5);
%

    catDir = 'L:\GCaMP\cat' ;
   save(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat'),'gcampCorr_ROI_Matrix_mice','-append');




% clear all;
%

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


timeTrace = squeeze(mean(gcampCorr_ROI_Matrix_mice,1));


for ii = 1:length(Alpha);
    for jj = 1:length(Beta);
         r(ii,jj)=normRow(transpose(timeTrace(100:220,ii,jj)))*(normRow(jrgeco1aCorr(100:220)))';
        figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4]);
    
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



