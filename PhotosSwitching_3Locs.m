excelFile="X:\Paper2\Hemi_Thy1_jRGECO1a_3Locs\Hemi_Thy1_jRGECO1a_3Locs - Copy.xlsx";
excelRows=20:22;

runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';

for runInd=runNum %for each mouse
    runInfo=runsInfo(runInd);
    ind_slash = strfind(runInfo.rawFile{1},'\');
    rawDir = runInfo.rawFile{1}(1:ind_slash(end));
    oriFile = fullfile(rawDir, strcat(runInfo.recDate,'-tform.mat'));
    finalFile = fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat'));
    load(oriFile)
    save(finalFile,'mytform')
end

%% Get Masks and WL
for runInd=runNum %for each mouse
    runInfo=runsInfo(runInd);
    ind_hyphen = strfind(runInfo.mouseName,'-');
    mouseName = runInfo.mouseName(1:ind_hyphen-1);
    ind_slash = strfind(runInfo.rawFile{1},'\');
    rawDir = runInfo.rawFile{1}(1:ind_slash(end));
    rawMaskFile = fullfile(rawDir,strcat(runInfo.recDate,'-',mouseName,'-LandmarksandMask.mat'));
    load(rawMaskFile)
    I.bregma = I.bregma([2,1]);
    I.tent = I.tent([2,1]);
    I.OF= I.OF([2,1]);
    [xform_isbrain]=affineTransform(isbrain,I);
    if ~exist(runInfo.saveFolder,'dir')
        mkdir(runInfo.saveFolder)
    end
    save(runInfo.saveMaskFile,'I','xform_isbrain','GalvoSeedCenter','GalvoSeedCenterCCDSpace','GoodSeedsidx','WL','isbrain','mytform');
    close all
end
