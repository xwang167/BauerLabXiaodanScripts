load('D:\OIS_Process\noVasculatureMask.mat')
saveDir_cat = 'K:\Glucose\cat';
bilateralFCMap_ISA_leftHem = zeros(3,9);
bilateralFCMap_Delta_leftHem = zeros(3,9);
for run = 1:9
    
    processedName_mice = strcat('200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(run),'.mat');
    load(fullfile(saveDir_cat,processedName_mice),'contrastName','bilateralFCMap_Delta_mice','bilateralFCMap_ISA_mice')
     for contrast = 1:3
         bilateralFCMap_ISA_leftHem(contrast,run) = mean(bilateralFCMap_ISA_mice{contrast}(leftMask ==1),'all');
         bilateralFCMap_Delta_leftHem(contrast,run) = mean(bilateralFCMap_Delta_mice{contrast}(leftMask ==1),'all');        
     end
    
    
end

figure
colors = {'k','g','m'};
time = 1:9;
for contrast = 1:3
    plot(time,bilateralFCMap_ISA_leftHem(contrast,:),colors{contrast},'LineStyle',':','LineWidth',3)
    hold on
    h(contrast) = plot(time,bilateralFCMap_Delta_leftHem(contrast,:),colors{contrast},'LineWidth',3);
    hold on
end

lgd = legend(h,{'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','southeast');
title(lgd,'... ISA; - Delta')
names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
set(gca, 'XTick', 1:9, 'XTickLabel', names)

load('D:\OIS_Process\atlas.mat')
AtlasSeeds_Big = AtlasSeeds_Big.*double(leftMask);
bilateralFCMap_ISA_Regions = zeros(5,9);
bilateralFCMap_Delta_Regions = zeros(5,9);
for ii =1:5;
    regInd = ii+3;
    for run = 1:9
        
        processedName_mice = strcat('200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(run),'.mat');
        load(fullfile(saveDir_cat,processedName_mice),'contrastName','bilateralFCMap_Delta_mice','bilateralFCMap_ISA_mice')
        for contrast = 1:3
            bilateralFCMap_ISA_Regions(contrast,run) = mean(bilateralFCMap_ISA_mice{contrast}(AtlasSeeds_Big==regInd),'all');
            bilateralFCMap_Delta_Regions(contrast,run) = mean(bilateralFCMap_Delta_mice{contrast}(AtlasSeeds_Big==regInd),'all');
        end
        
        
    end
    
    figure
    colors = {'k','g','m'};
    time = 1:9;
    for contrast = 1:3
        plot(time,bilateralFCMap_ISA_Regions(contrast,:),colors{contrast},'LineStyle',':','LineWidth',3)
        hold on
        h(contrast) = plot(time,bilateralFCMap_Delta_Regions(contrast,:),colors{contrast},'LineWidth',3);
        hold on
    end
    
    lgd = legend(h,{'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','southeast');
    title(lgd,'... ISA; - Delta')
    names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
    set(gca, 'XTick', 1:9, 'XTickLabel', names)
    
    switch regInd
        
        case 4
            regName = 'ML';
        case 5
            regName = 'SSL';
            
        case 6
            regName = 'RSL';
        case 7
            regName = 'PL';
        case 8
            regName = 'VL';
    end
    title(strcat('Average bilateral FC across'," ", regName))
end
