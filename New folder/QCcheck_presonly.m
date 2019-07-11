close all;clearvars;clc
isGsr = true;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
excelRows = 7:11;
%Xiaodan

if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':G',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = string(saveDir);
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    for run = 1:3
        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),"-",sessionInfo.bandtype,"-NewDetrend");
        processedDataName  = fullfile(saveDir,processedDataName);
        %rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
        %         [~, ~, L]=size(rawdata);

        load(strcat(processedDataName,".mat"),'xform_hb','xform_gcampCorr','xform_isbrain','xform_gcamp','sessionInfo','info')
        info.freqout = 1;
        %[oxy, deoxy]=gsr(xform_hb,xform_isbrain);
        oxy = squeeze(xform_hb(:,:,1,:));
        deoxy = squeeze(xform_hb(:,:,2,:));
        gcamp = squeeze(xform_gcamp(:,:,1,:));
        gcampCorr = squeeze(xform_gcampCorr(:,:,1,:));
        
        oxy = oxy.*xform_isbrain;
        deoxy = deoxy.*xform_isbrain;
        gcamp = gcamp.*xform_isbrain;
        gcampCorr = gcampCorr.*xform_isbrain;
        
        oxy(isnan(oxy)) = 0;
        deoxy(isnan(deoxy)) = 0;
        gcamp(isnan(gcamp)) = 0;
        gcampCorr(isnan(gcampCorr)) = 0;
        
        oxy = resampledata(oxy,sessionInfo.framerate,info.freqout,10^-5);
        deoxy = resampledata(deoxy,sessionInfo.framerate,info.freqout,10^-5);
        gcamp = resampledata(gcamp,sessionInfo.framerate,info.freqout,10^-5);
        gcampCorr = resampledata(gcampCorr,sessionInfo.framerate,info.freqout,10^-5);
        
        
        fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        R=mod(size(oxy,3),sessionInfo.stimblocksize);
        if R~=0
            pad=sessionInfo.stimblocksize-R;
            % disp(['** Non integer number of blocks presented. Padded ' filename, num2str(run), ' with ', num2str(pad), ' zeros **'])
            oxy(:,:,end:end+pad)=0;
            deoxy(:,:,end:end+pad)=0;
            gcamp(:,:,end:end+pad)=0;
            gcampCorr(:,:,end:end+pad)=0;
            info.appendedzeros=pad;
        end
        
        oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        
        for b=1:size(oxy,4)
            MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(oxy, 3);
                oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        for b=1:size(deoxy,4)
            MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(deoxy, 3);
                deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
            end
        end
        
        gcamp =reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        for b=1:size(gcamp,4)
            MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(gcamp, 3);
                gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
            end
        end
        
        gcampCorr =reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        for b=1:size(gcampCorr,4)
            MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(gcampCorr, 3);
                gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
            end
        end
        
        AvgOxy= mean(oxy,4);
        AvgDeOxy= mean(deoxy,4);
        AvgTotal=mean(oxy+deoxy,4);
        Avggcamp = mean(gcamp,4);
        AvggcampCorr = mean(gcampCorr,4);
        
        MeanFrame=squeeze(mean(AvgOxy(:,:,1:sessionInfo.stimbaseline),3));
        for t=1:size(AvgOxy, 3);
            AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:sessionInfo.stimbaseline),3));
        for t=1:size(AvgDeOxy, 3);
            AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgTotal(:,:,1:sessionInfo.stimbaseline),3));
        for t=1:size(AvgTotal, 3);
            AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(Avggcamp(:,:,1:sessionInfo.stimbaseline),3));
        for t=1:size(Avggcamp, 3);
            Avggcamp(:,:,t)=squeeze(Avggcamp(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvggcampCorr(:,:,1:sessionInfo.stimbaseline),3));
        for t=1:size(AvggcampCorr, 3);
            AvggcampCorr(:,:,t)=squeeze(AvggcampCorr(:,:,t))-MeanFrame;
        end
        
        %% Make Plots
        
        for b=1:size(gcamp,4);
            p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
            temp=gcamp(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b);
            imagesc(temp, [-max(max(temp)) max(max(temp))]);
            if b == size(gcamp,4)
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
        
        for b=1:size(gcampCorr,4);
            p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
            temp=gcampCorr(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b);
            imagesc(temp, [-max(max(temp)) max(max(temp))]);
            if b == size(gcampCorr,4)
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
        
        for b=1:size(oxy,4);
            p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
            temp=oxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b);
            imagesc(temp, [-2e-5 2e-5]);
            if b == size(oxy,4)
                colorbar
                set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
            end
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==1
                ylabel('Oxy')
            end
            title(['Pres ', num2str(b)]);
        end
        
        for b=1:size(deoxy,4);
            p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
            temp=deoxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b);
            imagesc(temp, [-2e-5 2e-5]);
            if b == size(deoxy,4)
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
        
        for b=1:size(oxy,4);
            p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
            temp=oxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b)+deoxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration,b);
            imagesc(temp, [-0.4e-5 0.4e-5]);
            if b == size(oxy,4)
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
        temp=mean(Avggcamp(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration-2:sessionInfo.stimbaseline+sessionInfo.stimduration),3);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        colorbar
        set(p,'Position',[0.015 0.05 0.095 0.095]);
        axis image off
        title('Avg Gcamp')
        
        
        
        p = subplot('position', [0.165 0.05 0.095 0.095]);
        temp=mean(AvggcampCorr(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration-2:sessionInfo.stimbaseline+sessionInfo.stimduration),3);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        colorbar
        set(p,'Position',[0.165 0.05 0.095 0.095]);
        axis image off
        title('Avg GcampCorr')
        
        p = subplot('position', [0.315 0.05 0.095 0.095]);
        temp=mean(AvgOxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration-2:sessionInfo.stimbaseline+sessionInfo.stimduration),3);
        imagesc(temp, [-1.5e-5 1.5e-5]);
        colorbar
        set(p,'Position',[0.315 0.05 0.095 0.095]);
        axis image off
        title('Avg Oxy')
        
        p = subplot('position', [0.465 0.05 0.095 0.095]);
        temp=mean(AvgDeOxy(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration-2:sessionInfo.stimbaseline+sessionInfo.stimduration),3);
        imagesc(temp, [-1.5e-5 1.5e-5]);
        colorbar
        set(p,'Position',[0.465 0.05 0.095 0.095]);
        axis image off
        title('Avg DeOxy')
        
        p = subplot('position', [0.615 0.05 0.095 0.095]);
        temp=mean(AvgTotal(:,:,sessionInfo.stimbaseline+sessionInfo.stimduration-2:sessionInfo.stimbaseline+sessionInfo.stimduration),3);
        imagesc(temp, [-0.4e-5 0.4e-5]);
        colorbar
        set(p,'Position',[0.615 0.05 0.095 0.095]);
        axis image off
        title('Avg Total')
        
        save(strcat(processedDataName,'.mat') , 'info','AvgOxy', 'AvgDeOxy', 'AvgTotal','Avggcamp','AvggcampCorr', '-append'); 
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,'Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
        
        output= strcat(processedDataName,'_StimMap.jpg');
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
        
        %Check functional connectivty
    end
 end