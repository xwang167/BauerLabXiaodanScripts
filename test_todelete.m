seedLocation = nan(2,3,160);
seedLocation_mice = nan(2,160);
for ii = 1:160
    if GoodSeedsidx_new_mice(ii)
    [~,I_1] = max(gridLaser_mice(:,:,ii,1),[],'all','linear');
    [row_1,col_1] = ind2sub([128 128],I_1);
    seedLocation(1,1,ii) = row_1;
    seedLocation(2,1,ii) = col_1;
    
    [~,I_2] = max(gridLaser_mice(:,:,ii,2),[],'all','linear');
    [row_2,col_2] = ind2sub([128 128],I_2);
    seedLocation(1,2,ii) = row_2;
    seedLocation(2,2,ii) = col_2;
    
    [~,I_3] = max(squeeze(gridLaser_mice(:,:,ii,3)),[],'all','linear');
    [row_3,col_3] = ind2sub([128 128],I_3);
    seedLocation(1,3,ii) = row_3;
    seedLocation(2,3,ii) = col_3;
    pgon = polyshape(seedLocation(2,:,ii),seedLocation(1,:,ii));
    [seedLocation_mice(1,ii),seedLocation_mice(2,ii)]= centroid(pgon);
    end
end