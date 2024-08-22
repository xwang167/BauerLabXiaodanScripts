% %% mouse average fc
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
info.nVx = 128;
info.nVy = 128;
runs =1:3;
length_runs = length(runs);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
% Initialization ISA
    R_jrgeco1aCorr_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_jrgeco1aCorr_ISA_mouse = zeros(16,16,length_runs);

    R_FADCorr_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_FADCorr_ISA_mouse = zeros(16,16,length_runs);

    R_total_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_total_ISA_mouse = zeros(16,16,length_runs);
% Initialization Delta
    R_jrgeco1aCorr_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_jrgeco1aCorr_Delta_mouse = zeros(16,16,length_runs);

    R_FADCorr_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_FADCorr_Delta_mouse = zeros(16,16,length_runs);

    R_total_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_total_Delta_mouse = zeros(16,16,length_runs);

    for n = runs
        disp('loading processed data')

        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName), ...
            'R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA',...
            'R_FADCorr_Delta','R_FADCorr_ISA','Rs_FADCorr_Delta','Rs_FADCorr_ISA',...
            'R_total_Delta','R_total_ISA','Rs_total_Delta','Rs_total_ISA')
        % ISA 
        R_jrgeco1aCorr_ISA_mouse(:,:,:,n) = R_jrgeco1aCorr_ISA;
        Rs_jrgeco1aCorr_ISA_mouse(:,:,n) = Rs_jrgeco1aCorr_ISA;

        R_FADCorr_ISA_mouse(:,:,:,n) = R_FADCorr_ISA;
        Rs_FADCorr_ISA_mouse(:,:,n) = Rs_FADCorr_ISA;

        R_total_ISA_mouse(:,:,:,n) = R_total_ISA;
        Rs_total_ISA_mouse(:,:,n) = Rs_total_ISA;
        %Delta
        R_jrgeco1aCorr_Delta_mouse(:,:,:,n) = R_jrgeco1aCorr_Delta;
        Rs_jrgeco1aCorr_Delta_mouse(:,:,n) = Rs_jrgeco1aCorr_Delta;

        R_FADCorr_Delta_mouse(:,:,:,n) = R_FADCorr_Delta;
        Rs_FADCorr_Delta_mouse(:,:,n) = Rs_FADCorr_Delta;

        R_total_Delta_mouse(:,:,:,n) = R_total_Delta;
        Rs_total_Delta_mouse(:,:,n) = Rs_total_Delta;
    end

    disp(char(['QC check on ', processedName_mouse]))

    % ISA average across runs
    R_jrgeco1aCorr_ISA_mouse = mean(R_jrgeco1aCorr_ISA_mouse,4);
    Rs_jrgeco1aCorr_ISA_mouse = mean(Rs_jrgeco1aCorr_ISA_mouse,3);

    R_FADCorr_ISA_mouse = mean(R_FADCorr_ISA_mouse,4);
    Rs_FADCorr_ISA_mouse = mean(Rs_FADCorr_ISA_mouse,3);

    R_total_ISA_mouse = mean(R_total_ISA_mouse,4);
    Rs_total_ISA_mouse = mean(Rs_total_ISA_mouse,3);

    % Delta average across runs
    R_jrgeco1aCorr_Delta_mouse = mean(R_jrgeco1aCorr_Delta_mouse,4);
    Rs_jrgeco1aCorr_Delta_mouse = mean(Rs_jrgeco1aCorr_Delta_mouse,3);

    R_FADCorr_Delta_mouse = mean(R_FADCorr_Delta_mouse,4);
    Rs_FADCorr_Delta_mouse = mean(Rs_FADCorr_Delta_mouse,3);

    R_total_Delta_mouse = mean(R_total_Delta_mouse,4);
    Rs_total_Delta_mouse = mean(Rs_total_Delta_mouse,3);

    save(fullfile(saveDir, processedName_mouse),...
        'R_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_Delta_mouse',...
        'R_FADCorr_Delta_mouse','Rs_FADCorr_Delta_mouse',...
        'R_total_Delta_mouse','Rs_total_Delta_mouse',...
        'R_jrgeco1aCorr_ISA_mouse','Rs_jrgeco1aCorr_ISA_mouse',...
        'R_FADCorr_ISA_mouse','Rs_FADCorr_ISA_mouse',...
        'R_total_ISA_mouse','Rs_total_ISA_mouse','-append')

    % QCcheck_fcVis(refseeds,R_FADCorr_Delta_mouse, Rs_FADCorr_Delta_mouse,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
    % close all
end
%% Delta
%% awake
excelRows = [181 183 185 228 232 236];
BilatFC_jrgeco1aCorr_Delta_awake = zeros(6,7); 
BilatFC_FADCorr_Delta_awake      = zeros(6,7);
BilatFC_total_Delta_awake        = zeros(6,7);
mouseInd = 1;
for excelRow = excelRows

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');    
    load(fullfile(saveDir, processedName_mouse),'Rs_jrgeco1aCorr_Delta_mouse',...
        'Rs_FADCorr_Delta_mouse','Rs_total_Delta_mouse')
    
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,1) = atanh(Rs_jrgeco1aCorr_Delta_mouse(2,10));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,2) = atanh(Rs_jrgeco1aCorr_Delta_mouse(3,11));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,3) = atanh(Rs_jrgeco1aCorr_Delta_mouse(4,12));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,4) = atanh(Rs_jrgeco1aCorr_Delta_mouse(5,13));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,5) = atanh(Rs_jrgeco1aCorr_Delta_mouse(6,14));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,6) = atanh(Rs_jrgeco1aCorr_Delta_mouse(7,15));
    BilatFC_jrgeco1aCorr_Delta_awake(mouseInd,7) = atanh(Rs_jrgeco1aCorr_Delta_mouse(4,3));

    BilatFC_FADCorr_Delta_awake(mouseInd,1) = atanh(Rs_FADCorr_Delta_mouse(2,10));
    BilatFC_FADCorr_Delta_awake(mouseInd,2) = atanh(Rs_FADCorr_Delta_mouse(3,11));
    BilatFC_FADCorr_Delta_awake(mouseInd,3) = atanh(Rs_FADCorr_Delta_mouse(4,12));
    BilatFC_FADCorr_Delta_awake(mouseInd,4) = atanh(Rs_FADCorr_Delta_mouse(5,13));
    BilatFC_FADCorr_Delta_awake(mouseInd,5) = atanh(Rs_FADCorr_Delta_mouse(6,14));
    BilatFC_FADCorr_Delta_awake(mouseInd,6) = atanh(Rs_FADCorr_Delta_mouse(7,15));
    BilatFC_FADCorr_Delta_awake(mouseInd,7) = atanh(Rs_FADCorr_Delta_mouse(4,3));
    
    BilatFC_total_Delta_awake(mouseInd,1) = atanh(Rs_total_Delta_mouse(2,10));
    BilatFC_total_Delta_awake(mouseInd,2) = atanh(Rs_total_Delta_mouse(3,11));
    BilatFC_total_Delta_awake(mouseInd,3) = atanh(Rs_total_Delta_mouse(4,12));
    BilatFC_total_Delta_awake(mouseInd,4) = atanh(Rs_total_Delta_mouse(5,13));
    BilatFC_total_Delta_awake(mouseInd,5) = atanh(Rs_total_Delta_mouse(6,14));
    BilatFC_total_Delta_awake(mouseInd,6) = atanh(Rs_total_Delta_mouse(7,15));
    BilatFC_total_Delta_awake(mouseInd,7) = atanh(Rs_total_Delta_mouse(4,3));

    mouseInd = mouseInd+1;
