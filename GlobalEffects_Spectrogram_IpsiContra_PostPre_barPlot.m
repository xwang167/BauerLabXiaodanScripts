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

S1_stim_ipsi = nan(301,39,length(mouse_ind));
S1_stim_bilat = nan(301,39,length(mouse_ind));

S2_stim_ipsi = nan(301,39,length(mouse_ind));
S2_stim_bilat = nan(301,39,length(mouse_ind));

S1_fc_ipsi = nan(301,39,length(mouse_ind));
S1_fc_bilat = nan(301,39,length(mouse_ind));

S2_fc_ipsi = nan(301,39,length(mouse_ind));
S2_fc_bilat = nan(301,39,length(mouse_ind));

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

    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    stim2_calcium = reshape(stim2_calcium,128*128,[]);
    stim2_calcium_ipsi = mean(stim2_calcium(ROI_ipsi(:),:));
    stim2_calcium_bilat = mean(stim2_calcium(ROI_bilat(:),:));
    clear stim2_calcium

    % spectrogram
    [S1_stim_ipsi(:,:,mouseInd),F1_stim,T1_stim] = spectrogram(stim1_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S1_stim_bilat(:,:,mouseInd),~,~] = spectrogram(stim1_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S2_stim_ipsi(:,:,mouseInd),F2_stim,T2_stim] = spectrogram(stim2_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S2_stim_bilat(:,:,mouseInd),~,~] = spectrogram(stim2_calcium_bilat,600,300,600,frameRate,'yaxis');

    % fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-dataFluor.mat'));

    % time course for ipsilateral and contralateral PS region without PS
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    fc1_calcium = reshape(fc1_calcium,128*128,[]);
    fc1_calcium_ipsi = mean(fc1_calcium(ROI_ipsi(:),:));
    fc1_calcium_bilat = mean(fc1_calcium(ROI_bilat(:),:));
    clear fc1_calcium

    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    fc2_calcium = reshape(fc2_calcium,128*128,[]);
    fc2_calcium_ipsi = mean(fc2_calcium(ROI_ipsi(:),:));
    fc2_calcium_bilat = mean(fc2_calcium(ROI_bilat(:),:));
    clear fc2_calcium

    % spectrogram
    [S1_fc_ipsi(:,:,mouseInd),F1_fc,T1_fc] = spectrogram(fc1_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S1_fc_bilat(:,:,mouseInd),~,~] = spectrogram(fc1_calcium_bilat,600,300,600,frameRate,'yaxis');

    [S2_fc_ipsi(:,:,mouseInd),F2_fc,T2_fc] = spectrogram(fc2_calcium_ipsi,600,300,600,frameRate,'yaxis');
    [S2_fc_bilat(:,:,mouseInd),~,~] = spectrogram(fc2_calcium_bilat,600,300,600,frameRate,'yaxis');
    mouseInd = mouseInd+1;
end

