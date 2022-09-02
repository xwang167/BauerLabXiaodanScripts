%% Get Run and System Info

%Some user input!
excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=[37];


fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!



%% Process Data
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
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    
    %do these exist?
    stimExist=[runInfo.saveFilePrefix ,'-StimResults','.mat'];
    stimExist2=[strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics.fig')];
    fcExist=[runInfo.saveFilePrefix '-seedFC-' num2str(fRange_ISA(1)) '-' num2str(fRange_ISA(2)) ];
    fcExist(strfind(fcExist,'.')) = 'p';
    fcExist=[fcExist '.mat'];
    %If is this already processed
    load(runInfo.saveHbFile,'xform_datahb')
    
    if ~isempty(runInfo.fluorChInd)
        load(runInfo.saveFluorFile,'xform_datafluorCorr')
    end
    
    if ~isempty(runInfo.FADChInd)
        load(runInfo.saveFADFile,'xform_dataFADCorr')
    end
    
    if ~isempty(runInfo.laserChInd)    %xw 220603 add for laser channel
        load(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'),'xform_datalaser')
    end
    
    
    load(runInfo.saveMaskFile,'xform_isbrain')
    mask=find(xform_isbrain);
    %Building Data Full
    if ~isempty(runInfo.fluorChInd)
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
    elseif ~isempty(runInfo.FADChInd)
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),5);
    else
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
    end
    %Shape Data
    data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:))*10^6;
    data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:))*10^6;
    data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))*10^6+squeeze(xform_datahb(:,:,2,:))*10^6;
    if ~isempty(runInfo.fluorChInd)
        data_full(:,:,:,4) = xform_datafluorCorr*100;
    end
    if ~isempty(runInfo.FADChInd)
        data_full(:,:,:,5) = xform_dataFADCorr*100;
    end
    if strcmp(runInfo.system,'EastOIS2+laser')%xw 220717 add laser channel
        data_full(:,:,:,5) = xform_datalaser;
    end
    clear xform_datafluorCorr xform_dataFADCorr xform_datahb
        %Time Ranges: This is for anesthetized
    %do we need this...? Cant we just call runsInfo? -- JPC
    peakTimeRange(1:size(data_full,4))={runInfo.stimStartTime:runInfo.stimEndTime};
    %Setting up stim
    stimBlockSize=round(runInfo.blockLen*runInfo.samplingRate); %stim length in frames
    %why is this here?
    R=mod(size(data_full,3),stimBlockSize); %are there dropped frames?
    %if there is dropped frames
    if R~=0
        pad=stimBlockSize-R;
        disp(['** Non integer number of blocks presented. Padded with ' , num2str(pad), ' zeros **'])
        data_full(:,:,end:end+pad,:)=0;
        runInfo.appendedZeros=pad;
    end
    numBlocks = round(size(data_full,3)/(runInfo.blockLen*runInfo.samplingRate));%what if not integer
    
    % GSR, Filter, Downsample
    data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],length(runInfo.Contrasts));
%     for ii = 1:length(runInfo.Contrasts)
%         data_full(:,:,:,ii) =  filterData(squeeze(data_full(:,:,:,ii)),0.01,5,runInfo.samplingRate); %xw 220716 remove extra squeeze
%     end
    data_full_BaselineShift= resample(data_full,(2*fRange_delta(2)*1.25),runInfo.samplingRate,'Dimension',3 ); %resample to 10 Hz
    data_full_gsr_BaselineShift=nan(size(data_full_BaselineShift));
    for ii = 1:length(runInfo.Contrasts)
        data_full_gsr_BaselineShift(:,:,:,ii) = gsr(squeeze(data_full_BaselineShift(:,:,:,ii)),xform_isbrain);
    end
    
    runInfo.samplingRate=(2*fRange_delta(2)*1.25); %change the sampling rate to fit the resample frequency
    clear data_full_gsr data_full
    
    %Reshape into blocks
    data_full_gsr_BaselineShift = reshape(data_full_gsr_BaselineShift,size(data_full_gsr_BaselineShift,1),size(data_full_gsr_BaselineShift,2),[],numBlocks,size(data_full_gsr_BaselineShift,4)); %reshape to pixel-pixel-blockSize-numblock-species
    data_full_BaselineShift = reshape(data_full_BaselineShift,size(data_full_BaselineShift,1),size(data_full_BaselineShift,2),[],numBlocks,size(data_full_BaselineShift,4)); %reshape to pixel-pixel-blockSize-numblock-species
    
    %Mean subtraction
    meanFrame = squeeze(mean(data_full_BaselineShift(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,:,:),3));
    data_full_BaselineShift = xform_isbrain.*(data_full_BaselineShift - permute(repmat(meanFrame,1,1,1,1, size(data_full_BaselineShift,3)), [1,2,5,3,4]  ));
    
    meanFrame = squeeze(mean(data_full_gsr_BaselineShift(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,:,:),3));
    data_full_gsr_BaselineShift = xform_isbrain.*(data_full_gsr_BaselineShift - permute(repmat(meanFrame,1,1,1,1, size(data_full_gsr_BaselineShift,3)), [1,2,5,3,4]  ));
    clear  meanFrame
    
    %Create Peak maps
    load(runInfo.saveMaskFile,'xform_StimROIMask');
    
    [fh,peakMaps]= generateBlockMap_Dynamics(data_full_BaselineShift,data_full_gsr_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain,xform_StimROIMask);
    %save
    sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run),'-GSR-NoFilter'])
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics_nofiter');
    saveas(gcf,strcat(saveName,'.fig'))
    export_fig(strcat(saveName,'.png'), '-transparent')
    close all
    save([runInfo.saveFilePrefix '-StimResults-nofilter'],'data_full_gsr_BaselineShift','data_full_BaselineShift','-v7.3');
    disp(['Done Processing ', runInfo.saveHbFile ' on ', runInfo.system])
