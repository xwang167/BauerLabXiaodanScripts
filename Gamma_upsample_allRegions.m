clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
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
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat",'mask_new')
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
    for n = 1:3
        disp(strcat(mouseName,', run#',num2str(n)))
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr','xform_isbrain')
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

        % Initialize Gamma NVC and NMC parameters
        for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
            for h = {'NVC','NMC'}
                eval(strcat('T_',  h{1},'_',region{1},' = zeros(1,21-startInd);'))
                eval(strcat('W_',  h{1},'_',region{1},' = zeros(1,21-startInd);'))
                eval(strcat('A_',  h{1},'_',region{1},' = zeros(1,21-startInd);'))
                eval(strcat('r_',  h{1},'_',region{1},' = zeros(1,21-startInd);'))
                eval(strcat('r2_', h{1},'_',region{1},' = zeros(1,21-startInd);'))
                eval(strcat('obj_',h{1},'_',region{1},' = zeros(1,21-startInd);'))
            end
            eval(strcat('hemoPred_',region{1},' = zeros(21-startInd,t_kernel*freq_new);'))
            eval(strcat('FADPred_' ,region{1},' = zeros(21-startInd,t_kernel*freq_new);'))
        end

        jj = 1;
        tic
        for ii = startInd:20

            % reshape for each window
            HbT_temp     = reshape(HbT    (:,:,:,ii),128*128,[]);
            FAD_temp     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_temp = reshape(Calcium(:,:,:,ii),128*128,[]);

            %% Calculate Gamma NVC
            for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                % mean signal over regions
                eval(strcat('regHbT     = mean(HbT_temp    (mask_',region{1},'(:),:));'))
                eval(strcat('regCalcium = mean(Calcium_temp(mask_',region{1},'(:),:));'))
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
                eval(strcat('hemoPred_',region{1},'(jj,:)= regHemoPred;'))
                eval(strcat('T_NVC_'   ,region{1},'(jj)  = regHrfParam(1);'))
                eval(strcat('W_NVC_'   ,region{1},'(jj)  = regHrfParam(2);'))
                eval(strcat('A_NVC_'   ,region{1},'(jj)  = regHrfParam(3);'))
                eval(strcat('r_NVC_'   ,region{1},'(jj)  = corr(regHemoPred',char(39),',regHbT',char(39),');'))%real(atanh(corr(pixHemoPred',pixHemo')));
                eval(strcat('r2_NVC'   ,region{1},'(jj)  = 1-sumsqr(regHbT-regHemoPred)/sumsqr(regHbT-mean(regHbT));'))
                eval(strcat('obj_NVC_' ,region{1},'(jj)  = obj;'))%1 - var(pixHemoPred - pixHemo)/var(pixHemo);
                clear regHbT regCalcium

                % make directory
                saveName = fullfile(saveDir,'Gamma_NVC_Regions', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_NVC_Regions.mat'));
                if ~exist(fullfile(saveDir,'Gamma_NVC_Regions'))
                    mkdir(fullfile(saveDir,'Gamma_NVC_Regions'))
                end
                % save
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',...
                        char(39),'hemoPred_',region{1},char(39),',',...
                        char(39),'T_NVC_'    ,region{1},char(39),',',...
                        char(39),'W_NVC_'    ,region{1},char(39),',',...
                        char(39),'A_NVC_'    ,region{1},char(39),',',...
                        char(39),'r_NVC_'    ,region{1},char(39),',',...
                        char(39),'r2_NVC_'   ,region{1},char(39),',',...
                        char(39),'obj_NVC_'  ,region{1},char(39),',',...
                        char(39),'-append',char(39),')'))
                else
                    eval(strcat('save(',char(39),saveName,char(39),',',...
                        char(39),'hemoPred_',region{1},char(39),',',...
                        char(39),'T_NVC_'    ,region{1},char(39),',',...
                        char(39),'W_NVC_'    ,region{1},char(39),',',...
                        char(39),'A_NVC_'    ,region{1},char(39),',',...
                        char(39),'r_NVC_'    ,region{1},char(39),',',...
                        char(39),'r2_NVC_'   ,region{1},char(39),',',...
                        char(39),'obj_NVC_'  ,region{1},char(39),')'))
                end
            end
            clear HbT_temp

            %% Calculate Gamma NMC
            for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                % mean signal over regions
                eval(strcat('regFAD     = mean(FAD_temp    (mask_',region{1},'(:),:));'))
                eval(strcat('regCalcium = mean(Calcium_temp(mask_',region{1},'(:),:));'))
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
                eval(strcat('FADPred_',region{1},'(jj,:)= regFADPred;'))
                eval(strcat('T_NMC_'  ,region{1},'(jj)= regMrfParam(1);'))
                eval(strcat('W_NMC_'  ,region{1},'(jj)= regMrfParam(2);'))
                eval(strcat('A_NMC_'  ,region{1},'(jj)= regMrfParam(3);'))
                eval(strcat('r_NMC_'  ,region{1},'(jj)= corr(regFADPred',char(39),',regFAD',char(39),');'))%real(atanh(corr(pixHemoPred',pixHemo')));
                eval(strcat('r2_NMC_' ,region{1},'(jj)= 1-sumsqr(regFAD-regFADPred)/sumsqr(regFAD-mean(regFAD));'))
                eval(strcat('obj_NMC_',region{1},'(jj)= obj;'))%1 - var(pixHemoPred - pixHemo)/var(pixHemo);
                clear regFAD regCalcium

                % make directory
                saveName = fullfile(saveDir,'Gamma_NMC_Regions', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_NMC_Regions.mat'));
                if ~exist(fullfile(saveDir,'Gamma_NMC_Regions'))
                    mkdir(fullfile(saveDir,'Gamma_NMC_Regions'))
                end
                % save
                if exist(saveName,'file')
                    eval(strcat('save(',char(39),saveName,char(39),',',...
                        char(39),'FADPred_',region{1},char(39),',',...
                        char(39),'T_NMC_'    ,region{1},char(39),',',...
                        char(39),'W_NMC_'    ,region{1},char(39),',',...
                        char(39),'A_NMC_'    ,region{1},char(39),',',...
                        char(39),'r_NMC_'    ,region{1},char(39),',',...
                        char(39),'r2_NMC_'   ,region{1},char(39),',',...
                        char(39),'obj_NMC_'  ,region{1},char(39),',',...
                        char(39),'-append',char(39),')'))
                else
                    eval(strcat('save(',char(39),saveName,char(39),',',...
                        char(39),'FADPred_',region{1},char(39),',',...
                        char(39),'T_NMC_'    ,region{1},char(39),',',...
                        char(39),'W_NMC_'    ,region{1},char(39),',',...
                        char(39),'A_NMC_'    ,region{1},char(39),',',...
                        char(39),'r_NMC_'    ,region{1},char(39),',',...
                        char(39),'r2_NMC_'   ,region{1},char(39),',',...
                        char(39),'obj_NMC_'  ,region{1},char(39),')'))
                end
            end
            clear FAD_temp Calcium_temp
            jj = jj +1;
        end
        toc
    end
end


