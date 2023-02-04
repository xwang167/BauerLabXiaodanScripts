clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
startInd = 2;
freqLow = 0.02;
calMax = 8;
hbMax  = 2.5;
FADMax = 1;
hrfMax = 0.2;
mrfMax = 0.00;
samplingRate = 25;
freq_new     = 250;
t_kernel = 30;
t=linspace(0,t_kernel-1/freq_new,t_kernel*freq_new);
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
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
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
%%
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = 1:3
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
        HbT     = filterData(HbT,   freqLow,2,samplingRate);
        FAD     = filterData(FAD,   freqLow,2,samplingRate);
        Calcium = filterData(Calcium,freqLow,2,samplingRate);
        
        % Reshape into 30 seconds
        HbT     = reshape(HbT    ,128,128,t_kernel*samplingRate,[]);
        FAD     = reshape(FAD    ,128,128,t_kernel*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,t_kernel*samplingRate,[]);
        
        % Initialize Gamma NVC and NMC parameters
        for region = 1:50
            for h = {'NVC','NMC'}
                eval(strcat('T_',  h{1},' = zeros(21-startInd,50);'))
                eval(strcat('W_',  h{1},' = zeros(21-startInd,50);'))
                eval(strcat('A_',  h{1},' = zeros(21-startInd,50);'))
                eval(strcat('r_',  h{1},' = zeros(21-startInd,50);'))
                eval(strcat('r2_', h{1},' = zeros(21-startInd,50);'))
                eval(strcat('obj_',h{1},' = zeros(21-startInd,50);'))
            end
            eval(strcat('hemoPred = zeros(21-startInd,t_kernel*freq_new,50);'))
            eval(strcat('FADPred  = zeros(21-startInd,t_kernel*freq_new,50);'))
        end
        
        jj = 1;
        tic
        for ii = startInd:20
            
            % reshape for each window
            HbT_temp     = reshape(HbT    (:,:,:,ii),128*128,[]);
            FAD_temp     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_temp = reshape(Calcium(:,:,:,ii),128*128,[]);
            
            %% Calculate Gamma NVC
            for region = 1:50
                % mean signal over regions
                mask_region = zeros(128,128);
                mask_region(mask == region) = 1;
                mask_region = logical(mask_region);
                regHbT     = mean(HbT_temp    (mask_region(:),:));
                regCalcium = mean(Calcium_temp(mask_region(:),:));
                % Upsample to 250Hz
                regHbT     = resample(regHbT    ,freq_new,samplingRate);
                regCalcium = resample(regCalcium,freq_new,samplingRate);
                
                % Filter again from 0.02 to 2 Hz
                regHbT     = filterData(regHbT    ,freqLow,2,freq_new);
                regCalcium = filterData(regCalcium,freqLow,2,freq_new);
                
                % Gamma fit
                options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
                he = HemodynamicsError(t,regCalcium,regHbT);
                fcn = @(param)he.fcn(param);
                [x,regHrfParam,obj,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.6,1.8,0.005],[0.2,0.3,0.0005],[2,3,0.05],options)'); %T, W, A -- guess, lower bound, upper bound
                HRF = hrfGamma(t,regHrfParam(1),regHrfParam(2),regHrfParam(3)); % %T, W, A
                regHemoPred = conv(regCalcium,HRF);
                regHemoPred = regHemoPred(1:length(regCalcium));
                hemoPred(jj,:,region)= regHemoPred;
                T_NVC(jj,region)     = regHrfParam(1);
                W_NVC(jj,region)     = regHrfParam(2);
                A_NVC(jj,region)     = regHrfParam(3);
                r_NVC(jj,region)     = corr(regHemoPred',regHbT');
                r2_NVC(jj,region)    = 1-sumsqr(regHbT-regHemoPred)/sumsqr(regHbT-mean(regHbT));
                obj_NVC(jj,region)   = obj;              
                figure('units','normalized','outerposition',[0 0 1 1])
                subplot(2,2,1)
                imagesc(mask_region)
                axis image off
                title(parcelnames{region})
                
                subplot(2,2,2)
                plot((1:t_kernel*freq_new)/freq_new,regHbT,'k')
                ylabel('\Delta\muM')
                ylim([-hbMax hbMax])
                hold on
                yyaxis right
                plot((1:t_kernel*freq_new)/freq_new,regCalcium,'m')
                legend('HbT','jRGECO1a')
                ylim([-calMax calMax])
                ylabel('\DeltaF/F%')
                xlabel('Time(s)')
                title(strcat('Time Course for',{' '},parcelnames{region}))
                grid on
                
                subplot(2,2,3)
                plot(t,HRF)
                xlim([0 10])
                %ylim([-hrfMax hrfMax])
                ylabel('\Delta\muM/\DeltaF/F%')
                xlabel('Time(s)')
                title(strcat('HRF for',{' '},parcelnames{region}))
                grid on
                
                subplot(2,2,4)
                plot((1:t_kernel*freq_new)/freq_new,regHbT,'k')
                hold on
                plot((1:t_kernel*freq_new)/freq_new,regHemoPred,'Color',[0 0.5 0])
                xlabel('Time(s)')
                ylabel('\Delta\muM')
                legend('Actual HbT','Predicted HbT')
                title(strcat('r = ',num2str(r_NVC(jj,region))))
                grid on
                
                sgtitle(strcat('HRF for Region',{' '},parcelnames{region},',',{' '},num2str(freqLow),'-2Hz, ',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                if ~exist(fullfile(saveDir,'Gamma_NVC'))
                    mkdir(fullfile(saveDir,'Gamma_NVC'))
                end
                saveName =  fullfile(saveDir,'Gamma_NVC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',parcelnames{region},'-NoGSR-HRF'));
                saveas(gcf,strcat(saveName,'.fig'))
                saveas(gcf,strcat(saveName,'.png'))

                 clear regHbT regCalcium
            end
            clear HbT_temp
            
            %% Calculate Gamma NMC
            for region = 1:50
                % mean signal over regions
                regFAD     = mean(FAD_temp    (mask_region(:),:));
                regCalcium = mean(Calcium_temp(mask_region(:),:));
                % Upsample to 250Hz
                regFAD     = resample(regFAD    ,freq_new,samplingRate);
                regCalcium = resample(regCalcium,freq_new,samplingRate);
                
                % Filter again from 0.02 to 2 Hz
                regFAD    = filterData(regFAD    ,freqLow,2,freq_new);
                regCalcium = filterData(regCalcium,freqLow,2,freq_new);
                
                % Gamma fit
                options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
                he = HemodynamicsError(t,regCalcium,regFAD);
                fcn = @(param)he.fcn(param);
                [x,regMrfParam,obj,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.1,0.02,0.002],[0.004,0.004,0.0005],[0.6,1.2,0.02],options)'); %T, W, A -- guess, lower bound, upper bound
                MRF = hrfGamma(t,regMrfParam(1),regMrfParam(2),regMrfParam(3)); % %T, W, A
                regFADPred = conv(regCalcium,MRF);
                regFADPred = regFADPred(1:length(regCalcium));
                FADPred(jj,:,region) = regFADPred;
                T_NMC(jj,region)     = regHrfParam(1);
                W_NMC(jj,region)     = regHrfParam(2);
                A_NMC(jj,region)     = regHrfParam(3);
                r_NMC(jj,region)     = corr(regHemoPred',regHbT');
                r2_NMC(jj,region)    = 1-sumsqr(regHbT-regHemoPred)/sumsqr(regHbT-mean(regHbT));
                obj_NMC(jj,region)   = obj;
               
                
                figure('units','normalized','outerposition',[0 0 1 1])
                subplot(2,2,1)
                imagesc(mask_region)
                axis image off
                title(parcelnames{region})
                grid on
                
                subplot(2,2,2)
                plot((1:t_kernel*freq_new)/freq_new,regFAD,'g')
                ylabel('\DeltaF/F%')
                ylim([-FADMax FADMax])
                hold on
                yyaxis right
                plot((1:t_kernel*freq_new)/freq_new,regCalcium,'m')
                legend('FAD','jRGECO1a')
                ylim([-calMax calMax])
                ylabel('\DeltaF/F%')
                xlabel('Time(s)')
                title(strcat('Time Course for',{' '},parcelnames{region}))
                grid on
                
                subplot(2,2,3)
                plot(t,MRF)
                xlim([0 1])
                %ylim([-mrfMax mrfMax])
                ylabel('\DeltaF/F%/\DeltaF/F%')
                xlabel('Time(s)')
                title(strcat('MRF for',{' '},parcelnames{region}))
                grid on
                
                subplot(2,2,4)
                plot((1:t_kernel*freq_new)/freq_new,regFAD,'g')
                hold on
                plot((1:t_kernel*freq_new)/freq_new,regFADPred,'k')
                xlabel('Time(s)')
                ylabel('\DeltaF/F%')
                legend('Actual FAD','Predicted FAD')
                
                title(strcat('r = ',num2str(r_NMC(jj,region))))
                ylim([-FADMax FADMax])
                grid on
                
                sgtitle(strcat('MRF for Region',{' '},parcelnames{region},',',{' '},num2str(freqLow),'-2Hz, ',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
                if ~exist(fullfile(saveDir,'Gamma_NMC'))
                    mkdir(fullfile(saveDir,'Gamma_NMC'))
                end
                saveName =  fullfile(saveDir,'Gamma_NMC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-',rparcelnames{region},'-NoGSR-MRF'));
                saveas(gcf,strcat(saveName,'.fig'))
                saveas(gcf,strcat(saveName,'.png'))
                clear regFAD regCalcium               
            end
            clear FAD_temp Calcium_temp
            close all
            jj = jj +1;
        end
        % make directory
        saveName = fullfile(saveDir,'Gamma_NVC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_NVC.mat'));
        if ~exist(fullfile(saveDir,'Gamma_NVC'))
            mkdir(fullfile(saveDir,'Gamma_NVC'))
        end
        % save
        if exist(saveName,'file')
            save(saveName,'hemoPred','T_NVC','W_NVC','A_NVC','r_NVC','r2_NVC','obj_NVC','-append')
        else
            save(saveName,'hemoPred','T_NVC','W_NVC','A_NVC','r_NVC','r2_NVC','obj_NVC')
        end
        saveName = fullfile(saveDir,'Gamma_NMC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_NMC.mat'));
        if ~exist(fullfile(saveDir,'Gamma_NMC'))
            mkdir(fullfile(saveDir,'Gamma_NMC'))
        end
        % save
        if exist(saveName,'file')
            save(saveName,'hemoPred','T_NMC','W_NMC','A_NMC','r_NMC','r2_NMC','obj_NMC','-append')
        else
            save(saveName,'hemoPred','T_NMC','W_NMC','A_NMC','r_NMC','r2_NMC','obj_NMC')
        end
        
        toc
    end
end


