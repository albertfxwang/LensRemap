% regain my honor!

clear all; clc; tic

%% load in data
img=load('cut1.dat');
alpha1=load('alpha1.dat');
alpha2=load('alpha2.dat');
gamma1=load('gamma1.dat');
gamma2=load('gamma2.dat');
kappa=load('kappa.dat');
mag=load('mag.dat');

img_ra=load('i1_ra.dat');
img_dec=load('i1_dec.dat');
lens_ra=load('lens_ra.dat');
lens_dec=load('lens_dec.dat');

N_img=length(img);
N_lens=length(mag);

RA0_img=zeros(N_img);
DEC0_img=zeros(N_img);
dRA4_img=zeros(N_img,N_img,4);
dDEC4_img=zeros(N_img,N_img,4);
dRA4_src=zeros(N_img,N_img,4);
dDEC4_src=zeros(N_img,N_img,4);
RA4_src=zeros(N_img,N_img,4);
DEC4_src=zeros(N_img,N_img,4);
counts_src=zeros(N_img,N_img,4);

% the rotation-mat
CD1_1   =   -1.01466245311E-06; % Degrees / Pixel                                
CD2_1   =   -8.27140110712E-06; % Degrees / Pixel                                
CD1_2   =   -8.27139425197E-06; % Degrees / Pixel                                
CD2_2   =    1.01465256774E-06; % Degrees / Pixel                 
CD=[CD1_1 CD1_2; CD2_1 CD2_2];

dpixel4=[0.5 0.5 -0.5 -0.5; 0.5 -0.5 0.5 -0.5];

%% 2D interpolation to evaluate alpha, Jacobian-mat at each pixel's center

% NB the transpose of img_dec, in order to make 2D interpolated results matrices
alpha1_img=interp2(lens_ra,lens_dec,alpha1,img_ra,img_dec(end:-1:1)');     % default method: linear
alpha2_img=interp2(lens_ra,lens_dec,alpha2,img_ra,img_dec(end:-1:1)');
gamma1_img=interp2(lens_ra,lens_dec,gamma1,img_ra,img_dec(end:-1:1)');
gamma2_img=interp2(lens_ra,lens_dec,gamma2,img_ra,img_dec(end:-1:1)');
kappa_img=interp2(lens_ra,lens_dec,kappa,img_ra,img_dec(end:-1:1)');

% compute the elements of the Jacobian-mat
jacob_11 = 1 - kappa_img - gamma1_img;
jacob_22 = 1 - kappa_img + gamma1_img;
jacob_12 = -gamma2_img;
jacob_21 = jacob_12;

%% Step 1: apply the deflection angle shift to the center of each pixel
%          so now we need to specify two matrices of the same dimension to
%          the img matrix, to record the RA, DEC for each grid cell
for i=1:N_img
    RA0_img(:,i)=img_ra(i);
    DEC0_img(i,:)=img_dec(i);
end

% testing
mag_img=interp2(lens_ra,lens_dec,mag,img_ra,img_dec');
mag_img_p=interp2(lens_ra,lens_dec,mag,RA0_img,DEC0_img);
if max(max(abs(mag_img-mag_img_p))) > 1e-8
    fprintf('something wrong w/ matric indices!\n')
    break
end

RA0_src=RA0_img-alpha1_img/60;
DEC0_src=DEC0_img-alpha2_img/60;

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
% fix_colorbar(hbar,ax);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 9 8]);
% print -dpng src_i1.png;       % writing png takes much longer than you thought!
print -dpsc2 src_i1_true.ps;
% print -dpsc2 src_i2.ps;

toc
