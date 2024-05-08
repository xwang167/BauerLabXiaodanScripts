load('E:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_datahb')
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\AtlasandIsbrain.mat')


load('E:\RGECO\Kenny\190627\190627-R5M2285-fc1-dataFluor.mat', 'xform_isbrain')
load('E:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_FAD')
HbO = xform_datahb(:,:,1,:);
HbR = xform_datahb(:,:,2,:);
clear xform_datahb
% Reshape
HbO = reshape(HbO,      128*128,[])*10^6;
HbR = reshape(HbR,      128*128,[])*10^6;
FAD = reshape(xform_FAD,128*128,[])*100;
clear xform_FAD
% Time course
mask_p = AtlasSeeds == 14;
mask_v = AtlasSeeds == 17;
mask_p = logical(mask_p.*xform_isbrain);
mask_v = logical(mask_v.*xform_isbrain);
figure
imagesc(mask_p)
imagesc(mask_v)

% Time course median
timecourse_HbO_p = median(HbO(mask_p(:),:));
timecourse_HbR_p = median(HbR(mask_p(:),:));
timecourse_FAD_p = median(FAD(mask_p(:),:));
timecourse_HbO_v = median(HbO(mask_v(:),:));
timecourse_HbR_v = median(HbR(mask_v(:),:));
timecourse_FAD_v = median(FAD(mask_v(:),:));
% Visualization of time course
figure
subplot(211)
plot((1:14999)/25,timecourse_HbO_p,'r')
hold on
plot((1:14999)/25,timecourse_HbR_p,'b')
hold on
plot((1:14999)/25,timecourse_FAD_p,'g')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \muM')
legend('HbO','HbR','Raw FAD')
title('Parietal')
ylim([-20 30])
subplot(212)
plot((1:14999)/25,timecourse_HbO_v,'r')
hold on
plot((1:14999)/25,timecourse_HbR_v,'b')
hold on
plot((1:14999)/25,timecourse_FAD_v,'g')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \muM')
ylim([-20 30])
legend('HbO','HbR','Raw FAD')
title('Visual')
[pxx_HbO_p,hz] = pwelch(timecourse_HbO_p,[],[],[],25);
pxx_HbR_p      = pwelch(timecourse_HbR_p,[],[],[],25);
pxx_FAD_p      = pwelch(timecourse_FAD_p,[],[],[],25);
pxx_HbO_v      = pwelch(timecourse_HbO_v,[],[],[],25);
pxx_HbR_v      = pwelch(timecourse_HbR_v,[],[],[],25);
pxx_FAD_v      = pwelch(timecourse_FAD_v,[],[],[],25);

figure
subplot(121)
loglog(hz,pxx_HbO_p,'r')
hold on
loglog(hz,pxx_HbR_p,'b')
hold on
loglog(hz,pxx_FAD_p,'g')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F%)^2/Hz or (\muM)^2/Hz')
legend('HbO','HbR','Raw FAD')
title('Parietal')
subplot(122)
loglog(hz,pxx_HbO_v,'r')
hold on
loglog(hz,pxx_HbR_v,'b')
hold on
loglog(hz,pxx_FAD_v,'g')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F%)^2/Hz or (\muM)^2/Hz')
legend('HbO','HbR','Raw FAD')
title('Visual')


HbO_brain = HbO(logical(xform_isbrain(:)),:);
[U_HbO,S_HbO,V_HbO] = svd(HbO_brain);
figure
for i = 1:10
U_full = nan(128^2,1);
U_full(logical(xform_isbrain(:))) = U_HbO(:,i);
subplot(5,2,i);
imagesc(U_full, 'AlphaData',xform_isbrain);
end
figure
for i = 1:10
U_full = nan(128^2,1);
U_full(logical(xform_isbrain(:))) = U_HbO(:,i);
subplot(5,2,i);
imagesc(reshape(U_full,128,[]), 'AlphaData',xform_isbrain);
end
figure
for i = 1:10
U_full = nan(128^2,1);
U_full(logical(xform_isbrain(:))) = U_HbO(:,i);
subplot(5,2,i);
imagesc(reshape(U_full,128,[]), 'AlphaData',xform_isbrain);
axis square; colorbar
end
figure; plot(diag(S_HbO));
var_explained_mode = diag(S_HbO).^2/(sum(diag(S_HbO).^2));
figure; yyaxis left; plot(var_explained_mode);
yyaxis right; cumsum(var_explained_mode);
xlim([0 20])
yyaxis right; plot(cumsum(var_explained_mode));

numModes = 9;
data_95 = U_HbO(:,1:numModes)*S_HbO(1:numModes,1:numModes)*V_HbO(:,1:numModes)';

numModes = 36;
data_99 = U_HbO(:,1:numModes)*S_HbO(1:numModes,1:numModes)*V_HbO(:,1:numModes)';

xlim([0 50]);
yyaxis left;ylabel('Variance Explained')


HbO_95 = nan(128*128,14999);
HbO_95(xform_isbrain(:),:) = data_95;

HbO_95_p = median(HbO_95(mask_p(:),:))*10^6;
pxx_HbO_95_p = pwelch(HbO_95_p,[],[],[],25);

pxxs_HbO_95_p = pwelch(HbO_95(mask_p(:),:)',[],[],[],25);
pxxs_HbO_95_p_median = median(pxxs_HbO_95_p,2);

pxxs_HbO_100_p = pwelch(HbO(mask_p(:),:)',[],[],[],25);
pxxs_HbO_100_p_median = median(pxxs_HbO_100_p,2);

