excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitArea.mat',...
    'validLocation')
stdMap = nan(128,128,160);
for location = 1:160
    if ~isnan(validLocation(location))
        inhibtionMaps_mice = nan(128,128,10);
        mouseInd = 1;
        for excelRow = excelRows
            runsInfo = parseRuns_xw(excelFile,excelRow);
            runInfo = runsInfo(1);
            load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap')
            inhibtionMaps_mice(:,:,mouseInd) = inhibitionMap(:,:,location);
            mouseInd = mouseInd+1;
        end
        temp = nanstd(inhibtionMaps_mice,0,3);
        temp(logical(1-mask)) = nan;
        stdMap(:,:,location) = temp;
    end
end

save('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSTD.mat',...
    'stdMap')