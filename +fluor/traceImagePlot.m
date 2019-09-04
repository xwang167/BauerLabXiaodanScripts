function traceImagePlot(oxy_blocks,deoxy_blocks,total_blocks,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,outputName,texttitle,varargin)
%oxy, deoxy, total, gcamp, gcampCorr, green in [nVx,nVy,time] without dark
%frame

%oxy_downsampled, deoxy_downsampled and total downsampled in[nVx,nVy,time,block]
% outputName is char for naming the file
% then block average the downsampled variables from the good runs
% baseline substraction and save the downsampled variables
% time average the image sequence from half way of the activation to the end of
% the activation to create AvgOxy_stim AvgDeOxy_stim AvgTotal_stim AvggcampCorr_stim
% Use AvgTotal_stim and AvggcampCorr_Stim to create different ROIs for total and fluor with 75% maximum and
% save the ROI and the max of AvggcampCorr_stim and AvgTotal_stim
% plot the image sequence


% block average non-downsampled oxy,deoxy, total, gcamp, gcampCorr, green
%baseline substraction
% plot time trace of the ROI

%save the plots in jpg

import mouse.*



p = inputParser;


addParameter(p,'time',[],@isnumeric);
addParameter(p,'input',[],@isnumeric);

addParameter(p,'jrgeco1aCorr_blocks',[],@isnumeric);
addParameter(p,'jrgeco1a_blocks',[],@isnumeric);
addParameter(p,'red_blocks',[],@isnumeric);
addParameter(p,'jrgeco1aCorr_blocks_downsampled',[],@isnumeric);
addParameter(p,'jrgeco1a_blocks_downsampled',[],@isnumeric);
addParameter(p,'red_blocks_downsampled',[],@isnumeric);
addParameter(p,'temp_jrgeco1aCorr_max',[],@isnumeric);
addParameter(p,'Avgjrgeco1aCorr_stim',[],@isnumeric);
addParameter(p,'ROI_jrgeco1aCorr',[],@islogical);

addParameter(p,'ROI_total',[],@islogical);

addParameter(p,'gcampCorr_blocks',[],@isnumeric);
addParameter(p,'gcamp_blocks',[],@isnumeric);
addParameter(p,'green_blocks',[],@isnumeric);
addParameter(p,'gcampCorr_blocks_downsampled',[],@isnumeric);
addParameter(p,'gcamp_blocks_downsampled',[],@isnumeric);
addParameter(p,'temp_gcampCorr_max',[],@isnumeric);
addParameter(p,'AvggcampCorr_stim',[],@isnumeric);
addParameter(p,'ROI_gcampCorr',[],@islogical);

parse(p,varargin{:});

time = p.Results.time;
input = p.Results.input;

jrgeco1aCorr_blocks = p.Results.jrgeco1aCorr_blocks;
jrgeco1aCorr_blocks_downsampled = p.Results.jrgeco1aCorr_blocks_downsampled;


jrgeco1a_blocks = p.Results.jrgeco1a_blocks;
jrgeco1a_blocks_downsampled = p.Results.jrgeco1a_blocks_downsampled;

red_blocks = p.Results.red_blocks;
red_blocks_downsampled = p.Results.red_blocks_downsampled;

temp_jrgeco1aCorr_max = p.Results.temp_jrgeco1aCorr_max;
Avgjrgeco1aCorr_stim= p.Results.Avgjrgeco1aCorr_stim;
ROI_jrgeco1aCorr = p.Results.ROI_jrgeco1aCorr;

gcampCorr_blocks = p.Results.gcampCorr_blocks;
gcampCorr_blocks_downsampled = p.Results.gcampCorr_blocks_downsampled;

gcamp_blocks = p.Results.gcamp_blocks;
green_blocks = p.Results.green_blocks;
gcamp_blocks_downsampled = p.Results.gcamp_blocks_downsampled;

