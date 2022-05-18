import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236];% 202 195 204 230 234 240];
runs = 1;%
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
bad_peakNum = [];

bad_peaks_T = [];
bad_nopeaks_T = [];

bad_r = [];
bad_peaks_r = [];
bad_nopeaks_r = [];

bad_lag = [];
bad_peaks_lag = [];
bad_nopeaks_lag = [];

bad_lagCorr = [];
bad_peaks_lagCorr = [];
bad_nopeaks_lagCorr = [];

good_peakNum = [];

good_peaks_T = [];
good_nopeaks_T = [];

good_r = [];
good_peaks_r = [];
good_nopeaks_r = [];

good_lag = [];
good_peaks_lag = [];
good_nopeaks_lag = [];

good_lagCorr = [];
good_peaks_lagCorr = [];
good_nopeaks_lagCorr = [];

fs =5;
edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = 0: round(tZone*fs);
tLim = [0 2];
rLim = [-1 1];

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
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    systemType = excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        maskDir = fullfile(rawdataloc,recDate);
    else
        maskDir = saveDir;
    end
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = logical(mask_new.*xform_isbrain);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        %filter
        Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);
        Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);
        
        HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
        clear Hb_filter
        HbT_filter = squeeze(HbT_filter);
        
        %%reshape
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        
        %downsample
        Calcium_filter=resample(Calcium_filter',fs,sessionInfo.framerate)';
        HbT_filter=resample(HbT_filter',fs,sessionInfo.framerate)';
        
        % reshape
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        
        %time length for HRF
        time_epoch=15;
        t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(fs/sessionInfo.framerate));%% force it to be 5 hz
        options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);
        mask = logical(mask_new.*xform_isbrain);
        for ii = 1:128
            for jj = 1:128
                range_peaks = [];
                if mask(ii,jj)
                    pixHemo = squeeze(HbT_filter(ii,jj,:))'*10^6;
                    pixNeural = squeeze(Calcium_filter(ii,jj,:))'*100;
                    he = HemodynamicsError(t,pixNeural,pixHemo);
                    fcn = @(param)he.fcn(param);
                    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
                    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                    
                    pixHemoPred = conv(pixNeural,pixelHrf);
                    pixHemoPred = pixHemoPred(1:numel(pixNeural));
                    r = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                    [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                        reshape(pixHemo,1,1,[]),reshape(pixNeural,1,1,[]),edgeLen,validRange,corrThr, true,true);
                    lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                    T = pixHrfParam(1);
                    
                    if T == 0.2
                        bad_lag = [bad_lag,lagTimeTrial_HbTCalcium];
                        bad_lagCorr = [bad_lagCorr,lagAmpTrial_HbTCalcium];
                        bad_r = [bad_r,r];
                        [~,locs] = findpeaks(pixHemo,'MinPeakProminence',6);
                        
                        bad_peakNum = [bad_peakNum,length(locs)];
                        
                        %with peaks
                        if ~isempty(locs)
                            for ll = 1:length(locs)
                                if locs(ll)+30>length(pixHemo)
                                    endInd = length(pixHemo);
                                else
                                    endInd = locs(ll)+30;
                                end
                                
                                if locs(ll)-30<1
                                    startInd = 1;
                                else
                                    startInd = locs(ll)-30;
                                end
                                range_peaks = [range_peaks,startInd:endInd];
                            end
                            
                            trace_peak_calcium = pixNeural(range_peaks);
                            trace_peak_HbT = pixHemo(range_peaks);
                            
                            
                            he = HemodynamicsError(t,trace_peak_calcium,trace_peak_HbT);
                            fcn = @(param)he.fcn(param);
                            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
                            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                            
                            pixHemoPred = conv(trace_peak_calcium,pixelHrf);
                            pixHemoPred = pixHemoPred(1:numel(trace_peak_calcium));
                            r = corr(pixHemoPred',trace_peak_HbT');%real(atanh(corr(pixHemoPred',pixHemo')));
                            [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                reshape(trace_peak_HbT,1,1,[]),reshape(trace_peak_calcium,1,1,[]),edgeLen,validRange,corrThr, true,true);
                            lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                            bad_peaks_T = [bad_peaks_T,pixHrfParam(1)];
                            bad_peaks_r = [bad_peaks_r,r];
                            bad_peaks_lag = [bad_peaks_lag,lagTimeTrial_HbTCalcium];
                            bad_peaks_lagCorr = [bad_peaks_lagCorr,lagAmpTrial_HbTCalcium];
                            
                            
                            trace_nopeak_calcium = pixNeural;
                            trace_nopeak_HbT = pixHemo;
                            
                            trace_nopeak_calcium(range_peaks) = [];
                            trace_nopeak_HbT(range_peaks) = [];
                            he = HemodynamicsError(t,trace_nopeak_calcium,trace_nopeak_HbT);
                            fcn = @(param)he.fcn(param);
                            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
                            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                            
                            pixHemoPred = conv(trace_nopeak_calcium,pixelHrf);
                            pixHemoPred = pixHemoPred(1:numel(trace_nopeak_calcium));
                            r = corr(pixHemoPred',trace_nopeak_calcium');%real(atanh(corr(pixHemoPred',pixHemo')));
                            [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                reshape(trace_nopeak_HbT,1,1,[]),reshape(trace_nopeak_calcium,1,1,[]),edgeLen,validRange,corrThr, true,true);
                            lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                            bad_nopeaks_T = [bad_nopeaks_T,pixHrfParam(1)];
                            bad_nopeaks_r = [bad_nopeaks_r,r];
                            bad_nopeaks_lag = [bad_nopeaks_lag,lagTimeTrial_HbTCalcium];
                            bad_nopeaks_lagCorr = [bad_nopeaks_lagCorr,lagAmpTrial_HbTCalcium];
                            % no peaks
                        else
                            bad_peaks_T = [bad_peaks_T,0];
                            bad_peaks_r = [bad_peaks_r,0];
                            bad_peaks_lag = [bad_peaks_lag,0];
                            bad_peaks_lagCorr = [bad_peaks_lagCorr,0];
                            
                            bad_nopeaks_T = [bad_nopeaks_T,T];
                            bad_nopeaks_r = [bad_nopeaks_r,r];
                            bad_nopeaks_lag = [bad_nopeaks_lag,lagTimeTrial_HbTCalcium];
                            bad_nopeaks_lagCorr = [bad_nopeaks_lagCorr,lagAmpTrial_HbTCalcium];
                            
                            
                        end
                    end
                    
                    if T>0.6 && T<1.1
                        good_r = [good_r,r];
                        [~,locs] = findpeaks(pixHemo,'MinPeakProminence',6);
                        
                        good_peakNum = [good_peakNum,length(locs)];
                        good_lag = [good_lag,lagTimeTrial_HbTCalcium];
                        good_lagCorr = [good_lagCorr,lagAmpTrial_HbTCalcium];
                        %only peaks
                        if ~isempty(locs)
                            for ll = 1:length(locs)
                                if locs(ll)+30>length(pixHemo)
                                    endInd = length(pixHemo);
                                else
                                    endInd = locs(ll)+30;
                                end
                                
                                if locs(ll)-30<1
                                    startInd = 1;
                                else
                                    startInd = locs(ll)-30;
                                end
                                range_peaks = [range_peaks,startInd:endInd];
                            end
                            
                            trace_peak_calcium = pixNeural(range_peaks);
                            trace_peak_HbT = pixHemo(range_peaks);
                            
                            
                            he = HemodynamicsError(t,trace_peak_calcium,trace_peak_HbT);
                            fcn = @(param)he.fcn(param);
                            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
                            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                            
                            pixHemoPred = conv(trace_peak_calcium,pixelHrf);
                            pixHemoPred = pixHemoPred(1:numel(trace_peak_calcium));
                            r = corr(pixHemoPred',trace_peak_HbT');%real(atanh(corr(pixHemoPred',pixHemo')));
                            [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                reshape(trace_peak_HbT,1,1,[]),reshape(trace_peak_calcium,1,1,[]),edgeLen,validRange,corrThr, true,true);
                            lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                            good_peaks_T = [good_peaks_T,pixHrfParam(1)];
                            good_peaks_r = [good_peaks_r,r];
                            good_peaks_lag = [good_peaks_lag,lagTimeTrial_HbTCalcium];
                            good_peaks_lagCorr = [good_peaks_lagCorr,lagAmpTrial_HbTCalcium];
                            
                            
                            trace_nopeak_calcium = pixNeural;
                            trace_nopeak_HbT = pixHemo;
                            
                            trace_nopeak_calcium(range_peaks) = [];
                            trace_nopeak_HbT(range_peaks) = [];
                            he = HemodynamicsError(t,trace_nopeak_calcium,trace_nopeak_HbT);
                            fcn = @(param)he.fcn(param);
                            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
                            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                            
                            pixHemoPred = conv(trace_nopeak_calcium,pixelHrf);
                            pixHemoPred = pixHemoPred(1:numel(trace_nopeak_calcium));
                            r = corr(pixHemoPred',trace_nopeak_HbT');%real(atanh(corr(pixHemoPred',pixHemo')));
                            [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
                                reshape(trace_nopeak_HbT,1,1,[]),reshape(trace_nopeak_calcium,1,1,[]),edgeLen,validRange,corrThr, true,true);
                            lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
                            good_nopeaks_T = [good_nopeaks_T,pixHrfParam(1)];
                            good_nopeaks_r = [good_nopeaks_r,r];
                            good_nopeaks_lag = [good_nopeaks_lag,lagTimeTrial_HbTCalcium];
                            good_nopeaks_lagCorr = [good_nopeaks_lagCorr,lagAmpTrial_HbTCalcium];
                            
                        else
                            good_peaks_T = [good_peaks_T,0];
                            good_peaks_r = [good_peaks_r,0];
                            good_peaks_lag = [good_peaks_lag,0];
                            good_peaks_lagCorr = [good_peaks_lagCorr,0];
                            
                            good_nopeaks_T = [good_nopeaks_T,T];
                            good_nopeaks_r = [good_nopeaks_r,r];
                            good_nopeaks_lag = [good_nopeaks_lag,lagTimeTrial_HbTCalcium];
                            good_nopeaks_lagCorr = [good_nopeaks_lagCorr,lagAmpTrial_HbTCalcium];
                            
                            
                        end
                    end
                    
                    
                end
            end
        end
        
    end
