function plotROIRaw_BlockAverage(raw,nVy,nVx,numChannels,numBlocks,blocksize,blockDuration,mouseType,systemType,ROI,stimbaseline,I,runName,isbrain,saveDir,visName)
xform_raw = reshape(mouse.preprocess.affineTransform(raw,I),nVy,nVx, numChannels,[]);
xform_raw4 = reshape(xform_raw,[nVy*nVx numChannels blocksize numBlocks]);
raw4 = reshape(raw,[nVy*nVx numChannels blocksize numBlocks]);


iri = find(ROI==1);
xform_raw_blockAverage = mean(xform_raw4(:,:,:,2:10),4);

ibi = find(isbrain==1);
raw_blockAverage = mean(raw4(:,:,:,2:10),4);

raw_roi_blockAverage = squeeze(mean(xform_raw_blockAverage(iri,:,:),1));
raw_global_blockAverage = squeeze(mean(raw_blockAverage(ibi,:,:),1));

baseline_roi_blockAverage = nanmean(raw_roi_blockAverage(:,1:stimbaseline),2);
raw_ratio_roi_blockAverage = raw_roi_blockAverage./repmat(baseline_roi_blockAverage,[1 blocksize]); % make the data ratiometric

baseline_global_blockAverage = nanmean(raw_global_blockAverage(:,1:stimbaseline),2);
raw_ratio_global_blockAverage = raw_global_blockAverage./repmat(baseline_global_blockAverage,[1 blocksize]); % make the data ratiometric

raw_roi_blockAverage_logmean = logmean(raw_roi_blockAverage);
visName = char(visName);
save(fullfile(saveDir,strcat(visName(1:end-3),'mat')),'raw_ratio_roi_blockAverage')

time = blockDuration/blocksize*(1:blocksize);
if strcmp(mouseType,'jrgeco1a')||strcmp(systemType,'EastOIS2')
    Colors = [0.6 0 0 ;0 1 0;1 0 0];
    legendName = {'red fluorescence', 'green LED', 'red LED'};
elseif strcmp(mouseType,'gcamp6f')||strcmp(systemType,'EastOIS2')
    Colors = [0 0.6 0 ;0 1 0;1 0 0];
    legendName = {'green fluorescence', 'green LED', 'red LED'};
end

figure('units','normalized','outerposition',[0 0 1 1]);
texttitle = strcat('Raw data with temperal detrending'," ",runName);
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);



time_whole = blockDuration/blocksize*(1:10*blocksize);
rawdata=single(reshape(raw,nVy*nVx,numChannels,[]));

mdata_global=squeeze(mean(rawdata(ibi,:,:),1));
for c=1:numChannels;
    mdatanorm_global(c,:)=mdata_global(c,:)./(squeeze(mean(mdata_global(c,:),2)));
end

subplot('position', [0.1 0.78 0.7 0.15])
p=plot(time_whole,mdatanorm_global'); title('Normalized Raw Data for Global');
for c=1:numChannels;
    set(p(c),'Color',Colors(c,:));
end
xlabel('Time (sec)')
ylabel('Mean Counts')

xlim([time_whole(1) time_whole(end)])

xform_raw3 = single(reshape(xform_raw,nVy*nVx,numChannels,[]));
mdata_roi=squeeze(mean(xform_raw3(iri,:,:),1));
for c=1:numChannels;
    mdatanorm_roi(c,:)=mdata_roi(c,:)./(squeeze(mean(mdata_roi(c,:),2)));
end

subplot('position', [0.1 0.55 0.7 0.15])
p=plot(time_whole,mdatanorm_roi'); title('Normalized Raw Data for ROI');
for c=1:numChannels;
    set(p(c),'Color',Colors(c,:));
end
xlabel('Time (sec)')
ylabel('Mean Counts')
xlim([time_whole(1) time_whole(end)])




subplot('position',[0.1,0.05,0.3,0.4])
p = plot(time,raw_ratio_global_blockAverage);
for c = 1:numChannels
    set(p(c),'Color',Colors(c,:));
end

xlabel('Time (sec)')
ylabel('Counts');
xlim([time(1) time(end)])
title('Block averaged (Block 2-10) Raw Data for Global')
legend(p,legendName)


set(findall(gca, 'Type', 'Line'),'LineWidth',2);




subplot('position',[0.5,0.05,0.3,0.4])
p = plot(time,raw_ratio_roi_blockAverage);
for c = 1:3
    set(p(c),'Color',Colors(c,:));
end

xlabel('Time (sec)')
ylabel('Counts');
xlim([time(1) time(end)])
title('Block averaged (Block 2-10) Raw Data for ROI')
legend(p,legendName)

set(findall(gca, 'Type', 'Line'),'LineWidth',2);
orient portrait
print ('-djpeg', '-r1000',fullfile(saveDir,visName));


        sessionInfo.hbSpecies = 2:3;
        sessionInfo.fluorSpecies = 1;
        sessionInfo.fluorExcitationFile = "jrgeco1a_excitation.txt";%% need
        sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";
           muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
               systemInfo.numLEDs = 4;
    systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_TL625_Pol.txt"];

    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
           [op, E] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(3:4));
            BaselineFunction  = @(x) mean(x,numel(size(x)));
            raw_ratio_roi_blockAverage = reshape(raw_ratio_roi_blockAverage,1,1,3,500);
            baselineValues = BaselineFunction(raw_ratio_roi_blockAverage);
            
            xform_datahb_blockaverage = mouse.process.procOIS(raw_ratio_roi_blockAverage(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);

           
           
           
                    [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(2));
                    [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,sessionInfo.fluorEmissionFile);


                    dpIn = op_in.dpf/2;
                    dpOut = op_out.dpf/2;

                    %             dpIn = 0.056;
                    %             dpOut = 0.057;
                    xform_jrgeco1a_blockaverage = raw_ratio_roi_blockAverage(:,:,1,:) ;
                    xform_jrgeco1aCorr_blockaverage = mouse.physics.correctHb(xform_jrgeco1a_blockaverage,xform_datahb_blockaverage,...
                        [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
                    xform_jrgeco1aCorr_blockaverage = xform_jrgeco1aCorr_blockaverage-1;

max_oxy = max(squeeze(xform_datahb_blockaverage(1,1,1,:)));
max_jrgeco1aCorr = max(squeeze(xform_jrgeco1aCorr_blockaverage(1,1,1,:)));
time = 300/500*(1:500);
figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
p1 = plot(time,squeeze(xform_datahb_blockaverage(1,1,1,:)),'r');
hold on;
yyaxis left
p2 = plot(time,squeeze(xform_datahb_blockaverage(1,1,2,:)),'b');
ylim([-1.2*max_oxy 1.2*max_oxy])

hold on;
yyaxis right
p3= plot(time,squeeze(xform_jrgeco1aCorr_blockaverage(1,1,1,:)),'k');
ylim([-1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr])

legend([p1 p2 p3],'HbO_2','HbR','R1a','FontSize',10);
texttitle2 = strcat('Blockaverage Data first then feed time trace to'," ",runName);
annotation('textbox',[0.125 0.95 1 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

print ('-djpeg', '-r1000',fullfile(saveDir,strcat(visName(1:end-4),'_processed.jpg')));
close all