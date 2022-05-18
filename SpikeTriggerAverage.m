import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236];% 202 195 204 230 234 240];
runs = 1;%
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')

HbT_spikes = [];
calcium_spikes = [];

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
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a')
        xform_jrgeco1a = squeeze(xform_jrgeco1a);
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1a(isinf(xform_jrgeco1a)) = 0;
        xform_jrgeco1a(isnan(xform_jrgeco1a)) = 0;
        
        calcium = squeeze(xform_jrgeco1a);  
        %clear xform_jrgeco1a
        HbT = squeeze(xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:));
        %clear xform_datahb
       
        mask = logical(mask_new.*xform_isbrain);
        for ii = 1:128
            for jj = 1:128
                range_peaks = [];
                if mask(ii,jj)
                    pixHemo = squeeze(HbT(ii,jj,1:1000))'*10^6;
                    pixNeural = squeeze(calcium(ii,jj,1:1000))'*100;
                    [~,locs] = findpeaks(pixNeural,'MinPeakProminence',6);
                                       
                    %with peaks
                    if ~isempty(locs)
                        for ll = 1:length(locs)
                            if locs(ll)+30>length(pixHemo)
                                locs(ll) = [];
                            else
                                endInd = locs(ll)+30;
                            end
                            
                            if locs(ll)-30<1
                                 locs(ll) = [];
                            else
                                startInd = locs(ll)-30;
                            end
                            peak_HbT = pixHemo(startInd:endInd);
                            peak_calcium = pixNeural(startInd:endInd);
                            baseline_HbT = mean(peak_HbT(1:10));
                            baseline_calcium = mean(peak_calcium(1:10));
                            peak_HbT =  peak_HbT - baseline_HbT;
                            peak_calcium =  peak_calcium - baseline_calcium;
                            HbT_spike = peakHbT;
                            calcium_spike = peak_calcium;
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
                        
                    end
                end
                
                
            end
        end
    end
    
end


