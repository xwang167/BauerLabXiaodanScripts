function [oxy_downsampled,deoxy_downsampled,total_downsampled,goodBlocks,temp_oxy_max,temp_deoxy_max,temp_total_max,stimStartTime,stimEndTime,jrgeco1aCorr_downsampled,jrgeco1a_downsampled,temp_jrgeco1aCorr_max, gcampCorr_downsampled, gcamp_downsampled,temp_gcampCorr_max] = pickGoodBlocks(oxy,deoxy,total,freqOut,sessionInfo,outputName,texttitle,varargin)
%downsample the data
%Peak image of every block
%Select blocks
% blockaveraged peak image

p = inputParser;

addParameter(p,'jrgeco1aCorr',[],@isnumeric);
addParameter(p,'jrgeco1a',[],@isnumeric);
addParameter(p,'gcampCorr',[],@isnumeric);
addParameter(p,'gcamp',[],@isnumeric);
parse(p,varargin{:});

jrgeco1aCorr = p.Results.jrgeco1aCorr;
gcampCorr = p.Results.gcampCorr;

jrgeco1a = p.Results.jrgeco1a;
gcamp = p.Results.gcamp;

stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
numBlock = size(oxy,3)/sessionInfo.stimblocksize;


numDesample = size(oxy,3)/sessionInfo.framerate*freqOut;
factor = round(numDesample/numBlock);
numDesample = factor*numBlock;

oxy_downsampled = resampledata(oxy,size(oxy,3),numDesample,10^-5);
deoxy_downsampled = resampledata(deoxy,size(oxy,3),numDesample,10^-5);
total_downsampled = resampledata(total,size(oxy,3),numDesample,10^-5);

oxy_downsampled = reshape(oxy_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
deoxy_downsampled = reshape(deoxy_downsampled,size(deoxy,1),size(deoxy,2),[],numBlock);
total_downsampled = reshape(total_downsampled,size(total,1),size(total,2),[],numBlock);

baseline_oxy_downsampled = squeeze(mean(oxy_downsampled(:,:,1:stimStartTime,2),3));
baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled(:,:,1:stimStartTime,2),3));
baseline_total_downsampled = squeeze(mean(total_downsampled(:,:,1:stimStartTime,2),3));

