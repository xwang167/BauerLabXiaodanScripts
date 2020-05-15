function [mdata, stddatanorm,InstMvMt,LTMvMt] = QCcheck_raw(raw,isbrain,system,frameRate,saveDir,visName,mouseType)
rawdata = double(raw);
[info.nVy, info.nVx,numLED, ~]=size(rawdata);
info.T1=size(rawdata,4);
% testpixel=squeeze(rawdata(31,82,:,:));
%         if any(any(testpixel==0))
%             emptyframes=zeros(size(testpixel));
%             for c=1:systemInfo.LEDFiles;
%                 emptyframes(c,:)=any(testpixel(c,:)==0,1);
%             end
%             disp([filename,num2str(run),' had empty frames, no QC performed, moving on...'])
%             info.emptyframes=emptyframes;
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'.mat')),'info', '-append');
%             break
%         end

ibi=find(isbrain==1);
rawdata=single(reshape(rawdata,info.nVy*info.nVx,numLED,[]));

clear mdatanorm stddatanorm
mdata=squeeze(mean(rawdata(ibi,:,:),1));

for c=1:numLED;
    mdatanorm(c,:)=mdata(c,:)./(squeeze(mean(mdata(c,:),2)));
end

for c=1:numLED;
    stddatanorm(c,:)=std(mdatanorm(c,:),0,2);
end

time=linspace(1,info.T1,info.T1)/frameRate;

fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
set(fhraw,'Units','normalized');
%set(fhraw,'Units','normalized','visible','off');

plotedit on
%% Plot Raw Data
if strcmp(system, 'fcOIS1')
    Colors=[1 0 0; 1 0.5 0; 1 1 0; 0 0 1];
    TickLabels={'R', 'O', 'Y', 'B'};
elseif strcmp(system, 'fcOIS2')
    Colors=[0 0 1; 0 1 0; 1 1 0; 1 0 0];
    TickLabels={'B', 'G', 'Y', 'R'};
elseif strcmp(system, 'EastOIS1')
    Colors=[0 0 1; 1 1 0; 1 0.5 0; 1 0 0];
    TickLabels={'B', 'Y', 'O', 'R'};
      legendName = {'blue LED', 'green LED', 'orange LED' 'red LED'};
elseif strcmp(system, 'EastOIS1_Fluor')
    Colors = [0 0 1; 0 1 0; 1 0.5 0; 1 0 0];
    TickLabels = {'B','G','O', 'R' };
     legendName = {'green fluorescence', 'green LED', 'orange LED' 'red LED'};
elseif strcmp(system, 'EastOIS2')
    if strcmp(mouseType,'PV')
         TickLabels = {'G','R','B'};
           Colors = [0 1 0;1 0 0;0 0 1];
    legendName = {'green LED', 'red LED','Laser'};
    elseif strcmp(mouseType,'Gopto3')||strcmp(mouseType,'Wopto3')
         TickLabels = {'L','B','G','Red'};
           Colors = [0 0 1;1 0 1;0 1 0;1 0 0];
    legendName = {'Laser', 'Green Fluor','Green LED','red LED'};
    elseif strcmp(mouseType,'jrgeco1a-opto3')||strcmp(mouseType,'Wopto3')
         TickLabels = {'G','R','F','L'};
         Colors = [0 1 0;1 0 0;1 0 1;0 0 1;];
    legendName = {'Green LED','red LED', 'Red Fluor','Laser'};
    else
    TickLabels = {'B','G1','G2','R'};
    Colors = [0 0 1; 1 0 1;0 1 0;1 0 0];
    legendName = {'Blue Green fluorescence', 'Green red fluorescence','green LED', 'red LED'};
    end
elseif strcmp(system,'EastOIS2_OneCam')

         TickLabels = {'Fluor','G','R'};
           Colors = [ 0 0 1;0 1 0;1 0 0];
    legendName = {'Green fluorescence', 'GreenLED','Red LED'};

    
    

end



subplot('position', [0.1 0.75 0.25 0.2])
p=plot(time,mdata); title('Raw Data');
for c=1:numLED;
    set(p(c),'Color',Colors(c,:));
end
title('Raw Data');
xlabel('Time (sec)')
ylabel('Counts');
ylim([0.8*min(min(mdata)) 1.1*max(max(mdata))])

xlim([time(1) time(end)])

