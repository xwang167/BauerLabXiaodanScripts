clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
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
edgeLen =1;
tZone = 4;
validRange = - edgeLen: round(tZone*freq_new);
maxValidRange = max(abs(validRange));
validInd = (min(validRange)+maxValidRange+1):(maxValidRange+1+max(validRange));

load("noVasculatureMask.mat",'mask_new')
load('AtlasandIsbrain.mat','AtlasSeedsFilled')
AtlasSeedsFilled(AtlasSeedsFilled==0) = nan;
AtlasSeedsFilled(:,65:128) = AtlasSeedsFilled(:,65:128)+20;

% Mask for different regions
mask_M2_L = AtlasSeedsFilled==4;
mask_M1_L = AtlasSeedsFilled==5;
mask_SS_L = AtlasSeedsFilled==6 | AtlasSeedsFilled==7 | AtlasSeedsFilled==8 | AtlasSeedsFilled==9 | AtlasSeedsFilled==10 | AtlasSeedsFilled==11;
mask_P_L  = AtlasSeedsFilled==13 | AtlasSeedsFilled==14 | AtlasSeedsFilled==15;
mask_V1_L = AtlasSeedsFilled==17;
mask_V2_L = AtlasSeedsFilled==16|AtlasSeedsFilled==18;

mask_M2_R = AtlasSeedsFilled==24;
mask_M1_R = AtlasSeedsFilled==25;
mask_SS_R = AtlasSeedsFilled==26 | AtlasSeedsFilled==27 | AtlasSeedsFilled==28 | AtlasSeedsFilled==29 | AtlasSeedsFilled==30 | AtlasSeedsFilled==31;
mask_P_R  = AtlasSeedsFilled==33 | AtlasSeedsFilled==34 | AtlasSeedsFilled==35;
mask_V1_R = AtlasSeedsFilled==37;
mask_V2_R = AtlasSeedsFilled==36|AtlasSeedsFilled==38;


