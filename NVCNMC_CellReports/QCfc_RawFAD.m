sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
sessionInfo.bandtype_Delta = {"Delta",0.4,4};
sessionInfo.framerate =25;
refseeds=GetReferenceSeeds;
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
runs = 1:3;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end

    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        load(fullfile(saveDir,processedName), 'xform_FAD')
        [R_FAD_ISA,Rs_FAD_ISA]= QCcheck_CalcRRs(refseeds,double(xform_FAD)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        save(fullfile(saveDir,processedName),'Rs_FAD_ISA','R_FAD_ISA','-append')
        [R_FAD_Delta,Rs_FAD_Delta]= QCcheck_CalcRRs(refseeds,double(xform_FAD)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        save(fullfile(saveDir,processedName),'Rs_FAD_Delta','R_FAD_Delta','-append')
        QCcheck_fcVis(refseeds,R_FAD_Delta,Rs_FAD_Delta,'FAD', 'g','Delta',saveDir,strcat(visName),false,xform_isbrain)
        close all
    end
end

%% mouse average
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))

        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');

    else
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
    end
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end

    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');

    R_FAD_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    R_FAD_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_FAD_Delta_mouse = zeros(16,16,length_runs);
    Rs_FAD_ISA_mouse = zeros(16,16,length_runs);

    for n = runs
        disp('loading processed data')

        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'R_FAD_Delta','R_FAD_ISA',...
            'Rs_FAD_Delta','Rs_FAD_ISA')

        R_FAD_Delta_mouse(:,:,:,n) = R_FAD_Delta;
        R_FAD_ISA_mouse(:,:,:,n) = R_FAD_ISA;
        Rs_FAD_Delta_mouse(:,:,n) = Rs_FAD_Delta;
        Rs_FAD_ISA_mouse(:,:,n) = Rs_FAD_ISA;
    end

    disp(char(['QC check on ', processedName_mouse]))
    R_FAD_Delta_mouse = mean(R_FAD_Delta_mouse,4);
    R_FAD_ISA_mouse  = mean(R_FAD_ISA_mouse,4);
    Rs_FAD_Delta_mouse = mean(Rs_FAD_Delta_mouse,3);
    Rs_FAD_ISA_mouse = mean(Rs_FAD_ISA_mouse,3);

    save(fullfile(saveDir, processedName_mouse),'R_FAD_ISA_mouse',...
        'R_FAD_Delta_mouse','Rs_FAD_ISA_mouse','Rs_FAD_Delta_mouse')
    QCcheck_fcVis(refseeds,R_FAD_Delta_mouse, Rs_FAD_Delta_mouse,'FAD','g','Delta',saveDir,visName,false,xform_isbrain)
    close all
end

%% Mice Average
excelRows = [202 195 204 230 234 240];
numMice = length(excelRows);
xform_isbrain_mice = 1;
info.nVx = 128;
info.nVy = 128;
R_FAD_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
R_FAD_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
Rs_FAD_Delta_mice = zeros(16,16,numMice);
Rs_FAD_ISA_mice = zeros(16,16,numMice);

miceName = [];
miceName_powerdata = [];
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);

    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;


    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');

              load(fullfile(saveDir, processedName),'R_FAD_Delta_mouse','R_FAD_ISA_mouse',...
                'Rs_FAD_Delta_mouse','Rs_FAD_ISA_mouse')
            R_FAD_Delta_mice(:,:,:,ll) = real(atanh(R_FAD_Delta_mouse));
            R_FAD_ISA_mice(:,:,:,ll) = real(atanh(R_FAD_ISA_mouse));
            Rs_FAD_Delta_mice(:,:,ll) = real(atanh(Rs_FAD_Delta_mouse));
            Rs_FAD_ISA_mice(:,:,ll) = real(atanh(Rs_FAD_ISA_mouse));
        ll = ll+1;
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

R_FAD_Delta_mice = mean(R_FAD_Delta_mice,4);
R_FAD_ISA_mice  = mean(R_FAD_ISA_mice,4);
Rs_FAD_Delta_mice = mean(Rs_FAD_Delta_mice,3);
Rs_FAD_ISA_mice = mean(Rs_FAD_ISA_mice,3);

saveDir_cat = 'E:\RGECO\cat';
save(fullfile(saveDir_cat, processedName_mice),'R_FAD_ISA_mice',...
    'R_FAD_Delta_mice','Rs_FAD_ISA_mice','Rs_FAD_Delta_mice','-append')
visName = strcat(recDate,miceName);
QCcheck_fcVis(refseeds,R_FAD_ISA_mice, Rs_FAD_ISA_mice,'FAD','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FAD_Delta_mice, Rs_FAD_Delta_mice,'FAD','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
