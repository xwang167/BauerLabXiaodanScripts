clear all;close all;clc
system = 'EastOIS2';
import mouse.*
info.freqout=1;
info.newFreq = 8;
info.bandtype = {"0.01Hz-8Hz",0.01,8};

excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
info.nVx = 128;
info.nVy = 128;

excelRows = [34];
pkgDir = what('bauerParams');
ledDir = string(fullfile(pkgDir.path,'ledSpectra'));
extCoeffDir = string(pkgDir.path);
  sessionInfo.hbSpecies = 1:2;
hbSpecies = sessionInfo.hbSpecies;

systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
    "TwoCam_Mightex525_BP_Pol.txt", ...
    "TwoCam_Mightex525_BP_Pol.txt", ...
    "TwoCam_TL625_Pol.txt"];

for ind = 1:numel(systemInfo.LEDFiles)
    systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
end

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    
    sessionInfo.mouseType = excelRaw{13};
    
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
  
    
    load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\Combined\',recDate,'-',mouseName,'-LandmarksandMarks'),'isbrain')
    %
    % [nVy, nVx, hem, T]=size(datahb);
    % for h=1:hem;
    %     for m=1:T;
    %         xform_datahb_old(:,:,h,m)=Affine(I, datahb(:,:,h,m));
    %     end
    % end
    %
    %  xform_datahb_old=real(xform_datahb_old);
    % load('J:\ProcessedData_3\GCaMP\181217\181217-G3M6-stim1-GSR-Detrend-0.01Hz-8Hz.mat','xform_datahb_bandpass_GSR')
    
    
    
    
    
    
    for ii = 1
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'.mat');
        directory = fullfile(saveDir, 'Combined');
        load(fullfile(directory,rawName),'raw')
        %raw = double(mouse.expSpecific.procFluor(raw));
        if ~isempty(find(isnan(raw), 1))
            raw(isnan(raw))=0;
        end
        %fluor = squeeze(raw(:,:,1,:));
        green = squeeze(raw(:,:,2,:));
        red = squeeze(raw(:,:,3,:));
        
        %fluor = fluor.*isbrain;
        green = green.*isbrain;
        red = red.*isbrain;
        
        
        green=reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        
        red=reshape(red,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        
        %fluor=reshape(fluor,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        %fluor_blocks = mean(fluor,4);
        green_blocks = mean(green,4);
        red_blocks = mean(red,4);
        saveName = strcat('J:\ProcessedData_2\Zyla\',recDate,'\Combined\',recDate,'-',mouseName,'-stim',num2str(ii));
        save(saveName,'green_blocks','red_blocks','-append')
        
        
        raw = zeros(128,128,2,size(red,3));
        raw(:,:,1,:) = reshape(green_blocks,128,128,[]);
        raw(:,:,2,:) = reshape(red_blocks,128,128,[]);

        load(strcat('J:\ProcessedData_2\Zyla\190115\Combined\190115-G2M5-LandmarksandMarks'),'isbrain','I')

raw(isnan(raw)) = 0;

[datahb, ~, ~]= ...
    mouse.preprocess.procOIS(raw,...
    systemInfo.LEDFiles(3:4),isbrain);
datahb_bandpass =highpass(datahb,info.bandtype{2},sessionInfo.framerate);
datahb_bandpass(isnan(datahb_bandpass)) = 0; 
datahb_GSR = mouse.preprocess.gsr(datahb_bandpass,isbrain);
 
                 oxy = double(squeeze(datahb_GSR(:,:,1,:)));
                deoxy = double(squeeze(datahb_GSR(:,:,2,:)));
                total = oxy+deoxy;
                oxy(isnan(oxy)) = 0;
                deoxy(isnan(deoxy)) = 0;
                total(isnan(total)) = 0;
        
 
        
        
                fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
                set(fhraw,'Units','normalized');
                
                plotedit on
                R=mod(size(oxy,3),sessionInfo.stimblocksize);
                if R~=0
                    pad=sessionInfo.stimblocksize-R;
                    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                    oxy(:,:,end:end+pad)=0;
                    deoxy(:,:,end:end+pad)=0;
                    total(:,:,end:end+pad)=0;
                    
                end
                

                    MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline),3));
                    for t=1:size(oxy, 3);
                        oxy(:,:,t)=squeeze(oxy(:,:,t))-MeanFrame;
                    end
  
                

                    MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline),3));
                    for t=1:size(deoxy, 3);
                        deoxy(:,:,t)=squeeze(deoxy(:,:,t))-MeanFrame;
                    end


                    MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline),3));
                    for t=1:size(total, 3);
                        total(:,:,t)=squeeze(total(:,:,t))-MeanFrame;
                    end

                
          oxy_downsampled = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
        
        oxy_blocks_downsampled = permute(oxy_downsampled,[1 2 4 3]);
                MeanFrame_oxy_downsampled=mean(oxy_blocks_downsampled(:,:,1:5),3);
        oxy_blocks_baseline_downsampled = oxy_blocks_downsampled-MeanFrame_oxy_downsampled;
        %oxy_blocks_baseline_downsampled = oxy_blocks_downsampled;


        deoxy_downsampled = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
        deoxy_blocks_downsampled = permute(deoxy_downsampled,[1 2 4 3]);
                MeanFrame_deoxy_downsampled=mean(deoxy_blocks_downsampled(:,:,1:5),3);
        deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled-MeanFrame_deoxy_downsampled;
         %deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled;
        
        
        total_downsampled = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
        total_blocks_downsampled = permute(total_downsampled,[1 2 4 3]);
        MeanFrame_total_downsampled=mean(total_blocks_downsampled(:,:,1:5),3);
        total_blocks_baseline_downsampled = total_blocks_downsampled-MeanFrame_total_downsampled;   
         %total_blocks_baseline_downsampled = total_blocks_downsampled;
        
        Valmax = max(max(oxy_blocks_baseline_downsampled(:,:,11)));
        for b=4:13
            p = subplot('position', [0.015+(b-4)*0.095 0.77 0.095 0.095]);
            imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-0.7*Valmax 0.7*Valmax]);
            if b == 13
                colorbar
                set(p,'Position',[0.015+(b-4)*0.095 0.77 0.095 0.095]);
            end
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b == 4
                ylabel('Oxy')
            end
            title([num2str(b),'s']);
        end
        
        for b=4:13
            p = subplot('position', [0.015+(b-4)*0.095 0.64 0.095 0.095]);
            imagesc(deoxy_blocks_baseline_downsampled(:,:,b), [-0.5*Valmax 0.5*Valmax]);
            if b == 13
                colorbar
                set(p,'Position',[0.015+(b-4)*0.095 0.64 0.095 0.095]);
            end
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==4
                ylabel('DeOxy')
            end
            title([num2str(b),'s']);
        end
        
        
        
        for b=4:13
            p = subplot('position', [0.015+(b-4)*0.095 0.51 0.095 0.095]);
            imagesc(total_blocks_baseline_downsampled(:,:,b), [-0.7*Valmax 0.7*Valmax]);
            if b == 13
                colorbar
                set(p,'Position',[0.015+(b-4)*0.095 0.51 0.095 0.095]);
            end
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==4
                ylabel('Total')
            end
            title([num2str(b),'s']);
        end
        
               disp(strcat('Generate ROI and Block average plot for '))
               
        MeanFrame_oxy=mean(oxy(:,:,1:sessionInfo.stimbaseline),3);
        AvgOxy_stim = mean(oxy(:,:,(sessionInfo.stimbaseline+round(sessionInfo.framerate)):(sessionInfo.stimbaseline+round((sessionInfo.stimduration+1)*sessionInfo.framerate)))-MeanFrame_oxy,3);
        


        roi = zeros(128,128);
        roi(70:80,20:30) = 1;
        mask_oxy = roi;
        mask_oxy = logical(mask_oxy);
        mask_oxy_contour = bwperim(mask_oxy );
        
        
        
        
        

        
        
        
        
        
        oxy_blocks_baseline = oxy-mean(oxy(:,:,1:sessionInfo.stimbaseline),3);
        deoxy_blocks_baseline = deoxy-mean(deoxy(:,:,1:sessionInfo.stimbaseline),3);
        total_blocks_baseline = total-mean(total(:,:,1:sessionInfo.stimbaseline),3);
        
%           oxy_blocks_baseline = oxy;
%         deoxy_blocks_baseline = deoxy;
%         total_blocks_baseline = total;      
%         
        
        clear oxy deoxy  total
        
        
        oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
        deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
        total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
        
        for i = 1:sessionInfo.stimblocksize
            
            oxy_temp = oxy_blocks_baseline(:,:,i);
            oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_oxy));
            
            deoxy_temp = deoxy_blocks_baseline(:,:,i);
            deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_oxy));
            
            total_temp = total_blocks_baseline(:,:,i);
            total_blocks_baseline_active(i) = mean(total_temp(mask_oxy));
            
            
        end
        stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
        max_oxy = max(oxy_blocks_baseline_active((sessionInfo.stimbaseline+round(sessionInfo.framerate)):(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
        
        
x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
        
        
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
        imagesc(AvgOxy_stim,[-2e-6 2e-6])
        hold on
        contour(mask_oxy_contour,'k')
        axis image off

        
        %ax.FontSize = 8;
        

        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(ii),'-GSR'),'FontWeight','bold','Color',[1 0 0],'FontSize',8);
       
                
                
    end
    
    
end

