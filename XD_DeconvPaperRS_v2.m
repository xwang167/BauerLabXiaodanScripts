clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
load('D:\OIS_Process\noVasculatureMask.mat')
% mask without vasculature
mask = leftMask+rightMask;
excelRows = [181 183 185 228 232 236 ];
runs = 1:3;%
numReg = 40;
samplingRate =25;
freq = 10;
for excelRow = excelRows
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = xform_isbrain.*mask;
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        
        %1.) Filter 0.02-2Hz, downsample to 10 Hz
        HbT =  filterData(HbT,0.02,2,samplingRate);
        Calcium = filterData(Calcium,0.02,2,samplingRate);
        
        HbT = resample(HbT,freq,samplingRate,'Dimension',3); %resample to 10 Hz
        Calcium = resample(Calcium,freq,samplingRate,'Dimension',3); %resample to 10 Hz
        %2.) Reshape into 30 seconds
        HbT=reshape(HbT,128,128,30*freq,[]);
        Calcium=reshape(Calcium,128,128,30*freq,[]);
        
        %3.) Deconvolution
        h = nan(size(HbT));
        for nVy = 1: size(HbT,1)
            for nVx = 1: size(HbT,2)
                if mask(nVy,nVx)
                    for win=1:size(HbT,4)
                        pixHbT = tukeywin(length(squeeze(HbT(nVy,nVx,:,win))),.3).*squeeze(HbT(nVy,nVx,:,win)); %make sure these are column vectors!
                        pixCalcium = tukeywin(length(squeeze(Calcium(nVy,nVx,:,win))),.3).*squeeze(Calcium(nVy,nVx,:,win)); %make sure these are column vectors!
                        X = convmtx(pixCalcium,length(pixCalcium));% why calculating convolution matrix for input? 599*300?
                        X = X(1:length(pixCalcium),1:length(pixCalcium));% make it square?
                        [~,S,~]=svd(X);
                        h(nVy,nVx,:,win)= (X'*S*X+(S(1,1).^2)*.5*eye(length(pixCalcium))) \ (X'*S*[zeros(3*freq,1); pixHbT(1:end-3*freq)]);% why add 3s of zeros? Do we need to shift it?
                    end
                end
            end
        end
        
%         %4.) Average across blocks
%         h_avg = mean(h,4);
%         h_avg = reshape(h_avg,size(h,1)*size(h,2),[]);
%         h_regions = nan(40,size(h,3));
%         %5.) Create regional average h_regions
%         AtlasSeeds = AtlasSeeds.*mask;
%         for reg = 1:numReg
%             ROI = AtlasSeeds == reg;
%             h_regions(reg,:) = mean(h_avg(ROI(:),:));
%         end
        t = (-3*freq:(30-3)*freq-1)/freq;
        saveName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NVC','.mat');
        save(fullfile(saveDir,saveName),'t','h')
    end
end

% figure
% imagesc(mask)
% axis image off
% title('Overlap between xform\_isbrain and Atlas')
% 
% HbT = reshape(HbT,128,128,[]);
% Calcium = reshape(Calcium,128,128,[]);
% 
% [Pxx_HbT,hz] = pwelch(squeeze(HbT(72,23,:)),[],[],[],10);
% [Pxx_Calcium,hz] = pwelch(squeeze(Calcium(72,23,:)),[],[],[],10);
% 
% figure
% loglog(hz,Pxx_HbT,'k')
% hold on
% loglog(hz,Pxx_Calcium,'m')
% xlabel('Frequency(Hz)')
% ylabel('(\DeltaF/F%)^2/Hz or (\Delta\muM)^2/Hz')
% xlim([0.0048 5])
% legend('HbT','jRGECO1a','location','southwest')
% title({'Awake Power Spectra Density for ','filtered and downsampled data at (28,72)'})
% 
% 
% figure
% plot(t,h_regions(9,:))
% xlabel('Time(s)')
% ylabel('(\Delta\muM)/(\DeltaF/F%)')
% title('h for one run of one awake mouse')
% xlim([-3 27])