end

%% Anesthetized
excelRows = [202 195 204 230 234 240];
BilatFC_jrgeco1aCorr_Delta_anes = zeros(6,7); 
BilatFC_FADCorr_Delta_anes      = zeros(6,7);
BilatFC_total_Delta_anes        = zeros(6,7);
mouseInd = 1;
for excelRow = excelRows

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');    
    load(fullfile(saveDir, processedName_mouse),'Rs_jrgeco1aCorr_Delta_mouse',...
        'Rs_FADCorr_Delta_mouse','Rs_total_Delta_mouse')
    
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,1) = atanh(Rs_jrgeco1aCorr_Delta_mouse(2,10));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,2) = atanh(Rs_jrgeco1aCorr_Delta_mouse(3,11));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,3) = atanh(Rs_jrgeco1aCorr_Delta_mouse(4,12));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,4) = atanh(Rs_jrgeco1aCorr_Delta_mouse(5,13));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,5) = atanh(Rs_jrgeco1aCorr_Delta_mouse(6,14));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,6) = atanh(Rs_jrgeco1aCorr_Delta_mouse(7,15));
    BilatFC_jrgeco1aCorr_Delta_anes(mouseInd,7) = atanh(Rs_jrgeco1aCorr_Delta_mouse(4,3));

    BilatFC_FADCorr_Delta_anes(mouseInd,1) = atanh(Rs_FADCorr_Delta_mouse(2,10));
    BilatFC_FADCorr_Delta_anes(mouseInd,2) = atanh(Rs_FADCorr_Delta_mouse(3,11));
    BilatFC_FADCorr_Delta_anes(mouseInd,3) = atanh(Rs_FADCorr_Delta_mouse(4,12));
    BilatFC_FADCorr_Delta_anes(mouseInd,4) = atanh(Rs_FADCorr_Delta_mouse(5,13));
    BilatFC_FADCorr_Delta_anes(mouseInd,5) = atanh(Rs_FADCorr_Delta_mouse(6,14));
    BilatFC_FADCorr_Delta_anes(mouseInd,6) = atanh(Rs_FADCorr_Delta_mouse(7,15));
    BilatFC_FADCorr_Delta_anes(mouseInd,7) = atanh(Rs_FADCorr_Delta_mouse(4,3));
    
    BilatFC_total_Delta_anes(mouseInd,1) = atanh(Rs_total_Delta_mouse(2,10));
    BilatFC_total_Delta_anes(mouseInd,2) = atanh(Rs_total_Delta_mouse(3,11));
    BilatFC_total_Delta_anes(mouseInd,3) = atanh(Rs_total_Delta_mouse(4,12));
    BilatFC_total_Delta_anes(mouseInd,4) = atanh(Rs_total_Delta_mouse(5,13));
    BilatFC_total_Delta_anes(mouseInd,5) = atanh(Rs_total_Delta_mouse(6,14));
    BilatFC_total_Delta_anes(mouseInd,6) = atanh(Rs_total_Delta_mouse(7,15));
    BilatFC_total_Delta_anes(mouseInd,7) = atanh(Rs_total_Delta_mouse(4,3));

    mouseInd = mouseInd+1;
