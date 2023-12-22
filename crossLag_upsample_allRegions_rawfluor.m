clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
excelRows =[181,183];
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
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240];
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


for excelRow = excelRows

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\CrossLag_NMC_raw'),'dir')
        mkdir(strcat(saveDir,'\CrossLag_NMC_raw'))
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
        load(fullfile(saveDir,processedName),'xform_FAD','xform_jrgeco1aCorr')
        FAD = xform_FAD*100;
        clear xform_FAD
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        % Pad one more frame to full 10 mins
        FAD    (:,:,end+1) = FAD    (:,:,end);
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Filter 0.02-2Hz, downsample to 10 Hz
        FAD     = filterData(double(FAD),    freqLow,2,samplingRate);
        Calcium = filterData(double(Calcium),freqLow,2,samplingRate);

        % Reshape into 30 seconds
        FAD     = reshape(FAD    ,128,128,t_kernel*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,t_kernel*samplingRate,[]);

        % Initialization
        crossLagX_NMC_raw=nan(21-startInd,length(validRange),50);
        crossLagY_NMC_raw=nan(21-startInd,length(validRange),50);
        jj = 1;
        for ii = startInd:20
            % reshape for each window
            FAD_temp     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_temp = reshape(Calcium(:,:,:,ii),128*128,[]);

            % upsample to 250 Hz
            FAD_resample     = resample(FAD_temp    ,freq_new,samplingRate,'Dimension',2);
            Calcium_resample = resample(Calcium_temp,freq_new,samplingRate,'Dimension',2);
            %% Calculate HRF and MRF

            for region = 1:50

                % Mean signal inside of the regional mask
                mask_region = zeros(128,128);
                mask_region(mask == region) = 1;
                mask_region = logical(mask_region);

                FAD_region     = mean(FAD_resample    (mask_region(:),:));
                Calcium_region = mean(Calcium_resample(mask_region(:),:));


                % Lag for NMC
                [covResult,lags] = xcorr(FAD_region,Calcium_region,maxValidRange,'coeff');
                % vectorize cross correlation
                covResult = covResult(validInd);
                crossLagY_NMC_raw(jj,:,region) = covResult(:);
                lags = lags(validInd);
                crossLagX_NMC_raw(jj,:,region) = lags(:)/freq_new;


                % Find lag time, amplitude and width for the max lag within
                % valid region

                % Visualization for cross lag for NMC
                figure('units','normalized','outerposition',[0 0 1 1])
                subplot(1,3,1)
                imagesc(mask_region)
                axis image off
                title(parcelnames{region})


                subplot(1,3,2)
                plot((1:t_kernel*freq_new)/freq_new,FAD_region,'g')
                hold on
                plot((1:t_kernel*freq_new)/freq_new,Calcium_region,'m')
                legend('FAF','Corrected jRGECO1a')
                ylim([-calMax calMax])
                ylabel('\DeltaF/F%')
                xlabel('Time(s)')
                title(strcat('Time Course for',{' '},parcelnames{region}))
                grid on

                subplot(1,3,3)
                plot(crossLagX_NMC_raw(jj,:,region),crossLagY_NMC_raw(jj,:,region),'k')
                xlabel('Time(s)')
                title(strcat('Cross correlaiton of NMC of raw FAF for',{' '},parcelnames{region}))
                grid on
                ylim([-inf inf])

                sgtitle(strcat('Cross Lag of NMC of raw FAF for Region',{' '},parcelnames{region},',',{' '},num2str(freqLow),'-2Hz,',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                saveName =  fullfile(saveDir,'CrossLag_NMC_raw', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',parcelnames{region},'-CrossLag-NMC'));
                saveas(gcf,strcat(saveName,'.fig'))
                saveas(gcf,strcat(saveName,'.png'))
                close all
            end
            jj = jj+1;
        end
        clear FAD Calcium
        %save
        for var = {'crossLagY','crossLagX'}
            saveName = fullfile(saveDir,'CrossLag_NMC_raw', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC_raw','.mat'));
            if exist(saveName,'file')
                eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_raw',char(39),',',char(39),'-append',char(39),')'))
            else
                eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_raw',char(39),')'))
            end
        end
        toc
    end
end



