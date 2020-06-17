
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";




excelRows = [185,228,232,236,181];%321:327;

runs = 1:3;


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

 xform_WL = imresize(xform_WL,0.5);
 mask = imresize(mask,0.5);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb')

        if strcmp(sessionType,'fc')


            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
                xform_total = squeeze(xform_datahb(:,:,1,:)+ xform_datahb(:,:,2,:));
                xform_total(isinf(xform_total)) = 0;
                xform_total(isnan(xform_total)) = 0;
                xform_FADCorr(isnan(xform_FADCorr)) = 0;
                xform_FADCorr(isinf(xform_FADCorr)) = 0;
                xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
                xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;


               
                %functionally relvenat brain organization (lag with respect to global signal)
                edgeLen =3;
                tZone = 4;
              
                ISA = [0.009 0.08];
                Delta = [0.4 4];
                validRange = -round(tZone*fs): round(tZone*fs);
                tLim_ISA = [-1.5 1.5];
                tLim_Delta = [-0.05 0.05];
                corrThr = 0.3;
             rLim = [-1 1];
             tic;
                [lagTime_Projection_Calcium_ISA,lagAmp_Projection_Calcium_ISA] = calcProjectionLag(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                toc;
                [lagTime_Projection_FAD_ISA,lagAmp_Projection_FAD_ISA] = calcProjectionLag(xform_FADCorr,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                [lagTime_Projection_total_ISA,lagAmp_Projection_total_ISA] = calcProjectionLag(xform_total,ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                save(fullfile(saveDir,processedName),'lagTime_Projection_total_ISA', 'lagAmp_Projection_total_ISA','lagTime_Projection_FAD_ISA', 'lagAmp_Projection_FAD_ISA','lagTime_Projection_Calcium_ISA','lagAmp_Projection_Calcium_ISA','-append');


                figure;
                colormap jet
                subplot(2,3,1); imagesc(lagTime_Projection_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,2); imagesc(lagTime_Projection_FAD_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,3); imagesc(lagTime_Projection_total_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,4); imagesc(lagAmp_Projection_Calcium_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,5); imagesc(lagAmp_Projection_FAD_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,6); imagesc(lagAmp_Projection_total_ISA,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Projection Lag, ISA'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_ProjLag_ISA.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_ProjLag_ISA.fig')));

tic;
                [lagTime_Projection_total_Delta,lagAmp_Projection_total_Delta] = calcProjectionLag(xform_total,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
                toc;
                [lagTime_Projection_FAD_Delta,lagAmp_Projection_FAD_Delta] = calcProjectionLag(xform_FADCorr,Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
                [lagTime_Projection_Calcium_Delta,lagAmp_Projection_Calcium_Delta] = calcProjectionLag(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);

                save(fullfile(saveDir,processedName),'lagTime_Projection_total_Delta', 'lagAmp_Projection_total_Delta','lagTime_Projection_FAD_Delta', 'lagAmp_Projection_FAD_Delta','lagTime_Projection_Calcium_Delta','lagAmp_Projection_Calcium_Delta','-append');


                figure;
                colormap jet
                subplot(2,3,1); imagesc(lagTime_Projection_Calcium_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,2); imagesc(lagTime_Projection_FAD_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,3); imagesc(lagTime_Projection_total_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,4); imagesc(lagAmp_Projection_Calcium_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,5); imagesc(lagAmp_Projection_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                subplot(2,3,6); imagesc(lagAmp_Projection_total_Delta,rLim); axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'Projection Lag, Delta'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_ProjLag_Delta.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_ProjLag_Delta.fig')));
                close all
            end
            close all
        end
    end
end
