function [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxyDownSampled, ...
    deoxyDownSampled,totalDownSampled,FADCorrDownSampled,jrgecoCorrDownSampled)

subplot(1,3,1)
imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('Oxy')

subplot(1,3,2)
imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('DeOxy')

subplot(1,3,3)
imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('Total')

colormap jet
pause;
prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
title1 = 'Selet scale';
dims = [1 35];
definput = {'8e-6';'2e-6';'6e-6'};
answer = inputdlg(prompt,title1,dims,definput);
temp_oxy_max = str2double(answer{1});
temp_deoxy_max = str2double(answer{2});
temp_total_max = str2double(answer{3});
close all;

figure
subplot(1,2,1)
imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('jrgeco1aCorr')

subplot(1,2,2)
imagesc(squeeze(mean(FADCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('FADCorr')
colormap jet
pause;
prompt = {'Enter jrgeco1aCorr limit:';'Enter FADCorr limit:'};
title1 = 'Selet scale';
dims = [1 35];
definput = {'0.01','0.01'};
answer = inputdlg(prompt,title1,dims,definput);
temp_jrgeco1aCorr_max = str2double(answer{1});
temp_FADCorr_max = str2double(answer{2});
numRows = 5;

close all


figure('units','normalized','outerposition',[0 0 1 1]);
for ii = 1:numBlock
    subplot(numRows,numBlock,ii)
    imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_oxy_max temp_oxy_max]);
    title(strcat('Pres',{' '},num2str(ii)))
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('oxy')
    end
    
    subplot(numRows,numBlock,numBlock+ii)
    imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('deoxy')
    end
    
    
    subplot(numRows,numBlock,2*numBlock+ii)
    imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_total_max temp_total_max]);
    colormap jet
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('total')
    end
    
    subplot(numRows,numBlock,3*numBlock+ii)
    imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('jrgeco1aCorr')
    end
    
    subplot(numRows,numBlock,4*numBlock+ii)
    imagesc(squeeze(mean(FADCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_FADCorr_max temp_FADCorr_max]);
    if ii == 1
        ylabel('FADCorr')
    end
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
end

prompt = {'Bad blocks to remove:'};
title1 = 'Pick block';
dims = [1 35];
definput = {'[]'};
answer = inputdlg(prompt,title1,dims,definput);
blocks = 1:numBlock;
if ~strcmp(answer{1},'[]')
blocks(str2double(answer{1})) = [];
end
goodBlocks = blocks;
end