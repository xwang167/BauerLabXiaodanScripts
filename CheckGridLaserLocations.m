

poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
% excelFile="C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\examples\Code Modification\exampleTiffOIS+Gcamp.xlsx";
% excelRows=[15];  % Rows from Excell Database
%clear all;close all;

excelFile="X:\XW\CodeModification\CodeMeeting.xlsx";
excelRows=[4];
istransform = 0;

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns_xw(excelFile,excelRows);
load('Z:\220205\220205-paper-LandmarksandMask.mat')

%% first chunk
load('Z:\220205\220205-paper-stim1-cam1_1.mat')




load('Z:\220208\220208-N13M309-stim1-cam1_1.mat')
load('Z:\220208\220208-mytform.mat')
load('Z:\220208\220208-m.mat')
load('Z:\220208\220208-N13M309-LandmarksandMask.mat')
totalFrames = size(raw_unregistered,3);
n1 = (totalFrames-60)/1801;
indx1 = 60+5*20*3+4;
idxs1 = indx1:1801:totalFrames;

laserFrames_1 = raw_unregistered(:,:,idxs1);

ii = 40;
numValid = 0;
while numValid<40
      numValid = sum(GoodSeedsidx(1:ii));
      ii = ii+1;
end


kk = 1;
for jj = 1:ii-1
    if GoodSeedsidx(m(jj))           
        imagesc(laserFrames_1(:,:,kk),[0 100000])
        axis image off
        hold on
        scatter(GalvoSeedCenterCCDSpace(m(jj),2),GalvoSeedCenterCCDSpace(m(jj),1),'w','LineWidth',1.5)
        kk = kk+1;
        title(num2str(jj))
        pause
    end
end





load('Z:\220208\220208-N13M309-stim1-cam1_2.mat')
totalFrames = size(raw_unregistered,3);
n2 = (totalFrames)/1801;
indx1 = 5*20*3+4;
idxs1 = indx1:1801:totalFrames;

laserFrames_2 = raw_unregistered(:,:,idxs1);


ii = 80;
numValid = 0;
while numValid<80
      numValid = sum(GoodSeedsidx(1:ii));
      ii = ii+1;
end

kk = 1;
for jj = 41:ii-1
    if GoodSeedsidx(m(jj))           
        imagesc(laserFrames_2(:,:,kk),[0 100000])
        axis image off
        hold on
        scatter(GalvoSeedCenterCCDSpace(m(jj),2),GalvoSeedCenterCCDSpace(m(jj),1),'w','LineWidth',1.5)
        kk = kk+1;
        title(num2str(jj))
        pause
    end
end


for kk = 1:40
     imagesc(laserFrames_2(:,:,kk),[0 100000])
     pause
end


sessionInfo = sysInfo_xw(runInfo.system);
raw_unregistered(:,:,idxs1) = [];
raw_unregistered = reshape(raw_unregistered,128,128,sessionInfo.numLEDs,[]);

darkFrames = raw_unregistered(:,:,:,2:20);
darFrame = mean(darkFrames,4);







%%second chunk
load('Z:\220205\220205-paper-stim1-cam1_2.mat')

totalFrames = size(raw_unregistered,3);
n2 = totalFrame/1801;

indx2 = 5*20*3+4;
idxs2 = indx2:1801:totalFrames;

laserFrames_2 = raw_unregistered(:,:,idxs2);
raw_unregistered(:,:,idxs2) = [];

darkFrames = raw_unregistered(:,:,2:60);
raw_unregistered(:,:,1:60) = [];


kk = 1;
for jj = 1:n2
    if GoodSeedsidx(m(jj))           
        figure
        imagesc(laserFrames_2(:,:,kk))
        hold on
        scatter(GalvoSeedCenterCCDSpace(m(jj),2),GalvoSeedCenterCCDSpace(m(jj),1),'w')
        kk = kk+1;
        pause
    end
end



A = squeeze(raw_unregistered(93,68,:));