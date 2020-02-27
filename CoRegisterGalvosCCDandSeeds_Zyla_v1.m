
function [GalvoSeedCenterCorrected] = CoRegisterGalvosCCDandSeeds_Zyla_v1(fileName, darkFramesTotal,greenInd,redInd)
% This function calculates the locations of the predefinded seeds in atlas
% space and maps them to mouse space. "seedcenter" contains the locations
% of the seeds in mouse space, and I contains the landmark locations

%% Landmarks for Galvos and CCD (y,x)
nVy = 128;
nVx = 128;

CCDPoints=...
[4 5 1;...  
3 127 1;...
125 3 1;...
125 125 1];

GalvoPoints=...
[0.61 -0.26 1;...
-0.57 -0.27 1;...
0.55 0.26 1;...
-0.61 0.25 1];
%% Transformation Matrix

W_Galvo2CCD=GalvoPoints\CCDPoints;
W_CCD2Galvo=CCDPoints\GalvoPoints;

%% Get Seeds according to Atlas Space 
[Seeds, L]=GalvoSeeds_PaxinosSpace;% Seeds and L are row vector [x y]

F=fieldnames(Seeds.R);
numf=numel(F);

for f = 1:numf
    N = F{f};
    Seeds.R.(N)(1,2) = -Seeds.R.(N)(1,2);
    Seeds.L.(N)(1,2) = -Seeds.L.(N)(1,2);
end


F_L=fieldnames(L);
numf_L=numel(F_L);

for f_L = 1:numf_L
    N_L = F_L{f_L};
    L.(N_L)(1,2) = -L.(N_L)(1,2);  
end




%% GetLandmarks for mouse
imageCam1 = readOneFrame_Zyla(strcat(fileName,'-WL-cam1'),nVy,nVx,darkFramesTotal+greenInd);%6
imageCam2 = readOneFrame_Zyla(strcat(fileName,'-WL-cam2'),nVy,nVx,darkFramesTotal+redInd);%7

[WL,mytform] = getTransformationandWL_Zyla(imageCam1,imageCam2,nVy,nVx);


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

aa=atan2(L.of(2)-L.tent(2),L.of(1)-L.tent(1));  %Angle in Paxinos Space
ia=atan2(OF(2)-T(2),OF(1)-T(1));                %Angle in Mouse Space
da=ia-aa;                           %Mouse-Paxinos


pixmm=idist/adist;                  %Mouse/Pax
R=[cos(da) -sin(da) ; sin(da) cos(da)];

% I in column vector [x;y]
I.bregma=pixmm*(R*(L.bregma)');
I.tent=pixmm*(R*(L.tent)');
I.OF=pixmm*(R*(L.of)');

t=T'-I.tent;             %translation=mouse-Paxinos

I.bregma=I.bregma+t;
I.tent=I.tent+t;
I.OF=I.OF+t;



for f=1:numf
    N=F{f};
    I.Seeds.R.(N)=(pixmm*R*(Seeds.R.(N))'+I.bregma);
    I.Seeds.L.(N)=(pixmm*R*(Seeds.L.(N))'+I.bregma);
end

seedcenter=zeros(2*numf,2);
seedCenterCorrected = zeros(2*numf,2);

for f=0:numf-1;
    N=F{f+1};
    seedcenter(2*(f+1)-1,1)=I.Seeds.R.(N)(1);
    seedcenter(2*(f+1)-1,2)=I.Seeds.R.(N)(2);
    seedcenter(2*(f+1),1)=I.Seeds.L.(N)(1);
    seedcenter(2*(f+1),2)=I.Seeds.L.(N)(2);  
end

% seedcenter=flipdim(seedcenter,2);

% I from column vector to row vector
I.bregma = (I.bregma)';
I.tent =(I.tent)';
I.OF = (I.OF)';

seedcenter(:,3)=1;
seedCenterCorrected(:,3)=1;

seedCenterCorrected(:,1:2)= John_GalvoSeedCurvatureCxn(seedcenter(:,1:2),I,30,5);

%% Transform seeds in CCD Space to Galvo space
%GalvoSeedCenter=round(seedcenter*W_CCD2Galvo*1000)/1000;  %factor of 1000 due to rounding galvo Volatages to the nearest mV
GalvoSeedCenterCorrected=(seedCenterCorrected*W_CCD2Galvo*1000)/1000;  %rounding seems to introduce error between intended stim site and actual stim site

%% Transform seeds in Galvo Space to CCD space
%GalvoSeedCenterCCDSpace=round(GalvoSeedCenter*W_Galvo2CCD);
GalvoSeedCenterCCDSpaceCorrected=(GalvoSeedCenterCorrected*W_Galvo2CCD); %no need to round here either

I.OF(:,3)=1;
I.tent(:,3)=1;
I.bregma(:,3)=1;
LGalvo2CCD.OF=round(I.OF*W_CCD2Galvo*W_Galvo2CCD);
LGalvo2CCD.tent=round(I.tent*W_CCD2Galvo*W_Galvo2CCD);
LGalvo2CCD.bregma=round(I.bregma*W_CCD2Galvo*W_Galvo2CCD);

GalvoSeedCenterCorrected=GalvoSeedCenterCorrected(:,1:2);
GalvoSeedCenterCCDSpaceCorrected=GalvoSeedCenterCCDSpaceCorrected(:,1:2);

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
title('Paxinos Seeds & Corrected Seed(Red) in CCD Space');
  
for f=1:size(seedcenter,1)
    hold on;
    plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
    plot(seedCenterCorrected(f,1),seedCenterCorrected(f,2),'ro','MarkerFaceColor','r')
end

    hold on;
    plot(I.tent(1,1),I.tent(1,2),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.bregma(1,1),I.bregma(1,2),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.OF(1,1),I.OF(1,2),'ko','MarkerFaceColor','b')
    hold on;plot(seedcenterCorrected(8,1),seedcenterCorrected(8,2),'wo','MarkerFaceColor','w')
    
subplot(1,2,2);
image(WL); %changed 3/1/1
axis off
axis image
title('Galvo Coords Transformed to CCD Space');
  
for f=1:size(GalvoSeedCenterCCDSpace,1)
    hold on;
    plot(GalvoSeedCenterCCDSpace(f,1),GalvoSeedCenterCCDSpace(f,2),'ko','MarkerFaceColor','k')
    plot(GalvoSeedCenterCCDSpaceCorrected(f,1),GalvoSeedCenterCCDSpaceCorrected(f,2),'ro','MarkerFaceColor','r')
end


    hold on;
    plot(LGalvo2CCD.tent(1,1),LGalvo2CCD.tent(1,2),'ko','MarkerFaceColor','b')
    hold on;
    plot(LGalvo2CCD.bregma(1,1),LGalvo2CCD.bregma(1,2),'ko','MarkerFaceColor','b')
    hold on;
    plot(LGalvo2CCD.OF(1,1),LGalvo2CCD.OF(1,2),'ko','MarkerFaceColor','b')
    hold on;plot(GalvoSeedCenterCCDSpaceCorrected(8,1),GalvoSeedCenterCCDSpaceCorrected(8,2),'wo','MarkerFaceColor','w')
    
     saveas(gcf,strcat(fileName,'-WLandMarks.jpg'))
    
    
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
    
    save(strcat(fileName,'-LandmarksAndMask.mat'),'mytform','affineMarkers','WL','isbrain','xform_isbrain','xform_WL','xform_WLcrop','WLcrop') 

    
end