end



%% jRGECO1a Delta Awake vs Anesthetized
model_series = [mean(BilatFC_jrgeco1aCorr_Delta_awake(:,1)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,1));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,2)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,2));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,3)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,3));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,4)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,4));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,5)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,5));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,6)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,6));
    mean(BilatFC_jrgeco1aCorr_Delta_awake(:,7)),mean(BilatFC_jrgeco1aCorr_Delta_anes(:,7))];

model_error = [std(BilatFC_jrgeco1aCorr_Delta_awake(:,1)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,1));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,2)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,2));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,3)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,3));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,4)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,4));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,5)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,5));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,6)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,6));
    std(BilatFC_jrgeco1aCorr_Delta_awake(:,7)),std(BilatFC_jrgeco1aCorr_Delta_anes(:,7))];

h_jrgeco1aCorr_Delta_AwakevsAnes = zeros(1,7);
p_jrgeco1aCorr_Delta_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_jrgeco1aCorr_Delta_AwakevsAnes(ii),p_jrgeco1aCorr_Delta_AwakevsAnes(ii)] = ttest2(BilatFC_jrgeco1aCorr_Delta_awake(:,ii),BilatFC_jrgeco1aCorr_Delta_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('jRGECO1a, Delta')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_jrgeco1aCorr_Delta_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})

