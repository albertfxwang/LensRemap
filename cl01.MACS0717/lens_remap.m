% calculate source plane grids 

clear all; clc; tic
diary('a2_G_remap.diary');
fprintf('------------------------------------------------\n')
fprintf('| Now we are working on RXJ1347 - a2_G_remap ! |\n')
fprintf('------------------------------------------------\n')

%% load in data
alpha1=load('a2_G_data/alpha1.dat');
alpha2=load('a2_G_data/alpha2.dat');
gamma1=load('a2_G_data/gamma1.dat');
gamma2=load('a2_G_data/gamma2.dat');
kappa=load('a2_G_data/kappa.dat');
mag=load('a2_G_data/mag.dat');
lens_ra=load('a2_G_data/lens_ra.dat');    % lens RA/DEC can be treated as axis values
lens_dec=load('a2_G_data/lens_dec.dat');  % since there's a good alignment btw WCS coord and its axes
img=load('a2_G_data/cut.dat');
img_ra=load('a2_G_data/img_ra.dat');       % here image RA/DEC is NOT axis values
img_dec=load('a2_G_data/img_dec.dat');     % you should interp to get value at each pair of them
img_ctr=load('a2_G_data/img_WCS_ctr.dat');    % the 2nd line: RA DEC for the image center

N_img=length(img_ra);
if length(img_dec)~= N_img
    fprintf('dimensions of image''s RA DEC don''t get along!\n')
    break
else
    fprintf('length of the image = %d, square size=%d\n',N_img,sqrt(N_img))
end
% the rotation-mat
CD1_1   =   -1.01466245311E-06; % Degrees / Pixel                                
CD2_1   =   -8.27140110712E-06; % Degrees / Pixel                                
CD1_2   =   -8.27139425197E-06; % Degrees / Pixel                                
CD2_2   =    1.01465256774E-06; % Degrees / Pixel                 

% HST image's reference pixel's WCS coord
ref_ra=206.901315235;       % $ imhead RXJ1347-1145_fullres_G.fits | grep CRVAL1
ref_dec=-11.7542487671;     % $ imhead RXJ1347-1145_fullres_G.fits | grep CRVAL2

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
sb_src=zeros(N_img,4);

%% 2D interpolation to evaluate alpha, Jacobian-mat at each pixel's center
for j=1:N_img
    alpha1_img(j)=interp2(lens_ra,lens_dec,alpha1,img_ra(j),img_dec(j));   % default method: linear
    alpha2_img(j)=interp2(lens_ra,lens_dec,alpha2,img_ra(j),img_dec(j));
    gamma1_img(j)=interp2(lens_ra,lens_dec,gamma1,img_ra(j),img_dec(j));
    gamma2_img(j)=interp2(lens_ra,lens_dec,gamma2,img_ra(j),img_dec(j));
    kappa_img(j)=interp2(lens_ra,lens_dec,kappa,img_ra(j),img_dec(j));
    fprintf('finished No.%d interpolation set!\n',j)
end
alpha1_ctr=interp2(lens_ra,lens_dec,alpha1,img_ctr(2,1),img_ctr(2,2));
alpha2_ctr=interp2(lens_ra,lens_dec,alpha2,img_ctr(2,1),img_ctr(2,2));
mag_ctr=interp2(lens_ra,lens_dec,mag,img_ctr(2,1),img_ctr(2,2));   % interp for the image center

% compute the elements of the Jacobian-mat
jacob_11 = 1 - kappa_img - gamma1_img;
jacob_22 = 1 - kappa_img + gamma1_img;
jacob_12 = -gamma2_img;
jacob_21 = jacob_12;

%% Step 1: apply the deflection angle shift to the center of each pixel
%          so now we need to specify two matrices of the same dimension to
%          the img matrix, to record the RA, DEC for each grid cell
RA0_src=img_ra+alpha1_img/60.;       % Remember the RA-axis is inverted !!!
DEC0_src=img_dec-alpha2_img/60.;
ctr_ra=img_ctr(2,1)+alpha1_ctr/60.;
ctr_dec=img_ctr(2,2)-alpha2_ctr/60.;

%% Step 2: apply Jacobian-mat to 4 corner points of each pixel
%          but even before that, you have to calc (RA,DEC) of them at
%          image's plane using the rotation-mat
for i=1:N_img
    fprintf('\n---No.%d pixel--- img_ctr(%10.8e,%10.8e) => src_ctr(%10.8e,%10.8e)\n',...
        i,img_ra(i),img_dec(i),RA0_src(i),DEC0_src(i))
        for t=1:4
            temp_img=CD*dpixel4(:,t);                   % temp_img: [dalpha; dbeta]
            dRA4_img(i,t)=temp_img(1)/cos(ref_dec/180*pi);
            dDEC4_img(i,t)=temp_img(2);
            temp_src=[jacob_11(i) jacob_12(i); jacob_21(i) jacob_22(i)]...
                *[dRA4_img(i,t); dDEC4_img(i,t)];       % temp_src: [dRA4_src; dDEC4_src]
            dRA4_src(i,t)=temp_src(1);
            dDEC4_src(i,t)=temp_src(2);
            RA4_src(i,t)=RA0_src(i)+dRA4_src(i,t);
            DEC4_src(i,t)=DEC0_src(i)+dDEC4_src(i,t);
%            counts_src(i,t)=0.25*img(i);
            sb_src(i,t)=img(i);         
            % It's the concept of conservation of surface brightness rather than photon counts
            % actually there should also be an extra consts as well as taking log but dropped here for convenience
            fprintf('(%d, %d) img(%10.8e,%10.8e) => src(%10.8e,%10.8e)\n',...
                i,t,dRA4_img(i,t)+img_ra(i),dDEC4_img(i,t)+img_dec(i),RA4_src(i,t),DEC4_src(i,t))
            clear temp_img temp_src
        end
end

save a2_G_remap.mat
toc
diary off

