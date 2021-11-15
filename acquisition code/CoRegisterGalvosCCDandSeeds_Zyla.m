function [GalvoSeedCenterCorrected] = CoRegisterGalvosCCDandSeeds_Zyla(directory,fileName,mytform)%, darkFramesTotal,greenInd,redInd)

% This function calculates the locations of the predefinded seeds in atlas
% space and maps them to mouse space. "seedcenter" contains the locations
% of the seeds in mouse space, and I contains the landmark locations

%% Landmarks for Galvos and CCD (y,x)
% if exist(strcat(fullfile(directory,fileName),'-LandmarksAndMask.mat'),'file')
%     disp('landmarks file already existed')
% else

CCDPoints=...
[1 9 1;...  
6 121 1;...
122 8 1;...
124 124 1];

GalvoPoints=...
[0.02 -0.5 1;...
-0.04 -0.13 1;...
0.37 -0.39 1;...
0.3 -0.01 1];%
% CCDPoints=...
% [7 123 1;...  
%  6 9 1;...
% 123 7 1;...
% 124 121 1];
% 
% GalvoPoints=...
% [-0.20  0.13 1;...right top
%  -0.13  -0.23 1;...left top
% 0.20  -0.13 1;...left bottom
% 0.13  0.23 1];...right bottom



        %% Transformation Matrix
    
    W_Galvo2CCD=GalvoPoints\CCDPoints;
    W_CCD2Galvo=CCDPoints\GalvoPoints;
    
    %% Get Seeds according to Atlas Space
    [Seeds, L]=GalvoSeeds_PaxinosSpace_xw;
    
    F=fieldnames(Seeds.R);
    numf=numel(F);
    
    %flip y axis in paxino space
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
    
    F=fieldnames(Seeds.R);
    numf=numel(F);
    
    for f=1:numf
        N=F{f};
        I.Seeds.R.(N)=(pixmm*Seeds.R.(N)*R+I.bregma);
        I.Seeds.L.(N)=(pixmm*Seeds.L.(N)*R+I.bregma);
    end
    
    seedcenter=zeros(2*numf,2);
    
    
    for f=0:numf-1;
        N=F{f+1};
        seedcenter(2*(f+1)-1,1)=I.Seeds.R.(N)(1);
        seedcenter(2*(f+1)-1,2)=I.Seeds.R.(N)(2);
        seedcenter(2*(f+1),1)=I.Seeds.L.(N)(1);
        seedcenter(2*(f+1),2)=I.Seeds.L.(N)(2);
    end
    
    affineMarkers = I;
    % Change to (y,x)
    seedcenter=flipdim(seedcenter,2);
    I.bregma=flipdim(I.bregma,2);
    I.tent=flipdim(I.tent,2);
    I.OF=flipdim(I.OF,2);
    
    seedcenter(:,3)=1;
    seedcenterCorrected = zeros(size(seedcenter));
    seedcenterCorrected(:,3)=1;
    seedcenterCorrected(:,1:2)= John_GalvoSeedCurvatureCxn(seedcenter(:,1:2),I,19,0); %theta_x = atan(9/26.5)*180/3.14
    
    
    %% Transform seeds in CCD Space to Galvo space
    %GalvoSeedCenter=round(seedcenter*W_CCD2Galvo*1000)/1000;  %factor of 1000 due to rounding galvo Volatages to the nearest mV
    GalvoSeedCenter=(seedcenter*W_CCD2Galvo*1000)/1000;  %rounding seems to introduce error between intended stim site and actual stim site
    GalvoSeedCenterCorrected=(seedcenterCorrected*W_CCD2Galvo*1000)/1000;  %rounding seems to introduce error between intended stim site and actual stim site
    
    
    %% Transform seeds in Galvo Space to CCD space
    %GalvoSeedCenterCCDSpace=round(GalvoSeedCenter*W_Galvo2CCD);
    GalvoSeedCenterCCDSpace=(GalvoSeedCenter*W_Galvo2CCD); %no need to round here either
    GalvoSeedCenterCCDSpaceCorrected=(GalvoSeedCenterCorrected*W_Galvo2CCD);
    
    I.OF(:,3)=1;
    I.tent(:,3)=1;
    I.bregma(:,3)=1;
    LGalvo2CCD.OF=round(I.OF*W_CCD2Galvo*W_Galvo2CCD);
    LGalvo2CCD.tent=round(I.tent*W_CCD2Galvo*W_Galvo2CCD);
    LGalvo2CCD.bregma=round(I.bregma*W_CCD2Galvo*W_Galvo2CCD);
    
    GalvoSeedCenter=GalvoSeedCenter(:,1:2);
    GalvoSeedCenterCCDSpace=GalvoSeedCenterCCDSpace(:,1:2);
    
    GalvoSeedCenterCorrected=GalvoSeedCenterCorrected(:,1:2);
    GalvoSeedCenterCCDSpaceCorrected=GalvoSeedCenterCCDSpaceCorrected(:,1:2);
    
    
    %% Visualize landmarks and seeds
    
    if max(WL(:))>1
        WL=double(WL)/255;
    else
        WL=WL;
    end
    
    
    
    figure;
    subplot(1,2,1);
    image(WL); %changed 3/1/1
    axis off
    axis image
    title('Paxinos Seeds & Corrected Seed(Red) in CCD Space');
    
    for f=1:size(seedcenter,1)
        hold on;
        plot(seedcenter(f,2),seedcenter(f,1),'ko','MarkerFaceColor','k')
        plot(seedcenterCorrected(f,2),seedcenterCorrected(f,1),'ro','MarkerFaceColor','r')
    end
    
    hold on;
    plot(I.tent(1,2),I.tent(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.bregma(1,2),I.bregma(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.OF(1,2),I.OF(1,1),'ko','MarkerFaceColor','b')
    hold on;plot(seedcenterCorrected(8,2),seedcenterCorrected(8,1),'wo','MarkerFaceColor','w')
    
    subplot(1,2,2);
    image(WL); %changed 3/1/1
    axis off
    axis image
    title('Galvo Coords Transformed to CCD Space');
    
    for f=1:size(GalvoSeedCenterCCDSpace,1)
        hold on;
        plot(GalvoSeedCenterCCDSpace(f,2),GalvoSeedCenterCCDSpace(f,1),'ko','MarkerFaceColor','k')
        plot(GalvoSeedCenterCCDSpaceCorrected(f,2),GalvoSeedCenterCCDSpaceCorrected(f,1),'ro','MarkerFaceColor','r')
    end
    
    
    hold on;
    plot(LGalvo2CCD.tent(1,2),LGalvo2CCD.tent(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(LGalvo2CCD.bregma(1,2),LGalvo2CCD.bregma(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(LGalvo2CCD.OF(1,2),LGalvo2CCD.OF(1,1),'ko','MarkerFaceColor','b')
    hold on;plot(GalvoSeedCenterCCDSpaceCorrected(8,2),GalvoSeedCenterCCDSpaceCorrected(8,1),'wo','MarkerFaceColor','w')
    
    saveas(gcf,fullfile(directory,strcat(fileName,'-WLandMarks.jpg')))
    
    
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
    
    save(fullfile(directory,strcat(fileName,'-LandmarksAndMask.mat')),'mytform','affineMarkers','WL','isbrain','xform_isbrain','xform_WL','xform_WLcrop','WLcrop')
end
% end