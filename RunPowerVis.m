%%Get list of mice and runs, and load into a cancat file
function MouseAvgPower(excelFile,excelRows)
%ALL of these should be ISA ( 0.1-0.4) and delta *(.5 to 4) because it
%uses JPC power_wrapper
noVascMask=ones(128,128);
noVascMask(:,61:67)=0;

runsInfo = parseRuns(excelFile,excelRows);
[excel_row,first_ind_mouse,mouse_ids]=unique({runsInfo.excelRow_char});

%Mouse Averages
for mouse_indx=1:length(first_ind_mouse) %this is the number of mice
    inds=find(mouse_ids==mouse_indx);  %how many runs for each mice and which one is the associated runsInfo?  
    runInfo=runsInfo(first_ind_mouse(mouse_indx));    

    
    save_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-avgPower'); %anmol- adjusted it so that savename is served above
    if isfile(strcat(save_name,'.mat')) 
        disp([strcat(save_name,'.mat') ' already exists'])
        continue 
    end
    load(runInfo.saveMaskFile,'xform_isbrain'); 

    disp(['Loaded ', runInfo.mouseName, ' runs: ' num2str(ind)])

    %Plotting
fbands={'Full','ISA','Delta'};    
    for i=1:5
        fh1=figure; 
        tiledlayout(1,3)
        
        for j=1:3 %through each freq band
            nexttile
            imagesc(10*log10(powerMap(:,:,j,i).*1/max(max(powerMap(:,:,j,i).*1))),'alphadata',xform_isbrain) 
            title(fbands{j},'Position',[62 15])
            axis image
            axis off
            colormap; 
            caxis([-30,0])
        end
        cb=colorbar;
        if i<=3
            cb.Label.String='Normalized Log10(Mol^2/Hz)'
        else
            cb.Label.String='Normalized Log10(\DeltaF/F%)^2/Hz'            
        end 
        sgtitle([runInfo.mouseName, ' Average Power Map:' runInfo.Contrasts{i}])
    
        
        fh2=figure;
        loglog(hz,global_sig_for(:,i)/global_sig_for(1,i));
        grid on
        xlabel('Frequency (Hz)')
        if i<=3
        ylabel('NormalizedLog10(Mol^2/Hz)')
        else
        ylabel('Normalized Log10(\DeltaF/F%)^2/Hz')            
        end
        ylim([10^-5 10])
        xlim([10^(-2) 10]) %[0 runsInfo.samplingrate/2].

        sgtitle([runInfo.mouseName, ' Global Signal Spectra:' runInfo.Contrasts{i}])        

        power_across_cortex=reshape(whole_spectra_map,[128*128,numel(hz),numel(runInfo.Contrasts)]);
        power_across_cortex=squeeze(mean(power_across_cortex,1,'omitnan')); %this is now size hz, contrast %removed a parenthesis

        fh3=figure() 
        loglog(hz,power_across_cortex(:,i)/power_across_cortex(1,i));
        grid on
        xlabel('Frequency (Hz)')
        if i<=3
        ylabel('Normalized Log10(Mol^2/Hz)')
        else
        ylabel('Normalized Log10(\DeltaF/F%)^2/Hz')            
        end
        grid on
        ylim([10^-4 10]) 
        xlim([10^(-2) 10]) %[0 runsInfo.samplingrate/2]
        
        sgtitle([runInfo.mouseName, ' Cortical Power:' runInfo.Contrasts{i}])
     end
    close all; 
    
    

    
end