end


%make plots
figure
C = [bad_peakNum, good_peakNum];
grp = [zeros(1,1332), ones(1,11268)];
boxplot(C,grp)
xticklabels({'Good','Bad'})
title('Number of Peaks, (Prominance>=6)')
xticklabels({'bad','good'})
figure
C = [bad_r, good_r];
grp = [zeros(1,1332), ones(1,11268)];
boxplot(C,grp)
xticklabels({'bad','good'})
title('r between pred and meas hb')

figure
C = [bad_lag, good_lag];
grp = [zeros(1,1332), ones(1,11268)];
boxplot(C,grp)
xticklabels({'bad','good'})
ylabel('peak lag(s)')
title('Peak lag between calcium and HbT')

figure
C = [bad_lagCorr, good_lagCorr];
grp = [zeros(1,1332), ones(1,11268)];
boxplot(C,grp)
xticklabels({'bad','good'})
title('Lagged correlation between calcium and HbT')

figure
C = [bad_nopeaks_T,bad_peaks_T,good_nopeaks_T,good_peaks_T];
grp = [zeros(1,1332), ones(1,1332), ones(1,11268)*2, ones(1,11268)*3];
boxplot(C,grp)
xticklabels({'bad no peaks','bad only peaks','good no peaks','good only peaks'})
title('Time to peak')

figure
C = [bad_nopeaks_r,bad_peaks_r,good_nopeaks_r,good_peaks_r];
grp = [zeros(1,1332), ones(1,1332), ones(1,11268)*2, ones(1,11268)*3];
boxplot(C,grp)
xticklabels({'bad no peaks','bad only peaks','good no peaks','good only peaks'})
title('Correlation coefficient between pred and meas HbT')

figure
C = [bad_nopeaks_lag,bad_peaks_lag,good_nopeaks_lag,good_peaks_lag];
grp = [zeros(1,1332), ones(1,1332), ones(1,11268)*2, ones(1,11268)*3];
boxplot(C,grp)
xticklabels({'bad no peaks','bad only peaks','good no peaks','good only peaks'})
title('Peak Lag')

figure
C = [bad_nopeaks_lagCorr,bad_peaks_lagCorr,good_nopeaks_lagCorr,good_peaks_lagCorr];
grp = [zeros(1,1332), ones(1,1332), ones(1,11268)*2, ones(1,11268)*3];
boxplot(C,grp)
xticklabels({'bad no peaks','bad only peaks','good no peaks','good only peaks'})
title('Lagged Correaltion')