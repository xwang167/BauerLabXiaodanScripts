%function MouseAvgStim(excelFile,excelRows)
excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=2:50;

runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char});


%Mouse Averages: FOR EACH MOUSE
for mouse_indx=45:length(first_ind_mouse) %this is the number of mice
    inds=find(numruns_per_mouse==mouse_indx);  %how many runs -- and which ones -- for each mice and which one is the associated runsInfo?
    runInfo=runsInfo(first_ind_mouse(mouse_indx));
    if contains(runInfo.mouseName,'Whisker') %% need to delete
        load(runInfo.saveMaskFile,'xform_isbrain','xform_StimROIMask');
        
        save_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-AvgStimResults');
        if isfile(strcat(save_name,'.mat'))
            disp([strcat(save_name,'.mat') ' already exists'])
            continue
        end
        load(strcat(runInfo.saveFilePrefix,'-StimResults.mat'),'data_full_gsr_BaselineShift');
        data_full_gsr_BaselineShift_mouse_avg = nan(size(data_full_gsr_BaselineShift,1),size(data_full_gsr_BaselineShift,2),...
            size(data_full_gsr_BaselineShift,3),size(data_full_gsr_BaselineShift,4),size(data_full_gsr_BaselineShift,5),length(inds));
        data_full_BaselineShift_mouse_avg = data_full_gsr_BaselineShift_mouse_avg;
        for mouse_run=1:length(inds) %load for each run
            ind=inds(mouse_run);   %associated index in runsInfo
            %LOADING
            if exist([ runsInfo(ind).saveFilePrefix, '-StimResults.mat' ],'file')
                disp([runsInfo(ind).mouseName,num2str(runsInfo(ind).run)])%xw 220720 delete xform_isbrain_intersect because xform_isbrain is mouse level.
                load(strcat(runsInfo(ind).saveFilePrefix,'-StimResults.mat'),'data_full_gsr_BaselineShift','data_full_BaselineShift'); %xw 220718 convert runInfo to runsInfo(ind)
                data_full_gsr_BaselineShift(:,:,:,runsInfo(ind).BadPres,:) =[];
                data_full_BaselineShift(:,:,:,runsInfo(ind).BadPres,:) = []; % xw 220720 make Remove bad pres instead of make them nan
                data_full_gsr_BaselineShift_mouse_avg(:,:,:,:,:,mouse_run)=data_full_gsr_BaselineShift;
                clear data_full_gsr_BaselineShift
                data_full_BaselineShift_mouse_avg(:,:,:,:,:,mouse_run)=data_full_BaselineShift;
                clear data_full_BaselineShift
                
                %get rid of bad presentations
            else
                disp([runsInfo(ind).saveHbFile,' needs to processed'])
            end
        end
        %AVERAGINE
        data_full_gsr_BaselineShift_mouse_avg=squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,6,'omitnan'));
        data_full_gsr_BaselineShift_mouse_avg=squeeze(mean(data_full_gsr_BaselineShift_mouse_avg,4,'omitnan'));% xw 220720 add average blocks
        data_full_BaselineShift_mouse_avg=squeeze(mean(data_full_BaselineShift_mouse_avg,6,'omitnan')); %xw 220720 add non gsr data 
        data_full_BaselineShift_mouse_avg=squeeze(mean(data_full_BaselineShift_mouse_avg,4,'omitnan'));% xw 220720 add average blocks
        %PREPERATION
        runInfo.samplingRate=10; %%correct for downsample seen in wrapper %xw20720 delete numBlocks, not used in later functions
        peakTimeRange(1:numel(runInfo.Contrasts))={runInfo.stimStartTime:runInfo.stimEndTime};
        %reshape to be compatible with generateBlockMap_Dynamics
        data_full_BaselineShift_mouse_avg = reshape(data_full_BaselineShift_mouse_avg,size(data_full_BaselineShift_mouse_avg,1),size(data_full_BaselineShift_mouse_avg,2),...
            size(data_full_BaselineShift_mouse_avg,3),size(data_full_BaselineShift_mouse_avg,4),1);%xw 220720 add time trace
        %Plotting   %Create Peak maps
        [fh,peakMaps]= generateBlockMap_Dynamics_avg(data_full_BaselineShift_mouse_avg,data_full_gsr_BaselineShift_mouse_avg,runInfo,peakTimeRange,xform_isbrain,xform_StimROIMask);%xw 220720 add time trace
        %save
        sgtitle([runInfo.recDate '-' runInfo.mouseName '-GSR'])
        saveName = strcat(runInfo.saveFilePrefix(1:end-1),'_GSR_BlockPeak_Dynamics');
        saveas(gcf,strcat(saveName,'.fig'))
        export_fig(strcat(saveName,'.png'), '-transparent')
        close all
        save([runInfo.saveFilePrefix(1:end-1), '-AvgStimResults'],'data_full_gsr_BaselineShift_mouse_avg','data_full_BaselineShift_mouse_avg','-v7.3');
    end
end


