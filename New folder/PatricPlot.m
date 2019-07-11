clearvars;close all;clc
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end


for excelRow = [19 20 21]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    if ~isempty(excelRaw{14})
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        systemType = excelRaw{5};
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        
        SpecificMouseName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend");
        
        if strcmp(char(sessionType),'stim')
            oxy_runs = [];
            deoxy_runs = [];
            total_runs = [];
            gcampRaw_runs = [];
            gcampCorr_runs = [];
            green_runs = [];
            
            for run = str2num(excelRaw{14})
                %         rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
                %         [~, ~, L]=size(rawdata);
                processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
                
                mask_oxy_name = strcat(fullfile(saveDir,processedDataName),'_OxyActiveMask');
                if exist(strcat(mask_oxy_name,'.mat'),'file')
                    load(strcat(mask_oxy_name,'.mat'),'mask_oxy');
                else
                    load(strcat(fullfile(saveDir,processedDataName),'.mat'),'AvgOxy_endStim')
                    imagesc(AvgOxy_endStim, [-max(max(AvgOxy_endStim)) max(max(AvgOxy_endStim))]);
                    axis image off
                    title('Avg Oxy')
                    disp('Create mask')
                    p = drawpolygon('LineWidth',7,'Color','cyan');
                    bw = poly2mask(p.Position(:,1),p.Position(:,2),128,128);
                    isActivate=double(bw);
                    temp_oxy_area = AvgOxy_endStim.*isActivate;
                    temp_oxy_max = max(temp_oxy_area,[],'all');
                    
                    mask_oxy = zeros(128,128);
                    mask_oxy(temp_oxy_area>= 0.75*temp_oxy_max) = 1;
                    mask_oxy = logical(mask_oxy);
                    imshow(mask_oxy);
                    saveas(gcf,strcat(mask_oxy_name,'jpg'));
                    save(strcat(mask_oxy_name,'.mat'),'mask_oxy');
                end
                
                mask_gcampCorr_name = strcat(fullfile(saveDir,processedDataName),'_GcampCorrActiveMask');
                if exist(strcat(mask_gcampCorr_name,'.mat'),'file')
                    load(strcat(mask_gcampCorr_name,'.mat'),'mask_gcampCorr');
                else
                    load(strcat(fullfile(saveDir,processedDataName),'.mat'),'AvggcampCorr_endStim')
                    imagesc(AvggcampCorr_endStim, [-max(max(AvggcampCorr_endStim)) max(max(AvggcampCorr_endStim))]);
                    axis image off
                    title('Avg GcampCorr')
                    disp('Create mask')
                    p_gcampCorr = drawpolygon('LineWidth',7,'Color','cyan');
                    bw_gcampCorr = poly2mask(p_gcampCorr.Position(:,1),p_gcampCorr.Position(:,2),128,128);
                    isActivate_gcampCorr=double(bw_gcampCorr);
                    temp_gcampCorr_area = AvggcampCorr_endStim.*isActivate_gcampCorr;
                    temp_gcampCorr_max = max(temp_gcampCorr_area,[],'all');
                    
                    mask_gcampCorr = zeros(128,128);
                    mask_gcampCorr(temp_gcampCorr_area>=0.75*temp_gcampCorr_max) = 1;
                    mask_gcampCorr = logical(mask_gcampCorr);
                    imshow(mask_gcampCorr)
                    saveas(gcf,strcat(mask_gcampCorr_name,'jpg'));
                    save(strcat(mask_gcampCorr_name,'.mat'),'mask_gcampCorr');
                end
                
                clear AvgOxy_endStim AvggcampCorr_endStim
                load(strcat(fullfile(saveDir,processedDataName),'.mat'),'xform_hb','xform_total','xform_gcampCorr','xform_gcamp','xform_green','sessionInfo','info','time')
                oxy = squeeze(xform_hb(:,:,1,:));
                deoxy = squeeze(xform_hb(:,:,2,:));
                clear xform_hb
                total = squeeze(xform_total(:,:,1,:));
                clear xform_total
                gcampRaw = squeeze(xform_gcamp(:,:,1,:));
                clear xform_gcamp
                gcampCorr = squeeze(xform_gcampCorr(:,:,1,:));
                clear xform_gcampCorr
                green = squeeze(xform_green(:,:,1,:));
                clear xform_green
                R=mod(size(oxy,3),sessionInfo.stimblocksize);
                if R~=0
                    pad=sessionInfo.stimblocksize-R;
                    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ', num2str(pad), ' zeros **'))
                    oxy(:,:,end:end+pad)=0;
                    deoxy(:,:,end:end+pad)=0;
                    total(:,:,end:end+pad)=0;
                    gcampRaw(:,:,end:end+pad)=0;
                    gcampCorr(:,:,end:end+pad)=0;
                    green(:,:,end:end+pad)=0;
                    info.appendedzeros=pad;
                end
                
                
                
                
                oxy = reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                deoxy = reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                total = reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                gcampRaw = reshape(gcampRaw,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                gcampCorr = reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                green = reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                
                oxy_runs = cat(4,oxy_runs,oxy);
                deoxy_runs = cat(4,deoxy_runs,deoxy);
                total_runs = cat(4,total_runs,total);
                gcampRaw_runs = cat(4,gcampRaw_runs,gcampRaw);
                gcampCorr_runs = cat(4,gcampCorr_runs,gcampCorr);
                green_runs = cat(4,green_runs,green);
            end
            clear oxy deoxy total gcampRaw gcampCorr green
            
            baseline_size = size(oxy_runs);
            oxy_runs_baseline = zeros(baseline_size);
            deoxy_runs_baseline = zeros(baseline_size);
            total_runs_baseline = zeros(baseline_size);
            gcampRaw_runs_baseline = zeros(baseline_size);
            gcampCorr_runs_baseline = zeros(baseline_size);
            green_runs_baseline = zeros(baseline_size);
            
            numBlock_runs = size(oxy_runs,4);
            frames_block = sessionInfo.stimblocksize;
            for block = 1:numBlock_runs
                for frame = 1:frames_block
                    oxy_runs_baseline(:,:,frame,block) = squeeze(oxy_runs(:,:,frame,block))-squeeze(mean(oxy_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                    deoxy_runs_baseline(:,:,frame,block) = squeeze(deoxy_runs(:,:,frame,block))-squeeze(mean(deoxy_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                    total_runs_baseline(:,:,frame,block) = squeeze(total_runs(:,:,frame,block))-squeeze(mean(total_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                    gcampRaw_runs_baseline(:,:,frame,block) = squeeze(gcampRaw_runs(:,:,frame,block))-squeeze(mean(gcampRaw_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                    gcampCorr_runs_baseline(:,:,frame,block) = squeeze(gcampCorr_runs(:,:,frame,block))-squeeze(mean(gcampCorr_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                    green_runs_baseline(:,:,frame,block) = squeeze(green_runs(:,:,frame,block))-squeeze(mean(green_runs(:,:,1:sessionInfo.stimbaseline,block),3));
                end
            end
            
                oxy_runs_blockAvg = mean(oxy_runs_baseline,4);
            deoxy_runs_blockAvg = mean(deoxy_runs_baseline,4);
            total_runs_blockAvg = mean(total_runs_baseline,4);
            gcampRaw_runs_blockAvg = mean(gcampRaw_runs_baseline,4);
            gcampCorr_runs_blockAvg = mean(gcampCorr_runs_baseline,4);
            green_runs_blockAvg = mean(green_runs_baseline,4);
            
            clear oxy_runs_baseline deoxy_runs_baseline total_runs_baseline gcampRaw_runs_baseline gcampCorr_runs_baseline green_runs_baseline
    
            oxy_runs_blockAvg_active =  zeros(1,frames_block);
            deoxy_runs_blockAvg_active = zeros(1,frames_block);
            total_runs_blockAvg_active = zeros(1,frames_block);
            gcampRaw_runs_blockAvg_active = zeros(1,frames_block);
            gcampCorr_runs_blockAvg_active = zeros(1,frames_block);
            green_runs_blockAvg_active = zeros(1,frames_block);
            for i = 1:frames_block
                
                oxy = oxy_runs_blockAvg(:,:,i);
                oxy_runs_blockAvg_active(i) = mean(oxy(mask_oxy));
                
                deoxy = deoxy_runs_blockAvg(:,:,i);
                deoxy_runs_blockAvg_active(i) = mean(deoxy(mask_oxy));
                
                total = total_runs_blockAvg(:,:,i);
                total_runs_blockAvg_active(i) = mean(total(mask_oxy));
                
                gcampRaw = gcampRaw_runs_blockAvg(:,:,i);
                gcampRaw_runs_blockAvg_active(i) = mean(gcampRaw(mask_gcampCorr));
                
                gcampCorr = gcampCorr_runs_blockAvg(:,:,i);
                gcampCorr_runs_blockAvg_active(i) = mean(gcampCorr(mask_gcampCorr));
                
                green = green_runs_blockAvg(:,:,i);
                green_runs_blockAvg_active(i) = mean(green(mask_gcampCorr));
            end
            
            
            x = (1:sessionInfo.stimblocksize).*(30/sessionInfo.stimblocksize);
            plotedit on
            
            subplot('position',[0.1,0.08,0.8,0.35])
            yyaxis left
            p1 = plot(x,gcampCorr_runs_blockAvg_active(1:sessionInfo.stimblocksize),'k');
            ylim([-0.03 0.03])
            
            
            hold on
            yyaxis right
            p2 = plot(x,oxy_runs_blockAvg_active(1:sessionInfo.stimblocksize),'r');
            ylim([-3e-5 3e-5])
            hold on
            yyaxis right
            ylabel('HBO_2,HbR(\DeltaM)','FontSize',8)
            p3 = plot(x,deoxy_runs_blockAvg_active(1:sessionInfo.stimblocksize),'b');
            ylim([-3e-5 3e-5]);
            p4 = plot(x,total_runs_blockAvg_active(1:sessionInfo.stimblocksize),'y');
            yyaxis left;
            ylabel('GCaMP6f(\DeltaF/F)','FontSize',6);
            
            
            hold on
            for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
                line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-0.03 0.03]);
                hold on
            end
            legend([p2 p3 p4 p1 ],'HbO_2','HbR','HbTotal','G6f(corr.)','FontSize',4);
            xlabel('Time(s)','FontSize',6)
            xt = get(gca, 'XTick');
            set(gca, 'FontSize',4)
            
            
            subplot('position',[0.1,0.50,0.8,0.35])
            p4 = plot(x,gcampCorr_runs_blockAvg_active(1:sessionInfo.stimblocksize),'k');
            ylim([-0.04 0.03])
            
            
            hold on
            p5=plot(x,gcampRaw_runs_blockAvg_active(1:sessionInfo.stimblocksize),'Color',[0 0.6 0]);
            ylabel('GCaMP6f(\DeltaF/F)','FontSize',6)
            hold on
            p6=plot(x,green_runs_blockAvg_active(1:sessionInfo.stimblocksize),'g');
            y2 = get(gca,'ylim');
            hold on
            for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
                line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-0.04 0.04]);
                hold on
            end
            
            legend([p6 p5 p4 ],'512nm','G6f(raw)','G6f(corr.)','FontSize',4);
            xlabel('Time(s)','FontSize',6)
            
            xt = get(gca, 'XTick');
            set(gca, 'FontSize',4)
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(recDate," ",sessionType," ",sessionInfo.bandtype{1},' Block Average for  ' ,{' '}, mouseName),'FontWeight','bold','Color',[1 0 0],'FontSize',8);
            
            output=fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,"-",sessionInfo.bandtype{1},'-BlockAvg_EachMouse_Vis.jpg'));
            orient portrait
            print ('-djpeg', '-r1000',output);
            figure('visible', 'on');
            save(strcat(fullfile(saveDir,SpecificMouseName),'_BlockAverage.mat'),'gcampCorr_runs_blockAvg_active','oxy_runs_blockAvg_active','deoxy_runs_blockAvg_active','total_runs_blockAvg_active','gcampRaw_runs_blockAvg_active','green_runs_blockAvg_active')
            
            
            close all
        end
    end
end

clear all;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end
info.nVy = 128;
info.nVx = 128;
for excelRow= [19 20]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    if ~isempty(excelRaw{14})
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        if strcmp(char(sessionType),'stim')
            SpecificMouseName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend");
            numRuns = length(str2num(excelRaw{14}));
            
            AvgOxy_endStim_runs = zeros(info.nVy,info.nVx,numRuns);
            AvgDeOxy_endStim_runs = zeros(info.nVy,info.nVx,numRuns);
            AvgTotal_endStim_runs = zeros(info.nVy,info.nVx,numRuns);
            Avggcamp_endStim_runs = zeros(info.nVy,info.nVx,numRuns);
            AvggcampCorr_endStim_runs = zeros(info.nVy,info.nVx,numRuns);
            numPres = 10;
            gcamp_endStim_runs = zeros(info.nVy,info.nVx, numPres,numRuns);
            gcampCorr_endStim_runs = zeros(info.nVy,info.nVx, numPres,numRuns);
            oxy_endStim_runs = zeros(info.nVy,info.nVx, numPres,numRuns);
            deoxy_endStim_runs = zeros(info.nVy,info.nVx, numPres,numRuns);
            total_endStim_runs = zeros(info.nVy,info.nVx, numPres,numRuns);
            
            
            for run = str2num(excelRaw{14})
                processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
                load(strcat(fullfile(saveDir,processedDataName),'.mat'),'AvgOxy_endStim', 'AvgDeOxy_endStim', 'AvgTotal_endStim','Avggcamp_endStim','AvggcampCorr_endStim','gcamp_endStim','gcampCorr_endStim','oxy_endStim','deoxy_endStim','total_endStim');
                AvgOxy_endStim_runs (:,:,run)= AvgOxy_endStim;
                AvgDeOxy_endStim_runs (:,:,run)= AvgDeOxy_endStim;
                AvgTotal_endStim_runs (:,:,run)= AvgTotal_endStim;
                Avggcamp_endStim_runs (:,:,run)= Avggcamp_endStim;
                AvggcampCorr_endStim_runs (:,:,run)= AvggcampCorr_endStim;
                
                gcamp_endStim_runs(:,:,:,run)=  gcamp_endStim;
                gcampCorr_endStim_runs(:,:,:,run)= gcampCorr_endStim;
                oxy_endStim_runs(:,:,:,run)= oxy_endStim;
                deoxy_endStim_runs(:,:,:,run)= deoxy_endStim;
                total_endStim_runs(:,:,:,run)= total_endStim;
                
                
                
            end
            AvgOxy_endStim_runs=mean( AvgOxy_endStim_runs,3);
            AvgDeOxy_endStim_runs=mean( AvgDeOxy_endStim_runs,3);
            AvgTotal_endStim_runs=mean( AvgTotal_endStim_runs,3);
            Avggcamp_endStim_runs=mean( Avggcamp_endStim_runs,3);
            AvggcampCorr_endStim_runs=mean( AvggcampCorr_endStim_runs,3);
            gcamp_endStim_runs=mean(gcamp_endStim_runs,4);
            gcampCorr_endStim_runs=mean(gcampCorr_endStim_runs,4);
            oxy_endStim_runs=mean(oxy_endStim_runs,4);
            deoxy_endStim_runs=mean(deoxy_endStim_runs,4);
            total_endStim_runs=mean(total_endStim_runs,4);
            
            
            
            
            
            
            
            for b=1:numPres
                p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
                imagesc(gcamp_endStim_runs(:,:,b), [-max(max(gcamp_endStim_runs(:,:,b))) max(max(gcamp_endStim_runs(:,:,b)))]);
                
                if b == numPres
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.8 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampRaw')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            
            for b=1:numPres
                p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
                imagesc(gcampCorr_endStim_runs(:,:,b), [-max(max(gcampCorr_endStim_runs(:,:,b))) max(max(gcampCorr_endStim_runs(:,:,b)))]);
                if b == numPres
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.65 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampCorr')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            
            for b=1:numPres
                p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
                imagesc(oxy_endStim_runs(:,:,b), [-2e-5 2e-5]);
                if b == numPres
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b == 1
                    ylabel('Oxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            
            for b=1:numPres
                p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
                imagesc(deoxy_endStim_runs(:,:,b), [-2e-5 2e-5]);
                if b == numPres
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.35 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('DeOxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            
            
            
            for b=1:numPres
                p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
                imagesc(total_endStim_runs(:,:,b), [-0.4e-5 0.4e-5]);
                if b == numPres
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.2 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('Total')
                end
                title(['Pres ', num2str(b)]);
            end
            
            
            
            p = subplot('position', [0.015 0.05 0.095 0.095]);
             imagesc(Avggcamp_endStim_runs, [-max(max(Avggcamp_endStim_runs)) max(max(Avggcamp_endStim_runs))]);
            colorbar
            set(p,'Position',[0.015 0.05 0.095 0.095]);
            axis image off
            title('Avg Gcamp')
            
            
            
            p = subplot('position', [0.165 0.05 0.095 0.095]);
            imagesc(AvggcampCorr_endStim_runs, [-max(max(AvggcampCorr_endStim_runs)) max(max(AvggcampCorr_endStim_runs))]);
            colorbar
            set(p,'Position',[0.165 0.05 0.095 0.095]);
            axis image off
            title('Avg GcampCorr')
            
            
            
            p = subplot('position', [0.315 0.05 0.095 0.095]);
           imagesc(AvgOxy_endStim_runs, [-1.5e-5 1.5e-5]);
            colorbar
            set(p,'Position',[0.315 0.05 0.095 0.095]);
            axis image off
            title('Avg Oxy')
            
            p = subplot('position', [0.465 0.05 0.095 0.095]);
            imagesc(AvgDeOxy_endStim_runs, [-1.5e-5 1.5e-5]);
            colorbar
            set(p,'Position',[0.465 0.05 0.095 0.095]);
            axis image off
            title('Avg Deoxy')
            
            
            p = subplot('position', [0.615 0.05 0.095 0.095]);
            imagesc(AvgTotal_endStim_runs, [-0.4e-5 0.4e-5]);
            colorbar
            set(p,'Position',[0.615 0.05 0.095 0.095]);
            axis image off
            title('Avg Total')
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(SpecificMouseName,'Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
            
            output= strcat(fullfile(saveDir,SpecificMouseName),'_StimMap_EachMouse.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all
            save(strcat(fullfile(saveDir,SpecificMouseName),'_StimMap_EachMouse.mat'),'AvgOxy_endStim_runs', 'AvgDeOxy_endStim_runs', 'AvgTotal_endStim_runs','Avggcamp_endStim_runs','AvggcampCorr_endStim_runs','gcamp_endStim_runs','gcampCorr_endStim_runs','oxy_endStim_runs','deoxy_endStim_runs','total_endStim_runs');
        end
        
    end
    
end




% %% FC
% %
% clear all;
% excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
% isGsr = true;
% if isGsr == true
%     isGsrname = '-GSR';
% else
%     isGsrname = '';
% end
% info.nVy = 128;
% info.nVx = 128;
% for excelRow= [3 5 7 8 10]
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
%     if ~isempty(excelRaw{14})
%         recDate = excelRaw{1}; recDate = string(recDate);
%         mouseName = excelRaw{2}; mouseName = string(mouseName);
%         saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%         sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%         if strcmp(char(sessionType),'fc')
%  
%             SpecificMouseName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend");
%             numSeeds = 14;
%             numRuns = length(str2num(excelRaw{14}));
%             Rs_oxy_ISA_runs = zeros(numSeeds,numSeeds,numRuns);
%             Rs_gcampCorr_ISA_runs = zeros(numSeeds,numSeeds,numRuns);
%             Rs_oxy_Delta_runs = zeros(numSeeds,numSeeds,numRuns);
%             Rs_gcampCorr_Delta_runs = zeros(numSeeds,numSeeds,numRuns);
%             
%             
%             R_oxy_ISA_runs = zeros(info.nVy,info.nVx, numSeeds,numRuns);
%             R_gcampCorr_ISA_runs = zeros(info.nVy,info.nVx, numSeeds,numRuns);
%             R_oxy_Delta_runs = zeros(info.nVy,info.nVx, numSeeds,numRuns);
%             R_gcampCorr_Delta_runs = zeros(info.nVy,info.nVx, numSeeds,numRuns);
%             
%             
%             numRuns = length(str2num(excelRaw{14}));
%             for run = str2num(excelRaw{14})
%                 processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
%                 load(strcat(fullfile(saveDir,processedDataName),'.mat'),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA','Rs_gcampCorr_ISA','R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta','xform_isbrain');
%                 Rs_oxy_ISA_runs (:,:,run)= Rs_oxy_ISA;
%                 Rs_gcampCorr_ISA_runs (:,:,run)= Rs_gcampCorr_ISA;
%                 Rs_oxy_Delta_runs (:,:,run)= Rs_oxy_Delta;
%                 Rs_gcampCorr_Delta_runs (:,:,run)= Rs_gcampCorr_Delta;
%                 
%                 R_oxy_ISA_runs(:,:,:,run)=  R_oxy_ISA;
%                 R_gcampCorr_ISA_runs(:,:,:,run)= R_gcampCorr_ISA;
%                 R_oxy_Delta_runs(:,:,:,run)= R_oxy_Delta;
%                 R_gcampCorr_Delta_runs(:,:,:,run)= R_gcampCorr_Delta;
%                 
%                 
%                 
%                 
%             end
%             Rs_oxy_ISA_runs=mean( Rs_oxy_ISA_runs,3);
%             Rs_gcampCorr_ISA_runs=mean( Rs_gcampCorr_ISA_runs,3);
%             Rs_oxy_Delta_runs=mean( Rs_oxy_Delta_runs,3);
%             Rs_gcampCorr_Delta_runs=mean( Rs_gcampCorr_Delta_runs,3);
%             
%             R_oxy_ISA_runs=mean(R_oxy_ISA_runs,4);
%             R_gcampCorr_ISA_runs=mean(R_gcampCorr_ISA_runs,4);
%             R_oxy_Delta_runs=mean(R_oxy_Delta_runs,4);
%             R_gcampCorr_Delta_runs=mean(R_gcampCorr_Delta_runs,4);
%             
%             
%             
%             
%             
%             
%             
%             
%             
%             
%             seednames={'Olf','Fr','Cg','M','SS','RS','V'};
%             refseeds=GetReferenceSeeds;
%             refseeds = refseeds(1:14,:);
%             sides={'L','R'};
%             
%             mm=10;
%             mpp=mm/info.nVx;
%             seedradmm=0.25;
%             seedradpix=seedradmm/mpp;
%             
%             numseeds=numel(seednames);
%             numsides=numel(sides);
%             P=burnseeds(refseeds,seedradpix,xform_isbrain);
%             figure;
%             for s=1:numseeds
%                 
%                 OE=0;
%                 if mod(s,2)==0
%                     OE=0.26;
%                 else
%                     OE=0.1;
%                 end
%                 
%                 subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_oxy_ISA_runs(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%                 axis image off
%                 title([seednames{s},'R'],'FontSize',6)
%                 
%                 p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_oxy_ISA_runs(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%                 axis image off
%                 title([seednames{s},'L'],'FontSize',6)
%                 hold off;
%                 
%             end
%             colorbar
%             set(p1,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%             
%             for s=1:numseeds
%                 
%                 if mod(s,2)==0
%                     OE=0.26;
%                 else
%                     OE=0.1;
%                 end
%                 
%                 subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_gcampCorr_ISA_runs(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%                 axis image off
%                 title([seednames{s},'R'],'FontSize',6)
%                 
%                 p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_gcampCorr_ISA_runs(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%                 axis image off
%                 title([seednames{s},'L'],'FontSize',6)
%                 hold off;
%                 
%             end
%             
%             colorbar
%             set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%             
%             
%             
%             
%             
%             for s=1:numseeds
%                 
%                 OE=0;
%                 if mod(s,2)==0
%                     OE=0.26;
%                 else
%                     OE=0.1;
%                 end
%                 
%                 subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_oxy_Delta_runs(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%                 axis image off
%                 title([seednames{s},'R'],'FontSize',6)
%                 
%                 p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_oxy_Delta_runs(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%                 axis image off
%                 title([seednames{s},'L'],'FontSize',6)
%                 hold off;
%                 
%             end
%             colorbar
%             set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%             
%             for s=1:numseeds
%                 
%                 OE=0;
%                 if mod(s,2)==0
%                     OE=0.26;
%                 else
%                     OE=0.1;
%                 end
%                 
%                 subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_gcampCorr_Delta_runs(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%                 axis image off
%                 title([seednames{s},'R'],'FontSize',6)
%                 
%                 p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%                 %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%                 imagesc(R_gcampCorr_Delta_runs(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%                 hold on;
%                 plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%                 axis image off
%                 title([seednames{s},'L'],'FontSize',6)
%                 hold off;
%                 
%             end
%             
%             colorbar
%             set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%             
%             
%             
%             
%             
%             
%             
%             annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(SpecificMouseName,' FC Map'),'FontWeight','bold');
%             annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
%             annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
%             
%             annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
%             annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
%             
%             output= strcat(fullfile(saveDir,SpecificMouseName),'_FCMap_EachMouse.jpg');
%             orient portrait
%             print ('-djpeg', '-r300', output);
%             
%             figure('visible', 'on');
%             close all
%             
%             subplot(2,2,1)
%             imagesc(Rs_oxy_ISA_runs,[-1 1])
%             colorbar
%             subplot(2,2,2)
%             imagesc(Rs_gcampCorr_ISA_runs,[-1 1])
%             subplot(2,2,3)
%             imagesc(Rs_oxy_Delta_runs,[-1 1])
%             subplot(2,2,4)
%             imagesc(Rs_gcampCorr_Delta_runs,[-1 1])
%             
%             
%             annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(SpecificMouseName,' FC matrix'),'FontWeight','bold');
%             annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
%             annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
%             
%             annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
%             annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
%             
%             output= strcat(fullfile(saveDir,SpecificMouseName),'_FCMatrix_EachMouse.jpg');
%             orient portrait
%             print ('-djpeg', '-r300', output);
%             
%             figure('visible', 'on');
%             close all
%             
%             
%             
%             save(fullfile(saveDir,strcat(SpecificMouseName,"_FCMap_EachMouse.mat")),'R_oxy_ISA_runs', 'Rs_oxy_ISA_runs','R_gcampCorr_ISA_runs', 'Rs_gcampCorr_ISA_runs','R_oxy_Delta_runs', 'Rs_oxy_Delta_runs','R_gcampCorr_Delta_runs', 'Rs_gcampCorr_Delta_runs','xform_isbrain');
%             clear  R_oxy_ISA_runs    Rs_oxy_ISA_runs   R_gcampCorr_ISA_runs    Rs_gcampCorr_ISA_runs   R_oxy_Delta_runs    Rs_oxy_Delta_runs   R_gcampCorr_Delta_runs    Rs_gcampCorr_Delta_runs
%         end
%     end
% end
% 
% 
