database='G:\OISProjects\CulverLab\Stroke\OptoStroke.xlsx';
type='Whole';
excelfiles=[154:182];  % Rows from Excell Database
thresh=0.4;

load('G:\OISProjects\CulverLab\Stroke\ControlSymisbrainall.mat', 'symisbrainall');

idx=find(symisbrainall==1);
[Y,X]=ind2sub([128,128], idx);

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
        
        disp('Calculating Global Node Degree for Postive Correlations')
        
        BinMap=zeros(size(tempfc));
        BinMap(tempfc>thresh)=1;
        WeiMap=zeros(size(tempfc));
        idx=find(tempfc>thresh);
        WeiMap(idx)=tempfc(idx);
        NDbin=sum(BinMap);
        NDwei=sum(WeiMap);
        NDim=zeros(128,128,2);
        
        for hh=1:size(tempfc,1);
            NDim(Y(hh),X(hh),1)=NDbin(hh);
            NDim(Y(hh),X(hh),2)=NDwei(hh);
        end
        
        w = genvarname(['NDimAll_',Mouse]);
        eval([w '=NDim;']);
        
        save([directory,Date,'-',Mouse,'-fc-cat.mat'], ['NDimAll_',Mouse],'-append');
        
        disp('Calculating Ipsilateral Node Degree for Postive Correlations')
        
        NDimIpsi=zeros(128,128,2);
        NDBinIpsiL=sum(BinMap(1:size(tempfc)/2,1:size(tempfc)/2));          %First quadrant, Left Seeds with Left Connections
        NDBinIpsiR=sum(BinMap(size(tempfc)/2+1:end,size(tempfc)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
        NDWeiIpsiL=sum(WeiMap(1:size(tempfc)/2,1:size(tempfc)/2));          %First quadrant, Left Seeds with Left Connections
        NDWeiIpsiR=sum(WeiMap(size(tempfc)/2+1:end,size(tempfc)/2+1:end));  %Fourth quadrant, Right Seeds with Right Connections
        
        for hh=1:size(tempfc,1)/2
            NDimIpsi(Y(hh),X(hh),1)=NDBinIpsiL(hh);
            NDimIpsi(Y(hh),X(hh),2)=NDWeiIpsiL(hh);
        end
        
        for hh=size(tempfc,1)/2+1:size(tempfc,1)
            NDimIpsi(Y(hh),X(hh),1)=NDBinIpsiR(hh-size(tempfc,1)/2);
            NDimIpsi(Y(hh),X(hh),2)=NDWeiIpsiR(hh-size(tempfc,1)/2);
        end
        
        w = genvarname(['NDimIpsi_',Mouse]);
        eval([w '=NDimIpsi;']);
        save([directory,Date,'-',Mouse,'-fc-cat.mat'],['NDimIpsi_',Mouse], '-append');
        
        disp('Calculating Contralateral Node Degree for Postive Correlations')
        
        NDimContra=zeros(128,128,2);
        NDBinContraL=sum(BinMap(size(tempfc)/2+1:end,1:size(tempfc)/2));    %Third quadrant, Left Seeds with Right Connections
        NDBinContraR=sum(BinMap(1:size(tempfc)/2,size(tempfc)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
        NDWeiContraL=sum(WeiMap(size(tempfc)/2+1:end,1:size(tempfc)/2));    %Third quadrant, Left Seeds with Left Connections
        NDWeiContraR=sum(WeiMap(1:size(tempfc)/2,size(tempfc)/2+1:end));    %Second quadrant, Right Seeds with Left Connections
        
        for hh=1:size(tempfc,1)/2;
            NDimContra(Y(hh),X(hh),1)=NDBinContraL(hh);
            NDimContra(Y(hh),X(hh),2)=NDWeiContraL(hh);
        end
        
        for hh=size(tempfc,1)/2+1:size(tempfc,1);
            NDimContra(Y(hh),X(hh),1)=NDBinContraR(hh-size(tempfc,1)/2);
            NDimContra(Y(hh),X(hh),2)=NDWeiContraR(hh-size(tempfc,1)/2);
        end
        
        w = genvarname(['NDimContra_',Mouse]);
        eval([w '=NDimContra;']);
        save([directory,Date,'-',Mouse,'-fc-cat.mat'],['NDimContra_',Mouse],'-append');
        toc
    end
    
    clearvars -except SeedsUsed symisbrainall NewSeedsUsed database excelfiles type thresh idx Y X
end