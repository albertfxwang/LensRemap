% pixelize the src plane in terms of all multiple images within one system

clear all; clc; tic

addpath ../mscripts/
PlotParams;

sys= '14';
mat_dir= 'sharon_sys14.mat';      % the folder containing .mat files
mat_tail='_deflect.mat';
pic_name=[sys '.tot_pix_fin.ps'];
diary([sys,'.tot_pix_fin.diary']);
num_img=3;

fprintf('----------------------------------------------------------\n')
fprintf(['|  This is the diary for plotting ',pic_name,'!    |\n'])
fprintf(['|  Now we are working on MACS0717 - srcpix for totsys ',sys,'! |\n'])
fprintf('----------------------------------------------------------\n')

%------------ the pixel scale of the RGB img given by the Python command
% fitstools.get_pixscale('MACS0717_F814WF105WF140W_R.fits')  already in unit of arcsec!!!
img_pixscale=0.049999997703084283;
%------------ the 1-over-ratio for src_pixscale, 1st column: alpha, 2nd column: beta, 
% the ordering of rows follow their names, not their appearances in the next section afterwards
scale=[2.4 2.9; 1.3 1.6; 2.6 2.2];  
scale_tot=[3.0 2.7];
% *NOTE: the scale for totsys can be much higher than individual img

%------------ the center of src plane img, 1st column: alpha, 2nd column: beta
src_ctr=zeros(num_img,2);

%------------ the Jacobi matrix of external kappa and shear fields 
a3_jacobi=struct('kappa',1.9,'gamma',0.3,'phi',15);
a1_jacobi=struct('kappa',0.98,'gamma',0.73,'phi',55);

%------------ set the handle for plotting
h=figure(1);

%% getting remapped results for each img and plotting figures as well!!!
%-------------------------------------------------------------------------------
% first of all, srcpix the img which has the smallest magnification
num=2;
if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_tail])))

src_alpha= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;           % alpha
src_beta=  reshape(DEC0_src,N_img,1)*3600.;       % beta      <=>     DEC in arcsec
src_cnt=   reshape(img,N_img,1);
ctr_alpha= ctr_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ctr
ctr_beta=  ctr_dec*3600.;                         % beta_ctr
src_ctr(num,1)= ctr_alpha;
src_ctr(num,2)= ctr_beta;
ref_alpha= ref_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ref
ref_beta=  ref_dec*3600.;                         % beta_ref
%------------ records the indices of which src plane pixels cnts go into
indx_alpha = zeros(N_img,1);
indx_beta = zeros(N_img,1);

%%------------ set up the common ctr for all img
ctr_common=[src_ctr(num,1) src_ctr(num,2)];

%%%------------ saving data for the combined subplot
a3_N=N_img;
a3_src_alpha=src_alpha;
a3_src_beta=src_beta;
a3_src_cnt=src_cnt;

scale_alpha=scale(num,1);
scale_beta=scale(num,2);
binsize_alpha= img_pixscale/scale_alpha;
binsize_beta=  img_pixscale/scale_beta;
[vec_alpha,N_alpha]=MakeVecCtr(src_alpha,src_ctr(num,1),binsize_alpha);
[vec_beta,N_beta]=  MakeVecCtr(src_beta,src_ctr(num,2),binsize_beta);
src_cnt_pix = zeros(N_beta,N_alpha);
times_pix = zeros(N_beta,N_alpha);

%------------ interlacing
for i=1:N_img
    absdiff_alpha=  abs(vec_alpha-src_alpha(i));
    absdiff_beta=   abs(vec_beta-src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix3_SB = src_cnt_pix./times_pix;    
srcpix3_dalpha= vec_alpha-ref_alpha;
srcpix3_dbeta=  vec_beta-ref_beta;

%------------ sub-plotting
subplot(2,2,1);
imagescwithnan(srcpix3_dalpha,srcpix3_dbeta,srcpix3_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('d\alpha [arcsec]','FontSize',lab_fontsize);
ylabel('d\beta [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(macs0717.sys14ar);


%-------------------------------------------------------------------------------
% srcpix another img
num=3;
if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_tail])))

