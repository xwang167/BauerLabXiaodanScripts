poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
%clear all;close all;

excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows=[2:4];
istransform = 1;

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';

% get xform_isbrain
for runInd=runNum %for each mouse
    
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'isbrain')
[xform_isbrain]=Affine(I, isbrain, 'New');
save(runInfo.saveMaskFile,'xform_isbrain','-append')
end

% get indx for laser frame
rightRectangle = mean(raw_unregistered(48:97,79:105,:),'all');
laser_indx = find(rightRectangle < 10000);
laserNum = sum(rightRectangle < 10000);

