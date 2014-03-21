% plotting the remapped images repeatedly
% NOTE: set(gcf, 'PaperPosition',[ 0 0 8 6]) fits my laptop screen better, while [ 0 0 9 7] fits larger screen better

clear all; clc; tic

% color and linewidth schemes
lab_fontsize =12; axes_fontsize =10;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

% HST image's reference pixel's WCS coord
ref_ra=206.901315235;       % $ imhead RXJ1347-1145_fullres_G.fits | grep CRVAL1
ref_dec=-11.7542487671;     % $ imhead RXJ1347-1145_fullres_G.fits | grep CRVAL2

% getting results for i1
load i1_remap.mat
i1_rg1=gamma1_img./(1-kappa_img);
i1_rg2=gamma2_img./(1-kappa_img);
i1_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i1_mag=posify(i1_mag);
i1_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i1_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i1_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i1_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i1_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i2
load i2_remap.mat
i2_rg1=gamma1_img./(1-kappa_img);
i2_rg2=gamma2_img./(1-kappa_img);
i2_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i2_mag=posify(i2_mag);
i2_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i2_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i2_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i2_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i2_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i3
load i3_remap.mat
i3_rg1=gamma1_img./(1-kappa_img);
i3_rg2=gamma2_img./(1-kappa_img);
i3_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i3_mag=posify(i3_mag);
i3_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i3_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i3_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i3_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i3_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i4
load i4_remap.mat
i4_rg1=gamma1_img./(1-kappa_img);
i4_rg2=gamma2_img./(1-kappa_img);
i4_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i4_mag=posify(i4_mag);
i4_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i4_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i4_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i4_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i4_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i5
load i5_remap.mat
i5_rg1=gamma1_img./(1-kappa_img);
i5_rg2=gamma2_img./(1-kappa_img);
i5_mag=1./(1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2));
% i5_mag=posify(i5_mag);
i5_img_ra=(img_ra-ref_ra)*3600.;     % RA in arcsec
i5_img_dec=(img_dec-ref_dec)*3600.;  % DEC in arcsec
i5_src_ra=(reshape(RA4_src,N_img*4,1)-ref_ra)*3600.;     % RA in arcsec
i5_src_dec=(reshape(DEC4_src,N_img*4,1)-ref_dec)*3600.;  % DEC in arcsec
i5_src_cnt=reshape(counts_src,N_img*4,1);

%% calc positions for text labels

lab_i1src_ra=0.5*(min(i1_src_ra)+max(i1_src_ra))+2;
lab_i1src_dec=max(i1_src_dec)+0.5;
lab_i2src_ra=0.5*(min(i2_src_ra)+max(i2_src_ra))+2;
lab_i2src_dec=max(i2_src_dec)+0.5;
lab_i3src_ra=0.5*(min(i3_src_ra)+max(i3_src_ra))+2;
lab_i3src_dec=max(i3_src_dec)+0.5;
lab_i4src_ra=0.5*(min(i4_src_ra)+max(i4_src_ra))+2;
lab_i4src_dec=max(i4_src_dec)+0.5;
lab_i5src_ra=0.5*(min(i5_src_ra)+max(i5_src_ra))+2;
lab_i5src_dec=max(i5_src_dec)+0.5;

lab_i1img_ra=0.5*(min(i1_img_ra)+max(i1_img_ra))+2;
lab_i1img_dec=max(i1_img_dec)+1;
lab_i2img_ra=0.5*(min(i2_img_ra)+max(i2_img_ra))+2;
lab_i2img_dec=max(i2_img_dec)+1;
lab_i3img_ra=0.5*(min(i3_img_ra)+max(i3_img_ra))+2;
lab_i3img_dec=max(i3_img_dec)+1;
lab_i4img_ra=0.5*(min(i4_img_ra)+max(i4_img_ra))+2;
lab_i4img_dec=max(i4_img_dec)+1;
lab_i5img_ra=0.5*(min(i5_img_ra)+max(i5_img_ra))+2;
lab_i5img_dec=max(i5_img_dec)+1;

