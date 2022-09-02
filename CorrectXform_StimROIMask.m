excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=2:50;

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
%% Get Masks and WL
previousDate = []; %initialize the date
mouse_ind=start_ind_mouse';
for runInd=mouse_ind %for each mouse
    
    runInfo=runsInfo(runInd);
    currentDate = runInfo.recDate;

    load(runInfo.saveMaskFile,'I','StimROIMask')
    xform_StimROIMask=affineTransform(StimROIMask,I);
    xform_StimROIMask=single(uint8(xform_StimROIMask));

    save(runInfo.saveMaskFile,'xform_StimROIMask','-append');
end