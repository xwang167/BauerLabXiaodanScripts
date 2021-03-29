


saveDir_cat = 'L:\RGECO\cat';
processedName_mice_awake = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
                            
processedName_mice_anes = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
load(fullfile(saveDir_cat, processedName_mice_awake),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')
% load xform_isbrain-mice
contrasts = ["jrgeco1aCorr","FADCorr","total"];
freqBand = ["ISA","Delta"];
A =  ones(16);
triup = triu(A,1);
trilow = tril(A,-1);

% %Visualize ISA and Delta FC matirx
% for ii = 1:3
%         eval(strcat('Rs_',contrasts(ii),'_Delta_mice_temp = Rs_',contrasts(ii),'_Delta_mice.*triup;'))
%         eval(strcat('Rs_',contrasts(ii),'_ISA_mice_temp = Rs_',contrasts(ii),'_ISA_mice.*trilow;'))
%         eval(strcat('Rs_',contrasts(ii),'_tri = Rs_',contrasts(ii),'_Delta_mice_temp + Rs_',contrasts(ii),'_ISA_mice_temp;'))
%         figure
%         colormap jet
%         eval(strcat('imagesc(Rs_',contrasts(ii),'_tri, [-1.1 1.1])'))
%         axis image
%         
% 
% set(gca,'XTick',(1:16));
% set(gca,'YTick',(1:16));
% set(gca,'XTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
% set(gca,'YTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
% 
%         title(strcat('Awake',{' '},contrasts(ii)))
%         set(gca,'FontSize',10,'FontWeight','Bold')
%  end


for ii = 1:3
    for jj = 1:2
        eval(strcat('Rs_',contrasts(ii),'_',freqBand(jj),'_mice = Rs_',contrasts(ii),'_',freqBand(jj),'_mice(logical(triup));'))
    end
end

for ii = 1:3
  
        eval(strcat('Rs_',contrasts(ii),'_mice_spcorr = corr(Rs_',contrasts(ii),'_ISA_mice,Rs_',contrasts(ii),'_Delta_mice);'))
 
end


load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_isbrain_mice')
ibi = reshape(xform_isbrain_mice,128*128,1);
totalIsbrainPixel = sum(ibi,'all');

for ii = 1:3
    eval(strcat('R_',contrasts(ii),'_mice_spcorr = nan(16,1);'))
    for jj = 1:2
         eval(strcat('R_',contrasts(ii),'_',freqBand(jj),'_mice_temp = nan(totalIsbrainPixel,16);'))
         eval(strcat('R_',contrasts(ii),'_',freqBand(jj),'_mice = reshape(R_',contrasts(ii),'_',freqBand(jj),'_mice,128*128,16);'))
           for ll = 1:16
             eval(strcat('R_',contrasts(ii),'_',freqBand(jj),'_mice_temp(:,ll)= R_',contrasts(ii),'_',freqBand(jj),'_mice(logical(ibi),ll);'))
           end
    end
     
end

for ii = 1:3
    eval(strcat('R_',contrasts(ii),'_mice_spcorr = nan(1,16);'))
    for ll = 1:16
        eval(strcat('R_',contrasts(ii),'_mice_spcorr(ll) = nancorr(R_',contrasts(ii),'_ISA_mice_temp(:,ll),R_',contrasts(ii),'_Delta_mice_temp(:,ll));'))
        
    end
end
figure
xticks = 1:1:16;
plot(R_jrgeco1aCorr_mice_spcorr,'m')
hold on
plot(R_FADCorr_mice_spcorr,'g') 
hold on
plot(R_total_mice_spcorr,'k')
title('Anes Mice')
set(gca,'XTick',1:16)
xticklabels({'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'})

figure
xticks = 1:1:16;
plot(R_jrgeco1aCorr_mice_spcorr,'m')
hold on
plot(R_FADCorr_mice_spcorr,'g') 
hold on
plot(R_total_mice_spcorr,'k')
title('Anes Mice')
set(gca,'XTick',1:16)
xticklabels({'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'})
