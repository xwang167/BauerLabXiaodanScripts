
close all;clear all;clc

import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";




excelRows =  [195 202 204 230 234 240];%[181,183,185,228,232,236];%321:327;

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
        if strcmp(sessionType,'fc')
            
            
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                
                %functionally relvenat brain organization (lag with respect to global signal)
                edgeLen =1;
                tZone = 4;
                
                ISA = [0.009 0.08];
                Delta = [0.4 4];
                validRange = -round(tZone*fs): round(tZone*fs);
                tLim_ISA = [-1.5 1.5];
                tLim_Delta = [-0.05 0.05];
                corrThr = 0;
                rLim = [-1 1];
                     
                disp('loading processed data') 
                load(fullfile(saveDir,processedName),'lagTime_Projection_FAD_Delta', 'lagAmp_Projection_FAD_Delta',...
                    'lagTime_Projection_FAD_ISA', 'lagAmp_Projection_FAD_ISA');
                      
                figure
                colormap jet
                subplot(2,2,1); imagesc(lagTime_Projection_FAD_ISA,[-1 1]); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,2); imagesc(lagTime_Projection_FAD_Delta,[-0.05 0.05]); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,3); imagesc(lagAmp_Projection_FAD_ISA,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                subplot(2,2,4); imagesc(lagAmp_Projection_FAD_Delta,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'FAD Projection Lag'))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_ProjLag.png')));
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_FAD_ProjLag.fig')));
                
                
            end
            close all
        end
    end
end


