load('X:\PVChR2-Thy1RGECO\cat\AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites.mat', 'AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites')
load('N13M309-N13M549-N13M548-N27M753-N27M755-N26M761-N26M764-N24M783-N24M778-N24M322-SeedLocation.mat', 'seedLocation_mice')
A = AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites(:,:,:,87)*100;
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
saveDest = 'D:\movie\PSleftGrid_block87_v2.avi';
    writerObj = VideoWriter(saveDest);
    writerObj.FrameRate = 10;
    framerate = 10;
    %%
    close all
    fig1 = figure(1);
    disp('drawing')
    mycolormap =customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    for jj =  60:2:240
        display(num2str(jj/20))
        imagesc(A(:,:,jj),'AlphaData',mask,[-1.5 1.5]); 
        text(53,10,['t = ' sprintf('%.1f',(jj-100)/20) 's'],'FontSize',14,'FontWeight','bold')
        set(gca,'Visible','off'); 
        if jj>100 && jj<201
            hText = text(100,15,'Stim On','FontSize',14,'color','b','FontWeight','bold');
            hold on
            scatter(21,85.5,100,'b','o','LineWidth',2)
            hold off
        end
        axis(gca,'square');
       %title(['t=' sprintf('%.1f',(jj-100)/framerate) 's'],'FontSize',14,'FontWeight','bold')
       colormap(mycolormap);      
        Frames((jj-58)/2) = getframe(fig1);
        drawnow;
    end
     
    open(writerObj);
    for ii=1:length(Frames)
        frame = Frames(ii);
        writeVideo(writerObj,frame);
    end
    close(writerObj);
    close(fig1);
    clear('Frames');
    disp('Finished!');


