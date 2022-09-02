excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=2:50;

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
%% Get Masks and WL
previousDate = []; %initialize the date
mouse_ind=start_ind_mouse';
peakTimeRange(1:5)={runInfo.stimStartTime:runInfo.stimEndTime};
numBlocks = 10;
%%
for runInd=mouse_ind %for each mouse
    
    runInfo=runsInfo(runInd);
    load([runInfo.saveFilePrefix '-StimResults'],'data_full_gsr_BaselineShift','data_full_BaselineShift');
    data_full_gsr_BaselineShift(:,:,:,:,5) = data_full_BaselineShift(:,:,:,:,5);
    save([runInfo.saveFilePrefix '-StimResults'],'data_full_gsr_BaselineShift','-append');
    runInfo.samplingRate=(2*fRange_delta(2)*1.25);
    
    load(runInfo.saveMaskFile,'xform_StimROIMask','xform_isbrain');
    [fh,peakMaps]= generateBlockMap_Dynamics(data_full_BaselineShift,data_full_gsr_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain,xform_StimROIMask);
    sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run),'-GSR'])
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics');
    saveas(gcf,strcat(saveName,'.fig'))
    export_fig(strcat(saveName,'.png'), '-transparent')
    close all
    
end
