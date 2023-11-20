clear;close all;clc
excelFile="X:\Paper2\GlobalEffects\GlobalEffects_PVChR2Thy1jRGECO1a - Copy.xlsx";
excelRows=[9,11,13,17];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!

stimDur = input('Please enter the stim duration in seconds : ');
frameRate = 20;
fc1end = frameRate*10*60;
fc2start = frameRate*(10*60+stimDur)+1;
stimstart = frameRate*10*60+1;
stimend = frameRate*(10*60+stimDur);


load("AtlasandIsbrain_Allen.mat")
load("X:\Paper2\GlobalEffects\30sPS\spectrogramTF.mat",'T1_stim','F1_stim')
mouse_ind=start_ind_mouse';

% initialize

S1_stim_ipsi_30 = nan(301,39,length(mouse_ind));
S1_stim_bilat_30 = nan(301,39,length(mouse_ind));

PS_stim_ipsi_30 = nan(301,1,length(mouse_ind));
PS_stim_bilat_30 = nan(301,1,length(mouse_ind));

S2_stim_ipsi_30 = nan(301,39,length(mouse_ind));
S2_stim_bilat_30 = nan(301,39,length(mouse_ind));

S1_stim_ipsi_60 = nan(601,19,length(mouse_ind));
S1_stim_bilat_60 = nan(601,19,length(mouse_ind));

S2_stim_ipsi_60 = nan(601,19,length(mouse_ind));
S2_stim_bilat_60 = nan(601,19,length(mouse_ind));

S1_stim_ipsi_120 = nan(1201,9,length(mouse_ind));
S1_stim_bilat_120 = nan(1201,9,length(mouse_ind));

S2_stim_ipsi_120 = nan(1201,9,length(mouse_ind));
S2_stim_bilat_120 = nan(1201,9,length(mouse_ind));


S1_fc_ipsi_30 = nan(301,39,length(mouse_ind));
S1_fc_bilat_30 = nan(301,39,length(mouse_ind));

PS_fc_ipsi_30 = nan(301,1,length(mouse_ind));
PS_fc_bilat_30 = nan(301,1,length(mouse_ind));

S2_fc_ipsi_30 = nan(301,39,length(mouse_ind));
S2_fc_bilat_30 = nan(301,39,length(mouse_ind));

S1_fc_ipsi_60 = nan(601,19,length(mouse_ind));
S1_fc_bilat_60 = nan(601,19,length(mouse_ind));

S2_fc_ipsi_60 = nan(601,19,length(mouse_ind));
S2_fc_bilat_60 = nan(601,19,length(mouse_ind));

S1_fc_ipsi_120 = nan(1201,9,length(mouse_ind));
S1_fc_bilat_120 = nan(1201,9,length(mouse_ind));

S2_fc_ipsi_120 = nan(1201,9,length(mouse_ind));
S2_fc_bilat_120 = nan(1201,9,length(mouse_ind));

mouseInd = 1;