%% FAD Delta Awake vs Anesthetized
model_series = [mean(BilatFC_FADCorr_Delta_awake(:,1)),mean(BilatFC_FADCorr_Delta_anes(:,1));
    mean(BilatFC_FADCorr_Delta_awake(:,2)),mean(BilatFC_FADCorr_Delta_anes(:,2));
    mean(BilatFC_FADCorr_Delta_awake(:,3)),mean(BilatFC_FADCorr_Delta_anes(:,3));
    mean(BilatFC_FADCorr_Delta_awake(:,4)),mean(BilatFC_FADCorr_Delta_anes(:,4));
    mean(BilatFC_FADCorr_Delta_awake(:,5)),mean(BilatFC_FADCorr_Delta_anes(:,5));
    mean(BilatFC_FADCorr_Delta_awake(:,6)),mean(BilatFC_FADCorr_Delta_anes(:,6));
    mean(BilatFC_FADCorr_Delta_awake(:,7)),mean(BilatFC_FADCorr_Delta_anes(:,7))];

model_error = [std(BilatFC_FADCorr_Delta_awake(:,1)),std(BilatFC_FADCorr_Delta_anes(:,1));
    std(BilatFC_FADCorr_Delta_awake(:,2)),std(BilatFC_FADCorr_Delta_anes(:,2));
    std(BilatFC_FADCorr_Delta_awake(:,3)),std(BilatFC_FADCorr_Delta_anes(:,3));
    std(BilatFC_FADCorr_Delta_awake(:,4)),std(BilatFC_FADCorr_Delta_anes(:,4));
    std(BilatFC_FADCorr_Delta_awake(:,5)),std(BilatFC_FADCorr_Delta_anes(:,5));
    std(BilatFC_FADCorr_Delta_awake(:,6)),std(BilatFC_FADCorr_Delta_anes(:,6));
    std(BilatFC_FADCorr_Delta_awake(:,7)),std(BilatFC_FADCorr_Delta_anes(:,7))];

h_FADCorr_Delta_AwakevsAnes = zeros(1,7);
p_FADCorr_Delta_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_FADCorr_Delta_AwakevsAnes(ii),p_FADCorr_Delta_AwakevsAnes(ii)] = ttest2(BilatFC_FADCorr_Delta_awake(:,ii),BilatFC_FADCorr_Delta_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('FAD, Delta')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_FADCorr_Delta_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})
%% HbT Delta Awake vs Anesthetized
model_series = [mean(BilatFC_total_Delta_awake(:,1)),mean(BilatFC_total_Delta_anes(:,1));
    mean(BilatFC_total_Delta_awake(:,2)),mean(BilatFC_total_Delta_anes(:,2));
    mean(BilatFC_total_Delta_awake(:,3)),mean(BilatFC_total_Delta_anes(:,3));
    mean(BilatFC_total_Delta_awake(:,4)),mean(BilatFC_total_Delta_anes(:,4));
    mean(BilatFC_total_Delta_awake(:,5)),mean(BilatFC_total_Delta_anes(:,5));
    mean(BilatFC_total_Delta_awake(:,6)),mean(BilatFC_total_Delta_anes(:,6));
    mean(BilatFC_total_Delta_awake(:,7)),mean(BilatFC_total_Delta_anes(:,7))];

model_error = [std(BilatFC_total_Delta_awake(:,1)),std(BilatFC_total_Delta_anes(:,1));
    std(BilatFC_total_Delta_awake(:,2)),std(BilatFC_total_Delta_anes(:,2));
    std(BilatFC_total_Delta_awake(:,3)),std(BilatFC_total_Delta_anes(:,3));
    std(BilatFC_total_Delta_awake(:,4)),std(BilatFC_total_Delta_anes(:,4));
    std(BilatFC_total_Delta_awake(:,5)),std(BilatFC_total_Delta_anes(:,5));
    std(BilatFC_total_Delta_awake(:,6)),std(BilatFC_total_Delta_anes(:,6));
    std(BilatFC_total_Delta_awake(:,7)),std(BilatFC_total_Delta_anes(:,7))];

h_total_Delta_AwakevsAnes = zeros(1,7);
p_total_Delta_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_total_Delta_AwakevsAnes(ii),p_total_Delta_AwakevsAnes(ii)] = ttest2(BilatFC_total_Delta_awake(:,ii),BilatFC_total_Delta_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('HbT, Delta')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_total_Delta_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})

