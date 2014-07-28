% pixelize the src plane

clear all; clc

addpath ../mscripts/
PlotParams;

diary('4.3_pix.diary');
fprintf('------------------------------------------------\n')
fprintf('|  Now we are working on MACS0717 - 4.3_pix!   |\n')
fprintf('------------------------------------------------\n')

%-------------------------------------------------------------------------------
% probably moved to lens_deflect.m later
%------------ the pixel scale of the RGB img given by the Python command
% fitstools.get_pixscale('MACS0717_F814WF105WF140W_R.fits')  alreadt in unit of arcsec!!!
img_pixscale=0.049999997703084283;
mag_min= 2.90527;
scale=1;
src_pixscale= img_pixscale/scale;

% getting results for 4.3_
load 4.3_deflect.mat
src_ra=    reshape(RA0_src,N_img,1)*3600.;        % RA in arcsec
src_alpha= src_ra*cos(ref_dec/180.*pi);           % alpha
src_beta=  reshape(DEC0_src,N_img,1)*3600.;       % beta      <=>     DEC in arcsec
src_cnt=   reshape(img,N_img,1);
ctr_alpha= ctr_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ctr
ctr_beta=  ctr_dec*3600.;                         % beta_ctr
ref_alpha= ref_ra*cos(ref_dec/180.*pi)*3600.;     % alpha_ref
ref_beta=  ref_dec*3600.;                         % beta_ref
%------------ records the indices of which src plane pixels cnts go into
indx_alpha = zeros(N_img,1);
indx_beta = zeros(N_img,1);

[vec_alpha,N_alpha]=MakeVecCtr(src_alpha,ctr_alpha,src_pixscale);
[vec_beta,N_beta]=  MakeVecCtr(src_beta,ctr_beta,src_pixscale);
%------------ NOTE: beta is the 1st column, while alpha is the 2nd!
src_cnt_pix = zeros(N_beta,N_alpha);
times_pix = zeros(N_beta,N_alpha);

for i=1:N_img
    absdiff_alpha=  abs(vec_alpha-src_alpha(i));
    absdiff_beta=   abs(vec_beta-src_beta(i));
    [diff_alpha,indx_alpha(i)]= min(absdiff_alpha);
    [diff_beta,indx_beta(i)]=   min(absdiff_beta);
    if diff_alpha==src_pixscale/2. || diff_beta==src_pixscale/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_beta(i),indx_alpha(i))=src_cnt_pix(indx_beta(i),indx_alpha(i))+src_cnt(i);
    times_pix(indx_beta(i),indx_alpha(i))=  times_pix(indx_beta(i),indx_alpha(i))+1;
%     fprintf('finished putting the No.%d remapped corner points!\n',i)
    clear absdiff_alpha absdiff_beta diff_alpha diff_beta
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
src_SB_pix = src_cnt_pix./times_pix;    
% NOTE: it's the conservation of SB not of photon counts!!
%       the counts on src plane is always < counts on img plane!
dalpha= vec_alpha-ref_alpha;
dbeta=  vec_beta-ref_beta;

%% plotting figure

figure(1)
imagescwithnan(dalpha,dbeta,src_SB_pix,jet,[1 1 1],true)
axis xy
colorbar

xlabel('d\alpha [arcsec]','FontSize',lab_fontsize);
ylabel('d\beta [arcsec]','FontSize',lab_fontsize);
title('MACS0717 4.3_{src} on the pixelized source plane')
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
%------------ NOTE: the following determines the axial ranges!!!
axis(macs0717.sys4ar);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 4.3_pix.ps;

diary off
