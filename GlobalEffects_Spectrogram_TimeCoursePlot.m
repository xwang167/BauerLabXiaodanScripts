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

ii = 1; 
for jj = [3,4,6:25,28,29,31:50]
    label_region{ii} = parcelnames{jj};
    ii = ii+1;
end

mask_exclude = nan(128,128);
ii = 1; 
for jj = [3,4,6:25,28,29,31:50]
   mask_exclude(AtlasSeeds == jj)= ii;
    ii = ii+1;
end
clear AtlasSeeds
% order from anterior to posterior, medial to lateral, left and right
% treated the same
order = nan(1,44);

order(2) = 1;
order(2+22) = 1+22;

order(1) = 2;
order(1+22) = 2+22;

order(5) = 3;
order(5+22) = 3+22;

order(7) = 4;
order(7+22) = 4+22;

order(6) = 5;
order(6+22) = 5+22;

order(9) = 6;
order(9+22) = 6+22;

order(3) = 7;
order(3+22) = 7+22;

order(10) = 8;
order(10+22) = 8+22;

order(8) = 9;
order(8+22) = 9+22;

order(4) = 10;
order(4+22) = 10+22;

order(20) = 11;
order(20+22) = 11+22;

order(19) = 12;
order(19+22) = 12+22;

order(18) = 13;
order(18+22) = 13+22;

order(16) = 14;
order(16+22) = 14+22;

order(17) = 15;
order(17+22) = 15+22;

order(11) = 16;
order(11+22) = 16+22;

order(21) = 17;
order(21+22) = 17+22;

order(22) = 18;
order(22+22) = 18+22;

order(12) = 19;
order(12+22) = 19+22;

order(15) = 20;
order(15+22) = 20+22;

order(13) = 21;
order(13+22) = 21+22;

order(14) = 22;
order(14+22) = 22+22;

%% Average the calcium signal over Allen regions
mouse_ind=start_ind_mouse';
for runInd=mouse_ind
    runInfo = runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')
    mask_exclude(~xform_isbrain)=nan;
    % stim run
    tmp = matfile(runInfo.saveFluorFile);

    stim1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    stim1_calcium = reshape(stim1_calcium,128*128,[]);

    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    stim2_calcium = reshape(stim2_calcium,128*128,[]);
    
    S1_stim = nan(301,39,44);
    S2_stim = nan(301,39,44);
    for region = 1:44
        ind = find(order==region);
        mask_region = mask_exclude==ind;
        stim1_calcium_region = mean(stim1_calcium(mask_region(:),:));
        stim2_calcium_region = mean(stim2_calcium(mask_region(:),:));
        [S1_stim(:,:,region),F1_stim,T1_stim] = spectrogram(stim1_calcium_region,600,300,600,frameRate,'yaxis');       
        [S2_stim(:,:,region),F2_stim,T2_stim] = spectrogram(stim2_calcium_region,600,300,600,frameRate,'yaxis');

    end
    save(strcat(runInfo.saveFilePrefix,'-spectrogram.mat'),'S1_stim','S2_stim')
    clear stim1_calcium stim2_calcium
    % fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-dataFluor.mat'));
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    fc1_calcium = reshape(fc1_calcium,128*128,[]);
    
    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    fc2_calcium = reshape(fc2_calcium,128*128,[]);

    S1_fc = nan(301,39,44);
    S2_fc = nan(301,39,44);
    for region = 1:44
        ind = find(order==region);
        mask_region = mask_exclude==ind;
        fc1_calcium_region = mean(fc1_calcium(mask_region(:),:));
        fc2_calcium_region = mean(fc2_calcium(mask_region(:),:));
        [S1_fc(:,:,region),F1_fc,T1_fc] = spectrogram(fc1_calcium_region,600,300,600,frameRate,'yaxis');
        [S2_fc(:,:,region),F2_fc,T2_fc] = spectrogram(fc2_calcium_region,600,300,600,frameRate,'yaxis');        
    end
    clear fc1_calcium fc2_calcium
    save(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-spectrogram.mat'),'S1_fc','S2_fc')

end
save(strcat(runInfo.saveFolder(1:end-6),'spectrogramTF.mat'),'T1_stim','F1_stim')
%% Visualization
load("X:\Paper2\GlobalEffects\30sPS\spectrogramTF.mat",'T1_stim','F1_stim')
for region = 1:44
    ind = find(order==region);
    region_name = label_region{ind(1)};
    figure('units','normalized','outerposition',[0 0 1 1])
    for runInd=mouse_ind
        runInfo = runsInfo(runInd);
        % load stim run
        load(strcat(runInfo.saveFilePrefix,'-spectrogram.mat'),'S1_stim','S2_stim')
        % load fc run
        load(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-spectrogram.mat'),'S1_fc','S2_fc')
        scatter(zeros(length(T1_stim)),10*log10(abs(S1_fc(1,:,region))),'k','filled')
        hold on
        scatter(zeros(length(T1_stim)),10*log10(abs(S1_stim(1,:,region))),'r','filled')
        hold on
        scatter(T1_stim/60,10*log10(abs(S2_fc(1,:,region))),'k','filled')
        hold on
        scatter(T1_stim/60,10*log10(abs(S2_stim(1,:,region))),'r','filled')
    end
    xlabel('Time(min)')
    ylabel('Power(dB/Hz)')
    L(1) = scatter(nan,nan,'k','filled');
    L(2) = scatter(nan,nan,'r','filled');
    legend(L,{'No PS','PS'})
    ylim([-inf inf])
    for ii =  1:26
        shortName = FullName{ii,2};
        fullName = FullName{ii,1};
        if contains(region_name{1},shortName{1})
            if strcmp(region_name{1}(end),'L')
                title(strcat('Left',{' '},fullName{1}))
            else
                title(strcat('Right',{' '},fullName{1}))
            end
        end
    end
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},'-spectrogramTimeCourse.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},'-spectrogramTimeCourse.png'))
    close all
end

%

% 
% scatter(T1_fc/60,S1_fc(1,:,region),'b','filled') % convert to 10log10?
% hold on
% scatter(T1_fc/60,S2_fc(1,:,region),'g','filled')
% hold on
% scatter(T1_fc/60,S1_stim(1,:,region),'m','filled')
% hold on
% scatter(T1_fc/60,S2_stim(1,:,region),'r','filled')
% 
% xlabel('Time (min)')
% ylabel('Power/frequency(dB/Hz)')