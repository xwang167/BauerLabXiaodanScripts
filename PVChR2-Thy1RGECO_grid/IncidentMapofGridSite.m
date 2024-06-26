load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
excelRows = 2:11;
GoodSeedsidx_mice = zeros(length(excelRows),160);
ii = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'GoodSeedsidx_NoLaserOutFOV')
    GoodSeedsidx_mice(ii,:) = GoodSeedsidx_NoLaserOutFOV;
    ii = 1+ii;
end
incidentVector = sum(GoodSeedsidx_mice,1);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_incident.mat'),'incidentVector')
figure
[refseeds, ~]=GetReferenceGridSeeds;
imagesc(xform_WL(:,1:64,:));
hold on
for jj = 1:160
    scatter(refseeds(m(jj),1),refseeds(m(jj),2),30,incidentVector(m(jj)),'filled')
    hold on
end
colormap jet
colorbar
axis image off
title('Incident Map of how many mice have same stimulation sites')