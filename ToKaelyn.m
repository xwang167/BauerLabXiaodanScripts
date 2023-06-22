%% Air 1 second
clear 
%load
load("V:\1second - Air\230309\GroupAvg\1 second-AvgStimResults.mat")
load("V:\1second - Air\230309\GroupAvg\GroupXformMask.mat")
close all
calciumStart = 52;
calciumEnd = 64;

FADStart = 53;
FADEnd = 62;

HbTStart = 58;
HbTEnd = 75;

[pix_calcium_air1_mice, pix_FAD_air1_mice, pix_HbT_air1_mice,calcium_dynamics_air1_mice,FAD_dynamics_air1_mice,HbT_dynamics_air1_mice] = ...
    generateFigure(data_full_gsr_BaselineShift_group_avg,data_full_BaselineShift_group_avg,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain_intersect,'Air 1 Second');
saveas(gcf,"V:\1second - Air\230309\GroupAvg\1 second-peakDynamics.fig")
clear data_full_gsr_BaselineShift_group_avg data_full_BaselineShift_group_avg

excelFile = "V:\SingleWhiskerStim_Air_1.xlsx";
excelRows = 2:5;
runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});

% initialize
numMouse = length(first_ind_mouse);
pix_calcium_air1 = zeros(1,numMouse);
pix_FAD_air1 = zeros(1,numMouse);
pix_HbT_air1 = zeros(1,numMouse);

calcium_dynamics_air1 = zeros(300,numMouse);
FAD_dynamics_air1 = zeros(300,numMouse);
HbT_dynamics_air1 = zeros(300,numMouse);

for ii = 1:numMouse
    runInfo = runsInfo(first_ind_mouse(ii));
    %load
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-AvgStimResults.mat');
    load(load_name, 'data_full_gsr_BaselineShift_mouse_avg')
    % block average
    data_gsr = squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,4));
    clear data_full_gsr_BaselineShift_mouse_avg
    % load
    load(load_name, 'data_full_BaselineShift_mouse_avg')
    % block average
    data_nogsr = squeeze(mean(data_full_BaselineShift_mouse_avg,4));
    clear data_full_BaselineShift_mouse_avg
    load(runInfo.saveMaskFile)
    sgText = strcat('Air 1 Second',{' Mouse'},runInfo.mouseName);
    [pix_calcium_air1(ii),pix_FAD_air1(ii),pix_HbT_air1(ii),calcium_dynamics_air1(:,ii),FAD_dynamics_air1(:,ii),HbT_dynamics_air1(:,ii)] = ...
    generateFigure(data_gsr,data_nogsr,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain,sgText);
    saveFigName = strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-SpatialPSF');
    saveas(gcf,strcat(saveFigName,'.fig'))
    saveas(gcf,strcat(saveFigName,'.png'))
    close all
end
save("V:\1second - Air\1second - Air-SpatialPSF.mat",'pix_calcium_air1','pix_FAD_air1','pix_HbT_air1','calcium_dynamics_air1','FAD_dynamics_air1','HbT_dynamics_air1')

%% Air 10 seconds
clear
load("V:\10second - Air\230310\GroupAvg\10 seconds-AvgStimResults.mat")
load("V:\10second - Air\230310\GroupAvg\GroupXformMask.mat")
calciumStart = 52;
calciumEnd = 150;

FADStart = 53;
FADEnd = 150;

HbTStart = 58;
HbTEnd = 150;

[pix_calcium_air10_mice, pix_FAD_air10_mice, pix_HbT_air10_mice,calcium_dynamics_air10_mice,FAD_dynamics_air10_mice,HbT_dynamics_air10_mice] = ...
    generateFigure(data_full_gsr_BaselineShift_group_avg,data_full_BaselineShift_group_avg,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain_intersect,'Air 10 Seconds');
saveas(gcf,"V:\10second - Air\230310\GroupAvg\10 seconds-peakDynamics.fig")
clear data_full_gsr_BaselineShift_group_avg data_full_BaselineShift_group_avg

excelFile = "V:\SingleWhiskerStim_Air_1.xlsx";
excelRows = 6:9;
runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});

% initialize
numMouse = length(first_ind_mouse);
pix_calcium_air10 = zeros(1,numMouse);
pix_FAD_air10 = zeros(1,numMouse);
pix_HbT_air10 = zeros(1,numMouse);

