clear;close all;clc
excelFile="X:\Paper2\GlobalEffects\GlobalEffects_PVChR2Thy1jRGECO1a - Copy.xlsx";
excelRows=[9,11,13,17];

fc1end = 20*10*60;
fc2start = 20*(10*60+30)+1;
stimstart = 20*10*60+1;
stimend = 20*(10*60+30);

fRange_ISA = [0.01 0.08];
fRange_Delta = [0.5 4];

runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
%% Get Masks and WL
previousDate = []; %initialize the date
mouse_ind=start_ind_mouse';
for runInd=mouse_ind
    runInfo = runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')
    % stim run
    tmp = matfile(runInfo.saveFluorFile);
    stim1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    % Power
    [whole_spectra_map_stim1_calcium,avg_cort_spec_stim1_calcium,powerMap_stim1_calcium,hz_stim1_calcium,global_sig_for_stim1_calcium,glob_sig_power_stim1_calcium] = ...
        PowerAnalysis(stim1_calcium,runInfo.samplingRate,xform_isbrain);

   % Bilateral FC map
    stim1_calcium_isa = filterData(stim1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    stim1_calcium_isa = gsr(stim1_calcium_isa,xform_isbrain);
    Bilat_stim1_calcium_isa = bilateralFC_fun(stim1_calcium_isa);
    clear stim1_calcium_isa

    stim1_calcium_delta = filterData(stim1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);
    stim1_calcium_delta = gsr(stim1_calcium_delta,xform_isbrain);
    Bilat_stim1_calcium_delta = bilateralFC_fun(stim1_calcium_delta);
    clear stim1_calcium_delta stim1_calcium



    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);

    % Power
     [whole_spectra_map_stim2_calcium,avg_cort_spec_stim2_calcium,powerMap_stim2_calcium,hz_stim2_calcium,global_sig_for_stim2_calcium,glob_sig_power_stim2_calcium] = ...
        PowerAnalysis(stim2_calcium,runInfo.samplingRate,xform_isbrain);

    stim2_calcium_isa = filterData(stim2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    stim2_calcium_isa = gsr(stim2_calcium_isa,xform_isbrain);
    Bilat_stim2_calcium_isa = bilateralFC_fun(stim2_calcium_isa);
    clear stim2_calcium_isa

    stim2_calcium_delta = filterData(stim2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);
    stim2_calcium_delta = gsr(stim2_calcium_delta,xform_isbrain);
    Bilat_stim2_calcium_delta = bilateralFC_fun(stim2_calcium_delta);
    clear stim2_calcium_delta stim2_calcium

    clear tmp

    % Laser location
    tmp = matfile(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'));
    laser = mean(tmp.xform_datalaser(:,:,stimstart:stimend),3);
    [~,I] = max(laser(:));
    [row,col] = ind2sub([128,128],I);

    % Corresponding fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc1-dataFluor.mat'));
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);

    % Power
    [whole_spectra_map_fc1_calcium,avg_cort_spec_fc1_calcium,powerMap_fc1_calcium,hz_fc1_calcium,global_sig_for_fc1_calcium,glob_sig_power_fc1_calcium] = ...
        PowerAnalysis(fc1_calcium,runInfo.samplingRate,xform_isbrain);

    fc1_calcium_isa = filterData(fc1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    fc1_calcium_isa = gsr(fc1_calcium_isa,xform_isbrain);
    Bilat_fc1_calcium_isa = bilateralFC_fun(fc1_calcium_isa);
    clear fc1_calcium_isa

    fc1_calcium_delta = filterData(fc1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);
    fc1_calcium_delta = gsr(fc1_calcium_delta,xform_isbrain);
    Bilat_fc1_calcium_delta = bilateralFC_fun(fc1_calcium_delta);
    clear fc1_calcium_delta fc1_calcium

    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);

    % Power
    [whole_spectra_map_fc2_calcium,avg_cort_spec_fc2_calcium,powerMap_fc2_calcium,hz_fc2_calcium,global_sig_for_fc2_calcium,glob_sig_power_fc2_calcium] = ...
        PowerAnalysis(fc2_calcium,runInfo.samplingRate,xform_isbrain);

    % Bilateral FC map
    fc2_calcium_isa = filterData(fc2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    fc2_calcium_isa = gsr(fc2_calcium_isa,xform_isbrain);
    Bilat_fc2_calcium_isa = bilateralFC_fun(fc2_calcium_isa);
    clear fc2_calcium_isa

    fc2_calcium_delta = filterData(fc2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);
    fc2_calcium_delta = gsr(fc2_calcium_delta,xform_isbrain);
    Bilat_fc2_calcium_delta = bilateralFC_fun(fc2_calcium_delta);
    clear fc2_calcium_delta fc2_calcium
    clear tmp

    save(strcat(runInfo.saveFilePrefix(1:end-5),'_Bilat.mat'),...
        'Bilat_fc1_calcium_isa','Bilat_fc2_calcium_isa','Bilat_stim1_calcium_isa','Bilat_stim2_calcium_isa',...
        'Bilat_fc1_calcium_delta','Bilat_fc2_calcium_delta','Bilat_stim1_calcium_delta','Bilat_stim2_calcium_delta')

    save(strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap.mat'),...
        'powerMap_fc1_calcium','powerMap_fc2_calcium','powerMap_stim1_calcium','powerMap_stim2_calcium')


    % Visualization
    % Power Total
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(log(powerMap_fc1_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc1_calcium(:,:,1))))
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(log(powerMap_fc2_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,1))))
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(log(powerMap_fc2_calcium(:,:,1))-log(powerMap_fc1_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,1))),[-0.6 0.6])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(log(powerMap_stim1_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim1_calcium(:,:,1))))
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(log(powerMap_stim2_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,1))))
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(log(powerMap_stim2_calcium(:,:,1))-log(powerMap_stim1_calcium(:,:,1)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,1))),[-0.6 0.6])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col,row,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Power Maps, Total'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_Total.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_Total.png'))
    % Power ISA
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(log(powerMap_fc1_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc1_calcium(:,:,2))))
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(log(powerMap_fc2_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,2))))
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(log(powerMap_fc2_calcium(:,:,2))-log(powerMap_fc1_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,2))),[-0.6 0.6])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(log(powerMap_stim1_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim1_calcium(:,:,2))))
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(log(powerMap_stim2_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,2))))
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(log(powerMap_stim2_calcium(:,:,2))-log(powerMap_stim1_calcium(:,:,2)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,2))),[-0.6 0.6])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col,row,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Power Maps, ISA'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_ISA.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_ISA.png'))

    % Power Delta
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(log(powerMap_fc1_calcium(:,:,3)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc1_calcium(:,:,3))))
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(log(powerMap_fc2_calcium(:,:,3)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,3))))
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(log(powerMap_fc2_calcium(:,:,3))-log(powerMap_fc1_calcium(:,:,3)),'AlphaData',xform_isbrain.*(~isnan(powerMap_fc2_calcium(:,:,3))),[-0.6 0.6])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(powerMap_stim1_calcium(:,:,3),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim1_calcium(:,:,3))))
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(log(powerMap_stim2_calcium(:,:,3)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,3))))
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(log(powerMap_stim2_calcium(:,:,3))-log(powerMap_stim1_calcium(:,:,3)),'AlphaData',xform_isbrain.*(~isnan(powerMap_stim2_calcium(:,:,3))),[-0.6 0.6])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col,row,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Power Maps, Delta'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_Delta.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_powerMap_Delta.png'))

    % Bilateral ISA
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(Bilat_fc1_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc1_calcium_isa)),[0 1])
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(Bilat_fc2_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc2_calcium_isa)),[0 1])
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(Bilat_fc2_calcium_isa-Bilat_fc1_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc2_calcium_isa)),[-0.4 0.4])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(Bilat_stim1_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim1_calcium_isa)),[0 1])
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(Bilat_stim2_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim2_calcium_isa)),[0 1])
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(Bilat_stim2_calcium_isa-Bilat_stim1_calcium_isa,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim2_calcium_isa)),[-0.4 0.4])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col,row,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Bilateral Maps, ISA'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_Bilat_ISA.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_Bilat_ISA.png'))

    % Bilateral Delta
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(Bilat_fc1_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc1_calcium_delta)),[0 1])
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(Bilat_fc2_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc2_calcium_delta)),[0 1])
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(Bilat_fc2_calcium_delta-Bilat_fc1_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_fc2_calcium_delta)),[-0.1 0.1])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(Bilat_stim1_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim1_calcium_delta)),[0 1])
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(Bilat_stim2_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim2_calcium_delta)),[0 1])
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(Bilat_stim2_calcium_delta-Bilat_stim1_calcium_delta,'AlphaData',xform_isbrain.*(~isnan(Bilat_stim2_calcium_delta)),[-0.1 0.1])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col,row,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Bilateral Maps, Delta'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_Bilat_Delta.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_Bilat_Delta.png'))
    close all
end

