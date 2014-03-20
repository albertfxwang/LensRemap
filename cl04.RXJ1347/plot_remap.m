% plotting the remapped images repeatedly

clear all; clc; tic

% color and linewidth schemes
lab_fontsize =13; axes_fontsize =10;
color = {'y','r','m','g','c','k','b'};
solid = {'-b','-r','-m','-g','-c','-k','-y'};
dot = {':b',':r',':m',':g',':c',':k'};
dash = {'--b','--r','--m','--g','--c','--k'};
lw1=2.5; lw2=1.7; lw3=0.8;

% getting results for i1
load i1_remap.mat
i1_rg1=gamma1_img./(1-kappa_img);
i1_rg2=gamma2_img./(1-kappa_img);
i1_mag=1./((1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2)));
i1_img_ra=img_ra;
i1_img_dec=img_dec;
i1_src_ra=reshape(RA4_src,N_img*4,1);
i1_src_dec=reshape(DEC4_src,N_img*4,1);
i1_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i2
load i2_remap.mat
i2_rg1=gamma1_img./(1-kappa_img);
i2_rg2=gamma2_img./(1-kappa_img);
i2_mag=1./((1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2)));
i2_img_ra=img_ra;
i2_img_dec=img_dec;
i2_src_ra=reshape(RA4_src,N_img*4,1);
i2_src_dec=reshape(DEC4_src,N_img*4,1);
i2_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i3
load i3_remap.mat
i3_rg1=gamma1_img./(1-kappa_img);
i3_rg2=gamma2_img./(1-kappa_img);
i3_mag=1./((1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2)));
i3_img_ra=img_ra;
i3_img_dec=img_dec;
i3_src_ra=reshape(RA4_src,N_img*4,1);
i3_src_dec=reshape(DEC4_src,N_img*4,1);
i3_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i4
load i4_remap.mat
i4_rg1=gamma1_img./(1-kappa_img);
i4_rg2=gamma2_img./(1-kappa_img);
i4_mag=1./((1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2)));
i4_img_ra=img_ra;
i4_img_dec=img_dec;
i4_src_ra=reshape(RA4_src,N_img*4,1);
i4_src_dec=reshape(DEC4_src,N_img*4,1);
i4_src_cnt=reshape(counts_src,N_img*4,1);

% getting results for i5
load i5_remap.mat
i5_rg1=gamma1_img./(1-kappa_img);
i5_rg2=gamma2_img./(1-kappa_img);
i5_mag=1./((1-kappa_img.^2-(gamma1_img.^2+gamma2_img.^2)));
i5_img_ra=img_ra;
i5_img_dec=img_dec;
i5_src_ra=reshape(RA4_src,N_img*4,1);
i5_src_dec=reshape(DEC4_src,N_img*4,1);
i5_src_cnt=reshape(counts_src,N_img*4,1);

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
xlabel('RA','FontSize',lab_fontsize);
ylabel('DEC','FontSize',lab_fontsize);
xlim([206.86 206.9]);
ylim([-11.757 -11.754]);

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('counts','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
% print -dpsc2 i5_src.ps;


%% reduced shear g1 on img plane
figure(2)  
scatter(i1_img_ra,i1_img_dec,3,i1_rg1)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_rg1)
scatter(i3_img_ra,i3_img_dec,3,i3_rg1)
scatter(i4_img_ra,i4_img_dec,3,i4_rg1)
scatter(i5_img_ra,i5_img_dec,3,i5_rg1)
hold off
colormap('jet');
xlabel('RA','FontSize',lab_fontsize);
ylabel('DEC','FontSize',lab_fontsize);
xlim([206.865 206.89]);

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_1','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);


%% reduced shear g2 on img plane
figure(3)  
scatter(i1_img_ra,i1_img_dec,3,i1_rg2)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_rg2)
scatter(i3_img_ra,i3_img_dec,3,i3_rg2)
scatter(i4_img_ra,i4_img_dec,3,i4_rg2)
scatter(i5_img_ra,i5_img_dec,3,i5_rg2)
hold off
colormap('jet');
xlabel('RA','FontSize',lab_fontsize);
ylabel('DEC','FontSize',lab_fontsize);
xlim([206.865 206.89]);

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylabel('reduced shear g_2','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);


%% reduced shear g1 on img plane

mag_lims=([0 max(max(i1_mag),max(i2_mag),max(i3_mag),max(i4_mag),max(i5_mag))]);

figure(4)  
scatter(i1_img_ra,i1_img_dec,3,i1_mag)
hold on
scatter(i2_img_ra,i2_img_dec,3,i2_mag)
scatter(i3_img_ra,i3_img_dec,3,i3_mag)
scatter(i4_img_ra,i4_img_dec,3,i4_mag)
scatter(i5_img_ra,i5_img_dec,3,i5_mag)
hold off
colormap('jet');
xlabel('RA','FontSize',lab_fontsize);
ylabel('DEC','FontSize',lab_fontsize);
xlim([206.865 206.89]);

set(gca,'FontSize',axes_fontsize,'LineWidth',1.3,'XDir','Reverse'); 
ax = gca;
hbar = colorbar('EastOutside');
axes(hbar);
ylim(hbar,mag_lims)
ylabel('magnification','FontSize',lab_fontsize);
set(gca,'FontSize',axes_fontsize);
axes(ax);

set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);


