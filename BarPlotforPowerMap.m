% excelFile='Y:\CTREM\CTREM_new.xlsx';
% excelRows=[2:11,17:22,27:66];  % Rows from Excell Database???34,63
% Group_directory = 'Y:\CTREM\Group level averages';
% runsInfo = parseRuns(excelFile,excelRows);
% [excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});
% excel_row=str2double(excel_row);
% excelData = readtable(excelFile);
% tableRows = excel_row - 1;
% 
% %Get Group labels and ignore, non-labled mice
% groupLabel=cell(numel(excel_row),1);
% ct=1;
% for row = tableRows
%     groupLabel(ct) = excelData{row,'Genotype'};
%     if isempty(groupLabel{ct})
%         groupLabel(ct)={'unassigned'};
%         warning(['row ' num2str(row) ' has no group assignment. It will not be included.'])
%     end
%     ct=ct+1;
% end
% 
% [group_names,~,group_id]=unique(groupLabel);
% 
% if ~exist(Group_directory)
%     mkdir(Group_directory)
% end

% average = nan(3,4,numel(group_names));
% error = nan(3,4,numel(group_names));
% 
% for group_indx=1:numel(group_names) %this is the number of group labels
%     %loading all mice
%     if ~contains(group_names{group_indx},'unassigned')
%         xform_isbrain_intersect=ones(128,128);
%         tmp=[find(group_id==group_indx)]; %mice in the group
%         save_name=strcat(Group_directory,filesep,group_names{group_indx}, '-avgPower');
%         %
%         load(strcat(save_name,'.mat'),'tmp_powerMap')
%         load('D:\OIS_Process\noVasculaturemask.mat')
%         mask = logical(xform_isbrain_intersect.*(leftMask+rightMask));
%         for i= 1:numel(tmp)
%             runInfo=runsInfo( first_ind_mouse(tmp(i)) );
%             load(runInfo.saveMaskFile)
%             xform_isbrain_intersect=xform_isbrain_intersect.*xform_isbrain;
%         end
% 
%         for ii = 1:3
%             for jj = 1:4              
%                 temp = squeeze(tmp_powerMap(:,:,ii,jj,:));
%                 temp = reshape(temp,128*128,[]);
%                 imask = reshape(mask,128*128,1);
%                 
%                 average(ii,jj,group_indx) = mean(mean(temp(imask,:),1));
%                 error(ii,jj,group_indx) = std(mean(temp(imask,:),1));
%             end
%         end
%         
%     end
% end



