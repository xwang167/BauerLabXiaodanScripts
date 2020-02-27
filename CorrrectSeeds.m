cData = zeros(128);
seedLocMap = zeros(128);
runInfo.window = [-5 5 -5 5]; % y min, y max, x min, x max (in mm)
paramPath = what('bauerParams');
seedsData = load(fullfile(paramPath.path,'seeds16.mat'));
seedNum = size(seedsData.seedCenter,1);
numPixY = size(cData,1); % number of pixels in y axis
numPixX = size(cData,2);
sizeY = runInfo.window(2)-runInfo.window(1); % size in mm in y axis
sizeX = runInfo.window(4)-runInfo.window(3);
seedCenter = seedsData.seedCenter;
seedCenter(:,1) = (seedCenter(:,1) - runInfo.window(1))./sizeY; % get normalized coordinate
seedCenter(:,2) = (seedCenter(:,2) - runInfo.window(3))./sizeX;
seedCenter(:,1) = round(seedCenter(:,1).*numPixY); % convert to pixel coordinate
seedCenter(:,2) = round(seedCenter(:,2).*numPixX);

seedRadius = 0.25; % in mm
seedRadius = round(seedRadius/sizeY*numPixY);


for seedInd = 1:seedNum
    seedCoor = mouse.math.circleCoor(seedCenter(seedInd,:),seedRadius);
    seedCoor = mouse.math.matCoor2Ind(seedCoor,[numPixY numPixX]);
    seedLocMap(seedCoor) = 1;
end
figure
imagesc(seedLocMap)
title('Kenny Seed Map')

seedNum = 16;

refseeds=GetReferenceSeeds;
refseeds(1,1) = 42; %Parietal
refseeds(1,2) = 88; %Parietal
refseeds(2,1) = 87; %Parietal
refseeds(2,2) = 88; %Parietal
refseeds(9,1) = 18;
refseeds(9,2) = 66;
refseeds(10,1) = 111;
refseeds(10,2) = 66;

%Olfactory
%Frontal
%Cingulate
%Motor
%Somatosenory
%Retrosplenial
%Visual
%Auditory
%Parietal

seedCenter = flip(refseeds,2);

seedLocMap = zeros(128);
for seedInd = 1:seedNum
    seedCoor = mouse.math.circleCoor(seedCenter(seedInd,:),seedRadius);
    seedCoor = mouse.math.matCoor2Ind(seedCoor,[numPixY numPixX]);
    seedLocMap(seedCoor) = 1;
end
figure
imagesc(seedLocMap)
title('New Seed Map')
