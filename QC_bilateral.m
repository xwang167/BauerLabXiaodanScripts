
fRanges = {[0.009 0.08],[0.4 4]};
fStrs = {'ISA','Delta'};
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 321:327;
runs = 1:9;

%


%% preprocess and process

% get standard mask
paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'stdMask.mat'));

% get seed FC each run
% bilatFCMapCat = {};
% bilatFCMapMouse = {};
% 
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    cFs = excelRaw{7};
    systemType = excelRaw{5};
    sessionInfo.mouseType = excelRaw{17};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb')
        for jj = 1:size(xform_datahb,4)
            xform_isbrain(isinf(xform_datahb(:,:,1,jj))) = 0;
            xform_isbrain(isnan(xform_datahb(:,:,1,jj))) = 0;
            
        end
        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
        load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        
        % saveFileSeedFC = [runInfo.saveFilePrefix,'-bilateralFC-',fStr,'.mat'];
        
        disp(mouseName)
        disp(['#',num2str(n)])
        disp('loading data');
        data = {}; mask = {}; fs = [];
        data{1} = total;
        data{2} = xform_FADCorr;
        data{3} = xform_jrgeco1aCorr;
        mask{1} = xform_isbrain; mask{2} = mask{1}; mask{3} = mask{2};
        contrastName = {'HbT','FADCorr','jRGECO1aCorr'};
        
        
        %%% save each figure
        for contrastInd = 1:numel(data)
            cData = data{contrastInd};
            cMask = mask{contrastInd};
            cName = contrastName{contrastInd};
            
            %%%prepare data
            cData_gsr = mouse.process.gsr(cData,cMask); % gsr
            for ii = 1:2
                fRange = fRanges{ii};
                
                fStr = fStrs{ii};
                cData = mouse.freq.filterData(cData_gsr,fRange(1),fRange(2),cFs);
                
                %%% get bilateral fc
                bilateralFCMap{contrastInd} = mouse.conn.bilateralFC(cData);
                clear cData
                %%% plot
                cMaskMirrored = cMask & fliplr(cMask);
                fh(contrastInd) = mouse.expSpecific.plotFCMap([],[],...
                    bilateralFCMap{contrastInd},cMaskMirrored);
                
                %%% plot title
                titleAxesHandle=axes('position',[0 0 1 0.9]);
                t = title(titleAxesHandle,[cName ' FC, ' fStr 'Hz']);
                set(titleAxesHandle,'visible','off');
                set(t,'visible','on');
                pause(0.1);
                visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
                saveFigSeedFC = fullfile(saveDir,strcat(visName,'-bilateralFC-',fStr,'-',cName));
                saveas(fh(contrastInd),strcat(saveFigSeedFC, '.png'));
                close(fh(contrastInd));
                
                
%%%                save seed fc data
                if ii ==1
                    bilateralFCMap_ISA{contrastInd} = bilateralFCMap{contrastInd};
                elseif ii ==2
                    bilateralFCMap_Delta{contrastInd} = bilateralFCMap{contrastInd};           
                end
            end
            clear cData_gsr
            
        end
                   save(fullfile(saveDir,processedName),'contrastName','bilateralFCMap_ISA','bilateralFCMap_Delta','mask','-append');
         clear bilateralFCMap_ISA bilateralFCMap_Delta
    end
end