temp_gcampCorr_max = p.Results.temp_gcampCorr_max;
AvggcampCorr_stim= p.Results.AvggcampCorr_stim;
ROI_gcampCorr = p.Results.ROI_gcampCorr;






% baseline substraction
MeanFrame_oxy_downsampled=mean(oxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
oxy_blocks_baseline_downsampled = oxy_blocks_downsampled-MeanFrame_oxy_downsampled;

MeanFrame_deoxy_downsampled=mean(deoxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled-MeanFrame_deoxy_downsampled;

MeanFrame_total_downsampled=mean(total_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
total_blocks_baseline_downsampled = total_blocks_downsampled-MeanFrame_total_downsampled;


if ~isempty(Avgjrgeco1aCorr_stim)
    MeanFrame_jrgeco1aCorr_downsampled=mean(jrgeco1aCorr_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    jrgeco1aCorr_blocks_baseline_downsampled = jrgeco1aCorr_blocks_downsampled-MeanFrame_jrgeco1aCorr_downsampled;
    MeanFrame_jrgeco1a_downsampled=mean(jrgeco1a_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    jrgeco1a_blocks_baseline_downsampled = jrgeco1a_blocks_downsampled-MeanFrame_jrgeco1a_downsampled;
        MeanFrame_red_downsampled=mean(red_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    red_blocks_baseline_downsampled = red_blocks_downsampled-MeanFrame_red_downsampled;
end

if ~isempty(AvggcampCorr_stim)
    MeanFrame_gcampCorr_downsampled=mean(gcampCorr_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    gcampCorr_blocks_baseline_downsampled = gcampCorr_blocks_downsampled-MeanFrame_gcampCorr_downsampled;
    MeanFrame_gcamp_downsampled=mean(gcamp_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    gcamp_blocks_baseline_downsampled = gcamp_blocks_downsampled-MeanFrame_gcamp_downsampled;
end

%save
% if exist(strcat(outputName,'_vis.mat'),'file')
%     save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','-append');
% else
%     save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled');
% end




figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
disp('image sequence of Hb')
startSecond = round(sessionInfo.stimbaseline/sessionInfo.framerate)-1;

for b=startSecond:startSecond+9
    p = subplot('position', [0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
    imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-temp_oxy_max temp_oxy_max]);
    if b == startSecond+9
        colorbar
        set(p,'Position',[0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
    end
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b == 4
        ylabel('Oxy')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    
end

for b=startSecond:startSecond+9
    p = subplot('position', [0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
    imagesc(deoxy_blocks_baseline_downsampled(:,:,b), [-temp_deoxy_max temp_deoxy_max]);
    if b == startSecond+9
        colorbar
        set(p,'Position',[0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==startSecond
        ylabel('DeOxy')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end



for b=startSecond:startSecond+9
    p = subplot('position', [0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
    imagesc(total_blocks_baseline_downsampled(:,:,b), [-temp_total_max temp_total_max]);
    if b == startSecond+9
        colorbar
        set(p,'Position',[0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==startSecond
        ylabel('Total')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end

colormap jet


disp(strcat('time trace plot'))


oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);

clear oxy_blocks deoxy_blocks  total_blocks


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);

if ~isempty(Avgjrgeco1aCorr_stim)
    jrgeco1aCorr_blocks_baseline = jrgeco1aCorr_blocks-mean(jrgeco1aCorr_blocks(:,:,1:sessionInfo.stimbaseline),3);
    jrgeco1aCorr_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
    
    jrgeco1a_blocks_baseline = jrgeco1a_blocks-mean(jrgeco1a_blocks(:,:,1:sessionInfo.stimbaseline),3);
    jrgeco1a_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
    red_blocks_baseline = red_blocks-mean(red_blocks(:,:,1:sessionInfo.stimbaseline),3);
    red_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
end
if ~isempty(AvggcampCorr_stim)
    gcampCorr_blocks_baseline = gcampCorr_blocks-mean(gcampCorr_blocks(:,:,1:sessionInfo.stimbaseline),3);
    gcampCorr_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
    
    gcamp_blocks_baseline = gcamp_blocks-mean(gcamp_blocks(:,:,1:sessionInfo.stimbaseline),3);
    gcamp_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
    
    green_blocks_baseline = green_blocks-mean(green_blocks(:,:,1:sessionInfo.stimbaseline),3);
    green_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
end

for i = 1:sessionInfo.stimblocksize
     oxy_temp = oxy_blocks_baseline(:,:,i);
    if isempty(Avgjrgeco1aCorr_stim)&&isempty(AvggcampCorr_stim)
   ROI_oxy_contour = bwperim(ROI_total);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(ROI_total));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(ROI_total));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(ROI_total));
    end
    
    if ~isempty(Avgjrgeco1aCorr_stim)

    oxy_blocks_baseline_active(i) = mean(oxy_temp(ROI_jrgeco1aCorr));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(ROI_jrgeco1aCorr));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(ROI_jrgeco1aCorr));
        jrgeco1aCorr_temp = jrgeco1aCorr_blocks_baseline(:,:,i);
        jrgeco1aCorr_blocks_baseline_active(i) = mean(jrgeco1aCorr_temp(ROI_jrgeco1aCorr));
        
        jrgeco1a_temp = jrgeco1a_blocks_baseline(:,:,i);
        jrgeco1a_blocks_baseline_active(i) = mean(jrgeco1a_temp(ROI_jrgeco1aCorr));
        
        red_temp = red_blocks_baseline(:,:,i);
        red_blocks_baseline_active(i) = mean(red_temp(ROI_jrgeco1aCorr));
    end
    if ~isempty(AvggcampCorr_stim)
                    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(ROI_gcampCorr));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(ROI_gcampCorr));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(ROI_gcampCorr));
        gcampCorr_temp = gcampCorr_blocks_baseline(:,:,i);
        gcampCorr_blocks_baseline_active(i) = mean(gcampCorr_temp(ROI_gcampCorr));
        
        gcamp_temp = gcamp_blocks_baseline(:,:,i);
        gcamp_blocks_baseline_active(i) = mean(gcamp_temp(ROI_gcampCorr));
        
        green_temp = green_blocks_baseline(:,:,i);
        green_blocks_baseline_active(i) = mean(green_temp(ROI_gcampCorr));
        
    end
    
end

stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
max_oxy = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks

if ~isempty(Avgjrgeco1aCorr_stim)
      max_jrgeco1aCorr = max(jrgeco1aCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_red = min(red_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_jrgeco1a =  min(jrgeco1a_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_value = min(min_red,min_jrgeco1a);
end

if ~isempty(AvggcampCorr_stim)
    max_gcampCorr = max(gcampCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_green = min(green_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_gcamp =  min(gcamp_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
    min_value = min(min_green,min_gcamp);
end

x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
hold on
subplot('position',[0.05,0.08,0.5,0.35])
if ~isempty(Avgjrgeco1aCorr_stim)
    yyaxis left
    plot(x,jrgeco1aCorr_blocks_baseline_active,'k-');
    ylim([-1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr])
    ylabel('jrgeco1a(\DeltaF/F)','FontSize',12);
    hold on
end


if ~isempty(AvggcampCorr_stim)
    yyaxis left
    plot(x,gcampCorr_blocks_baseline_active,'k-');
    ylim([-1.1*max_gcampCorr 1.1*max_gcampCorr])
    ylabel('gcamp6f(\DeltaF/F)','FontSize',12);
    hold on
   
end

 yyaxis right
plot(x,oxy_blocks_baseline_active,'r-');
hold on
plot(x,deoxy_blocks_baseline_active,'b-');
plot(x,total_blocks_baseline_active,'Color',[.61 .51 .74]);

set(findall(gca, 'Type', 'Line'),'LineWidth',1);

hold on


ylim([-1.3*max_oxy 1.3*max_oxy])

xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
if isempty(time)
    for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1/sessionInfo.stimFrequency
        line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[-1.3*max_oxy 1.3*max_oxy]);
        hold on
        if ~isempty(Avgjrgeco1aCorr_stim)
            line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ -1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr]);
            hold on
        end
        
    end
else

    plot(time,(input-2.5)/10000,'-')
end

if ~isempty(Avgjrgeco1aCorr_stim)
    lgd = legend('jrgeco1aCorr','HbO_2','HbR','HbTotal');
elseif ~isempty(AvggcampCorr_stim)
    lgd = legend('gcampCorr','HbO_2','HbR','HbTotal');
else
    lgd = legend('HbO_2','HbR','HbTotal');
end
lgd.FontSize = 14;



xlabel('Time(s)','FontSize',12)
ylabel('Hb(\DeltaM)','FontSize',12)








if ~isempty(Avgjrgeco1aCorr_stim)
    ROI_jrgeco1aCorr_contour = bwperim(ROI_jrgeco1aCorr);
    subplot('position',[0.6,0.25,0.15,0.2])
    imagesc(Avgjrgeco1aCorr_stim*100,[-temp_jrgeco1aCorr_max*100 temp_jrgeco1aCorr_max*100])
    colorbar
    hold on
    contour(ROI_jrgeco1aCorr_contour,'k')
    axis image off
    title('jrgeco1aCorr %');
end

if ~isempty(AvggcampCorr_stim)
    ROI_gcampCorr_contour = bwperim(ROI_gcampCorr);
    subplot('position',[0.6,0.25,0.15,0.2])
    imagesc(AvggcampCorr_stim,[-temp_gcampCorr_max temp_gcampCorr_max])
    colorbar
    hold on
    contour(ROI_gcampCorr_contour,'k')
    axis image off
    title('gcampCorr');
end


subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
if ~isempty(Avgjrgeco1aCorr_stim)
    contour(ROI_jrgeco1aCorr_contour,'k')
elseif ~isempty(AvggcampCorr_stim)
    contour(ROI_gcampCorr_contour,'k')
else
contour(ROI_oxy_contour,'k')
end

axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-temp_deoxy_max temp_deoxy_max])
colorbar
hold on
if ~isempty(Avgjrgeco1aCorr_stim)
    contour(ROI_jrgeco1aCorr_contour,'k')
elseif ~isempty(AvggcampCorr_stim)
    contour(ROI_gcampCorr_contour,'k')
else
contour(ROI_oxy_contour,'k')
end
axis image off
title('deoxy');


subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-temp_total_max temp_total_max])
colorbar
hold on
if ~isempty(Avgjrgeco1aCorr_stim)
    contour(ROI_jrgeco1aCorr_contour,'k')
elseif ~isempty(AvggcampCorr_stim)
    contour(ROI_gcampCorr_contour,'k')
else
contour(ROI_oxy_contour,'k')
end
axis image off
title('total');
colormap jet
texttitle = strcat(' Block Average for', {' '},texttitle,{' '}, 'for blocks ',{' '}, num2str(goodBlocks));
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(outputName,'_OIS_ROI75.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);

if ~isempty(Avgjrgeco1aCorr_stim)
        figure('units','normalized','outerposition',[0 0 1 1]);
    disp('image sequence of jrgeco1a')
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        imagesc(red_blocks_baseline_downsampled(:,:,b), [-0.3*temp_jrgeco1aCorr_max 0.3*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        end
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b == 4
            ylabel('625nm')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        imagesc(jrgeco1a_blocks_baseline_downsampled(:,:,b), [-1*temp_jrgeco1aCorr_max 1*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('jrgeco1a')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        imagesc(jrgeco1aCorr_blocks_baseline_downsampled(:,:,b), [-1*temp_jrgeco1aCorr_max 1*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('jrgeco1aCorr')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    
    
    hold on
    subplot('position',[0.05,0.08,0.7,0.35])
    p4 = plot(x,jrgeco1aCorr_blocks_baseline_active,'k-');
    
    
    hold on
    p5=plot(x,jrgeco1a_blocks_baseline_active,'Color',[ 0.6 0 0]);
    set(findall(gca, 'Type', 'Line'),'LineWidth',2);
    hold on
    p6=plot(x,red_blocks_baseline_active,'r-');
    hold on
    
    if isempty(time)
        for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1/sessionInfo.stimFrequency
            line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ 1.1*min_value 1.3*max_jrgeco1aCorr]);
            hold on
        end
    else
        plot(time,input-2.5,'-')
    end
    ax = gca;
    ax.FontSize = 8;
    xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
    
    ylim([1.1*min_value 1.3*max_jrgeco1aCorr])
    
    lgd =legend('R1a(corr.)','R1a(raw)','625nm');
    lgd.FontSize = 14;
    xlabel('Time(s)','FontSize',20,'FontWeight','bold')
    ylabel('jrgeco1a(\DeltaF/F)','FontSize',20,'FontWeight','bold')
    
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')
    
    ROI_jrgeco1aCorr_contour = bwperim(ROI_jrgeco1aCorr);
    subplot('position',[0.8,0.1,0.2,0.25])
    Avgjrgeco1aCorr_stim(isinf(Avgjrgeco1aCorr_stim)) = 0;
    imagesc(Avgjrgeco1aCorr_stim*100,[-temp_jrgeco1aCorr_max*100 temp_jrgeco1aCorr_max*100])
    colormap jet
    hold on
    contour(ROI_jrgeco1aCorr_contour,'k')
    axis image off
    c = colorbar;
    c.FontSize = 14;
    c.FontWeight = 'bold';
    title('Corrected jrgeco1a 75%','fontsize',16)
    title('Corrected jrgeco1a Percentage Change')
    
    % subplot('position',[0.76,0.1,0.17,0.3])
    % disp('Calculating fft curve')
    % info.nVy = 128;
    % info.nVx =128;
    % ibi=find(xform_isbrain==1);
    % T1 =  length(oxy);
    % hz=linspace(0,sessionInfo.framerate,T1);
    % oxy2 = single(reshape(oxy,info.nVy*info.nVx,[]));
    % mdata_oxy = squeeze(mean(oxy2(ibi,:),1));
    % fdata_oxy = abs(fft(mdata_oxy));
    % fdata_oxy = fdata_oxy./mean(fdata_oxy);
    % p1 = loglog(hz(1:ceil(T1/2)), fdata_oxy(1:ceil(T1/2)),'g');
    %
    %
    % jrgeco1aCorr2 = single(reshape(jrgeco1aCorr,info.nVy*info.nVx,[]));
    % mdata_jrgeco1aCorr = squeeze(mean(jrgeco1aCorr2(ibi,:),1));
    % fdata_jrgeco1aCorr = abs(fft(mdata_jrgeco1aCorr));
    % fdata_jrgeco1aCorr = fdata_jrgeco1aCorr./mean(fdata_jrgeco1aCorr);
    % hold on
    % p2 = loglog(hz(1:ceil(T1/2)), fdata_jrgeco1aCorr(1:ceil(T1/2)),'k');
    % ylim([10^-2 10^2])
    % legend('HbO_2','jrgeco1aCorr','location','southwest')
    % xlabel('Frequency (Hz)')
    % ylabel('Magnitude')
    % xlim([0.01 15]);
    % title( 'FFT Normalized Data');
    % ytickformat('%.1f');
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    % save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','oxy_mice');
    output2 = strcat(outputName,'_jrgeco1a.jpg');
    orient portrait
    print ('-djpeg', '-r1000',output2);
    
end


if ~isempty(AvggcampCorr_stim)
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    disp('image sequence of gcamp')
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-0.8*temp_oxy_max 0.8*temp_oxy_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        end
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b == 4
            ylabel('Oxy')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        imagesc(gcamp_blocks_baseline_downsampled(:,:,b), [-1*temp_gcampCorr_max 1*temp_gcampCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('gcamp')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    
    for b=startSecond:startSecond+9
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        imagesc(gcampCorr_blocks_baseline_downsampled(:,:,b), [-1*temp_gcampCorr_max 1*temp_gcampCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('gcampCorr')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    
    
    hold on
    subplot('position',[0.05,0.08,0.7,0.35])
    p4 = plot(x,gcampCorr_blocks_baseline_active,'k-');
    
    
    hold on
    p5=plot(x,gcamp_blocks_baseline_active,'Color',[ 0 0.6 0]);
    set(findall(gca, 'Type', 'Line'),'LineWidth',2);
    hold on
    p6=plot(x,green_blocks_baseline_active,'g-');
    hold on
    
    if isempty(time)
        for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1/sessionInfo.stimFrequency
            line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ 1.1*min_value 1.1*max_gcampCorr]);
            hold on
        end
    else
        plot(time,input-2.5,'-')
    end
    ax = gca;
    ax.FontSize = 8;
    xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
    
    ylim([1.1*min_value 1.1*max_gcampCorr])
    
    lgd =legend('G6f(corr.)','G6f(raw)','525nm');
    lgd.FontSize = 14;
    xlabel('Time(s)','FontSize',20,'FontWeight','bold')
    ylabel('GCaMP6f(\DeltaF/F)','FontSize',20,'FontWeight','bold')
    
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')
    
    ROI_gcampCorr_contour = bwperim(ROI_gcampCorr);
    subplot('position',[0.8,0.1,0.2,0.25])
    imagesc(AvggcampCorr_stim*100,[-temp_gcampCorr_max*100 temp_gcampCorr_max*100])
    colormap jet
    hold on
    contour(ROI_gcampCorr_contour,'k')
    axis image off
    c = colorbar;
    c.FontSize = 14;
    c.FontWeight = 'bold';
    title('Corrected GCaMP6f 75%','fontsize',16)
    title('Corrected GCaMP6f Percentage Change')
    
    % subplot('position',[0.76,0.1,0.17,0.3])
    % disp('Calculating fft curve')
    % info.nVy = 128;
    % info.nVx =128;
    % ibi=find(xform_isbrain==1);
    % T1 =  length(oxy);
    % hz=linspace(0,sessionInfo.framerate,T1);
    % oxy2 = single(reshape(oxy,info.nVy*info.nVx,[]));
    % mdata_oxy = squeeze(mean(oxy2(ibi,:),1));
    % fdata_oxy = abs(fft(mdata_oxy));
    % fdata_oxy = fdata_oxy./mean(fdata_oxy);
    % p1 = loglog(hz(1:ceil(T1/2)), fdata_oxy(1:ceil(T1/2)),'g');
    %
    %
    % gcampCorr2 = single(reshape(gcampCorr,info.nVy*info.nVx,[]));
    % mdata_gcampCorr = squeeze(mean(gcampCorr2(ibi,:),1));
    % fdata_gcampCorr = abs(fft(mdata_gcampCorr));
    % fdata_gcampCorr = fdata_gcampCorr./mean(fdata_gcampCorr);
    % hold on
    % p2 = loglog(hz(1:ceil(T1/2)), fdata_gcampCorr(1:ceil(T1/2)),'k');
    % ylim([10^-2 10^2])
    % legend('HbO_2','gcampCorr','location','southwest')
    % xlabel('Frequency (Hz)')
    % ylabel('Magnitude')
    % xlim([0.01 15]);
    % title( 'FFT Normalized Data');
    % ytickformat('%.1f');
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    % save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','oxy_mice');
    output2 = strcat(outputName,'_gcamp.jpg');
    orient portrait
    print ('-djpeg', '-r1000',output2);
    
    
end
