% regain my honor!

clear all; clc

%% load in data
cut1=load('cut1.dat');
alpha1=load('alpha1.dat');
alpha2=load('alpha2.dat');
gamma1=load('gamma1.dat');
gamma2=load('gamma2.dat');
kappa=load('kappa.dat');
mag=load('mag.dat');

img_ra=load('img_ra.dat');
img_dec=load('img_dec.dat');
lens_ra=load('lens_ra.dat');
lens_dec=load('lens_dec.dat');

%%

CD1_1   =   -1.01466245311E-06; % Degrees / Pixel                                
CD2_1   =   -8.27140110712E-06; % Degrees / Pixel                                
CD1_2   =   -8.27139425197E-06; % Degrees / Pixel                                
CD2_2   =    1.01465256774E-06; % Degrees / Pixel                 

% figure(1)
% imagesc(img_ra,img_dec,cut1);
% axis xy
% colorbar;


