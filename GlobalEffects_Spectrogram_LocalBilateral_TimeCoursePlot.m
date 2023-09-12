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
%% Visualization
load("X:\Paper2\GlobalEffects\30sPS\spectrogramTF.mat",'T1_stim','F1_stim')
% Color for 4 difference mice under resting state and PS
colorFc = {...
    [221,196,173]/255,...
    [191,153,130]/255,...
    [160,82,45]/255,...
    [126,74,59]/255};

colorStim = {...
    [230,170,178]/255,...
    [248,155,200]/255,...
    [228,79,159]/255,...
    [235,47,141]/255,
    };

mouse_ind=start_ind_mouse';

% figure with fc and stim

freqBand = {[2,5],[5,17],[17,65],[65,257]};
for freqInd = 1:4
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
        [S1_stim_ipsi,F1_stim,T1_stim] = spectrogram(stim1_calcium_ipsi,600,300,600,frameRate,'yaxis');
        [S1_stim_bilat,~,~] = spectrogram(stim1_calcium_bilat,600,300,600,frameRate,'yaxis');

        [S2_stim_ipsi,F2_stim,T2_stim] = spectrogram(stim2_calcium_ipsi,600,300,600,frameRate,'yaxis');
        [S2_stim_bilat,~,~] = spectrogram(stim2_calcium_bilat,600,300,600,frameRate,'yaxis');

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
        [S1_fc_ipsi,F1_fc,T1_fc] = spectrogram(fc1_calcium_ipsi,600,300,600,frameRate,'yaxis');
        [S1_fc_bilat,~,~] = spectrogram(fc1_calcium_bilat,600,300,600,frameRate,'yaxis');

        [S2_fc_ipsi,F2_fc,T2_fc] = spectrogram(fc2_calcium_ipsi,600,300,600,frameRate,'yaxis');
        [S2_fc_bilat,~,~] = spectrogram(fc2_calcium_bilat,600,300,600,frameRate,'yaxis');

        T1 = sort(-T1_fc);
        T2 = T2_fc;

        startFreq = num2str(F1_fc(freqBand{freqInd}(1)),2);
        startFreq = strrep(startFreq,'.','p');
        endFreq = num2str(F1_fc(freqBand{freqInd}(2)),2);
        endFreq = strrep(endFreq,'.','p');

        if mouseInd == 1
            figure('units','normalized','outerposition',[0 0 1 1])
        else
            figure(1)
        end
        subplot(211)
        plot(T1/60,10*log10(mean(abs(S1_fc_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorFc{mouseInd},'MarkerFaceColor',colorFc{mouseInd})
        hold on
        plot(T2/60,10*log10(mean(abs(S2_fc_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorFc{mouseInd},'MarkerFaceColor',colorFc{mouseInd})
        hold on
        xlabel('Time(min)')
        ylabel('Power(dB/hz)')
        title('Without PS')
        subplot(212)
        plot(T1/60,10*log10(mean(abs(S1_stim_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
        hold on
        plot(T2/60,10*log10(mean(abs(S2_stim_ipsi(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
        hold on
        xlabel('Time(min)')
        ylabel('Power(dB/hz)')
        title('with PS')
        sgtitle(strcat('Ipsilateral PS for freqency',{' '},startFreq,'-',endFreq,'Hz'))

        if mouseInd == 1
            figure('units','normalized','outerposition',[0 0 1 1])
        else
            figure(2)
        end
        subplot(211)
        plot(T1/60,10*log10(mean(abs(S1_fc_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorFc{mouseInd},'MarkerFaceColor',colorFc{mouseInd})
        hold on
        plot(T2/60,10*log10(mean(abs(S2_fc_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorFc{mouseInd},'MarkerFaceColor',colorFc{mouseInd})
        hold on
        xlabel('Time(min)')
        ylabel('Power(dB/hz)')
        title('Without PS')
        subplot(212)
        plot(T1/60,10*log10(mean(abs(S1_stim_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
        hold on
        plot(T2/60,10*log10(mean(abs(S2_stim_bilat(freqBand{freqInd}(1):freqBand{freqInd}(2),:)))),'-ko',...
            'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
        hold on
        xlabel('Time(min)')
        ylabel('Power(dB/hz)')
        title('with PS')
        sgtitle(strcat('Contralateral PS for freqency',{' '}, startFreq,'-',endFreq,'Hz'))

        mouseInd = mouseInd+1;
    end

    figure(1)
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-TimeCourse-FCandStim-',startFreq,'-',endFreq,'.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Ipsi-spectrogram-TimeCourse-FCandStim-',startFreq,'-',endFreq,'.png'))

    figure(2)
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Contra-spectrogram-TimeCourse-FCandStim-',startFreq,'-',endFreq,'.fig'))
    saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-Contra-spectrogram-TimeCourse-FCandStim-',startFreq,'-',endFreq,'.png'))
    close all
end


