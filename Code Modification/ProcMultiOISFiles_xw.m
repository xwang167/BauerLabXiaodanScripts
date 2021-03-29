function ProcMultiOISFiles_xw(excelFile,excelRow,Date, Mouse, suffix, directory,  system)

% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:

%%%% Not just readtiff


%% Process Resting State Data
rawdatatype='.tif';
filename = [Date,'-',Mouse,'-',suffix];
runsInfo = parseTiff(excelFile,excelRow);
n=1; %code assumes the first run is labeled as "1"
for runInfo = runsInfo
    if exist([directory, filename, num2str(n),'-datahb.mat'],'file') %checks to see if the raw data were already processed
        disp([filename,num2str(n),' Already processed'])
        n=n+1;
    else
        disp(['Processing ', filename,num2str(n), ' on ', system])
                
        sessionInfo = sysInfo(system);
        raw = readtiff(fileName);
        
      
        % remove dark  frames
        if ~isempty(sessionInfo.darkFrameNum) && sessionInfo.darkFrameNum~=0
            darkFrameInd = 2:sessionInfo.darkFrameNum/size(raw,3);
            darkFrame = squeeze(mean(raw(:,:,:,darkFrameInd),4));
            raw_baselineMinus = raw - repmat(darkFrame,1,1,1,size(raw,4));
            clear raw
            raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
            raw = raw_baselineMinus;
            clear raw_baselineMinus
        end
        %end remove
       
              
        %QC and dropped frames and save data
        disp('rawQC analysis...');
        %%%%%make it a function
        if ~isempty(runInfo.fluorChInd)
            representativeCh = runInfo.fluorChInd;
        else
            representativeCh = runInfo.hbChInd(1);
        end
        droppedFrames = []; % assume no dropped frames by default
        qcRawFig = qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,system);%%%%%save specific data to both hb and fluor data%%%color of lines 
        savefig(qcRawFig,runInfo.saveRawQCFig);
        saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
        close(qcRawFig);
        
     
        % perform check for dropped frames
        tic;
        disp('checking for dropped frames...');
        fixedData = false; % flag to see if data has been fixed yet or not
        [dfIndRaw, dfIndFixed, fixedRaw, fixedRawTime] = fixDroppedFrames(runInfo,raw,rawTime,fixedData);
        toc;
        
        if isempty(dfIndRaw) % if no dropped frames, continue as normal
            disp('No dropped frames detected.');
            clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
        else
            disp(['Detected and corrected for ' num2str(length(dfIndRaw)) ' dropped frames!']);
            raw = fixedRaw;
            rawTime = fixedRawTime;
            droppedFrames = dfIndFixed;
            
            % rerun rawQC after correction
            representativeCh = runInfo.hbChInd(1);
            qcRawFig =qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames);
            newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr'];
            saveas(qcRawFig,[newQCSaveLoc '.png']);
            close(qcRawFig);
            
            % check to make sure all dropped frames have been removed
            fixedData = true;
            [dfIndRaw, ~, ~, ~] = fixDroppedFrames(runInfo,fixedRaw,fixedRawTime,fixedData);%%%%% delete????
            if ~isempty(dfIndRaw)
                currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                    '' num2str(runInfo.run)];
                disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
            end
            clear fixedRaw fixedRawTime;
        end
        
        %%%%function
        % [datahb,op,E] = procOISData_xw(filename, sessionType, sessionInfo,rawdata(OIS));  %% move porcOISData content here
        pkgDir = what('bauerParams');%%%%delete
        
        raw = readtiff(filename);
        
        [op, E] = getHbOpticalPropertie_new(fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));%%%%musp to the function
        
        
        datahb = procOIS_xw(raw(:,:,sessionInfo.hbSpecies,:),op.dpf,E);%% not package%%%%%baselinevalue inside of function
        datahb = smoothImage(datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        
        disp('Saving Data')
        save([directory, filename,num2str(n),'-datahb'],'datahb','sessionInfo','op','E')
        
        datafluor = squeeze(raw(:,:,sessionInfo.fluorSpecies,:));
        datafluor = procFluor(datafluor,baselineValues(:,:,sessionInfo.fluorSpecies));
        [op_in, E_in] = getHbOpticalProperties_new(fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
        [op_out, E_out] = getHbOpticalProperties_new(fullfile(fluorDir,sessionInfo.fluorEmissionFile));
        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
        datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);%%%% gcamp only flag
        datafluorCorr = smoothImage(datafluorCorr,systemInfo.gbox,systemInfo.gsigma);
        datafluor = smoothImage(datafluor,systemInfo.gbox,systemInfo.gsigma);
        save([directory, filename,num2str(n),'-datafluor'],'datafluor','datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','-append')
        %%%depackage
%         %%%% average 
%         fcqc
%         stim
    end
end