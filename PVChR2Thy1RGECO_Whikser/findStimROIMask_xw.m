function ROI= findStimROIMask_xw(peakMap,nX,nY) 
%assuming field of view of 1cm^2, draw a 2mm seed locust

        [x,y] = clicksubplot;    
        [X,Y] = meshgrid(1:nX,1:nY); % coordinates for the whole matrix
        radius = .1*nX; %calculate radius that is 2mm
        ROI = sqrt((X-x).^2+(Y-y).^2)<radius;%all the region inside of the cercle that defined by user input
        max_ROI = prctile(peakMap(ROI),99); % find 99% value just in case maximum value is from bubbles and stuff that make a super bright pixel
        temp = peakMap.*ROI;
        ROI = temp>0.5*max_ROI;
end %mean from dark frames to end