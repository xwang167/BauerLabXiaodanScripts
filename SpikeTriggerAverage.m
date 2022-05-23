import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236];% 202 195 204 230 234 240];
runs = 1:3;%
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')

HbO_spikes = [];
HbR_spikes = [];
HbT_spikes = [];
FAD_spikes = [];
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
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a','xform_FAD')
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1a(isinf(xform_jrgeco1a)) = 0;
        xform_jrgeco1a(isnan(xform_jrgeco1a)) = 0;
        xform_FAD(isinf(xform_FAD)) = 0;
        xform_FAD(isnan(xform_FAD)) = 0;
        
        calcium = squeeze(xform_jrgeco1a);
        FAD = squeeze(xform_FAD);
        clear xform_jrgeco1a xform_FAD
        HbT = squeeze(xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:));
        HbR = squeeze(xform_datahb(:,:,2,:));
        HbO = squeeze(xform_datahb(:,:,1,:));
        clear xform_datahb
        
        mask = logical(mask_new.*xform_isbrain);
        for ii = 1:128
            for jj = 1:128
                range_peaks = [];
                if mask(ii,jj)
                    pixHbT = squeeze(HbT(ii,jj,:))'*10^6;
                    pixHbO = squeeze(HbO(ii,jj,:))'*10^6;
                    pixHbR = squeeze(HbR(ii,jj,:))'*10^6;
                    pixNeural = squeeze(calcium(ii,jj,:))'*100;
                    pixFAD = squeeze(FAD(ii,jj,:))'*100;
                    [~,locs] = findpeaks(pixNeural,'MinPeakProminence',6);
                    %with peaks
                    if ~isempty(locs)
                        for ll = 1:length(locs)
                            if locs(ll)+250>length(pixHemo)
                                continue
                            else
                                endInd = locs(ll)+250;
                            end
                            
                            if locs(ll)-74<1
                                continue
                            else
                                startInd = locs(ll)-74;
                            end
                            peak_HbT = pixHbT(startInd:endInd);
                            peak_HbO = pixHbO(startInd:endInd);
                            peak_HbR = pixHbR(startInd:endInd);
                            peak_FAD = pixFAD(startInd:endInd);
                            peak_calcium = pixNeural(startInd:endInd);
                            
                            baseline_HbT = mean(peak_HbT(1:50));
                            baseline_HbO = mean(peak_HbO(1:50));
                            baseline_HbR = mean(peak_HbR(1:50));
                            baseline_FAD = mean(peak_FAD(1:50));
                            baseline_calcium = mean(peak_calcium(1:50));
                            
                            peak_HbT =  peak_HbT - baseline_HbT;
                            peak_HbO =  peak_HbO - baseline_HbO;
                            peak_HbR =  peak_HbR - baseline_HbR;
                            peak_FAD =  peak_FAD - baseline_FAD;
                            peak_calcium =  peak_calcium - baseline_calcium;
                            
                            HbT_spikes = cat(1,HbT_spikes,peak_HbT);
                            HbO_spikes = cat(1,HbO_spikes,peak_HbO);
                            HbR_spikes = cat(1,HbR_spikes,peak_HbR);
                            FAD_spikes = cat(1,FAD_spikes,peak_FAD);
                            calcium_spikes = cat(1,calcium_spikes,peak_calcium);
                        end
                    end
                    
                    % no peaks
                    
                end
            end
            
            
        end
    end
end



