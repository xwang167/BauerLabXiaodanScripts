database='D:\Bice\Imaging Datasheets\Marco_Colonna.xlsx';
excelfiles=[16:43];  % Rows from Excell Database

%load('G:\OISProjects\Musiek\BmalKOvsWTMapsandMatrices_180202.mat', 'symisbrainall')
%load('D:\ProcessedData\Marco_Colonna\Group Average Functional Connectivity Maps and Matrices_181109.mat', 'symisbrainall')
% load('C:\Users\Fats Waller\Desktop\Colonna Updated\Group Average Functional Connectivity Maps and Matrices_181210', 'symisbrainall')
%load('C:\Users\Fats Waller\Desktop\Colonna Updated\190109 Updated Excel files 16 to 38\190109-Group Average Functional Connectivity Maps and Matrices.mat', 'symisbrainall')
load('D:\ProcessedData\Colonna Data Processed 190416\GroupAverageMatrices.mat', 'symisbrainall')


[SeedsUsed]=CalcRasterSeedsUsed(symisbrainall);

type='Whole';

idx=find(symisbrainall);
for n=1:size(idx,1); 
    [I,J]=ind2sub([128,128], idx(n)); 
    SeedsfromIdx(n,:)=[J,I];
end

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    
    if exist([directory, Date,'-', Mouse,'-fc-cat.mat'])
        
        tic
        disp('Loading Full Pixel-Pixel Correlation Matrix')
        load([Date,'-',Mouse, '-fc-cat.mat'], ['MeanR_AllPix_',Mouse, '_',type]);                
        tempfc=eval(['MeanR_AllPix_',Mouse, '_',type]);
        
        disp('Calculating Node Degree for Postive Correlations')
        
        BinMap=zeros(size(tempfc));
        BinMap(tempfc>0.4)=1;
        WeiMap=zeros(size(tempfc));
        idx=find(tempfc>0.4);
        WeiMap(idx)=tempfc(idx);
        NDbin=sum(BinMap);
        NDwei=sum(WeiMap);
        NDim=zeros(128,128,2);
        
        for hh=1:size(tempfc,1);
            NDim(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),1)=NDbin(hh);
            NDim(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),2)=NDwei(hh);
        end
        
        w = genvarname(['NodeDeg_',Mouse]);
        eval([w '=NDim;']);
        
        save([directory,Date,'-',Mouse,'-fc-cat.mat'], ['NodeDeg_',Mouse],'-append');
        
        disp('Calculating Ipsilateral Node Degree for Postive Correlations')

        NDimIpsi=zeros(128,128,2);
        NDBinIpsiR=sum(BinMap(1:size(tempfc)/2,1:size(tempfc)/2));          %First quadrant, Right Seeds with Right Connections
        NDBinIpsiL=sum(BinMap(size(tempfc)/2+1:end,size(tempfc)/2+1:end));  %Fourth quadrant, Left Seeds with Left Connections
        NDWeiIpsiR=sum(WeiMap(1:size(tempfc)/2,1:size(tempfc)/2));          %First quadrant, Right Seeds with Right Connections
        NDWeiIpsiL=sum(WeiMap(size(tempfc)/2+1:end,size(tempfc)/2+1:end));  %Fourth quadrant, Left Seeds with Left Connections
        
        for hh=1:size(tempfc,1)/2;
            NDimIpsi(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),1)=NDBinIpsiR(hh);
            NDimIpsi(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),2)=NDWeiIpsiR(hh);
        end
        
        for hh=size(tempfc,1)/2+1:size(tempfc,1);
            NDimIpsi(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),1)=NDBinIpsiL(hh-size(tempfc,1)/2);
            NDimIpsi(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),2)=NDWeiIpsiL(hh-size(tempfc,1)/2);
        end
        
        w = genvarname(['NDimIpsi_',Mouse]);
        eval([w '=NDimIpsi;']);
        save([directory,Date,'-',Mouse,'-fc-cat.mat'],['NDimIpsi_',Mouse], '-append');
        
        disp('Calculating Contralateral Node Degree for Postive Correlations')

        NDimContra=zeros(128,128,2);
        NDBinContraR=sum(BinMap(size(tempfc)/2+1:end,1:size(tempfc)/2));    %Third quadrant, Right Seeds with Left Connections
        NDBinContraL=sum(BinMap(1:size(tempfc)/2,size(tempfc)/2+1:end));    %Second quadrant, Left Seeds with Right Connections
        NDWeiContraR=sum(WeiMap(size(tempfc)/2+1:end,1:size(tempfc)/2));    %Third quadrant, Right Seeds with Left Connections
        NDWeiContraL=sum(WeiMap(1:size(tempfc)/2,size(tempfc)/2+1:end));    %Second quadrant, Left Seeds with Right Connections
        
        for hh=1:size(tempfc,1)/2;
            NDimContra(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),1)=NDBinContraR(hh);
            NDimContra(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),2)=NDWeiContraR(hh);
        end
        
        for hh=size(tempfc,1)/2+1:size(tempfc,1);
            NDimContra(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),1)=NDBinContraL(hh-size(tempfc,1)/2);
            NDimContra(SeedsfromIdx(hh,2),SeedsfromIdx(hh,1),2)=NDWeiContraL(hh-size(tempfc,1)/2);
        end
        
        w = genvarname(['NDimContra_',Mouse]);
        eval([w '=NDimContra;']);
        save([directory,Date,'-',Mouse,'-fc-cat.mat'],['NDimContra_',Mouse],'-append');
        toc
     end
    
    clearvars -except SeedsUsed symisbrainall NewSeedsUsed database excelfiles type SeedsfromIdx
end