function [seedcenter] = GenerateCCDSeed_Zyla(directory,fileName,mytform)%, darkFramesTotal,greenInd,redInd)

% This function calculates the locations of the predefinded seeds in atlas
% space and maps them to mouse space. "seedcenter" contains the locations
% of the seeds in mouse space, and I contains the landmark location

        
    
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
    imageCam1 = readOneFrame_Zyla(fullfile(directory,strcat(fileName,'-WL-cam1')),nVy,nVx,82);%xw,211126: 87 to 88%6,87
    imageCam2 = readOneFrame_Zyla(fullfile(directory,strcat(fileName,'-WL-cam2')),nVy,nVx,88);%xw,211126: 87 to 89;%7,87
    
    [WL,mytform] = getTransformationandWL_withTform(imageCam1,imageCam2,nVy,nVx,mytform); %xw changed 211125
    
    
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
    
    I.OF(:,3)=1;
    I.tent(:,3)=1;
    I.bregma(:,3)=1;
  
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
    end
    
    hold on;
    plot(I.tent(1,2),I.tent(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.bregma(1,2),I.bregma(1,1),'ko','MarkerFaceColor','b')
    hold on;
    plot(I.OF(1,2),I.OF(1,1),'ko','MarkerFaceColor','b')
   
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
    I = affineMarkers;
    save(fullfile(directory,strcat(fileName,'-LandmarksAndMask.mat')),...
        'mytform','I','WL','isbrain','xform_isbrain','xform_WL','xform_WLcrop','WLcrop','seedcenter')%xw:211126 affineMarkers to I in order to compatible with new pipeline
end
% end