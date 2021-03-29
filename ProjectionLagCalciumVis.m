import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 236;%[181,183,185,228,232];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
mask = double(imresize(mask,0.5));
xform_WL = imresize(xform_WL,0.5);

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

    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    if exist(fullfile(saveDir,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    else
        saveDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    end
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'lagTime_Projection_Calcium_ISA','lagTime_Projection_Calcium_Delta',...
            'lagAmp_Projection_Calcium_ISA','lagAmp_Projection_Calcium_Delta')
        tLim_ISA = [-1.5 1.5];
                tLim_Delta = [-0.2 0.2];
             
                rLim = [-1 1];
        figure;
        colormap jet
        subplot(2,2,1); imagesc(lagTime_Projection_Calcium_ISA,tLim_ISA); axis image off;h = colorbar;ylabel(h,'t(s)');title('ISA');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,2,2); imagesc(lagTime_Projection_Calcium_Delta,tLim_Delta); axis image off;h = colorbar;ylabel(h,'t(s)');title('Delta');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,2,3); imagesc(lagAmp_Projection_Calcium_ISA,rLim);axis image off;h = colorbar;ylabel(h,'r');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        subplot(2,2,4); imagesc(lagAmp_Projection_Calcium_Delta,rLim); axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'jRGECO1aCorr Projection Lag'))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_jRGECO1aCorr_ProjLag.fig')));
    end
end