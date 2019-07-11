clear all;close all;clc
system = 'EastOIS2';

info.freqout=1;
info.bandtype = {"0.01Hz-8Hz",0.01,8};

excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
info.nVx = 128;
info.nVy = 128;

excelRows = [22 24 25];
numMouse = length(excelRows);

oxy_mice = [];
deoxy_mice = [];
total_mice = [];
mouseName_cat = [];
n =1;
info.newFreq = 8;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    mouseName_cat = strcat(mouseName_cat,'-',mouseName);
    info.newFreq = 8;
    
    
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{10};
    
    if ~exist(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'file')
        load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\Combined\',recDate,'-',mouseName,'-LandmarksandMarks'),'I','isbrain')
        %
        % [nVy, nVx, hem, T]=size(datahb);
        % for h=1:hem;
        %     for m=1:T;
        %         xform_datahb_old(:,:,h,m)=Affine(I, datahb(:,:,h,m));
        %     end
        % end
        %
        %  xform_datahb_old=real(xform_datahb_old);
        % load('J:\ProcessedData_3\GCaMP\181217\181217-G3M6-stim1-GSR-Detrend-0.01Hz-8Hz.mat','xform_datahb_bandpass_GSR')
        
        oxy_runs = [];
        deoxy_runs = [];
        total_runs = [];
        for ii = 1:3
            if ~exist(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'file')
                load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat'),'xform_datahb')
                
                xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
                %xform_datahb_bandpass=lowpass(xform_datahb_bandpass ,info.bandtype{3},info.newFreq);
                
                xform_isbrain = Affine(I,isbrain);
                %
                
                xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
                %
                %
                % if ~isempty(find(isnan(xform_datahb_bandpass_GSR), 1))
                %     xform_datahb_bandpass_GSR(isnan(xform_datahb_bandpass_GSR))=0;
                %     disp(strcat(tiffFileName,'xform_datahb_bandpass_GSR has NAN'));
                % end
                %
                %
                %
                
                oxy = double(squeeze(xform_datahb_GSR(:,:,1,:)));
                deoxy = double(squeeze(xform_datahb_GSR(:,:,2,:)));
                total = double(oxy+deoxy);
                
                xform_isbrain = double(xform_isbrain);
                
                oxy = oxy.*xform_isbrain;
                deoxy = deoxy.*xform_isbrain;
                total = total .*xform_isbrain;
                
                oxy(isnan(oxy)) = 0;
                deoxy(isnan(deoxy)) = 0;
                total(isnan(total)) = 0;
                
                
                fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
                set(fhraw,'Units','normalized','visible','off');
                
                plotedit on
                R=mod(size(oxy,3),sessionInfo.stimblocksize);
                if R~=0
                    pad=sessionInfo.stimblocksize-R;
                    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
                    oxy(:,:,end:end+pad)=0;
                    deoxy(:,:,end:end+pad)=0;
                    total(:,:,end:end+pad)=0;
                    
                end
                
                oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                
                for b=1:size(oxy,4)
                    MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(oxy, 3);
                        oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
                    end
                end
                
                deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                for b=1:size(deoxy,4)
                    MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(deoxy, 3);
                        deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
                    end
                end
                
                total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
                for b=1:size(total,4)
                    MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
                    for t=1:size(total, 3);
                        total(:,:,t,b)=squeeze(total(:,:,t,b))-MeanFrame;
                    end
                end
                
                oxy = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                deoxy = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                total = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
                
                oxy = permute(oxy,[1 2 4 3]);
                deoxy = permute(deoxy,[1 2 4 3]);
                total = permute(total,[1 2 4 3]);
                
                info.stimblocksize = size(oxy,3);
                info.stimbaseline = round(sessionInfo.stimbaseline/sessionInfo.stimblocksize*info.stimblocksize);
                oxy_runs = cat(5,oxy_runs,oxy);
                deoxy_runs = cat(5,deoxy_runs,deoxy);
                total_runs = cat(5,total_runs,total);
                
                
                
                % Block Average
                
                [oxy_blocks_baseline_downsampled,deoxy_blocks_baseline_downsampled,total_blocks_baseline_downsampled] = traceImagePlot(oxy,deoxy,total,info,sessionInfo);
                
                annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(ii)),'FontWeight','bold','Color',[1 0 0],'FontSize',8);
                
                output= strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),' .jpg');
                orient portrait
                print ('-djpeg', '-r1000',output);
                figure('visible', 'on');
                close all
                save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info')
                strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat')
            else
                load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy','deoxy','total');
                oxy_runs = cat(5,oxy_runs,oxy);
                deoxy_runs = cat(5,deoxy_runs,deoxy);
                total_runs = cat(5,total_runs,total);
            end
        end
        oxy = mean(oxy_runs,5);
        deoxy = mean(deoxy_runs,5);
        total = mean(total_runs,5);
        [oxy_blocks_baseline_downsampled,deoxy_blocks_baseline_downsampled,total_blocks_baseline_downsampled] = traceImagePlot(oxy,deoxy,total,info,sessionInfo);
        
        oxy_mice = cat(5,oxy_mice,oxy);
        deoxy_mice = cat(5,deoxy_mice,deoxy);
        total_mice = cat(5,total_mice,total);
        
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for',"  " ,recDate,'-',mouseName,'-stim'),'FontWeight','bold','Color',[1 0 0],'FontSize',8);
        save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','oxy_mice');
        output= strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',' .jpg');
        orient portrait
        print ('-djpeg', '-r1000',output);
        figure('visible', 'on');
        close all
    else
        load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy','deoxy','total')
        oxy_mice = cat(5,oxy_mice,oxy);
        deoxy_mice = cat(5,deoxy_mice,deoxy);
        total_mice = cat(5,total_mice,total);
    end
    
    n = n+1;
end

oxy = mean(oxy_mice,5);
deoxy = mean(deoxy_mice,5);
total = mean(total_mice,5);
[oxy_blocks_baseline_downsampled,deoxy_blocks_baseline_downsampled,total_blocks_baseline_downsampled] = traceImagePlot(oxy,deoxy,total,info,sessionInfo);
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat('Block Average for', " " ,mouseName_cat),'FontWeight','bold','Color',[1 0 0],'FontSize',8);

output= strcat('J:\ProcessedData_2\Zyla\190102\190102-',mouseName_cat,'-stim','_cat'' .jpg');
orient portrait
print ('-djpeg', '-r1000',output);
figure('visible', 'on');
close all