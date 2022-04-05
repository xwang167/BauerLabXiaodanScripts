clear all;close all;clc
load('L:\RGECO\190627\190627-R5M2286-stim2_processed','xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190627\190627-R5M2286-stim2-dataFluor.mat', 'xform_isbrain')
data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),5);
data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:))*10^6;
data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:))*10^6;
data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))*10^6+squeeze(xform_datahb(:,:,2,:))*10^6;
data_full(:,:,:,4) = squeeze(xform_jrgeco1aCorr)*100;
data_full(:,:,:,5) = xform_FADCorr*100;
peakTimeRange(1:size(data_full,4))={5:10};
%Setting up stim
stimBlockSize=round(30*25); %stim length in frames
%why is this here?
R=mod(size(data_full,3),stimBlockSize); %are there dropped frames?
%if there is dropped frames
if R~=0
    pad=stimBlockSize-R;
    disp(['** Non integer number of blocks presented. Padded with ' , num2str(pad), ' zeros **'])
    data_full(:,:,end:end+pad,:)=0;
    runInfo.appendedZeros=pad;
end
numBlocks = round(size(data_full,3)/(30*25));%what if not integer




data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],5);
for ii = 1:size(data_full,4)
    data_full_gsr(:,:,:,ii) = gsr(squeeze(data_full(:,:,:,ii)),xform_isbrain);
end

data_full_gsr = reshape(data_full_gsr,size(data_full_gsr,1),size(data_full_gsr,2),[],numBlocks,size(data_full_gsr,4)); %reshape to pixel-pixel-blockSize-numblock-species
data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,size(data_full,4)); %reshape to pixel-pixel-blockSize-numblock-species


%%

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];


      data_full_gsr_BaselineShift=nan(size(data_full_gsr));
        data_full_BaselineShift=data_full_gsr_BaselineShift;
        for ii = 1:numBlocks
            for jj = 1:5
                data_full_gsr(:,:,:,ii,jj) =  filterData(squeeze(squeeze(data_full_gsr(:,:,:,ii,jj))),0.02,5,25);
                meanFrame = squeeze(mean(data_full_gsr(:,:,1:5*25,ii,jj),3));
                data_full_gsr_BaselineShift(:,:,:,ii,jj) = xform_isbrain.*(data_full_gsr(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data_full_gsr,3),1,1));
               

                data_full(:,:,:,ii,jj) =  filterData(squeeze(squeeze(data_full(:,:,:,ii,jj))),0.02,5,25);  
                meanFrame = squeeze(mean(data_full(:,:,1:5*25,ii,jj),3));
                data_full_BaselineShift(:,:,:,ii,jj) = xform_isbrain.*(data_full(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data_full,3),1,1));
                              
            end
        end
        data_full_gsr_BaselineShift= resample(data_full_gsr_BaselineShift,(2*fRange_delta(2)*1.25),25,'Dimension',3 ); %resample to 10 Hz
        data_full_BaselineShift= resample(data_full_BaselineShift,(2*fRange_delta(2)*1.25),25,'Dimension',3 ); %resample to 10 Hz

        
runInfo.samplingRate=(2*fRange_delta(2)*1.25); %change the sampling rate


load('L:\RGECO\190627\190627-R5M2286-stim2_processed','ROI_GSR')
xform_StimROIMask = ROI_GSR;
runInfo.Contrasts={'HbO','HbR','HbT','Calcium','FAD'};
runInfo.system = 'EastOIS2_FAD_RGECO';
runInfo.stimStartTime = 5;
runInfo.stimEndTime = 10;
fh= generateBlockMap_Dynamics(data_full_BaselineShift,data_full_gsr_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain,xform_StimROIMask);
%save
sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run),'-GSR'])
saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics');
saveas(gcf,strcat(saveName,'.fig'))
saveas(gcf,strcat(saveName,'.png'))
close all
save(runInfo.saveFilePrefix,'data_full_gsr_BaselineShift','-v7.3');

test = reshape(data_full_BaselineShift(:,:,:,1,1),128*128,[]);




test = reshape(data_full_BaselineShift(:,:,:,1,1),128*128,[]);
ROI_GSR = ROI_GSR(:);
test_timetrace = mean(test(ROI_GSR,:));
figure
plot(test_timetrace)


meanFrame = squeeze(mean(data_full_gsr_BaselineShift(:,:,1:5*25,2,1),3));
