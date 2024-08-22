
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
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        output = fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
        
        if ~ exist(output,'file')
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
            load(fullfile(saveDir,rawName),'combinedRaw')
            disp(strcat('QC raw for ',rawName))
            
            QCcheck_raw(combinedRaw(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
        end
        disp('loading processed data')
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','sessionInfo')
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','sessionInfo')
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
                isBandPass = false;
                for  k=1:length(C)
                    if strcmp(C(k),'xform_green_GSR')
                        isBandPass = true;
                    end
                end
                if isBandPass
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
                    
                    
                    xform_datahb_GSR = mouse.process.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_gcamp_GSR = mouse.process.gsr(xform_gcamp_bandpass,xform_isbrain);
                    xform_gcampCorr_GSR = mouse.process.gsr(xform_gcampCorr_bandpass,xform_isbrain);
                    xform_green_GSR = mouse.process.gsr(xform_green_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','-append');
                end
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                C = who('-file',fullfile(saveDir,processedName));
                isBandPass = false;
                for  k=1:length(C)
                    
                    if strcmp(C(k),'xform_red_bandpass')
                        isBandPass = true;
                    end
                end
                if isBandPass
                    %                     load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_bandpass','xform_jrgeco1a_bandpass','xform_jrgeco1aCorr_bandpass','xform_red_bandpass');
                    
                    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR');
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
                    xform_red = double(mouse.expSpecific.procFluor(xform_raw(:,:,3,:)));
                    if ~isempty(find(isnan(xform_red), 1))
                        xform_red(isnan(xform_red))=0;
                    end
                    
                    load(strcat(saveDir,'\',recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat'),'xform_jrgeco1a','xform_jrgeco1aCorr')
                    if ~isempty(find(isnan(xform_jrgeco1a), 1))
                        xform_jrgeco1a(isnan(xform_jrgeco1a))=0;
                    end
                    if ~isempty(find(isnan(xform_jrgeco1aCorr), 1))
                        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr))=0;
                    end
                    
                    xform_jrgeco1a_bandpass =highpass(double(xform_jrgeco1a),info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =highpass(double(xform_jrgeco1aCorr),info.bandtype{2},sessionInfo.framerate);
                    xform_red_bandpass =highpass(xform_red,info.bandtype{2},sessionInfo.framerate);
                    xform_jrgeco1a_bandpass =lowpass(double(xform_jrgeco1a_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_jrgeco1aCorr_bandpass =lowpass(double(xform_jrgeco1aCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
                    xform_red_bandpass =lowpass(xform_red_bandpass,info.bandtype{3},sessionInfo.framerate);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_bandpass','xform_jrgeco1a_bandpass','xform_jrgeco1aCorr_bandpass','xform_red_bandpass','-append');
                    %
                    
                    xform_datahb_GSR = mouse.process.gsr(xform_datahb_bandpass,xform_isbrain);
                    xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a_bandpass,xform_isbrain);
                    xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr_bandpass,xform_isbrain);
                    xform_red_GSR = mouse.process.gsr(xform_red_bandpass,xform_isbrain);
                    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append');
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
            
            
            
            oxy_GSR = double(squeeze(xform_datahb_GSR(:,:,1,:)));
            deoxy_GSR = double(squeeze(xform_datahb_GSR(:,:,2,:)));
            total_GSR = double(oxy_GSR+deoxy_GSR);
            
            clear xform_datahb_bandpass xform_datahb_GSR
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = double(squeeze(xform_gcamp_GSR(:,:,1,:)));
                gcampCorr = double(squeeze(xform_gcampCorr_GSR(:,:,1,:)));
                green = double(squeeze(xform_green_GSR(:,:,1,:)));
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a_GSR = double(squeeze(xform_jrgeco1a_GSR(:,:,1,:)));
                jrgeco1aCorr_GSR = double(squeeze(xform_jrgeco1aCorr_GSR(:,:,1,:)));
                red_GSR = double(squeeze(xform_red_GSR(:,:,1,:)));
                
                clear xform_jrgeco1a_bandpass xform_jrgeco1aCorr_bandpass xform_jrgeco1a_GSR xform_jrgeco1aCorr_GSR
            end
            
            
            xform_isbrain = double(xform_isbrain);
            
            oxy_GSR = oxy_GSR.*xform_isbrain;
            deoxy_GSR = deoxy_GSR.*xform_isbrain;
            total_GSR = total_GSR .*xform_isbrain;
            
            oxy_GSR(isnan(oxy_GSR)) = 0;
            deoxy_GSR(isnan(deoxy_GSR)) = 0;
            total_GSR(isnan(total_GSR)) = 0;
            
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = gcamp.*xform_isbrain;
                gcampCorr = gcampCorr.*xform_isbrain;
                green = green.*xform_isbrain;
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a_GSR = jrgeco1a_GSR.*xform_isbrain;
                jrgeco1aCorr_GSR = jrgeco1aCorr_GSR.*xform_isbrain;
                red_GSR = red_GSR.*xform_isbrain;
            end
            
            R=mod(size(oxy_GSR,3),sessionInfo.stimblocksize);
            if R~=0
                pad=sessionInfo.stimblocksize-R;
                disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                oxy_GSR(:,:,end:end+pad)=0;
                deoxy_GSR(:,:,end:end+pad)=0;
                total_GSR(:,:,end:end+pad)=0;
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    gcamp_GSR(:,:,end:end+pad)=0;
                    gcampCorr_GSR(:,:,end:end+pad)=0;
                    green_GSR(:,:,end:end+pad)=0;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    jrgeco1a_GSR(:,:,end:end+pad)=0;
                    jrgeco1aCorr_GSR(:,:,end:end+pad)=0;
                    red_GSR(:,:,end:end+pad)=0;
                end
                
            end
            % Block Average
            texttitle_GSR = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(n)," ",'with GSR');
            output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n)),'_GSR');
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
                close all
                
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
                load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
                
                fluor.traceImagePlot_rgeco(oxy_GSR,deoxy_GSR,total_GSR,jrgeco1a_GSR,jrgeco1aCorr_GSR,red_GSR,info,sessionInfo,output_GSR,texttitle_GSR,xform_isbrain)
                fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
                close all
            end
        end
    end
end