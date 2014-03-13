% regain my honor!

clear all; clc; tic

%% load in data
img=load('cut2.dat');
alpha1=load('alpha1.dat');
alpha2=load('alpha2.dat');
gamma1=load('gamma1.dat');
gamma2=load('gamma2.dat');
kappa=load('kappa.dat');
mag=load('mag.dat');

img_ra=load('i2_ra.dat');       % here image RA/DEC is NOT axis values
img_dec=load('i2_dec.dat');     % you should interp to get value at each pair of them
lens_ra=load('lens_ra.dat');        % lens RA/DEC can be treated as axis values
lens_dec=load('lens_dec.dat');      % since there's a good alignment btw WCS coord and its axes

N_img=length(img_ra);
if length(img_dec)~= N_img
    fprintf('dimensions of image''s RA DEC don''t get along!\n')
    break
end
% the rotation-mat
CD1_1   =   -1.01466245311E-06; % Degrees / Pixel                                
CD2_1   =   -8.27140110712E-06; % Degrees / Pixel                                
CD1_2   =   -8.27139425197E-06; % Degrees / Pixel                                
CD2_2   =    1.01465256774E-06; % Degrees / Pixel                 
CD=[CD1_1 CD1_2; CD2_1 CD2_2];
dpixel4=[0.5 0.5 -0.5 -0.5; 0.5 -0.5 0.5 -0.5];

alpha_img=zeros(N_img,2);   % 1 -> alpha_1, 2 -> alpha_2
gamma_img=zeros(N_img,2);   % 1 -> gamma_1, 2 -> gamma_2
kappa_img=zeros(N_img,1);



RA0_img=zeros(N_img);
DEC0_img=zeros(N_img);
dRA4_img=zeros(N_img,4);
dDEC4_img=zeros(N_img,N_img,4);
dRA4_src=zeros(N_img,N_img,4);
dDEC4_src=zeros(N_img,N_img,4);
RA4_src=zeros(N_img,N_img,4);
DEC4_src=zeros(N_img,N_img,4);
counts_src=zeros(N_img,N_img,4);

%% 2D interpolation to evaluate alpha, Jacobian-mat at each pixel's center
for j=1:N_img
    alpha_img(j,1)=interp2(lens_ra,lens_dec,alpha1,img_ra(j),img_dec(j));   % default method: linear
    alpha_img(j,2)=interp2(lens_ra,lens_dec,alpha2,img_ra(j),img_dec(j));
    gamma_img(j,1)=interp2(lens_ra,lens_dec,gamma1,img_ra(j),img_dec(j));
    gamma_img(j,2)=interp2(lens_ra,lens_dec,gamma2,img_ra(j),img_dec(j));
    kappa_img(j)=interp2(lens_ra,lens_dec,kappa,img_ra(j),img_dec(j));
end
% compute the elements of the Jacobian-mat
jacob_11 = 1 - kappa_img - gamma_img(:,1);
jacob_22 = 1 - kappa_img + gamma_img(:,1);
jacob_12 = -gamma_img(:,2);
jacob_21 = jacob_12;

%% Step 1: apply the deflection angle shift to the center of each pixel
%          so now we need to specify two matrices of the same dimension to
%          the img matrix, to record the RA, DEC for each grid cell
RA0_src=img_ra-alpha_img(:,1)/60;
DEC0_src=img_dec-alpha_img(:,2)/60;

%% Step 2: apply Jacobian-mat to 4 corner points of each pixel
%          but even before that, you have to calc (RA,DEC) of them at
%          image's plane using the rotation-mat
for j=1:N_img
    for i=1:N_img
        for t=1:4
            temp_img=CD*dpixel4(:,t);           % temp_img: [dalpha; dbeta]
            dRA4_img(i,j,t)=temp_img(1)/cos(DEC0_img(i,j)/180*pi);
            dDEC4_img(i,j,t)=temp_img(2);
            temp_src=[jacob_11(i,j) jacob_12(i,j); jacob_21(i,j) jacob_22(i,j)]...
                *[dRA4_img(i,j,t); dDEC4_img(i,j,t)];  % temp_src: [dRA4_src; dDEC4_src]
            dRA4_src(i,j,t)=temp_src(1);
            dDEC4_src(i,j,t)=temp_src(2);
            RA4_src(i,j,t)=RA0_src(i,j)+dRA4_src(i,j,t);
            DEC4_src(i,j,t)=DEC0_src(i,j)+dDEC4_src(i,j,t);
            counts_src(i,j,t)=0.25*img(i,j);
            fprintf('(%d, %d, %d) img(%5.3e,%5.3e) => src(%5.3e,%5.3e)\n',...
                i,j,t,dRA4_img(i,j,t),dDEC4_img(i,j,t),dRA4_src(i,j,t),dDEC4_src(i,j,t))
            clear temp_img temp_src
        end
    end
end

%% plotting src image
lab_fontsize =14; axes_fontsize =12;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

figure(2)
scatter(RA4_src(1:N_img*N_img*4),DEC4_src(1:N_img*N_img*4),3,counts_src(1:N_img*N_img*4));
colormap('jet');
xlabel('RA','FontSize',lab_fontsize);
ylabel('DEC','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 

ax = gca;
% hbar = colorbar('horiz'); 
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
% fix_colorbar(hbar,ax);    only useful for matlab v7 or earlier
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 9 8]);
% print -dpng src_i1.png;   writing png takes much longer than you thought!

print -dpsc2 src_i1_true.ps;
% print -dpsc2 src_i2.ps;

toc
