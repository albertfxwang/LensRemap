% calculate source plane grids 

clear all; clc; tic
diary('14.3_deflect.diary');
fprintf('---------------------------------------------------\n')
fprintf('|       MACS0717   -   14.3_deflect                |\n')
fprintf('|       Lens Model: z1.855_sharon/                |\n')
fprintf('|       Observed HST image: imgF140W/             |\n')
fprintf('---------------------------------------------------\n')

%% load in data
img_id= '14.3_';
SLcatalog = importdata('z1.855_SLimg.cat', ' ', 2);
img_coord = SLcatalog.data;
indx=find(abs(img_coord(:,1) - str2num(img_id(1:end-1)))<1e-6);
img_ctr = img_coord(indx,2:3);

img     =load('imgF140W/14.3_cut.dat');
img_ra  =load('imgF140W/14.3_ra.dat');       % here image RA/DEC is NOT axis values
img_dec =load('imgF140W/14.3_dec.dat');     % you should interp to get value at each pair of them
alpha1  =load('z1.855_sharon/14.3_alpha1.dat');
alpha2  =load('z1.855_sharon/14.3_alpha2.dat');
mag     =load('z1.855_sharon/14.3_mag.dat');
lens_ra =load('z1.855_sharon/14.3_lensra.dat');    % lens RA/DEC can be treated as axis values
lens_dec=load('z1.855_sharon/14.3_lensdec.dat');  % since there's a good alignment btw WCS coord and its axes

N_img=length(img_ra);
if length(img_dec)~= N_img
    fprintf('dimensions of image''s RA DEC don''t get along!\n')
    break
else
    fprintf('length of the image = %d, square size=%d\n',N_img,sqrt(N_img))
end
%------------ HST image's reference pixel's WCS coord
%$ imhead MACS0717_F814WF105WF140W_R.fits | grep CRVAL1 (->RA), CRVAL2 (->DEC)
ref_ra=109.384564525;
ref_dec=37.7496681474;

alpha1_img=zeros(N_img,1);
alpha2_img=zeros(N_img,1);
mag_img=zeros(N_img,1);

%% 2D interpolation to evaluate alpha, Jacobian-mat at each pixel's center
for j=1:N_img
    alpha1_img(j)=interp2(lens_ra,lens_dec,alpha1,img_ra(j),img_dec(j));   % default method: linear
    alpha2_img(j)=interp2(lens_ra,lens_dec,alpha2,img_ra(j),img_dec(j));
    mag_img(j)=interp2(lens_ra,lens_dec,mag,img_ra(j),img_dec(j));
    fprintf('finished No.%d interpolation set!\n',j)
end
alpha1_ctr=interp2(lens_ra,lens_dec,alpha1,img_ctr(1),img_ctr(2));
alpha2_ctr=interp2(lens_ra,lens_dec,alpha2,img_ctr(1),img_ctr(2));
mag_ctr=interp2(lens_ra,lens_dec,mag,img_ctr(2),img_ctr(2));   % interp for the image center

%% Step 1: apply the deflection angle shift to the center of each pixel
%          so now we need to specify two matrices of the same dimension to
%          the img matrix, to record the RA, DEC for each grid cell
RA0_src=img_ra+alpha1_img/60./cos(ref_dec/180.*pi);       % Remember the RA-axis is inverted, AND  the cos-factor !!!
DEC0_src=img_dec-alpha2_img/60.;
ctr_ra=img_ctr(1)+alpha1_ctr/60./cos(ref_dec/180.*pi);
ctr_dec=img_ctr(2)-alpha2_ctr/60.;

save 14.3_deflect.mat
toc
diary off

