function PowerAnalysis_Wrapper(excelFile,excelRows,varargin)

if numel(varargin) > 0
    fft_bool=varargin{1};%
else
    fft_bool=0; %don't use fft
end

runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!

runNum = numel(runsInfo);

for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    %     if isfile([runInfo.saveFilePrefix,'-Power.mat'])
    %         disp(strcat('Power Analysis for ',runInfo.mouseName,' run ' ,num2str(runInfo.run),' already exists!'))
    %         continue
    %     end
    disp(strcat('Running Power Analysis for ',runInfo.mouseName,' run ' ,num2str(runInfo.run))) %anmol- changed the order of display, so I wouldn't get redundant messages

    %Loading

    try
        load(runInfo.saveHbFile,'xform_datahb')
        load(runInfo.saveMaskFile,'xform_isbrain')
    catch
        warning(strcat(runInfo.mouseName, '-',runInfo.run, ' Not processed.'))
        continue
    end

    if ~isempty(runInfo.fluorChInd)
        load(runInfo.saveFluorFile,'xform_datafluorCorr');
    end
    if ~isempty(runInfo.FADChInd)
        load(runInfo.saveFADFile,'xform_dataFADCorr');
    end

    %Initializing
    data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),numel(runInfo.Contrasts));

    %Shape Data
    data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:));
    data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:));
    data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))+squeeze(xform_datahb(:,:,2,:));
    if ~isempty(runInfo.fluorChInd)
        data_full(:,:,:,4) = xform_datafluorCorr;
    end
    if ~isempty(runInfo.FADChInd)
        data_full(:,:,:,5) = xform_dataFADCorr;
    end
    %Power Break
    %initalize
    if fft_bool
        hz_size= numel(0:runInfo.samplingRate/size(data_full,3):runInfo.samplingRate/2);
    else
        hz_size= 2^floor(log2(size(data_full,3)))/4+1;
    end
    whole_spectra_map=nan(128,128,hz_size,numel(runInfo.Contrasts));
    avg_cort_spec=nan(hz_size,numel(runInfo.Contrasts));
    powerMap=nan(128,128,3,numel(runInfo.Contrasts));
    global_sig_for=nan(hz_size,numel(runInfo.Contrasts));
    glob_sig_power=nan(3,numel(runInfo.Contrasts));

    for contrast=1:numel(runInfo.Contrasts)
        [whole_spectra_map(:,:,:,contrast),avg_cort_spec(:,contrast),powerMap(:,:,:,contrast),hz, global_sig_for(:,contrast),glob_sig_power(:,contrast)]= PowerAnalysis(squeeze(data_full(:,:,:,contrast)),runInfo.samplingRate,xform_isbrain,fft_bool);
    end
    save(strcat(runInfo.saveFilePrefix,'-Power.mat'),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','-v7.3')


    %Plot
    fh=PowerAnalysisVisualize(hz,avg_cort_spec,powerMap, global_sig_for, runInfo);
    sgtitle([runInfo.recDate '-' runInfo.mouseName '-' runInfo.session '-' num2str(runInfo.run)])

    saveName = strcat(runInfo.saveFolder, filesep ,runInfo.recDate ,'-' ,runInfo.mouseName , '-',runInfo.session, '-', num2str(runInfo.run), '-powerAnalysis');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    close all



end

end