 
 clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [202 195 204 230 234 240];
runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
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
        
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);
        
        Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);
        
        HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
        clear Hb_filter
        HbT_filter = squeeze(HbT_filter);
        
        Calcium_filter = reshape(Calcium_filter,128*128,[]);
        HbT_filter = reshape(HbT_filter,128*128,[]);
        %downsample
        Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
        HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';
        
        % reshape
        
        Calcium_filter = reshape(Calcium_filter,128,128,[]);
        HbT_filter = reshape(HbT_filter,128,128,[]);
        time_epoch=15;
        t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
        hrfParam = nan(128,128,3);
        T = nan(128,128);
        W = nan(128,128);
        A = nan(128,128);
        objValues = nan(128,128);
        r = nan(128,128);
        r2 = nan(128,128);
        mask = reshape(mask,128,128);
        
        options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);
        
        for xInd = 1:size(HbT_filter,2)
            for yInd = 1:size(HbT_filter,1)
                if mask(yInd,xInd)
                    pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
                    pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
                    %t = (0:25)./25;
                    %t = (0:750)./25;
                    %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
                    he = HemodynamicsError(t,pixNeural,pixHemo);
                    %             worstErr = sum(pixHemo.^2);
                    %             options.TolFun = worstErr*0.01;
                    %fcn = @(param)he.fcn(param);
                    fcn = @(param)he.fcn(param);
                    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
                    
                    
                    %             tMin = 0.0625; tMax = 4; tNum = 64;
                    %             wMin = 0.125; wMax = 6; wNum = 48;
                    %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
                    %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
                    %             y = zeros(size(X1));
                    %             for i = 1:numel(X1)
                    %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
                    %             end
                    %             [~,I] = min(y(:));
                    %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
                    
                    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                    
                    pixHemoPred = conv(pixNeural,pixelHrf);
                    pixHemoPred = pixHemoPred(1:numel(pixNeural));
                    
                    hrfParam(yInd,xInd,:) = pixHrfParam;
                    hemoPred(yInd,xInd,:) = pixHemoPred;
                    objValues(yInd,xInd) = obj_val;
                    
                    r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                    r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                    
                    %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
                end
            end
        end
        T(:,:) = hrfParam(:,:,1);
        W(:,:) = hrfParam(:,:,2);
        A(:,:) = hrfParam(:,:,3);
        
        if exist(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jonah','.mat')),'file')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jonah','.mat')),...
                'T','W','A','r','r2','hemoPred','objValues','-append')
        else
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jonah','.mat')),...
                'T','W','A','r','r2','hemoPred','objValues','-v7.3')
        end
        
        figure
        subplot(2,3,1)
        imagesc(T,[0 2])
        axis image off
        colorbar
        colormap jet
        title('T(s)')
        
        subplot(2,3,2)
        imagesc(W,[0 3])
        axis image off
        colormap jet
        title('W(s)')
        colorbar
        
        
        subplot(2,3,3)
        imagesc(A,[0 0.3])
        axis image off
        colormap jet
        title('A((\Delta\muM)/(\DeltaF/F%))')
        colorbar
        
        
        subplot(2,3,4)
        imagesc(r,[-1 1])
        axis image off
        colormap jet
        title('r')
        colorbar
        
        subplot(2,3,5)
        imagesc(r2,[0 1])
        axis image off
        colormap jet
        title('R^2')
        colorbar
        
        subplot(2,3,6)
        imagesc(objValues,[0 3500])
        axis image off
        colormap jet
        title('Objective Value')
        colorbar
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_jonha.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumHbT_GammaFit_jonah.fig')));  

    end
end