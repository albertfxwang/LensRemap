% plotting the remapped images repeatedly for one system
% NOTE: set(gcf, 'PaperPosition',[ 0 0 8 6]) fits my laptop screen better, while [ 0 0 9 7] fits larger screen better

clear all; clc; tic

num_img=2;
img_center=zeros(num_img,2);   % 1st column: RA. 2nd column: DEC.
src_ctr=zeros(num_img,2);

% getting results for a1_
load a1_G_remap.mat
a1_rg1=gamma1_img./(1-kappa_img);
a1_rg2=gamma2_img./(1-kappa_img);
a1_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% a1_mag=posify(a1_mag);
a1_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
a1_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
a1_img_cnt=img;
a1_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
a1_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
a1_src_cnt=reshape(counts_src,N_img*4,1);
num=1;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% getting results for a2_
load a2_G_remap.mat
a2_rg1=gamma1_img./(1-kappa_img);
a2_rg2=gamma2_img./(1-kappa_img);
a2_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% a2_mag=posify(a2_mag);
a2_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
a2_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
a2_img_cnt=img;
a2_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
a2_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
a2_src_cnt=reshape(counts_src,N_img*4,1);
num=2;
img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

% % getting results for i3_
% load i3_G_remap.mat
% i3_rg1=gamma1_img./(1-kappa_img);
% i3_rg2=gamma2_img./(1-kappa_img);
% i3_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% % i3_mag=posify(i3_mag);
% i3_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
% i3_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
% i3_img_cnt=img;
% i3_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
% i3_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
% i3_src_cnt=reshape(counts_src,N_img*4,1);
% num=3;
% img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
% img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
% src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
% src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;
% 
% % getting results for i4_
% load i4_G_remap.mat
% i4_rg1=gamma1_img./(1-kappa_img);
% i4_rg2=gamma2_img./(1-kappa_img);
% i4_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% % i4_mag=posify(i4_mag);
% i4_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
% i4_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
% i4_img_cnt=img;
% i4_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
% i4_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
% i4_src_cnt=reshape(counts_src,N_img*4,1);
% num=4;
% img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
% img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
% src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
% src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;
% 
% % getting results for i5_
% load i5_G_remap.mat
% i5_rg1=gamma1_img./(1-kappa_img);
% i5_rg2=gamma2_img./(1-kappa_img);
% i5_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% % i5_mag=posify(i5_mag);
% i5_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
% i5_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
% i5_img_cnt=img;
% i5_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
% i5_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
% i5_src_cnt=reshape(counts_src,N_img*4,1);
% num=5;
% img_center(num,1)=(img_ctr(2,1)-ref_ra)*3600.;
% img_center(num,2)=(img_ctr(2,2)-ref_dec)*3600.;
% src_ctr(num,1)=(ctr_ra-ref_ra)*3600.;
% src_ctr(num,2)=(ctr_dec-ref_dec)*3600.;

%% color and linewidth schemes
lab_fontsize =12; axes_fontsize =10;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

%% the remapped images in src plane
figure(1)  
scatter(a1_src_ra,a1_src_dec,3,a1_src_cnt)
hold on
scatter(a2_src_ra,a2_src_dec,3,a2_src_cnt)
% scatter(i3_src_ra,i3_src_dec,3,i3_src_cnt)
% scatter(i4_src_ra,i4_src_dec,3,i4_src_cnt)
% scatter(i5_src_ra,i5_src_dec,3,i5_src_cnt)
colormap('jet');
plot(src_ctr(:,1),src_ctr(:,2),'ko','MarkerSize',15,'LineWidth',2)
hold off
for i=1:num_img
    text(src_ctr(i,1),src_ctr(i,2)+1,['a',num2str(i),' src'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 a-system w.r.t. the reference pixel''s RA/DEC')
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
print -dpsc2 atot_G_src.ps;


%% the original HST images in lens plane
figure(2)  
scatter(a1_img_ra,a1_img_dec,3,a1_img_cnt)
hold on
scatter(a2_img_ra,a2_img_dec,3,a2_img_cnt)
% scatter(i3_img_ra,i3_img_dec,3,i3_img_cnt)
% scatter(i4_img_ra,i4_img_dec,3,i4_img_cnt)
% scatter(i5_img_ra,i5_img_dec,3,i5_img_cnt)
colormap('jet');
plot(img_center(:,1),img_center(:,2),'ks','MarkerSize',10,'LineWidth',1)
hold off
for i=1:num_img
    text(img_center(i,1),img_center(i,2)+3,['a',num2str(i),' img'],...
        'HorizontalAlignment','center','FontSize',axes_fontsize)
end

xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
title('RXJ1347 a-system w.r.t. the reference pixel''s RA/DEC')
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
print -dpsc2 atot_G_img.ps;

%--------------------------- below are dropouts ---------------------------
% %% reduced shear g1 on img plane
% figure(2)  
% scatter(a1_img_ra,a1_img_dec,3,a1_rg1)
% hold on
% scatter(a2_img_ra,a2_img_dec,3,a2_rg1)
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
% scatter(a1_img_ra,a1_img_dec,3,a1_rg2)
% hold on
% scatter(a2_img_ra,a2_img_dec,3,a2_rg2)
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
% scatter(a1_img_ra,a1_img_dec,3,a1_mag)
% hold on
% scatter(a2_img_ra,a2_img_dec,3,a2_mag)
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
