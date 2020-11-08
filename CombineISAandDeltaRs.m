 load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat', 'Rs_FADCorr_Delta_mice', 'Rs_FADCorr_ISA_mice', 'Rs_jrgeco1aCorr_Delta_mice', 'Rs_jrgeco1aCorr_ISA_mice', 'Rs_total_Delta_mice', 'Rs_total_ISA_mice')

Calcium_Delta = triu(Rs_jrgeco1aCorr_Delta_mice);
Calcium_ISA = tril(Rs_jrgeco1aCorr_ISA_mice);
Rs_Calcium = Calcium_Delta+ Calcium_ISA;
figure
imagesc(Rs_Calcium,[-1.2 1.2])
colormap jet
axis image
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
set(gca,'YTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
title('Anes jRGECO1a')



FAD_Delta = triu(Rs_FADCorr_Delta_mice);
FAD_ISA = tril(Rs_FADCorr_ISA_mice);
Rs_FAD = FAD_Delta+ FAD_ISA;
figure
imagesc(Rs_FAD,[-1.2 1.2])
colormap jet
axis image
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
set(gca,'YTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
title('Anes FAD')

total_Delta = triu(Rs_total_Delta_mice);
total_ISA = tril(Rs_total_ISA_mice);
Rs_total = total_Delta+ total_ISA;
figure
imagesc(Rs_total,[-1.2 1.2])
colormap jet
axis image
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
set(gca,'YTickLabel',{'FL','ML','CL','SL','PL','RL','AL','VL','FR','MR','CR','SR','PR','RR','AR','VR'},'Fontsize',8);
title('Anes Total')