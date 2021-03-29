clear all
close all
clc
excelRows = [182,184,186,229,233,237];%[203,205,231,235,241];%182,184,186,203,   excelRows =[203 231 235 241];%,203, 231, 235, 241
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;

% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     sessionInfo.stimblocksize = excelRaw{11};
%     sessionInfo.stimbaseline=excelRaw{12};
%     sessionInfo.stimduration = excelRaw{13};
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
%     if ~exist(fullfile(maskDir,maskName))
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         
%     end
%     load(fullfile(maskDir,maskName), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     for n = runs
%         naming = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_GSR_BlockPeakMap','.fig');
%         openfig(fullfile(saveDir,naming))
%         processedName=strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%     prompt = {'Good Blocks are:'};
%     title1 = 'Good Blocks';
%     dims = [1 35];
%     definput = {'1'};
%     answer = inputdlg(prompt,title1,dims,definput);
%     goodBlocks = str2num(answer{1});
%     save(fullfile(saveDir,processedName), 'goodBlocks','-append')
%         
%         
%     end
% end

    peakMap_FAD_mice = [];
    peakMap_calcium_mice = [];

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
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName))
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
         processedName=strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName), 'goodBlocks')
        if ~isempty(goodBlocks)
         load(fullfile(saveDir,processedName), 'xform_FAD_GSR','xform_jrgeco1a_GSR')

        xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],10);
        xform_FAD_GSR = reshape(xform_FAD_GSR,128,128,[],10);
        peakFrames = sessionInfo.stimbaseline:sessionInfo.stimbaseline + sessionInfo.stimduration*sessionInfo.framerate;
       
        peakMap_FAD = mean(xform_FAD_GSR(:,:,:,goodBlocks),4);
        clear xform_FAD_GSR
        peakMap_calcium = mean(xform_jrgeco1a_GSR(:,:,:,goodBlocks),4);
        clear xform_jrgeco1a_GSR

        peakMap_FAD = mean(peakMap_FAD(:,:,peakFrames),3);
        peakMap_calcium = mean(peakMap_calcium(:,:,peakFrames),3);
        

    peakMap_FAD_mice = cat(3,peakMap_FAD_mice,peakMap_FAD);
    peakMap_calcium_mice = cat(3,peakMap_calcium_mice,peakMap_calcium);
        
        end
        
    end
end

    peakMap_FAD_mice = mean(peakMap_FAD_mice,3)*100;
    peakMap_calcium_mice = mean(peakMap_calcium_mice,3)*100;
    
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
    
mask = leftMask+rightMask;

figure
imagesc(peakMap_FAD_mice,[-1.5 1.5])
colormap jet
axis image off
colorbar
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('Raw FAD')

figure
imagesc(peakMap_calcium_mice,[-4 4])
colormap jet
axis image off
colorbar
hold on;imagesc(xform_WL,'AlphaData',1-mask);    
title('Raw Calcium')