calcium_dynamics_air10 = zeros(300,numMouse);
FAD_dynamics_air10 = zeros(300,numMouse);
HbT_dynamics_air10 = zeros(300,numMouse);

for ii = 1:numMouse
    runInfo = runsInfo(first_ind_mouse(ii));
    %load
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-AvgStimResults.mat');
    load(load_name, 'data_full_gsr_BaselineShift_mouse_avg')
    % block average
    data_gsr = squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,4));
    clear data_full_gsr_BaselineShift_mouse_avg
    % load
    load(load_name, 'data_full_BaselineShift_mouse_avg')
    % block average
    data_nogsr = squeeze(mean(data_full_BaselineShift_mouse_avg,4));
    clear data_full_BaselineShift_mouse_avg
    load(runInfo.saveMaskFile)
    sgText = strcat('Air 10 Second',{' Mouse'},runInfo.mouseName);
    [pix_calcium_air10(ii),pix_FAD_air10(ii),pix_HbT_air10(ii),calcium_dynamics_air10(:,ii),FAD_dynamics_air10(:,ii),HbT_dynamics_air10(:,ii)] = ...
    generateFigure(data_gsr,data_nogsr,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain,sgText);
    saveFigName = strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-SpatialPSF');
    saveas(gcf,strcat(saveFigName,'.fig'))
    saveas(gcf,strcat(saveFigName,'.png'))
    close all
end
save("V:\10second - Air\10second - Air-SpatialPSF.mat",'pix_calcium_air10','pix_FAD_air10','pix_HbT_air10','calcium_dynamics_air10','FAD_dynamics_air10','HbT_dynamics_air10')


%% Piezo 1 second
clear
load("V:\1second - Piezo\GroupAvg\1 second-AvgStimResults.mat")
load("V:\1second - Piezo\GroupAvg\GroupXformMask.mat")
calciumStart = 52;
calciumEnd = 64;

FADStart = 53;
FADEnd = 62;

HbTStart = 58;
HbTEnd = 75;

[pix_calcium_piezo1_mice, pix_FAD_piezo1_mice, pix_HbT_piezo1_mice,calcium_dynamics_piezo1_mice,FAD_dynamics_piezo1_mice,HbT_dynamics_piezo1_mice] = ...
    generateFigure(data_full_gsr_BaselineShift_group_avg,data_full_BaselineShift_group_avg,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain_intersect,'Piezo 1 Second');
saveas(gcf,"V:\1second - Piezo\GroupAvg\1 second-peakDynamics.fig")
clear data_full_gsr_BaselineShift_group_avg data_full_BaselineShift_group_avg

%% initialize
excelFile = "V:\SingleWhiskerStim_Piezo_1.xlsx";
excelRows = [2,4,5,6,10,11];
runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});

numMouse = length(first_ind_mouse);
pix_calcium_piezo1 = zeros(1,numMouse);
pix_FAD_piezo1 = zeros(1,numMouse);
pix_HbT_piezo1 = zeros(1,numMouse);

calcium_dynamics_piezo1 = zeros(300,numMouse);
FAD_dynamics_piezo1 = zeros(300,numMouse);
HbT_dynamics_piezo1 = zeros(300,numMouse);

for ii = 1:numMouse
    runInfo = runsInfo(first_ind_mouse(ii));
    %load
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-AvgStimResults.mat');
    load(load_name, 'data_full_gsr_BaselineShift_mouse_avg')
    % block average
    data_gsr = squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,4));
    clear data_full_gsr_BaselineShift_mouse_avg
    % load
    load(load_name, 'data_full_BaselineShift_mouse_avg')
    % block average
    data_nogsr = squeeze(mean(data_full_BaselineShift_mouse_avg,4));
    clear data_full_BaselineShift_mouse_avg
    load(runInfo.saveMaskFile)
    sgText = strcat('Piezo 1 Second',{' Mouse'},runInfo.mouseName);
    [pix_calcium_piezo1(ii),pix_FAD_piezo1(ii),pix_HbT_piezo1(ii),calcium_dynamics_piezo1(:,ii),FAD_dynamics_piezo1(:,ii),HbT_dynamics_piezo1(:,ii)] = ...
    generateFigure(data_gsr,data_nogsr,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain,sgText);
    saveFigName = strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-SpatialPSF');
    saveas(gcf,strcat(saveFigName,'.fig'))
    saveas(gcf,strcat(saveFigName,'.png'))
    close all