%% ISA
%% awake
excelRows = [181 183 185 228 232 236];
BilatFC_jrgeco1aCorr_ISA_awake = zeros(6,7); 
BilatFC_FADCorr_ISA_awake      = zeros(6,7);
BilatFC_total_ISA_awake        = zeros(6,7);
mouseInd = 1;
for excelRow = excelRows

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');    
    load(fullfile(saveDir, processedName_mouse),'Rs_jrgeco1aCorr_ISA_mouse',...
        'Rs_FADCorr_ISA_mouse','Rs_total_ISA_mouse')
    
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,1) = atanh(Rs_jrgeco1aCorr_ISA_mouse(2,10));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,2) = atanh(Rs_jrgeco1aCorr_ISA_mouse(3,11));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,3) = atanh(Rs_jrgeco1aCorr_ISA_mouse(4,12));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,4) = atanh(Rs_jrgeco1aCorr_ISA_mouse(5,13));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,5) = atanh(Rs_jrgeco1aCorr_ISA_mouse(6,14));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,6) = atanh(Rs_jrgeco1aCorr_ISA_mouse(7,15));
    BilatFC_jrgeco1aCorr_ISA_awake(mouseInd,7) = atanh(Rs_jrgeco1aCorr_ISA_mouse(4,3));

    BilatFC_FADCorr_ISA_awake(mouseInd,1) = atanh(Rs_FADCorr_ISA_mouse(2,10));
    BilatFC_FADCorr_ISA_awake(mouseInd,2) = atanh(Rs_FADCorr_ISA_mouse(3,11));
    BilatFC_FADCorr_ISA_awake(mouseInd,3) = atanh(Rs_FADCorr_ISA_mouse(4,12));
    BilatFC_FADCorr_ISA_awake(mouseInd,4) = atanh(Rs_FADCorr_ISA_mouse(5,13));
    BilatFC_FADCorr_ISA_awake(mouseInd,5) = atanh(Rs_FADCorr_ISA_mouse(6,14));
    BilatFC_FADCorr_ISA_awake(mouseInd,6) = atanh(Rs_FADCorr_ISA_mouse(7,15));
    BilatFC_FADCorr_ISA_awake(mouseInd,7) = atanh(Rs_FADCorr_ISA_mouse(4,3));
    
    BilatFC_total_ISA_awake(mouseInd,1) = atanh(Rs_total_ISA_mouse(2,10));
    BilatFC_total_ISA_awake(mouseInd,2) = atanh(Rs_total_ISA_mouse(3,11));
    BilatFC_total_ISA_awake(mouseInd,3) = atanh(Rs_total_ISA_mouse(4,12));
    BilatFC_total_ISA_awake(mouseInd,4) = atanh(Rs_total_ISA_mouse(5,13));
    BilatFC_total_ISA_awake(mouseInd,5) = atanh(Rs_total_ISA_mouse(6,14));
    BilatFC_total_ISA_awake(mouseInd,6) = atanh(Rs_total_ISA_mouse(7,15));
    BilatFC_total_ISA_awake(mouseInd,7) = atanh(Rs_total_ISA_mouse(4,3));

    mouseInd = mouseInd+1;
end

