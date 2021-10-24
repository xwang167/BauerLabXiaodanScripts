Alpha =  0.5:0.01:1;
Beta = 0.5:0.01:1;  
factorMatrix = cell(length(Alpha),length(Beta));
for ii = 1:length(Alpha)
    for jj = 1:length(Beta)        
        factorMatrix{ii,jj} = [Alpha(ii),Beta(jj)];
    end
end

import mouse.*
excelRows = [124,126,127];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

numMice = length(excelRows);

miceName = [];
catDir = 'L:\GCaMP\cat' ;
load(fullfile(catDir,'190506--G6M2-G7M6-G7M7-stim_processed_mice_Correction.mat'),'gcampCorr_ROI_Matrix_mice');
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

rms_Value = zeros(51,51);
for ii = 1:length(Alpha)
    for jj = 1:length(Beta)
         rms_Value(ii,jj)=rms(normRow(transpose(timeTrace(100:200,ii,jj)))-(normRow(jrgeco1aCorr(100:200))));
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
        title(strcat('Corrected GCaMP, alpha = ',num2str(factorMatrix{ii,jj}(1)),', beta = ',num2str(factorMatrix{ii,jj}(2)),', rms = ',num2str(rms_Value(ii,jj))))
        xlabel('Time(s)')
        ylabel('Fluor(\DeltaF/F)')
        set(gca,'fontweight','bold','FontSize',14)
     
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
imagesc(rms)
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


