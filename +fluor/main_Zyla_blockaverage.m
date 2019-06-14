
close all;clearvars;clc

excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;
% 
excelRows = [83];

runs = 1;

% Process raw data to get xform_datahb and xform_fluor(if needed)


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);

    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end

    sessionInfo.mouseType = excelRaw{13};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.totalFrameNum = excelRaw{18};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;


    if strcmp(char(sessionInfo.mouseType),'WT')
        sessionInfo.hbSpecies = 1:2;
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        sessionInfo.hbSpecies = 2:3;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
        sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        sessionInfo.hbSpecies = 2:3;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorExcitationFile = "jrgeco1a_excitation.txt";%% need
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
    end

    systemInfo.numLEDs = 4;
    systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_TL625_Pol.txt"];

    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;



    wlName = strcat(recDate,'-',mouseName,'-WLandTransform','.mat');
    load(fullfile(saveDir,wlName),'mytform');


    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName),'I')


    pkgDir = what('bauerParams');
    
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    sessionInfo.fluorEmissionFile = fullfile(fluorDir,sessionInfo.fluorEmissionFile);
    
    ledDir = fullfile(pkgDir.path,'ledSpectra');
    for ind = 1:numel(systemInfo.LEDFiles)
        systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
        
    end

    for n = runs 

        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_blockaverage','.mat');

        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            rawName_blockaverage = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_blockaverage.mat');
               load(fullfile(saveDir,rawName),'xform_raw')
             xform_raw5 = reshape(xform_raw,128,128,3,500,10);
             xform_raw_blockaverage = mean(xform_raw5(:,:,:,:,2:10),5);
            if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
                sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
            end
  
            disp('get hemoglobin data');
   
            maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
            load(fullfile(saveDir,maskName), 'xform_isbrain','I')

            xform_isbrain(isnan(xform_isbrain)) = 0;
            xform_isbrain = logical(xform_isbrain);


            [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(3:4));
            BaselineFunction  = @(x) mean(x,numel(size(x)));
            baselineValues = BaselineFunction(xform_raw_blockaverage);
            xform_datahb_blockaverage = mouse.process.procOIS(xform_raw_blockaverage(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E,xform_isbrain);

            save(fullfile(saveDir,processedName),'xform_raw_blockaverage','xform_datahb_blockaverage','sessionInfo','systemInfo','-v7.3')



        if ~strcmp(char(sessionInfo.mouseType),'WT')

            xform_fluor = xform_raw_blockaverage(:,:,sessionInfo.fluorSpecies,:);
            xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
            [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(fullfile(pkgDir.path,sessionInfo.extCoeffFile));

            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                C = who('-file',fullfile(saveDir,processedName));
                isFluorGot = false;
                for  k=1:length(C)
                    if strcmp(C(k),'xform_gcamp')
                        isFluorGot = true;
                    end
                end
                if ~isFluorGot
                    disp('correct gcamp')



                    [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
                    [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);


                    dpIn = op_in.dpf/2;
                    dpOut = op_out.dpf/2;

                    %             dpIn = 0.056;
                    %             dpOut = 0.057;
                    xform_gcamp= xform_fluor ;
                    xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
                        [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);

                    save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','-append')
                else
                    disp(strcat('gcamp data already processed for ',processedName))
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                C = who('-file',fullfile(saveDir,processedName));
                isFluorGot = false;
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_jrgeco1a_blockaverage')
%                         isFluorGot = true;
%                     end
%                 end
                if ~isFluorGot
                    disp('correct jrgeco1a')




                    [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(2));
                    [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);


                    dpIn = op_in.dpf/2;
                    dpOut = op_out.dpf/2;

                    %             dpIn = 0.056;
                    %             dpOut = 0.057;
                    xform_jrgeco1a_blockaverage = xform_fluor ;
                    xform_jrgeco1aCorr_blockaverage = mouse.physics.correctHb(xform_jrgeco1a_blockaverage,xform_datahb_blockaverage,...
                        [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);

                    save(fullfile(saveDir,processedName),'xform_jrgeco1a_blockaverage','xform_jrgeco1aCorr_blockaverage','-append')
                else
                    disp(strcat('jrgeco1a data already processed for ',processedName))
                end


            end

        end
    end

end


% QC

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    
    for n = runs 
      

        disp('loading processed data')
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_blockaverage','.mat');
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','sessionInfo')
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            load(fullfile(saveDir, processedName),'xform_datahb_blockaverage','xform_jrgeco1a_blockaverage','xform_jrgeco1aCorr_blockaverage','sessionInfo')
        end
        
        if strcmp(sessionType,'fc')
            oxy = double(squeeze(xform_datahb(:,:,1,:)));
            disp(char(['QC check on ', processedName]))
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcampCorr = double(squeeze(xform_gcampCorr));
                QCcheck_fc(oxy,gcampCorr,'gcamp',xform_isbrain, sessionInfo,saveDir,visName);
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                
                jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr));
                QCcheck_fc(oxy,jrgeco1aCorr,'jrgeco1a',xform_isbrain, sessionInfo,saveDir,visName);
            end
        elseif strcmp(sessionType,'stim')
            
            sessionInfo.stimblocksize = excelRaw{8};
            sessionInfo.stimbaseline=excelRaw{9};
            sessionInfo.stimduration = excelRaw{10};
            sessionInfo.stimFrequency = excelRaw{12};
            info.newFreq = 8;
            info.freqout=1;
            info.bandtype = {"0.01Hz-8Hz",0.01,8};
            
            
            
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
            
            
            
            
            
            
            %xform_datahb_bandpass=lowpass(xform_datahb_bandpass ,info.bandtype{3},info.newFreq);
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                C = who('-file',fullfile(saveDir,processedName));
                isGsr = false;
                for  k=1:length(C)
                    if strcmp(C(k),'xform_green_GSR')
                        isGsr = true;
                    end
                end
                if isGsr
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR');
                else
                    xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                    xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                    rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                    
                    disp('loading raw data');
                    if strcmp(systemType,'EastOIS2')
                        
                        load(fullfile(saveDir,rawName),'xform_raw')
                    elseif strcmp(systemType,'EastOIS1_Fluor')
                        load(fullfile(saveDir,rawName),'xform_raw');
                    end
                    xform_raw = double(mouse.expSpecific.procFluor(xform_raw));
                    if ~isempty(find(isnan(xform_raw), 1))
                        xform_raw(isnan(xform_raw))=0;
                    end
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_gcamp','xform_gcampCorr')
                    if ~isempty(find(isnan(xform_gcamp), 1))
                        xform_gcamp(isnan(xform_gcamp))=0;
                    end
                    if ~isempty(find(isnan(xform_gcampCorr), 1))
                        xform_gcampCorr(isnan(xform_gcampCorr))=0;
                    end
                    
                    
                    
                    
                    xform_gcamp_bandpass =highpass(double(xform_gcamp),info.bandtype{2},sessionInfo.framerate);
                    xform_gcampCorr_bandpass =highpass(double(xform_gcampCorr),info.bandtype{2},sessionInfo.framerate);
                    xform_green_bandpass =highpass(xform_raw(:,:,2,:),info.bandtype{2},sessionInfo.framerate);
                    
                    xform_gcamp_bandpass =lowpass(double(xform_gcamp_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_gcampCorr_bandpass =lowpass(double(xform_gcampCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_green_bandpass =lowpass(xform_green_bandpass,info.bandtype{3},sessionInfo.framerate);
                    %
                    
                    
                    
                    
                    xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_gcamp_GSR = mouse.preprocess.gsr(xform_gcamp_bandpass,xform_isbrain);
                    xform_gcampCorr_GSR = mouse.preprocess.gsr(xform_gcampCorr_bandpass,xform_isbrain);
                    xform_green_GSR = mouse.preprocess.gsr(xform_green_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','-append');
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                C = who('-file',fullfile(saveDir,processedName));
                isGsr = false;
                for  k=1:length(C)
                    if strcmp(C(k),'xform_red_GSR')
                        isGsr = true;
                    end
                end
                if isGsr
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed_blockaverage.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR');
                else
                    xform_datahb_bandpass =highpass(xform_datahb_blockaverage,info.bandtype{2},sessionInfo.framerate);
                    xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
                    rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_blockaverage.mat');
                    
                    disp('loading raw data');
                    if strcmp(systemType,'EastOIS2')
                        
                        load(fullfile(saveDir,rawName),'xform_raw_blockaverage')
                    elseif strcmp(systemType,'EastOIS1_Fluor')
                        load(fullfile(saveDir,rawName),'xform_raw');
                    end
                    xform_red_blockaverage = double(mouse.expSpecific.procFluor(xform_raw_blockaverage(:,:,3,:)));
                    if ~isempty(find(isnan(xform_red_blockaverage), 1))
                        xform_red_blockaverage(isnan(xform_red_blockaverage))=0;
                    end
                    
                    load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat'),'xform_jrgeco1a','xform_jrgeco1aCorr')
                    if ~isempty(find(isnan(xform_jrgeco1a_blockaverage), 1))
                        xform_jrgeco1a_blockaverage(isnan(xform_jrgeco1a_blockaverage))=0;
                    end
                    if ~isempty(find(isnan(xform_jrgeco1aCorr_blockaverage), 1))
                        xform_jrgeco1aCorr_blockaverage(isnan(xform_jrgeco1aCorr_blockaverage))=0;
                    end
                    
                    xform_jrgeco1a_bandpass =highpass(double(xform_jrgeco1a_blockaverage),info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =highpass(double(xform_jrgeco1aCorr_blockaverage),info.bandtype{2},sessionInfo.framerate);
                    xform_red_bandpass =highpass(xform_red_blockaverage,info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1a_bandpass =lowpass(double(xform_jrgeco1a_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =lowpass(double(xform_jrgeco1aCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_red_bandpass =lowpass(xform_red_bandpass,info.bandtype{3},sessionInfo.framerate);
                    
                    %
                    
                    xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_jrgeco1a_GSR = mouse.preprocess.gsr(xform_jrgeco1a_bandpass,xform_isbrain);
                    xform_jrgeco1aCorr_GSR = mouse.preprocess.gsr(xform_jrgeco1aCorr_bandpass,xform_isbrain);
                    xform_red_GSR = mouse.preprocess.gsr(xform_red_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed_blockaverage.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append');
                end
            end
            %
            %
            % if ~isempty(find(isnan(xform_datahb_bandpass_GSR), 1))
            %     xform_datahb_bandpass_GSR(isnan(xform_datahb_bandpass_GSR))=0;
            %     disp(strcat(tiffFileName,'xform_datahb_bandpass_GSR has NAN'));
            % end
            %
            %
            %
            
            oxy = double(squeeze(xform_datahb_GSR(:,:,1,:)));
            deoxy = double(squeeze(xform_datahb_GSR(:,:,2,:)));
            total = double(oxy+deoxy);
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = double(squeeze(xform_gcamp_GSR(:,:,1,:)));
                gcampCorr = double(squeeze(xform_gcampCorr_GSR(:,:,1,:)));
                green = double(squeeze(xform_green_GSR(:,:,1,:)));
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a = double(squeeze(xform_jrgeco1a_GSR(:,:,1,:)));
                jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr_GSR(:,:,1,:)));
                red = double(squeeze(xform_red_GSR(:,:,1,:)));
            end
            
            
            xform_isbrain = double(xform_isbrain);
            
            oxy = oxy.*xform_isbrain;
            deoxy = deoxy.*xform_isbrain;
            total = total .*xform_isbrain;
            
            oxy(isnan(oxy)) = 0;
            deoxy(isnan(deoxy)) = 0;
            total(isnan(total)) = 0;
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = gcamp.*xform_isbrain;
                gcampCorr = gcampCorr.*xform_isbrain;
                green = green.*xform_isbrain;
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a = jrgeco1a.*xform_isbrain;
                jrgeco1aCorr = jrgeco1aCorr.*xform_isbrain;
                red = red.*xform_isbrain;
            end
            
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            R=mod(size(oxy,3),sessionInfo.stimblocksize);
            if R~=0
                pad=sessionInfo.stimblocksize-R;
                disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                oxy(:,:,end:end+pad)=0;
                deoxy(:,:,end:end+pad)=0;
                total(:,:,end:end+pad)=0;
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp(:,:,end:end+pad)=0;
                    gcampCorr(:,:,end:end+pad)=0;
                    green(:,:,end:end+pad)=0;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a(:,:,end:end+pad)=0;
                    jrgeco1aCorr(:,:,end:end+pad)=0;
                    red(:,:,end:end+pad)=0;
                end
                
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
            
            total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(total,4)
                MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(total, 3);
                    total(:,:,t,b)=squeeze(total(:,:,t,b))-MeanFrame;
                end
            end
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp=reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(gcamp,4)
                    MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(gcamp, 3);
                        gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                    end
                end
                
                gcampCorr=reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(gcampCorr,4)
                    MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(gcampCorr, 3);
                        gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
                    end
                end
                
                
                green=reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(green,4)
                    MeanFrame=squeeze(mean(green(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(green, 3);
                        green(:,:,t,b)=squeeze(green(:,:,t,b))-MeanFrame;
                    end
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a=reshape(jrgeco1a,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1a,4)
                    MeanFrame=squeeze(mean(jrgeco1a(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1a, 3);
                        jrgeco1a(:,:,t,b)=squeeze(jrgeco1a(:,:,t,b))-MeanFrame;
                    end
                end
                jrgeco1aCorr=reshape(jrgeco1aCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(jrgeco1aCorr,4)
                    MeanFrame=squeeze(mean(jrgeco1aCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(jrgeco1aCorr, 3);
                        jrgeco1aCorr(:,:,t,b)=squeeze(jrgeco1aCorr(:,:,t,b))-MeanFrame;
                    end
                end
                red=reshape(red,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(red,4)
                    MeanFrame=squeeze(mean(red(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(red, 3);
                        red(:,:,t,b)=squeeze(red(:,:,t,b))-MeanFrame;
                    end
                end
                
            end
            
            
            
            %                 oxy = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
            %                 deoxy = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
            %                 total = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
            %
            %                 oxy = permute(oxy,[1 2 4 3]);
            %                 deoxy = permute(deoxy,[1 2 4 3]);
            %                 total = permute(total,[1 2 4 3]);
            %
            %                 info.stimblocksize = size(oxy,3);
            %                 info.stimbaseline = round(sessionInfo.stimbaseline/sessionInfo.stimblocksize*info.stimblocksize);
            
            
            
            % Block Average
            texttitle = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(n),'blockaveraged first');
            output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_blockaverage'));
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                
                fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
                
                close all
                
                %save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info')
                %strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat')
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
                load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
                fluor.traceImagePlot_rgeco_blockaverage(oxy,deoxy,total,jrgeco1a,jrgeco1aCorr,red,info,sessionInfo,output,texttitle,xform_isbrain)
                close all
            end
        end
    end
end







