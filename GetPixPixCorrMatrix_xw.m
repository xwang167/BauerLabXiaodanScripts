import mouse.*
excelFile='V:\CTREM\CTREM.xlsx';
excelRows=[2:11,17:22,27:63];

symisbrainall = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    symisbrainall = symisbrainall.*xform_isbrain;
end
symisbrainall = symisbrainall & fliplr(symisbrainall);
[SeedsUsed]=CalcRasterSeedsUsed(symisbrainall);

type='Whole';
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    if ischar(excelRaw{10})
        runs = str2num(excelRaw{10}); %1:excelRaw{13};
    else
        runs = excelRaw{10};
    end
    processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    R_AllPix_hb_mouse=zeros(size(SeedsUsed,1), size(SeedsUsed,1),length(runs));
    R_AllPix_fluor_mouse=zeros(size(SeedsUsed,1), size(SeedsUsed,1),length(runs));
    ind = 1;
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName_dataHb = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataHb','.mat');
        processedName_dataFluor = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataFluor','.mat');
        load(fullfile(saveDir,processedName_dataHb),'xform_datahb')
        load(fullfile(saveDir,processedName_dataFluor),'xform_datafluorCorr')
        
        tic
        disp('Calculating Correlation Matrix for All Pixels')
        
        disp(['Run #: ', num2str(n)])
        
        [R_AllPix_hb]=fcManySeed_fast(xform_datahb, symisbrainall, type);
        xform_datafluorCorr = reshape(xform_datafluorCorr,128,128,1,[]);
        [R_AllPix_fluor]=fcManySeed_fast_fluor(xform_datafluorCorr, symisbrainall);
        
        R_AllPix_hb=real(atanh(R_AllPix_hb));
        R_AllPix_fluor=real(atanh(R_AllPix_fluor));
        
        R_AllPix_hb(R_AllPix_hb==Inf)=0;
        R_AllPix_fluor(R_AllPix_fluor==Inf)=0;
        
        save(fullfile(saveDir,processedName_dataHb),'R_AllPix_hb','-append')
        save(fullfile(saveDir,processedName_dataFluor),'R_AllPix_fluor','-append')
        
        R_AllPix_hb_mouse(:,:,ind) = R_AllPix_hb;
        R_AllPix_fluor_mouse(:,:,ind) = R_AllPix_fluor;
        ind = ind + 1;
    end
    
    R_AllPix_hb_mouse = mean(R_AllPix_hb_mouse,3);
    R_AllPix_fluor_mouse = mean(R_AllPix_fluor_mouse,3);
    
    save(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
    save(fullfile(saveDir,processedName_dataFluor_mouse),'R_AllPix_fluor_mouse')
    
    clearvars -except SeedsUsed symisbrainall excelFile excelRows type
end