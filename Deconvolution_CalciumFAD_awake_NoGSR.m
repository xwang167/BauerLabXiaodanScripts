clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
startInd = 2;
freqLow = 0.02;
freqHigh = 2;
calMax = 8;
FADMax = 1;
mrfMax = 0.05;
nVx = 128;
nVy = 128;
samplingRate =25;
freq = 250;
t_kernel = 30;
t = (-3*freq:(t_kernel-3)*freq-1)/freq;
load('AtlasandIsbrain.mat','AtlasSeeds')
mask_barrel = AtlasSeeds==9;


for excelRow = [181 183 185 228 232 236]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\Barrel_mrf'),'dir')
        mkdir(strcat(saveDir,'\Barrel_mrf'))
    end
    for n = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        %load contrasts
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_isbrain')
%         maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%         %load xform_isbrain
%         if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
%             load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
%             
%         else
%             maskDir = saveDir;
%             maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%             load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain')
%         end
        FAD = squeeze(xform_FADCorr)*100;% convert to DeltaF/F%
        clear xform_FADCorr
        FAD(:,:,end+1) = FAD(:,:,end);
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Filter 0.01-5Hz, resample to 250 Hz
        FAD =  filterData(FAD,freqLow,freqHigh,samplingRate);
        Calcium = filterData(Calcium,freqLow,freqHigh,samplingRate);
        
        %resample
        FAD = resample(FAD,freq,samplingRate,'Dimension',3); %resample to 250 Hz
        Calcium = resample(Calcium,freq,samplingRate,'Dimension',3); %resample to 250 Hz
        
        % filter again
        FAD =  filterData(FAD,freqLow,freqHigh,freq);
        Calcium = filterData(Calcium,freqLow,freqHigh,freq);
        
        % Reshape into 30 seconds
        FAD=reshape(FAD,128,128,t_kernel*freq,[]);
        Calcium=reshape(Calcium,128,128,t_kernel*freq,[]);
        
        r_Barrel_mrf_0p02_2 = zeros(1,21-startInd);
        mrf_Barrel_0p02_2 = zeros(21-startInd,length(Calcium));
        jj = 1;
        for ii = startInd:20
            
            % reshape
            FAD_barrel = reshape(FAD(:,:,:,ii),128*128,[]);
            Calcium_barrel = reshape(Calcium(:,:,:,ii),128*128,[]);
            
            % Barrel only
            FAD_barrel = mean(FAD_barrel(mask_barrel(:),:));
            Calcium_barrel = mean(Calcium_barrel(mask_barrel(:),:));
            
            % starting point to be zero
            FAD_barrel = tukeywin(length(FAD_barrel),.3).*squeeze(FAD_barrel');
            Calcium_barrel = tukeywin(length(Calcium_barrel),.3).*squeeze(Calcium_barrel');
            
            % mrf
            X = convmtx(Calcium_barrel,length(Calcium_barrel));% why calculating convolution matrix for input? 599*300?
            %X = X(151:450,:);
            X = X(1:length(Calcium_barrel),1:length(Calcium_barrel));% make it square?
            [~,S,~]=svd(X);
            lambda = 0.01;
            h_region_barrel = (X'*S*X+(S(1,1).^3)*lambda*eye(length(Calcium_barrel))) \ (X'*S*[zeros(3*freq,1); FAD_barrel(1:end-3*freq)]);% why add 3s of zeros? Do we need to shift it?
            mrf_Barrel_0p02_2(jj,:) = h_region_barrel;
            
            % Predicted FAD
            FAD_barrel_pred = conv(Calcium_barrel,h_region_barrel);
            FAD_barrel_pred = FAD_barrel_pred(1:(length(FAD_barrel)+3*freq));
            r_region_barrel = corr(FAD_barrel,FAD_barrel_pred(3*freq+1:end));
            r_Barrel_mrf_0p02_2(jj) = r_region_barrel;
            
            jj = jj+1;
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(2,2,1)
            plot((1:t_kernel*freq)/freq,FAD_barrel,'g')
            ylabel('\DeltaF/F%')
            ylim([-FADMax FADMax])
            hold on
            yyaxis right
            plot((1:t_kernel*freq)/freq,Calcium_barrel,'m')
            legend('FAD','jRGECO1a')
            ylim([-calMax calMax])
            ylabel('\DeltaF/F%')
            xlabel('Time(s)')
            title('Time Course for Barrel Cortex')
            
            subplot(2,2,2)
            plot(t,h_region_barrel)
            xlim([-3 10])
            %ylim([-mrfMax mrfMax])
            ylabel('\Delta\muM/\DeltaF/F%')
            xlabel('Time(s)')
            title('mrf for Barrel Cortex')

            subplot(2,2,3)
            yyaxis left
            plot((1:t_kernel*freq)/freq,FAD_barrel,'g')
            hold on
            yyaxis right
            plot((1:t_kernel*freq)/freq,FAD_barrel_pred(3*freq+1:3*freq+length(FAD_barrel)),'k')
            xlabel('Time(s)')
            ylabel('\DeltaF/F%')
            legend('Actual FAD','Predicted FAD')
            title(strcat('r = ',num2str(r_region_barrel)))
            
            sgtitle(strcat('mrf for Barrel Region, ',num2str(freqLow),'-',freqHigh,', ',' lambda = ',num2str(lambda),', ',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
            saveName =  fullfile(saveDir,'Barrel_mrf', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-Barrel-NoGSR-mrf'));
            saveas(gcf,strcat(saveName,'.fig'))
            saveas(gcf,strcat(saveName,'.png'))
            close all
        end
        
        save(fullfile(saveDir,'Barrel_mrf', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Barrel_mrf','.mat')),'r_Barrel_mrf_0p02_2','mrf_Barrel_0p02_2','-append')
    end
end

%% Averaged over r>0.6 only
totalNum = 0;
mrf_Barrel_0p02_2_0p6 = [];
miceName = [];
for excelRow = [181 183 185 228 232 236]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\Barrel_mrf'),'dir')
        mkdir(strcat(saveDir,'\Barrel_mrf'))
    end
    for n = 1:3
        load(fullfile(saveDir,'Barrel_mrf', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Barrel_mrf','.mat')),'r_Barrel_mrf_0p02_2','mrf_Barrel_0p02_2')
        totalNum = totalNum + length(r_Barrel_mrf_0p02_2);
        mrf_Barrel_0p02_2_0p6 = cat(1,mrf_Barrel_0p02_2_0p6,mrf_Barrel_0p02_2(r_Barrel_mrf_0p02_2>0.6,:));
    end
end
qualifiedNum = size(mrf_Barrel_0p02_2_0p6,1);
mrf_Barrel_0p02_2_0p6_median = median(mrf_Barrel_0p02_2_0p6);
save(strcat('L:\RGECO\cat\Barrel_mrf\',recDate,miceName,'-Barrel_mrf.mat'),'mrf_Barrel_0p02_2_0p6','qualifiedNum','totalNum');

[pks,locs,w,p] = findpeaks(mrf_Barrel_0p02_2_0p6_median,t,'MinPeakProminence',2e-9);
figure
plot_distribution_prctile(t,mrf_Barrel_0p02_2_0p6)
legend('25%-75%')
xlim([-3 10])
xlabel('Time(s)')
grid on
title(strcat(num2str(qualifiedNum),'/',num2str(totalNum),' has r>0.6, Median: T=',num2str(locs),'s, W=',num2str(w),'s, A=',num2str(pks)))

% Averaged across all 
totalNum = 0;
mrf_Barrel_0p02_2_mice = [];
r_Barrel_mrf_0p02_2_mice= [];
miceName = [];
for excelRow = [181 183 185 228 232 236]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);

    for n = 1:3
        load(fullfile(saveDir,'Barrel_mrf', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Barrel_mrf','.mat')),'mrf_Barrel_0p02_2')
        totalNum = totalNum + length(mrf_Barrel_0p02_2);
        mrf_Barrel_0p02_2_mice = cat(1,mrf_Barrel_0p02_2_mice,mrf_Barrel_0p02_2);
        r_Barrel_mrf_0p02_2_mice = [r_Barrel_mrf_0p02_2_mice,r_Barrel_mrf_0p02_2];
    end
end
mrf_Barrel_0p02_2_mice_median = median(mrf_Barrel_0p02_2_mice);
r_Barrel_mrf_0p02_2_mice_median = median(r_Barrel_mrf_0p02_2_mice);
save(strcat('L:\RGECO\cat\Barrel_mrf\',recDate,miceName,'-Barrel_mrf.mat'),'mrf_Barrel_0p02_2_mice','-append');

[pks,locs,w,p] = findpeaks(mrf_Barrel_0p02_2_mice_median,t,'MinPeakProminence',2e-9);
figure
plot_distribution_prctile(t,mrf_Barrel_0p02_2_mice)
legend('25%-75%')
xlim([-3 10])
xlabel('Time(s)')
grid on
title(strcat('Median: T=',num2str(locs),'s, W=',num2str(w),'s, A=',num2str(pks)', 'r=',num2str(r_Barrel_mrf_0p02_2_mice_median,'%4.2f')))



