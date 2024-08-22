clear; close all; clc
lowFreq = 1;
import mouse.*
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
%excelRows = [182 184 186 229 233 237];
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];%181
runs =1:3;
sessionInfo.framerate = 25;
refseeds=GetReferenceSeeds;
sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
sessionInfo.bandtype_Delta = {"Delta",0.4,4};

% generate corr FAD and RSFC
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end

    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;

    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};

    if strcmp(sessionType,'stim')
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
    else
        sessionInfo.stimbaseline =0;
        sessionInfo.stimduration =0;
    end
    sessionInfo.hbSpecies = [3 4];
    sessionInfo.FADspecies = 1;
    sessionInfo.fluorSpecies = 2;
    sessionInfo.refChan = 4;
    sessionInfo.refChan_Green = 3;
    sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";

    sessionInfo.FADEmissionFile = "fad_emission.txt";
    systemInfo.LEDFiles = [
        "TwoCam_Mightex470_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
        "TwoCam_TL625_Pol_Longer593.txt"];
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end

    % end

    xform_isbrain(isnan(xform_isbrain)) = 0;
    xform_isbrain = logical(xform_isbrain);

    %     badruns = str2num(excelRaw{19});
    %     runs(badruns) = [];

    for n = runs
        tic
        disp([mouseName,',run#',num2str(n)])
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,rawName),'rawdata')

        if size(rawdata,4)~=(sessionInfo.framerate*600) && (size(rawdata,4)~=sessionInfo.framerate*300)
            darkFrameInd = 2:sessionInfo.darkFrameNum/size(rawdata,3);
            darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
            raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
            clear rawdata
            raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
            rawdata = raw_baselineMinus;
        end

        if strcmp(sessionType,'stim')
            rawdata(:,:,:,1) = rawdata(:,:,:,2);
        elseif strcmp(sessionType,'fc')
            rawdata(:,:,:,1) = [];
        end
        rawdata(:,:,:,end) = rawdata(:,:,:,end-1);
        raw_detrend = temporalDetrendAdam(rawdata);
        clear rawdata
        raw_detrend = process.smoothImage(raw_detrend,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data

        xform_raw = process.affineTransform(raw_detrend,affineMarkers);
        clear raw_detrend
        xform_raw(isnan(xform_raw)) = 0;
        BaselineFunction  = @(x) mean(x,numel(size(x)));

        baselineValues = xform_raw;
        baselineValues = BaselineFunction(baselineValues);

        xform_FAD = squeeze(xform_raw(:,:,sessionInfo.FADspecies,:));
        xform_FAD= procFluor(xform_FAD,baselineValues(:,:,sessionInfo.FADspecies));

        load(fullfile(saveDir, processedName),'xform_datahb')
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb_1Order = lowpass_1stOrder(xform_datahb,lowFreq,sessionInfo.framerate);
        clear xform_datahb
        load(fullfile(saveDir, processedName),'op_in_FAD','op_out_FAD','E_in_FAD','E_out_FAD')

        dpIn_FAD = op_in_FAD.dpf/2;
        dpOut_FAD = op_out_FAD.dpf/2;

        xform_FADCorr_1Order = mouse.physics.correctHb(xform_FAD,xform_datahb_1Order,...
            [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
        clear xform_FAD  xform_datahb_1Order
        xform_FADCorr_1Order = mouse.process.smoothImage(xform_FADCorr_1Order,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data%%%%%
        save(fullfile(saveDir,processedName), 'xform_FADCorr_1Order','-append')

        % [R_FADCorr_1Order_Delta,Rs_FADCorr_1Order_Delta]= QCcheck_CalcRRs(refseeds,double(xform_FADCorr_1Order)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        % clear xform_FADCorr_1Order
        % save(fullfile(saveDir,processedName),'Rs_FADCorr_1Order_Delta','R_FADCorr_1Order_Delta','-append')
        % visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed');
        % QCcheck_fcVis(refseeds,R_FADCorr_1Order_Delta,Rs_FADCorr_1Order_Delta,'FADCorr-1Order', 'g','Delta',saveDir,strcat(visName),false,xform_isbrain)
        % clear R_FADCorr_1Order_Delta Rs_FADCorr_1Order_Delta
        % close all
        toc
    end
end
%% mouse average fc
info.nVx = 128;
info.nVy = 128;
length_runs = length(runs);
for excelRow = 181
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))

        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');

    else
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
    end
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end

    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');

    R_FADCorr_1Order_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_FADCorr_1Order_Delta_mouse = zeros(16,16,length_runs);

    for n = runs
        disp('loading processed data')

        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'R_FADCorr_1Order_Delta','R_FADCorr_1Order_ISA',...
            'Rs_FADCorr_1Order_Delta','Rs_FADCorr_1Order_ISA')

        R_FADCorr_1Order_Delta_mouse(:,:,:,n) = R_FADCorr_1Order_Delta;
        Rs_FADCorr_1Order_Delta_mouse(:,:,n) = Rs_FADCorr_1Order_Delta;
    end

    % disp(char(['QC check on ', processedName_mouse]))
     R_FADCorr_1Order_Delta_mouse = mean(R_FADCorr_1Order_Delta_mouse,4);
     Rs_FADCorr_1Order_Delta_mouse = mean(Rs_FADCorr_1Order_Delta_mouse,3);

    save(fullfile(saveDir, processedName_mouse),...
        'R_FADCorr_1Order_Delta_mouse','Rs_FADCorr_1Order_Delta_mouse','-append')
    % QCcheck_fcVis(refseeds,R_FADCorr_1Order_Delta_mouse, Rs_FADCorr_1Order_Delta_mouse,'FADCorr_1Order','g','Delta',saveDir,visName,false,xform_isbrain)
    % close all
end

%% Mice Average
excelRows = [202 195 204 230 234 240];
numMice = length(excelRows);
xform_isbrain_mice = 1;
info.nVx = 128;
info.nVy = 128;
R_FADCorr_1Order_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);

Rs_FADCorr_1Order_Delta_mice = zeros(16,16,numMice);


miceName = [];
miceName_powerdata = [];
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);

    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;


    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');

    load(fullfile(saveDir, processedName),'R_FADCorr_1Order_Delta_mouse',...
        'Rs_FADCorr_1Order_Delta_mouse')
    R_FADCorr_1Order_Delta_mice(:,:,:,ll) = real(atanh(R_FADCorr_1Order_Delta_mouse));
    Rs_FADCorr_1Order_Delta_mice(:,:,ll) = real(atanh(Rs_FADCorr_1Order_Delta_mouse));
    ll = ll+1;
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