%% Anesthetized
excelRows = [202 195 204 230 234 240];
BilatFC_jrgeco1aCorr_ISA_anes = zeros(6,7); 
BilatFC_FADCorr_ISA_anes      = zeros(6,7);
BilatFC_total_ISA_anes        = zeros(6,7);
mouseInd = 1;
for excelRow = excelRows

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');    
    load(fullfile(saveDir, processedName_mouse),'Rs_jrgeco1aCorr_ISA_mouse',...
        'Rs_FADCorr_ISA_mouse','Rs_total_ISA_mouse')
    
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,1) = atanh(Rs_jrgeco1aCorr_ISA_mouse(2,10));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,2) = atanh(Rs_jrgeco1aCorr_ISA_mouse(3,11));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,3) = atanh(Rs_jrgeco1aCorr_ISA_mouse(4,12));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,4) = atanh(Rs_jrgeco1aCorr_ISA_mouse(5,13));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,5) = atanh(Rs_jrgeco1aCorr_ISA_mouse(6,14));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,6) = atanh(Rs_jrgeco1aCorr_ISA_mouse(7,15));
    BilatFC_jrgeco1aCorr_ISA_anes(mouseInd,7) = atanh(Rs_jrgeco1aCorr_ISA_mouse(4,3));

    BilatFC_FADCorr_ISA_anes(mouseInd,1) = atanh(Rs_FADCorr_ISA_mouse(2,10));
    BilatFC_FADCorr_ISA_anes(mouseInd,2) = atanh(Rs_FADCorr_ISA_mouse(3,11));
    BilatFC_FADCorr_ISA_anes(mouseInd,3) = atanh(Rs_FADCorr_ISA_mouse(4,12));
    BilatFC_FADCorr_ISA_anes(mouseInd,4) = atanh(Rs_FADCorr_ISA_mouse(5,13));
    BilatFC_FADCorr_ISA_anes(mouseInd,5) = atanh(Rs_FADCorr_ISA_mouse(6,14));
    BilatFC_FADCorr_ISA_anes(mouseInd,6) = atanh(Rs_FADCorr_ISA_mouse(7,15));
    BilatFC_FADCorr_ISA_anes(mouseInd,7) = atanh(Rs_FADCorr_ISA_mouse(4,3));
    
    BilatFC_total_ISA_anes(mouseInd,1) = atanh(Rs_total_ISA_mouse(2,10));
    BilatFC_total_ISA_anes(mouseInd,2) = atanh(Rs_total_ISA_mouse(3,11));
    BilatFC_total_ISA_anes(mouseInd,3) = atanh(Rs_total_ISA_mouse(4,12));
    BilatFC_total_ISA_anes(mouseInd,4) = atanh(Rs_total_ISA_mouse(5,13));
    BilatFC_total_ISA_anes(mouseInd,5) = atanh(Rs_total_ISA_mouse(6,14));
    BilatFC_total_ISA_anes(mouseInd,6) = atanh(Rs_total_ISA_mouse(7,15));
    BilatFC_total_ISA_anes(mouseInd,7) = atanh(Rs_total_ISA_mouse(4,3));

    mouseInd = mouseInd+1;
end



%% jRGECO1a ISA Awake vs Anesthetized
model_series = [mean(BilatFC_jrgeco1aCorr_ISA_awake(:,1)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,1));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,2)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,2));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,3)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,3));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,4)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,4));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,5)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,5));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,6)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,6));
    mean(BilatFC_jrgeco1aCorr_ISA_awake(:,7)),mean(BilatFC_jrgeco1aCorr_ISA_anes(:,7))];

model_error = [std(BilatFC_jrgeco1aCorr_ISA_awake(:,1)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,1));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,2)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,2));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,3)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,3));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,4)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,4));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,5)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,5));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,6)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,6));
    std(BilatFC_jrgeco1aCorr_ISA_awake(:,7)),std(BilatFC_jrgeco1aCorr_ISA_anes(:,7))];

h_jrgeco1aCorr_ISA_AwakevsAnes = zeros(1,7);
p_jrgeco1aCorr_ISA_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_jrgeco1aCorr_ISA_AwakevsAnes(ii),p_jrgeco1aCorr_ISA_AwakevsAnes(ii)] = ttest2(BilatFC_jrgeco1aCorr_ISA_awake(:,ii),BilatFC_jrgeco1aCorr_ISA_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('jRGECO1a, ISA')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_jrgeco1aCorr_ISA_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})

%% FAD ISA Awake vs Anesthetized
model_series = [mean(BilatFC_FADCorr_ISA_awake(:,1)),mean(BilatFC_FADCorr_ISA_anes(:,1));
    mean(BilatFC_FADCorr_ISA_awake(:,2)),mean(BilatFC_FADCorr_ISA_anes(:,2));
    mean(BilatFC_FADCorr_ISA_awake(:,3)),mean(BilatFC_FADCorr_ISA_anes(:,3));
    mean(BilatFC_FADCorr_ISA_awake(:,4)),mean(BilatFC_FADCorr_ISA_anes(:,4));
    mean(BilatFC_FADCorr_ISA_awake(:,5)),mean(BilatFC_FADCorr_ISA_anes(:,5));
    mean(BilatFC_FADCorr_ISA_awake(:,6)),mean(BilatFC_FADCorr_ISA_anes(:,6));
    mean(BilatFC_FADCorr_ISA_awake(:,7)),mean(BilatFC_FADCorr_ISA_anes(:,7))];

