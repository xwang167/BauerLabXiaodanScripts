% This function will generate power analysis plots for user specified data.
% A pwelch test is used to generate the power spectra.
%
% Inputs:
%   excelFile: character array containing the location of the excel file to
%   be read
%   rows: the specific rows in the excel file that should be processed
%   fRange: bands over which to compute the power maps (specified by the
%   user via a input menu)

%% acquire user inputs

% parse the runs listed in excel file
excelFile = 'Y:\CTREM\WT.xlsx';
excelRows = 2:15;
runsInfo = parseRuns(excelFile,excelRows);
%% preprocess

% read in data
paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
meanMask = stdMask.leftMask | stdMask.rightMask;

runInd = 0;
runNum = numel(runsInfo);
disp([num2str(runNum) ' run(s) detected.']);
currentExcelRow = runsInfo(1).excelRow;

freqMouse = {};
spectraMouse = {};
meanSpectraMouse = {};
freqAllMice = {};
spectraAllMice = {};
meanSpectraAllMice = {};
runInfoAllMice = {};

%% process each run
for runInfo = runsInfo
    runInd = runInd + 1;
    disp(['----- Trial ' num2str(runInd) '/' num2str(runNum) ' -----']);
    
    % initialize variable names for save files
    currentTrialName = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session,...
        num2str(runInfo.run)];
    mouseRunInfo = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session];
    savePowerInfo = [runInfo.saveFolder, '\PowerAnalysisNew\'];
    if ~exist(savePowerInfo, 'dir')
        mkdir(savePowerInfo)
    end
    
    % check to see if data already exists
    if exist(fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-Power.mat']), 'file')
        disp('Loading saved power analysis data...');
        load(fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-Power.mat']),'powerMap');
    else
        disp(strcat('Running Power Analysis for ',runInfo.mouseName,' run ' ,num2str(runInfo.run))) %anmol- changed the order of display, so I wouldn't get redundant messages
        
        %Loading
        try
            load(runInfo.saveHbFile,'xform_datahb')
            load(runInfo.saveMaskFile,'xform_isbrain')
        catch
            warning(strcat(runInfo.mouseName, '-',runInfo.run, ' Not processed.'))
            continue
        end
        
        if ~isempty(runInfo.fluorChInd)
            load(runInfo.saveFluorFile,'xform_datafluorCorr');
        end
        if ~isempty(runInfo.FADChInd)
            load(runInfo.saveFADFile,'xform_dataFADCorr');
        end
        
        %Initializing
        
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
        if ~isempty(runInfo.fluorChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
        end
        if ~isempty(runInfo.FADChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),5);
        end
        
        %Shape Data
        data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:))*10^6;
        data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:))*10^6;
        data_full(:,:,:,3)=(squeeze(xform_datahb(:,:,1,:))+squeeze(xform_datahb(:,:,2,:)))*10^6;
        if ~isempty(runInfo.fluorChInd)
            data_full(:,:,:,4) = xform_datafluorCorr*100;
        end
        if ~isempty(runInfo.FADChInd)
            data_full(:,:,:,5) = xform_dataFADCorr*100;
        end
        %Power Break
        for ii=1:size(data_full,4)
            [whole_spectra_map(:,:,:,ii),avg_cort_spec,powerMap(:,:,:,ii),hz, global_sig_for(:,ii),glob_sig_power(:,ii)]= ...
                PowerAnalysis(squeeze(data_full(:,:,:,ii)),runInfo.samplingRate,xform_isbrain.*meanMask,...
                {[0.009,0.08],[0.4,4],[0 10]},0);
        end
        % save figures/data
        save(fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-Power.mat']),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','-v7.3')
        
        % ISA PowerMap figure
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        for jj = 1:length(runInfo.Contrasts)
            subplot(1,length(runInfo.Contrasts),jj)
            if jj <4
                powerLim = [-12.5 -10.5];
            else
                powerLim = [-5.5 -3.5];
            end
            imagesc(log10(powerMap(:,:,2,jj)),powerLim)
            cb = colorbar();
            axis(gca,'square');
            set(gca,'Visible','off');
            colormap jet;
            titleObj = title(runInfo.Contrasts(jj),'FontSize',13);
            set(titleObj,'Visible','on');
            % different label for gcamp6
            if jj >3
                ylabelObj = ylabel(cb,'log_1_0 ((\DeltaF/F%)^2)','FontSize',13);
            else
                ylabelObj = ylabel(cb,'log_1_0 (\muM^2)','FontSize',13);
            end
            set(ylabelObj,'Visible','on');
        end
        colormap jet
        suptitle([runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),' 0.009-0.08 Power Map'])
        saveas(gcf,fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-powerMap-0p009-0p08.fig']));
        saveas(gcf,fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-powerMap-0p009-0p08.png']));
        
        
        % Delta PowerMap figure
        figure('Renderer', 'painters', 'Position', [100 100 1420 370])
        for jj = 1:length(runInfo.Contrasts)
            subplot(1,length(runInfo.Contrasts),jj)
            if jj <4
                powerLim = [-13.5 -11.5];
            else
                powerLim = [-7 -5];
            end
            imagesc(log10(powerMap(:,:,3,jj)),powerLim)
            cb = colorbar();
            axis(gca,'square');
            set(gca,'Visible','off');
            colormap jet;
            titleObj = title(runInfo.Contrasts(jj),'FontSize',13);
            set(titleObj,'Visible','on');
            % different label for gcamp6
            if jj >3
                ylabelObj = ylabel(cb,'log10 ((\DeltaF/F)^2)','FontSize',13);
            else
                ylabelObj = ylabel(cb,'log10 (M^2)','FontSize',13);
            end
            set(ylabelObj,'Visible','on');
        end
        colormap jet
        suptitle([runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),' 0.4-4 Power Map'])
        saveas(gcf,fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-powerMap-0p4-4.fig']));
        saveas(gcf,fullfile(savePowerInfo,[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run),'-powerMap-0p4-4.png']));

        
    end
end    
    %% Average all of the runs for each mouse
    
    % as long as we're in the same excel row and we haven't reached the end
    % of the runs, store the freq and spectra into respective matrices
    if runInd == numel(runsInfo)
        lastRunInMouse = true;
    elseif currentExcelRow ~= runsInfo(runInd+1).excelRow
        lastRunInMouse = true;
    else
        lastRunInMouse = false;
    end
    
    if lastRunInMouse
        % add last data to mouse vectors
        freqMouse = [freqMouse; runFreq];
        spectraMouse = [spectraMouse; runSpectra];
        meanSpectraMouse = [meanSpectraMouse; runMeanSpectra];
        
        disp(['----- Average computations for ' mouseRunInfo ' -----']);
        spectraMouseAvg = {};
        meanSpectraMouseAvg = {};
        storeSpectraLogSum = 0;
        storeMeanSpectraLogSum = 0;
        [numRuns, numSpecies] = size(freqMouse);
        
        %sum and average the spectra for each of the species
        tic; % how long it takes to compute and plot avg power
        disp('Computing and plotting average power...');
        for ind=1:numSpecies
            for ind2=1:numRuns
                % take log before summing and computing avg
                storeSpectraLogSum = storeSpectraLogSum + log(spectraMouse{ind2, ind});
                % also average meanSpectraMouse
                storeMeanSpectraLogSum = storeMeanSpectraLogSum +...
                    log(meanSpectraMouse{ind2, ind});
            end
            spectraLogAvg = storeSpectraLogSum/numRuns;
            meanSpectraLogAvg = storeMeanSpectraLogSum/numRuns;
            % convert back from log
            spectraMouseAvg = [spectraMouseAvg exp(spectraLogAvg)];
            meanSpectraMouseAvg = [meanSpectraMouseAvg exp(meanSpectraLogAvg)];
            storeSpectraLogSum = 0;
            storeMeanSpectraLogSum = 0;
        end
        
        % plot mouse average figures
        currentTrialName = [mouseRunInfo '-avg'];
        freqMouseAvg = freqMouse(1,:);
        [mouseAvgSpectraFig, mouseAvgMapFigure] = plotPower(fRange,freqMouseAvg,...
            spectraMouseAvg,meanSpectraMouseAvg,meanMask,speciesList,currentTrialName);
        toc % how long it takes to compute and plot avg power
        
        % save figures/data
        tic; % how long it takes to save average plots/data
        disp('Saving average power plots and data...');
        saveAvgSpectraFig = [savePowerInfo '\' mouseRunInfo '-powerSpectraAVG'];
        saveas(mouseAvgSpectraFig, [saveAvgSpectraFig '.png']);
        close(mouseAvgSpectraFig);
        
        for saveInd = 1:numel(mouseAvgMapFigure)
            saveAvgMapFigure = [savePowerInfo '\' mouseRunInfo '-powerMapAVG-' fStr{saveInd}];
            saveas(mouseAvgMapFigure(saveInd), [saveAvgMapFigure '.png']);
            close(mouseAvgMapFigure(saveInd));
        end
        
        freqAllMice = [freqAllMice; freqMouseAvg];
        spectraAllMice = [spectraAllMice; spectraMouseAvg];
        meanSpectraAllMice = [meanSpectraAllMice; meanSpectraMouseAvg];
        runInfoAllMice = [runInfoAllMice; mouseRunInfo];
        
        % clear variables before next run
        freqMouse = {};
        spectraMouse = {};
        meanSpectraMouse = {};
        
        if runInd ~= numel(runsInfo)
            currentExcelRow = runsInfo(runInd+1).excelRow;
        end
        toc % how long it takes to save average plots/data
        
    else
        freqMouse = [freqMouse; runFreq];
        spectraMouse = [spectraMouse; runSpectra];
        meanSpectraMouse = [meanSpectraMouse; runMeanSpectra];
    end
%end

%% Average across mice

% compute and plot averages across mice if more than one mouse is present
[numMice, numSpecies] = size(spectraAllMice);

if numMice > 1
    storeSpectraLogSum = 0;
    storeMeanSpectraLogSum = 0;
    spectraAllMiceAvg = {};
    meanSpectraAllMiceAvg = {};
    
    disp(['----- Average computations across ' num2str(numMice) ' unique mice -----']);
    tic; % how long it takes to compute and plot avg power across mice
    disp('Computing and plotting average power...');
    for ind=1:numSpecies
        for ind2=1:numMice
            % take log before summing and computing avg
            storeSpectraLogSum = storeSpectraLogSum + log(spectraAllMice{ind2, ind});
            storeMeanSpectraLogSum = storeMeanSpectraLogSum + log(meanSpectraAllMice{ind2, ind});
        end
        spectraLogAvg = storeSpectraLogSum/numMice;
        meanSpectraLogAvg = storeMeanSpectraLogSum/numMice;
        % convert back from log
        spectraAllMiceAvg = [spectraAllMiceAvg exp(spectraLogAvg)];
        meanSpectraAllMiceAvg = [meanSpectraAllMiceAvg exp(meanSpectraLogAvg)];
        storeSpectraLogSum = 0;
        storeMeanSpectraLogSum = 0;
    end
    
    % plot mouse average figures
    [~,excelName] = fileparts(excelFile);
    currentTrialName = [excelName '-rows' num2str(min(rows)) '~' num2str(max(rows))];
    freqAllMouseAvg = freqAllMice(1,:);
    [mouseAvgSpectraFig, mouseAvgMapFigure] = plotPower(fRange,freqAllMouseAvg,...
        spectraAllMiceAvg,meanSpectraAllMiceAvg,meanMask,speciesList,currentTrialName);
    toc % how long it takes to compute and plot avg power
    
    % save figures/data
    tic; % how long it takes to save average plots/data
    disp('Saving average power figures...');
    
    saveAcrossMousePowerInfo = [savePowerInfo '\AvgAcrossMice'];
    if ~exist(saveAcrossMousePowerInfo, 'dir')
        mkdir(saveAcrossMousePowerInfo)
    end
    
    saveAvgSpectraFig = [saveAcrossMousePowerInfo '\' currentTrialName '-powerSpectraAVG'];
    savefig(mouseAvgSpectraFig, saveAvgSpectraFig);
    saveas(mouseAvgSpectraFig, [saveAvgSpectraFig '.png']);
    close(mouseAvgSpectraFig);
    
    for saveInd = 1:numel(mouseAvgMapFigure)
        saveAvgMapFigure = [saveAcrossMousePowerInfo '\' currentTrialName '-powerMapAVG-'...
            fStr{saveInd}];
        savefig(mouseAvgMapFigure(saveInd), saveAvgMapFigure);
        saveas(mouseAvgMapFigure(saveInd), [saveAvgMapFigure '.png']);
        close(mouseAvgMapFigure(saveInd));
    end
    
    toc % how long it takes to save average plots/data
end

