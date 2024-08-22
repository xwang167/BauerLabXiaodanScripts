clear all;close all;clc
for run = 1:3
%     rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
%     [~, ~, L]=size(rawdata);
    info.numled = 4;
    info.nVx = 128;
    info.nVy = 128;
    info.framerate = 16.8;
    info.freqout = 1;
    load(strcat('D:\ProcessedData\181031\181031-GCampM2-stim',num2str(run), '-Affine_GSR_NewDetrend'),'oxy','deoxy','gcamp6all','isbrain2')
    
    isbrain2 = double(isbrain2);
    gcamp = squeeze(gcamp6all(:,:,2,:));
    gcampCorr = squeeze(gcamp6all(:,:,1,:));
    
    
    oxy = double(oxy).*isbrain2;
    deoxy = double(deoxy).*isbrain2;
    
    gcamp = double(gcamp).*isbrain2;
    gcampCorr = double(gcampCorr).*isbrain2;
    
    oxy(isnan(oxy)) = 0;
    deoxy(isnan(deoxy)) = 0;
    gcamp(isnan(gcamp)) = 0;
    gcampCorr(isnan(gcampCorr)) = 0;
    
    oxy = resampledata(oxy,info.framerate,info.freqout,10^-5);
    deoxy = resampledata(deoxy,info.framerate,info.freqout,10^-5);
    gcamp = resampledata(gcamp,info.framerate,info.freqout,10^-5);
    gcampCorr = resampledata(gcampCorr,info.framerate,info.freqout,10^-5);
    

    
    fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
    set(fhraw,'Units','normalized','visible','off');
    
    plotedit on
    system = 'EastOIS1_Fluor';
    
    
    
    
    
    info.stimblocksize= 30;
    info.stimbaseline= 5;
    info.stimduration= 5;
    
    R=mod(size(oxy,3),info.stimblocksize);
    if R~=0
        pad=info.stimblocksize-R;
        % disp(['** Non integer number of blocks presented. Padded ' filename, num2str(run), ' with ', num2str(pad), ' zeros **'])
        oxy(:,:,end:end+pad)=0;
        deoxy(:,:,end:end+pad)=0;
        gcamp(:,:,end:end+pad)=0;
        gcampCorr(:,:,end:end+pad)=0;
        info.appendedzeros=pad;
    end
    
    oxy=reshape(oxy,info.nVy,info.nVx,info.stimblocksize,[]);
    
    for b=1:size(oxy,4)
        MeanFrame=squeeze(mean(oxy(:,:,1:info.stimbaseline,b),3));
        for t=1:size(oxy, 3);
            oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
        end
    end
    
    deoxy=reshape(deoxy,info.nVy,info.nVx,info.stimblocksize,[]);
    for b=1:size(deoxy,4)
        MeanFrame=squeeze(mean(deoxy(:,:,1:info.stimbaseline,b),3));
        for t=1:size(deoxy, 3);
            deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
        end
    end
    
    gcamp =reshape(gcamp,info.nVy,info.nVx,info.stimblocksize,[]);
    for b=1:size(gcamp,4)
        MeanFrame=squeeze(mean(gcamp(:,:,1:info.stimbaseline,b),3));
        for t=1:size(gcamp, 3);
            gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
        end
    end
    
    gcampCorr =reshape(gcampCorr,info.nVy,info.nVx,info.stimblocksize,[]);
    for b=1:size(gcampCorr,4)
        MeanFrame=squeeze(mean(gcampCorr(:,:,1:info.stimbaseline,b),3));
        for t=1:size(gcampCorr, 3);
            gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
        end
    end
    
    AvgOxy= mean(oxy,4);
    AvgDeOxy= mean(deoxy,4);
    AvgTotal=mean(oxy+deoxy,4);
    Avggcamp = mean(gcamp,4);
    AvggcampCorr = mean(gcampCorr,4);
    
    MeanFrame=squeeze(mean(AvgOxy(:,:,1:info.stimbaseline),3));
    for t=1:size(AvgOxy, 3);
        AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
    end
    
    MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:info.stimbaseline),3));
    for t=1:size(AvgDeOxy, 3);
        AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
    end
    
    MeanFrame=squeeze(mean(AvgTotal(:,:,1:info.stimbaseline),3));
    for t=1:size(AvgTotal, 3);
        AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
    end
    
    MeanFrame=squeeze(mean(Avggcamp(:,:,1:info.stimbaseline),3));
    for t=1:size(Avggcamp, 3);
        Avggcamp(:,:,t)=squeeze(Avggcamp(:,:,t))-MeanFrame;
    end
    
    MeanFrame=squeeze(mean(AvggcampCorr(:,:,1:info.stimbaseline),3));
    for t=1:size(AvggcampCorr, 3);
        AvggcampCorr(:,:,t)=squeeze(AvggcampCorr(:,:,t))-MeanFrame;
    end
    
    %% Make Plots
    
    for b=1:size(gcamp,4);
        subplot('position', [0.03+(b-1)*0.095 0.8 0.095 0.095]);
        temp=gcamp(:,:,info.stimbaseline+info.stimduration,b);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==1
            ylabel('Gcamp')
        end
        title(['Pres ', num2str(b)]);
    end
    
    for b=1:size(gcampCorr,4);
        subplot('position', [0.03+(b-1)*0.095 0.65 0.095 0.095]);
        temp=gcampCorr(:,:,info.stimbaseline+info.stimduration,b);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==1
            ylabel('GcampCorr')
        end
        title(['Pres ', num2str(b)]);
    end
    
    for b=1:size(oxy,4);
        subplot('position', [0.03+(b-1)*0.095 0.5 0.095 0.095]);
        temp=oxy(:,:,info.stimbaseline+info.stimduration,b);
        imagesc(temp, [-5e-3 5e-3]);
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==1
            ylabel('Oxy')
        end
        title(['Pres ', num2str(b)]);
    end
    
    for b=1:size(deoxy,4);
        subplot('position', [0.03+(b-1)*0.095 0.35 0.095 0.095]);
        temp=deoxy(:,:,info.stimbaseline+info.stimduration,b);
        imagesc(temp, [-5e-3 5e-3]);
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==1
            ylabel('DeOxy')
        end
        title(['Pres ', num2str(b)]);
    end
    
    for b=1:size(oxy,4);
        subplot('position', [0.03+(b-1)*0.095 0.2 0.095 0.095]);
        temp=oxy(:,:,info.stimbaseline+info.stimduration,b)+deoxy(:,:,info.stimbaseline+info.stimduration,b);
        imagesc(temp, [-3e-4 3e-4]);
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==1
            ylabel('Total')
        end
        title(['Pres ', num2str(b)]);
    end
    
    subplot('position', [0.03 0.05 0.095 0.095]);
    temp=mean(Avggcamp(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
    imagesc(temp, [-max(max(temp)) max(max(temp))]);
    axis image off
    title('Avg Gcamp')
    
    
    
    subplot('position', [0.125 0.05 0.095 0.095]);
    temp=mean(AvggcampCorr(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
    imagesc(temp, [-max(max(temp)) max(max(temp))]);
    axis image off
    title('Avg GcampCorr')
    
    subplot('position', [0.22 0.05 0.095 0.095]);
    temp=mean(AvgOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
    imagesc(temp, [-5e-3 5e-3]);
    axis image off
    title('Avg Oxy')
    
    subplot('position', [0.315 0.05 0.095 0.095]);
    temp=mean(AvgDeOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
    imagesc(temp, [-5e-3 5e-3]);
    axis image off
    title('Avg DeOxy')
    
    subplot('position', [0.41 0.05 0.095 0.095]);
    temp=mean(AvgTotal(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration),3);
    imagesc(temp, [-3e-4 3e-4]);
    axis image off
    title('Avg Total')
    save(['D:\ProcessedData\181031\181031-GCampM2-stim',num2str(run), '-Affine_GSR_NewDetrend'], 'AvgOxy', 'AvgDeOxy', 'AvgTotal','Avggcamp','AvggcampCorr', '-append');
    
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',['181031-GCampM2-stim',num2str(run),' Lindsey Data Visualization'],'FontWeight','bold','Color',[1 0 0]);
    
    output=['D:\ProcessedData\181031\181031-GCampM2-stim',num2str(run), '-processed','_Lindseypres.jpg'];
    orient portrait
    print ('-djpeg', '-r300', output);
    
    figure('visible', 'on');
    close all
    
    %% Check functional connectivty
end
