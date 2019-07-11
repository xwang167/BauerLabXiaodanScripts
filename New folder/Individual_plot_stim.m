clearvars;close all;clc
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end




% oxy_mice = [];
% deoxy_mice = [];
% gcamp_mice= [];
% gcampCorr_mice = [];
% green_mice = [];


for excelRow = 7:11
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = string(saveDir);
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    oxy_runs = [];
    deoxy_runs = [];
    total_runs = [];
    gcampRaw_runs = [];
    gcampCorr_runs = [];
    green_runs = [];
    for run = 1:3
        %         rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
        %         [~, ~, L]=size(rawdata);
        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),"-",bandtype,isGsrname,"-NewDetrend");
        load(strcat(fullfile(saveDir,processedDataName),'.mat'),'xform_hb','xform_total','xform_gcampCorr','xform_gcamp','xform_green','sessionInfo','info')
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline = excelRaw{9};
    sessionInfo.stimduration*sessionInfo.stimFrequency = excelRaw{10};
        oxy = squeeze(xform_hb(:,:,1,:));
        deoxy = squeeze(xform_hb(:,:,2,:));
        total = squeeze(xform_total(:,:,1,:));
        gcampRaw = squeeze(xform_gcamp(:,:,1,:));
        gcampCorr = squeeze(xform_gcampCorr(:,:,1,:));
        green = squeeze(xform_green(:,:,1,:));
        R=mod(size(oxy,3),sessionInfo.stimblocksize*sessionInfo.framerate);
        if R~=0
            pad=sessionInfo.stimblocksize*sessionInfo.framerate-R;
            disp(['** Non integer number of blocks presented. Padded ' processedDataName, num2str(run), ' with ', num2str(pad), ' zeros **'])
            oxy(:,:,end:end+pad)=0;
            deoxy(:,:,end:end+pad)=0;
            total(:,:,end:end+pad)=0;
            gcampRaw(:,:,end:end+pad)=0;
            gcampCorr(:,:,end:end+pad)=0;
            green(:,:,end:end+pad)=0;
            info.appendedzeros=pad;
        end
        
        
        
        
        oxy = reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        deoxy = reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        total = reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        gcampRaw = reshape(gcampRaw,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        gcampCorr = reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        green = reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize*sessionInfo.framerate,[]);
        clear xform_hb xform_gcampCorr xform_gcamp xform_green;
        
        oxy_runs = cat(4,oxy_runs,oxy);
        deoxy_runs = cat(4,deoxy_runs,deoxy);
        total_runs = cat(4,total_runs,total);
        gcampRaw_runs = cat(4,gcampRaw_runs,gcampRaw);
        gcampCorr_runs = cat(4,gcampCorr_runs,gcampCorr);
        green_runs = cat(4,green_runs,green);
    end
    
    
    baseline_size = size(oxy_runs);
    oxy_runs_baseline = zeros(baseline_size);
    deoxy_runs_baseline = zeros(baseline_size);
    total_runs_baseline = zeros(baseline_size);
    gcampRaw_runs_baseline = zeros(baseline_size);
    gcampCorr_runs_baseline = zeros(baseline_size);
    green_runs_baseline = zeros(baseline_size);
    
    numBlock_runs = size(oxy_runs,4);
    frames_block = sessionInfo.framerate * sessionInfo.stimblocksize;
    for block = 1:numBlock_runs
        for frame = 1:frames_block
            oxy_runs_baseline(:,:,frame,block) = squeeze(oxy_runs(:,:,frame,block))-squeeze(mean(oxy_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
            deoxy_runs_baseline(:,:,frame,block) = squeeze(deoxy_runs(:,:,frame,block))-squeeze(mean(deoxy_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
            total_runs_baseline(:,:,frame,block) = squeeze(total_runs(:,:,frame,block))-squeeze(mean(total_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
            gcampRaw_runs_baseline(:,:,frame,block) = squeeze(gcampRaw_runs(:,:,frame,block))-squeeze(mean(gcampRaw_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
            gcampCorr_runs_baseline(:,:,frame,block) = squeeze(gcampCorr_runs(:,:,frame,block))-squeeze(mean(gcampCorr_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
            green_runs_baseline(:,:,frame,block) = squeeze(green_runs(:,:,frame,block))-squeeze(mean(green_runs(:,:,1:sessionInfo.stimbaseline*sessionInfo.framerate,block),3));
        end
    end
    
    oxy_runs_baseline_active = zeros(numBlock_runs,frames_block);
    deoxy_runs_baseline_active = zeros(numBlock_runs,frames_block);
    total_runs_baseline_active = zeros(numBlock_runs,frames_block);
    gcampRaw_runs_baseline_active = zeros(numBlock_runs,frames_block);
    gcampCorr_runs_baseline_active = zeros(numBlock_runs,frames_block);
    green_runs_baseline_active = zeros(numBlock_runs,frames_block);
    for block = 1:numBlock_runs
        for frame = 1:frames_block
            temp_oxy = oxy_runs_baseline(:,:,frame,block);
            oxy_runs_baseline_active(frame,block) = mean(temp_oxy(temp_oxy_area>= 0.75*temp_oxy_max));
            
            temp_deoxy = deoxy_runs_baseline(:,:,frame,block);
            deoxy_runs_baseline_active(frame,block) = mean(temp_deoxy(temp_oxy_area>=0.75*temp_oxy_max));
            
                        %temp_total = total_runs_baseline(:,:,frame,block);
            %total_runs_baseline_active(frame,block) = mean(temp_total(temp_oxy_area>=0.75*temp_oxy_max));
            
            temp_gcampRaw = gcampRaw_runs_baseline(:,:,frame,block);
            gcampRaw_runs_baseline_active(frame,block) = mean(temp_gcampRaw(temp_gcampCorr_area>=0.75*temp_gcampCorr_max));
            
            temp_gcampCorr = gcampCorr_runs_baseline(:,:,frame,block);
            gcampCorr_runs_baseline_active(frame,block) = mean(temp_gcampCorr(temp_gcampCorr_area>=0.75*temp_gcampCorr_max));
            
            temp_green = green_runs_baseline(:,:,frame,block);
            green_runs_baseline_active(frame,block) = mean(temp_green(temp_gcampCorr_area>=0.75*temp_gcampCorr_max));
        end
    end
    
    x = (1:sessionInfo.framerate*30)./sessionInfo.framerate;
    plotedit on
    
    
    for i = 1:numBlock_runs
        subplot('position',[0.1,0.08,0.8,0.4])
        yyaxis left
        p1 = plot(x,gcampCorr_runs_baseline_active(1:sessionInfo.framerate*30,i),'o');
        ylim([-0.02 0.04])
        
        
        hold on
        yyaxis right
        p2 = plot(x,oxy_runs_baseline_active(1:sessionInfo.framerate*30,i),'s');
        ylim([-2e-5 4e-5])
        hold on
        yyaxis right
        ylabel('HBO_2,HbR,HbTotal(\DeltaM)','FontSize',6)
        p3 = plot(x,deoxy_runs_baseline_active(1:sessionInfo.framerate*30,i),'*');
        ylim([-2e-5 4e-5]);
        %p4 = plot(x,total_runs_baseline_active(1:sessionInfo.framerate*30,i),'y');
        ylim([-2e-5 4e-5]);
        yyaxis left;
        ylabel('GCaMP6f(\DeltaF/F)','FontSize',6);
        
        
        hold on
        for k  = 0:5*3
            p = line([5+k/3 5+k/3],[-0.02 0.04]);
            hold on
        end
        
        legend([p2 p3 p1 ],'HbO_2','HbR','G6f(corr.)','FontSize',5);
        %legend([p2 p3 p4 p1 ],'HbO_2','HbR','HbTotal','G6f(corr.)','FontSize',5);
        xlabel('Time(s)','FontSize',6)
        
        
        
        subplot('position',[0.1,0.55,0.8,0.4])
        p4 = plot(x,gcampCorr_runs_baseline_active(1:sessionInfo.framerate*30,i),'o');
        y2 = get(gca,'ylim');
        
        hold on
        p5=plot(x,gcampRaw_runs_baseline_active(1:sessionInfo.framerate*30,i),'Color',[0 0.6 0]);
        ylabel('GCaMP6f(\DeltaF)','FontSize',6)
        hold on
        p6=plot(x,green_runs_baseline_active(1:sessionInfo.framerate*30,i),'x');
        y2 = get(gca,'ylim');
        hold on
        for j = 0:5*3
            line([5+j/3 5+j/3],y2);
            hold on
        end
        
        legend([p6 p5 p4 ],'512nm','G6f(raw)','G6f(corr.)','FontSize',5);
        xlabel('Time(s)','FontSize',6)
        
        xt = get(gca, 'XTick');
        set(gca, 'FontSize',6)
    end
    
    
end

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(recDate,"-",sessionType,bandtype,'Hz Block Average for  ' ,{' '}, mouseName),'FontWeight','bold','Color',[1 0 0]);

output=fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,bandtype,'-Individual_EachMouse_Vis.jpg'));
orient portrait
print ('-djpeg', '-r1000',output);
figure('visible', 'on');



close all
