function FinalMouseBrain = John_MakeMouseBrainStandard(excelfiles)
close all
database='E:\LeeOISProjects\PVTitrations\PVCHR2Titration.xlsx';
FinalMouseBrain = zeros(128,128,length(excelfiles),2);
num = 0;
for n = excelfiles;
    num = num+1;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':H',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    sessiontype=eval(raw{6});
    
    load([saveloc,Date,'\',Date,'-',Mouse,'-stim1-datahb.mat'], 'xform_GalvoSeed','xform_LaserFrameIndices','GoodSeedsidx_Left');
    figure
    John_CreateNiceWL(0.1);
    xlim([-10,138]);
    ylim([-10,138]);
    hold on
    for i = 1:size(xform_GalvoSeed,1);
        plot(xform_GalvoSeed(i,1),xform_GalvoSeed(i,2),'ko');
        plot(xform_LaserFrameIndices(i,1),xform_LaserFrameIndices(i,2),'kx');
        text(xform_GalvoSeed(i,1)-0.75,xform_GalvoSeed(i,2)-4,num2str(i));
    end
    
    diststore = zeros(size(xform_GalvoSeed,1),1);
    for j = 1:size(xform_GalvoSeed,1);
        dist1 = sqrt((xform_GalvoSeed(j,1)-xform_LaserFrameIndices(j,1))^2 + ...
            (xform_GalvoSeed(j,2)-xform_LaserFrameIndices(j,2))^2);
        diststore(j) = dist1;
        line = [xform_GalvoSeed(j,1),xform_GalvoSeed(j,2); ...
            xform_LaserFrameIndices(j,1),xform_LaserFrameIndices(j,2)];
        if dist1 <=2;
            linecol = '--g';
            txtcol = 'green';
        elseif dist1 <=4;
            linecol = '--y';
            txtcol = [0.5,0.5,0];
        else
            linecol ='--r';
            txtcol = 'red';
        end
        plot(line(:,1),line(:,2),linecol,'HandleVisibility','off')
        str = sprintf('%.1f',dist1);
        text(xform_GalvoSeed(j,1)-0.75,xform_GalvoSeed(j,2)-2,str,'Color',txtcol);
    end
        
    badseeds = input('Type in the seeds to exclude [***]: ');
    CurvatureGoodSeeds = GoodSeedsidx_Left;
    CurvatureGoodSeeds(badseeds) = 0;
    FinalMouseBrain(:,:,num,:) = John_Make3DMouseBrain(7,30,30,xform_GalvoSeed,xform_LaserFrameIndices,CurvatureGoodSeeds);
    clearvars xform_GalvoSeed xform_LaserFrameIndices CurvatureGoodSeeds GoodSeedsidx_Left
end
FinalMouseBrain = squeeze(mean(FinalMouseBrain(:,:,:,:),3));
figure
surf_x = 1:128;
surf_y = 1:128;
surf_z_x = squeeze(FinalMouseBrain(:,:,1));
surf_z_y = squeeze(FinalMouseBrain(:,:,2));
subplot(1,2,1)
John_CreateNiceWL(1); hold on
surf(surf_x,surf_y,surf_z_x);
xlim([0,128]);
ylim([0,128]);
daspect([1,1,1]);
subplot(1,2,2)
John_CreateNiceWL(1); hold on
surf(surf_x,surf_y,surf_z_y);

xlim([0,128]);
ylim([0,128]);
daspect([1,1,1]);
save('E:\LeeOISProjects\MouseBrainStandard','FinalMouseBrain');
end


