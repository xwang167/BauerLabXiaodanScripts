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
    clear stim1_calcium
    stim1_calcium_isa = reshape(stim1_calcium_isa,128*128,[]);

    stim1_calcium_isa_regions = nan(12000,44);

    for region = 1:44
        stim1_calcium_isa_regions(:,region) = transpose(nanmean(stim1_calcium_isa(AtlasSeeds == find(order==region),:)));
    end
    clear stim1_calcium_isa

    stim1_calcium_isa_regions_partCorr = nan(44,44);
    stim1_calcium_isa_regions_pearsonCorr = nan(44,44);
    for ii = 1:44
        for jj = 1:44
            A = stim1_calcium_isa_regions(:,ii);
            B = stim1_calcium_isa_regions(:,jj);
            stim1_calcium_isa_regions_pearsonCorr(ii,jj) = corr(A,B);
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

    stim2_calcium = tmp.xform_datafluorCorr(:,:,fc2start:end);

    % Bilateral FC map
    stim2_calcium_isa = filterData(stim2_calcium,fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
    clear stim2_calcium
    stim2_calcium_isa = reshape(stim2_calcium_isa,128*128,[]);

    stim2_calcium_isa_regions = nan(12000,44);

    for region = 1:44
        stim2_calcium_isa_regions(:,region) = transpose(nanmean(stim2_calcium_isa(AtlasSeeds == find(order==region),:)));
    end
    clear stim2_calcium_isa

    stim2_calcium_isa_regions_partCorr = nan(44,44);
    stim2_calcium_isa_regions_pearsonCorr = nan(44,44);
    for ii = 1:44
        for jj = 1:44
            A = stim2_calcium_isa_regions(:,ii);
            B = stim2_calcium_isa_regions(:,jj);
            stim2_calcium_isa_regions_pearsonCorr(ii,jj) = corr(A,B);
            C = stim2_calcium_isa_regions;
            C(:,[ii,jj]) = [];
            pinvC = pinv(C);
            betaA = pinvC*A;
            betaB = pinvC*B;
            regressedA = A-C*betaA;
            regressedB = B-C*betaB;
            stim2_calcium_isa_regions_partCorr(ii,jj) = corr(regressedA,regressedB);
        end
    end

    figure
    subplot(321)
    imagesc(stim1_calcium_isa_regions_pearsonCorr,[-1 1])
    axis image off
    colormap jet
    subplot(322)
    imagesc(stim1_calcium_isa_regions_partCorr,[-1 1])
    axis image off

    subplot(323)
    imagesc(stim2_calcium_isa_regions_pearsonCorr,[-1 1])
    axis image off
    subplot(324)
    imagesc(stim2_calcium_isa_regions_partCorr,[-1 1])
    axis image off

    subplot(325)
    imagesc(stim2_calcium_isa_regions_pearsonCorr-stim1_calcium_isa_regions_pearsonCorr,[-1 1])
    axis image off
    subplot(326)
    imagesc(stim2_calcium_isa_regions_partCorr-stim1_calcium_isa_regions_partCorr,[-1 1])
    axis image off

end