end
save("V:\1second - Piezo\1second - Piezo-SpatialPSF.mat",'pix_calcium_piezo1','pix_FAD_piezo1','pix_HbT_piezo1','calcium_dynamics_piezo1','FAD_dynamics_piezo1','HbT_dynamics_piezo1')


%% Piezo 10 second
clear
load("V:\10second - Piezo\GroupAvg\10 second-AvgStimResults.mat")
load("V:\10second - Piezo\GroupAvg\GroupXformMask.mat")
calciumStart = 52;
calciumEnd = 150;

FADStart = 53;
FADEnd = 150;

HbTStart = 58;
HbTEnd = 150;


[pix_calcium_piezo10_mice, pix_FAD_piezo10_mice, pix_HbT_piezo10_mice,calcium_dynamics_apiezo10_mice,FAD_dynamics_piezo10_mice,HbT_dynamics_piezo10_mice] = ...
    generateFigure(data_full_gsr_BaselineShift_group_avg,data_full_BaselineShift_group_avg,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain_intersect,'Piezo 10 Seconds');
saveas(gcf,"V:\10second - Piezo\GroupAvg\10 second-peakDynamics.fig")
clear data_full_gsr_BaselineShift_group_avg data_full_BaselineShift_group_avg

%% initialize
excelFile = "V:\SingleWhiskerStim_Piezo_1.xlsx";
excelRows = [3,7,8,9,12,13];
runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});


numMouse = length(first_ind_mouse);
pix_calcium_piezo10 = zeros(1,numMouse);
pix_FAD_piezo10 = zeros(1,numMouse);
pix_HbT_piezo10 = zeros(1,numMouse);

calcium_dynamics_piezo10 = zeros(300,numMouse);
FAD_dynamics_piezo10 = zeros(300,numMouse);
HbT_dynamics_piezo10 = zeros(300,numMouse);

for ii = 1:numMouse
    runInfo = runsInfo(first_ind_mouse(ii));
    %load
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-AvgStimResults.mat');
    load(load_name, 'data_full_gsr_BaselineShift_mouse_avg')
    % block average
    data_gsr = squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,4));
    clear data_full_gsr_BaselineShift_mouse_avg
    % load
    load(load_name, 'data_full_BaselineShift_mouse_avg')
    % block average
    data_nogsr = squeeze(mean(data_full_BaselineShift_mouse_avg,4));
    clear data_full_BaselineShift_mouse_avg
    load(runInfo.saveMaskFile)
    sgText = strcat('Piezo 10 Second',{' Mouse'},runInfo.mouseName);
    [pix_calcium_piezo10(ii),pix_FAD_piezo10(ii),pix_HbT_piezo10(ii),calcium_dynamics_piezo10(:,ii),FAD_dynamics_piezo10(:,ii),HbT_dynamics_piezo10(:,ii)] = ...
    generateFigure(data_gsr,data_nogsr,calciumStart,calciumEnd,FADStart,FADEnd,HbTStart,HbTEnd,xform_isbrain,sgText);
    saveFigName = strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-SpatialPSF');
    saveas(gcf,strcat(saveFigName,'.fig'))
    saveas(gcf,strcat(saveFigName,'.png'))
    close all
end
save("V:\10second - Piezo\10second - Piezo-SpatialPSF.mat",'pix_calcium_piezo10','pix_FAD_piezo10','pix_HbT_piezo10','calcium_dynamics_piezo10','FAD_dynamics_piezo10','HbT_dynamics_piezo10')

