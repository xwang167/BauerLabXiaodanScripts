function makemask()%qc)

            qc=struct('Date',{'180102','180102'},...
          'MouseDay', {'a','a'},...
          'MouseNum', {'180102-Mouse1','180102-Mouse3'},...
          'Runs', {[1:6]});   

for i=1:length(qc)
    
    date=qc(i).Date;
    mousenum=qc(i).MouseNum;
    %msd=qc(i).ms;

fcrun=['Z:\Rachel\Rachel_fcOIS\OIS3\' date '\' date '-' mousenum '-stim1.mat'];
    %greenframe=double(imread([fcrun,'.tif'],6));
    %greenframe=double(fcrun,6);
    load(fcrun);
    greenframe=rawdata(:,:,6);
    greenframeall(:,:,1)=greenframe./max(greenframe(:));
    greenframeall(:,:,2)=greenframe./max(greenframe(:));
    greenframeall(:,:,3)=greenframe./max(greenframe(:));

%greenframe=imread(['/data/culver/data1/Lindsey/data/Anesthesia/',date,'/',msd,'/',run,'.tif'],6);
mask=double(roipoly(greenframeall));
imwrite(mask,['Z:\Rachel\Rachel_fcOIS\OIS3\' date '\' date '-' mousenum '_mask.tif'],'tif');

end
