function [Seeds, L]=GalvoSeedGrid_PaxinosSpace

Xdim=linspace(-4.75,-0.25,10);
Ydim=linspace(-4.5,3,16);

[X, Y]=meshgrid(Xdim, Ydim);
X1=reshape(X,[],1);
Y1=reshape(Y,[],1);
Seeds.L(:,:)=[X1 Y1];

Xdim=linspace(0.25,4.75,10);
Ydim=linspace(-4.5,3,16);


[X, Y]=meshgrid(Xdim, Ydim);
X1=reshape(X,[],1);
Y1=reshape(Y,[],1);
Seeds.R(:,:)=[X1 Y1];

L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];