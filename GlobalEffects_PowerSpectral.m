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

%% Ipsilateral
mouse_ind=start_ind_mouse';
for runInd=mouse_ind
    runInfo = runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')

    % Laser location
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
    ROI_contra = sqrt((X-x).^2+(Y-y).^2)<radius;


    % load the Calcium data during fc in the middle
    tmp_fc = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-dataFluor.mat'));
    FC_calcium_fc = tmp_fc.xform_datafluorCorr(:,:,stimstart:stimend);
    FC_calcium_fc = reshape(FC_calcium_fc,128*128,[]);

    [Pxx_ROI_ipsi,hz] = pwelch(transpose(FC_calcium_fc(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(FC_calcium_fc(ROI_contra(:),:))*100,[],[],[],frameRate);

    clear FC_calcium_fc

    Pxx_FC_calcium_fc_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_FC_calcium_fc_contra = mean(Pxx_ROI_contra,2);
    % load the calium data 1min to 30 s before the fc

    n1_calcium_fc = tmp_fc.xform_datafluorCorr(:,:,stimstart-60*frameRate:stimend-60*frameRate);
    n1_calcium_fc = reshape(n1_calcium_fc,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(n1_calcium_fc(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(n1_calcium_fc(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear n1_calcium_fc
    Pxx_n1_calcium_fc_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_n1_calcium_fc_contra = mean(Pxx_ROI_contra,2);

    % load the calium data 30s to 0 s before the fc
    n0p5_calcium_fc = tmp_fc.xform_datafluorCorr(:,:,stimstart-30*frameRate:stimend-30*frameRate);
    n0p5_calcium_fc = reshape(n0p5_calcium_fc,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(n0p5_calcium_fc(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(n0p5_calcium_fc(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear n0p5_calcium_fc
    Pxx_n0p5_calcium_fc_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_n0p5_calcium_fc_contra = mean(Pxx_ROI_contra,2);
    % load the calium data 0s to 30 s after the fc
    p0p5_calcium_fc = tmp_fc.xform_datafluorCorr(:,:,stimstart+stimDur*frameRate:stimend+stimDur*frameRate);
    p0p5_calcium_fc = reshape(p0p5_calcium_fc,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(p0p5_calcium_fc(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(p0p5_calcium_fc(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear p0p5_calcium_fc
    Pxx_p0p5_calcium_fc_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_p0p5_calcium_fc_contra = mean(Pxx_ROI_contra,2);

    % load the calium data 30s to 1 min after the fc
    p1_calcium_fc = tmp_fc.xform_datafluorCorr(:,:,stimstart+(stimDur+30)*frameRate:stimend+(stimDur+30)*frameRate);
    p1_calcium_fc = reshape(p1_calcium_fc,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(p1_calcium_fc(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(p1_calcium_fc(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear p1_calcium_fc
    Pxx_p1_calcium_fc_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_p1_calcium_fc_contra = mean(Pxx_ROI_contra,2);

    % load the Calcium data during photostimulation
    tmp_stim = matfile(runInfo.saveFluorFile);
    PS_calcium_stim = tmp_stim.xform_datafluorCorr(:,:,stimstart:stimend);
    peakMap_calcium = mean(PS_calcium_stim,3);
    PS_calcium_stim = reshape(PS_calcium_stim,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(PS_calcium_stim(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(PS_calcium_stim(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear PS_calcium_stim
    Pxx_PS_calcium_stim_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_PS_calcium_stim_contra = mean(Pxx_ROI_contra,2);

    % load the calium data 1min to 30 s before the stim
    n1_calcium_stim = tmp_stim.xform_datafluorCorr(:,:,stimstart-60*frameRate:stimend-60*frameRate);
    n1_calcium_stim = reshape(n1_calcium_stim,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(n1_calcium_stim(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(n1_calcium_stim(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear n1_calcium_stim
    Pxx_n1_calcium_stim_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_n1_calcium_stim_contra = mean(Pxx_ROI_contra,2);

    % load the calium data 30s to 0 s before the stim
    n0p5_calcium_stim = tmp_stim.xform_datafluorCorr(:,:,stimstart-30*frameRate:stimend-30*frameRate);
    n0p5_calcium_stim = reshape(n0p5_calcium_stim,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(n0p5_calcium_stim(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(n0p5_calcium_stim(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear n0p5_calcium_stim
    Pxx_n0p5_calcium_stim_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_n0p5_calcium_stim_contra = mean(Pxx_ROI_contra,2);
    % load the calium data 0s to 30 s after the stim
    p0p5_calcium_stim = tmp_stim.xform_datafluorCorr(:,:,stimstart+stimDur*frameRate:stimend+stimDur*frameRate);
    p0p5_calcium_stim = reshape(p0p5_calcium_stim,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(p0p5_calcium_stim(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(p0p5_calcium_stim(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear p0p5_calcium_stim
    Pxx_p0p5_calcium_stim_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_p0p5_calcium_stim_contra = mean(Pxx_ROI_contra,2);
    % load the calium data 30s to 1 min after the stim
    p1_calcium_stim = tmp_stim.xform_datafluorCorr(:,:,stimstart+(stimDur+30)*frameRate:stimend+(stimDur+30)*frameRate);
    p1_calcium_stim = reshape(p1_calcium_stim,128*128,[]);
    [Pxx_ROI_ipsi,hz] = pwelch(transpose(p1_calcium_stim(ROI_ipsi(:),:))*100,[],[],[],frameRate); %returns 128*128*length(hz). AKA spectra for each pixel
    [Pxx_ROI_contra,hz] = pwelch(transpose(p1_calcium_stim(ROI_contra(:),:))*100,[],[],[],frameRate);
    clear p1_calcium_stim
    Pxx_p1_calcium_stim_ipsi = mean(Pxx_ROI_ipsi,2);
    Pxx_p1_calcium_stim_contra = mean(Pxx_ROI_contra,2);

    save(strcat(runInfo.saveFilePrefix,'-powerSpectra.mat'),...
        'Pxx_n1_calcium_stim_ipsi','Pxx_n1_calcium_stim_contra',...
        'Pxx_n0p5_calcium_stim_ipsi','Pxx_n0p5_calcium_stim_contra',...
        'Pxx_PS_calcium_stim_ipsi','Pxx_PS_calcium_stim_contra',...
        'Pxx_p0p5_calcium_stim_ipsi','Pxx_p0p5_calcium_stim_contra',...
        'Pxx_p1_calcium_stim_ipsi','Pxx_p1_calcium_stim_contra')
    save(strcat(runInfo.saveFilePrefix(1:end-5),'fc',num2str(runInfo.run),'-powerSpectra.mat'),...
        'Pxx_n1_calcium_fc_ipsi','Pxx_n1_calcium_fc_contra',...
        'Pxx_n0p5_calcium_fc_ipsi','Pxx_n0p5_calcium_fc_contra',...
        'Pxx_FC_calcium_fc_ipsi','Pxx_FC_calcium_fc_contra',...
        'Pxx_p0p5_calcium_fc_ipsi','Pxx_p0p5_calcium_fc_contra',...
        'Pxx_p1_calcium_fc_ipsi','Pxx_p1_calcium_fc_contra')

    % Visualize laser and calcium peak map with laser location and ROI on
    % both sides
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(121)
    imagesc(laser)
    cb = colorbar;
    cb.Label.String = 'Counts';
    axis image off
    hold on
    scatter(col,row,'w','filled')
    title('Averaged Laser Frame')

    subplot(122)
    imagesc(peakMap_calcium*100,[-1.5 1.5])
    cb = colorbar;
    cb.Label.String = '\DeltaF/F%';
    axis image off
    hold on
    contour(ROI_ipsi,'k')
    hold on
    contour(ROI_contra,'k')
    title('Calcium PS PeakMap')
    colormap(brewermap(256, '-Spectral'))
    saveas(gca,strcat(runInfo.saveFilePrefix,'-LaserCalciumPeakMap.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix,'-LaserCalciumPeakMap.png'))

    % Ipsilateral Power Spectra for both fc and stim
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,5,1)
    loglog(hz,Pxx_n1_calcium_fc_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-60s to -30s')
    grid on

    subplot(2,5,2)
    loglog(hz,Pxx_n0p5_calcium_fc_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-30s to 0s')
    grid on

    subplot(2,5,3)
    loglog(hz,Pxx_FC_calcium_fc_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('Without PS')
    grid on

    subplot(2,5,4)
    loglog(hz,Pxx_p0p5_calcium_fc_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('0 to +30s')
    grid on

    subplot(2,5,5)
    loglog(hz,Pxx_p1_calcium_fc_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('+30s to +60s')
    grid on

    subplot(2,5,6)
    loglog(hz,Pxx_n1_calcium_stim_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-60s to -30s')
    grid on

    subplot(2,5,7)
    loglog(hz,Pxx_n0p5_calcium_stim_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-30s to 0s')
    grid on

    subplot(2,5,8)
    loglog(hz,Pxx_PS_calcium_stim_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('PS')
    grid on
    subplot(2,5,9)
    loglog(hz,Pxx_p0p5_calcium_stim_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('0 to +30s')
    grid on

    subplot(2,5,10)
    loglog(hz,Pxx_p1_calcium_stim_ipsi)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('+30s to +60s')
    grid on
    sgtitle(strcat(runInfo.mouseName,', Ipsilateral of Laser'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),num2str(runInfo.run),'-PowerSpectra-Ipsilateral.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),num2str(runInfo.run),'-PowerSpectra-Ipsilateral.png'))

    % Contralateral figure
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,5,1)
    loglog(hz,Pxx_n1_calcium_fc_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-60s to -30s')
    grid on

    subplot(2,5,2)
    loglog(hz,Pxx_n0p5_calcium_fc_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-30s to 0s')
    grid on

    subplot(2,5,3)
    loglog(hz,Pxx_FC_calcium_fc_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('Without PS')
    grid on

    subplot(2,5,4)
    loglog(hz,Pxx_p0p5_calcium_fc_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('0 to +30s')
    grid on

    subplot(2,5,5)
    loglog(hz,Pxx_p1_calcium_fc_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('+30s to +60s')
    grid on

    subplot(2,5,6)
    loglog(hz,Pxx_n1_calcium_stim_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-60s to -30s')
    grid on

    subplot(2,5,7)
    loglog(hz,Pxx_n0p5_calcium_stim_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('-30s to 0s')
    grid on

    subplot(2,5,8)
    loglog(hz,Pxx_PS_calcium_stim_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('PS')
    grid on

    subplot(2,5,9)
    loglog(hz,Pxx_p0p5_calcium_stim_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('0 to +30s')
    grid on

    subplot(2,5,10)
    loglog(hz,Pxx_p1_calcium_stim_contra)
    ylim([10^(-2.5) 5])
    xlabel('Hz')
    ylabel('(\DeltaF/F%)^2/Hz')
    title('+30s to +60s')
    grid on

    sgtitle(strcat(runInfo.mouseName,', Contralateral of Laser'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),num2str(runInfo.run),'-PowerSpectra-Contralateral.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),num2str(runInfo.run),'-PowerSpectra-Contralateral.png'))

    close all
end

