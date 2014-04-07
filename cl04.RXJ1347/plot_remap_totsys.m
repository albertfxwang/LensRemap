% plotting the remapped images repeatedly for one system
% NOTE: set(gcf, 'PaperPosition',[ 0 0 8 6]) fits my laptop screen better, while [ 0 0 9 7] fits larger screen better

clear all; clc; tic

num_img=5;
img_center=zeros(num_img,2);   % 1st column: RA. 2nd column: DEC.
src_ctr=zeros(num_img,2);

% getting results for i1
load i1_remap.mat
i1_rg1=gamma1_img./(1-kappa_img);
i1_rg2=gamma2_img./(1-kappa_img);
i1_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i1_mag=posify(i1_mag);
i1_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i1_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i1_img_cnt=img;
i1_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i1_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i1_src_cnt=reshape(counts_src,N_img*4,1);
num=1;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% getting results for i2
load i2_remap.mat
i2_rg1=gamma1_img./(1-kappa_img);
i2_rg2=gamma2_img./(1-kappa_img);
i2_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i2_mag=posify(i2_mag);
i2_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i2_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i2_img_cnt=img;
i2_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i2_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i2_src_cnt=reshape(counts_src,N_img*4,1);
num=2;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% getting results for i3
load i3_remap.mat
i3_rg1=gamma1_img./(1-kappa_img);
i3_rg2=gamma2_img./(1-kappa_img);
i3_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i3_mag=posify(i3_mag);
i3_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i3_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i3_img_cnt=img;
i3_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i3_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i3_src_cnt=reshape(counts_src,N_img*4,1);
num=3;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% getting results for i4
load i4_remap.mat
i4_rg1=gamma1_img./(1-kappa_img);
i4_rg2=gamma2_img./(1-kappa_img);
i4_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i4_mag=posify(i4_mag);
i4_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i4_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i4_img_cnt=img;
i4_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i4_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i4_src_cnt=reshape(counts_src,N_img*4,1);
num=4;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% getting results for i5
load i5_remap.mat
i5_rg1=gamma1_img./(1-kappa_img);
i5_rg2=gamma2_img./(1-kappa_img);
i5_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i5_mag=posify(i5_mag);
i5_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i5_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i5_img_cnt=img;
i5_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i5_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i5_src_cnt=reshape(counts_src,N_img*4,1);
num=5;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

%% color and linewidth schemes
lab_fontsize =12; axes_fontsize =10;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

