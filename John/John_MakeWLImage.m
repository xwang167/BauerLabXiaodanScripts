function John_MakeWLImage(filename)

WL=zeros(128,128,3);
i=0;
for k = [5,7,8];    %make WL image (r, y, b channels)
    %for k = [7,9,10];    %make WL image (r, y, b channels)
    i=i+1;
    WL(:,:,i) = fliplr(imread(filename,k));
end

WL(:,:,1)=WL(:,:,1)/max(max(WL(:,:,1)));
WL(:,:,2)=WL(:,:,2)/max(max(WL(:,:,2)));
WL(:,:,3)=WL(:,:,3)/max(max(WL(:,:,3)));

end