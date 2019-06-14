function rawdata = getRaw_Zyla(rawdatafolder,nVx,nVy,numTotalFrames,numLED)


disp(strcat('starting get raw from', rawdatafolder));
rawdatafolder = char(rawdatafolder);
camIndex = str2double(rawdatafolder(strfind(rawdatafolder,'cam')+3));
tempdir=dir(rawdatafolder);
tempdir2=tempdir(3:end-3, 1);% exclude . .. and ini modifieddata sifx
framenums=zeros(size(tempdir2, 1), 1);
for i=1:size(tempdir2, 1);
    tempframe=tempdir2(i).name(1:10);
    tempframe=str2double(fliplr(tempframe))+1; % flip num order
    framenums(i)=tempframe;
end
[~, frameidx]=sort(framenums);
tempdir2=tempdir2(frameidx);

fileinfo=inifile(fullfile(rawdatafolder, 'acquisitionmetadata.ini'), 'readall');
xPixels=str2double(cell2mat(fileinfo(1,4)));
yPixels=str2double(cell2mat(fileinfo(2,4)));
pixelencoding = cell2mat(fileinfo(4,4));
imbytes=str2double(cell2mat(fileinfo(5,4)));
imperfile=str2double(cell2mat(fileinfo(6,4)));
temp_rawdata=zeros(nVy, nVx, size(tempdir2, 1)*imperfile);


if strcmp(pixelencoding,'Mono16')
    offset=imbytes-xPixels*yPixels*2;%???
elseif strcmp(pixelencoding,'Mono32')
    offset=imbytes-xPixels*yPixels*4;
else
    msgbox('new pixel encoding')
end

a=0;
for i=1:size(tempdir2, 1);
    fid=fopen(fullfile(rawdatafolder, tempdir2(i).name));
    fseek(fid,0,'bof');%%????
    for n=1:imperfile;
        a=a+1;
        if strcmp(pixelencoding,'Mono16')
            tempdata=fread(fid,xPixels*yPixels,'uint16');
        elseif strcmp(pixelencoding,'Mono32')
            tempdata=fread(fid,xPixels*yPixels,'uint32');
        end
        fseek(fid,offset,'cof');%??? how to read the next image
        
        tempdata =reshape(tempdata, xPixels, yPixels);
        %% need to roate or flip for different cameras
        if camIndex == 1
            tempdata=rot90(reshape(tempdata, xPixels, yPixels), 1); % assumes data is square, equal pixels in x and y
            tempdata = flip(tempdata,2);
        elseif camIndex == 2
            tempdata=rot90(reshape(tempdata, xPixels, yPixels), 1);
            tempdata = flip(tempdata,1);
            tempdata = flip(tempdata,2);
        end
        
        temp_rawdata(:,:,a)=BinBySum(tempdata, nVy, nVx);
    end
    fclose(fid);
end
temp_rawdata = temp_rawdata(:,:,1:numTotalFrames);
if mod(numTotalFrames,numLED)~=0
    rawdata = zeros(nVy,nVx,numTotalFrames+1);
    rawdata(:,:,2:numTotalFrames+1) = temp_rawdata;
else
    rawdata = temp_rawdata;
end
rawdata = reshape(rawdata,nVy,nVx,numLED,[]);






