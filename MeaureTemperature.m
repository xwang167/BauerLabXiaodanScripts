
%run GUITest.m
%line 278 of GUITest
[filename path] = uigetfile;
s1 = strcat(path,filename);
%Load Flir Atlas
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
%open a thermal image
file = Flir.Atlas.Image.ThermalImageFile;
file.Open(s1);
%axes(handles.axes1);
%Get the image as an array
img = file.ImageArray;
%convert to Matlab type
X = uint8(img);
%Use matlabs Imshow to show the image
imshow(X);
%close file
file.Close;
handles.Filename = s1;
% guidata(hObject,handles);
% file
% file.Image
% file.ImageArray
% 
System.Drawing.Rectangle
System.Drawing.Rectangle(0,0,320,240)
file.GetValues(System.Drawing.Rectangle(0,0,320,240))

valsVector = double(file.GetValues(System.Drawing.Rectangle(0,0,320,240)));
valsArray = reshape(valsVector, [320,240]);
figure;surf(valsArray)
figure;imagesc(valsArray)
axis image off
 [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        [X,Y] = meshgrid(1:240,1:320);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(valsArray(ROI),99);
        temp = double(valsArray).*double(ROI);
        ROI = temp>max_ROI*0.98;
        hold on
        contour(ROI)      
        h = colorbar;
        colormap jet
    ylabel(h, 'Temperature(Celcius)')
    
    
    
    
    
    awake = 'FLIR0041';
 imagesc(valsArray(130:end,109:231),[20,38])
    
    colormap jet
    axis image off
    
      anes = 'FLIR0036';
imagesc(valsArray(100:230,49:195),[20,38])

    colormap jet
    axis image off