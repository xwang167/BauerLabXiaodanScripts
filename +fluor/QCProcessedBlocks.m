import mouse.*
sessionInfo.framerate = 16.667;
sessionInfo.hbSpecies = 1:2;
sessionInfo.stimbaseline = 83;
sessionInfo.stimblocksize = 500;
sessionInfo.stimduration = 5;
info.freqout=1;
info.bandtype = {"0.01Hz-8Hz",0.01,8};
info.newFreq = 8;
pkgDir = what('bauerParams');
ledDir = string(fullfile(pkgDir.path,'ledSpectra'));
extCoeffDir = string(pkgDir.path);
hbSpecies = sessionInfo.hbSpecies;
    systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_TL625_Pol.txt"];
    
for ind = 1:numel(systemInfo.LEDFiles)
    systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
end



green = reshape(green_blocks_G2M5_stim1,128,128,[]);
red = reshape(red_blocks_G2M5_stim1,128,128,[]);
raw = zeros(128,128,2,size(red,3));
raw(:,:,1,:) = green;
raw(:,:,2,:) = red;


load(strcat('J:\ProcessedData_2\Zyla\190115\Combined\190115-G2M5-LandmarksandMarks'),'isbrain','I')
xform_raw = preprocess.affineTransform(raw,I);
xform_raw(isnan(xform_raw)) = 0;
 xform_isbrain = Affine(I,isbrain);
 xform_isbrain(isnan(xform_isbrain)) = 0;
[xform_datahb, ~, ~]= ...
    mouse.preprocess.procOIS(xform_raw,...
    systemInfo.LEDFiles(3:4),xform_isbrain);
xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
xform_datahb_bandpass(isnan(xform_datahb_bandpass)) = 0; 
xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
 
                 oxy = double(squeeze(xform_datahb_GSR(:,:,1,:)));
                deoxy = double(squeeze(xform_datahb_GSR(:,:,2,:)));
                total = double(oxy+deoxy);
                
                                fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
                set(fhraw,'Units','normalized','visible','off');
                                oxy = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                deoxy = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                total = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                
                oxy = permute(oxy,[1 2 4 3]);
                deoxy = permute(deoxy,[1 2 4 3]);
                total = permute(total,[1 2 4 3]);
                
                info.stimblocksize = size(oxy,3);
                info.stimbaseline = round(sessionInfo.stimbaseline/sessionInfo.stimblocksize*info.stimblocksize);

                
                        AvgOxy= mean(oxy,4);
        MeanFrame_oxy=mean(AvgOxy(:,:,1:info.stimbaseline),3);
        AvgOxy_stim = mean(AvgOxy(:,:,(info.stimbaseline+1):(info.stimbaseline+round((sessionInfo.stimduration+1)*info.newFreq)))-MeanFrame_oxy,3);
        
        load('atlas.mat','AtlasSeeds');
        roi = AtlasSeeds == 9;
        temp_oxy_area = AvgOxy_stim.*roi;
        temp_oxy_max = max(temp_oxy_area,[],'all');
        roi_contour = bwperim(roi);
        
        mask_oxy = zeros(128,128);
        mask_oxy(temp_oxy_area>= 0.5*temp_oxy_max) = 1;
        mask_oxy = logical(mask_oxy);
        mask_oxy_contour = bwperim(mask_oxy );
        
        
        
        
        
        
        
        R=mod(size(oxy,3),info.stimblocksize);
        
        if R~=0
            pad=info.stimblocksize-R;
            disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ', num2str(pad), ' zeros **'))
            oxy(:,:,end:end+pad)=0;
            deoxy(:,:,end:end+pad)=0;
            total(:,:,end:end+pad)=0;
            
        end
        
        
        
        
        
        oxy_blocks = mean(oxy,4);
        deoxy_blocks = mean(deoxy,4);
        total_blocks = mean(total,4);
        
        
        
        
        oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:info.stimbaseline),3);
        deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:info.stimbaseline),3);
        total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:info.stimbaseline),3);
        
        
        
        
        clear oxy_blocks deoxy_blocks  total_blocks
        
        
        oxy_blocks_baseline_active =  zeros(1,info.stimblocksize);
        deoxy_blocks_baseline_active = zeros(1,info.stimblocksize);
        total_blocks_baseline_active = zeros(1,info.stimblocksize);
        
        for i = 1:info.stimblocksize
            
            oxy_temp = oxy_blocks_baseline(:,:,i);
            oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_oxy));
            
            deoxy_temp = deoxy_blocks_baseline(:,:,i);
            deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_oxy));
            
            total_temp = total_blocks_baseline(:,:,i);
            total_blocks_baseline_active(i) = mean(total_temp(mask_oxy));
            
            
        end
        stimDurationFrames = round(sessionInfo.stimduration*info.newFreq);
        max_oxy = max(oxy_blocks_baseline_active(info.stimbaseline:(info.stimbaseline+stimDurationFrames+round(1*info.newFreq))));%find peaks
        
        
        x = (1:round(info.stimblocksize))/info.newFreq;
        
        
        hold on
        subplot('position',[0.1,0.08,0.4,0.35])
        
        
        p2 = plot(x,oxy_blocks_baseline_active,'r-');
        
        hold on
        
        p3 = plot(x,deoxy_blocks_baseline_active,'b-');
        
        
        p4 = plot(x,total_blocks_baseline_active,'k-');
        
        
        sessionInfo.stimFrequency = 1;
        hold on
        for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
            line([5+i 5+i],[-1.2*max_oxy 1.2*max_oxy]);
            hold on
        end
        ax = gca;
        ax.FontSize = 8;
        
        legend([p2 p3 p4 ],'HbO_2','HbR','HbTotal','FontSize',4);
        xlabel('Time(s)','FontSize',6)
        
        
        ylabel('HBO_2,HbR(\DeltaM)','FontSize',6)
        ylim([-1.2*max_oxy 1.2*max_oxy])
        
        subplot('position',[0.6,0.08,0.35,0.35])
        imagesc(AvgOxy_stim,[-1.5*temp_oxy_max 1.5*temp_oxy_max])
        hold on
        contour(roi_contour,'r')
        hold on
        contour(mask_oxy_contour,'k')
        axis image off
        title('oxy 50% to oxy, deoxy, total' )
        
  
                
                annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(ii)),'FontWeight','bold','Color',[1 0 0],'FontSize',8);
                
                output= strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),' .jpg');
                orient portrait
                print ('-djpeg', '-r1000',output);
                figure('visible', 'on');
