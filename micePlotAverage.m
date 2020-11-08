import mouse.*
excelRows =  358:362;
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'K:\WT\cat' ;
xform_isbrain_mice = ones(128,128);
oxy_active_GSR_mice = [];
deoxy_active_GSR_mice = [];
oxy_active_NoGSR_mice = [];
deoxy_active_NoGSR_mice = [];

for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    
    
    
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'xform_isbrain', 'affineMarkers');
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    load(fullfile(saveDir, processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR')
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'1_processed','.mat')),'ROI_NoGSR')
    iROI_NoGSR = reshape(ROI_NoGSR,1,[]);
    oxy_GSR = reshape(xform_datahb_mouse_GSR(:,:,1,:),length(iROI_NoGSR),[]);
    deoxy_GSR = reshape(xform_datahb_mouse_GSR(:,:,2,:),length(iROI_NoGSR),[]);
    oxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,1,:),length(iROI_NoGSR),[]);
    deoxy_NoGSR = reshape(xform_datahb_mouse_NoGSR(:,:,2,:),length(iROI_NoGSR),[]);
    oxy_active_GSR = mean(oxy_GSR(iROI_NoGSR,:),1);
    deoxy_active_GSR = mean(deoxy_GSR(iROI_NoGSR,:),1);
    oxy_active_NoGSR = mean(oxy_NoGSR(iROI_NoGSR,:),1);
    deoxy_active_NoGSR = mean(deoxy_NoGSR(iROI_NoGSR,:),1);
    
    oxy_active_GSR_mice = cat(1,oxy_active_GSR_mice,oxy_active_GSR);
    deoxy_active_GSR_mice = cat(1,deoxy_active_GSR_mice,deoxy_active_GSR);
    oxy_active_NoGSR_mice = cat(1,oxy_active_NoGSR_mice,oxy_active_NoGSR);
    deoxy_active_NoGSR_mice = cat(1,deoxy_active_NoGSR_mice,deoxy_active_NoGSR);
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
end

oxy_active_GSR_mice = mean(oxy_active_GSR_mice,1);
deoxy_active_GSR_mice = mean(deoxy_active_GSR_mice,1);
oxy_active_NoGSR_mice = mean(oxy_active_NoGSR_mice);
deoxy_active_NoGSR_mice = mean(deoxy_active_NoGSR_mice);


load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'1','.mat')),'rawdata')
xform_laser =  process.affineTransform(rawdata(:,:,3,:),affineMarkers);
xform_laser = reshape(xform_laser,length(iROI_NoGSR),[]);
laser_active = mean(xform_laser(iROI_NoGSR,:),1);
figure
plot((1:602)/sessionInfo.framerate,oxy_active_NoGSR_mice,'-r')
hold on
plot((1:602)/sessionInfo.framerate,deoxy_active_NoGSR_mice,'-b')
hold on
plot((1:602)/sessionInfo.framerate,laser_active(1:602)/2/10^11,'-k')
legend('Oxy', 'DeOxy','Laser')
 xlabel('time(s)')
 ylabel('Concentration Change(\DeltaM)')
 title('Overlap Mode without GSR')
 set(gca,'FontSize',20,'FontWeight','Bold')
 set(findall(gca, 'Type', 'Line'),'LineWidth',2);
 

figure
plot((1:602)/sessionInfo.framerate,oxy_active_GSR_mice,'--r')
hold on
plot((1:602)/sessionInfo.framerate,deoxy_active_GSR_mice,'--b')
hold on
plot((1:602)/sessionInfo.framerate,laser_active(1:602)/2/10^11,'-k')
legend('Oxy', 'DeOxy','Laser')
 xlabel('time(s)')
 ylabel('Concentration Change(\DeltaM)')
 title('Overlap Mode with GSR')
 set(gca,'FontSize',20,'FontWeight','Bold')
 set(findall(gca, 'Type', 'Line'),'LineWidth',2);
 
 ylim([-1.6*10^-7 2.5*10^-7])
 
 
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
