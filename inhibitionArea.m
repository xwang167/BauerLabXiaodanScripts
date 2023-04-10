load('N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitionMap.mat',...
    'inhibitionMap_Calcium_NoGSR_mice')
load('N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-SeedLocation.mat',...
    'seedLocation_mice_FOV')
%%
inhibitArea = zeros(128,128,160);
mycolormap =customcolormap_preset('brown-white-pool');
delete = [2,17,33,34,49,65,66,81,97,99,107,114,115,116,117,118,119,120,121,122,123,130,1431,132,134,135,136,137,146,147,148,149,151];
adjust = [9,11,12,15,26,28,29,31,32,45,47,48,64,70,108];
for location = 1:160
    if ~isnan(seedLocation_mice_FOV(1,location))
        % find the most inhibition site around the laser spot(not necessary align with each other)
        [X,Y] = meshgrid(1:128,1:128);
        radius = 6; 
        ROI = sqrt((X-seedLocation_mice_FOV(2,location)).^2+(Y-seedLocation_mice_FOV(1,location)).^2)<radius;
        peakMap = inhibitionMap_Calcium_NoGSR_mice(:,:,location);
        peakMap(~ROI) = nan;
        [M,I] = min(peakMap,[],'all');
        if M<0
            [minRow,minCol] = ind2sub([128,128],I);
            temp = inhibitionMap_Calcium_NoGSR_mice(:,:,location);
            temp(:,65:128) = nan;
            area = temp<0.5*M;
            CC= bwconncomp(area);
            S = regionprops(CC,'Centroid');
            centroids = cat(1,S.Centroid);
            numRegions = size(centroids,1);
            distance = zeros(numRegions,1);
            for region = 1:numRegions
                    distance(region) = sqrt((centroids(region,1)-minCol)^2+(centroids(region,2)-minRow)^2);
            end
            [~,indRegion] = min(distance);
            inhibitArea(location) = length(CC.PixelIdxList{indRegion});
            contourInhibition = zeros(128*128,1);
            contourInhibition(CC.PixelIdxList{indRegion}) = 1;
            contourInhibition = reshape(contourInhibition,128,128);
            figure('units','normalized','outerposition',[0 0 1 1])   
            imagesc(inhibitionMap_Calcium_NoGSR_mice(:,:,location),[-1 1])
            colormap(mycolormap)
            a = colorbar;
            a.Label.String = '\DeltaF/F%';
            axis image off
            hold on
            contour(ROI,'w','LineWidth',0.1)
            hold on
            contour(area,'k')
            hold on
            contour(contourInhibition,'m')
            hold on
            scatter(seedLocation_mice_FOV(2,location),seedLocation_mice_FOV(1,location),'b','filled')
            hold on
            scatter(minCol,minRow,'r','filled')
            if ~isempty(find(delete == location))
                title(strcat('Need to disregard location #',num2str(location),', total area = ',num2str(inhibitArea(location)),'Pix'))
                inhibitArea(location) = 0;
            elseif ~isempty(find(adjust == location))
                title(strcat('Need to adjust location #',num2str(location),', total area = ',num2str(inhibitArea(location)),'Pix'))
            else
            title(strcat('location #',num2str(location),', total area = ',num2str(inhibitArea(location)),'Pix'))
            end
            pause
            close all
        end
    end
end
