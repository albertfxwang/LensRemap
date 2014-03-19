% regain my honor!

clear all; clc; tic

%% load in data
alpha1=load('i5_data/alpha1.dat');
alpha2=load('i5_data/alpha2.dat');
gamma1=load('i5_data/gamma1.dat');
gamma2=load('i5_data/gamma2.dat');
kappa=load('i5_data/kappa.dat');
% mag=load('mag.dat');
lens_ra=load('i5_data/lens_ra.dat');    % lens RA/DEC can be treated as axis values
lens_dec=load('i5_data/lens_dec.dat');  % since there's a good alignment btw WCS coord and its axes
img=load('i5_data/cut.dat');
img_ra=load('i5_data/img_ra.dat');       % here image RA/DEC is NOT axis values
img_dec=load('i5_data/img_dec.dat');     % you should interp to get value at each pair of them

N_img=length(img_ra);
if length(img_dec)~= N_img
    fprintf('dimensions of image''s RA DEC don''t get along!\n')
    break
else
    fprintf('length of the image = %d, square size=%d',N_img,sqrt(N_img))
end
% the rotation-mat
CD1_1   =   -1.01466245311E-06; % Degrees / Pixel                                
CD2_1   =   -8.27140110712E-06; % Degrees / Pixel                                
CD1_2   =   -8.27139425197E-06; % Degrees / Pixel                                
CD2_2   =    1.01465256774E-06; % Degrees / Pixel                 

CD=[CD1_1 CD1_2; CD2_1 CD2_2];
dpixel4=[0.5 0.5 -0.5 -0.5; 0.5 -0.5 -0.5 0.5]; % corners in upper-right, lower-right, lower-left, upper-left (clockwise)

alpha1_img=zeros(N_img,1);
alpha2_img=zeros(N_img,1);
gamma1_img=zeros(N_img,1);
gamma2_img=zeros(N_img,1);
kappa_img=zeros(N_img,1);

dRA4_img=zeros(N_img,4);
dDEC4_img=zeros(N_img,4);
dRA4_src=zeros(N_img,4);
dDEC4_src=zeros(N_img,4);
RA4_src=zeros(N_img,4);
DEC4_src=zeros(N_img,4);
counts_src=zeros(N_img,4);

%% 2D interpolation to evaluate alpha, Jacobian-mat at each pixel's center
for j=1:N_img
    alpha1_img(j)=interp2(lens_ra,lens_dec,alpha1,img_ra(j),img_dec(j));   % default method: linear
    alpha2_img(j)=interp2(lens_ra,lens_dec,alpha2,img_ra(j),img_dec(j));
    gamma1_img(j)=interp2(lens_ra,lens_dec,gamma1,img_ra(j),img_dec(j));
    gamma2_img(j)=interp2(lens_ra,lens_dec,gamma2,img_ra(j),img_dec(j));
    kappa_img(j)=interp2(lens_ra,lens_dec,kappa,img_ra(j),img_dec(j));
    fprintf('finished No.%d interpolation set!\n',j)
end

% compute the elements of the Jacobian-mat
jacob_11 = 1 - kappa_img - gamma1_img;
jacob_22 = 1 - kappa_img + gamma1_img;
jacob_12 = -gamma2_img;
jacob_21 = jacob_12;

%% Step 1: apply the deflection angle shift to the center of each pixel
%          so now we need to specify two matrices of the same dimension to
%          the img matrix, to record the RA, DEC for each grid cell
RA0_src=img_ra-alpha1_img/60;
DEC0_src=img_dec-alpha2_img/60;

%% Step 2: apply Jacobian-mat to 4 corner points of each pixel
%          but even before that, you have to calc (RA,DEC) of them at
%          image's plane using the rotation-mat
for i=1:N_img
        for t=1:4
            temp_img=CD*dpixel4(:,t);                   % temp_img: [dalpha; dbeta]
            dRA4_img(i,t)=temp_img(1)/cos(img_dec(i)/180*pi);
            dDEC4_img(i,t)=temp_img(2);
            temp_src=[jacob_11(i) jacob_12(i); jacob_21(i) jacob_22(i)]...
                *[dRA4_img(i,t); dDEC4_img(i,t)];       % temp_src: [dRA4_src; dDEC4_src]
            dRA4_src(i,t)=temp_src(1);
            dDEC4_src(i,t)=temp_src(2);
            RA4_src(i,t)=RA0_src(i)+dRA4_src(i,t);
            DEC4_src(i,t)=DEC0_src(i)+dDEC4_src(i,t);
            counts_src(i,t)=0.25*img(i);
            fprintf('(%d, %d) img(%5.3e,%5.3e) => src(%5.3e,%5.3e)\n',...
                i,t,dRA4_img(i,t)+img_ra(i),dDEC4_img(i,t)+img_dec(i),RA4_src(i,t),DEC4_src(i,t))
            clear temp_img temp_src
        end
end

%% plotting src image
lab_fontsize =14; axes_fontsize =12;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

figure(1)
scatter(RA4_src(1:N_img*4),DEC4_src(1:N_img*4),3,counts_src(1:N_img*4));
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

print -dpsc2 i5_src.ps;

toc
