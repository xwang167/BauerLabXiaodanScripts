
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";




excelRows = [321:327]; %[181,183,185,228,232,236,195 202 204 230 234 

runs = 4:9;%321 1:3 was done


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

xform_WL = imresize(xform_WL,0.5);
mask = double(imresize(mask,0.5));
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
    if exist(fullfile(saveDir,maskName),'file')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    else
        maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    end
    
    load(fullfile(saveDir,maskName),'xform_isbrain')
    
    saveDir_new =  fullfile(saveDir,'FilterFirst');
     if ~exist(saveDir_new)
        mkdir(saveDir_new)
     end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb')
        
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
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
                tic
                [lagTime_Projection_Calcium_ISA,lagAmp_Projection_Calcium_ISA] = calcProjectionLag(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
                toc
                tic

                [lagTime_Projection_Calcium_Delta,lagAmp_Projection_Calcium_Delta] = calcProjectionLag(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
             toc
                save(fullfile(saveDir_new,processedName),'lagTime_Projection_Calcium_ISA','lagAmp_Projection_Calcium_ISA','lagTime_Projection_Calcium_Delta','lagAmp_Projection_Calcium_Delta');
                
                figure
                colormap jet
                subplot(2,2,1); imagesc(lagTime_Projection_FAD_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,2); imagesc(lagTime_Projection_FAD_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,3); imagesc(lagAmp_Projection_FAD_ISA,rLim);axis image off;h = colorbar;ylabel(h,'r');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,4); imagesc(lagAmp_Projection_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'FAD Projection Lag'))
                saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_ProjLag.png')));
                saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_ProjLag.fig')));
                
                figure;
                colormap jet
                subplot(2,2,1); imagesc(lagTime_Projection_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,2); imagesc(lagTime_Projection_Calcium_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,3); imagesc(lagAmp_Projection_Calcium_ISA,rLim);axis image off;h = colorbar;ylabel(h,'r');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,4); imagesc(lagAmp_Projection_Calcium_Delta,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'jRGECO1aCorr Projection Lag'))
                saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag.png')));
                saveas(gcf,fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag.fig')));
                
                
                close all
            end
            close all
        end
    end
end
