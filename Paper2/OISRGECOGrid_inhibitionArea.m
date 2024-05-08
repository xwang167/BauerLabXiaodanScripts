load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitionMap.mat',...
    'inhibitionMap_Calcium_NoGSR_mice')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-SeedLocation.mat',...
    'seedLocation_mice_FOV')
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSTD.mat',...
    'stdMap')
load('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitSNR.mat',...
    'snrMap')

%%
inhibitArea = zeros(128,128,160);
mycolormap =customcolormap_preset('brown-white-pool');
mycolormap2 =customcolormap_preset('red-yellow-green');
localInhibitArea = nan(1,160);
distantInhibitArea = nan(1,160);
totalArea = zeros(1,160);
validLocation = nan(1,160);
for location = 138
    X_center = round(seedLocation_mice_FOV(2,location));
    Y_center = round(seedLocation_mice_FOV(1,location));
    if ~isnan(seedLocation_mice_FOV(1,location))
        if mask(Y_center,X_center)
            % find the most inhibition site around the laser spot(not necessary align with each other)
            [X,Y] = meshgrid(1:128,1:128);
            radius = 6;
            ROI = sqrt((X-seedLocation_mice_FOV(2,location)).^2+(Y-seedLocation_mice_FOV(1,location)).^2)<radius;
            peakMap = inhibitionMap_Calcium_NoGSR_mice(:,:,location);
            peakMap(~ROI) = nan;
            [M,I] = min(peakMap,[],'all');
            % If there is inhibtion
            if M<0
                [minRow,minCol] = ind2sub([128,128],I);
                temp = inhibitionMap_Calcium_NoGSR_mice(:,:,location);

                % only consider pixels that is not vasculature
                temp(logical(1-mask)) = nan;
                % find regions that has higher inhibition than 50% of the
                % maximium inhibition
                area = temp<0.5*M;
                % find different connected regions
                CC= bwconncomp(area);
                % number of different connected regions
                numRegions = length(CC.PixelIdxList);
                % index number for the laser center
                ind_center = sub2ind([128,128], Y_center, X_center);
                % initilization
                localInhibitionInd = [];
                for region = 1:numRegions
                    % total inhibition pixels
                    totalArea(location) = totalArea(location) + length(CC.PixelIdxList{region});
                    k = find(CC.PixelIdxList{region}==ind_center);
                    if ~isempty(k)
                        localInhibitionInd = region;
                    end
                end

                if ~isempty(localInhibitionInd)
                    
                    validLocation(location) = 1;
                    localInhibitArea(location) = length(CC.PixelIdxList{localInhibitionInd});
                    distantInhibitArea(location) = totalArea(location) - localInhibitArea(location); 
                    contourLocalInhibition = zeros(128*128,1);
                    contourLocalInhibition(CC.PixelIdxList{localInhibitionInd}) = 1;
                    contourLocalInhibition = reshape(contourLocalInhibition,128,128);
                    figure('units','normalized','outerposition',[0 0 1 1])
                    ax(1) = subplot(1,3,1);
                    imagesc(temp,[-1 1])
                    colormap(ax(1),mycolormap)
                    a = colorbar;
                    a.Label.String = '\DeltaF/F%';
                    axis image off
                    hold on
                    contour(area,'k')
                    hold on
                    contour(contourLocalInhibition,'m')
                    hold on
                    scatter(seedLocation_mice_FOV(2,location),seedLocation_mice_FOV(1,location),'b','filled')
                    title(strcat('distant area = ',num2str(distantInhibitArea(location)),'Pix'))

                    ax(2) = subplot(1,3,2);
                    imagesc(stdMap(:,:,location),[0,2])
                    colormap(ax(2),mycolormap2)
                    axis image off
                    a = colorbar;
                    a.Label.String = '\DeltaF/F%';
                    title(strcat('mean std = ',num2str(nanmean(stdMap(:,:,location),'all'))))

                    ax(3) = subplot(1,3,3);
                    imagesc(abs(snrMap(:,:,location)),[0,2])
                    colormap(ax(3),brewermap(256, '-Spectral'));
                    axis image off
                    a = colorbar;
                    title(strcat('mean abs(snr) = ',num2str(nanmean(abs(snrMap(:,:,location)),'all'))))
                    sgtitle(strcat('location #',num2str(location)))

                    pause
                    close all
                end
            end
        end
    end
end
stdMap_vector = reshape(stdMap,128*128,160);
stdMap_vector = nanmean(stdMap_vector);
validMask = ~isnan(stdMap_vector);
[~, nonnanrank] = sort(stdMap_vector(validMask));
order = zeros(size(stdMap_vector));
order(validMask) = nonnanrank;

save('X:\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-inhibitArea.mat',...
    'localInhibitArea','distantInhibitArea','validLocation')