for runInd=mouse_ind
    % Laser location
    runInfo = runsInfo(runInd);
    tmp_fc = matfile(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'));
    laser = mean(tmp_fc.xform_datalaser(:,:,stimstart:stimend),3);
    clear tmp_fc
    [~,I] = max(laser(:));
    [row,col] = ind2sub([128,128],I);

    %all the region inside of the circle with center at laser center
    [X,Y] = meshgrid(1:128,1:128);
    radius = 15; % number of pixels
    ROI_ipsi = sqrt((X-col).^2+(Y-row).^2)<radius;

    x = 129-col;
    y = row;
    ROI_bilat = sqrt((X-x).^2+(Y-y).^2)<radius;

    % exclude regions that is not inside of brain mask
    load(runInfo.saveMaskFile,'xform_isbrain')
    ROI_ipsi(~xform_isbrain) = 0;
    ROI_bilat(~xform_isbrain) = 0;

    % stim run
    tmp = matfile(runInfo.saveFluorFile);

    % time course for ipsilateral and contralateral PS region with PS
    stim1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    stim1_calcium = reshape(stim1_calcium,128*128,[]);
    stim1_calcium_ipsi = mean(stim1_calcium(ROI_ipsi(:),:));
    stim1_calcium_bilat = mean(stim1_calcium(ROI_bilat(:),:));
    clear stim1_calcium
    
    PS_stim_calcium = tmp.xform_datafluorCorr(:,:,stimstart:stimend);
    PS_stim_calcium = reshape(PS_stim_calcium,128*128,[]);
    PS_stim_calcium_ipsi = mean(PS_stim_calcium(ROI_ipsi(:),:));
    PS_stim_calcium_bilat = mean(PS_stim_calcium(ROI_bilat(:),:));
    clear PS_stim_calcium

    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    stim2_calcium = reshape(stim2_calcium,128*128,[]);
    stim2_calcium_ipsi = mean(stim2_calcium(ROI_ipsi(:),:));
    stim2_calcium_bilat = mean(stim2_calcium(ROI_bilat(:),:));
    clear stim2_calcium

    % spectrogram
    [S1_stim_ipsi_30(:,:,mouseInd),F1_stim_30,T1_stim_30] = spectrogram(stim1_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S1_stim_bilat_30(:,:,mouseInd),~,~] = spectrogram(stim1_calcium_bilat,600,300,600,frameRate,'yaxis');

    [PS_stim_ipsi_30(:,:,mouseInd),F1_PS_30,T1_PS_30] = spectrogram(PS_stim_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [PS_stim_bilat_30(:,:,mouseInd),~,~] = spectrogram(PS_stim_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S2_stim_ipsi_30(:,:,mouseInd),F2_stim_30,T2_stim_30] = spectrogram(stim2_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S2_stim_bilat_30(:,:,mouseInd),~,~] = spectrogram(stim2_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S1_stim_ipsi_60(:,:,mouseInd),F1_stim_60,T1_stim_60] = spectrogram(stim1_calcium_ipsi,1200,600,1200,frameRate,'yaxis');
    [S1_stim_bilat_60(:,:,mouseInd),~,~] = spectrogram(stim1_calcium_bilat,1200,600,1200,frameRate,'yaxis');

    [S2_stim_ipsi_60(:,:,mouseInd),F2_stim_60,T2_stim_60] = spectrogram(stim2_calcium_ipsi,1200,600,1200,frameRate,'yaxis');
    [S2_stim_bilat_60(:,:,mouseInd),~,~] = spectrogram(stim2_calcium_bilat,1200,600,1200,frameRate,'yaxis');

    [S1_stim_ipsi_120(:,:,mouseInd),F1_stim_120,T1_stim_120] = spectrogram(stim1_calcium_ipsi,2400,1200,2400,frameRate,'yaxis');
    [S1_stim_bilat_120(:,:,mouseInd),~,~] = spectrogram(stim1_calcium_bilat,2400,1200,2400,frameRate,'yaxis');

    [S2_stim_ipsi_120(:,:,mouseInd),F2_stim_120,T2_stim_120] = spectrogram(stim2_calcium_ipsi,2400,1200,2400,frameRate,'yaxis');
    [S2_stim_bilat_120(:,:,mouseInd),~,~] = spectrogram(stim2_calcium_bilat,2400,1200,2400,frameRate,'yaxis');

    %save

    % fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-dataFluor.mat'));

    % time course for ipsilateral and contralateral PS region without PS
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    fc1_calcium = reshape(fc1_calcium,128*128,[]);
    fc1_calcium_ipsi = mean(fc1_calcium(ROI_ipsi(:),:));
    fc1_calcium_bilat = mean(fc1_calcium(ROI_bilat(:),:));
    clear fc1_calcium

    PS_fc_calcium = tmp.xform_datafluorCorr(:,:,stimstart:stimend);
    PS_fc_calcium = reshape(PS_fc_calcium,128*128,[]);
    PS_fc_calcium_ipsi = mean(PS_fc_calcium(ROI_ipsi(:),:));
    PS_fc_calcium_bilat = mean(PS_fc_calcium(ROI_bilat(:),:));
    clear PS_fc_calcium

    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    fc2_calcium = reshape(fc2_calcium,128*128,[]);
    fc2_calcium_ipsi = mean(fc2_calcium(ROI_ipsi(:),:));
    fc2_calcium_bilat = mean(fc2_calcium(ROI_bilat(:),:));
    clear fc2_calcium

    % spectrogram
    [S1_fc_ipsi_30(:,:,mouseInd),F1_fc_30,T1_fc_30] = spectrogram(fc1_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S1_fc_bilat_30(:,:,mouseInd),~,~] = spectrogram(fc1_calcium_bilat,600,300,600,frameRate,'yaxis');

    [PS_fc_ipsi_30(:,:,mouseInd),F1_PS_30,T1_PS_30] = spectrogram(PS_fc_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [PS_fc_bilat_30(:,:,mouseInd),~,~] = spectrogram(PS_fc_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S2_fc_ipsi_30(:,:,mouseInd),F2_fc_30,T2_fc_30] = spectrogram(fc2_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S2_fc_bilat_30(:,:,mouseInd),~,~] = spectrogram(fc2_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S1_fc_ipsi_60(:,:,mouseInd),F1_fc_60,T1_fc_60] = spectrogram(fc1_calcium_ipsi,1200,600,1200,frameRate,'yaxis');
    [S1_fc_bilat_60(:,:,mouseInd),~,~] = spectrogram(fc1_calcium_bilat,1200,600,1200,frameRate,'yaxis');

    [S2_fc_ipsi_60(:,:,mouseInd),F2_fc_60,T2_fc_60] = spectrogram(fc2_calcium_ipsi,1200,600,1200,frameRate,'yaxis');
    [S2_fc_bilat_60(:,:,mouseInd),~,~] = spectrogram(fc2_calcium_bilat,1200,600,1200,frameRate,'yaxis');

    [S1_fc_ipsi_120(:,:,mouseInd),F1_fc_120,T1_fc_120] = spectrogram(fc1_calcium_ipsi,2400,1200,2400,frameRate,'yaxis');
    [S1_fc_bilat_120(:,:,mouseInd),~,~] = spectrogram(fc1_calcium_bilat,2400,1200,2400,frameRate,'yaxis');

    [S2_fc_ipsi_120(:,:,mouseInd),F2_fc_120,T2_fc_120] = spectrogram(fc2_calcium_ipsi,2400,1200,2400,frameRate,'yaxis');
    [S2_fc_bilat_120(:,:,mouseInd),~,~] = spectrogram(fc2_calcium_bilat,2400,1200,2400,frameRate,'yaxis');



    mouseInd = mouseInd+1;
end
save('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-spectrogram-stim.mat',...
         'S1_stim_ipsi_30','S1_stim_bilat_30','PS_stim_ipsi_30','PS_stim_bilat_30','S2_stim_ipsi_30','S2_stim_bilat_30',...
         'S1_stim_ipsi_60','S1_stim_bilat_60','S2_stim_ipsi_60','S2_stim_bilat_60',...
         'S1_stim_ipsi_120','S1_stim_bilat_120','S2_stim_ipsi_120','S2_stim_bilat_120', ...
         'F1_stim_30','F1_PS_30','F2_stim_30','F1_stim_60','F2_stim_60','F1_stim_120','F2_stim_120',...
         'T1_stim_30','T1_PS_30','T2_stim_30','T1_stim_60','T2_stim_60','T1_stim_120','T2_stim_120')
save('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-spectrogram-fc.mat',...
         'S1_fc_ipsi_30','S1_fc_bilat_30','PS_fc_ipsi_30','PS_fc_bilat_30','S2_fc_ipsi_30','S2_fc_bilat_30',...
         'S1_fc_ipsi_60','S1_fc_bilat_60','S2_fc_ipsi_60','S2_fc_bilat_60',...
         'S1_fc_ipsi_120','S1_fc_bilat_120','S2_fc_ipsi_120','S2_fc_bilat_120',...
         'F1_fc_30','F1_PS_30','F2_fc_30','F1_fc_60','F2_fc_60','F1_fc_120','F2_fc_120',...
         'T1_fc_30','T1_PS_30','T2_fc_30','T1_fc_60','T2_fc_60','T1_fc_120','T2_fc_120')
%% Visualization for ipsilateral

figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_120(2:end),abs(S1_fc_ipsi_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_ipsi_120(2:end,1,mouseInd)))
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_120(2:end),abs(S1_stim_ipsi_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_stim_120(2:end),abs(S2_stim_ipsi_120(2:end,1,mouseInd)))  
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('2mins before and after PS')

figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_60(2:end),abs(S1_fc_ipsi_60(2:end,19,mouseInd)))
    hold on
    loglog(F2_fc_60(2:end),abs(S2_fc_ipsi_60(2:end,1,mouseInd)))
    legend({'last min before PS','first min after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_60(2:end),abs(S1_stim_ipsi_60(2:end,19,mouseInd)))
    hold on
    loglog(F2_stim_60(2:end),abs(S2_stim_ipsi_60(2:end,1,mouseInd)))  
    legend({'last min before PS','first min after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('1 mins before and after PS')

figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_30(2:end),abs(S1_fc_ipsi_30(2:end,39,mouseInd)))
    hold on
    loglog(F2_fc_30(2:end),abs(S2_fc_ipsi_30(2:end,1,mouseInd)))
    legend({'last 30s before PS','first 30s after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_30(2:end),abs(S1_stim_ipsi_30(2:end,39,mouseInd)))
    hold on
    loglog(F2_stim_30(2:end),abs(S2_stim_ipsi_30(2:end,1,mouseInd)))  
    legend({'last 30s before PS','first 30s after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('30s before and after PS')

% visualization 2min before, after, 4mins after
figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_120(2:end),abs(S1_fc_ipsi_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_ipsi_120(2:end,1,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_ipsi_120(2:end,2,mouseInd)))

    legend({'last two mins before PS','first two mins after PS','1min-3min'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_120(2:end),abs(S1_stim_ipsi_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_stim_120(2:end),abs(S2_stim_ipsi_120(2:end,1,mouseInd)))  
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_ipsi_120(2:end,2,mouseInd)))

    legend({'last two mins before PS','first two mins after PS','1min-3min'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('2mins Time Fragment')

%% visualization for bilateral
figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_120(2:end),abs(S1_fc_bilat_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_bilat_120(2:end,1,mouseInd)))
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_120(2:end),abs(S1_stim_bilat_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_stim_120(2:end),abs(S2_stim_bilat_120(2:end,1,mouseInd)))  
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('2mins before and after PS')

figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_60(2:end),abs(S1_fc_bilat_60(2:end,19,mouseInd)))
    hold on
    loglog(F2_fc_60(2:end),abs(S2_fc_bilat_60(2:end,1,mouseInd)))
    legend({'last min before PS','first min after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_60(2:end),abs(S1_stim_bilat_60(2:end,19,mouseInd)))
    hold on
    loglog(F2_stim_60(2:end),abs(S2_stim_bilat_60(2:end,1,mouseInd)))  
    legend({'last min before PS','first min after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('1 mins before and after PS')

figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_30(2:end),abs(S1_fc_bilat_30(2:end,39,mouseInd)))
    hold on
    loglog(F2_fc_30(2:end),abs(S2_fc_bilat_30(2:end,1,mouseInd)))
    legend({'last 30s before PS','first 30s after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_30(2:end),abs(S1_stim_bilat_30(2:end,39,mouseInd)))
    hold on
    loglog(F2_stim_30(2:end),abs(S2_stim_bilat_30(2:end,1,mouseInd)))  
    legend({'last 30s before PS','first 30s after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    xlim([-inf inf])
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('30s before and after PS')

% visualization 2min before, after, 4mins after
figure
for mouseInd = 1:4
    runInfo = runsInfo(mouseInd);
    subplot(2,4,mouseInd)
    
    loglog(F1_fc_120(2:end),abs(S1_fc_bilat_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_bilat_120(2:end,1,mouseInd)))
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_bilat_120(2:end,2,mouseInd)))

    legend({'last two mins before PS','first two mins after PS','1min-3min'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', No PS'))
    subplot(2,4,4+mouseInd)
    
    loglog(F1_stim_120(2:end),abs(S1_stim_bilat_120(2:end,9,mouseInd)))
    hold on
    loglog(F2_stim_120(2:end),abs(S2_stim_bilat_120(2:end,1,mouseInd)))  
    hold on
    loglog(F2_fc_120(2:end),abs(S2_fc_bilat_120(2:end,2,mouseInd)))

    legend({'last two mins before PS','first two mins after PS','1min-3min'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title(strcat(runInfo.mouseName,', with PS'))
end
sgtitle('2mins Time Fragment')


%% Averaged across mice
figure
for mouseInd = 1:4
    subplot(1,2,1)
    runInfo = runsInfo(mouseInd);
    loglog(F1_fc_120(2:end),abs(mean(S1_fc_ipsi_120(2:end,9,:),3)))
    hold on
    loglog(F2_fc_120(2:end),abs(mean(S2_fc_ipsi_120(2:end,1,:),3)))
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title('No PS')
    
    subplot(1,2,2)
    loglog(F1_stim_120(2:end),abs(mean(S1_stim_ipsi_120(2:end,9,:),3)))
    hold on
    loglog(F2_stim_120(2:end),abs(mean(S2_stim_ipsi_120(2:end,1,:),3)))  
    legend({'last two mins before PS','first two mins after PS'},'location','southwest')
    xlabel('Frequency(Hz)')
    ylabel('\DeltaF/F/Hz')
    title('with PS')
end
sgtitle('2mins before and after PS Averaged across mice')
