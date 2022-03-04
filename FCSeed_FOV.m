excelFile = 'L:\RGECO\RGECO.xlsx';
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
    'seedLocation_mice_FOV')
seedLocation_mice_FOV_R = seedLocation_mice_FOV;
seedLocation_mice_FOV_R(2,:) = 129-seedLocation_mice_FOV_R(2,:);

excelRows = 2:7;
[X,Y] = meshgrid(1:128,1:128);
radius = 3;
runs = 1:3;
FCSeedMatrix_L_FOV_mice = nan(160,160,18);
FCSeedMatrix_R_FOV_mice = nan(160,160,18);
numRun = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile('L:\RGECO\',recDate,processedName),'xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = gsr(squeeze(xform_jrgeco1aCorr),xform_isbrain);
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
        timetrace_seeds_L = nan(14999,160);
        timetrace_seeds_R = nan(14999,160);
        
        for ii = 1:160
            x1 = seedLocation_mice_FOV(2,ii);
            y1 = seedLocation_mice_FOV(1,ii);         
            ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
            ROI = ROI(:);
            if ~isnan(x1)||mean(xform_isbrain(ROI))==1
            temp = mean(xform_jrgeco1aCorr(ROI,:),1);
            temp = filterData(temp,0.4,4,25);
            timetrace_seeds_L(:,ii) = temp;
            end
            
            x2 = seedLocation_mice_FOV_R(2,ii);
            y2 = seedLocation_mice_FOV_R(1,ii);
            ROI = sqrt((X-x2).^2+(Y-y2).^2)<radius;
            ROI = ROI(:);
            if ~isnan(x1)||mean(xform_isbrain(ROI))==1
            temp2 = mean(xform_jrgeco1aCorr(ROI,:),1);
            temp2 = filterData(temp2,0.4,4,25);
            timetrace_seeds_R(:,ii) = temp2;
            end
        end
        FCSeedMatrix_L_FOV = nan(160);
        FCSeedMatrix_R_FOV = nan(160);
        for jj = 1:160
            for kk = 1:160
                FCSeedMatrix_L_FOV(jj,kk) = corr(timetrace_seeds_L(:,jj),...
                    timetrace_seeds_L(:,kk));
                
                FCSeedMatrix_R_FOV(jj,kk) = corr(timetrace_seeds_L(:,jj),...
                    timetrace_seeds_R(:,kk));
            end
        end
        save(fullfile('L:\RGECO',recDate,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'FCSeedMatrix','.mat')),...
            'FCSeedMatrix_L_FOV', 'FCSeedMatrix_R_FOV');
        FCSeedMatrix_L_FOV_mice(:,:,numRun) = atanh(FCSeedMatrix_L_FOV);
        FCSeedMatrix_R_FOV_mice(:,:,numRun) = atanh(FCSeedMatrix_R_FOV);
        numRun = numRun+ 1;
    end
end
FCSeedMatrix_L_FOV_mice = nanmean(FCSeedMatrix_L_FOV_mice,3);
FCSeedMatrix_R_FOV_mice = nanmean(FCSeedMatrix_R_FOV_mice,3);
save(fullfile('L:\RGECO\cat\R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake_FCSeedMatrix'),...
    'FCSeedMatrix_L_FOV_mice','FCSeedMatrix_R_FOV_mice')

 HomoFC_FOV= nan(128,128);
    for ii = 1:160
        x1 = seedLocation_mice_FOV(2,ii);
        y1 = seedLocation_mice_FOV(1,ii);
        if ~isnan(x1)
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        HomoFC_FOV(ROI) = FCSeedMatrix_R_FOV_mice(ii,ii);
        end
    end
