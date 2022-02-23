        jj = 1;
        kk = 1;
        sum_blocks = 0;
while sum_blocks < numBlock+1
            sum_blocks = sum_blocks + GoodSeedsidx((ii-1)*40+jj);
            if GoodSeedsidx((ii-1)*40+jj) == 1
                gridImage_HbO(:,:,m(jj)) = squeeze(xform_datahb_GSR_on(:,:,1,kk));
                gridImage_HbR(:,:,m(jj)) = squeeze(xform_datahb_GSR_on(:,:,2,kk));
                gridImage_HbT(:,:,m(jj)) = gridImage_HbO(:,:,m(jj))+gridImage_HbR(:,:,m(jj));
                gridImage_jrgeco1aCorr(:,:,m(jj)) = xform_datafluorCorr_GSR_on(:,:,kk);
                kk = kk+1;
                figure
                subplot(2,2,1)
                imagesc(gridImage_HbO(:,:,m(jj)))
                hold on
                [row_temp,col_temp] = ind2sub([16,10],m(jj));
                scatter(col_temp,row_temp,'w')
            end
            jj = jj+1;
        end