src0_alpha= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;           % alpha
src0_beta=  reshape(DEC0_src,N_img,1)*3600.;       % beta      <=>     DEC in arcsec
src_cnt=   reshape(img,N_img,1);
ctr_alpha= ctr_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ctr
ctr_beta=  ctr_dec*3600.;                         % beta_ctr
src_ctr(num,1)= ctr_alpha;
src_ctr(num,2)= ctr_beta;
ref_alpha= ref_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ref
ref_beta=  ref_dec*3600.;                         % beta_ref
%------------ records the indices of which src plane pixels cnts go into
indx_alpha = zeros(N_img,1);
indx_beta = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_alpha,src1_beta]= shift(src0_alpha,src0_beta,src_ctr(num,:),ctr_common);
%------------ the following two lines are only for the shift plot
% src_alpha=src1_alpha;
% src_beta=src1_beta;
%%------------ Jacobi-rotate img
[src_alpha,src_beta]=   JacobiRot(src1_alpha,src1_beta,ctr_common,a3_jacobi);

%%%------------ saving data for the combined subplot
a2_N=N_img;
a2_src_alpha=src_alpha;
a2_src_beta=src_beta;
a2_src_cnt=src_cnt;

scale_alpha=scale(num,1);
scale_beta=scale(num,2);
binsize_alpha= img_pixscale/scale_alpha;
binsize_beta=  img_pixscale/scale_beta;
[vec_alpha,N_alpha]=MakeVecCtr(src_alpha,ctr_common(1),binsize_alpha);
[vec_beta,N_beta]=  MakeVecCtr(src_beta,ctr_common(2),binsize_beta);
%------------ the following four lines are only for the orig plot
% src_alpha=src0_alpha;
% src_beta=src0_beta;
% [vec_alpha,N_alpha]=MakeVecCtr(src_alpha,src_ctr(num,1),binsize_alpha);
% [vec_beta,N_beta]=  MakeVecCtr(src_beta,src_ctr(num,2),binsize_beta);
src_cnt_pix = zeros(N_beta,N_alpha);
times_pix = zeros(N_beta,N_alpha);

%------------ interlacing
for i=1:N_img
    absdiff_alpha=  abs(vec_alpha-src_alpha(i));
    absdiff_beta=   abs(vec_beta-src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix2_SB = src_cnt_pix./times_pix;    
srcpix2_dalpha= vec_alpha-ref_alpha;
srcpix2_dbeta=  vec_beta-ref_beta;

%------------ sub-plotting
subplot(2,2,2)
imagescwithnan(srcpix2_dalpha,srcpix2_dbeta,srcpix2_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('d\alpha [arcsec]','FontSize',lab_fontsize);
% ylabel('d\beta [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(macs0717.sys14ar);


%-------------------------------------------------------------------------------
% srcpix another img
num=1;
if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_tail])))

src0_alpha= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;           % alpha
src0_beta=  reshape(DEC0_src,N_img,1)*3600.;       % beta      <=>     DEC in arcsec
src_cnt=   reshape(img,N_img,1);
ctr_alpha= ctr_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ctr
ctr_beta=  ctr_dec*3600.;                         % beta_ctr
src_ctr(num,1)= ctr_alpha;
src_ctr(num,2)= ctr_beta;
ref_alpha= ref_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ref
ref_beta=  ref_dec*3600.;                         % beta_ref
%------------ records the indices of which src plane pixels cnts go into
indx_alpha = zeros(N_img,1);
indx_beta = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_alpha,src1_beta]= shift(src0_alpha,src0_beta,src_ctr(num,:),ctr_common);
%------------ the following two lines are only for the shift plot
% src_alpha=src1_alpha;
% src_beta=src1_beta;
%%------------ Jacobi-rotate img
[src_alpha,src_beta]=   JacobiRot(src1_alpha,src1_beta,ctr_common,a1_jacobi);

