function tempdata=readOneFrame_Zyla_NoBinning(rawdatafolder,targetFrameInd)
disp(['starting get raw from', rawdatafolder]);
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


n = floor((targetFrameInd-1)/imperfile);

jj = mod((targetFrameInd-1),imperfile);
%     
% if camIndex == 1
%     m = jj+2;
% elseif camIndex == 2
    m = jj+3;
% end
%     
if m > imperfile-1
    n = n+1;
    m = m - imperfile;
end
    fid=fopen(fullfile(rawdatafolder, tempdir2(n).name));%xw,220204.n+1 to n
    fseek(fid,m*imbytes,'bof');%%????
       if strcmp(pixelencoding,'Mono16')
        tempdata1=fread(fid,xPixels*yPixels,'uint16'); 
       elseif strcmp(pixelencoding,'Mono32')
          tempdata1=fread(fid,xPixels*yPixels,'uint32'); 
       else
           msgbox('new pixel encoding')
       end
        fclose(fid);
        tempdata =reshape(tempdata1, xPixels, yPixels);
        %% need to roate or flip for different cameras
        if camIndex == 1
            tempdata=rot90(reshape(tempdata, xPixels, yPixels), 1); % assumes data is square, equal pixels in x and y
            tempdata = flip(tempdata,2);
        elseif camIndex == 2
            tempdata=rot90(reshape(tempdata, xPixels, yPixels), 1);
            tempdata = flip(tempdata,1);
            tempdata = flip(tempdata,2);
        end
