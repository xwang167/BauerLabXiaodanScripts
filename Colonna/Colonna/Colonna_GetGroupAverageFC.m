database='C:\Users\Adam\Box\Colonna data SOS\ColonnaGCAMPtest.xlsx';
excelfiles=[2:24,26:27];  % Rows from Excell Database

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

isbrainall=ones(128);

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    directory=['C:\Users\Adam\Box\Colonna data SOS\AvgFC\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=[Date,'-',Mouse,'-AvgFC.mat'];
    
    load(file);
    
    tempISAR=eval([Mouse,'_MeanISAMatrix']);
    tempISAfc=eval([Mouse,'_MeanISAMap']);
    tempDeltaR=eval([Mouse,'_MeanDeltaMatrix']);
    tempDeltafc=eval([Mouse,'_MeanDeltaMap']);
    
    isbrain=zeros(128);
    isbrain(~isnan(squeeze(tempISAfc(:,:,5,1))))=1;
    isbrainall=isbrainall.*single(isbrain);
    
    if strcmp(Group,'TREMWT')
        a=a+1;
        TremWT_ISA_R(:,:,:,a)=tempISAR;
        TremWT_ISA_fcmap(:,:,:,:,a)=tempISAfc;
        TremWT_Delta_R(:,:,:,a)=tempDeltaR;
        TremWT_Delta_fcmap(:,:,:,:,a)=tempDeltafc;
        
    elseif strcmp(Group,'TREMHET')
        b=b+1;
        TremHet_ISA_R(:,:,:,b)=tempISAR;
        TremHet_ISA_fcmap(:,:,:,:,b)=tempISAfc;
        TremHet_Delta_R(:,:,:,b)=tempDeltaR;
        TremHet_Delta_fcmap(:,:,:,:,b)=tempDeltafc;
        
    elseif strcmp(Group,'TREMKO')
        c=c+1;
        TremKO_ISA_R(:,:,:,c)=tempISAR;
        TremKO_ISA_fcmap(:,:,:,:,c)=tempISAfc;
        TremKO_Delta_R(:,:,:,c)=tempDeltaR;
        TremKO_Delta_fcmap(:,:,:,:,c)=tempDeltafc;
        
    elseif strcmp(Group,'TREMWT5XFAD')
        d=d+1;
        TremWT5XFAD_ISA_R(:,:,:,d)=tempISAR;
        TremWT5XFAD_ISA_fcmap(:,:,:,:,d)=tempISAfc;
        TremWT5XFAD_Delta_R(:,:,:,d)=tempDeltaR;
        TremWT5XFAD_Delta_fcmap(:,:,:,:,d)=tempDeltafc;
        
    elseif strcmp(Group,'TREMHET5XFAD')
        e=e+1;
        TremHet5XFAD_ISA_R(:,:,:,e)=tempISAR;
        TremHet5XFAD_ISA_fcmap(:,:,:,:,e)=tempISAfc;
        TremHet5XFAD_Delta_R(:,:,:,e)=tempDeltaR;
        TremHet5XFAD_Delta_fcmap(:,:,:,:,e)=tempDeltafc;
        
    elseif strcmp(Group,'TREMKO5XFAD')
        f=f+1;
        TremKO5XFAD_ISA_R(:,:,:,f)=tempISAR;
        TremKO5XFAD_ISA_fcmap(:,:,:,:,f)=tempISAfc;
        TremKO5XFAD_Delta_R(:,:,:,f)=tempDeltaR;
        TremKO5XFAD_Delta_fcmap(:,:,:,:,f)=tempDeltafc;
        
    end
    clear([Mouse,'_MeanISAMatrix'],[Mouse,'_MeanISAMap'],[Mouse,'_MeanDeltaMatrix'],[Mouse,'_MeanDeltaMap'])
    clear tempISAR tempISAfc tempDeltaR tempDeltafc
    
end

Names=whos;
for n=1:size(Names,1)
    if numel(Names(n).size)==4
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),4);
        eval([newname '=temp;'])
        clear newname temp
        
    elseif numel(Names(n).size)==5
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),5);
        eval([newname '=temp;'])
        clear newname temp
    end    
end

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles


