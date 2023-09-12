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

z
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

%% Visualization
load("X:\Paper2\GlobalEffects\30sPS\spectrogramTF.mat",'T1_stim','F1_stim')
% Color for 4 difference mice under resting state and PS
colorFc = {...
    [221,196,173]/255,
    [191,153,130]/255,
    [160,82,45]/255,
    [126,74,59]/255};

colorStim = {...
    [230,170,178]/255,
    [248,155,200]/255
    [228,79,159]/255,
    [235,47,141]/255,
    };

mouse_ind=start_ind_mouse';
for freqInd = 1:3
    for region = 1:44
        ind = find(order==region);
        region_name = label_region{ind(1)};

        % figure with fc and stim
        figure('units','normalized','outerposition',[0 0 1 1])
        mouseInd = 1;
        for runInd=mouse_ind
            runInfo = runsInfo(runInd);
            % load stim and fc run
            load(strcat(runInfo.saveFilePrefix,'-spectrogram.mat'),'S1_stim','S2_stim')
            load(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-spectrogram.mat'),'S1_fc','S2_fc')

            pre_stim = abs(mean(squeeze(S1_stim(freqInd,:,region))));
            post_stim = abs(squeeze(S2_stim(freqInd,:,region)));

            pre_fc = abs(mean(squeeze(S1_fc(freqInd,:,region))));
            post_fc = abs(squeeze(S2_fc(freqInd,:,region)));

            % plot post/pre
            plot(T1_stim/60,log10(post_fc/pre_fc),'-ko',...
                'MarkerSize',10, 'MarkerEdgeColor',colorFc{mouseInd},'MarkerFaceColor',colorFc{mouseInd})
            hold on
            plot(T1_stim/60,log10(post_stim/pre_stim),'-ko',...
                'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
            hold on
            mouseInd = mouseInd+1;
        end
        xlabel('Time(min)')
        ylabel('log_1_0(Post/Pre)')

        % legend
        L(1) = scatter(nan,nan,10, 'MarkerEdgeColor',colorFc{1},'MarkerFaceColor',colorFc{1});
        L(2) = scatter(nan,nan,10, 'MarkerEdgeColor',colorFc{2},'MarkerFaceColor',colorFc{2});
        L(3) = scatter(nan,nan,10, 'MarkerEdgeColor',colorFc{3},'MarkerFaceColor',colorFc{3});
        L(4) = scatter(nan,nan,10, 'MarkerEdgeColor',colorFc{4},'MarkerFaceColor',colorFc{4});

        L(5) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{1},'MarkerFaceColor',colorStim{1});
        L(6) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{2},'MarkerFaceColor',colorStim{2});
        L(7) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{3},'MarkerFaceColor',colorStim{3});
        L(8) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{4},'MarkerFaceColor',colorStim{4});

        legend(L,{'fc:N39M1020','fc:N40M1004','fc:N40M387','fc:N39M1019',...
            'stim:N39M1020','stim:N40M1004','stim:N40M387','stim:N39M1019'})

        % region full name
        ylim([-inf inf])
        for ii =  1:26
            shortName = FullName{ii,2};
            fullName = FullName{ii,1};
            if contains(region_name{1},shortName{1})
                if strcmp(region_name{1}(end),'L')
                    title(strcat('Left',{' '},fullName{1},...
                        ', Frequency: ',num2str(F1_stim(freqInd),2),'-',num2str(F1_stim(freqInd+1),2),'Hz'))
                else
                    title(strcat('Right',{' '},fullName{1},...
                        ', Frequency: ',num2str(F1_stim(freqInd),2),'-',num2str(F1_stim(freqInd+1),2),'Hz'))
                end
            end
        end
        freqStr = strcat(num2str(F1_stim(freqInd),2),'-',num2str(F1_stim(freqInd+1),2),'Hz');
        freqStr = strrep(freqStr,'.','p');
        saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},...
            '-spectrogram-PostoverPre-FCandStim-',freqStr,'.fig'))
        saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},...
            '-spectrogram-PostoverPre-FCandStim-',freqStr,'.png'))
        close all

        % figure with only stim
        figure('units','normalized','outerposition',[0 0 1 1])
        mouseInd = 1;
        for runInd=mouse_ind
            runInfo = runsInfo(runInd);
            % load stim and fc run
            load(strcat(runInfo.saveFilePrefix,'-spectrogram.mat'),'S1_stim','S2_stim')
            load(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-spectrogram.mat'),'S1_fc','S2_fc')

            pre_stim = abs(mean(squeeze(S1_stim(freqInd,:,region))));
            post_stim = abs(squeeze(S2_stim(freqInd,:,region)));

            % plot post/pre
            plot(T1_stim/60,log10(post_stim/pre_stim),'-ko',...
                'MarkerSize',10, 'MarkerEdgeColor',colorStim{mouseInd},'MarkerFaceColor',colorStim{mouseInd})
            hold on
            mouseInd = mouseInd+1;
        end
        xlabel('Time(min)')
        ylabel('log_1_0(Post/Pre)')

        % legend
        clear L
        L(1) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{1},'MarkerFaceColor',colorStim{1});
        L(2) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{2},'MarkerFaceColor',colorStim{2});
        L(3) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{3},'MarkerFaceColor',colorStim{3});
        L(4) = scatter(nan,nan,10, 'MarkerEdgeColor',colorStim{4},'MarkerFaceColor',colorStim{4});

        legend(L,{'stim:N39M1020','stim:N40M1004','stim:N40M387','stim:N39M1019'})

        % region full name
        ylim([-inf inf])
        for ii =  1:26
            shortName = FullName{ii,2};
            fullName = FullName{ii,1};
            if contains(region_name{1},shortName{1})
                if strcmp(region_name{1}(end),'L')
                    title(strcat('Left',{' '},fullName{1},...
                        ', Frequency: ',num2str(F1_stim(freqInd),2),'-',num2str(F1_stim(freqInd+1),2),'Hz'))
                else
                    title(strcat('Right',{' '},fullName{1},...
                        ', Frequency: ',num2str(F1_stim(freqInd),2),'-',num2str(F1_stim(freqInd+1),2),'Hz'))
                end
            end
        end
        saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},...
            '-spectrogram-PostoverPre-StimOnly-',freqStr,'.fig'))
        saveas(gca,strcat('X:\Paper2\GlobalEffects\30sPS\GroupResults\30s-',region_name{1},...
            '-spectrogram-PostoverPre-StimOnly-',freqStr,'.png'))
        close all

    end
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