R_FADCorr_1Order_Delta_mice = mean(R_FADCorr_1Order_Delta_mice,4);
Rs_FADCorr_1Order_Delta_mice = mean(Rs_FADCorr_1Order_Delta_mice,3);

saveDir_cat = 'E:\RGECO\cat';
save(fullfile(saveDir_cat, processedName_mice),...
    'R_FADCorr_1Order_Delta_mice','Rs_FADCorr_1Order_Delta_mice','-append')
visName = strcat(recDate,miceName);
QCcheck_fcVis(refseeds,R_FADCorr_1Order_Delta_mice, Rs_FADCorr_1Order_Delta_mice,'FADCorr_1Order','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)


% [hz,powerdata_FADCorr_1Order ] = QCcheck_CalcPDS(xform_FADCorr_1Order /0.01,sessionInfo.framerate,xform_isbrain);
%
% total = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
% [~,powerdata_total] = QCcheck_CalcPDS(total*10^6,sessionInfo.framerate,xform_isbrain);
% [~,powerdata_oxy] = QCcheck_CalcPDS((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
% [~,powerdata_deoxy] = QCcheck_CalcPDS(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
%
% total_1Order = squeeze(xform_datahb_1Order(:,:,1,:)+xform_datahb_1Order(:,:,2,:));
% [~,powerdata_total_1Order] = QCcheck_CalcPDS(total_1Order*10^6,sessionInfo.framerate,xform_isbrain);
% [~,powerdata_oxy_1Order] = QCcheck_CalcPDS((xform_datahb_1Order(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
% [~,powerdata_deoxy_1Order] = QCcheck_CalcPDS(xform_datahb_1Order(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
%
% figure
% subplot(1,3,1)
% loglog(hz,powerdata_oxy,'r')
% hold on
% loglog(hz,powerdata_oxy_1Order,'b')
% legend({'No Filter','1st Order Filter'})
% xlabel('Frequency(Hz)')
% ylabel('(\Delta\muM)^2/Hz')
% title('HbO')
% subplot(1,3,2)
% loglog(hz,powerdata_deoxy,'r')
% hold on
% loglog(hz,powerdata_deoxy_1Order,'b')
% xlabel('Frequency(Hz)')
% ylabel('(\Delta\muM)^2/Hz')
% title('HbR')
% subplot(1,3,3)
% loglog(hz,powerdata_total,'r')
% hold on
% loglog(hz,powerdata_total_1Order,'b')
% xlabel('Frequency(Hz)')
% ylabel('(\Delta\muM)^2/Hz')
% title('HbT')

%% Powermap for each run:

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    oriDir = "D:\"; oriDir = fullfile(oriDir,recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end

    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end

    % end

    xform_isbrain(isnan(xform_isbrain)) = 0;
    xform_isbrain = logical(xform_isbrain);

    %     badruns = str2num(excelRaw{19});
    %     runs(badruns) = [];

    for n = runs
        disp([mouseName,',run#',num2str(n)])
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName), 'xform_FADCorr_1Order')
        FADCorr_1Order_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr_1Order)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
        clear xform_FADCorr_1Order
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed');
        QCcheck_powerMapVis(FADCorr_1Order_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName,"_FADCorr1OrderDelta"))
        save(fullfile(saveDir,processedName),'FADCorr_1Order_Delta_powerMap','-append')
        close all
    end
end
%% mouse average stim
goodBlocks_NoGSR = 1:10;
goodBlocks_GSR = 1:10;
stimStartTime = 5;
for excelRow = excelRows


    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);

    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};

    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    info.freqout=1;
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    xform_FADCorr_mouse_GSR = [];
    xform_FADCorr_mouse_NoGSR = [];
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        sessionInfo.stimblocksize = excelRaw{11};
        
        disp('loading processed data')
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
            'xform_FADCorr')
        numBlocks = size(xform_FADCorr,3)/sessionInfo.stimblocksize;
        xform_FADCorr = reshape(xform_FADCorr,128,128,[],numBlocks);
        xform_FADCorr_baseline = mean(xform_FADCorr(:,:,1:5*sessionInfo.framerate,:),3);
 
        xform_FADCorr_baseline = repmat(xform_FADCorr_baseline,1,1,size(xform_FADCorr,3),1);

        xform_FADCorr= xform_FADCorr-xform_FADCorr_baseline;
        xform_FADCorr_mouse_NoGSR = cat(4,xform_FADCorr_mouse_NoGSR,xform_FADCorr(:,:,:,goodBlocks_NoGSR));       
        xform_FADCorr_GSR = mouse.process.gsr(xform_FADCorr,xform_isbrain);
        clear xform_FADCorr
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_FADCorr_GSR','-append')% optional
        xform_FADCorr_GSR_baseline = mean(xform_FADCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
 
        xform_FADCorr_GSR_baseline = repmat(xform_FADCorr_GSR_baseline,1,1,size(xform_FADCorr_GSR,3),1);

        xform_FADCorr_GSR= xform_FADCorr_GSR-xform_FADCorr_GSR_baseline;
        xform_FADCorr_mouse_GSR = cat(4,xform_FADCorr_mouse_GSR,xform_FADCorr_GSR(:,:,:,goodBlocks_GSR));
        clear xform_FADCorr_GSR

    end
    xform_FADCorr_mouse_NoGSR = mean(xform_FADCorr_mouse_NoGSR,4);
    xform_FADCorr_mouse_GSR = mean(xform_FADCorr_mouse_GSR,4);
    save(fullfile(saveDir,processedName_mouse),'xform_FADCorr_mouse_GSR','xform_FADCorr_mouse_NoGSR','-append')
    peakMap_NoGSR = mean(xform_FADCorr_mouse_NoGSR(:,:,125:250),3);
    peakMap_GSR = mean(xform_FADCorr_mouse_GSR(:,:,125:250),3);
    figure
    subplot(121)
    subplot(122)
end
