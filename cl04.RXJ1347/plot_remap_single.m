% plotting one single remapped images

clear all; clc

% getting results for i1
load i5_remap.mat
img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
img_cnt=img;
src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
src_cnt=reshape(counts_src,N_img*4,1);

ctr_img_ra=(img_ctr(2,1)-ref_ra)*3600.;
ctr_img_dec=(img_ctr(2,2)-ref_dec)*3600.;
ctr_src_ra=(ctr_ra-ref_ra)*3600.;
ctr_src_dec=(ctr_dec-ref_dec)*3600.;

% color and linewidth schemes
lab_fontsize =12; axes_fontsize =10;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

%% the remapped images in src plane
figure(1)  
scatter(src_ra,src_dec,3,src_cnt)
colormap('jet');
hold on
plot(ctr_src_ra,ctr_src_dec,'ko','MarkerSize',15,'LineWidth',2)
hold off

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 i5_{src} w.r.t. the reference pixel''s RA/DEC')
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('Counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);
axis tight
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 i5_src.ps;


%% the original HST images in lens plane
figure(2)  
scatter(img_ra,img_dec,3,img_cnt)
colormap('jet');
hold on
plot(ctr_img_ra,ctr_img_dec,'ks','MarkerSize',15,'LineWidth',2)
hold off

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 i5_{img} w.r.t. the reference pixel''s RA/DEC')
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('Counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);
axis tight
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 i5_img.ps;