end

calcium_nofilter = data_full_BaselineShift(:,:,:,:,4);
HbO_nofilter = data_full_BaselineShift(:,:,:,:,1);
HbR_nofilter = data_full_BaselineShift(:,:,:,:,2);
calcium_nofilter = reshape(calcium_nofilter,128*128,300*10);
calcium_nofilter_timetrace = mean(calcium_nofilter(logical(xform_StimROIMask),:));


HbO_nofilter = reshape(HbO_nofilter,128*128,300*10);
HbO_nofilter_timetrace = mean(HbO_nofilter(logical(xform_StimROIMask),:));


HbR_nofilter = reshape(HbR_nofilter,128*128,300*10);
HbR_nofilter_timetrace = mean(HbR_nofilter(logical(xform_StimROIMask),:));

load('220704-N24M778-WhiskerOnly-stim1-StimResults.mat', 'data_full_BaselineShift')
calcium_filter = data_full_BaselineShift(:,:,:,:,4);
HbO_filter = data_full_BaselineShift(:,:,:,:,1);
HbR_filter = data_full_BaselineShift(:,:,:,:,2);
calcium_filter = reshape(calcium_filter,128*128,300*10);
calcium_filter_timetrace = mean(calcium_filter(logical(xform_StimROIMask),:));

HbO_filter = reshape(HbO_filter,128*128,300*10);
HbO_filter_timetrace = mean(HbO_filter(logical(xform_StimROIMask),:));

HbR_filter = reshape(HbR_filter,128*128,300*10);
HbR_filter_timetrace = mean(HbR_filter(logical(xform_StimROIMask),:));

figure
plot((1:300)/10,calcium_filter_timetrace(601:900),'r-')
hold on
plot((1:300)/10,calcium_nofilter_timetrace(601:900),'k--')
legend('With Filter','Without Filter')
title('jRGECO1a','color','m')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
figure
plot((1:300)/10,HbO_filter_timetrace(601:900),'r-')
hold on
plot((1:300)/10,HbO_nofilter_timetrace(601:900),'k--')
legend('With Filter','Without Filter')
title('HbO','color','r')
xlabel('Time(s)')
ylabel('\Delta\muM')

figure
plot((1:300)/10,HbR_filter_timetrace(601:900),'r-')
hold on
plot((1:300)/10,HbR_nofilter_timetrace(601:900),'k--')
legend('With Filter','Without Filter','location','southeast')
title('HbR','color','b')
xlabel('Time(s)')
ylabel('\Delta\muM')

figure
plot((1:300)/10,calcium_filter_timetrace(601:900)-calcium_nofilter_timetrace(601:900),'m-')
hold on
plot((1:300)/10,HbO_filter_timetrace(601:900)-HbO_nofilter_timetrace(601:900),'r-')
hold on
plot((1:300)/10,HbR_filter_timetrace(601:900)-HbR_nofilter_timetrace(601:900),'b-')
legend('jRGECO1a','HbO','HbR','location','northwest')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \Delta\muM')
titile('Difference b/w filter and no filter')