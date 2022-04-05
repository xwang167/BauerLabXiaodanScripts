function GammaFit_wrapper(excelFile,excelRows)
%%Parallel Pool
poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end

%Loading Info
runsInfo = parseRuns_olddata(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char});
runNum=numel(runsInfo);

load(which('GoodWL.mat'),'xform_WL');
load(which('noVasculatureMask.mat'));

% Processing
for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    savename = fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run)...
        ,'_gamma_CalciumHbT_[1,1.5,0.2]_[0.01,0.3,0]_[2,3,1]')); %anmol- added a savename here to check if it has already run

    
    disp('loading processed data')
    saveDir_new = strcat('L:\RGECO\Kenny\', runInfo.recDate, '\');
    maskName = strcat(runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,'1-datafluor','.mat');

    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end

    %load Hb
    processedName = [runInfo.saveFilePrefix '_processed.mat'];
    load(processedName,'xform_datahb','xform_jrgeco1aCorr');
    xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
    xform_total(isinf(xform_total)) = 0;
    xform_total(isnan(xform_total)) = 0;
    %Load Calcium
    xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
    xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
    %        %Load FAD
    %         if ~isempty(runInfo.FADChInd)
    %             load(runInfo.saveFluorFile,'xform_dataFADCorr')
    %                 xform_dataFADCorr(isnan(xform_dataFADCorr)) = 0;
    %                 xform_dataFADCorr(isinf(xform_dataFADCorr)) = 0;
    %         end
    OGsize=size(xform_jrgeco1aCorr);
    disp('filtering')
    %Filtering
    onlyBrain=find(xform_isbrain==1);
    
    xform_jrgeco1aCorr = filterData(double(xform_jrgeco1aCorr),0.02,2,runInfo.samplingRate);
    xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,OGsize(1)*OGsize(2),[]);
    disp('calcium downsample')
    tic
    xform_jrgeco1aCorr=resample(xform_jrgeco1aCorr',5,runInfo.samplingRate)';
    toc
    
    xform_total = filterData(double(xform_total),0.02,2,runInfo.samplingRate);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
    xform_total = reshape(xform_total,OGsize(1)*OGsize(2),[]);
    disp('total downsample')
    tic
    xform_total=resample(xform_total',5,runInfo.samplingRate)';
    toc
    
    %         xform_datafluorCorr = normRow(xform_datafluorCorr);
    %         xform_total = normRow(xform_total);
    
    xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,OGsize(1),OGsize(2),[]);
    xform_total = reshape(xform_total,OGsize(1),OGsize(2),[]);
    
    %setting things up
    time_epoch=30;
    t= [0:1/runInfo.samplingRate:time_epoch]; %30 seconds7
    t=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(5/runInfo.samplingRate));%% force it to be 5 hz
    disp('Gamma Fitting')
    tic
    %[T,W,A,r,r2,hemoPred,objective_vals] = GammaFit(xform_jrgeco1aCorr*100,xform_total*10^6,t,xform_isbrain);
    [T,W,A,r,r2,hemoPred,objective_vals] = GammaFit_jp_xw(xform_jrgeco1aCorr*100,xform_total*10^6,t,xform_isbrain);
    time_taken=toc
    load('D:\OIS_Process\noVasculatureMask.mat')
    
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
    save(strcat(savename,'.mat'),'T','W','A','r','r2','hemoPred')
    mask = logical(mask_new.*xform_isbrain);
        figure
        subplot(2,3,1)
        imagesc(T,[0,2])
        colorbar
        axis image off
        colormap jet
        title('T(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,2)
        imagesc(W,[0 3])
        colorbar
        axis image off
        colormap jet
        title('W(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,3)
        imagesc(A,[0 0.5])
        colorbar
        axis image off
        colormap jet
        title('A')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,4)
        imagesc(r,[0 1])
        colorbar
        axis image off
        colormap jet
        title('r')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,5)
        imagesc(r2,[0 1])
        colorbar
        axis image off
        colormap jet
        title('R^2')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        saveas(gcf,strcat(savename,'.png'));
        saveas(gcf,strcat(savename,'.fig'));
        close all
    
end




end