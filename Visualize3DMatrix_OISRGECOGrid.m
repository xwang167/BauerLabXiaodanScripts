%Overlap brain maps over mice
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;

% Overlap brain regions across mice
xform_isbrain_mice = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(runInfo.saveMaskFile,'xform_isbrain')
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
end


% Exclude midline and sutures
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat');
mask = leftMask+rightMask;
mask = mask.*xform_isbrain_mice;

% mice name
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = strcat(miceName(2:end),'-',runInfo.mouseName);
end

% visualize 3D matrix
for ii = 112:160
    testImage = reshape(AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites(:,:,1,ii),1,[]);
    if sum(isnan(testImage))<128*128
    [Seed_names,ordered_indices,sort_ind,color_keeper] = ...
        Visualize3DMatrixLR(AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites(:,:,:,ii),mask,runInfo,[miceName,' location #', num2str(ii)],'\DeltaF/F');
    
    saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Movie_Location',num2str(ii),'.png'))
    saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Movie_Location',num2str(ii),'.fig'))
    close all
    end
    %Notes:
end

load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(which('AtlasandIsbrain.mat'),'AtlasSeeds')
figure
imagesc(AtlasSeeds)
axis image off
for ii = 1:160
    if ~isnan(seedLocation_mice(2,ii))
    text(seedLocation_mice(2,ii),seedLocation_mice(1,ii),num2str(ii),'FontSize',8,'FontWeight','bold')
    end
end