%% the remapped images in src plane
figure(1)  
scatter(i1_src_ra,i1_src_dec,3,i1_src_cnt)
hold on
scatter(i2_src_ra,i2_src_dec,3,i2_src_cnt)
scatter(i3_src_ra,i3_src_dec,3,i3_src_cnt)
scatter(i4_src_ra,i4_src_dec,3,i4_src_cnt)
scatter(i5_src_ra,i5_src_dec,3,i5_src_cnt)
hold off
colormap('jet');
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% xlim([206.86 206.9]);
% ylim([-11.757 -11.754]);

text(lab_i1src_ra,lab_i1src_dec,'i1 src','FontSize',13)
text(lab_i2src_ra,lab_i2src_dec,'i2 src','FontSize',13)
text(lab_i3src_ra,lab_i3src_dec,'i3 src','FontSize',13)
text(lab_i4src_ra,lab_i4src_dec,'i4 src','FontSize',13)
text(lab_i5src_ra,lab_i5src_dec,'i5 src','FontSize',13)

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 src_tot.ps;


%% reduced shear g1 on img plane
figure(2)  
scatter(i1_img_ra,i1_img_dec,3,i1_rg1)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_rg1)
% scatter(i3_img_ra,i3_img_dec,3,i3_rg1)
scatter(i4_img_ra,i4_img_dec,3,i4_rg1)
scatter(i5_img_ra,i5_img_dec,3,i5_rg1)
hold off
colormap('jet');
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% xlim([206.865 206.89]);

text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_1','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 img_totno3_rg1.ps;


%% reduced shear g2 on img plane
figure(3)  
scatter(i1_img_ra,i1_img_dec,3,i1_rg2)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_rg2)
% scatter(i3_img_ra,i3_img_dec,3,i3_rg2)
scatter(i4_img_ra,i4_img_dec,3,i4_rg2)
scatter(i5_img_ra,i5_img_dec,3,i5_rg2)
hold off
colormap('jet');
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% xlim([206.865 206.89]);

text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_2','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 img_totno3_rg2.ps;


%% reduced shear g1 on img plane
figure(4)  
scatter(i1_img_ra,i1_img_dec,3,i1_mag)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_mag)
% scatter(i3_img_ra,i3_img_dec,3,i3_mag)
scatter(i4_img_ra,i4_img_dec,3,i4_mag)
scatter(i5_img_ra,i5_img_dec,3,i5_mag)
hold off
colormap('jet');
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
% xlim([206.865 206.89]);

text(lab_i1img_ra,lab_i1img_dec,'i1 img','FontSize',13)
text(lab_i2img_ra,lab_i2img_dec,'i2 img','FontSize',13)
text(lab_i4img_ra,lab_i4img_dec,'i4 img','FontSize',13)
text(lab_i5img_ra,lab_i5img_dec,'i5 img','FontSize',13)

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('magnification','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print -dpsc2 img_totno3_mag.ps;


%% especially for the bad boy i3
figure(5)

subplot(3,1,1);
scatter(i3_img_ra,i3_img_dec,3,i3_rg1)
colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse','xticklabel',[]); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_1','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

subplot(3,1,2);
scatter(i3_img_ra,i3_img_dec,3,i3_rg2)
colormap('jet');
% xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse','xticklabel',[]); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_2','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

subplot(3,1,3);
scatter(i3_img_ra,i3_img_dec,3,i3_mag)
colormap('jet');
xlabel('RA offset [arcsec]','FontSize',lab_fontsize);
ylabel('DEC offset [arcsec]','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('magnification','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

subplot(3,1,3);
set(gca,'position',[0.1,0.08,0.7,0.299])
subplot(3,1,2);
set(gca,'position',[0.1,0.38,0.7,0.299])
subplot(3,1,1);
set(gca,'position',[0.1,0.68,0.7,0.299])

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 9 9]);
print -dpsc2 img_i3_all.ps;



