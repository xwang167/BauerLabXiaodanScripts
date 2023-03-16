function [goodBlocks,temp_oxy_max,temp_deoxy_max,temp_total_max,temp_jrgeco1aCorr_max,temp_greenFluorCorr_max] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxyDownSampled, ...
    deoxyDownSampled,totalDownSampled,greenFluorCorrDownSampled,jrgecoCorrDownSampled,ROI)


 load('noVasculatureMask.mat')
mask_new = logical(mask_new);
% subplot(1,3,1)
% imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
% colorbar
% axis image off
% title('Oxy')
% 
% subplot(1,3,2)
% imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
% colorbar
% axis image off
% title('DeOxy')
% 
% subplot(1,3,3)
% imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
% colorbar
% axis image off
% title('Total')
% 
% colormap jet
% pause;
% prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
% title1 = 'Selet scale';
% dims = [1 35];
% definput = {'10';'5';'5'};
% answer = inputdlg(prompt,title1,dims,definput);

oxy_avg = mean(oxyDownSampled,4);
deoxy_avg = mean(deoxyDownSampled,4);
total_avg = mean(totalDownSampled,4);

oxy_peak = abs(mean(oxy_avg(:,:,stimStartTime+1:stimEndTime),3));
deoxy_peak = abs(mean(deoxy_avg(:,:,stimStartTime+1:stimEndTime),3));
total_peak = abs(mean(total_avg(:,:,stimStartTime+1:stimEndTime),3));


temp_oxy_max = prctile(oxy_peak(mask_new),90,'all')*1.4;
temp_deoxy_max = prctile(deoxy_peak(mask_new),90,'all')*1.4;
temp_total_max = prctile(total_peak(mask_new),90,'all')*1.4;
% temp_oxy_max = 6;%0.5;
% temp_deoxy_max = 2;%0.25;
% temp_total_max = 4;%0.5;
%close all;

%if ~isempty(jrgecoCorrDownSampled)
%     
%     figure
%     subplot(1,2,1)
%     imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
%     colorbar
%     axis image off
%     title('jrgeco1aCorr')
    
    
%end

%if ~isempty(greenFluorCorrDownSampled)
%     subplot(1,2,2)
%     imagesc(squeeze(mean(greenFluorCorrDownSampled(:,:,stimStartTime+1:stimEndTime,1),3)))
%     colorbar
%     axis image off
%end

% colormap jet


if ~isempty(jrgecoCorrDownSampled)&&~isempty(greenFluorCorrDownSampled)
%     title('FADCorr')
%     
%     pause;
%     prompt = {'Enter jrgeco1aCorr limit:';'Enter FADCorr limit:'};
%     title1 = 'Selet scale';
%     dims = [1 35];
%     definput = {'3','3'};
%     answer = inputdlg(prompt,title1,dims,definput);
jrgeco1aCorr_avg = mean(jrgecoCorrDownSampled,4);
greenFluorCorr_avg = mean(greenFluorCorrDownSampled,4);

jrgeco1aCorr_peak = abs(mean(jrgeco1aCorr_avg(:,:,stimStartTime+1:stimEndTime),3));
greenFluorCorr_peak = abs(mean(greenFluorCorr_avg(:,:,stimStartTime+1:stimEndTime),3));

temp_jrgeco1aCorr_max = prctile(jrgeco1aCorr_peak(mask_new),90,'all')*1.4;
if temp_jrgeco1aCorr_max == 0
    temp_jrgeco1aCorr_max = 0.001;
end
temp_greenFluorCorr_max = prctile(greenFluorCorr_peak(mask_new),90,'all')*1.4;
    numRows = 5;
    
elseif ~isempty(greenFluorCorrDownSampled)
%     title('gcampCorr')
%     
%     pause;
%     prompt = {'Enter gcampCorr limit:'};
%     title1 = 'Selet scale';
%     dims = [1 35];
%     definput = {'0.01'};
%     answer = inputdlg(prompt,title1,dims,definput);
greenFluorCorr_avg = mean(greenFluorCorrDownSampled,4);
greenFluorCorr_peak = abs(mean(greenFluorCorr_avg(:,:,stimStartTime+1:stimEndTime),3));
temp_greenFluorCorr_max = prctile(greenFluorCorr_peak(mask_new),90,'all')*1.4;
 temp_jrgeco1aCorr_max = [];   
    numRows = 4;
    
elseif ~isempty(jrgecoCorrDownSampled)
%     title('jrgeco1aCorr')
    
    %     pause;
    %     prompt = {'Enter jrgeco1aCorr limit:'};
    %     title1 = 'Selet scale';
    %     dims = [1 35];
    %     definput = {'0.01'};
    %     answer = inputdlg(prompt,title1,dims,definput);
    %     temp_jrgeco1aCorr_max = str2double(answer{1});
    jrgeco1aCorr_avg = mean(jrgeco1aCorrDownSampled,4);;
jrgeco1aCorr_peak = abs(mean(jrgeco1aCorr_avg(:,:,stimStartTime+1:stimEndTime),3));
temp_jrgeco1aCorr_max = prctile(jrgeco1aCorr_peak(mask_new),90,'all')*1.4;
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
% end