% plotting the remapped images repeatedly for one system
% NOTE: set(gcf, 'PaperPosition',[ 0 0 8 6]) fits my laptop screen better, while [ 0 0 9 7] fits larger screen better

clear all; clc; tic

addpath ~/Dropbox/matlab/plotting/
PlotParams;

num_img=3;
img_center=zeros(num_img,2);   % 1st column: RA. 2nd column: DEC.
src_ctr=zeros(num_img,2);

load  4.1_deflect.mat
a1_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
a1_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
a1_img_cnt=img;
a1_src_ra=(RA0_src-ref_ra)*3600.;     % RA in arcsec
a1_src_dec=(DEC0_src-ref_dec)*3600.;  % DEC in arcsec
a1_src_cnt=img;
num=1;
img_center(num,1)=(img_ctr(1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

load  4.2_deflect.mat
a2_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
a2_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
a2_img_cnt=img;
a2_src_ra=(RA0_src-ref_ra)*3600.;     % RA in arcsec
a2_src_dec=(DEC0_src-ref_dec)*3600.;  % DEC in arcsec
a2_src_cnt=img;
num=2;
img_center(num,1)=(img_ctr(1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

load  4.3_deflect.mat
a3_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
a3_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
a3_img_cnt=img;
a3_src_ra=(RA0_src-ref_ra)*3600.;     % RA in arcsec
a3_src_dec=(DEC0_src-ref_dec)*3600.;  % DEC in arcsec
a3_src_cnt=img;
num=3;
img_center(num,1)=(img_ctr(1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

%% the remapped images in src plane
figure(1)  
scatter(a1_src_ra,a1_src_dec,3,a1_src_cnt)
hold on
scatter(a2_src_ra,a2_src_dec,3,a2_src_cnt)
scatter(a3_src_ra,a3_src_dec,3,a3_src_cnt)
colormap('jet');
plot(src_ctr(:,1),src_ctr(:,2),'ko','MarkerSize',15,'LineWidth',2)
hold off
for i=1:num_img
    text(src_ctr(i,1),src_ctr(i,2)+0.75,['  4.',num2str(i),' src'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('MACS0717  4.system w.r.t. the reference pixel''s RA/DEC')
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('Counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);
% axis([-Inf,Inf,-Inf,Inf]);  <=>  axis tight
axis(ar);
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2  4.tot_src.ps;


%% the original HST images in lens plane
figure(2)  
scatter(a1_img_ra,a1_img_dec,3,a1_img_cnt)
hold on
scatter(a2_img_ra,a2_img_dec,3,a2_img_cnt)
scatter(a3_img_ra,a3_img_dec,3,a3_img_cnt)
colormap('jet');
plot(img_center(:,1),img_center(:,2),'ks','MarkerSize',10,'LineWidth',1)
hold off
for i=1:num_img
    text(img_center(i,1),img_center(i,2)+3,['  4.',num2str(i),' img'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('MACS0717  4.system w.r.t. the reference pixel''s RA/DEC')
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
print -dpsc2  4.tot_img.ps;

