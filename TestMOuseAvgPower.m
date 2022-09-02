noVascMask=ones(128,128);
noVascMask(:,61:67)=0;

runsInfo = parseRuns('X:\CodeModification\CodeMeeting.xlsx',6);
[excel_row,first_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char});

%Mouse Averages
for mouse_indx=1:length(first_ind_mouse) %this is the number of mice
    inds=find(numruns_per_mouse==mouse_indx);  %how many runs for each mice and which one is the associated runsInfo?  
    runInfo=runsInfo(first_ind_mouse(mouse_indx));      
    save_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-avgPower'); 
%     if isfile(strcat(save_name,'.mat')) 
%         disp([strcat(save_name,'.mat') ' already exists'])
%         continue 
%     end
    load(runInfo.saveMaskFile,'xform_isbrain'); 

    for mouse_run=1:length(inds) %load for each run
            ind=inds(mouse_run);   %associated index in runsInfo
            load([runsInfo(ind).saveFilePrefix,'-Power','.mat']); %load

            tmp_whole_spectra_map(:,:,:,:,mouse_run)=whole_spectra_map.*noVascMask;
            tmp_powerMap(:,:,:,:,mouse_run)=powerMap.*noVascMask;
            tmp_global_sig_for(:,:,mouse_run)=global_sig_for;
            tmp_glob_sig_power(:,:,mouse_run)=glob_sig_power;
            
    end 

    disp(['Loaded ', runInfo.mouseName, ' runs: ' num2str(ind)])

    whole_spectra_map_mouse_avg=squeeze(mean(tmp_whole_spectra_map,5,'omitnan'));%this is now size, 128,128,hz,contrast
    powerMap_mouse_avg=squeeze(mean(tmp_powerMap,5,'omitnan'));%this is now size, 128,128,f-band,contrast
    global_sig_for_mouse_avg=squeeze(mean(tmp_global_sig_for,3,'omitnan')); %this is now size hz, contrast
    glob_sig_power_mouse_avg=squeeze(mean(tmp_glob_sig_power,3,'omitnan')); %this is now size hz, contrast
        
    avg_cort_spec_mouse_avg=reshape(whole_spectra_map_mouse_avg,[128*128,numel(hz),numel(runInfo.Contrasts)]);
    avg_cort_spec_mouse_avg=squeeze(mean(avg_cort_spec_mouse_avg,1,'omitnan')); %this is now size hz, contrast %removed a parenthesis
%Saving    
    save(strcat(save_name,'.mat'), 'whole_spectra_map_mouse_avg' , 'powerMap_mouse_avg', 'global_sig_for_mouse_avg',...
    'glob_sig_power_mouse_avg','hz','avg_cort_spec_mouse_avg','-v7.3'); 

%Plotting
 %Plot
    fh=PowerAnalysisVisualize(hz,avg_cort_spec_mouse_avg,powerMap_mouse_avg, global_sig_for_mouse_avg, runInfo)
    saveName = strcat(runInfo.saveFolder, filesep ,runInfo.recDate ,'-' ,runInfo.mouseName ,'-AvgPowerAnalysis');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    close all 

    
end