%% the remapped images in src plane
figure(1)  
scatter(i1_src_ra,i1_src_dec,3,i1_src_cnt)
hold on
scatter(i2_src_ra,i2_src_dec,3,i2_src_cnt)
scatter(i3_src_ra,i3_src_dec,3,i3_src_cnt)
scatter(i4_src_ra,i4_src_dec,3,i4_src_cnt)
scatter(i5_src_ra,i5_src_dec,3,i5_src_cnt)
colormap('jet');
plot(src_ctr(:,1),src_ctr(:,2),'ko','MarkerSize',15,'LineWidth',2)
hold off
for i=1:num_img
    text(src_ctr(i,1),src_ctr(i,2)+1,['i',num2str(i),' src'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 i-system w.r.t. the reference pixel''s RA/DEC')
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
print -dpsc2 src_tot.ps;


%% the original HST images in lens plane
figure(2)  
scatter(i1_img_ra,i1_img_dec,3,i1_img_cnt)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_img_cnt)
scatter(i3_img_ra,i3_img_dec,3,i3_img_cnt)
scatter(i4_img_ra,i4_img_dec,3,i4_img_cnt)
scatter(i5_img_ra,i5_img_dec,3,i5_img_cnt)
colormap('jet');
plot(img_center(:,1),img_center(:,2),'ks','MarkerSize',10,'LineWidth',1)
hold off
for i=1:num_img
    text(img_center(i,1),img_center(i,2)+3,['i',num2str(i),' img'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 i-system w.r.t. the reference pixel''s RA/DEC')
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
print -dpsc2 img_tot.ps;


%% plotting the reduced shear vector map   ->  this should go into _single.m later
num=5;
figure(3)
quiver(i5_img_ra,i5_img_dec,i5_rg1,i5_rg2)
hold on
plot(img_center(num,1),img_center(num,2),'ks','MarkerSize',10,'LineWidth',1)
hold off
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 i5_ reduced shear whisker at the lens plane')

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
axis tight
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 i5_rgvec.ps;



%--------------------------- below are dropouts ---------------------------
% %% reduced shear g1 on img plane
% figure(2)  
% scatter(i1_img_ra,i1_img_dec,3,i1_rg1)
% hold on
% scatter(i2_img_ra,i2_img_dec,3,i2_rg1)
% % scatter(i3_img_ra,i3_img_dec,3,i3_rg1)
% scatter(i4_img_ra,i4_img_dec,3,i4_rg1)
% scatter(i5_img_ra,i5_img_dec,3,i5_rg1)
% hold off
% colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% % xlim([206.865 206.89]);
% 
% text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
% text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
% text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
% text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)
% 
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('reduced shear g_1','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% set(gcf, 'PaperUnits','inches');
% set(gcf, 'PaperPosition',[ 0 0 8 6]);
% print -dpsc2 img_totno3_rg1.ps;


% %% reduced shear g2 on img plane
% figure(3)  
% scatter(i1_img_ra,i1_img_dec,3,i1_rg2)
% hold on
% scatter(i2_img_ra,i2_img_dec,3,i2_rg2)
% % scatter(i3_img_ra,i3_img_dec,3,i3_rg2)
% scatter(i4_img_ra,i4_img_dec,3,i4_rg2)
% scatter(i5_img_ra,i5_img_dec,3,i5_rg2)
% hold off
% colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% % xlim([206.865 206.89]);
% 
% text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
% text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
% text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
% text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)
% 
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('reduced shear g_2','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% set(gcf, 'PaperUnits','inches');
% set(gcf, 'PaperPosition',[ 0 0 8 6]);
% print -dpsc2 img_totno3_rg2.ps;


% %% reduced magnification on img plane
% figure(4)  
% scatter(i1_img_ra,i1_img_dec,3,i1_mag)
% hold on
% scatter(i2_img_ra,i2_img_dec,3,i2_mag)
% % scatter(i3_img_ra,i3_img_dec,3,i3_mag)
% scatter(i4_img_ra,i4_img_dec,3,i4_mag)
% scatter(i5_img_ra,i5_img_dec,3,i5_mag)
% hold off
% colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% % xlim([206.865 206.89]);
% 
% text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
% text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
% text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
% text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)
% 
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('magnification','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% set(gcf, 'PaperUnits','inches');
% set(gcf, 'PaperPosition',[ 0 0 8 6]);
% print -dpsc2 img_totno3_mag.ps;


% %% especially for the bad boy i3
% figure(5)
% 
% subplot(3,1,1);
% scatter(i3_img_ra,i3_img_dec,3,i3_rg1)
% colormap('jet');
% % xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse','xticklabel',[]); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('reduced shear g_1','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% subplot(3,1,2);
% scatter(i3_img_ra,i3_img_dec,3,i3_rg2)
% colormap('jet');
% % xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse','xticklabel',[]); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('reduced shear g_2','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% subplot(3,1,3);
% scatter(i3_img_ra,i3_img_dec,3,i3_mag)
% colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
% ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
% ax = gca;
% hbar = colorbar('EastOutside');
% axes(hbar);
% ylabel('magnification','FontSize',lab_fontsize);
% set(gca,'FontSize',axes_fontsize);
% axes(ax);
% 
% subplot(3,1,3);
% set(gca,'position',[0.1,0.08,0.7,0.299])
% subplot(3,1,2);
% set(gca,'position',[0.1,0.38,0.7,0.299])
% subplot(3,1,1);
% set(gca,'position',[0.1,0.68,0.7,0.299])
% 
% set(gcf, 'PaperUnits','inches');
% set(gcf, 'PaperPosition',[ 0 0 9 9]);
% print -dpsc2 img_i3_all.ps;