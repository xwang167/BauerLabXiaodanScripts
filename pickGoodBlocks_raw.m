function [goodBlocks] = pickGoodBlocks_raw(stimStartTime,stimEndTime,numBlock,oxyDownSampled, ...
    deoxyDownSampled,totalDownSampled,greenFluorCorrDownSampled,jrgecoCorrDownSampled)


load('J:\RGECO\cat\ROI_NoGSR_Awake.mat')

subplot(1,3,1)
imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('Green')
oxyDownSampled_2 = reshape(oxyDownSampled,[],size(oxyDownSampled,3)*size(oxyDownSampled,4));
iROI = find(ROI_NoGSR==1);
oxy_active = mean(oxyDownSampled_2(iROI,:),1);

subplot(1,3,2)
imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('red')

subplot(1,3,3)
imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
colorbar
axis image off
title('laser')

colormap jet
pause;
prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
title1 = 'Selet scale';
dims = [1 35];
definput = {'10';'5';'5'};
answer = inputdlg(prompt,title1,dims,definput);
temp_oxy_max = str2double(answer{1});
temp_deoxy_max = str2double(answer{2});
temp_total_max = str2double(answer{3});
close all;

if ~isempty(jrgecoCorrDownSampled)
    
    figure
    subplot(1,2,1)
    imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
    colorbar
    axis image off
    title('jrgeco1aCorr')
    
    
end

if ~isempty(greenFluorCorrDownSampled)
    subplot(1,2,2)
    imagesc(squeeze(mean(greenFluorCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
    colorbar
    axis image off
end

colormap jet

if ~isempty(greenFluorCorrDownSampled)
    if ~isempty(jrgecoCorrDownSampled)
        title('FADCorr')
        
        pause;
        prompt = {'Enter jrgeco1aCorr limit:';'Enter FADCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'3','3'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_jrgeco1aCorr_max = str2double(answer{1});
        temp_greenFluorCorr_max = str2double(answer{2});
        numRows = 5;
        
    else
        title('gcampCorr')
        
        pause;
        prompt = {'Enter gcampCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'0.01'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_greenFluorCorr_max = str2double(answer{1});
        
        numRows = 4;
    end
else
    numRows = 3;
end




close all

figure
plot(1:length(oxy_active),oxy_active);

figure('units','normalized','outerposition',[0 0 1 1]);
for ii = 1:numBlock
    subplot(numRows,numBlock,ii)
    imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_oxy_max temp_oxy_max]);
    title(strcat('Pres',{' '},num2str(ii)))
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('green')
    end
    
    subplot(numRows,numBlock,numBlock+ii)
    imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('red')
    end
    
    
    subplot(numRows,numBlock,2*numBlock+ii)
    imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_total_max temp_total_max]);
    colormap jet
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('laser')
    end
    
    if ~isempty(greenFluorCorrDownSampled)
    subplot(numRows,numBlock,3*numBlock+ii)
    imagesc(squeeze(mean(greenFluorCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_greenFluorCorr_max temp_greenFluorCorr_max]);
    if ii == 1
        if ~isempty(jrgecoCorrDownSampled)
            ylabel('FADCorr')
        else
            ylabel('gcampCorr')
        end
        
    end
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    end
    
    if ~isempty(jrgecoCorrDownSampled)
        
        subplot(numRows,numBlock,4*numBlock+ii)
        imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('jrgeco1aCorr')
        end
    end
    
end


prompt = {'Bad blocks to remove:'};
title1 = 'Pick block';
dims = [1 35];
definput = {'[]'};
answer = inputdlg(prompt,title1,dims,definput);
blocks = 1:numBlock;
if ~isempty(str2num(answer{1}))
    blocks(str2num(answer{1})) = [];
end
goodBlocks = blocks;
end