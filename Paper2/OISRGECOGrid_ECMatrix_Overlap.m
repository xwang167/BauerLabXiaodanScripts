clear all;close all;clc

%Find Overlap PV maps across weeks
group1PathPre = "X:\Paper2\PVChR2-Thy1RGECO\cat\N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322";
group2PathPre = "W:\PV Mapping After Stroke\PV\cat\Week 1-N60M1-N60M2";
group3PathPre = "W:\PV Mapping After Stroke\PV\cat\Week 4-N60M1-N60M2";
group4PathPre = "W:\PV Mapping After Stroke\PV\cat\Week 8-N60M1-N60M2";

%% find overlap seeds
load(strcat(group1PathPre,"-GoodSeedsNew.mat"),'GoodSeedsidx_FOV_mice')
GoodSeedsidx_FOV_group1 = GoodSeedsidx_FOV_mice;

load(strcat(group2PathPre,"-GoodSeedsNew.mat"),'GoodSeedsidx_FOV_mice')
GoodSeedsidx_FOV_group2 = GoodSeedsidx_FOV_mice;

load(strcat(group3PathPre,"-GoodSeedsNew.mat"),'GoodSeedsidx_FOV_mice')
GoodSeedsidx_FOV_group3 = GoodSeedsidx_FOV_mice;

load(strcat(group4PathPre,"-GoodSeedsNew.mat"),'GoodSeedsidx_FOV_mice')
GoodSeedsidx_FOV_group4 = GoodSeedsidx_FOV_mice;

temp = GoodSeedsidx_FOV_group1+GoodSeedsidx_FOV_group2+GoodSeedsidx_FOV_group3+GoodSeedsidx_FOV_group4;
GoodSeedsidx_FOV_groups = temp==4; 


