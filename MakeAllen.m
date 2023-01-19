clear;close all;clc
load('AtlasandIsbrain_new.mat','AtlasSeeds_allen','CmapAllNetworks_allen')
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\labels.mat")
AtlasSeeds = zeros(128,128);
AtlasSeeds_allen(AtlasSeeds_allen == 0) = nan;
AtlasSeeds(:,1:64) = AtlasSeeds_allen(:,1:64);
for ii = 1:64
    AtlasSeeds(:,129-ii) = AtlasSeeds_allen(:,ii)+25;
end
imagesc(AtlasSeeds,[1 50])
colormap jet
axis image off
parcelnames = cell(1,50);
for ii = 1:25
    parcelnames{CmapAllNetworks_allen{ii,2}} = strcat(CmapAllNetworks_allen{ii,1},{' '},'L');
    parcelnames{CmapAllNetworks_allen{ii,2}+25} = strcat(CmapAllNetworks_allen{ii,1},{' '},'R');
end
outnew = table2cell(outnew);
FullName = outnew(:,1:3);
FullName = sortrows(FullName,3);
save("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds','FullName')