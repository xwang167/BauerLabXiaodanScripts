
%close all;clearvars;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


nVx = 128;
nVy = 128;
runs = 1:6;
excelRows = [142 144];
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     systemType = excelRaw{5};
%     systemInfo = expSpecific.sysInfo(systemType);
%     mouseType = excelRaw{13};
% %    sessionInfo =  expSpecific.sesInfo(mouseType);
%     sessionInfo.mouseType = mouseType;
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%         if exist(fullfile(saveDir,maskName))
%             disp(strcat('Landmarks and mask file already exists for ', recDate,'-', mouseName))
%             load(fullfile(saveDir,maskName), 'isbrain',  'I')
%         else
%     % need to be modified to see if WL exist
%     sessionInfo.darkFrameNum = excelRaw{14};
%     
%     sessionInfo.stimbaseline=excelRaw{9};
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.stimblocksize = excelRaw{8};
%     darkFrameInd = 2:sessionInfo.darkFrameNum;
%     filename = char(fullfile(rawdataloc,recDate,strcat(recDate,'-',mouseName,'-',sessionType,'1.tif')));
%     
% %     raw = read.readRaw(fileName,systemInfo.numLEDs,systemInfo.readFcn);
% %     WL = preprocess.getWL(raw,darkFrameInd,[4 3 2]);
%     
%     wl = zeros(128,128,3);
%     wl(:,:,1)= readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+4);
%     wl(:,:,2) = readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+3);
%     wl(:,:,3) = readtiff_oneImage(filename,sessionInfo.darkFrameNum*systemInfo.numLEDs+2);
%     WL = zeros(128,128,3);
%             WL(:,:,1) = wl(:,:,1)./max(max(wl(:,:,1)));
%         WL(:,:,2) = wl(:,:,2)./max(max(wl(:,:,2)));
%         WL(:,:,3) = wl(:,:,3)./max(max(wl(:,:,3)));
%     disp(strcat('get landmarks and mask for',recDate,'-', mouseName))
%     [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_xw(WL);
%     save(fullfile(saveDir,maskName), 'isbrain',  'I' ,'WL','WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter')
%     isbrain_contour = bwperim(isbrain);
%     
%     figure;
%     imagesc(WL); %changed 3/1/1
%     axis off
%     axis image
%     title(strcat(recDate,'-',mouseName));
%     
%     for f=1:size(seedcenter,1)
%         hold on;
%         plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
%     end
%     hold on;
%     plot(I.tent(1,1),I.tent(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     plot(I.bregma(1,1),I.bregma(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     plot(I.OF(1,1),I.OF(1,2),'ko','MarkerFaceColor','b')
%     hold on;
%     contour(isbrain_contour,'r')
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'_WLandMarks.jpg')))
%       end
%     clearvars -except excelFile nVx nVy excelRows runs
%     close all;
% end
% % 
% 
% 
% % Process raw data to get xform_datahb and xform_fluor(if needed)
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
% 
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
% 
%     sessionInfo.mouseType = excelRaw{13};
%     sessionInfo.darkFrameNum = excelRaw{11};
%     sessionInfo.totalFrameNum = excelRaw{18};
%     sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
%     sessionInfo.detrendSpatially = false;
%     sessionInfo.detrendTemporally = true;
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.freqout = sessionInfo.framerate;
%     muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
%     systemType = excelRaw{5};
%     systemInfo = expSpecific.sysInfo(systemType);
% 
%     sessionInfo.hbSpecies = 2:4;
%     if strcmp(char(sessionInfo.mouseType),'gcamp6f')
%         sessionInfo.fluorSpecies = 1;
%         sessionInfo.fluorExcitationFile = "gcamp6f_excitation.txt";
%         sessionInfo.fluorEmissionFile = "gcamp6f_emission.txt";
%     end
%     systemInfo.invalidFrameInd = 1;
% 
% 
%     rawdatabinloc=fullfile(saveDir, 'Binned');
%     if ~exist(rawdatabinloc);
%         mkdir(rawdatabinloc);
%     end
% 
% 
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%     load(fullfile(saveDir,maskName),'I')
% 
% 
%     pkgDir = what('bauerParams');
% 
%     fluorDir = fullfile(pkgDir.path,'probeSpectra');
%     sessionInfo.fluorEmissionFile = fullfile(fluorDir,sessionInfo.fluorEmissionFile);
% 
%     ledDir = fullfile(pkgDir.path,'ledSpectra');
%     for ind = 1:numel(systemInfo.LEDFiles)
%         systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
% 
%     end
% 
%     for n = runs
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
% 
%         if ~exist(fullfile(saveDir,processedName))
%             if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
%                 sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
%             end
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%             disp('preprocess');
%             systemInfo.invalidFrameInd = 1;
%             fileName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
%             raw_withdark = readtiff(char(fullfile(rawdataloc,recDate,fileName)));
%             raw_withdark = double(reshape(raw_withdark,nVy,nVx,systemInfo.numLEDs,[]));
%             time = 1:size(raw_withdark,4); time = time./sessionInfo.framerate;
% 
%             [time,xform_raw,raw] = fluor.preprocess(time,raw_withdark,systemInfo,sessionInfo,I,'darkFrameInd',2:sessionInfo.darkFrameNum/systemInfo.numLEDs);
%             save(fullfile(saveDir,rawName),'raw','xform_raw','-v7.3')
% 
%             disp('get hemoglobin data');
% 
%             maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
%             load(fullfile(saveDir,maskName), 'xform_isbrain','I')
% 
%             xform_isbrain(isnan(xform_isbrain)) = 0;
%             xform_isbrain = logical(xform_isbrain);
% 
% 
%             [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(sessionInfo.hbSpecies));
%             BaselineFunction  = @(x) mean(x,numel(size(x)));
%             baselineValues = BaselineFunction(xform_raw);
%             xform_datahb = mouse.process.procOIS(xform_raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E,xform_isbrain);
%             save(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo','-v7.3')
% 
%         else
%             disp(strcat('OIS data already processed for ',processedName))
%             load(fullfile(saveDir,processedName),'xform_datahb','sessionInfo','systemInfo')
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%             load(fullfile(saveDir,rawName),'xform_raw')
%         end
% 
% 
%         if ~strcmp(char(sessionInfo.mouseType),'WT')
% 
%             xform_fluor = xform_raw(:,:,sessionInfo.fluorSpecies,:);
%             xform_fluor = mouse.expSpecific.procFluor(xform_fluor); % make the data ratiometric
% 
%             if strcmp(char(sessionInfo.mouseType),'gcamp6f')
%                 C = who('-file',fullfile(saveDir,processedName));
%                 isFluorGot = false;
%                 for  k=1:length(C)
%                     if strcmp(C(k),'xform_gcamp')
%                         isFluorGot = true;
%                     end
%                 end
%                 if ~isFluorGot
%                     disp('correct gcamp')
% 
% 
% 
%                     [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(1));
%                     [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);
% 
% 
%                     dpIn = op_in.dpf/2;
%                     dpOut = op_out.dpf/2;
% 
%                     %             dpIn = 0.056;
%                     %             dpOut = 0.057;
%                     xform_gcamp= xform_fluor ;
%                     xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_datahb,...
%                         [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
% 
%                     save(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','-append')
%                 else
%                     disp(strcat('gcamp data already processed for ',processedName))
%                 end
%             end
% 
%         end
%     end
% 
% end




for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    
    
    for n = 1:3
        %         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        %         output = fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
        %
        % %         if ~ exist(output,'file')
        %             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        %             load(fullfile(saveDir,rawName),'raw')
        %             disp(strcat('QC raw for ',rawName))
        %
        %             QCcheck_raw(raw,isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
        %         else
        %         end
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
            sessionInfo.framerate = excelRaw{7};
            
            
            
            
            
            
        
            
            
            oxy = double(squeeze(xform_datahb(:,:,1,:)));
            deoxy = double(squeeze(xform_datahb(:,:,2,:)));
            total = double(oxy+deoxy);
            
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp = double(squeeze(xform_gcamp(:,:,1,:)));
                gcampCorr = double(squeeze(xform_gcampCorr(:,:,1,:)));
                green = double(squeeze(xform_green(:,:,1,:)));
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
            end
            
            
            
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
                end
            end              
            % Block Average
            texttitle = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(n));
            output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n)));
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')   
                fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle,xform_isbrain)
                close all
            end

        end
    end
end








