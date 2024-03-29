%% Plot bilateral map
cd("W:\PV Mapping After Stroke\RS\GroupAvg")
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat")
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
load('GroupXformMask.mat', 'xform_isbrain_intersect')
mask = leftMask.*xform_isbrain_intersect;
load('Baseline-avgFC_ISA.mat', 'bilatFCMap_group_avg')
baseline_bilat = bilatFCMap_group_avg(:,:,1);

load('Week 1-avgFC_ISA.mat', 'bilatFCMap_group_avg')
week1_bilat    = bilatFCMap_group_avg(:,:,1);

load('Week 4-avgFC_ISA.mat', 'bilatFCMap_group_avg')
week4_bilat    = bilatFCMap_group_avg(:,:,1);

load('Week 8-avgFC_ISA.mat', 'bilatFCMap_group_avg')
week8_bilat    = bilatFCMap_group_avg(:,:,1);


subplot(141)
imagesc(tanh(baseline_bilat),[-1.4 1.4])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap jet
axis image off

subplot(142)
imagesc(tanh(week1_bilat),[-1.4 1.4])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap jet
axis image off

subplot(143)
imagesc(tanh(week4_bilat),[-1.4 1.4])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap jet
axis image off

subplot(144)
imagesc(tanh(week8_bilat),[-1.4 1.4])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap jet
axis image off

%% Plot Forepaw stim
mask = (leftMask+rightMask).*xform_isbrain_intersect;
cd("W:\PV Mapping After Stroke\Forepaw\GroupAvg")
load('GroupXformMask.mat')
load('Baseline-AvgStimResults.mat', 'data_full_gsr_BaselineShift_group_avg')
baseline_peakMap = squeeze(mean(data_full_gsr_BaselineShift_group_avg(:,:,51:100,4,:),[3,5]));

load('Week 1-AvgStimResults.mat', 'data_full_gsr_BaselineShift_group_avg')
Week1_peakMap = squeeze(mean(data_full_gsr_BaselineShift_group_avg(:,:,51:100,4,:),[3,5]));

load('Week 4-AvgStimResults.mat', 'data_full_gsr_BaselineShift_group_avg')
Week4_peakMap = squeeze(mean(data_full_gsr_BaselineShift_group_avg(:,:,51:100,4,:),[3,5]));

load('Week 8-AvgStimResults.mat', 'data_full_gsr_BaselineShift_group_avg')
Week8_peakMap = squeeze(mean(data_full_gsr_BaselineShift_group_avg(:,:,51:100,4,:),[3,5]));

figure
subplot(141)
imagesc(baseline_peakMap,[-2.5 2.5])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap(brewermap(256, '-Spectral'))
axis image off
colorbar

subplot(142)
imagesc(Week1_peakMap,[-2.5 2.5])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap(brewermap(256, '-Spectral'))
axis image off
colorbar

subplot(143)
imagesc(Week4_peakMap,[-2.5 2.5])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap(brewermap(256, '-Spectral'))
axis image off
colorbar

subplot(144)
imagesc(Week8_peakMap,[-2.5 2.5])
hold on
imagesc(xform_WL,'AlphaData',1-mask);
colormap(brewermap(256, '-Spectral'))
axis image off
colorbar
