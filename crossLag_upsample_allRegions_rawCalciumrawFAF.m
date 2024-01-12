clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
startInd = 2;
freqLow = 0.02;
calMax = 8;
hbMax  = 2.5;
FADMax = 1;
hrfMax = 0.02;
mrfMax = 0.002;
samplingRate = 25;
freq_new     = 250;
t_kernel = 30;
tZone = 10;
validRange = - round(tZone*freq_new) : round(tZone*freq_new);
maxValidRange = max(abs(validRange));
validInd = (min(validRange)+maxValidRange+1):(maxValidRange+1+max(validRange));

load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

% Overlapped brain mask
xform_isbrain_mice = 1;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    disp(strcat(mouseName,', run #1'))
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
end

% Region inside of mouse brain
mask = AtlasSeeds.*xform_isbrain_mice;


for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\CrossLag_NMC_rawCalciumrawFAF'),'dir')
        mkdir(strcat(saveDir,'\CrossLag_NMC_rawCalciumrawFAF'))
    end
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = 1:3
        tic
        disp(strcat(mouseName,', run#',num2str(n)))
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FAD','xform_jrgeco1a')
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        FAD = xform_FAD*100;
        clear xform_FAD
        Calcium = squeeze(xform_jrgeco1a)*100; % convert to DeltaF/F%
        clear xform_jrgeco1a
        % Pad one more frame to full 10 mins
        HbT    (:,:,end+1) = HbT    (:,:,end);
        FAD    (:,:,end+1) = FAD    (:,:,end);
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Filter 0.02-2Hz, downsample to 10 Hz
        HbT     = filterData(HbT,    freqLow,2,samplingRate);
        FAD     = filterData(double(FAD),    freqLow,2,samplingRate);
        Calcium = filterData(double(Calcium),freqLow,2,samplingRate);
        
        % Reshape into 30 seconds
        HbT     = reshape(HbT    ,128,128,t_kernel*samplingRate,[]);
        FAD     = reshape(FAD    ,128,128,t_kernel*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,t_kernel*samplingRate,[]);
        
        % Initialization
        for h = {'NVC_rawCalciumrawFAF','NMC_rawCalciumrawFAF'}          
            eval(strcat('lagAmp_'   ,h{1},'=nan(21-startInd,50);'))
            eval(strcat('lagTime_'  ,h{1},'=nan(21-startInd,50);'))
            eval(strcat('lagWid_'   ,h{1},'=nan(21-startInd,50 );'))
            eval(strcat('crossLagY_',h{1},'=nan(21-startInd,length(validRange),50);'))
            eval(strcat('crossLagX_',h{1},'=nan(21-startInd,length(validRange),50);'))
        end
        jj = 1;
        for ii = startInd:20
            
            % reshape for each window
            HbT_temp     = reshape(HbT    (:,:,:,ii),128*128,[]);
            FAD_temp     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_temp = reshape(Calcium(:,:,:,ii),128*128,[]);
            
            % upsample to 250 Hz
            HbT_resample     = resample(HbT_temp    ,freq_new,samplingRate,'Dimension',2);
            FAD_resample     = resample(FAD_temp    ,freq_new,samplingRate,'Dimension',2);
            Calcium_resample = resample(Calcium_temp,freq_new,samplingRate,'Dimension',2);
            %% Calculate HRF and MRF
            
            for region = 1:50
                
                % Mean signal inside of the regional mask
                mask_region = zeros(128,128);
                mask_region(mask == region) = 1;
                mask_region = logical(mask_region);
                HbT_region     = mean(HbT_resample    (mask_region(:),:));
                FAD_region     = mean(FAD_resample    (mask_region(:),:));
                Calcium_region = mean(Calcium_resample(mask_region(:),:));
                
                % Lag for NVC
                [covResult,lags] = xcorr(HbT_region,Calcium_region,maxValidRange,'coeff');
                % vectorize cross correlation
                covResult = covResult(validInd);
                crossLagY_NVC_rawCalciumrawFAF(jj,:,region) = covResult(:);
                lags = lags(validInd);
                crossLagX_NVC_rawCalciumrawFAF(jj,:,region) = lags(:)/freq_new;
                
                
                % Find lag time, amplitude and width for the max lag within
                % valid region
                
                [A,T,W] = findpeaks(covResult,lags,'MinPeakHeight',0);
                if ~isempty(A)
                    [M,I] = max(A);                  
                    lagAmp_NVC_rawCalciumrawFAF (jj,region) = A(I);
                    lagTime_NVC_rawCalciumrawFAF(jj,region) = T(I);
                    lagTime_NVC_rawCalciumrawFAF(jj,region) = lagTime_NVC_rawCalciumrawFAF(jj,region)/freq_new;
                    lagWid_NVC_rawCalciumrawFAF (jj,region) = W(I);
                    
                    % Visualization for cross lag for NVC
                    figure('units','normalized','outerposition',[0 0 1 1])
                    subplot(1,3,1)
                    imagesc(mask_region)
                    axis image off
                    title(parcelnames{region})
                    
                    
                    subplot(1,3,2)
                    plot((1:t_kernel*freq_new)/freq_new,HbT_region,'k')
                    ylabel('\Delta\muM')
                    ylim([-hbMax hbMax])
                    hold on
                    yyaxis right
                    plot((1:t_kernel*freq_new)/freq_new,Calcium_region,'m')
                    legend('HbT','jRGECO1a')
                    ylim([-calMax calMax])
                    ylabel('\DeltaF/F%')
                    xlabel('Time(s)')
                    title(strcat('Time Course for',{' '},parcelnames{region}))
                    grid on
                    
                    subplot(1,3,3)
                    plot(crossLagX_NVC_rawCalciumrawFAF(jj,:,region),crossLagY_NVC_rawCalciumrawFAF(jj,:,region),'k')
                    hold on
                    scatter(lagTime_NVC_rawCalciumrawFAF(jj,region),lagAmp_NVC_rawCalciumrawFAF(jj,region),'r','filled')
                    xlabel('Time(s)')
                    title(strcat('Cross correlaiton of NVC rawCalciumrawFAF for',{' '},parcelnames{region}))
                    grid on
                    
                    sgtitle(strcat('Cross Lag of NVC for Region',{' '},parcelnames{region},',',{' '},num2str(freqLow),'-2Hz,rawCalciumrawFAF',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                    if ~exist(fullfile(saveDir,'CrossLag_NVC'))
                        mkdir(fullfile(saveDir,'CrossLag_NVC'))
                    end
                    saveName =  fullfile(saveDir,'CrossLag_NVC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',parcelnames{region},'-CrossLag-NVC-rawCalciumrawFAF'));
                    saveas(gcf,strcat(saveName,'.fig'))
                    saveas(gcf,strcat(saveName,'.png'))
                    
                end
                
                
                % Lag for NMC
                [covResult,lags] = xcorr(FAD_region,Calcium_region,maxValidRange,'coeff');
                % vectorize cross correlation
                covResult = covResult(validInd);
                crossLagY_NMC_rawCalciumrawFAF(jj,:,region) = covResult(:);
                lags = lags(validInd);
                crossLagX_NMC_rawCalciumrawFAF(jj,:,region) = lags(:)/freq_new;
                
                
                % Find lag time, amplitude and width for the max lag within
                % valid region
                
                [A,T,W] = findpeaks(covResult,lags,'MinPeakHeight',0);
                if ~isempty(A)
                    [M,I] = max(A);                  
                    lagAmp_NMC_rawCalciumrawFAF (jj,region) = A(I);
                    lagTime_NMC_rawCalciumrawFAF(jj,region) = T(I);
                    lagTime_NMC_rawCalciumrawFAF(jj,region) = lagTime_NMC_rawCalciumrawFAF(jj,region)/freq_new;
                    lagWid_NMC_rawCalciumrawFAF (jj,region) = W(I);
                    
                    % Visualization for cross lag for NMC
                    figure('units','normalized','outerposition',[0 0 1 1])
                    subplot(1,3,1)
                    imagesc(mask_region)
                    axis image off
                    title(parcelnames{region})
                    
                    
                    subplot(1,3,2)
                    plot((1:t_kernel*freq_new)/freq_new,HbT_region,'k')
                    ylabel('\Delta\muM')
                    ylim([-hbMax hbMax])
                    hold on
                    yyaxis right
                    plot((1:t_kernel*freq_new)/freq_new,Calcium_region,'m')
                    legend('HbT','jRGECO1a')
                    ylim([-calMax calMax])
                    ylabel('\DeltaF/F%')
                    xlabel('Time(s)')
                    title(strcat('Time Course for',{' '},parcelnames{region}))
                    grid on
                    
                    subplot(1,3,3)
                    plot(crossLagX_NMC_rawCalciumrawFAF(jj,:,region),crossLagY_NMC_rawCalciumrawFAF(jj,:,region),'k')
                    hold on
                    scatter(lagTime_NMC_rawCalciumrawFAF(jj,region),lagAmp_NMC_rawCalciumrawFAF(jj,region),'r','filled')
                    xlabel('Time(s)')
                    title(strcat('Cross correlaiton of NMC rawCalciumrawFAF for',{' '},parcelnames{region}))
                    grid on
                    
                    sgtitle(strcat('Cross Lag of NMC for Region',{' '},parcelnames{region},',',{' '},num2str(freqLow),'-2Hz,rawCalciumrawFAF',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                    if ~exist(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF'))
                        mkdir(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF'))
                    end
                    saveName =  fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',parcelnames{region},'-CrossLag-NMC-rawCalciumrawFAF'));
                    saveas(gcf,strcat(saveName,'.fig'))
                    saveas(gcf,strcat(saveName,'.png'))
                end
                close all
            end
            jj = jj+1;
        end
        clear HbT FAD Calcium
        %save
        for var = {'lagAmp','lagTime','lagWid','crossLagY','crossLagX'}                       
                saveName = fullfile(saveDir,'CrossLag_NVC_rawCalciumrawFAF', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NVC_rawCalciumrawFAF','.mat'));
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NVC_rawCalciumrawFAF',char(39),',',char(39),'-append',char(39),')'))
                else
                    if ~exist(fullfile(saveDir,'CrossLag_NVC_rawCalciumrawFAF'))
                        mkdir(fullfile(saveDir,'CrossLag_NVC_rawCalciumrawFAF'))
                    end
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NVC_rawCalciumrawFAF',char(39),')'))
                end
                saveName = fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC_rawCalciumrawFAF','.mat'));
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_rawCalciumrawFAF',char(39),',',char(39),'-append',char(39),')'))
                else
                    if ~exist(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF'))
                        mkdir(fullfile(saveDir,'CrossLag_NMC_rawCalciumrawFAF'))
                    end
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_rawCalciumrawFAF',char(39),')'))
                end
        end
        toc
    end
end



