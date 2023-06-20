clear;close all;clc
excelFile="X:\XW\Paper2\GlobalEffects\GlobalEffects_PVChR2Thy1jRGECO1a.xlsx";
excelRows=2:7;

runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
%% Get Masks and WL
previousDate = []; %initialize the date
mouse_ind=start_ind_mouse';
for runInd=mouse_ind
    runInfo = runsInfo(runInd);
    load(runInfo.saveHbFile,'xform_datahb')
    xform_total = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
    clear xform_datahb
    load(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'), 'xform_datalaser')
    load(runInfo.saveFluorFile, 'xform_datafluorCorr')
    load(runInfo.saveMaskFile,'xform_isbrain')

    % video for first resting state
    saveDest_resting1 = strcat(runInfo.saveFilePrefix,'-resting1-NoGSR.avi');
    writerObj_resting1 = VideoWriter(saveDest_resting1);
    writerObj_resting1.FrameRate = runInfo.samplingRate;

    fig1 = figure(1);
    set(fig1, 'Position', [50 50 700 275], 'Visible', 'off', 'Color', 'white');
    startIndex = 1;

    for jj =  1:12000
        display(num2str((jj-startIndex)/runInfo.samplingRate))
        ax1 = subplot(1,3,1);imagesc(xform_datalaser(:,:,jj),'AlphaData',xform_isbrain,[0 50000]);
        set(gca,'Visible','off');
        colormap(ax1,brewermap(256, 'Blues'));
        axis(gca,'square');
        cb1=colorbar;
        cb1.Label.String = 'Counts';
        titleObj1 = title('Laser');
        set(titleObj1,'Visible','on');

        ax2= subplot(1,3,2);imagesc(xform_datafluorCorr(:,:,jj)*100,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax2,brewermap(256, '-PiYG'));
        axis(gca,'square');
        cb2=colorbar;
        cb2.Label.String = '\DeltaF/F%';
        titleObj1 = title('Calcium');
        set(titleObj1,'Visible','on');
        set(cb2,'YTick',[-6,0,6]);
  

        ax3 = subplot(1,3,3);imagesc(xform_total(:,:,jj)*10^6,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax3,brewermap(256, '-Spectral'));
        axis(gca,'square');
        cb3=colorbar;
        cb3.Label.String = '\muM';
        set(cb3,'YTick',[-6,0,6]);
        titleObj3 = title('HbT');
        set(titleObj3,'Visible','on');

        titleObj = sgtitle(strcat(runInfo.mouseName,', Resting state before PS, t = ', sprintf('%.2f',(jj-startIndex)/runInfo.samplingRate), 's'));
        set(titleObj,'Visible','on');
        Frames(jj-startIndex+1) = getframe(fig1);
        drawnow;
    end
    open(writerObj_resting1);
    for ii=1:length(Frames)
        frame = Frames(ii);
        writeVideo(writerObj_resting1,frame);
    end
    close(writerObj_resting1);
    close(fig1);
    clear('Frames');
    disp('Finished!');
    clear frame Frames
    % PS 
    Laser_baseline   = mean(xform_datalaser(:,:,1:12000),3);
    calcium_baseline = mean(xform_datafluorCorr(:,:,1:12000),3);
    total_baseline   = mean(xform_total(:,:,1:12000),3);

    % video for PS
    saveDest_PS = strcat(runInfo.saveFilePrefix,'-PS-NoGSR.avi');
    writerObj_PS = VideoWriter(saveDest_PS);
    writerObj_PS.FrameRate = runInfo.samplingRate;

    fig2 = figure(2);
    set(fig2, 'Position', [50 50 700 275], 'Visible', 'off', 'Color', 'white');
    startIndex = 12001;

    for jj =  12001:12100
        display(num2str((jj-startIndex)/runInfo.samplingRate))
        ax1 = subplot(1,3,1);imagesc(xform_datalaser(:,:,jj)-Laser_baseline,'AlphaData',xform_isbrain,[0 50000]);
        set(gca,'Visible','off');
        colormap(ax1,brewermap(256, 'Blues'));
        axis(gca,'square');
        cb1=colorbar;
        cb1.Label.String = 'Counts';
        titleObj1 = title('Laser');
        set(titleObj1,'Visible','on');

        ax2= subplot(1,3,2);imagesc(xform_datafluorCorr(:,:,jj)*100-calcium_baseline,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax2,brewermap(256, '-PiYG'));
        axis(gca,'square');
        cb2=colorbar;
        cb2.Label.String = '\DeltaF/F%';
        titleObj1 = title('Calcium');
        set(titleObj1,'Visible','on');
        set(cb2,'YTick',[-6,0,6]);
  

        ax3 = subplot(1,3,3);imagesc(xform_total(:,:,jj)*10^6-total_baseline,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax3,brewermap(256, '-Spectral'));
        axis(gca,'square');
        cb3=colorbar;
        cb3.Label.String = '\muM';
        set(cb3,'YTick',[-6,0,6]);
        titleObj3 = title('HbT');
        set(titleObj3,'Visible','on');

        titleObj = sgtitle(strcat(runInfo.mouseName,', PS, t = ', sprintf('%.2f',(jj-startIndex)/runInfo.samplingRate), 's'));
        set(titleObj,'Visible','on');
        Frames(jj-startIndex+1) = getframe(fig2);
        drawnow;
    end
    open(writerObj_PS);
    for ii=1:length(Frames)
        frame = Frames(ii);
        writeVideo(writerObj_PS,frame);
    end
    close(writerObj_PS);
    close(fig2);
    clear('Frames');
    disp('Finished!');
    clear frame Frames

    % Resting state after PS
    saveDest_resting2 = strcat(runInfo.saveFilePrefix,'-resting2-NoGSR.avi');
    writerObj_resting2 = VideoWriter(saveDest_resting2);
    writerObj_resting2.FrameRate = runInfo.samplingRate;

    fig3 = figure(3);
    set(fig3, 'Position', [50 50 700 275], 'Visible', 'off', 'Color', 'white');
    startIndex = 12101;

    for jj =  12101:24100
        display(num2str((jj-startIndex)/runInfo.samplingRate))
        ax1 = subplot(1,3,1);imagesc(xform_datalaser(:,:,jj),'AlphaData',xform_isbrain,[0 50000]);
        set(gca,'Visible','off');
        colormap(ax1,brewermap(256, 'Blues'));
        axis(gca,'square');
        cb1=colorbar;
        cb1.Label.String = 'Counts';
        titleObj1 = title('Laser');
        set(titleObj1,'Visible','on');

        ax2= subplot(1,3,2);imagesc(xform_datafluorCorr(:,:,jj)*100,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax2,brewermap(256, '-PiYG'));
        axis(gca,'square');
        cb2=colorbar;
        cb2.Label.String = '\DeltaF/F%';
        titleObj1 = title('Calcium');
        set(titleObj1,'Visible','on');
        set(cb2,'YTick',[-6,0,6]);
  

        ax3 = subplot(1,3,3);imagesc(xform_total(:,:,jj)*10^6,'AlphaData',xform_isbrain,[-6 6]);
        set(gca,'Visible','off');
        colormap(ax3,brewermap(256, '-Spectral'));
        axis(gca,'square');
        cb3=colorbar;
        cb3.Label.String = '\muM';
        set(cb3,'YTick',[-6,0,6]);
        titleObj3 = title('HbT');
        set(titleObj3,'Visible','on');

        titleObj = sgtitle(strcat(runInfo.mouseName,', Resting state after PS, t = ', sprintf('%.2f',(jj-startIndex)/runInfo.samplingRate), 's'));
        set(titleObj,'Visible','on');
        Frames(jj-startIndex+1) = getframe(fig3);
        drawnow;
    end
    open(writerObj_resting2);
    for ii=1:length(Frames)
        frame = Frames(ii);
        writeVideo(writerObj_resting2,frame);
    end
    close(writerObj_resting2);
    close(fig3);
    clear('Frames');
    disp('Finished!');
    clear frame Frames

    clear xform_datalaser xform_datafluorCorr xform_total
end

