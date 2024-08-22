
clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 346;
runs =1:3;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.framerate = excelRaw{7};
    systemType = excelRaw{5};
    sessionInfo.mouseType = excelRaw{17};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(rawdataloc,recDate,maskName),'isbrain')
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_detrend');
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata')
        numChan = size(rawdata,3);
        raw_detrend = temporalDetrendAdam(rawdata);        
        [mdata_detrend, stddatanorm_detrend,InstMvMt_detrend,LTMvMt_detrend]= QCcheck_raw(raw_detrend,isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType);
        save(fullfile(saveDir,rawName),'mdata_detrend','stddatanorm_detrend','InstMvMt_detrend','LTMvMt_detrend','-append')
        %         [mdata, Colors, legendName] = QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/numChan+1):end-1),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType);
        %         figure;
        %         p = plot(linspace(1,300,length(mdata)),mdata);
        %         for c=1:numChan;
        %                set(p(c),'Color',Colors(c,:));
        %         end
        %          legend(legendName,'Location','southeast')
        %          title(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'raw mdata'))
        %           output=fullfile(saveDir,strcat(visName,'_mdata.jpg'));
        %           orient portrait
        %           print ('-djpeg', '-r300', output);
    end
end