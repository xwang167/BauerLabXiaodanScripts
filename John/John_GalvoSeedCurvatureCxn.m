function [GalvoSeeds_cxn] = John_GalvoSeedCurvatureCxn(GalvoSeeds,I,theta_x,theta_y);
Mousebrain = John_Make3DMouseBrain(I); % outputs mouse brain model with (y,x) format
GalvoSeeds_cxn = zeros(size(GalvoSeeds));

for i = 1:size(GalvoSeeds,1)
    if GalvoSeeds(i,1)~=0 & GalvoSeeds(i,2)~=0;
        h = squeeze(Mousebrain(round(GalvoSeeds(i,1)),round(GalvoSeeds(i,2)),:));
        GalvoSeeds_cxn(i,1) = GalvoSeeds(i,1); %+h(2)*tand(theta_y);
        GalvoSeeds_cxn(i,2) = GalvoSeeds(i,2)+h(1)*tand(theta_x);
    end
end


% Analyze
end