%%%------------ saving data for the combined subplot
a1_N=N_img;
a1_src_alpha=src_alpha;
a1_src_beta=src_beta;
a1_src_cnt=src_cnt;

scale_alpha=scale(num,1);
scale_beta=scale(num,2);
binsize_alpha= img_pixscale/scale_alpha;
binsize_beta=  img_pixscale/scale_beta;
[vec_alpha,N_alpha]=MakeVecCtr(src_alpha,ctr_common(1),binsize_alpha);
[vec_beta,N_beta]=  MakeVecCtr(src_beta,ctr_common(2),binsize_beta);
%------------ the following four lines are only for the orig plot
% src_alpha=src0_alpha;
% src_beta=src0_beta;
% [vec_alpha,N_alpha]=MakeVecCtr(src_alpha,src_ctr(num,1),binsize_alpha);
% [vec_beta,N_beta]=  MakeVecCtr(src_beta,src_ctr(num,2),binsize_beta);
src_cnt_pix = zeros(N_beta,N_alpha);
times_pix = zeros(N_beta,N_alpha);

%------------ interlacing
for i=1:N_img
    absdiff_alpha=  abs(vec_alpha-src_alpha(i));
    absdiff_beta=   abs(vec_beta-src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix1_SB = src_cnt_pix./times_pix;    
srcpix1_dalpha= vec_alpha-ref_alpha;
srcpix1_dbeta=  vec_beta-ref_beta;

%------------ sub-plotting
subplot(2,2,3)
imagescwithnan(srcpix1_dalpha,srcpix1_dbeta,srcpix1_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('d\alpha [arcsec]','FontSize',lab_fontsize);
ylabel('d\beta [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(macs0717.sys14ar);


%%%-------------------------------------------------------------------------------
% subplotting the combined pixelized src plane img
%------------ set up ranges in alpha,beta using macs0717.sys-ar
alpha_range=macs0717.sys14ar(1:2)+ref_alpha;
beta_range= macs0717.sys14ar(3:4)+ref_beta;

binsize_alpha= img_pixscale/scale_tot(1);
binsize_beta=  img_pixscale/scale_tot(2);
[vec_alpha,N_alpha]=MakeVecCtr(alpha_range,ctr_common(1),binsize_alpha);
[vec_beta,N_beta]=  MakeVecCtr(beta_range,ctr_common(2),binsize_beta);
src_cnt_pix = zeros(N_beta,N_alpha);
times_pix = zeros(N_beta,N_alpha);
for i=1:a1_N
    absdiff_alpha=  abs(vec_alpha-a1_src_alpha(i));
    absdiff_beta=   abs(vec_beta-a1_src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+a1_src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
for i=1:a2_N
    absdiff_alpha=  abs(vec_alpha-a2_src_alpha(i));
    absdiff_beta=   abs(vec_beta-a2_src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+a2_src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
for i=1:a3_N
    absdiff_alpha=  abs(vec_alpha-a3_src_alpha(i));
    absdiff_beta=   abs(vec_beta-a3_src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==binsize_alpha/2. || diff_beta==binsize_beta/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+a3_src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix_tot_SB = src_cnt_pix./times_pix;    
srcpix_tot_dalpha= vec_alpha-ref_alpha;
srcpix_tot_dbeta=  vec_beta-ref_beta;

%------------ sub-plotting
subplot(2,2,4)
imagescwithnan(srcpix_tot_dalpha,srcpix_tot_dbeta,srcpix_tot_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('d\alpha [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 combined img ',sys,' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(macs0717.sys14ar);


%% end-up work for the figure
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print(h,'-dpsc2',pic_name);
toc
diary off

%----------------------------- no use anymore ----------------------------------%
% leg_end = legend(['\kappa_{ext}=',num2str(jacobi_1.kappa)],['|\gamma_{ext}|=',num2str(jacobi_1.gamma)],...
%     ['\phi=',num2str(jacobi_1.phi)],3);
% set(leg_end,'Box','off','FontSize',axes_fontsize);