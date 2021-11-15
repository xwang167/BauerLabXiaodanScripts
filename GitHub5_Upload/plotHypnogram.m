function plotHypnogram(scoringindex, filetitle)
%simple function to plot the hypnogram alone based on the scoringindex
disp('Plotting hypnogram');

timemax=length(scoringindex);
figure;
subplot(2,1,2);
axis ([0 timemax+1 0 3])
% axis ([0 timemax 0 5])
set(gca,'YTick',[0.5 1.5 2.5])
% set(gca,'YTick',[0.5 1.5 2.5 3.5])
set(gca,'YTickLabel',{'R','W','N'},'Fontsize',14)
% set(gca,'YTickLabel',{'A','R','N','W'})
% time = (5:10:5+10*1078)/3600;
set(gca,'XTick',[180 360 540 720 900 1080]);
set(gca,'XTickLabel', [0.5 1 1.5 2 2.5 3],'Fontsize',14);
ylabel('Sleep States','FontSize',14)
xlabel('Time(hr)','FontSize',14)
title(filetitle,'FontSize',18)
set(gcf,'color','white')

for l=1:size(scoringindex,2)
    switch scoringindex(l)
        
        case 0  %WAKE
            line([1 1]*l,[1 2],'LineWidth',1,'Color',[241 161 5]/255);
            
        case 1 %NREM
            line([1 1]*l,[2 3],'LineWidth',1,'Color',[39 125 229]/255);
%         case 2 %ARTIFACT
%             line([1 1]*l,[3 4],'LineWidth',2,'Color','green');
        case 3 %REM
            line([1 1]*l,[0 1],'LineWidth',1,'Color',[38 179 150]/255);
    end
end

% for l=1:size(scoringindex,2)
%     switch scoringindex(l)
%         
%         case 0 
%             line([1 1]*l,[3 4],'LineWidth',2,'Color','blue');
%             
%         case 1
%             line([1 1]*l,[2 3],'LineWidth',2,'Color','black');
%         case 2
%             line([1 1]*l,[0 1],'LineWidth',2,'Color','green');
%         case 3
%             line([1 1]*l,[1 2],'LineWidth',2,'Color','red');
%         
%       
%     end
%    
% end

% xlabel('epoch')
% title(filetitle)

disp('Finished plotting hypnogram');
end