for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\CrossLag_NMC_Regions_Upsample'),'dir')
        mkdir(strcat(saveDir,'\CrossLag_NMC_Regions_Upsample'))
    end
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
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
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        FAD = xform_FADCorr*100;
        clear xform_FADCorr
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        % Pad one more frame to full 10 mins
        HbT    (:,:,end+1) = HbT    (:,:,end);
        FAD    (:,:,end+1) = FAD    (:,:,end);
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Filter 0.02-2Hz, downsample to 10 Hz
        HbT     = filterData(HbT,    freqLow,2,samplingRate);
        FAD     = filterData(FAD,    freqLow,2,samplingRate);
        Calcium = filterData(Calcium,freqLow,2,samplingRate);
        
        % Reshape into 30 seconds
        HbT     = reshape(HbT    ,128,128,t_kernel*samplingRate,[]);
        FAD     = reshape(FAD    ,128,128,t_kernel*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,t_kernel*samplingRate,[]);
        
        % Regions within brain without vasculature
        mask_M2_L = logical(mask_M2_L.*mask_new.*xform_isbrain);
        mask_M1_L = logical(mask_M1_L.*mask_new.*xform_isbrain);
        mask_SS_L = logical(mask_SS_L.*mask_new.*xform_isbrain);
        mask_P_L  = logical(mask_P_L .*mask_new.*xform_isbrain);
        mask_V1_L = logical(mask_V1_L.*mask_new.*xform_isbrain);
        mask_V2_L = logical(mask_V2_L.*mask_new.*xform_isbrain);
        
        mask_M2_R = logical(mask_M2_R.*mask_new.*xform_isbrain);
        mask_M1_R = logical(mask_M1_R.*mask_new.*xform_isbrain);
        mask_SS_R = logical(mask_SS_R.*mask_new.*xform_isbrain);
        mask_P_R  = logical(mask_P_R .*mask_new.*xform_isbrain);
        mask_V1_R = logical(mask_V1_R.*mask_new.*xform_isbrain);
        mask_V2_R = logical(mask_V2_R.*mask_new.*xform_isbrain);
        
        % Initialization
        for h = {'NVC','NMC'}
            for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                eval(strcat('lagAmp_'   ,h{1},'_',region{1},'=nan(1,21-startInd);'))
                eval(strcat('lagTime_'  ,h{1},'_',region{1},'=nan(1,21-startInd);'))
                eval(strcat('lagWid_'   ,h{1},'_',region{1},'=nan(1,21-startInd);'))
                eval(strcat('crossLagY_',h{1},'_',region{1},'=nan(21-startInd,length(validRange));'))
                eval(strcat('crossLagX_',h{1},'_',region{1},'=nan(21-startInd,length(validRange));'))
            end
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
            
            for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                
                % Mean signal inside of the regional mask
                eval(strcat('HbT_region     = mean(HbT_resample    (mask','_',region{1},'(:),:));'))
                eval(strcat('FAD_region     = mean(FAD_resample    (mask','_',region{1},'(:),:));'))
                eval(strcat('Calcium_region = mean(Calcium_resample(mask','_',region{1},'(:),:));'))
                
                % Lag for NVC
                [covResult,lags] = xcorr(HbT_region,Calcium_region,maxValidRange,'coeff');
                % vectorize cross correlation
                covResult = covResult(validInd);
                eval(strcat('crossLagY_NVC_',region{1},'(jj,:) = covResult(:);'))
                lags = lags(validInd);
                eval(strcat('crossLagX_NVC_',region{1},'(jj,:) = lags(:)/freq_new;'))
                
                
                % Find lag time, amplitude and width for the max lag within
                % valid region
                
                [A,T,W] = findpeaks(covResult,lags,'MinPeakHeight',0);
                if ~isempty(A)
                    [M,I] = max(A);
                    if M>covResult(1) ||  M == covResult(1)
                        eval(strcat('lagAmp_NVC_' ,region{1},'(jj) = A(I);'))
                        eval(strcat('lagTime_NVC_',region{1},'(jj) = T(I);'))
                        eval(strcat('lagWid_NVC_' ,region{1},'(jj) = W(I);'))
                        eval(strcat('lagTime_NVC_',region{1},'(jj) = lagTime_NVC_',region{1},'(jj)/freq_new;'))
                        % Visualization for cross lag for NVC
                        figure('units','normalized','outerposition',[0 0 1 1])
                        subplot(1,3,1)
                        eval(strcat('imagesc(mask_',region{1},')'))
                        axis image off
                        title(region)
                        grid on
                        
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
                        title(strcat('Time Course for',{' '},region{1}))
                        grid on
                        
                        subplot(1,3,3)
                        eval(strcat('plot(crossLagX_NVC_',region{1},'(jj,:),crossLagY_NVC_',region{1},'(jj,:),',char(39),'k',char(39),')'))
                        ylim([-1 1])
                        xlim([0 4])
                        hold on
                        eval(strcat('scatter(lagTime_NVC_',region{1},'(jj),lagAmp_NVC_',region{1},'(jj),',char(39),'r',char(39),',',char(39),'filled',char(39),')'))
                        xlabel('Time(s)')
                        title(strcat('Cross correlaiton of NVC for',{' '},region{1}))
                        grid on
                        
                        sgtitle(strcat('Cross Lag of NVC for Region',{' '},region{1},',',{' '},num2str(freqLow),'-2Hz,',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                        if ~exist(fullfile(saveDir,'CrossLag_NVC_Regions_Upsample'))
                            mkdir(fullfile(saveDir,'CrossLag_NVC_Regions_Upsample'))
                        end
                        saveName =  fullfile(saveDir,'CrossLag_NVC_Regions_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',region{1},'-CrossLag-NVC'));
                        saveas(gcf,strcat(saveName,'.fig'))
                        saveas(gcf,strcat(saveName,'.png'))
                    end
                end
                
                
                % Lag for NMC
                [covResult,lags] = xcorr(FAD_region,Calcium_region,maxValidRange,'coeff');
                % vectorize cross correlation
                covResult = covResult(validInd);
                eval(strcat('crossLagY_NMC_',region{1},'(jj,:) = covResult(:);'))
                lags = lags(validInd);
                eval(strcat('crossLagX_NMC_',region{1},'(jj,:) = lags(:)/freq_new;'))
                
                
                % Find lag time, amplitude and width for the max lag within
                % valid region
                
                [A,T,W] = findpeaks(covResult,lags,'MinPeakHeight',0);
                if ~isempty(A)
                    [M,I] = max(A);
                    if M>covResult(1) ||  M == covResult(1)
                        [M,I] = max(A);
                        eval(strcat('lagAmp_NMC_' ,region{1},'(jj) = A(I);'))
                        eval(strcat('lagTime_NMC_',region{1},'(jj) = T(I);'))
                        eval(strcat('lagWid_NMC_' ,region{1},'(jj) = W(I);'))
                        eval(strcat('lagTime_NMC_',region{1},'(jj) = lagTime_NMC_',region{1},'(jj)/freq_new;'))
                        % Visualization for cross lag for NMC
                        figure('units','normalized','outerposition',[0 0 1 1])
                        subplot(1,3,1)
                        eval(strcat('imagesc(mask_',region{1},')'))
                        axis image off
                        title(region)
                        grid on
                        
                        subplot(1,3,2)
                        plot((1:t_kernel*freq_new)/freq_new,FAD_region,'g')
                        ylabel('\DeltaF/F%')
                        ylim([-FADMax FADMax])
                        hold on
                        yyaxis right
                        plot((1:t_kernel*freq_new)/freq_new,Calcium_region,'m')
                        legend('FAD','jRGECO1a')
                        ylim([-calMax calMax])
                        ylabel('\DeltaF/F%')
                        xlabel('Time(s)')
                        title(strcat('Time Course for',{' '},region{1}))
                        grid on
                        
                        subplot(1,3,3)
                        eval(strcat('plot(crossLagX_NMC_',region{1},'(jj,:),crossLagY_NMC_',region{1},'(jj,:),',char(39),'k',char(39),')'))
                        ylim([-1 1])
                        xlim([0 4])
                        hold on
                        eval(strcat('scatter(lagTime_NMC_',region{1},'(jj),lagAmp_NMC_',region{1},'(jj),',char(39),'r',char(39),',',char(39),'filled',char(39),')'))
                        xlabel('Time(s)')
                        title(strcat('Cross correlaiton of NMC for',{' '},region{1}))
                        grid on
                        
                        sgtitle(strcat('Cross Lag of NMC for Region',{' '},region{1},',',{' '},num2str(freqLow),'-2Hz,',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                        if ~exist(fullfile(saveDir,'CrossLag_NMC_Regions_Upsample'))
                            mkdir(fullfile(saveDir,'CrossLag_NMC_Regions_Upsample'))
                        end
                        saveName =  fullfile(saveDir,'CrossLag_NMC_Regions_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',region{1},'-CrossLag-NMC'));
                        saveas(gcf,strcat(saveName,'.fig'))
                        saveas(gcf,strcat(saveName,'.png'))
                    end
                end
                close all
            end
            jj = jj+1;
        end
        clear HbT FAD Calcium
        %save
        for var = {'lagAmp','lagTime','lagWid','crossLagY','crossLagX'}           
            for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                saveName = fullfile(saveDir,'CrossLag_NVC_Regions_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NVC_Regions_Upsample','.mat'));
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NVC_',region{1},char(39),',',char(39),'-append',char(39),')'))
                else
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NVC_',region{1},char(39),')'))
                end
                saveName = fullfile(saveDir,'CrossLag_NMC_Regions_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC_Regions_Upsample','.mat'));
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_',region{1},char(39),',',char(39),'-append',char(39),')'))
                else
                    eval(strcat('save(',char(39),saveName,char(39),',',char(39),var{1},'_NMC_',region{1},char(39),')'))
                end
            end
            
        end
        toc
    end
end



