clear;close all;clc
excelFile="X:\Paper2\GlobalEffects\GlobalEffects_PVChR2Thy1jRGECO1a - Copy.xlsx";
excelRows=[9,11,13,17];

fc1end = 20*10*60;
fc2start = 20*(10*60+30)+1;
stimstart = 20*10*60+1;
stimend = 20*(10*60+30);

fRange_ISA = [0.01 0.08];
fRange_Delta = [0.5 4];
edgeLen =1;
tZone = 4;

fs = 20;
validRange = -round(tZone*fs): round(tZone*fs);
tLim_ISA = [-1.5 1.5];
tLim_Delta = [-0.05 0.05];
corrThr = 0;
rLim = [-1 1];


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
    % Lag with GS
    tic;
    [lagTime_Projection_stim1_calcium_ISA,lagAmp_Projection_stim1_calcium_ISA] = calcProjectionLag(stim1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    toc;
    [lagTime_Projection_stim1_calcium_Delta,lagAmp_Projection_stim1_calcium_Delta] = calcProjectionLag(stim1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    clear stim1_calcium

    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    [lagTime_Projection_stim2_calcium_ISA,lagAmp_Projection_stim2_calcium_ISA] = calcProjectionLag(stim2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    [lagTime_Projection_stim2_calcium_Delta,lagAmp_Projection_stim2_calcium_Delta] = calcProjectionLag(stim2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    clear stim2_calcium
    clear tmp

    % Laser location
    tmp = matfile(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'));
    laser = mean(tmp.xform_datalaser(:,:,stimstart:stimend),3);
    [~,I] = max(laser(:));
    [row,col] = ind2sub([128,128],I);

    % Corresponding fc run
    tmp = matfile(strcat(runInfo.saveFilePrefix(1:end-5),'fc1-dataFluor.mat'));
    fc1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);
    % Lag with GS
    [lagTime_Projection_fc1_calcium_ISA,lagAmp_Projection_fc1_calcium_ISA] = calcProjectionLag(fc1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    [lagTime_Projection_fc1_calcium_Delta,lagAmp_Projection_fc1_calcium_Delta] = calcProjectionLag(fc1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    clear fc1_calcium
    
    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);
    [lagTime_Projection_fc2_calcium_ISA,lagAmp_Projection_fc2_calcium_ISA] = calcProjectionLag(fc2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    [lagTime_Projection_fc2_calcium_Delta,lagAmp_Projection_fc2_calcium_Delta] = calcProjectionLag(fc2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,edgeLen,validRange,corrThr);
    clear fc2_calcium
    clear tmp

    save(strcat(runInfo.saveFilePrefix(1:end-5),'_ProjLag.mat'),...
        'lagTime_Projection_stim1_calcium_ISA','lagAmp_Projection_stim1_calcium_ISA',...
        'lagTime_Projection_stim1_calcium_Delta','lagAmp_Projection_stim1_calcium_Delta',...
        'lagTime_Projection_stim2_calcium_ISA','lagAmp_Projection_stim2_calcium_ISA',...
        'lagTime_Projection_stim2_calcium_Delta','lagAmp_Projection_stim2_calcium_Delta',...
        'lagTime_Projection_fc1_calcium_ISA','lagAmp_Projection_fc1_calcium_ISA',...
        'lagTime_Projection_fc1_calcium_Delta','lagAmp_Projection_fc1_calcium_Delta',...
        'lagTime_Projection_fc2_calcium_ISA','lagAmp_Projection_fc2_calcium_ISA',...
        'lagTime_Projection_fc2_calcium_Delta','lagAmp_Projection_fc2_calcium_Delta')



    % Visualization

    % Projection Lag ISA
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(lagTime_Projection_fc1_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc1_calcium_ISA)),tLim_ISA)
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(lagTime_Projection_fc2_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc2_calcium_ISA)),tLim_ISA)
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(lagTime_Projection_fc2_calcium_ISA-lagTime_Projection_fc1_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc1_calcium_ISA)),[-0.8 0.8])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(lagTime_Projection_stim1_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim1_calcium_ISA)),tLim_ISA)
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(lagTime_Projection_stim2_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim2_calcium_ISA)),tLim_ISA)
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(lagTime_Projection_stim2_calcium_ISA-lagTime_Projection_stim1_calcium_ISA,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim1_calcium_ISA)),[-0.8 0.8])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col/2,row/2,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Projection Lag, ISA'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_projLag_ISA.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_projLag_ISA.png'))

    % Projection Lag Delta
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,1)
    imagesc(lagTime_Projection_fc1_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc1_calcium_Delta)),tLim_Delta)
    title('First resting state without PS')
    colorbar
    axis image off

    subplot(2,3,2)
    imagesc(lagTime_Projection_fc2_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc2_calcium_Delta)),tLim_Delta)
    title('Second resting state without PS')
    colorbar
    axis image off

    subplot(2,3,3)
    imagesc(lagTime_Projection_fc2_calcium_Delta-lagTime_Projection_fc1_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_fc1_calcium_Delta)),[-0.02 0.02])
    title('Difference without PS')
    colorbar
    axis image off

    subplot(2,3,4)
    imagesc(lagTime_Projection_stim1_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim1_calcium_Delta)),tLim_Delta)
    title('First resting state before PS')
    colorbar
    axis image off

    subplot(2,3,5)
    imagesc(lagTime_Projection_stim2_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim2_calcium_Delta)),tLim_Delta)
    title('Second resting state after PS')
    colorbar
    axis image off

    subplot(2,3,6)
    imagesc(lagTime_Projection_stim2_calcium_Delta-lagTime_Projection_stim1_calcium_Delta,'AlphaData',imresize(xform_isbrain,0.5).*(~isnan(lagTime_Projection_stim1_calcium_Delta)),[-0.02 0.02])
    title('Difference with PS')
    colorbar
    axis image off
    hold on
    scatter(col/2,row/2,'b','filled')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(runInfo.mouseName,', Projection Lag, Delta'))

    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_projLag_Delta.fig'))
    saveas(gca,strcat(runInfo.saveFilePrefix(1:end-5),'_projLag_Delta.png'))

    close all
end

