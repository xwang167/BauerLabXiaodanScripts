excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [183 ];

T_CalciumFAD_2min = nan(128,128,5);
W_CalciumFAD_2min = nan(128,128,5);
A_CalciumFAD_2min= nan(128,128,5);
r_CalciumFAD_2min = nan(128,128,5);
r2_CalciumFAD_2min = nan(128,128,5);
hemoPred_CalciumFAD_2min= nan(128,128,3000,5);
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
n = 1;
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
      
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
        % clear xform_FADCorr
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        %clear xform_jrgeco1aCorr

        
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        FAD_filter = reshape(FAD_filter,128*128,[]);
%         %resample
%         Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
%         FAD_filter=resample(FAD_filter',5,sessionInfo.framerate)';
        
%         Calcium_filter = normRow(Calcium_filter);
%         FAD_filter = normRow(FAD_filter);
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        FAD_filter = reshape(FAD_filter,128,128,[]);
         t = (0:750)./25;
%         time_epoch=30;
%         t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
%    
         ii = 1;
         hemoPred_CalciumFAD_2min= nan(128,128,3000,5);
            tic
            [T_CalciumFAD_2min(:,:,ii),W_CalciumFAD_2min(:,:,ii),A_CalciumFAD_2min(:,:,ii),...
                r_CalciumFAD_2min(:,:,ii),r2_CalciumFAD_2min(:,:,ii),hemoPred_CalciumFAD_2min(:,:,:,ii)] ...
                = interSpeciesGammaFit_CalciumFAD_Mask(Calcium_filter(:,:,(ii-1)*120*25+1:ii*120*25),...
                FAD_filter(:,:,(ii-1)*120*25+1:ii*120*25),t,mask);
            toc
        

             figure
            subplot(2,3,4)
            imagesc(r_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([-1 1])
            axis image off
            colormap jet
            title('r')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,5)
            imagesc(r2_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 1])
            axis image off
            colormap jet
            title('R^2')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,1)
            imagesc(T_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.3])
            axis image off
            cmocean('ice')
            title('T(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,2)
            imagesc(W_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.06])
            axis image off
            cmocean('ice')
            title('W(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,3)
            imagesc(A_CalciumFAD_2min(:,:,1),'AlphaData',mask)
             cb=colorbar;
            caxis([0 1.4])
            axis image off
            cmocean('ice')
            title('A')
            set(gca,'FontSize',14,'FontWeight','Bold')           
suptitle('25 Hz')
            
            
            
            
            
            
            
            
            
          time_epoch=3;
         t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
            
                 hemoPred_CalciumFAD_2min= nan(128,128,600,5);
            tic
            [T_CalciumFAD_2min(:,:,ii),W_CalciumFAD_2min(:,:,ii),A_CalciumFAD_2min(:,:,ii),...
                r_CalciumFAD_2min(:,:,ii),r2_CalciumFAD_2min(:,:,ii),hemoPred_CalciumFAD_2min(:,:,:,ii)] ...
                = interSpeciesGammaFit_CalciumFAD_Mask(Calcium_filter(:,:,(ii-1)*120*5+1:ii*120*5),...
                FAD_filter(:,:,(ii-1)*120*5+1:ii*120*5),t,mask);
            toc
        

             figure
            subplot(2,3,4)
            imagesc(r_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([-1 1])
            axis image off
            colormap jet
            title('r')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,5)
            imagesc(r2_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 1])
            axis image off
            colormap jet
            title('R^2')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,1)
            imagesc(T_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.3])
            axis image off
            cmocean('ice')
            title('T(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,2)
            imagesc(W_CalciumFAD_2min(:,:,1),'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.06])
            axis image off
            cmocean('ice')
            title('W(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,3)
            imagesc(A_CalciumFAD_2min(:,:,1),'AlphaData',mask)
             cb=colorbar;
            caxis([0 1.4])
            axis image off
            cmocean('ice')
            title('A')
            set(gca,'FontSize',14,'FontWeight','Bold')           
suptitle('5Hz')