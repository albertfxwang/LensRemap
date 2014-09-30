
%%----------------------- below are dropouts from plot_remap_totsys.m -----------------------
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
% 0.5
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
% hbar = colorbar(0.5'EastOutside');
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