jrgeco1aCorr_downsampled = [];
jrgeco1a_downsampled = [];
if ~isempty(jrgeco1aCorr)
    jrgeco1aCorr_downsampled = resampledata(jrgeco1aCorr,size(oxy,3),numDesample,10^-5);
    jrgeco1aCorr_downsampled = reshape(jrgeco1aCorr_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
    baseline_jrgeco1aCorr_downsampled = squeeze(mean(jrgeco1aCorr_downsampled(:,:,1:stimStartTime,2),3));
    
    jrgeco1a_downsampled = resampledata(jrgeco1a,size(oxy,3),numDesample,10^-5);
    jrgeco1a_downsampled = reshape(jrgeco1a_downsampled,size(oxy,1),size(oxy,2),[],numBlock);

end

gcampCorr_downsampled = [];
gcamp_downsampled = [];
if ~isempty(gcampCorr)
    gcampCorr_downsampled = resampledata(double(gcampCorr),size(oxy,3),numDesample,10^-5);
    gcampCorr_downsampled = reshape(gcampCorr_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
    baseline_gcampCorr_downsampled = squeeze(mean(gcampCorr_downsampled(:,:,1:stimStartTime,2),3));
    
    gcamp_downsampled = resampledata(double(gcamp),size(oxy,3),numDesample,10^-5);
    gcamp_downsampled = reshape(gcamp_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
end



stimEndTime= stimStartTime+sessionInfo.stimduration;
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
imagesc(squeeze(oxy_downsampled(:,:,stimEndTime,5))-baseline_oxy_downsampled,[-9e-6 9e-6])
colorbar
axis image off
title('Oxy')
subplot(1,3,2)
imagesc(squeeze(deoxy_downsampled(:,:,stimEndTime,5))-baseline_deoxy_downsampled,[-3e-6 3e-6])
colorbar
axis image off
title('DeOxy')
subplot(1,3,3)
imagesc(squeeze(total_downsampled(:,:,stimEndTime,5))-baseline_total_downsampled,[-6e-6 6e-6])
colorbar
axis image off
title('Total')
colormap jet
pause;
prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
title1 = 'Selet scale';
dims = [1 35];
definput = {'9e-6';'3.5e-6';'6e-6'};
answer = inputdlg(prompt,title1,dims,definput);
temp_oxy_max = str2double(answer{1});
temp_deoxy_max = str2double(answer{2});
temp_total_max = str2double(answer{3});



numRows = 3;
temp_jrgeco1aCorr_max = [];
if ~isempty(jrgeco1aCorr)
    figure
    imagesc(squeeze(jrgeco1aCorr_downsampled(:,:,stimEndTime,5))-baseline_jrgeco1aCorr_downsampled,[-0.03 0.03])
    colorbar
    axis image off
    title('jrgeco1aCorr')
    colormap jet
    pause;
    prompt = {'Enter jrgeco1aCorr limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'0.01'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_jrgeco1aCorr_max = str2double(answer{1});
    numRows = 4;
end

temp_gcampCorr_max = [];
if ~isempty(gcampCorr)
    figure
    imagesc(squeeze(gcampCorr_downsampled(:,:,stimEndTime,5))-baseline_gcampCorr_downsampled,[-0.03 0.03])
    colorbar
    axis image off
    title('gcampCorr')
    colormap jet
    pause;
    prompt = {'Enter gcampCorr limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'0.01'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_gcampCorr_max = str2double(answer{1});
    numRows = 4;
end


figure('units','normalized','outerposition',[0 0 1 1]);
for ii = 1:numBlock
    subplot(numRows,numBlock,ii)
    imagesc(squeeze(oxy_downsampled(:,:,stimEndTime,ii))-baseline_oxy_downsampled,[-temp_oxy_max temp_oxy_max]);
    title(strcat('Pres',{' '},num2str(ii)))
        axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('oxy')
    end
    subplot(numRows,numBlock,numBlock+ii)
    imagesc(squeeze(deoxy_downsampled(:,:,stimEndTime,ii))-baseline_deoxy_downsampled,[-temp_deoxy_max temp_deoxy_max]);
        axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if ii == 1
        ylabel('deoxy')
    end
    subplot(numRows,numBlock,2*numBlock+ii)
    imagesc(squeeze(total_downsampled(:,:,stimEndTime,ii))-baseline_total_downsampled,[-temp_total_max temp_total_max]);
    colormap jet

        axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
        if ii == 1
        ylabel('total')
    end
    if ~isempty(jrgeco1aCorr)
        subplot(numRows,numBlock,3*numBlock+ii)
        imagesc(squeeze(jrgeco1aCorr_downsampled(:,:,stimEndTime,ii))-baseline_jrgeco1aCorr_downsampled,[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
            axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
        if ii == 1
            ylabel('jrgeco1aCorr')
        end
    elseif ~isempty(gcampCorr)
        subplot(numRows,numBlock,3*numBlock+ii)
        imagesc(squeeze(gcampCorr_downsampled(:,:,stimEndTime,ii))-baseline_gcampCorr_downsampled,[-temp_gcampCorr_max temp_gcampCorr_max]);
        if ii == 1
            ylabel('gcampCorr')
        end
            axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    end
end


prompt = {'Enter good blocks:'};
title1 = 'Pick block';
dims = [1 35];
definput = {strcat('[', num2str(1:numBlock), ']')};
answer = inputdlg(prompt,title1,dims,definput);

texttitle = strcat(' Peak Map for each block', {' '},texttitle,{' '}, 'blocks ',{' '}, answer{1},'are picked');
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(outputName,'_BlockPeakMap.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);
goodBlocks = str2num(answer{1});

close all

