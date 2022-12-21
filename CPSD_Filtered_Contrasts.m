clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
samplingRate =25;
load('AtlasandIsbrain.mat','AtlasSeeds')
mask_barrel = AtlasSeeds==9;


for excelRow = [181,183,185,228,232,236 202 195 204 230 234 240]
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\Barrel_CPSD'),'dir')
        mkdir(strcat(saveDir,'\Barrel_CPSD'))
    end
    for n = 1:3
        disp(strcat(mouseName,', run#',num2str(n)))
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
        maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
            
        else
            maskDir = saveDir;
            maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
            load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain')
        end
        HbT =     squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        FAD =     squeeze(xform_FADCorr)*100; % convert to DeltaF/F%
        clear xform_FADCorr
        Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        % Pad to full 10 min
        HbT    (:,:,end+1) = HbT    (:,:,end);
        FAD    (:,:,end+1) = FAD    (:,:,end);
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Filter
        HbT     = filterData(HbT,    0.02,2,samplingRate);
        FAD     = filterData(FAD,    0.02,2,samplingRate);
        Calcium = filterData(Calcium,0.02,2,samplingRate);
        % Reshape into 30 seconds
        HbT     = reshape(HbT,    128,128,120*samplingRate,[]);
        FAD     = reshape(FAD,    128,128,120*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,120*samplingRate,[]);
        Pxx_CalciumFAD = zeros(513,5);
        Pxx_CalciumHbT = zeros(513,5);
        Pxx_FADHbT     = zeros(513,5);
        for ii = 1:5
            
            % reshape
            HbT_barrel     = reshape(HbT    (:,:,:,ii),128*128,[]);
            FAD_barrel     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_barrel = reshape(Calcium(:,:,:,ii),128*128,[]);
            
            % Barrel only
            HbT_barrel     = mean(HbT_barrel    (mask_barrel(:),:));
            FAD_barrel     = mean(FAD_barrel    (mask_barrel(:),:));
            Calcium_barrel = mean(Calcium_barrel(mask_barrel(:),:));
            
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(3,1,1)
            [Pxx_CalciumFAD(:,ii),hz] = cpsd(Calcium_barrel,FAD_barrel,[],[],[],samplingRate);
                                        cpsd(Calcium_barrel,FAD_barrel,[],[],[],samplingRate)
            title('Calcium and FAD')
            xlim([0 4])
            
            subplot(3,1,2)
            Pxx_CalciumHbT(:,ii) = cpsd(Calcium_barrel,HbT_barrel,[],[],[],samplingRate); 
                                   cpsd(Calcium_barrel,HbT_barrel,[],[],[],samplingRate)
            title('Calcium and HbT')
            xlim([0 4])
            
            subplot(3,1,3)
            Pxx_FADHbT(:,ii) = cpsd(FAD_barrel(:,ii),HbT_barrel,[],[],[],samplingRate);
                               cpsd(FAD_barrel(:,ii),HbT_barrel,[],[],[],samplingRate)
            title('FAD and HbT')
            xlim([0 4])
            
            sgtitle(strcat('Welch Cross power spectral density, ',mouseName,' Run #',num2str(n),', Segment #',num2str(ii)))
            saveName =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-segment#',num2str(ii),'-Barrel-CPSD'));
            saveas(gcf,strcat(saveName,'.fig'))
            saveas(gcf,strcat(saveName,'.png'))
            close all
        end
        clear Calcium FAD HbT
        save(strcat(saveName,'.mat'),'hz','Pxx_CalciumFAD','Pxx_CalciumHbT','Pxx_FADHbT')
    end
end

