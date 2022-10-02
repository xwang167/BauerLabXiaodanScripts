
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
%% convert laser from to coordinate of laser
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    seedLocation_mouse = nan(2,160);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    for ii = 1:160
        temp = gridLaser_mouse(:,:,ii);
        [max_Val,I] = max(temp(:));
        if max_Val>10000
            [row,col] = ind2sub([128 128],I);
            seedLocation_mouse(1,ii) = row;
            seedLocation_mouse(2,ii) = col;
        end
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse')
end


% All for Calcium
%% Create inhibition map for calcium
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-CalciumMovieOrdered.mat'),'AvgMovie_jRGECO1a_NoGSR_ordered')
    inhibitionMap = nan(128,128,160);
    close all
    for kk = 1:160
        
        % inhibition map
        for ii = 1:128
            for jj = 1:128
                inhibitionMap(ii,jj,kk) = median(AvgMovie_jRGECO1a_NoGSR_ordered(ii,jj,101:200,kk))*100;
            end
        end
    end
    
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap')
end

%% Generate figure of inhibition map with laser laoction on
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap')
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse')
    close all
    for kk = 1:160
        
        % figure number
        if mod(kk,40)==0
            ll = 40;
            num = floor(kk/40);
        else
            ll = mod(kk,40);
            num = floor(kk/40)+1;
        end
        
        % Create figure
        f = figure(num);
        subplot(5,8,ll)
        imagesc(inhibitionMap(:,:,kk),[-2 2])
        axis image off
        title(strcat('Position #',num2str(kk)))
        
        % Laser location visualization
        x1 = seedLocation_mouse(2,kk);
        y1 = seedLocation_mouse(1,kk);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        hold on
        contour(ROI,'w')
        
        
        % title and save
        if ll == 40
            p = subplot(5,8,40);
            Pos = get(p,'Position');
            h = colorbar;
            ylabel(h, '\DeltaF/F%')
            set(p,'Position',Pos)
            f.WindowState = 'fullscreen';
            colormap jet
            sgtitle(strcat(runInfo.recDate,'-',runInfo.mouseName,' - Calcium NoGSR Inhibition Map - Subfig #',num2str(num)))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR Inhibition Map_',num2str(num),'.png'))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR Inhibition Map_',num2str(num),'.fig'))
        end
    end
end

%% make seedLocation_mice
miceName = [];
seedLocation_mice = nan(2,160,10);
ii = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = [miceName,'-',runInfo.mouseName];
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse')
    seedLocation_mice(:,:,ii) = seedLocation_mouse;
    ii = ii+1;
end
seedLocation_mice = nanmedian(seedLocation_mice,3);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice','-append')



%% Mice averaged inhibition map for calcium
miceName = [];
inhibitionMap_Calcium_NoGSR_mice = nan(128,128,160,10);
ii = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = [miceName,'-',runInfo.mouseName];
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap')
    inhibitionMap_Calcium_NoGSR_mice(:,:,:,ii) = inhibitionMap;
    ii = ii + 1;
end
inhibitionMap_Calcium_NoGSR_mice = nanmedian(inhibitionMap_Calcium_NoGSR_mice,4);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'inhibitionMap_Calcium_NoGSR_mice')

%% generate mice averaged inhibition map with laser location for calcium
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'inhibitionMap_Calcium_NoGSR_mice')
mycolormap = customcolormap_preset('red-white-blue');
close all
for kk = 1:160
    
    % figure number
    if mod(kk,40)==0
        ll = 40;
        num = floor(kk/40);
    else
        ll = mod(kk,40);
        num = floor(kk/40)+1;
    end
    
    % Create figure
    f = figure(num);
    subplot(5,8,ll)
    imagesc(inhibitionMap_Calcium_NoGSR_mice(:,:,kk),[-1 1])
    axis image off
    title(strcat('Position #',num2str(kk)))
    
    % Laser location visualization
    x1 = seedLocation_mice(2,kk);
    y1 = seedLocation_mice(1,kk);
    [X,Y] = meshgrid(1:128,1:128);
    radius = 3;
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    hold on
    contour(ROI,'g')
    
    
    % title and save
    if ll == 40
        p = subplot(5,8,40);
        Pos = get(p,'Position');
        h = colorbar;
        ylabel(h, '\DeltaF/F%')
        set(p,'Position',Pos)
        f.WindowState = 'fullscreen';
        colormap(mycolormap)
        sgtitle(strcat(miceName(2:end),' - Calcium NoGSR Inhibition Map - Subfig #',num2str(num)))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Inhibition Map_',num2str(num),'.png'))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Inhibition Map_',num2str(num),'.fig'))
    end
end


%% Generate Calcium Inhibition Map that with Incident larger than 5
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_incident.mat'),'incidentVector');
isIncidentHigh = incidentVector>5;
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'inhibitionMap_Calcium_NoGSR_mice')
mycolormap = brewermap(256,'-RdBu');
%CoolerColors= brewermap(256,'-Spectral');