%%
freqBand = {[2,5],[5,17],[17,65],[65,257]};
for freqInd = 1:4
    startFreq = num2str(F1_fc(freqBand{freqInd}(1)),2);
    startFreq = strrep(startFreq,'.','p');
    endFreq = num2str(F1_fc(freqBand{freqInd}(2)),2);
    endFreq = strrep(endFreq,'.','p');

    % Average across 2 octave frequency bands
    fc_pre_ipsi   = mean(squeeze(mean(abs(S1_fc_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:)))));
    stim_pre_ipsi = mean(squeeze(mean(abs(S1_stim_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:)))));

    fc_post_ipsi   = squeeze(mean(abs(S2_fc_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:))));
    stim_post_ipsi = squeeze(mean(abs(S2_stim_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:))));

    fc_pre_bilat   = mean(squeeze(mean(abs(S1_fc_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:)))));
    stim_pre_bilat = mean(squeeze(mean(abs(S1_stim_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:)))));

    fc_post_bilat   = squeeze(mean(abs(S2_fc_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:))));
    stim_post_bilat = squeeze(mean(abs(S2_stim_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:,:))));

    for time = 1:size(fc_post_ipsi,1)
        % Normalized with pre stim averaged across time
        fc_post_ipsi(time,:) = fc_post_ipsi(time,:)./fc_pre_ipsi;
        stim_post_ipsi(time,:) = stim_post_ipsi(time,:)./stim_pre_ipsi;

        fc_post_bilat(time,:) = fc_post_bilat(time,:)./fc_pre_bilat;
        stim_post_bilat(time,:) = stim_post_bilat(time,:)./stim_pre_bilat;
    end

    % mean and std
    fc_post_ipsi_mean   = mean(fc_post_ipsi,2);
    stim_post_ipsi_mean = mean(stim_post_ipsi,2);
    fc_post_bilat_mean   = mean(fc_post_bilat,2);
    stim_post_bilat_mean = mean(stim_post_bilat,2);

    fc_post_ipsi_std   = std(fc_post_ipsi,0,2);
    stim_post_ipsi_std = std(stim_post_ipsi,0,2);
    fc_post_bilat_std   = std(fc_post_bilat,0,2);
    stim_post_bilat_std = std(stim_post_bilat,0,2);

    % Visualization
    switch freqInd
        case 1
            ylimit = 5;
        case 2
            ylimit = 2.5;
        case 3
            ylimit = 1.4;
        case 4
            ylimit = 1.4;
    end

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    plotBarErr(T2_fc/60,fc_post_ipsi_mean,fc_post_ipsi_std,ylimit)

    title('Without PS')
    subplot(2,1,2)
    plotBarErr(T2_stim/60,stim_post_ipsi_mean,stim_post_ipsi_std,ylimit)
    title('With PS')
    sgtitle(strcat('Ipsilateral PS for freqency',{' '},startFreq,'-',endFreq,'Hz'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-PostPreBar-FCandStim-',startFreq,'-',endFreq,'.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-PostPreBar-FCandStim-',startFreq,'-',endFreq,'.png'))

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    plotBarErr(T2_fc/60,fc_post_bilat_mean,fc_post_bilat_std,ylimit)
    title('Without PS')
    subplot(2,1,2)
    plotBarErr(T2_stim/60,stim_post_bilat_mean,stim_post_bilat_std,ylimit)
    title('With PS')
    sgtitle(strcat('Contralateral PS for freqency',{' '},startFreq,'-',endFreq,'Hz'))

    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Contra-spectrogram-PostPreBar-FCandStim-',startFreq,'-',endFreq,'.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Contra-spectrogram-PostPreBar-FCandStim-',startFreq,'-',endFreq,'.png'))
    close all
end

%% Plot over frequency for ipsilateral

for ii = 1:39
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    plotBarErrOverFreq(freqBand,length(mouse_ind),S1_fc_ipsi,S2_fc_ipsi,F2_fc,ii)
    title('Without PS')
    subplot(2,1,2)
    plotBarErrOverFreq(freqBand,length(mouse_ind),S1_stim_ipsi,S2_stim_ipsi,F2_stim,ii)
    title('With PS')
    sgtitle(strcat('Frequency content ipsilateral for time',{' '},num2str(T2_fc(ii)-15),'s',' to',{' '},num2str(T2_fc(ii)+15),'s'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-PostPreBar-FCandStim-',num2str(T2_fc(ii)),'s.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-PostPreBar-FCandStim-',num2str(T2_fc(ii)),'s.png'))
    close all
end

%% Plot over frequency for Contralateral
for ii = 1:39
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    plotBarErrOverFreq(freqBand,length(mouse_ind),S1_fc_bilat,S2_fc_bilat,F2_fc,ii)
    title('Without PS')
    subplot(2,1,2)
    plotBarErrOverFreq(freqBand,length(mouse_ind),S1_stim_bilat,S2_stim_bilat,F2_stim,ii)
    title('With PS')
    sgtitle(strcat('Frequency content bilatlateral for time',{' '},num2str(T2_fc(ii)-15),'s',' to',{' '},num2str(T2_fc(ii)+15),'s'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Bilat-spectrogram-PostPreBar-FCandStim-',num2str(T2_fc(ii)),'s.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Bilat-spectrogram-PostPreBar-FCandStim-',num2str(T2_fc(ii)),'s.png'))
    close all
end



function plotBarErr(T,meanVal,stdVal,ylimit)
errhigh = stdVal;
errlow = zeros(1,length(stdVal));
b = bar(T,meanVal);
hold on
er = errorbar(T,meanVal,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
grid on
ylabel('Post/Pre')
xlabel('Time(min)')
ylim([0 ylimit])
end

function plotBarErrOverFreq(freqBand,mouseNum,S1,S2,F,timeInd)
pre_freq = nan(4,mouseNum);
for jj = 1:4
    pre_freq(jj,:) = mean(squeeze(mean(abs(S1(freqBand{jj}(1):freqBand{jj}(2),:,:)))));
end


    post_freq = nan(4,mouseNum);
    for ii = 1:4
        post_freq(ii,:) = mean(abs(S2(freqBand{ii}(1):freqBand{ii}(2),timeInd,:)));
    end
    % normalized by pre
    post_freq = post_freq./pre_freq;
    x = 1:4;
    errhigh = std(post_freq,0,2);
    errlow = zeros(1,length(x));
    b = bar(x,mean(post_freq,2));
    b.BarWidth = 0.4;
    hold on
    er = errorbar(x,mean(post_freq,2),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    hold off
    grid on
    ylabel('Post/Pre')
    xlabel('Freqency(Hz)')
    xticklabels({strcat(num2str(F(freqBand{1}(1)),2),'-',num2str(F(freqBand{1}(2)),2)),...
                 strcat(num2str(F(freqBand{2}(1)),2),'-',num2str(F(freqBand{2}(2)),2)),...  
                 strcat(num2str(F(freqBand{3}(1)),2),'-',num2str(F(freqBand{3}(2)),2)),... 
                 strcat(num2str(F(freqBand{4}(1)),2),'-',num2str(F(freqBand{4}(2)),2))})

end






