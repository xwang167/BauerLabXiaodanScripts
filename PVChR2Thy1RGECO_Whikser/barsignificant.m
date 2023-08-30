%function GroupAvgStim(excelFile,excelRows,Group_directory)
clear;close all;clc;
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

%% Peak maps of each mouse for each group
for group_indx=1:numel(group_names) %this is the number of group labels
    %loading all mice
    if ~strcmp(group_names{group_indx},'unassigned') %only load mice with labels
        tmp=[find(group_id==group_indx)]; %find which mice have are in the current group
        xform_isbrain_intersect=ones(128,128); %get the intersection of all the isbrains
        xform_StimROIMask_intersect = ones(128,128);
        data_full_BaselineShift_mice = nan(128,128,300,5,7);
        for mouse_ind= 1:numel(tmp) %Load all of these mice
            runInfo=runsInfo( first_ind_mouse(tmp(mouse_ind)) );
            load(runInfo.saveMaskFile) %load xform_isbrain
            xform_isbrain_intersect=xform_isbrain_intersect.*xform_isbrain;
            xform_StimROIMask_intersect = xform_StimROIMask_intersect.*xform_StimROIMask;
            load_name=strcat(runInfo.saveFolder ,'\', runInfo.recDate, '-' ,runInfo.mouseName, '-',runInfo.session,'-AvgStimResults.mat');
            load(load_name, ...
                'data_full_BaselineShift_mouse_avg')
            data_full_BaselineShift_mice(:,:,:,:,mouse_ind)=data_full_BaselineShift_mouse_avg;
            clear data_full_BaselineShift_mouse_avg
            disp(['Loaded ', runInfo.mouseName, ', group:' group_names{group_indx}])

        end
        data_full_BaselineShift_mice = reshape(data_full_BaselineShift_mice,128*128,300,5,7);
        peakMaps_mice = squeeze(mean(data_full_BaselineShift_mice(:,51:100,:,:),2));
        clear data_full_BaselineShift_mice
        save_name= strcat(Group_directory,'\',group_names{group_indx}, '-AvgStimResults');
        if exist(save_name)
            save(save_name,'peakMaps_mice','-append');
        else
            save(save_name,'peakMaps_mice');
        end
    end
end

%% mean value inside of ROI for each mouse of each group
load("X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\cat\WhiskerOnly-AvgStimResults.mat")
peakMaps_mice= reshape(peakMaps_mice,128,128,5,7);
peakMap = nanmean(peakMaps_mice(:,:,4,:),4);
ROI = findStimROIMask_xw(peakMap,128,128); 
for group_indx=1:numel(group_names) %this is the number of group labels
    %loading all mice
    if ~strcmp(group_names{group_indx},'unassigned') %only load mice with labels
        save_name= strcat(Group_directory,'\',group_names{group_indx}, '-AvgStimResults');
        load(save_name)
        ROI_mice = squeeze(mean(peakMaps_mice(ROI(:),:,:),1));
        save(save_name,'ROI_mice','-append');
    end
end

%%
x = 1:16;
load('WhiskerOnly-AvgStimResults.mat', 'ROI_mice')
whiskerOnly = ROI_mice;
load('S1bLWhisker-AvgStimResults.mat', 'ROI_mice')
S1bLWhisker = ROI_mice;
load('S1bRWhisker-AvgStimResults.mat', 'ROI_mice')
S1bRWhisker = ROI_mice;
load('MbLWhisker-AvgStimResults.mat', 'ROI_mice')
MbLWhisker = ROI_mice;

S1bLWhisker_100 = S1bLWhisker./whiskerOnly*100;
S1bRWhisker_100 = S1bRWhisker./whiskerOnly*100;
MbLWhisker_100 = MbLWhisker./whiskerOnly*100;
whiskerOnly_100 = whiskerOnly./whiskerOnly*100;
S1bLWhisker_100(:,1) = nan;
S1bLWhisker_100(2,4) = nan;
S1bRWhisker_100(:,1) = nan;
MbLWhisker_100(:,1) = nan;
S1bLWhisker_mean = nanmean(S1bLWhisker_100,2);
S1bRWhisker_mean = nanmean(S1bRWhisker_100,2);
MbLWhisker_mean = nanmean(MbLWhisker_100,2);
whiskerOnly_mean = nanmean(whiskerOnly_100,2);
%%
data = [];
for ii = 1:4
    data = cat(1,data,whiskerOnly_mean(ii));
    data = cat(1,data,S1bLWhisker_mean(ii));
    data = cat(1,data,S1bRWhisker_mean(ii));
    data = cat(1,data,MbLWhisker_mean(ii));
end

%%
S1bLWhisker_std = nanstd(S1bLWhisker_100,0,2);
S1bRWhisker_std = nanstd(S1bRWhisker_100,0,2);
MbLWhisker_std = nanstd(MbLWhisker_100,0,2);
whiskerOnly_std = nanstd(whiskerOnly_100,0,2);
error = [];
for ii = 1:4
    error = cat(1,error,whiskerOnly_std(ii));
    error = cat(1,error,S1bLWhisker_std(ii));
    error = cat(1,error,S1bRWhisker_std(ii));
    error = cat(1,error,MbLWhisker_std(ii));
end

x =1:16;
errhigh = error;
errlow  = zeros(1,16);

figure
b=bar(x,data);

b.FaceColor = 'flat';
for ii = 1:4
    b.CData(ii,:) = [1 0 0];
end

for ii = 5:8
    b.CData(ii,:) = [0 0 1];
end

for ii = 9:12
    b.CData(ii,:) = [0 0 0];
end

for ii = 13:16
    b.CData(ii,:) = [1 0 1];
end


hold on

er = errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off


xticklabels({'WS','WS+PS_{S1bL}','WS+PS_{S1bR}','WS+PS_{MbL}','WS','WS+PS_{S1bL}',...
    'WS+PS_{S1bR}','WS+PS_{MbL}','WS','WS+PS_{S1bL}','WS+PS_{S1bR}','WS+PS_{MbL}','WS','WS+PS_{S1bL}','WS+PS_{S1bR}','WS+PS_{MbL}'})
ylabel('%')


% 0.05,0.01,0.001,0.0001
[h, p]=ttest2(whiskerOnly_100(4,:), S1bLWhisker_100(4,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(4,:), S1bRWhisker_100(4,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(4,:), MbLWhisker_100(4,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly_100(1,:), S1bLWhisker_100(1,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(1,:), S1bRWhisker_100(1,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(1,:), MbLWhisker_100(1,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly_100(2,:), S1bLWhisker_100(2,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(2,:), S1bRWhisker_100(2,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(2,:), MbLWhisker_100(2,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly_100(3,:), S1bLWhisker_100(3,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(3,:), S1bRWhisker_100(3,:), 0.05, 'both', 'unequal')
[h, p]=ttest2(whiskerOnly_100(3,:), MbLWhisker_100(3,:), 0.05, 'both', 'unequal')

