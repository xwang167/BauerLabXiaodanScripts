type='Whole';
thresh=0.4;
import mouse.*
excelFile='Y:\CTREM\CTREM_new.xlsx';
excelRows=[2:11,17:22,27:66];

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
idx=find(symisbrainall==1);
[Y,X]=ind2sub([128,128], idx);

% for excelRow=excelRows;
%     
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{9}; 
%     saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
%     sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
%     disp(['Loading ', mouseName, ' n= ' , num2str(excelRow)])
%     
%     tic
%     disp('Loading Full Pixel-Pixel Correlation Matrix')
%     processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
%     processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
%     load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
%     tempfc_hb = R_AllPix_hb_mouse;
%     
%     disp('Calculating Global Node Degree for Postive Correlations')
%     
%     BinMap_hb=zeros(size(tempfc_hb));
%     BinMap_hb(tempfc_hb>thresh)=1;
%     WeiMap_hb = zeros(size(tempfc_hb));
%     idx_hb = find(tempfc_hb>thresh);
%     WeiMap_hb(idx_hb)=tempfc_hb(idx_hb);
%     NDbin_hb=sum(BinMap_hb);
%     NDwei_hb=sum(WeiMap_hb);
%     
%     
%     NDim_hb=zeros(128,128,2);
%     
%     for hh=1:size(tempfc_hb,1);
%         NDim_hb(Y(hh),X(hh),1)=NDbin_hb(hh);
%         NDim_hb(Y(hh),X(hh),2)=NDwei_hb(hh);
%     end
%     
%     NDimAll_hb_mouse = NDim_hb;
%     
%     save(fullfile(saveDir,processedName_dataHb_mouse), 'NDimAll_hb_mouse','-append');
%     
%     disp('Calculating Ipsilateral Node Degree for Postive Correlations')
%     
%     NDimIpsi_hb=zeros(128,128,2);
%     NDBinIpsiL_hb=sum(BinMap_hb(1:size(tempfc_hb)/2,1:size(tempfc_hb)/2));          %First quadrant, Left Seeds with Left Connections
%     NDBinIpsiR_hb=sum(BinMap_hb(size(tempfc_hb)/2+1:end,size(tempfc_hb)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
%     NDWeiIpsiL_hb=sum(WeiMap_hb(1:size(tempfc_hb)/2,1:size(tempfc_hb)/2));          %First quadrant, Left Seeds with Left Connections
%     NDWeiIpsiR_hb=sum(WeiMap_hb(size(tempfc_hb)/2+1:end,size(tempfc_hb)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
%     
%     for hh=1:size(tempfc_hb,1)/2
%         NDimIpsi_hb(Y(hh),X(hh),1)=NDBinIpsiL_hb(hh);
%         NDimIpsi_hb(Y(hh),X(hh),2)=NDWeiIpsiL_hb(hh);
%     end
%     
%     for hh=size(tempfc_hb,1)/2+1:size(tempfc_hb,1)
%         NDimIpsi_hb(Y(hh),X(hh),1)=NDBinIpsiR_hb(hh-size(tempfc_hb,1)/2);
%         NDimIpsi_hb(Y(hh),X(hh),2)=NDWeiIpsiR_hb(hh-size(tempfc_hb,1)/2);
%     end
%     
%     NDimIpsi_hb_mouse=NDimIpsi_hb;
%     save(fullfile(saveDir,processedName_dataHb_mouse),'NDimIpsi_hb_mouse', '-append');
%     
%     disp('Calculating Contralateral Node Degree for Postive Correlations')
%     
%     NDimContra_hb=zeros(128,128,2);
%     NDBinContraL_hb=sum(BinMap_hb(size(tempfc_hb)/2+1:end,1:size(tempfc_hb)/2));    %Third quadrant, Left Seeds with Right Connections
%     NDBinContraR_hb=sum(BinMap_hb(1:size(tempfc_hb)/2,size(tempfc_hb)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
%     NDWeiContraL_hb=sum(WeiMap_hb(size(tempfc_hb)/2+1:end,1:size(tempfc_hb)/2));    %Third quadrant, Left Seeds with Left Connections
%     NDWeiContraR_hb=sum(WeiMap_hb(1:size(tempfc_hb)/2,size(tempfc_hb)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
%     
%     for hh=1:size(tempfc_hb,1)/2;
%         NDimContra_hb(Y(hh),X(hh),1)=NDBinContraL_hb(hh);
%         NDimContra_hb(Y(hh),X(hh),2)=NDWeiContraL_hb(hh);
%     end
%     
%     for hh=size(tempfc_hb,1)/2+1:size(tempfc_hb,1);
%         NDimContra_hb(Y(hh),X(hh),1)=NDBinContraR_hb(hh-size(tempfc_hb,1)/2);
%         NDimContra_hb(Y(hh),X(hh),2)=NDWeiContraR_hb(hh-size(tempfc_hb,1)/2);
%     end
%     
%     NDimContra_hb_mouse=NDimContra_hb;
%     save(fullfile(saveDir,processedName_dataHb_mouse),'NDimContra_hb_mouse','-append');
%     toc
%     
%     
%     clearvars -except SeedsUsed symisbrainall NewSeedsUsed database excelFile type thresh idx Y X excelRow excelRows
% end


for excelRow=excelRows;
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; 
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    disp(['Loading ', mouseName, ' n= ' , num2str(excelRow)])
    
    tic
    disp('Loading Full Pixel-Pixel Correlation Matrix')
    processedName_datafluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    load(fullfile(saveDir,processedName_datafluor_mouse),'R_AllPix_fluor_mouse')
    tempfc_fluor = R_AllPix_fluor_mouse;
    
    disp('Calculating Global Node Degree for Postive Correlations')
    
    BinMap_fluor=zeros(size(tempfc_fluor));
    BinMap_fluor(tempfc_fluor>thresh)=1;
    WeiMap_fluor = zeros(size(tempfc_fluor));
    idx_fluor = find(tempfc_fluor>thresh);
    WeiMap_fluor(idx_fluor)=tempfc_fluor(idx_fluor);
    NDbin_fluor=sum(BinMap_fluor);
    NDwei_fluor=sum(WeiMap_fluor);
    
    
    NDim_fluor=zeros(128,128,2);
    
    for hh=1:size(tempfc_fluor,1);
        NDim_fluor(Y(hh),X(hh),1)=NDbin_fluor(hh);
        NDim_fluor(Y(hh),X(hh),2)=NDwei_fluor(hh);
    end
    
    NDimAll_fluor_mouse = NDim_fluor;
    
    save(fullfile(saveDir,processedName_datafluor_mouse), 'NDimAll_fluor_mouse','-append');
    
    disp('Calculating Ipsilateral Node Degree for Postive Correlations')
    
    NDimIpsi_fluor=zeros(128,128,2);
    NDBinIpsiL_fluor=sum(BinMap_fluor(1:size(tempfc_fluor)/2,1:size(tempfc_fluor)/2));          %First quadrant, Left Seeds with Left Connections
    NDBinIpsiR_fluor=sum(BinMap_fluor(size(tempfc_fluor)/2+1:end,size(tempfc_fluor)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
    NDWeiIpsiL_fluor=sum(WeiMap_fluor(1:size(tempfc_fluor)/2,1:size(tempfc_fluor)/2));          %First quadrant, Left Seeds with Left Connections
    NDWeiIpsiR_fluor=sum(WeiMap_fluor(size(tempfc_fluor)/2+1:end,size(tempfc_fluor)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
    
    for hh=1:size(tempfc_fluor,1)/2
        NDimIpsi_fluor(Y(hh),X(hh),1)=NDBinIpsiL_fluor(hh);
        NDimIpsi_fluor(Y(hh),X(hh),2)=NDWeiIpsiL_fluor(hh);
    end
    
    for hh=size(tempfc_fluor,1)/2+1:size(tempfc_fluor,1)
        NDimIpsi_fluor(Y(hh),X(hh),1)=NDBinIpsiR_fluor(hh-size(tempfc_fluor,1)/2);
        NDimIpsi_fluor(Y(hh),X(hh),2)=NDWeiIpsiR_fluor(hh-size(tempfc_fluor,1)/2);
    end
    
    NDimIpsi_fluor_mouse=NDimIpsi_fluor;
    save(fullfile(saveDir,processedName_datafluor_mouse),'NDimIpsi_fluor_mouse', '-append');
    
    disp('Calculating Contralateral Node Degree for Postive Correlations')
    
    NDimContra_fluor=zeros(128,128,2);
    NDBinContraL_fluor=sum(BinMap_fluor(size(tempfc_fluor)/2+1:end,1:size(tempfc_fluor)/2));    %Third quadrant, Left Seeds with Right Connections
    NDBinContraR_fluor=sum(BinMap_fluor(1:size(tempfc_fluor)/2,size(tempfc_fluor)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
    NDWeiContraL_fluor=sum(WeiMap_fluor(size(tempfc_fluor)/2+1:end,1:size(tempfc_fluor)/2));    %Third quadrant, Left Seeds with Left Connections
    NDWeiContraR_fluor=sum(WeiMap_fluor(1:size(tempfc_fluor)/2,size(tempfc_fluor)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
    
    for hh=1:size(tempfc_fluor,1)/2;
        NDimContra_fluor(Y(hh),X(hh),1)=NDBinContraL_fluor(hh);
        NDimContra_fluor(Y(hh),X(hh),2)=NDWeiContraL_fluor(hh);
    end
    
    for hh=size(tempfc_fluor,1)/2+1:size(tempfc_fluor,1);
        NDimContra_fluor(Y(hh),X(hh),1)=NDBinContraR_fluor(hh-size(tempfc_fluor,1)/2);
        NDimContra_fluor(Y(hh),X(hh),2)=NDWeiContraR_fluor(hh-size(tempfc_fluor,1)/2);
    end
    
    NDimContra_fluor_mouse=NDimContra_fluor;
    save(fullfile(saveDir,processedName_datafluor_mouse),'NDimContra_fluor_mouse','-append');
    toc
    
    
    clearvars -except SeedsUsed symisbrainall NewSeedsUsed database excelFile type thresh idx Y X excelRow excelRows
end