saveDir_cat = 'K:\Glucose\cat';
for run = runs;
    excelRows =321:327;
    
    numMice = length(excelRows);
    xform_isbrain_mice = 1;
    sessionInfo.miceType = 'jrgeco1a';
    saveDir_cat = 'K:\Glucose\cat';
    miceName = [];
    bilateralFCMap_ISA_mice = cell(1,3);
    bilateralFCMap_Delta_mice = cell(1,3);
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        miceName = char(strcat(miceName, '-', mouseName));
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        sessionInfo.darkFrameNum = excelRaw{11};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        systemType =excelRaw{5};
        sessionInfo.darkFrameNum = excelRaw{11};
        sessionInfo.framerate = excelRaw{7};
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
        
        
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain(isinf(xform_isbrain)) = 0;
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'_processed.mat');
        
        load(fullfile(saveDir, processedName),'contrastName','bilateralFCMap_ISA','bilateralFCMap_Delta')
        for contrast = 1:3
            bilateralFCMap_ISA{contrast} = atanh(bilateralFCMap_ISA{contrast});
            bilateralFCMap_Delta{contrast} = atanh(bilateralFCMap_Delta{contrast});
            bilateralFCMap_ISA_mice{contrast} = cat(3,bilateralFCMap_ISA_mice{contrast},bilateralFCMap_ISA{contrast});
            bilateralFCMap_Delta_mice{contrast} = cat(3,bilateralFCMap_Delta_mice{contrast},bilateralFCMap_Delta{contrast});
        end
        
    end
    
    visName = strcat(miceName,"-",sessionType,num2str(run));
    for contrast = 1:3
        bilateralFCMap_ISA_mice{contrast} = nanmean(bilateralFCMap_ISA_mice{contrast},3);
        bilateralFCMap_ISA_mice{contrast} = tanh(bilateralFCMap_ISA_mice{contrast});
        bilateralFCMap_ISA_mice{contrast}(isnan(bilateralFCMap_ISA_mice{contrast})) = 0;
        bilateralFCMap_ISA_mice{contrast}(isinf(bilateralFCMap_ISA_mice{contrast})) = 0;
        
        bilateralFCMap_Delta_mice{contrast} = nanmean(bilateralFCMap_Delta_mice{contrast},3);
        bilateralFCMap_Delta_mice{contrast} = tanh(bilateralFCMap_Delta_mice{contrast});
        bilateralFCMap_Delta_mice{contrast}(isnan(bilateralFCMap_Delta_mice{contrast})) = 0;
        bilateralFCMap_Delta_mice{contrast}(isinf(bilateralFCMap_Delta_mice{contrast})) = 0;
        speciesMat_ISA = bilateralFCMap_ISA_mice{contrast};
        speciesMat_Delta = bilateralFCMap_Delta_mice{contrast};
        % get the mask
        cMask = stdMask.isbrain.*xform_isbrain_mice;
        cMask = repmat(cMask,size(speciesMat_ISA,1)/size(cMask,1));
        
        % plot
        cMaskMirrored = cMask & fliplr(cMask);
        f1 = mouse.expSpecific.plotFCMap([],[],...
            speciesMat_ISA,cMaskMirrored);
        
        % plot title
        titleAxesHandle=axes('position',[0 0 1 0.9]);
        t = title(titleAxesHandle,strcat(contrastName{contrast} ,' ISA fc',num2str(run)));
        set(titleAxesHandle,'visible','off');
        set(t,'visible','on');
        pause(0.1);
        
        % save fig
        saveFigName = fullfile(saveDir_cat,strcat(contrastName{contrast}, 'ISA fc',num2str(run)));
        savefig(f1,saveFigName);
        saveas(f1,strcat(saveFigName, '.png'));
        close(f1);
        
        % plot
        
        f2 = mouse.expSpecific.plotFCMap([],[],...
            speciesMat_Delta,cMaskMirrored);
        
        % plot title
        titleAxesHandle=axes('position',[0 0 1 0.9]);
        t = title(titleAxesHandle,strcat(contrastName{contrast} ,' Delta fc',num2str(run)));
        set(titleAxesHandle,'visible','off');
        set(t,'visible','on');
        
        % save fig
        saveFigName2 = fullfile(saveDir_cat,strcat(contrastName{contrast}, 'Delta fc',num2str(run)));
        savefig(f2,saveFigName2);
        saveas(f2,strcat(saveFigName2, '.png'));
        close(f2);
        
    end
    
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
    save(fullfile(saveDir_cat,processedName_mice),'contrastName','bilateralFCMap_Delta_mice','bilateralFCMap_ISA_mice','-append')
end