model_error = [std(BilatFC_FADCorr_ISA_awake(:,1)),std(BilatFC_FADCorr_ISA_anes(:,1));
    std(BilatFC_FADCorr_ISA_awake(:,2)),std(BilatFC_FADCorr_ISA_anes(:,2));
    std(BilatFC_FADCorr_ISA_awake(:,3)),std(BilatFC_FADCorr_ISA_anes(:,3));
    std(BilatFC_FADCorr_ISA_awake(:,4)),std(BilatFC_FADCorr_ISA_anes(:,4));
    std(BilatFC_FADCorr_ISA_awake(:,5)),std(BilatFC_FADCorr_ISA_anes(:,5));
    std(BilatFC_FADCorr_ISA_awake(:,6)),std(BilatFC_FADCorr_ISA_anes(:,6));
    std(BilatFC_FADCorr_ISA_awake(:,7)),std(BilatFC_FADCorr_ISA_anes(:,7))];

h_FADCorr_ISA_AwakevsAnes = zeros(1,7);
p_FADCorr_ISA_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_FADCorr_ISA_AwakevsAnes(ii),p_FADCorr_ISA_AwakevsAnes(ii)] = ttest2(BilatFC_FADCorr_ISA_awake(:,ii),BilatFC_FADCorr_ISA_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('FAD, ISA')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_FADCorr_ISA_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})
%% HbT ISA Awake vs Anesthetized
model_series = [mean(BilatFC_total_ISA_awake(:,1)),mean(BilatFC_total_ISA_anes(:,1));
    mean(BilatFC_total_ISA_awake(:,2)),mean(BilatFC_total_ISA_anes(:,2));
    mean(BilatFC_total_ISA_awake(:,3)),mean(BilatFC_total_ISA_anes(:,3));
    mean(BilatFC_total_ISA_awake(:,4)),mean(BilatFC_total_ISA_anes(:,4));
    mean(BilatFC_total_ISA_awake(:,5)),mean(BilatFC_total_ISA_anes(:,5));
    mean(BilatFC_total_ISA_awake(:,6)),mean(BilatFC_total_ISA_anes(:,6));
    mean(BilatFC_total_ISA_awake(:,7)),mean(BilatFC_total_ISA_anes(:,7))];

model_error = [std(BilatFC_total_ISA_awake(:,1)),std(BilatFC_total_ISA_anes(:,1));
    std(BilatFC_total_ISA_awake(:,2)),std(BilatFC_total_ISA_anes(:,2));
    std(BilatFC_total_ISA_awake(:,3)),std(BilatFC_total_ISA_anes(:,3));
    std(BilatFC_total_ISA_awake(:,4)),std(BilatFC_total_ISA_anes(:,4));
    std(BilatFC_total_ISA_awake(:,5)),std(BilatFC_total_ISA_anes(:,5));
    std(BilatFC_total_ISA_awake(:,6)),std(BilatFC_total_ISA_anes(:,6));
    std(BilatFC_total_ISA_awake(:,7)),std(BilatFC_total_ISA_anes(:,7))];

h_total_ISA_AwakevsAnes = zeros(1,7);
p_total_ISA_AwakevsAnes = zeros(1,7);
for ii = 1:7
    [h_total_ISA_AwakevsAnes(ii),p_total_ISA_AwakevsAnes(ii)] = ttest2(BilatFC_total_ISA_awake(:,ii),BilatFC_total_ISA_anes(:,ii));
end


% Visualization
pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';

hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,2),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 4])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('HbT, ISA')

for ii =1:7
    sigstar({[x(1,ii),x(2,ii)]},p_total_ISA_AwakevsAnes(ii),0,1)
end
legend({'Awake','Anesthetized'})