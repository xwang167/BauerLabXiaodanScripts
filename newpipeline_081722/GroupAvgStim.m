%function GroupAvgStim(excelFile,excelRows,Group_directory)

excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=2:50;
Group_directory = 'X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\cat';
%getting excel/mouse info
runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});
excel_row=str2double(excel_row);
excelData = readtable(excelFile);
tableRows = excel_row - 1;
%Get Group labels and ignore, non-labled mice
%initialize
groupLabel=cell(numel(excel_row),1);
ct=1;
for row = tableRows

    groupLabel(ct) = excelData{row,'Group'};

    if isempty(groupLabel{ct})
        groupLabel(ct)={'unassigned'};
        warning(['row ' num2str(row) ' has no group assignment. It will not be included.'])
    elseif sum(~cellfun(@isempty,strfind(excelData.Properties.VariableNames,'Timepoint'))) > 0
        tp= excelData{row,'Timepoint'};
        groupLabel{ct}= [groupLabel{ct} '-' tp{:}];
    end
    ct=ct+1;
end
[group_names,~,group_id]=unique(groupLabel);

%Create group directory
if ~exist(Group_directory)
    mkdir(Group_directory)
end

%Group Averages: FOR EACH GROUP
for group_indx=1:numel(group_names) %this is the number of group labels
    %loading all mice
    if ~strcmp(group_names{group_indx},'unassigned') %only load mice with labels
        tmp=[find(group_id==group_indx)]; %find which mice have are in the current group
        xform_isbrain_intersect=ones(128,128); %get the intersection of all the isbrains
        xform_StimROIMask_intersect = ones(128,128);
        for mouse_ind= 1:numel(tmp) %Load all of these mice
            runInfo=runsInfo( first_ind_mouse(tmp(mouse_ind)) );
            load(runInfo.saveMaskFile) %load xform_isbrain
            xform_isbrain_intersect=xform_isbrain_intersect.*xform_isbrain;
            xform_StimROIMask_intersect = xform_StimROIMask_intersect.*xform_StimROIMask;
            load_name=strcat(runInfo.saveFolder ,'\', runInfo.recDate, '-' ,runInfo.mouseName, '-',runInfo.session,'-AvgStimResults.mat');
            load(load_name, ...
                'data_full_gsr_BaselineShift_mouse_avg','data_full_BaselineShift_mouse_avg')
            data_full_gsr_BaselineShift_group_avg(:,:,:,:,mouse_ind)=data_full_gsr_BaselineShift_mouse_avg;
            clear data_full_gsr_BaselineShift_mouse_avg 
            data_full_BaselineShift_group_avg(:,:,:,:,mouse_ind)=data_full_BaselineShift_mouse_avg; %xw 220720 add non gsr data
            clear data_full_BaselineShift_mouse_avg
            disp(['Loaded ', runInfo.mouseName, ', group:' group_names{group_indx}])

        end
        

        %AVERAGING
        data_full_gsr_BaselineShift_group_avg=squeeze(mean(data_full_gsr_BaselineShift_group_avg,5,'omitnan')); %saverage across mice
        data_full_BaselineShift_group_avg=squeeze(mean(data_full_BaselineShift_group_avg,5,'omitnan'));
        %PREPERATION
        runInfo.samplingRate=10; %%correct for downsample seen in wrapper
        peakTimeRange(1:numel(runInfo.Contrasts))={runInfo.stimStartTime:runInfo.stimEndTime};
        %PLOTTING
        [fh,peakMaps] = generateBlockMap_Dynamics_avg(data_full_BaselineShift_group_avg,data_full_gsr_BaselineShift_group_avg,...
            runInfo,peakTimeRange,xform_isbrain_intersect,xform_StimROIMask_intersect);%xw 220720 add time trace
        sgtitle([group_names{group_indx} ])

        %save
        saveFigName=strcat(Group_directory,'\', group_names{group_indx},'_GSR_BlockPeak');
        saveas(gcf,strcat(saveFigName,'.fig'))
        saveas(gcf,strcat(saveFigName,'.png'))
        close all

        %save_name= strcat(Group_directory,'\',group_names{group_indx}, '-AvgStimResults');
        %save(save_name,'data_full_gsr_BaselineShift_group_avg','data_full_BaselineShift_group_avg','-v7.3');
    end

    clearvars -except paramPath seedsData seedNames seedNum excel_row first_ind_mouse mouse_ids range_name runsInfo fStr group_names group_id Group_directory xform_isbrain_intersect_group

end

