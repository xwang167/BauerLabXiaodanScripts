load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
saveDir_cat = 'K:\Glucose\cat';
FADCorr_ISA_powerMap_leftHem = zeros(1,9);
FADCorr_Delta_powerMap_leftHem = zeros(1,9);
jrgeco1aCorr_ISA_powerMap_leftHem = zeros(1,9);
jrgeco1aCorr_Delta_powerMap_leftHem = zeros(1,9);
total_ISA_powerMap_leftHem = zeros(1,9);
total_Delta_powerMap_leftHem = zeros(1,9);
for run = 1:9
    
    processedName_mice = strcat('200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(run),'.mat');
    load(fullfile(saveDir_cat,processedName_mice),...
        'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice')
    
    FADCorr_ISA_powerMap_leftHem(run) = mean(FADCorr_ISA_powerMap_mice(mask ==1),'all');
    FADCorr_Delta_powerMap_leftHem(run) = mean(FADCorr_Delta_powerMap_mice(mask ==1),'all');
    
    jrgeco1aCorr_ISA_powerMap_leftHem(run) = mean(jrgeco1aCorr_ISA_powerMap_mice(mask ==1),'all');
    jrgeco1aCorr_Delta_powerMap_leftHem(run) = mean(jrgeco1aCorr_Delta_powerMap_mice(mask ==1),'all');
    
    total_ISA_powerMap_leftHem(run) = mean(total_ISA_powerMap_mice(mask ==1),'all');
    total_Delta_powerMap_leftHem(run) = mean(total_Delta_powerMap_mice(mask ==1),'all');
    
end

figure
colors = {'k','g','m'};
time = 1:9;


plot(time,total_ISA_powerMap_leftHem./total_ISA_powerMap_leftHem(1),colors{1},'LineStyle',':','LineWidth',3)
hold on
plot(time,FADCorr_ISA_powerMap_leftHem./FADCorr_ISA_powerMap_leftHem(1),colors{2},'LineStyle',':','LineWidth',3)
hold on
plot(time,jrgeco1aCorr_ISA_powerMap_leftHem./jrgeco1aCorr_ISA_powerMap_leftHem(1),colors{3},'LineStyle',':','LineWidth',3)

legend({'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','northeast');
names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
set(gca, 'XTick', 1:9, 'XTickLabel', names)
title('Average ISA power map across two hemispheres')

figure
 plot(time,total_Delta_powerMap_leftHem./total_Delta_powerMap_leftHem(1),colors{1},'LineWidth',3);
hold on
plot(time,FADCorr_Delta_powerMap_leftHem./FADCorr_Delta_powerMap_leftHem(1),colors{2},'LineWidth',3);
hold on
 plot(time,jrgeco1aCorr_Delta_powerMap_leftHem./jrgeco1aCorr_Delta_powerMap_leftHem(1),colors{3},'LineWidth',3);

legend({'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','northeast');
names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
set(gca, 'XTick', 1:9, 'XTickLabel', names)
title('Average Delta power map across two hemispheres')






load('D:\OIS_Process\atlas.mat')
AtlasSeeds_Big = AtlasSeeds_Big.*double(leftMask);

FADCorr_ISA_powerMap_Regions = zeros(1,9);
FADCorr_Delta_powerMap_Regions = zeros(1,9);
jrgeco1aCorr_ISA_powerMap_Regions = zeros(1,9);
jrgeco1aCorr_Delta_powerMap_Regions = zeros(1,9);
total_ISA_powerMap_Regions = zeros(1,9);
total_Delta_powerMap_Regions = zeros(1,9); 

for ii =1:5
    regInd = ii+3;
    for run = 1:9
        
        processedName_mice = strcat('200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(run),'.mat');
         load(fullfile(saveDir_cat,processedName_mice),...
        'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice')
                 
            
    FADCorr_ISA_powerMap_Regions(run) = mean(FADCorr_ISA_powerMap_mice(AtlasSeeds_Big==regInd),'all');
    FADCorr_Delta_powerMap_Regions(run) = mean(FADCorr_Delta_powerMap_mice(AtlasSeeds_Big==regInd),'all');
    
    jrgeco1aCorr_ISA_powerMap_Regions(run) = mean(jrgeco1aCorr_ISA_powerMap_mice(AtlasSeeds_Big==regInd),'all');
    jrgeco1aCorr_Delta_powerMap_Regions(run) = mean(jrgeco1aCorr_Delta_powerMap_mice(AtlasSeeds_Big==regInd),'all');
    
    total_ISA_powerMap_Regions(run) = mean(total_ISA_powerMap_mice(AtlasSeeds_Big==regInd),'all');
    total_Delta_powerMap_Regions(run) = mean(total_Delta_powerMap_mice(AtlasSeeds_Big==regInd),'all');
            
            
        
        
        
    end
    
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
    
    colors = {'k','g','m'};
    time = 1:9;
    figure
plot(time,total_ISA_powerMap_Regions./total_ISA_powerMap_Regions(1),colors{1},'LineStyle',':','LineWidth',3)
hold on
plot(time,FADCorr_ISA_powerMap_Regions./FADCorr_ISA_powerMap_Regions(1),colors{2},'LineStyle',':','LineWidth',3)
hold on
plot(time,jrgeco1aCorr_ISA_powerMap_Regions./jrgeco1aCorr_ISA_powerMap_Regions(1),colors{3},'LineStyle',':','LineWidth',3)
    lgd = legend({'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','northeast');
    names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
    set(gca, 'XTick', 1:9, 'XTickLabel', names)
    title(strcat('Average ISA power map across'," ", regName))

figure
plot(time,total_Delta_powerMap_Regions./total_Delta_powerMap_Regions(1),colors{1},'LineWidth',3);
hold on
plot(time,FADCorr_Delta_powerMap_Regions./FADCorr_Delta_powerMap_Regions(1),colors{2},'LineWidth',3);
hold on
plot(time,jrgeco1aCorr_Delta_powerMap_Regions./jrgeco1aCorr_Delta_powerMap_Regions(1),colors{3},'LineWidth',3);
    
    lgd = legend({'HbT','Corrected FAD','Corrected jRGECO1a'},'Location','northeast');
    names = {'fc1' 'fc2' 'fc3' 'fc4' 'fc5' 'fc6' 'fc7' 'fc8' 'fc9'};
    set(gca, 'XTick', 1:9, 'XTickLabel', names)
    title(strcat('Average Delta power map across'," ", regName))
end
