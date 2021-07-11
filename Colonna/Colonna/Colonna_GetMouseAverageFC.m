database='C:\Users\Adam\Box\Colonna data SOS\ColonnaGCAMPtest.xlsx';
%excelfiles=[2];  % Rows from Excell Database
excelfiles=[8,10];  % Rows from Excell Database

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    directory=['C:\Users\Adam\Box\Colonna data SOS\AvgFC\'];
%         
    if ~exist(directory)
        mkdir(directory);
    end
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    
    if ~isnan(raw{7})
        if ischar(raw{7})
            Runs=str2num(char(raw{7}));
        else
            Runs=raw{7};
        end
    end
    
    tempISAMatrix=[];
    tempISAMap=[];
    tempDeltaMatrix=[];
    tempDeltaMap=[];
    
    for m=Runs
        load([Date,'-', Mouse,'-fc',num2str(m),'-seedFC-0p009-0p08.mat'], 'seedFC', 'seedFCMap');
        tempISAMatrix=cat(4,tempISAMatrix,atanh(seedFC));
        temp=seedFCMap;
        seedFCMap2=zeros(128,128,16,4);
        for ii=1:4
            seedFCMap2(:,:,:,ii)=cell2mat(seedFCMap(1,ii));
        end
        tempISAMap=cat(5,tempISAMap, atanh(seedFCMap2));
        
        clear seedFC seedFCMap
        
        load([Date,'-', Mouse,'-fc',num2str(m),'-seedFC-0p4-4.mat'], 'seedFC', 'seedFCMap');
        tempDeltaMatrix=cat(4,tempDeltaMatrix,atanh(seedFC));
        temp=seedFCMap;
        seedFCMap2=zeros(128,128,16,4);
        for ii=1:4
            seedFCMap2(:,:,:,ii)=cell2mat(seedFCMap(1,ii));
        end
        tempDeltaMap=cat(5,tempDeltaMap, atanh(seedFCMap2));
        
        clear seedFC seedFCMap

    end
    
    MeanISAMatrix=mean(tempISAMatrix,4);
    MeanISAMap=mean(tempISAMap,5);
    MeanDeltaMatrix=mean(tempDeltaMatrix,4);
    MeanDeltaMap=mean(tempDeltaMap,5);
    
    u = genvarname([Mouse,'_MeanISAMatrix']);
    v = genvarname([Mouse,'_MeanISAMap']);
    w = genvarname([Mouse,'_MeanDeltaMatrix']);
    x = genvarname([Mouse,'_MeanDeltaMap']);
    
    eval([u '=MeanISAMatrix;']);
    eval([v '=MeanISAMap;']);
    eval([w '=MeanDeltaMatrix;']);
    eval([x '=MeanDeltaMap;']);    
    
    save([directory, Date, '-', Mouse, '-AvgFC.mat'],[Mouse,'_MeanISAMatrix'],[Mouse,'_MeanISAMap'],[Mouse,'_MeanDeltaMatrix'],[Mouse,'_MeanDeltaMap'])
    clearvars -except database excelfiles n
end






