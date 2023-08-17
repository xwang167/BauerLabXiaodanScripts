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


load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

% order from anterior to posterior
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

mouse_ind=start_ind_mouse';
for runInd=mouse_ind
    runInfo = runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')
    mask = xform_isbrain.*(~isnan(AtlasSeeds));
    % stim run
    tmp = matfile(runInfo.saveFluorFile);
    stim1_calcium = tmp.xform_datafluorCorr(:,:,1:fc1end);

   % Bilateral FC map
    stim1_calcium_isa = filterData(stim1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    stim1_calcium_isa_gsr = gsr(stim1_calcium_isa,mask);

    stim1_calcium_isa = reshape(stim1_calcium_isa,128*128,[]);
    stim1_calcium_isa_gsr = reshape(stim1_calcium_isa_gsr,128*128,[]);

    stim1_calcium_isa_regions = nan(12000,44);
    stim1_calcium_isa_gsr_regions = nan(12000,44);

    for region = 1:44
        stim1_calcium_isa_regions(:,region) = transpose(nanmean(stim1_calcium_isa(AtlasSeeds == find(order==region),:)));
        stim1_calcium_isa_gsr_regions(:,region) = transpose(nanmean(stim1_calcium_isa_gsr(AtlasSeeds == find(order==region),:)));
    end
    clear stim1_calcium_isa stim1_calcium_isa_gsr

    stim1_calcium_isa_regions_partCorr = nan(44,44);
    stim1_calcium_isa_regions_pearsonCorr = nan(44,44);
    for ii = 1:44
        for jj = 1:44
            A = stim1_calcium_isa_regions(:,ii);
            B = stim1_calcium_isa_regions(:,jj);
            stim1_calcium_isa_regions_pearsonCorr(ii,jj) = corr(stim1_calcium_isa_gsr_regions(:,ii),stim1_calcium_isa_gsr_regions(:,jj));
            C = stim1_calcium_isa_regions;
            C(:,[ii,jj]) = [];
            pinvC = pinv(C);
            betaA = pinvC*A;
            betaB = pinvC*B;
            regressedA = A-C*betaA;
            regressedB = B-C*betaB;
            stim1_calcium_isa_regions_partCorr(ii,jj) = corr(regressedA,regressedB);

        end
    end

    stim1_calcium_delta = filterData(stim1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);
 
    clear stim1_calcium_delta stim1_calcium



    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);

    stim2_calcium_isa = filterData(stim2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
 
    clear stim2_calcium_isa

    stim2_calcium_delta = filterData(stim2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);

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
    fc1_calcium_isa = filterData(fc1_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);

    clear fc1_calcium_isa

    fc1_calcium_delta = filterData(fc1_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);

    clear fc1_calcium_delta fc1_calcium

    fc2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);

    % Bilateral FC map
    fc2_calcium_isa = filterData(fc2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);

    clear fc2_calcium_isa

    fc2_calcium_delta = filterData(fc2_calcium,fRange_Delta(1),fRange_Delta(2),runInfo.samplingRate,xform_isbrain);

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

