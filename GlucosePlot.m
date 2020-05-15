load('K:\Glucose\glucose_03162020.mat')
average_1 =  mean(glucose_1);
size(average_1)
std_1 = std(glucose_1);
size(std_1)
average_2 =  mean(glucose_2);
std_2 = std(glucose_2);
figure;errorbar([-41,-3,13,26,39,54,67,81],average_1,std_1,'k')
hold on
errorbar([-40,-2,14,27,40,55,68,82],average_2,std_2,'r:')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
legend('Test1','Test2','location','southeast')
xticks([-41,-3,13,26,39,54,67,81])
xticklabels({'-0:41','-0:03','0:13','0:26','0:39','0:54','1:07','1:21'})
ylabel('Blood Glucose Level(mg/dL)','fontweight','bold','FontSize',15,'fontweight','bold')
xlabel('Time(h:mm)','FontSize',15,'fontweight','bold')
title('Glucose Level','FontSize',15,'fontweight','bold')
load('D:\OIS_Process\noVasculatureMask.mat')
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold')

a = get(gca,'YTickLabel');  
set(gca,'YTickLabel',a,'fontsize',12,'FontWeight','bold')










clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\Glucose.xlsx";
numMice = 7;
dataTabel = cell(1,numMice);
dataTable{1,1} = readtable(excelFile,'Range','B3:G12');
dataTable{1,2} = readtable(excelFile,'Range','B17:G26');
dataTable{1,3} = readtable(excelFile,'Range','B31:G40');
dataTable{1,4} = readtable(excelFile,'Range','B45:G54');
dataTable{1,5} = readtable(excelFile,'Range','B59:G68');
dataTable{1,6} = readtable(excelFile,'Range','B73:G82');
dataTable{1,7} = readtable(excelFile,'Range','B87:G96');


plotColors = {[0, 0.4470, 0.7410],[0.8500, 0.3250, 0.0980],[0.9290, 0.6940, 0.1250],...
    [0.4940, 0.1840, 0.5560],[0.4660, 0.6740, 0.1880],[0.3010, 0.7450, 0.9330],[0.6350, 0.0780, 0.1840]};
for ii = 1:numMice
    kk = 1;
    for jj = [1 2 4 5 6 7 8 9]
        timePoint_1_text =  dataTable{1,ii}{jj,2}{1};
        infmt = 'hh:mm';
        outfmt = infmt;
        timePoint_1(ii,kk) = duration(timePoint_1_text,'InputFormat',infmt,'Format',outfmt);
        glucose_1(ii,kk) = dataTable{1,ii}{jj,3};
        
       %scatter(timePoint_1,dataTable{1,ii}{jj,3},[],plotColors{1,ii});
        hold on;
        timePoint_2_text =  dataTable{1,ii}{jj,5}{1};
        timePoint_2(ii,kk) = duration(timePoint_2_text,'InputFormat',infmt,'Format',outfmt);
        glucose_2(ii,kk) = dataTable{1,ii}{jj,6};
        %h(ii) = scatter(timePoint_2,dataTable{1,ii}{jj,6},[],plotColors{1,ii},'filled');
        kk = kk+1;
    end    
end
save('K:\Glucose\glucose_03162020.mat','glucose_1','glucose_2','timePoint_1','timePoint_2')

load('K:\Glucose\glucose_03162020.mat')
for ii = 1:numMice
 plot(timePoint_1(ii,:),glucose_1(ii,:),'Color',plotColors{1,ii},'LineStyle',':','LineWidth',3);
hold on
end



for ii = 1:numMice
h(ii)= plot(timePoint_2(ii,:),glucose_2(ii,:),'Color',plotColors{1,ii},'LineWidth',3);
hold on
end

lgd = legend(h,{'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7'},'Location','southeast');
title(lgd,'... test #1; - test #2')
ylim([50,610])
xlabel('Time after Dextrose Injection(hh:mm)','fontweight','bold')
ylabel('Blood Glucose Level(mg/dL)','fontweight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)


load('K:\Glucose\glucose_03162020.mat')
time = [1,3,4,5,6,7,8,9];
for ii = 1:numMice
 plot(time,glucose_1(ii,:),'Color',plotColors{1,ii},'LineStyle',':','LineWidth',3);
hold on
end



for ii = 1:numMice
h(ii)= plot(time,glucose_2(ii,:),'Color',plotColors{1,ii},'LineWidth',3);
hold on
end

lgd = legend(h,{'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7'},'Location','southeast');
title(lgd,'... test #1; - test #2')
ylim([50,610])
xlabel('')
ylabel('Blood Glucose Level(mg/dL)','fontweight','bold')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)