% Generate box plot for activation area
clear
load("V:\1second - Air\1second - Air-SpatialPSF.mat",'pix_calcium_air1','pix_FAD_air1','pix_HbT_air1','calcium_dynamics_air1','FAD_dynamics_air1','HbT_dynamics_air1')
load("V:\10second - Air\10second - Air-SpatialPSF.mat",'pix_calcium_air10','pix_FAD_air10','pix_HbT_air10','calcium_dynamics_air10','FAD_dynamics_air10','HbT_dynamics_air10')
load("V:\1second - Piezo\1second - Piezo-SpatialPSF.mat",'pix_calcium_piezo1','pix_FAD_piezo1','pix_HbT_piezo1','calcium_dynamics_piezo1','FAD_dynamics_piezo1','HbT_dynamics_piezo1')
load("V:\10second - Piezo\10second - Piezo-SpatialPSF.mat",'pix_calcium_piezo10','pix_FAD_piezo10','pix_HbT_piezo10','calcium_dynamics_piezo10','FAD_dynamics_piezo10','HbT_dynamics_piezo10')


compareContrasts = cell(1,3);

compareContrasts{1} = [[pix_calcium_air1,nan,nan]',[pix_calcium_air10,nan,nan]',pix_calcium_piezo1',pix_calcium_piezo10']*(0.078)^2;% pad mice with air with nan to match size
compareContrasts{2} = [[pix_FAD_air1,nan,nan]',[pix_FAD_air10,nan,nan]',pix_FAD_piezo1',pix_FAD_piezo10']*(0.078)^2;
compareContrasts{3} = [[pix_HbT_air1,nan,nan]',[pix_HbT_air10,nan,nan]',pix_HbT_piezo1',pix_HbT_piezo10']*(0.078)^2;
labels ={'Calcium','FAD','HbT'};
grpLabels = {'Air 1 s','Air 10 s','Piezo 1 s','Piezo 10 s'};
figure
boxplotGroup(compareContrasts,'Colors',[1 0 1; 0 0.5 0; 0 0 0],'GroupType','betweenGroups','SecondaryLabels',grpLabels,'interGroupSpace',2)
set(gca,'xtick',[])
ylim([0.3 2.8])
ylabel('Area(mm^2)')
title('Activation Area Comparison')

% Time course for activation
figure
subplot(131);
plot_distribution_prctile(-4.9:0.1:25,calcium_dynamics_air1','Color',[1,0,0])
hold on
plot_distribution_prctile(-4.9:0.1:25,calcium_dynamics_air10','Color',[0,0,1])
hold on
plot_distribution_prctile(-4.9:0.1:25,calcium_dynamics_piezo1','Color',[0.9290 0.6940 0.1250])
hold on
plot_distribution_prctile(-4.9:0.1:25,calcium_dynamics_piezo10','Color',[0.4940 0.1840 0.5560])
title('Calcium')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
xlim([0 15])
subplot(132);
plot_distribution_prctile(-4.9:0.1:25,FAD_dynamics_air1','Color',[1,0,0])
hold on
plot_distribution_prctile(-4.9:0.1:25,FAD_dynamics_air10','Color',[0,0,1])
hold on
plot_distribution_prctile(-4.9:0.1:25,FAD_dynamics_piezo1','Color',[0.9290 0.6940 0.1250])
hold on
plot_distribution_prctile(-4.9:0.1:25,FAD_dynamics_piezo10','Color',[0.4940 0.1840 0.5560])
title('FAD')
xlim([0 15])
xlabel('Time(s)')
ylabel('\DeltaF/F%')
subplot(133);
plot_distribution_prctile(-4.9:0.1:25,HbT_dynamics_air1','Color',[1,0,0])
hold on
plot_distribution_prctile(-4.9:0.1:25,HbT_dynamics_air10','Color',[0,0,1])
hold on
plot_distribution_prctile(-4.9:0.1:25,HbT_dynamics_piezo1','Color',[0.9290 0.6940 0.1250])
hold on
plot_distribution_prctile(-4.9:0.1:25,HbT_dynamics_piezo10','Color',[0.4940 0.1840 0.5560])
title('HbT')
xlim([0 15])
xlabel('Time(s)')
ylabel('\Delta\muM')
%add legend
hold on
h = zeros(3, 1);
h(1) = plot(NaN,NaN,'Color',[1,0,0],'LineWidth',2);
h(2) = plot(NaN,NaN,'Color',[0,0,1],'LineWidth',2);
h(3) = plot(NaN,NaN,'Color',[0.9290 0.6940 0.1250],'LineWidth',2);
h(4) = plot(NaN,NaN,'Color',[0.4940 0.1840 0.5560],'LineWidth',2);
legend(h, 'Air 1s','Air 10s','Piezo 1s','Piezo 10s','LineWidth',2);