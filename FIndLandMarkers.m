excelFile="A:\JPC\DOI_RGeco\DOI_Database.xlsx";
excelRows=[11:56];

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);

tmp=matfile(runInfo.rawFile{1});   %JPC partial load  -- has size size(test,'raw_unregistered')
raw_unregistered=tmp.raw_unregistered(:,:,1:200*runInfo.numCh); %JPC
raw_unregistered=reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),runInfo.numCh,[]);
firstFrame_cam1  = squeeze(raw_unregistered(:,:,sessionInfo.rgb(2),runInfo.darkFramesInd(end)+1));
clear raw_unregistered tmp
tmp=matfile(runInfo.rawFile{2});   %JPC partial load  -- has size size(test,'raw_unregistered')
raw_unregistered=tmp.raw_unregistered(:,:,1:200*runInfo.numCh); %JPC
raw_unregistered=reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),runInfo.numCh,[]);

firstFrame_cam2  = squeeze(raw_unregistered(:,:,sessionInfo.rgb(1),runInfo.darkFramesInd(end)+2)); % JPC made this +2 instead of +1

clear raw_unregistered tmp


load([rawDataLoc,runInfo.recDate,'-gridWL-cam1.mat'])
cam1 = mean(raw_unregistered(:,:,4,:),4);
cam1=normr(cam1);
clear raw_unregistered
load([rawDataLoc,runInfo.recDate,'-gridWL-cam2.mat'])
cam2 = mean(raw_unregistered(:,:,4,:),4);
cam2=normr(cam2); %JPC
clear raw_unregistered
[mytform,fixed_cam1,registered_cam2] = getTransformation(cam1,cam2);
save(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')


fixed = firstFrame_cam1./max(max(firstFrame_cam1));
unregistered = firstFrame_cam2./max(max(firstFrame_cam2));
registered = imwarp(unregistered, mytform,'OutputView',imref2d(size(unregistered)));
%%
%Create White Light Image
WL = zeros(128,128,3);
WL(:,:,1) = registered;
if (StimCh~= 2) && (runInfo.session=="stim") %if there is a dropped frame
    WL(:,:,2) = 2.8*registered; %add some conrast!
    WL(:,:,3) = 4*registered;   %add some conrast!
else
    WL(:,:,2) = fixed;
    WL(:,:,3) = fixed;
end
disp([runInfo.saveHbFile,' Label'])
[isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_Zyla(WL);
