function [GoodSeedsidx, GalvoSeedCenter,GalvoSeedCenterCCDSpace]=CoRegisterGalvosCCDandSeedGrid_Zyla(FileName)

% This function calculates the locations of the predefinded seeds in atlas
% space and maps them to mouse space. "seedcenter" contains the locations
% of the seeds in mouse space, and I contains the landmark locations

%% Landmarks for Galvos and CCD (y,x)
CCDPoints=...
    [4 4 1;...
    3 126 1;...
    124 3 1;...
    124 124 1];

GalvoPoints=...
    [0.61 -0.26 1;...
    -0.57 -0.27 1;...
    0.55 0.26 1;...
    -0.61 0.25 1];

%% Transformation Matrix

W_Galvo2CCD=GalvoPoints\CCDPoints;
W_CCD2Galvo=CCDPoints\GalvoPoints;

%% Get Seeds according to Atlas Space
[Seeds, L]=GalvoSeedGrid_PaxinosSpace;

Seeds=fliplr(Seeds); %so that its now y,x
F=fieldnames(Seeds);
numf=numel(F);

%% GetLandmarks for mouse

nVx = 128;
nVy = 128;
imageCam1 = readOneFrame_Zyla(fullfile(directory,strcat(fileName,'-WL-cam1')),nVy,nVx,87);%6,87
imageCam2 = readOneFrame_Zyla(fullfile(directory,strcat(fileName,'-WL-cam2')),nVy,nVx,87);%7,87

[WL,mytform] = getTransformationandWL_Zyla(imageCam1,imageCam2,nVy,nVx,[]);


WLfig=figure;
image(WL); %changed 3/1/1
axis image;


disp('Click Anterior Midline Suture Landmark');
[x y]=ginput(1);

OF(1)=x;
OF(2)=y;

disp('Click Lambda');
[x y]=ginput(1);

T(1)=x;
T(2)=y;

disp('Create mask')
isbrain=roipoly(WL);


%% Transform Atlas seeds to CCD space ("Long way" of Affine transform)

adist=norm(L.of-L.tent);    %Paxinos Space
idist=norm(OF-T);           %Mouse Space

aa=atan2(L.of(1)-L.tent(1),L.of(2)-L.tent(2));  %Angle in Paxinos Space
ia=atan2(OF(1)-T(1),OF(2)-T(2));                %Angle in Mouse Space
da=ia-aa;                           %Mouse-Paxinos

pixmm=idist/adist;                  %Mouse/Pax
R=[cos(da) -sin(da) ; sin(da) cos(da)];

I.bregma=pixmm*(L.bregma*R);
I.tent=pixmm*(L.tent*R);
I.OF=pixmm*(L.of*R);

t=T-I.tent;             %translation=mouse-Paxinos

I.bregma=I.bregma+t;
I.tent=I.tent+t;
I.OF=I.OF+t;

numf=size(Seeds.L,1);

for f=1:numf
    I.Seeds.R(f,:)=(pixmm*Seeds.R(f,:)*R+I.bregma);
    I.Seeds.L(f,:)=(pixmm*Seeds.L(f,:)*R+I.bregma);
end

seedcenter=zeros(2*numf,2);
F=0;
for f=0:numf-1;
    F=F+1;
    seedcenter(2*(f+1)-1,1)=I.Seeds.R(F,1);
    seedcenter(2*(f+1)-1,2)=I.Seeds.R(F,2);
    seedcenter(2*(f+1),1)=I.Seeds.L(F,1);
    seedcenter(2*(f+1),2)=I.Seeds.L(F,2);
end

%load('C:\Users\user\Desktop\MatlabCode\OISCode\AtlasMaskRedo.mat', 'isbrain');

seedcenter=round(seedcenter);

seedcenter=reshape(seedcenter,[],1);
idx=find(seedcenter<1);
seedcenter(idx)=1;
idx=find(seedcenter>128);
seedcenter(idx)=1;

seedcenter=reshape(seedcenter,[],2);

