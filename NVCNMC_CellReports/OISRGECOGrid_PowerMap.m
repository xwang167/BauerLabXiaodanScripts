excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
load('W:\220210\220210-m.mat')
%% Generate delta power map for each block
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    for run = 1:length(runsInfo)
        runInfo = runsInfo(run);
        totalSubFileNum = length(runInfo.rawFile)/2;
        for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat'),'xform_datafluorCorr')
        calcium = reshape(xform_datafluorCorr,128,128,600,[])*100;
        clear xform_datafluorCorr
        powerMap_Delta = nan(128,128,size(calcium,4));        
        for site = 1:size(calcium,4)
            powerMap_Delta(:,:,site) = QCcheck_CalcPowerMap(double(calcium(:,:,:,site)),runInfo.samplingRate,[0.5 4]);                    
        end
        clear calcium
        save(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-PowerMap.mat'),'powerMap_Delta')
        end
    end
end
%% average across three runs
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    totalSubFileNum = length(runsInfo(1).rawFile)/2;
    for ii = 1:totalSubFileNum
        powerMap_Delta_runs = [];
        for run = 1:length(runsInfo)
            runInfo = runsInfo(run);
            load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-PowerMap.mat'),'powerMap_Delta')
            powerMap_Delta_runs = cat(4,powerMap_Delta_runs,powerMap_Delta);
        end
        powerMap_Delta_runs = nanmedian(powerMap_Delta_runs,4);
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-PowerMap.mat'),'powerMap_Delta_runs','-v7.3')
    end    
end

%% put powerMap_Delta_runs at right order for each mouse
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    powerMap_Delta_runs_ordered = nan(128,128,160);
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-PowerMap.mat'),'powerMap_Delta_runs')
        numBlock = size(powerMap_Delta_runs,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                laser_location = gridLaser_mouse(:,:,m(jj));
                [M,~] = max(laser_location,[],'all','linear');
                if M < 10000 %|| GoodSeedsidx_shared(m(jj)) ==0
                    disp([runInfo.mouseName,'#' num2str(m(jj)) ])
                else
                    powerMap_Delta_runs_ordered(:,:,m(jj)) = powerMap_Delta_runs(:,:,kk);
                    clear AvgMovie_jRGECO1a_NoGSR
                end
                kk = kk+1;
            end
            jj = jj+1;
        end
        
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-PowerMapOrdered.mat'),'powerMap_Delta_runs_ordered','-v7.3')
    clear powerMap_Delta_runs_ordered
end

%% Generate figure of Delta power map with laser loction on
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-PowerMapOrdered.mat'),'powerMap_Delta_runs_ordered')
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
        imagesc(powerMap_Delta_runs_ordered(:,:,kk),[-2 2])
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
            sgtitle(strcat(runInfo.recDate,'-',runInfo.mouseName,' - Calcium NoGSR Delta Power Map - Subfig #',num2str(num)))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR Delta Power Map_',num2str(num),'.png'))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR Delta Power Map_',num2str(num),'.fig'))
        end
    end
end


%% Generate figure of ISA power map with laser loction on
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-PowerMap.mat'),'powerMap_ISA')
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
        load('D:\OIS_Process\noVasculatureMask.mat')
        
        imagesc(logpowerMap_ISA(:,:,kk),[0 0.04])
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
            sgtitle(strcat(runInfo.recDate,'-',runInfo.mouseName,' - Calcium NoGSR ISA Power Map - Subfig #',num2str(num)))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR ISA Power Map_',num2str(num),'.png'))
            saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Calcium NoGSR ISA Power Map_',num2str(num),'.fig'))
        end
    end
end




%% Mice averaged power map for calcium
miceName = [];
powerMap_Calcium_ISA_NoGSR_mice = nan(128,128,160,10);
powerMap_Calcium_Delta_NoGSR_mice = nan(128,128,160,10);
ii = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = [miceName,'-',runInfo.mouseName];
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-PowerMap.mat'),'powerMap_ISA','powerMap_Delta')
    powerMap_Calcium_ISA_NoGSR_mice(:,:,:,ii) = powerMap_ISA;
    powerMap_Calcium_Delta_NoGSR_mice(:,:,:,ii) = powerMap_Delta;
    ii = ii + 1;
end
powerMap_Calcium_ISA_NoGSR_mice = nanmedian(powerMap_Calcium_ISA_NoGSR_mice,4);
powerMap_Calcium_Delta_NoGSR_mice = nanmedian(powerMap_Calcium_Delta_NoGSR_mice,4);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-PowerMap.mat'),'powerMap_Calcium_ISA_NoGSR_mice','powerMap_Calcium_Delta_NoGSR_mice')

%% generate mice averaged ISA power map with laser location for calcium
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'powerMap_Calcium_ISA_NoGSR_mice')
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
    imagesc(powerMap_Calcium_ISA_NoGSR_mice(:,:,kk),[-1 1])
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
        sgtitle(strcat(miceName(2:end),' - Calcium NoGSR ISA Power Map - Subfig #',num2str(num)))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR ISA Power Map_',num2str(num),'.png'))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR ISA Power Map_',num2str(num),'.fig'))
    end
end

%% generate mice averaged Delta power map with laser location for calcium
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-inhibitionMap.mat'),'powerMap_Calcium_Delta_NoGSR_mice')
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
    imagesc(powerMap_Calcium_Delta_NoGSR_mice(:,:,kk),[-1 1])
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
        sgtitle(strcat(miceName(2:end),' - Calcium NoGSR Delta Power Map - Subfig #',num2str(num)))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Delta Power Map_',num2str(num),'.png'))
        saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'_Calcium NoGSR Delta Power Map_',num2str(num),'.fig'))
    end
end