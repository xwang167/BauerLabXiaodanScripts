%% Get Run and System Info
clear
%Some user input!
% excelFile="A:\JPC\DOI_RGeco\DOI_Database.xlsx";
excelFile="X:\ToAllison\ToAllison.xlsx";
% excelRows=[11:60];
excelRows=[2:3];


%
% excelFile="A:\JPC\Cofluc\Cofluc_Database.xlsx";
% excelRows=[6:9];

fft_bool=0; %use Pwelch
fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!

% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:

runNum = numel(runsInfo);
for runInd = 1:runNum
    runInfo = runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')
    mask=find(xform_isbrain);
    load([runInfo.saveFilePrefix '-StimResults'],'data_full_BaselineShift');

    %             load(runInfo.saveMaskFile,'xform_StimROIMask');
    peakTimeRange(1:size(data_full_BaselineShift,5))={runInfo.stimStartTime:runInfo.stimEndTime};
    numBlocks = 10;
    [fh,peakMaps]= generateBlockMap(data_full_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain);
    %save
    sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run)])
    saveName = strcat(runInfo.saveFilePrefix,'_BlockPeak');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    %             export_fig(strcat(saveName,'.png'), '-transparent') %I dont
    %             have this funciton
    close all  

end