GoodSeedsidx=zeros(size(seedcenter,1),1);
for s=1:size(seedcenter,1);
    if isbrain(seedcenter(s,2),seedcenter(s,1))
        GoodSeeds(s,:)=seedcenter(s,:);
        GoodSeedsidx(s)=1;
    end
end

GoodSeeds=flipdim(GoodSeeds,2);
I.bregma=flipdim(I.bregma,2);
I.tent=flipdim(I.tent,2);
I.OF=flipdim(I.OF,2);

GoodSeeds(:,3)=1;
GoodSeeds(:,1:2)= John_GalvoSeedCurvatureCxn(GoodSeeds(:,1:2),I,19,0);
%% Transform seeds in CCD Space to Galvo space
GalvoSeedCenter=round(GoodSeeds*W_CCD2Galvo*1000)/1000;  %factor of 1000 due to rounding galvo Volatages to the nearest mV

%% Transform seeds in Galvo Space to CCD space
GalvoSeedCenterCCDSpace=round(GalvoSeedCenter*W_Galvo2CCD);

I.OF(:,3)=1;
I.tent(:,3)=1;
I.bregma(:,3)=1;
LGalvo2CCD.OF=round(I.OF*W_CCD2Galvo*W_Galvo2CCD);
LGalvo2CCD.tent=round(I.tent*W_CCD2Galvo*W_Galvo2CCD);
LGalvo2CCD.bregma=round(I.bregma*W_CCD2Galvo*W_Galvo2CCD);

GalvoSeedCenter=GalvoSeedCenter(:,1:2);
GalvoSeedCenterCCDSpace=GalvoSeedCenterCCDSpace(:,1:2);

%% Visualize landmarks and seeds

if max(WL(:))>1
    WL=double(WL)/255;
else
    WL=WL;
end

close(WLfig)

figure;
subplot(1,2,1);
image(WL); %changed 3/1/1
axis off
axis image
title('White Light Image with Paxinos Grid in CCD Space');

for f=1:size(GoodSeeds,1)
    hold on;
    plot(GoodSeeds(f,2),GoodSeeds(f,1),'ko','MarkerFaceColor','k')
end

hold on;
plot(I.tent(1,2),I.tent(1,1),'ko','MarkerFaceColor','b')
hold on;
plot(I.bregma(1,2),I.bregma(1,1),'ko','MarkerFaceColor','b')
hold on;
plot(I.OF(1,2),I.OF(1,1),'ko','MarkerFaceColor','b')


subplot(1,2,2);
image(WL); %changed 3/1/1
axis off
axis image
title('White Light Image with Galvo Coords Transformed to CCD Space');

for f=1:size(GalvoSeedCenterCCDSpace,1)
    hold on;
    plot(GalvoSeedCenterCCDSpace(f,2),GalvoSeedCenterCCDSpace(f,1),'ko','MarkerFaceColor','k')
end

hold on;
plot(LGalvo2CCD.tent(1,2),LGalvo2CCD.tent(1,1),'ko','MarkerFaceColor','b')
hold on;
plot(LGalvo2CCD.bregma(1,2),LGalvo2CCD.bregma(1,1),'ko','MarkerFaceColor','b')
hold on;
plot(LGalvo2CCD.OF(1,2),LGalvo2CCD.OF(1,1),'ko','MarkerFaceColor','b')

[xform_isbrain]=Affine(affineMarkers, isbrain, 'New');
xform_isbrain=single(uint8(xform_isbrain));

[xform_WL]=Affine(affineMarkers, WL, 'New');

for j=1:3
    xform_WLcrop(:,:,j)=xform_WL(:,:,j).*xform_isbrain; %make affine transform WL image
end

WLcrop=WL;
for j=1:3
    WLcrop(:,:,j)=WLcrop(:,:,j).*isbrain; %make WLcrop image
end

save(fullfile(directory,strcat(fileName,'-LandmarksAndMask.mat')),...
    'mytform','affineMarkers','WL','isbrain','xform_isbrain','xform_WL','xform_WLcrop','WLcrop')
end





