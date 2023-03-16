load('N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitionMap.mat',...
    'inhibitionMap_Calcium_NoGSR_mice')
load('N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-SeedLocation.mat',...
    'seedLocation_mice_FOV')
inhibitionArea = zeros(128,128,160);
for location = 1:160
    if isnan(seedLocation_mice_FOV(1,location))
        inhibitionArea(:,:,location) = nan;
    else
        [X,Y] = meshgrid(1:128,1:128);
        radius = 3; 
        ROI = sqrt((X-seedLocation_mice_FOV(2,location)).^2+(Y-seedLocation_mice_FOV(1,location)).^2)<radius;
        inhibitionMap_Calcium_NoGSR_mice = reshape(inhibitionMap_Calcium_NoGSR_mice,128*128,160)
        maxArea = inhibitionMap_Calcium_NoGSR_mice
    end
end
