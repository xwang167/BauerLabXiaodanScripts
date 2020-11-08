
refseeds=GetReferenceSeeds;
%     refseeds = refseeds(1:14,:);
%                      refseeds(3,1) = 42;
%                     refseeds(3,2) = 88;
%                     refseeds(4,1) = 87;
%                     refseeds(4,2) = 88;
%                     refseeds(9,1) = 18;
%                     refseeds(9,2) = 66;
%                     refseeds(10,1) = 111;
%                     refseeds(10,2) = 66;   
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
figure
    imagesc(xform_WL)
    hold on
    scatter(refseeds(1:2,1),refseeds(1:2,2),'r','filled')
    hold on
    scatter(refseeds(3:4,1),refseeds(3:4,2),'g','filled')
     hold on
    scatter(refseeds(5:6,1),refseeds(5:6,2),'b','filled')
  hold on
    scatter(refseeds(7:8,1),refseeds(7:8,2),'m','filled')
    hold on
    scatter(refseeds(9:10,1),refseeds(9:10,2),'y','filled')
    hold on
    scatter(refseeds(11:12,1),refseeds(11:12,2),'w','filled')
        hold on
    scatter(refseeds(13:14,1),refseeds(13:14,2),'k','filled')
    
    hold on
    scatter(refseeds(15:16,1),refseeds(15:16,2),'c','filled')
    
    legend('Olfactory','Frontal','Cingulate','Motor','Somatosenory','Retrosplenial','Visual','Auditory')
    axis image off
   
    
    
    
    fixedPoints = [1.5 2;-1.5 2;0.72 3.8;-0.72 3.8];
    movingPoints = [refseeds(8,1) refseeds(8,2); refseeds(7,1) refseeds(7,2);refseeds(2,1) refseeds(2,2); refseeds(1,1) refseeds(1,2)];
    tform = fitgeotrans(movingPoints,fixedPoints,'nonreflectivesimilarity');
    [PL_x,PL_y ] = transformPointsForward(tform,refseeds(3,1),refseeds(3,2));
    [PR_x,PR_y ] = transformPointsForward(tform,refseeds(4,1),refseeds(4,2));
    
    [SSL_x,SSL_y ] = transformPointsForward(tform,refseeds(9,1),refseeds(9,2));%-3.5769,4.0769
    [SSR_x,SSR_y ] = transformPointsForward(tform,refseeds(10,1),refseeds(10,2));
   
    
 Seeds.R.Olf=[0.72 3.8]; %Olfactory
Seeds.R.Fr=[1.3 3.3];   %Frontal
Seeds.R.Cing=[0.3 1.8]; %Cingulate
Seeds.R.M=[1.5 2];      %Motor
Seeds.R.SS=[3.2 -0.5];  %Somatosenory
Seeds.R.Ret=[0.5 -2.1]; %Retrosplenial
Seeds.R.V=[2.4 -4];     %Visual
Seeds.R.Aud=[4.2 -2.7]; %Auditory)
   

Seeds.L.Olf=[-0.72 3.8];
Seeds.L.Fr=[-1.3 3.3];
Seeds.L.Cing=[-0.3 1.8];
Seeds.L.M=[-1.5 2];
Seeds.L.SS=[-3.2 -0.5];
Seeds.L.Ret=[-0.5 -2.1];
Seeds.L.V=[-2.4 -4];
Seeds.L.Aud=[-4.2 -2.7];
    

refseeds_xw = GetReferenceSeeds_xw;

figure
    imagesc(xform_WL)
    hold on
    scatter(refseeds_xw(1:2,1),refseeds_xw(1:2,2),'dr','filled')
    hold on
    scatter(refseeds_xw(3:4,1),refseeds_xw(3:4,2),'dm','filled')
     hold on
    scatter(refseeds_xw(5:6,1),refseeds_xw(5:6,2),'db','filled')
  hold on
    scatter(refseeds_xw(7:8,1),refseeds_xw(7:8,2),'dy','filled')
    hold on
    scatter(refseeds_xw(9:10,1),refseeds_xw(9:10,2),'dg','filled')
    hold on
    scatter(refseeds_xw(11:12,1),refseeds_xw(11:12,2),'dw','filled')
        hold on
    scatter(refseeds_xw(13:14,1),refseeds_xw(13:14,2),'dk','filled')
    hold on
    scatter(refseeds_xw(15:16,1),refseeds_xw(15:16,2),'dc','filled')
    legend('Olfactory','Motor','Cingulate','Somatosenory','Parietal','Retrosplenial','Auditory','Visual')
    axis image off

    movingPoints = [64.5 19;74 15;55 15];
    fixedPoints = [0 3.525;0.72 3.8;-0.72 3.8];
    tform = fitgeotrans(movingPoints,fixedPoints,'affine');
    [x,y] = transformPointsForward(tform,111, 66);
    Seeds.R.Olf=[0.72 3.8]; %Olfactory
Seeds.R.M=[1.5 2];      %Motor
Seeds.R.Cing=[0.3 1.8]; %Cingulate
Seeds.R.SS=[3.6 -0.15];  %Somatosenory
Seeds.R.P=[1.75 -1.85];  %Parietal
Seeds.R.Ret=[0.5 -2.1]; %Retrosplenial
Seeds.R.Aud=[4.2 -2.7]; %Auditory
Seeds.R.V=[2.4 -4];     %Visual
    
    