% X= 1:4;% 
% 
% 
% figure
% bar(X,squeeze(average(1,3,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(1,3,[5,6,3,4])),zeros(1,4),squeeze(error(1,3,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for HbT at Full band')
% set(gca,'fontweight','bold')
% 
% 
% 
% figure
% bar(X,squeeze(average(2,3,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(2,3,[5,6,3,4])),zeros(1,4),squeeze(error(2,3,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for HbT at ISA band')
% set(gca,'fontweight','bold')
% 
% figure
% bar(X,squeeze(average(3,3,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(3,3,[5,6,3,4])),zeros(1,4),squeeze(error(3,3,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for HbT at Delta band')
% set(gca,'fontweight','bold')
% 
% 
% figure
% bar(X,squeeze(average(1,4,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(1,4,[5,6,3,4])),zeros(1,4),squeeze(error(1,4,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for Calcium at Full band')
% set(gca,'fontweight','bold')
% 
% 
% 
% figure
% bar(X,squeeze(average(2,4,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(2,4,[5,6,3,4])),zeros(1,4),squeeze(error(2,4,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for Calcium at ISA band')
% set(gca,'fontweight','bold')
% 
% figure
% bar(X,squeeze(average(3,4,[5,6,3,4])),0.5);
% hold on
% er = errorbar(X,squeeze(average(3,4,[5,6,3,4])),zeros(1,4),squeeze(error(3,4,[5,6,3,4])));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
% xticklabels({'WT','WT5XFAD','KO','KO5XFAD'})
% ylabel('Power(\DeltaM)^2')
% title('Power Map for Calcium at Delta band')
% set(gca,'fontweight','bold')


powerMap_groups = cell(3,4,6);
for group_indx=1:numel(group_names) %this is the number of group labels
    %loading all mice
    if ~contains(group_names{group_indx},'unassigned')
        xform_isbrain_intersect=ones(128,128);
        tmp=[find(group_id==group_indx)]; %mice in the group
        save_name=strcat(Group_directory,filesep,group_names{group_indx}, '-avgPower');
        %
        load(strcat(save_name,'.mat'),'tmp_powerMap')
        tmp_powerMap = reshape(tmp_powerMap,128*128,3,4,[]);
        imask = reshape(mask,128*128,[]);
        tmp_value = squeeze(mean(tmp_powerMap(imask,:,:,:),1));
        for ii = 1:3
            for jj = 1:4
                powerMap_groups{ii,jj,group_indx} = squeeze(tmp_value(ii,jj,:));
            end
        end
        

    end
end

%HbT full
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{1,3,5},powerMap_groups{1,3,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{1,3,5},powerMap_groups{1,3,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{1,3,5},powerMap_groups{1,3,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{1,3,3},powerMap_groups{1,3,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{1,3,3},powerMap_groups{1,3,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{1,3,6},powerMap_groups{1,3,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD

%HbT ISA
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{2,3,5},powerMap_groups{2,3,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{2,3,5},powerMap_groups{2,3,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{2,3,5},powerMap_groups{2,3,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{2,3,3},powerMap_groups{2,3,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{2,3,3},powerMap_groups{2,3,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{2,3,6},powerMap_groups{2,3,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD

%HbT Delta
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{3,3,5},powerMap_groups{3,3,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{3,3,5},powerMap_groups{3,3,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{3,3,5},powerMap_groups{3,3,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{3,3,3},powerMap_groups{3,3,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{3,3,3},powerMap_groups{3,3,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{3,3,6},powerMap_groups{3,3,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD




%Calcium full
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{1,4,5},powerMap_groups{1,4,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{1,4,5},powerMap_groups{1,4,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{1,4,5},powerMap_groups{1,4,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{1,4,3},powerMap_groups{1,4,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{1,4,3},powerMap_groups{1,4,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{1,4,6},powerMap_groups{1,4,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD

%Calcium ISA
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{2,4,5},powerMap_groups{2,4,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{2,4,5},powerMap_groups{2,4,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{2,4,5},powerMap_groups{2,4,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{2,4,3},powerMap_groups{2,4,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{2,4,3},powerMap_groups{2,4,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{2,4,6},powerMap_groups{2,4,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD

%Calcium Delta
[h_WT_KO,p_WT_KO] = ttest2(powerMap_groups{3,4,5},powerMap_groups{3,4,3},0.05, 'both', 'unequal');
[h_WT_WTFAD,p_WT_WTFAD] = ttest2(powerMap_groups{3,4,5},powerMap_groups{3,4,6},0.05, 'both', 'unequal');
[h_WT_KOFAD,p_WT_KOFAD] = ttest2(powerMap_groups{3,4,5},powerMap_groups{3,4,4},0.05, 'both', 'unequal');
[h_KO_WTFAD,p_KO_WTFAD] = ttest2(powerMap_groups{3,4,3},powerMap_groups{3,4,6},0.05, 'both', 'unequal');
[h_KO_KOFAD,p_KO_KOFAD] = ttest2(powerMap_groups{3,4,3},powerMap_groups{3,4,4},0.05, 'both', 'unequal');
[h_WTFAD_KOFAD,p_WTFAD_KOFAD] = ttest2(powerMap_groups{3,4,6},powerMap_groups{3,4,4},0.05, 'both', 'unequal');

clear h_WT_KO p_WT_KO h_WT_WTFAD p_WT_WTFAD h_WT_KOFAD p_WT_KOFAD h_KO_WTFAD p_KO_WTFAD h_KO_KOFAD p_KO_KOFAD h_WTFAD_KOFAD p_WTFAD_KOFAD