%% load EC
load(strcat(group1PathPre,'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
gridEC_jRGECO1a_FOV_group1 = gridEC_jRGECO1a_mice_FOV;

load(strcat(group2PathPre,'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
gridEC_jRGECO1a_FOV_group2 = gridEC_jRGECO1a_mice_FOV;

load(strcat(group3PathPre,'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
gridEC_jRGECO1a_FOV_group3 = gridEC_jRGECO1a_mice_FOV;

load(strcat(group4PathPre,'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
gridEC_jRGECO1a_FOV_group4 = gridEC_jRGECO1a_mice_FOV;


%% load seedLocation
load(strcat(group1PathPre,'-SeedLocation.mat'),'seedLocation_mice_FOV')
seedLocation_FOV_group1 = seedLocation_mice_FOV;

load(strcat(group2PathPre,'-SeedLocation.mat'),'seedLocation_mice_FOV')
seedLocation_FOV_group2 = seedLocation_mice_FOV;

load(strcat(group3PathPre,'-SeedLocation.mat'),'seedLocation_mice_FOV')
seedLocation_FOV_group3 = seedLocation_mice_FOV;

load(strcat(group4PathPre,'-SeedLocation.mat'),'seedLocation_mice_FOV')
seedLocation_FOV_group4 = seedLocation_mice_FOV;

seedLocation_FOV_groups = nan(2,160);
seedLocation_FOV_groups(1,:) = (seedLocation_FOV_group1(1,:)+seedLocation_FOV_group2(1,:)+seedLocation_FOV_group3(1,:)+seedLocation_FOV_group4(1,:))/4;
seedLocation_FOV_groups(2,:) = (seedLocation_FOV_group1(2,:)+seedLocation_FOV_group2(2,:)+seedLocation_FOV_group3(2,:)+seedLocation_FOV_group4(2,:))/4;

load('AtlasandIsbrain.mat')

%% Find bad frames from seed location and grid EC
bad_seed_frame_groups = union(find(isnan(seedLocation_FOV_group1(1,:))),...
                        union(find(isnan(seedLocation_FOV_group2(1,:))),...
                        union(find(isnan(seedLocation_FOV_group3(1,:))),...
                              find(isnan(seedLocation_FOV_group4(1,:))))));
bad_gridEC_frame_groups = union(find(isnan(squeeze(gridEC_jRGECO1a_FOV_group1(64,64,:)))),...
                          union(find(isnan(squeeze(gridEC_jRGECO1a_FOV_group2(64,64,:)))),...
                          union(find(isnan(squeeze(gridEC_jRGECO1a_FOV_group3(64,64,:)))),...
                                find(isnan(squeeze(gridEC_jRGECO1a_FOV_group4(64,64,:)))))));
badFrames = union(bad_seed_frame_groups,bad_gridEC_frame_groups);

%% Find index inside of the brain atlas
atlasIndx_groups = nan(1,160);
seedLocation_valid_FOV_groups = nan(2,160);
for ii = 1:160
    if ~ismember(ii,badFrames)
        seedLocation_valid_FOV_groups(:,ii) = round(seedLocation_FOV_groups(:,ii));
        atlasIndx_groups(ii) = AtlasSeedsFilled(seedLocation_valid_FOV_groups(1,ii),...
           seedLocation_valid_FOV_groups(2,ii));
        if atlasIndx_groups(ii)==0
          atlasIndx_groups(ii) = NaN;
        end
    end
end

bad_atlas_frame = find(isnan(atlasIndx_groups));
badFrames = union(badFrames,bad_atlas_frame);

%% remove bad frames
atlasIndx_valid_FOV_group = atlasIndx_groups;
atlasIndx_valid_FOV_group(badFrames) = [];

seedLocation_FOV_group1(:,badFrames) = [];
seedLocation_FOV_group2(:,badFrames) = [];
seedLocation_FOV_group3(:,badFrames) = [];
seedLocation_FOV_group4(:,badFrames) = [];

gridEC_jRGECO1a_FOV_group1(:,:,badFrames) = [];
gridEC_jRGECO1a_FOV_group2(:,:,badFrames) = [];
gridEC_jRGECO1a_FOV_group3(:,:,badFrames) = [];
gridEC_jRGECO1a_FOV_group4(:,:,badFrames) = [];
%% find index to sort the matrix in the order of functional regions
[atlasIndx_valid_sorted_FOV,I_FOV] = sort(atlasIndx_valid_FOV_group);

seedLocation_valid_sorted_FOV_group1 = seedLocation_FOV_group1(:,I_FOV);
seedLocation_valid_sorted_FOV_group2 = seedLocation_FOV_group2(:,I_FOV);
seedLocation_valid_sorted_FOV_group3 = seedLocation_FOV_group3(:,I_FOV);
seedLocation_valid_sorted_FOV_group4 = seedLocation_FOV_group4(:,I_FOV);

gridEC_jRGECO1a_valid_sorted_FOV_group1 = gridEC_jRGECO1a_FOV_group1(:,:,I_FOV);
gridEC_jRGECO1a_valid_sorted_FOV_group2 = gridEC_jRGECO1a_FOV_group2(:,:,I_FOV);
gridEC_jRGECO1a_valid_sorted_FOV_group3 = gridEC_jRGECO1a_FOV_group3(:,:,I_FOV);
gridEC_jRGECO1a_valid_sorted_FOV_group4 = gridEC_jRGECO1a_FOV_group4(:,:,I_FOV);
%% Construct the PV EC matrix

%% right seed location
seedLocation_valid_sorted_R_FOV_group1 = nan(2,length(seedLocation_valid_sorted_FOV_group1));
seedLocation_valid_sorted_R_FOV_group1(1,:) = seedLocation_valid_sorted_FOV_group1(1,:);
seedLocation_valid_sorted_R_FOV_group1(2,:) = 129-seedLocation_valid_sorted_FOV_group1(2,:);

seedLocation_valid_sorted_R_FOV_group2 = nan(2,length(seedLocation_valid_sorted_FOV_group2));
seedLocation_valid_sorted_R_FOV_group2(1,:) = seedLocation_valid_sorted_FOV_group2(1,:);
seedLocation_valid_sorted_R_FOV_group2(2,:) = 129-seedLocation_valid_sorted_FOV_group2(2,:);

seedLocation_valid_sorted_R_FOV_group3 = nan(2,length(seedLocation_valid_sorted_FOV_group3));
seedLocation_valid_sorted_R_FOV_group3(1,:) = seedLocation_valid_sorted_FOV_group3(1,:);
seedLocation_valid_sorted_R_FOV_group3(2,:) = 129-seedLocation_valid_sorted_FOV_group3(2,:);

seedLocation_valid_sorted_R_FOV_group4 = nan(2,length(seedLocation_valid_sorted_FOV_group4));
seedLocation_valid_sorted_R_FOV_group4(1,:) = seedLocation_valid_sorted_FOV_group4(1,:);
seedLocation_valid_sorted_R_FOV_group4(2,:) = 129-seedLocation_valid_sorted_FOV_group4(2,:);


[X,Y] = meshgrid(1:128,1:128);
ECMatrix_valid_sorted_L_FOV_group1 = nan(length(seedLocation_valid_sorted_R_FOV_group1),length(seedLocation_valid_sorted_R_FOV_group1)); %95
ECMatrix_valid_sorted_R_FOV_group1 = nan(length(seedLocation_valid_sorted_R_FOV_group1),length(seedLocation_valid_sorted_R_FOV_group1));

ECMatrix_valid_sorted_L_FOV_group2 = nan(length(seedLocation_valid_sorted_R_FOV_group2),length(seedLocation_valid_sorted_R_FOV_group2)); %95
ECMatrix_valid_sorted_R_FOV_group2 = nan(length(seedLocation_valid_sorted_R_FOV_group2),length(seedLocation_valid_sorted_R_FOV_group2));

ECMatrix_valid_sorted_L_FOV_group3 = nan(length(seedLocation_valid_sorted_R_FOV_group3),length(seedLocation_valid_sorted_R_FOV_group3)); %95
ECMatrix_valid_sorted_R_FOV_group3 = nan(length(seedLocation_valid_sorted_R_FOV_group3),length(seedLocation_valid_sorted_R_FOV_group3));

ECMatrix_valid_sorted_L_FOV_group4 = nan(length(seedLocation_valid_sorted_R_FOV_group4),length(seedLocation_valid_sorted_R_FOV_group4)); %95
ECMatrix_valid_sorted_R_FOV_group4 = nan(length(seedLocation_valid_sorted_R_FOV_group4),length(seedLocation_valid_sorted_R_FOV_group4));

%% left matrix
for ii = 1:length(seedLocation_valid_sorted_FOV_group1)
    map1 = gridEC_jRGECO1a_valid_sorted_FOV_group1(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group1)
        x1 = seedLocation_valid_sorted_FOV_group1(2,jj);
        y1 = seedLocation_valid_sorted_FOV_group1(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map1 = reshape(map1,128*128,[]);
        ECMatrix_valid_sorted_L_FOV_group1(ii,jj) = nanmean(map1(ROI));
    end
end

for ii = 1:length(seedLocation_valid_sorted_FOV_group2)
    map2 = gridEC_jRGECO1a_valid_sorted_FOV_group2(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group2)
        x1 = seedLocation_valid_sorted_FOV_group2(2,jj);
        y1 = seedLocation_valid_sorted_FOV_group2(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map2 = reshape(map2,128*128,[]);
        ECMatrix_valid_sorted_L_FOV_group2(ii,jj) = nanmean(map2(ROI));
    end
end


for ii = 1:length(seedLocation_valid_sorted_FOV_group3)
    map3 = gridEC_jRGECO1a_valid_sorted_FOV_group3(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group3)
        x1 = seedLocation_valid_sorted_FOV_group3(2,jj);
        y1 = seedLocation_valid_sorted_FOV_group3(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map3 = reshape(map3,128*128,[]);
        ECMatrix_valid_sorted_L_FOV_group3(ii,jj) = nanmean(map3(ROI));
    end
end

for ii = 1:length(seedLocation_valid_sorted_FOV_group4)
    map4 = gridEC_jRGECO1a_valid_sorted_FOV_group4(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group4)
        x1 = seedLocation_valid_sorted_FOV_group4(2,jj);
        y1 = seedLocation_valid_sorted_FOV_group4(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map4 = reshape(map4,128*128,[]);
        ECMatrix_valid_sorted_L_FOV_group4(ii,jj) = nanmean(map4(ROI));
    end
end

%% right matrix
for ii = 1:length(seedLocation_valid_sorted_FOV_group1)
    map1 = gridEC_jRGECO1a_valid_sorted_FOV_group1(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group1)
        x1 = seedLocation_valid_sorted_R_FOV_group1(2,jj);
        y1 = seedLocation_valid_sorted_R_FOV_group1(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map1 = reshape(map1,128*128,[]);
        ECMatrix_valid_sorted_R_FOV_group1(ii,jj) = nanmean(map1(ROI));
    end
end

for ii = 1:length(seedLocation_valid_sorted_FOV_group2)
    map2 = gridEC_jRGECO1a_valid_sorted_FOV_group2(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group2)
        x1 = seedLocation_valid_sorted_R_FOV_group2(2,jj);
        y1 = seedLocation_valid_sorted_R_FOV_group2(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map2 = reshape(map2,128*128,[]);
        ECMatrix_valid_sorted_R_FOV_group2(ii,jj) = nanmean(map2(ROI));
    end
end


for ii = 1:length(seedLocation_valid_sorted_FOV_group3)
    map3 = gridEC_jRGECO1a_valid_sorted_FOV_group3(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group3)
        x1 = seedLocation_valid_sorted_R_FOV_group3(2,jj);
        y1 = seedLocation_valid_sorted_R_FOV_group3(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map3 = reshape(map3,128*128,[]);
        ECMatrix_valid_sorted_R_FOV_group3(ii,jj) = nanmean(map3(ROI));
    end
end

for ii = 1:length(seedLocation_valid_sorted_FOV_group4)
    map4 = gridEC_jRGECO1a_valid_sorted_FOV_group4(:,:,ii);
    for jj = 1:length(seedLocation_valid_sorted_FOV_group4)
        x1 = seedLocation_valid_sorted_R_FOV_group4(2,jj);
        y1 = seedLocation_valid_sorted_R_FOV_group4(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map4 = reshape(map4,128*128,[]);
        ECMatrix_valid_sorted_R_FOV_group4(ii,jj) = nanmean(map4(ROI));
    end
end


%% Left and Right matrix together
ECMatrix_valid_sorted_LR_FOV_group1 = nan(length(seedLocation_valid_sorted_FOV_group1),length(seedLocation_valid_sorted_FOV_group1)*2);
ECMatrix_valid_sorted_LR_FOV_group1(:,1:length(seedLocation_valid_sorted_FOV_group1)) = ECMatrix_valid_sorted_L_FOV_group1;
ECMatrix_valid_sorted_LR_FOV_group1(:,length(seedLocation_valid_sorted_FOV_group1)+1:end) = ECMatrix_valid_sorted_R_FOV_group1;

ECMatrix_valid_sorted_LR_FOV_group2 = nan(length(seedLocation_valid_sorted_FOV_group2),length(seedLocation_valid_sorted_FOV_group2)*2);
ECMatrix_valid_sorted_LR_FOV_group2(:,1:length(seedLocation_valid_sorted_FOV_group2)) = ECMatrix_valid_sorted_L_FOV_group2;
ECMatrix_valid_sorted_LR_FOV_group2(:,length(seedLocation_valid_sorted_FOV_group2)+1:end) = ECMatrix_valid_sorted_R_FOV_group2;

ECMatrix_valid_sorted_LR_FOV_group3 = nan(length(seedLocation_valid_sorted_FOV_group3),length(seedLocation_valid_sorted_FOV_group3)*2);
ECMatrix_valid_sorted_LR_FOV_group3(:,1:length(seedLocation_valid_sorted_FOV_group3)) = ECMatrix_valid_sorted_L_FOV_group3;
ECMatrix_valid_sorted_LR_FOV_group3(:,length(seedLocation_valid_sorted_FOV_group3)+1:end) = ECMatrix_valid_sorted_R_FOV_group3;

ECMatrix_valid_sorted_LR_FOV_group4 = nan(length(seedLocation_valid_sorted_FOV_group4),length(seedLocation_valid_sorted_FOV_group4)*2);
ECMatrix_valid_sorted_LR_FOV_group4(:,1:length(seedLocation_valid_sorted_FOV_group4)) = ECMatrix_valid_sorted_L_FOV_group4;
ECMatrix_valid_sorted_LR_FOV_group4(:,length(seedLocation_valid_sorted_FOV_group4)+1:end) = ECMatrix_valid_sorted_R_FOV_group4;

%% Visualization
[C, ia, ic] = unique(atlasIndx_valid_sorted_FOV);
seednames_sorted = cell(1,length(C)*2);
for ii = 1:length(C)
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
    seednames_sorted{ii+length(C)} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end

% Group1
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group1,[-1.4 1.4]);
title('Healthy Mice')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;

% Group2
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group2,[-1.4 1.4]);
title('Week 1 after Stroke')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group2,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;

% Group3
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group3,[-1.4 1.4]);
title('Week 4 after Stroke')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group3,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;

% Group4
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group4,[-1.4 1.4]);
title('Week 8 after Stroke')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group4,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;

%% difference between groups
% group2-group1
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group2-ECMatrix_valid_sorted_LR_FOV_group1,[-1.4 1.4]);
title('Week 1 - Healthy Mice')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;


% group3-group1
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group3-ECMatrix_valid_sorted_LR_FOV_group1,[-1.4 1.4]);
title('Week 4 - Healthy Mice')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
% group3-group2

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group3-ECMatrix_valid_sorted_LR_FOV_group2,[-1.4 1.4]);
title('Week 4 - Week1')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
%% 
% group1-group2
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group1-ECMatrix_valid_sorted_LR_FOV_group2,[-0.8 0.8]);
title('Healthy Mice - Week 1')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;

% group1-group3
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group1-ECMatrix_valid_sorted_LR_FOV_group3,[-0.8 0.8]);
title('Healthy Mice - Week 4')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
figure
imagesc(atlasIndx_valid_sorted_FOV')
colormap hsv
axis image
[C, ia, ic] = unique(atlasIndx_valid_sorted_FOV);
seednames_sorted = cell(1,length(C)*2);
for ii = 1:length(C)
seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
seednames_sorted{ii+length(C)*2} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)

% group1-group4
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_valid_sorted_LR_FOV_group1-ECMatrix_valid_sorted_LR_FOV_group4,[-0.8 0.8]);
title('Healthy Mice - Week 8')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-0.8 0 0.8])
axis image

yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_valid_sorted_L_FOV_group1,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
figure
imagesc(atlasIndx_valid_sorted_FOV')
colormap hsv
axis image
[C, ia, ic] = unique(atlasIndx_valid_sorted_FOV);
seednames_sorted = cell(1,length(C)*2);
for ii = 1:length(C)
seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
seednames_sorted{ii+length(C)*2} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)

%% spatial correlation
group1_vector = reshape(ECMatrix_valid_sorted_L_FOV_group1,1,[]);
group2_vector = reshape(ECMatrix_valid_sorted_L_FOV_group2,1,[]);
group3_vector = reshape(ECMatrix_valid_sorted_L_FOV_group3,1,[]);
group4_vector = reshape(ECMatrix_valid_sorted_L_FOV_group4,1,[]);

group3_vector(isnan(group3_vector)) = 0;
group4_vector(isnan(group4_vector)) = 0;
corr12 = corr(group1_vector',group2_vector');
corr13 = corr(group1_vector',group3_vector');
corr14 = corr(group1_vector',group4_vector');

%% EC changes within anterior regions (Fr, M and SS regions)
group1_front = median(ECMatrix_valid_sorted_LR_FOV_group1(1:63,1:63),'all');
group2_front = median(ECMatrix_valid_sorted_LR_FOV_group2(1:63,1:63),'all');
group3_front = median(ECMatrix_valid_sorted_LR_FOV_group3(1:63,1:63),'all');
group4_front = median(ECMatrix_valid_sorted_LR_FOV_group4(1:63,1:63),'all');
%% EC changes within posterior region (in Fr, M and SS regions)
group1_back = median(ECMatrix_valid_sorted_LR_FOV_group1(64:100,64:100),'all');
group2_back = median(ECMatrix_valid_sorted_LR_FOV_group2(64:100,64:100),'all');
group3_back = nanmedian(ECMatrix_valid_sorted_LR_FOV_group3(64:100,64:100),'all');
group4_back = nanmedian(ECMatrix_valid_sorted_LR_FOV_group4(64:100,64:100),'all');
%% EC changes between anterior and posterior
mask_temp = zeros(100,100);
mask_temp(1:63,1:63) = 1;
mask_temp(64:100,64:100) = 1;
mask_temp = ~logical(mask_temp);
group1_other = median(ECMatrix_valid_sorted_LR_FOV_group1(mask_temp));
group2_other = median(ECMatrix_valid_sorted_LR_FOV_group2(mask_temp));
group3_other = nanmedian(ECMatrix_valid_sorted_LR_FOV_group3(mask_temp));
group4_other = nanmedian(ECMatrix_valid_sorted_LR_FOV_group4(mask_temp));
%% visualization
figure
subplot(1,4,1)
plot([1,2,3,4],[1,corr12,corr13,corr14],'-s')
xlim([0.5 4.5])
ylim([0.8 1])
xticks([1,2,3,4])
xticklabels({'Healthy Mice','Week 1','Week 4','Week 8'})
ylabel('Spatial Correlation')
title('Spatial correlation')

subplot(1,4,2)
plot([1,2,3,4],[group1_front,group2_front,group3_front,group4_front],'-s')
xlim([0.5 4.5])

xticks([1,2,3,4])
xticklabels({'Healthy Mice','Week 1','Week 4','Week 8'})
ylabel('z(r)')
title('EC within Anterior Regions')

subplot(1,4,3)
plot([1,2,3,4],[group1_back,group2_back,group3_back,group4_back],'-s')
xlim([0.5 4.5])

xticks([1,2,3,4])
xticklabels({'Healthy Mice','Week 1','Week 4','Week 8'})
ylabel('z(r)')
title('EC within Posterior Regions')

subplot(1,4,4)
plot([1,2,3,4],[group1_other,group2_other,group3_other,group4_other],'-s')
xlim([0.5 4.5])

xticks([1,2,3,4])
xticklabels({'Healthy Mice','Week 1','Week 4','Week 8'})
ylabel('z(r)')
title('EC between anterior and posterior regions')