subplot('position', [0.45 0.68 0.5 0.27])
p=plot(time,mdatanorm'); title('Normalized Raw Data');
for c=1:numLED;
    set(p(c),'Color',Colors(c,:));
end
p(4).Color(4) = 0.05;
xlabel('Time (sec)')
ylabel('Mean Counts')
ylim([max(min(min(mdatanorm)),0.9) min(max(max(mdatanorm)),1.1)])
xlim([time(1) time(end)])

subplot('position', [0.42 0.09 0.14 0.18])
plot(stddatanorm*100');
ylim([0,2])
set(gca,'XTick',(1:numLED));
set(gca,'XTickLabel',TickLabels)
title('Std Deviation');
ylabel('% Deviation')


%% FFT Check
fdata=abs(fft(logmean(mdata),[],2));
hz=linspace(0,frameRate,info.T1);
subplot('position', [0.1 0.08 0.25 0.6]);
 title('FFT Raw Data');
for c=1:numLED;
    p(c)=loglog(hz(1:ceil(info.T1)),fdata(c,1:ceil(info.T1))'/5^(c^2-1));
    set(p(c),'Color',Colors(c,:));
    hold on
end
xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([0.01 10]);
legend(legendName,'Location','southwest')%legend(p,legendName,'Location','southwest')

%% Movement Check
rawdata=reshape(rawdata, info.nVy, info.nVx,numLED, []);

if strcmp(system, 'fcOIS1')
    BlueChan=4;
elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')||strcmp(system, 'EastOIS1_Fluor')
    BlueChan=2;
elseif strcmp(system, 'EastOIS2')
    if strcmp(mouseType,'PV')||strcmp(mouseType,'jrgeco1a-opto3')
        BlueChan = 1;
    else
    BlueChan = 3;
    end
elseif strcmp(system,'EastOIS2_OneCam')
    BlueChan = 2;
end

Im1=single(squeeze(rawdata(:,:,BlueChan,1)));
F1 = fft2(Im1); % reference image

InstMvMt=zeros(size(rawdata,4),1);
LTMvMt=zeros(size(rawdata,4),1);
Shift=zeros(2,size(rawdata,4),1);

for t=1:size(rawdata,4)-1;
    LTMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,BlueChan,t+1))-Im1)));
    InstMvMt(t)=sum(sum(abs(squeeze(rawdata(:,:,BlueChan,t+1))-squeeze(rawdata(:,:,BlueChan,t)))));
end

for t=1:size(rawdata,4);
    Im2=single(squeeze(rawdata(:,:,BlueChan,t)));
    F2 = fft2(Im2); % subsequent image to translate
    
    pdm = exp(1i.*(angle(F1)-angle(F2))); % Create phase difference matrix
    pcf = real(ifft2(pdm)); % Solve for phase correlation function
    pcf2(1:size(Im1,1)/2,1:size(Im1,1)/2)=pcf(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1)); % 4
    pcf2(size(Im1,1)/2+1:size(Im1,1),size(Im1,1)/2+1:size(Im1,1))=pcf(1:size(Im1,1)/2,1:size(Im1,1)/2); % 1
    pcf2(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1))=pcf(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2); % 3
    pcf2(size(Im1,1)/2+1:size(Im1,1),1:size(Im1,1)/2)=pcf(1:size(Im1,1)/2,size(Im1,1)/2+1:size(Im1,1)); % 2
    
    [~, imax] = max(pcf2(:));
    [ypeak, xpeak] = ind2sub(size(Im1,1),imax(1));
    offset = [ypeak-(size(Im1,1)/2+1) xpeak-(size(Im1,2)/2+1)];
    
    Shift(1,t)=offset(1);
    Shift(2,t)=offset(2);
    
end

clear rawdata

subplot('position', [0.43 0.4 0.5 0.2])

[AX, H1, H2]=plotyy(time, InstMvMt/1e6,time, LTMvMt/1e6);

set(get(AX(1), 'YLabel'), 'String', {'Sum Abs Diff Frame to Frame,'; '(Counts x 10^6)'});
set(get(AX(2),'YLabel'), 'String', {'Sum Abs Diff WRT First Frame,'; '(Counts x 10^6)'});
xlabel('Time  (sec)');
xlim(AX(1), [time(1) time(end)])
xlim(AX(2), [time(1) time(end)])
legend('Instantaneous Change','Change over Run');


subplot('position', [0.62 0.08 0.34 0.2]);
plot(time, Shift(1,:),'k');
hold on;
plot(time, Shift(2,:),'b');
ylim([-1*(abs(max(Shift(:)))+1) max(abs(Shift(:))+1)]);
xlabel('Time  (sec)');
xlim([time(1) time(end)])
ylabel('Offset (pixels)');
legend('Vertical','Horizontal');




annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName,' Raw Data Visualization'),'FontWeight','bold','Color',[1 0 0]);

output=fullfile(saveDir,strcat(visName,'_RawDataVis.jpg'));
orient portrait
print ('-djpeg', '-r300', output);

figure('visible', 'on');
close all
%save(fullfile(saveDir,strcat(visName,'.mat')), 'mdatanorm', 'mdata', 'stddatanorm', 'LTMvMt', 'InstMvMt', 'Shift', 'time', 'fdata', 'hz','info','-append');

%strcat(recDate,'-',mouseName,'-',sessionType,num2str(run))),'.mat')
