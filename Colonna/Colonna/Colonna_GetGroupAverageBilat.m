database='C:\Users\Adam\Box\Colonna data SOS\ColonnaGCAMPtest.xlsx';
excelfiles=[2:24,26:27];  % Rows from Excell Database

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    directory=['C:\Users\Adam\Box\Colonna data SOS\AvgBilat\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=[Date,'-',Mouse,'-AvgBilat.mat'];
    
    load(file);
    
    %tempISAfc=eval([Mouse,'_MeanISAMap']);
    tempDeltafc=eval([Mouse,'_MeanDeltaBilatMap']);
        
    if strcmp(Group,'TREMWT')
        a=a+1;
        %TremWT_ISA_Bilat(:,:,:,a)=tempISAfc;
        TremWT_Delta_Bilat(:,:,:,a)=tempDeltafc;
        
    elseif strcmp(Group,'TREMHET')
        b=b+1;
       % TremHet_ISA_Bilat(:,:,:,b)=tempISAfc;
        TremHet_Delta_Bilat(:,:,:,b)=tempDeltafc;
        
    elseif strcmp(Group,'TREMKO')
        c=c+1;
        %TremKO_ISA_Bilat(:,:,:,c)=tempISAfc;
        TremKO_Delta_Bilat(:,:,:,c)=tempDeltafc;
        
    elseif strcmp(Group,'TREMWT5XFAD')
        d=d+1;
        %TremWT5XFAD_ISA_Bilat(:,:,:,d)=tempISAfc;
        TremWT5XFAD_Delta_Bilat(:,:,:,d)=tempDeltafc;
        
    elseif strcmp(Group,'TREMHET5XFAD')
        e=e+1;
        %TremHet5XFAD_ISA_Bilat(:,:,:,e)=tempISAfc;
        TremHet5XFAD_Delta_Bilat(:,:,:,e)=tempDeltafc;
        
    elseif strcmp(Group,'TREMKO5XFAD')
        f=f+1;
        %TremKO5XFAD_ISA_Bilat(:,:,:,f)=tempISAfc;
        TremKO5XFAD_Delta_Bilat(:,:,:,f)=tempDeltafc;
        
    end
    clear([Mouse,'_MeanDeltaBilatMap'])
    clear tempISAR tempISAfc tempDeltaR tempDeltafc
    
end

Names=whos;
for n=1:size(Names,1)
    if numel(Names(n).size)==4
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),4);
        eval([newname '=temp;'])
        clear newname temp
    end
end

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles


