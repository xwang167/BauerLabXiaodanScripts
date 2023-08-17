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


load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

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
order(2+22) = 1;

order(1) = 2;
order(1+22) = 2;

order(5) = 3;
order(5+22) = 3;

order(7) = 4;
order(7+22) = 4;

order(6) = 5;
order(6+22) = 5;

order(9) = 6;
order(9+22) = 6;

order(3) = 7;
order(3+22) = 7;

order(10) = 8;
order(10+22) = 8;

order(8) = 9;
order(8+22) = 9;

order(4) = 10;
order(4+22) = 10;

order(20) = 11;
order(20+22) = 11;

order(19) = 12;
order(19+22) = 12;

order(18) = 13;
order(18+22) = 13;

order(16) = 14;
order(16+22) = 14;

order(17) = 15;
order(17+22) = 15;

order(11) = 16;
order(11+22) = 16;

order(21) = 17;
order(21+22) = 17;

order(22) = 18;
order(22+22) = 18;

order(12) = 19;
order(12+22) = 19;

order(15) = 20;
order(15+22) = 20;

order(13) = 21;
order(13+22) = 21;

order(14) = 22;
order(14+22) = 22;

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
    
    for region = 1:22
        ind = find(order==region);
        mask_region = logical(double(mask_exclude==ind(1))+double(mask_exclude==ind(2)));
        stim1_calcium_region = mean(stim1_calcium(mask_region(:),:));
        stim2_calcium_region = mean(stim2_calcium(mask_region(:),:));
        figure('units','normalized','outerposition',[0 0 1 1])
        region_name = label_region{ind(1)};
        sgtitle(strcat(runInfo.mouseName,'-stim',num2str(runInfo.run),', Region: ',region_name{1}(1:end-2)))
        subplot(211)
        spectrogram(stim1_calcium_region,600,300,600,frameRate,'yaxis');
        caxis([-80 -30])
        title('First 10 mins')
        subplot(212)
        spectrogram(stim2_calcium_region,600,300,600,frameRate,'yaxis');
        caxis([-80 -30])
         title('Second 10 mins')
        colormap(brewermap(256, '-Spectral'))

        saveas(gca,strcat(runInfo.saveFilePrefix,'_',region_name{1}(1:end-2),'.fig'))
        saveas(gca,strcat(runInfo.saveFilePrefix,'_',region_name{1}(1:end-2),'.png'))
        close all
    end
    clear stim1_calcium stim2_calcium
    % fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-dataFluor.mat'));
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    fc1_calcium = reshape(fc1_calcium,128*128,[]);
    
    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    fc2_calcium = reshape(fc2_calcium,128*128,[]);
    for region = 1:22
        ind = find(order==region);
        mask_region = logical(double(mask_exclude==ind(1))+double(mask_exclude==ind(2)));
        fc1_calcium_region = mean(fc1_calcium(mask_region(:),:));
        fc2_calcium_region = mean(fc2_calcium(mask_region(:),:));
        figure('units','normalized','outerposition',[0 0 1 1])
        region_name = label_region{ind(1)};
        sgtitle(strcat(runInfo.mouseName,'-fc',num2str(runInfo.run),', Region: ',region_name{1}(1:end-2)))
        subplot(211)
        spectrogram(fc1_calcium_region,600,300,600,frameRate,'yaxis');
        caxis([-80 -30])
        title('First 10 mins')
        subplot(212)
        spectrogram(fc2_calcium_region,600,300,600,frameRate,'yaxis');
        caxis([-80 -30])
         title('Second 10 mins')
        colormap(brewermap(256, '-Spectral'))

        saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'_',region_name{1}(1:end-2),'.fig'))
        saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'_',region_name{1}(1:end-2),'.png'))
        close all
    end

    clear fc1_calcium fc2_calcium
end