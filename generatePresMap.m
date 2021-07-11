function generatePresMap(stimStartTime,stimEndTime,numBlock,oxyDownSampled, ...
    deoxyDownSampled,totalDownSampled,greenFluorCorrDownSampled,jrgecoCorrDownSampled,ROI)

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
% pause;
% prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
% title1 = 'Selet scale';
% dims = [1 35];
% definput = {'10';'5';'5'};
% answer = inputdlg(prompt,title1,dims,definput);
% temp_oxy_max = str2double(answer{1});
% temp_deoxy_max = str2double(answer{2});
% temp_total_max = str2double(answer{3});
temp_oxy_max = 6;%0.5;
temp_deoxy_max = 2;%0.25;
temp_total_max = 4;%0.5;
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


if ~isempty(jrgecoCorrDownSampled)&&~isempty(greenFluorCorrDownSampled)
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
    
elseif ~isempty(greenFluorCorrDownSampled)
    title('gcampCorr')

    pause;
    prompt = {'Enter gcampCorr limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'0.01'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_greenFluorCorr_max = str2double(answer{1});
    
    numRows = 4;

elseif ~isempty(jrgecoCorrDownSampled)
        title('jrgeco1aCorr')

%     pause;
%     prompt = {'Enter jrgeco1aCorr limit:'};
%     title1 = 'Selet scale';
%     dims = [1 35];
%     definput = {'0.01'};
%     answer = inputdlg(prompt,title1,dims,definput);
%     temp_jrgeco1aCorr_max = str2double(answer{1});
    temp_jrgeco1aCorr_max = 4;
    numRows = 4;
    else
        numRows = 3;
end




% close all
% T1 = length(InstMvMt_detrend);
% time=linspace(1,T1,T1)/frameRate;
% 
% figure('units','normalized','outerposition',[0 0.2 0.2 0.4]);
% subplot(2,1,1);plot(1:length(oxy_active),oxy_active);
% subplot(2,1,2);plotyy(time, InstMvMt_detrend/1e6,time, LTMvMt_detrend/1e6);

figure('units','normalized','outerposition',[0.2 0.2 0.8 1]);
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
                hold on   
    contour( ROI,'k');
    subplot(numRows,numBlock,numBlock+ii)
    imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('deoxy')
    end
                hold on   
    contour( ROI,'k');
    
    subplot(numRows,numBlock,2*numBlock+ii)
    imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_total_max temp_total_max]);
    colormap jet
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('total')    

    end
    hold on   
    contour( ROI,'k');
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
                        hold on
    contour( ROI,'k');
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    if ~isempty(jrgecoCorrDownSampled)
        if ~isempty(greenFluorCorrDownSampled)
            subplot(numRows,numBlock,4*numBlock+ii)
        else
            subplot(numRows,numBlock,3*numBlock+ii)
        end
        imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('jrgeco1aCorr')

        end
                        hold on
    contour( ROI,'k');
    end
    
end
    hold on
    contour( ROI,'k');


% end