%%
clearvars -except excelFile runs numReg AtlasSeeds samplingRate freq
excelRows = [202 195 204 230 234 240];
for excelRow = excelRows
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    AtlasMask = AtlasSeeds>0;
    mask = xform_isbrain.*AtlasMask;
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        
        %1.) Filter 0.04-2Hz, downsample to 10 Hz
        HbT =  filterData(HbT,0.04,2,samplingRate);
        Calcium = filterData(Calcium,0.04,2,samplingRate);
        
        HbT = resample(HbT,freq,samplingRate,'Dimension',3); %resample to 10 Hz
        Calcium = resample(Calcium,freq,samplingRate,'Dimension',3); %resample to 10 Hz
        %2.) Reshape into 30 seconds
        HbT=reshape(HbT,128,128,30*freq,[]);
        Calcium=reshape(Calcium,128,128,30*freq,[]);
        
        %3.) Deconvolution
        tic
        h = nan(size(HbT));
        for nVy = 1: size(HbT,1)
            for nVx = 1: size(HbT,2)
                if mask(nVy,nVx)
                    for win=1:size(HbT,4)
                        pixHbT = tukeywin(length(squeeze(HbT(nVy,nVx,:,win))),.3).*squeeze(HbT(nVy,nVx,:,win)); %make sure these are column vectors!
                        pixCalcium = tukeywin(length(squeeze(Calcium(nVy,nVx,:,win))),.3).*squeeze(Calcium(nVy,nVx,:,win)); %make sure these are column vectors!
                        X = convmtx(pixCalcium,length(pixCalcium));% why calculating convolution matrix for input? 599*300?
                        X = X(1:length(pixCalcium),1:length(pixCalcium));% make it square?
                        [~,S,~]=svd(X);
                        h(nVy,nVx,:,win)= (X'*S*X+(S(1,1).^2)*.5*eye(length(pixCalcium))) \ (X'*S*[zeros(3*freq,1); pixHbT(1:end-3*freq)]);% why add 3s of zeros? Do we need to shift it?
                    end
                end
            end
        end
%         toc
%         %4.) Average across blocks
%         h_avg = mean(h,4);
%         h_avg = reshape(h_avg,size(h,1)*size(h,2),[]);
%         h_regions = nan(40,size(h,3));
%         %5.) Create regional average h_regions
%         AtlasSeeds = AtlasSeeds.*mask;
%         for reg = 1:numReg
%             ROI = AtlasSeeds == reg;
%             h_regions(reg,:) = mean(h_avg(ROI(:),:));
%         end
        t = (-3*freq:(30-3)*freq-1)/freq;
        saveName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NVC','.mat');
        save(fullfile(saveDir,saveName),'t','h')
    end
end

% HbT = reshape(HbT,128,128,[]);
% Calcium = reshape(Calcium,128,128,[]);
% 
% [Pxx_HbT,hz] = pwelch(squeeze(HbT(72,23,:)),[],[],[],10);
% [Pxx_Calcium,hz] = pwelch(squeeze(Calcium(72,23,:)),[],[],[],10);
% 
% figure
% loglog(hz,Pxx_HbT,'k')
% hold on
% loglog(hz,Pxx_Calcium,'m')
% xlabel('Frequency(Hz)')
% ylabel('(\DeltaF/F%)^2/Hz or (\Delta\muM)^2/Hz')
% xlim([0.0048 5])
% legend('HbT','jRGECO1a','location','southwest')
% title({'Anes Power Spectra Density for ','filtered and downsampled data at (28,72)'})
% 
% 
% figure
% plot(t,h_regions(9,:))
% xlabel('Time(s)')
% ylabel('(\Delta\muM)/(\DeltaF/F%)')
% title('h for one run of one anes mouse')
% xlim([-3 27])
% 
% figure
% subplot(2,1,1)
% yyaxis left
% plot((1:600)/10,squeeze(HbT(72,23,1:600)),'k')
% ylabel('\Delta\muM')
% ylim([-2 2])
% hold on
% yyaxis right
% plot((1:600)/10,squeeze(Calcium(72,23,1:600)),'m')
% ylim([-8 8])
% ylabel('\DeltaF/F%')
% xlabel('Time(s)')
% xlim([0 30])
% legend('HbT','jRGECO1a')
% title('Time Course for Filtered and Downsampled Signal')
% 
% subplot(2,1,2)
% plot(t,squeeze(h(72,23,:,1)),'k')
% title('HRF')
% xlabel('Time(s)')
% ylabel('(\Delta\muM)/(\DeltaF/F%)')
% xlim([-3 27])
% 
% figure
% subplot(3,1,1)
% plot((1:6000)/10,reshape(Calcium_regions(9,:,:),1,[]),'m')
% hold on
% plot((1:6000)/10,reshape(HbT_regions(9,:,:),1,[]),'k')
% xlabel('Time(s)')
% ylabel('\DeltaF/F% or \Delta\muM')
% title('Time course for barrel cortex')
% legend('jRGECO1a','HbT')
% subplot(3,1,2)
% plot((1:6000)/10,reshape(Calcium_regions(9,:,:),1,[]),'m')
% hold on
% plot((1:6000)/10,reshape(HbT_regions(9,:,:),1,[]),'k')
% xlabel('Time(s)')
% ylabel('\DeltaF/F% or \Delta\muM')
% title('Time course for barrel cortex')
% xlim([0 30])
% subplot(3,1,3)
% for ii = 1:20
%     plot((-30:300-31)/10,squeeze(h(9,ii,:)),'Color',[0.6 0.6 0.6])
%     hold on
% end
% plot((-30:300-31)/10,squeeze(h_regions(9,:)),'k')
% xlabel('Time(s)')
% ylabel('(\Delta\muM)/(\DeltaF/F%)')
% title('Hemodynamic response function')
% xlim([-3 27])
% sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)))