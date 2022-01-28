%% load in Atlas and Network Assignments
load('AtlasandIsbrain.mat', 'AtlasSeedsAllNetworksLR', 'NetworksLR', 'CmapAllNetworks')

%% load in movie and brain mask
load('G:\OISProjects\CulverLab\Stroke\150930\150930-CK11-fc-cat.mat', 'xform_datahb', 'xform_isbrain'); %load image sequence and brain mask. Your variables might be called somehting different.

%% Calculate whole cortex FC matrix
xform_datahb_GSR=gsr(xform_datahb,xform_isbrain);
xform_datahb_GSR=reshape(xform_datahb_GSR,128*128,[]);
TempR=normr(xform_datahb_GSR)*normr(xform_datahb_GSR)';

%% Symmetrize Brain Mask 
symisbrainall=zeros(128);
symisbrainall(:,1:64)=xform_isbrain(:,1:64).*fliplr(xform_isbrain(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);
Brainidx=find(symisbrainall==1);

%% Crop Whole cortex FC matrix
TempR=TempR(Brainidx,Brainidx);

%% Remove networks containing only a few pixels (we can discuss)
Atlas=AtlasSeedsAllNetworksLR;
BadNets=[23,24,4,1,25,21,13,12,8,3,7,22];
BadNets=[BadNets; BadNets+24];

for p=1:numel(BadNets)
    idx=Atlas==BadNets(p);
    Atlas(idx)=0;
end

%% Reorder indices of brain mask to go along rows instead of columns (only affects final look of whole cortex FC matrix)
APPixels=[];
a=0;
for y=1:128
    for x=1:128
        if symisbrainall(y,x)
            a=a+1;
            APPixels(a)=sub2ind([128, 128], y, x);
        end
    end
end
APPixels=APPixels';

%% Make a mapping vector between the indicies in the brain mask and the rows of the whole cortex FC matrix
APPixelsidx=[];
for n=1:size(APPixels,1)
    APPixelsidx(n)=find(Brainidx==APPixels(n),1, 'first'); 
end
APPixelsidx=APPixelsidx';

%% Reorder whole cortex correlation matrix
TempR=TempR(APPixelsidx,APPixelsidx);

%% find rows of correlation matrix that correspond to network parcels and ignore unassigned brain pixels
[Nets,I] = sort(Atlas(APPixels),'ascend'); % sort by network in Left then Right
I(Nets == 0) = [];
GoodNets=unique(Nets(Nets~=0))';
Nets(Nets == 0) = [];

%% Reorder according to network assignment
ReorderedFCMat=TempR(I,I);

%% Plot
order=cell2mat(NetworksLR(:,2));

clear key Cmap
key(:,1)=1:size(ReorderedFCMat,1);
key(:,2)=Nets;

CmapAllNetworksLR=[CmapAllNetworks; CmapAllNetworks];
OrderedNetworks(order,1)=join([NetworksLR(:,1), NetworksLR(:,3)]);
OrderedCmapAllNetworks(order,:)=CmapAllNetworksLR;

GoodNetsV=[GoodNets; GoodNets];
GoodNetsH=[GoodNets; GoodNets];
OrderedNetworksH=OrderedNetworks;

Cmap=OrderedCmapAllNetworks;

buffer=200;
lims=[-0.7 0.7];

figure; 
Matrix_Org3(ReorderedFCMat, key, GoodNetsV, GoodNetsH, OrderedNetworks, OrderedNetworks, buffer, lims, Cmap,'jet')
