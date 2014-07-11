% pixelize the source plane

clear all; clc

addpath ../mscripts/
PlotParams;

diary('4.1_pix.diary');
fprintf('------------------------------------------------\n')
fprintf('|  Now we are working on MACS0717 - 4.1_pix!   |\n')
fprintf('------------------------------------------------\n')

% getting results for 4.1_
load 4.1_remap.mat
src_ra =reshape(RA4_src,N_img*4,1)*3600.;   % RA in arcsec
src_dec=reshape(DEC4_src,N_img*4,1)*3600.;  % DEC in arcsec
src_cnt=reshape(sb_src,N_img*4,1);
% ctr_src_ra=(ctr_ra-ref_ra)*3600.;
% ctr_src_dec=(ctr_dec-ref_dec)*3600.;
fprintf('magnification at the center (RA=%10.5f, DEC=%10.5f) is %10.5f\n',ctr_ra,ctr_dec,mag_ctr)
% pix_scale_img=0.03;
% pix_scale_src=0.03/mag_ctr;
indx_ra = zeros(N_img*4,1);     % records the indices of which src plane pixels cnts go into
indx_dec = zeros(N_img*4,1);

N_bin=sqrt(N_img);
src_cnt_pix = zeros(N_bin);
times_pix = zeros(N_bin);
[vec_ra,binsize_ra]=MakeVec(src_ra,2,N_bin);
[vec_dec,binsize_dec]=MakeVec(src_dec,2,N_bin);

for i=1:N_img*4
    absdiff_ra =abs(vec_ra-src_ra(i));
    absdiff_dec=abs(vec_dec-src_dec(i));
    [diff_ra,indx_ra(i)]=min(absdiff_ra);
    [diff_dec,indx_dec(i)]=min(absdiff_dec);
    if diff_ra==binsize_ra/2. || diff_dec==binsize_dec/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_dec(i),indx_ra(i))=src_cnt_pix(indx_dec(i),indx_ra(i))+src_cnt(i);
    times_pix(indx_dec(i),indx_ra(i))=times_pix(indx_dec(i),indx_ra(i))+1;
%     fprintf('finished putting the No.%d remapped corner points!\n',i)
    clear absdiff_ra absdiff_dec diff_ra diff_dec
end
src_ra_pix=vec_ra-ref_ra*3600.;
src_dec_pix=vec_dec-ref_dec*3600.;
src_cnt_pix(src_cnt_pix == 0) = NaN;
src_SB_pix = src_cnt_pix./times_pix;    
%%%%%%%%%%%%%%%% NOTE: it's the conservation of SB not of photon counts!!
%%%%%%%%%%%%%%%% the counts on src plane is always < counts on img plane!

%% plotting figure

figure(1)
imagescwithnan(src_ra_pix,src_dec_pix,src_SB_pix,jet,[1 1 1],true)
axis xy
colorbar

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('MACS0717 4.1_{src} on the pixelized source plane')
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
% axis tight

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 4.1_pix.ps;

diary off
