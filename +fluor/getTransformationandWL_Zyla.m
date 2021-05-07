function [WL,mytform] = getTransformationandWL_Zyla(firstFrame_cam1,firstFrame_cam2,nVy,nVx,mytform)
fixed = firstFrame_cam1./max(max(firstFrame_cam1));
unregistered = firstFrame_cam2./max(max(firstFrame_cam2));
if isempty(mytform)
    f = msgbox(['click four pairs of points',newline,'export in movingPoints and fixedPoints',newline,'close after finish selection']);
    pause(0.5)
    [movingPoints,fixedPoints] = cpselect(unregistered,fixed,'Wait',true);
    mytform = fitgeotrans(movingPoints, fixedPoints, 'projective');
end

registered = imwarp(unregistered, mytform,'OutputView',imref2d(size(unregistered)));
C  = imfuse(registered,fixed,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure;
imagesc(C);
axis image off
title('projective')

WL = zeros(nVy,nVx,3);
WL(:,:,1) = registered;
WL(:,:,2) = fixed;
WL(:,:,3) = fixed;