close all
for kk = 1:160
    
    % figure number
    if mod(kk,40)==0
        ll = 40;
        num = floor(kk/40);
    else
        ll = mod(kk,40);
        num = floor(kk/40)+1;
    end
    
    % Create figure
    f = figure(num);
    subplot(5,8,ll)
    
    if isIncidentHigh(kk)
    imagesc(inhibitionMap_Calcium_NoGSR_mice(:,:,kk),[-1 1])
    else
        imagesc(nan(128,128),[-1 1])
    end
    
    axis image off
    title(strcat('Position #',num2str(kk)))
    
    % Laser location visualization
    x1 = seedLocation_mice(2,kk);
    y1 = seedLocation_mice(1,kk);
    [X,Y] = meshgrid(1:128,1:128);
    radius = 3;
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    if isIncidentHigh(kk)
    hold on
    contour(ROI,'g')
    end
    
    
    % title and save
    if ll == 40
        p = subplot(5,8,40);
        Pos = get(p,'Position');
        h = colorbar;
        ylabel(h, '\DeltaF/F%')
        set(p,'Position',Pos)
        f.WindowState = 'fullscreen';
        colormap(mycolormap)
        sgtitle(strcat(miceName(2:end),' - Calcium NoGSR Inhibition Map, Incident larger than 5 - Subfig #',num2str(num)))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Inhibition Map_Incident5_',num2str(num),'.png'))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Inhibition Map_Incident5_',num2str(num),'.fig'))
    end
end



% All for HbT
%% Create inhibition map for HbT
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-HbTMovieOrdered.mat'),'AvgMovie_HbT_NoGSR_ordered')
    inhibitionMap_HbT = nan(128,128,160);
    close all
    for kk = 1:160
        
        % inhibition map
        for ii = 1:128
            for jj = 1:128
                inhibitionMap_HbT(ii,jj,kk) = median(AvgMovie_HbT_NoGSR_ordered(ii,jj,101:200,kk))*10^6;
            end
        end
    end
    
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap_HbT','-append')
end

%% Generate figure of inhibition map with laser lacoction on
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap_HbT')
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse')
    close all
    for kk = 1:160
        
        % figure number
        if mod(kk,40)==0
            ll = 40;
            num = floor(kk/40);
        else
            ll = mod(kk,40);
            num = floor(kk/40)+1;
        end
        
        % Create figure
        f = figure(num);
        subplot(5,8,ll)
        imagesc(inhibitionMap_HbT(:,:,kk),[-2 2])
        axis image off
        title(strcat('Position #',num2str(kk)))
        
        % Laser location visualization
        x1 = seedLocation_mouse(2,kk);
        y1 = seedLocation_mouse(1,kk);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        hold on
        contour(ROI,'w')
        
        
        % title and save
        if ll == 40
            p = subplot(5,8,40);
            Pos = get(p,'Position');
            h = colorbar;
            ylabel(h, '\DeltaF/F%')
            set(p,'Position',Pos)
            f.WindowState = 'fullscreen';
            colormap jet
            sgtitle(strcat(runInfo.recDate,'-',runInfo.mouseName,' - HbT NoGSR Inhibition Map - Subfig #',num2str(num)))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_HbT NoGSR Inhibition Map_',num2str(num),'.png'))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_HbT NoGSR Inhibition Map_',num2str(num),'.fig'))
        end
    end
end

%% Mice averaged inhibition map for HbT
miceName = [];
inhibitionMap_HbT_NoGSR_mice = nan(128,128,160,10);
ii = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = [miceName,'-',runInfo.mouseName];
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-InhibitionMap.mat'),'inhibitionMap_HbT')
    inhibitionMap_HbT_NoGSR_mice(:,:,:,ii) = inhibitionMap_HbT;
    ii = ii + 1;
end
inhibitionMap_HbT_NoGSR_mice = nanmedian(inhibitionMap_HbT_NoGSR_mice,4);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'inhibitionMap_HbT_NoGSR_mice','-append')

%% generate mice averaged inhibition map with laser location for calcium
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'inhibitionMap_HbT_NoGSR_mice')
mycolormap = customcolormap_preset('orange-white-purple');
close all
for kk = 1:160
    
    % figure number
    if mod(kk,40)==0
        ll = 40;
        num = floor(kk/40);
    else
        ll = mod(kk,40);
        num = floor(kk/40)+1;
    end
    
    % Create figure
    f = figure(num);
    subplot(5,8,ll)
    imagesc(inhibitionMap_HbT_NoGSR_mice(:,:,kk),[-1 1])
    axis image off
    title(strcat('Position #',num2str(kk)))
    
    % Laser location visualization
    x1 = seedLocation_mice(2,kk);
    y1 = seedLocation_mice(1,kk);
    [X,Y] = meshgrid(1:128,1:128);
    radius = 3;
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    hold on
    contour(ROI,'g')
    
    
    % title and save
    if ll == 40
        p = subplot(5,8,40);
        Pos = get(p,'Position');
        h = colorbar;
        ylabel(h, '\DeltaF/F%')
        set(p,'Position',Pos)
        f.WindowState = 'fullscreen';
        colormap(mycolormap)
        sgtitle(strcat(miceName(2:end),' - HbT NoGSR Inhibition Map - Subfig #',num2str(num)))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_HbT NoGSR Inhibition Map_',num2str(num),'.png'))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_HbT NoGSR Inhibition Map_',num2str(num),'.fig'))
    end
end

