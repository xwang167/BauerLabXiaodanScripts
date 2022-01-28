runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,~]=unique({runsInfo.excelRow_char});
excel_row=str2double(excel_row);
excelData = readtable(excelFile);
tableRows = excel_row - 1;

%no vasc mask
noVascMask=ones(128,128);
noVascMask(:,61:67)=0;

%Get Group labels and ignore, non-labled mice
groupLabel=cell(numel(excel_row),1);
ct=1; 
for row = tableRows
    groupLabel(ct) = excelData{row,'Genotype'};
    if isempty(groupLabel{ct})
        groupLabel(ct)={'unassigned'};
        warning(['row ' num2str(row) ' has no group assignment. It will not be included.'])
    end
    ct=ct+1; 
end

[group_names,~,group_id]=unique(groupLabel);

if ~exist(Group_directory)
   mkdir(Group_directory)
end

for group_indx=1:numel(group_names) %this is the number of group labels
    %loading all mice
    if ~contains(group_names{group_indx},'unassigned')
        xform_isbrain_intersect=ones(128,128); 
        tmp=[find(group_id==group_indx)]; %mice in the group
        save_name=strcat(Group_directory,filesep,group_names{group_indx}, '-avgPower'); 

        if isfile(strcat(save_name,'.mat')) 
            disp(strcat(save_name,'.mat already exists, loading'));
            load(strcat(save_name,'.mat'));
            runInfo=runsInfo( first_ind_mouse(1));
        else
        
            for i= 1:numel(tmp)
                runInfo=runsInfo( first_ind_mouse(tmp(i)) );
                load(runInfo.saveMaskFile)
                xform_isbrain_intersect=xform_isbrain_intersect.*xform_isbrain;

                load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-avgPower'); 
                load(strcat(load_name,'.mat'), 'whole_spectra_map_mouse_avg' , 'power_map_mouse_avg', 'global_sig_for_mouse_avg',...
                    'glob_sig_power_mouse_avg','hz')
                tmp_whole_spectra_map(:,:,:,:,i)=whole_spectra_map_mouse_avg;%.*noVascMask;
                tmp_powerMap(:,:,:,:,i)=power_map_mouse_avg;%.*noVascMask;
                tmp_global_sig_for(:,:,i)=global_sig_for_mouse_avg;%anmol- deleted .*noVascMask;
                tmp_glob_sig_power(:,:,i)=glob_sig_power_mouse_avg;%
            end
            whole_spectra_map_group_avg=squeeze(mean(tmp_whole_spectra_map,5,'omitnan'));%this is now size, 128,128,hz,contrast
            power_map_group_avg=squeeze(mean(tmp_powerMap,5,'omitnan'));%this is now size, 128,128,f-band,contrast
            global_sig_for_group_avg=squeeze(mean(tmp_global_sig_for,3,'omitnan')); %this is now size hz, contrast
            glob_sig_power_group_avg=squeeze(mean(tmp_glob_sig_power,3,'omitnan')); %this is now size hz, contrast

            avg_power_across_cortex_group_avg=reshape(whole_spectra_map_group_avg,[128*128,numel(hz),numel(runInfo.Contrasts)]); 
            avg_power_across_cortex_group_avg=squeeze(mean(avg_power_across_cortex_group_avg,1,'omitnan')); 

            save(strcat(save_name,'.mat'), 'whole_spectra_map_group_avg' , 'power_map_group_avg', 'global_sig_for_group_avg',...
                'glob_sig_power_group_avg','hz','avg_power_across_cortex_group_avg','xform_isbrain_intersect','-v7.3')        
        end
%PLOTTING     
    %% Non-overlay contrast
        fbands={'Full','ISA','Delta'};
        lims={[-120 -105],[-120 -105],[-130 -120]; ...
              [-140 -100],[-140 -100],[-140 -110]; ...
              [-120 -110],[-130 -110],[-135 -120]; ...
              [-50 -35],  [-50 -35],  [-60 -50]}; %Manually determined ranges for contrast and band
        
         load('D:\OIS_Process\noVasculaturemask.mat')
         mask = logical(xform_isbrain_intersect.*(leftMask+rightMask));
         ii = 1;
         fh=figure;
        for i=1:numel(runInfo.Contrasts)
            for j=1:3 %through each freq band
                subplot(4,3,ii)
                imagesc(10*log10(power_map_group_avg(:,:,j,i)).*mask,'alphadata',mask)
                if i==1
                title(fbands{j},'Position',[62 5]) 
                end
                axis image 
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                colormap jet;
                cb=colorbar;
                caxis(lims{i,j});   
                ii = ii+1;
                if j ==1
                    ylabel(runInfo.Contrasts{i},'fontweight','bold')
                end
            end
            
            if i<=3 
                cb.Label.String='10*log_1_0(M^2)'; 
            else
                cb.Label.String='10*log_1_0(\DeltaF/F)^2';
            end         

        end
            suptitle([group_names{group_indx}, ' Average Power Map:'])
            savefig(fh,strcat(save_name,'-MAP-allcontrasts.fig'));
            saveas(fh,strcat(save_name,'-MAP-allcontrasts.png')); 
    end
end