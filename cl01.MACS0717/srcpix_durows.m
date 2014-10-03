% Plot the pre-/post-tweak idvd and combined images in pixelized src plane
% in two separate rows to appear in Tucker's paper
%<<<141001>>> Copy the entire content from "srcpix_conJrot_totsys.m" 

clear all; clc; tic

addpath ../mscripts/
PlotParams;

sys= '14';
axial_range= macs0717.sys14ar;

mat_dir= 'z1.855_sharon_deflect';      % the folder containing .mat files
mat_extsn='_deflect.mat';
corrdefl_dir=  'CorrDefl_imgF140W_z1.855_sharon/durows';
diary(fullfile(corrdefl_dir,[sys,'_durows_fin.diary']));
pic_name=[sys '_durows_fin.eps'];

LMtot = importdata('z1.855_sharon_LMkgphi.dat', ' ', 2);
LMvals = LMtot.data(:,2:end);
LMnames= LMtot.data(:,1);

num_img=3;
%------------ the center of src plane img, 1st column: a, 2nd column: b
src_ctr=zeros(num_img,2);

fprintf('----------------------------------------------------------\n')
fprintf(['|  This is the diary for plotting ',pic_name,'!    |\n'])
fprintf(['|  Now we are working on MACS0717 - srcpix for totsys ',sys,'! |\n'])
fprintf('----------------------------------------------------------\n')

%------------ the pixel scale of the RGB img given by the Python command
% fitstools.get_pixscale('MACS0717_F814WF105WF140W_R.fits')  already in unit of arcsec!!!
img_pixscale=0.049999997703084283;

%------------ the 1-over-ratio for src_pixscale, 1st column: a, 2nd column: b, 
% the ordering of rows follow their names, not their appearances, which are denoted by img0->1->2...
scale=[2.0 2.0; 1.3 1.6; 2.4 1.2];  scale_tot=[2.4 2.4];

% *NOTE: the scale for totsys can be much higher than individual img
img0=2;  img1=3;  img2=1;

%------------ the con-Jacobi matrix parameters for the correct tweak 
img1_conJ=struct('a',-1.3,'b',0.0,'c',-0.2,'d',NaN);
img2_conJ=struct('a',0.8,'b',-0.35,'c',0.28,'d',NaN);

%------------ set the handle for plotting
h=figure(1); num_colm=num_img+1;

%% Get remapped results for each img and plot the img before and after my tweak
%-------------------------------------------------------------------------------
% first of all, srcpix the img which has the smallest magnification
num=img0;

fprintf(['\n#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
%------------ load the .mat file
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

src_a=  reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src_b=  reshape(DEC0_src,N_img,1)*3600.;       % b
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
%%%%------------ a,b_ref set to be ctr_a,b of the target img
ref_a=  ctr_a;
ref_b=  ctr_b;
%------------ records the indices of which src plane pixels cnts go into
indx_a = zeros(N_img,1);
indx_b = zeros(N_img,1);

%%------------ set up the common ctr for all img
ctr_common=[src_ctr(num,1) src_ctr(num,2)];

%%%------------ saving data for the combined subplot
img0_N=N_img;
img0_src_a=src_a;
img0_src_b=src_b;
img0_src_cnt=src_cnt;

[vec_a,N_a]= MakeVecCtr(src_a,src_ctr(num,1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,src_ctr(num,2),binsize_b);
src_cnt_pix= zeros(N_b,N_a);
times_pix=   zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a=  abs(vec_a-src_a(i));
    absdiff_b=  abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix0_SB= src_cnt_pix./times_pix;
srcpix0_da= vec_a-ref_a;
srcpix0_db= vec_b-ref_b;
% here the number in variable names has nothing to do with the value of "num". same thing below

%------------ sub-plotting      post
subplot(2,num_colm,num+num_colm);
imagescwithnan(srcpix0_da,srcpix0_db,srcpix0_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
xlabel('arcseconds','FontSize',lab_fontsize);
title(['corrected arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

%------------ sub-plotting      pre
subplot(2,num_colm,num);
imagescwithnan(srcpix0_da,srcpix0_db,srcpix0_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
title(['original arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);


%% srcpix another img
num=img1;
conJnod=img1_conJ;

fprintf(['\n#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
%------------ calc the con-Jacobian matrix and real values for all lensing quantities
imgname=str2double([sys '.' num2str(num)]);
indx=find(ismember(LMnames,imgname));
km=LMvals(indx,1);
gm=LMvals(indx,2);
phim=LMvals(indx,3);
lens_model=struct('kappa',km,'gamma',gm,'phi',phim);
ratioq=calcq(lens_model);
conJparam=update_d(ratioq,conJnod);
lens_real=calcReal_kgphi(lens_model,ratioq,conJparam);
%------------ load the .mat file
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

src0_a= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src0_b= reshape(DEC0_src,N_img,1)*3600.;       % b
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
%------------ records the indices of which src plane pixels cnts go into
indx_a = zeros(N_img,1);
indx_b = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_a,src1_b]= shift(src0_a,src0_b,src_ctr(num,:),ctr_common);
%%------------ con-Jacobi rotating img
[src_a,src_b]=   conJacobiRot(src1_a,src1_b,ctr_common,conJparam);
%%%------------ saving data for the combined subplot
img1_N=N_img;
img1_src_a=src_a;
img1_src_b=src_b;
img1_src_cnt=src_cnt;

%-------------------------------------------------------------------------------
% the following subsection is for post-tweak img
[vec_a,N_a]= MakeVecCtr(src_a,ctr_common(1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,ctr_common(2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix1_SB= src_cnt_pix./times_pix;    
srcpix1_da= vec_a-ref_a;
srcpix1_db= vec_b-ref_b;

%------------ sub-plotting      post
subplot(2,num_colm,num+num_colm);
imagescwithnan(srcpix1_da,srcpix1_db,srcpix1_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
xlabel('arcseconds','FontSize',lab_fontsize);
title(['corrected arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

%-------------------------------------------------------------------------------
% the following subsection is for pre-tweak img
src_a=src0_a;
src_b=src0_b;
[vec_a,N_a]= MakeVecCtr(src_a,src_ctr(num,1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,src_ctr(num,2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix1_SB= src_cnt_pix./times_pix;    
srcpix1_da= vec_a-ref_a;
srcpix1_db= vec_b-ref_b;

%------------ sub-plotting      pre
subplot(2,num_colm,num);
imagescwithnan(srcpix1_da,srcpix1_db,srcpix1_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
title(['original arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);


%% srcpix another img
num=img2;
conJnod=img2_conJ;

fprintf(['\n#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
%------------ calc the con-Jacobian matrix and real values for all lensing quantities
imgname=str2double([sys '.' num2str(num)]);
indx=find(ismember(LMnames,imgname));
km=LMvals(indx,1);
gm=LMvals(indx,2);
phim=LMvals(indx,3);
lens_model=struct('kappa',km,'gamma',gm,'phi',phim);
ratioq=calcq(lens_model);
conJparam=update_d(ratioq,conJnod);
lens_real=calcReal_kgphi(lens_model,ratioq,conJparam);
%------------ load the .mat file
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

src0_a= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src0_b= reshape(DEC0_src,N_img,1)*3600.;       % b 
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
%------------ records the indices of which src plane pixels cnts go into
indx_a = zeros(N_img,1);
indx_b = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_a,src1_b]= shift(src0_a,src0_b,src_ctr(num,:),ctr_common);
%%------------ con-Jacobi rotating img
[src_a,src_b]=   conJacobiRot(src1_a,src1_b,ctr_common,conJparam);
%%%------------ saving data for the combined subplot
img2_N=N_img;
img2_src_a=src_a;
img2_src_b=src_b;
img2_src_cnt=src_cnt;

%-------------------------------------------------------------------------------
% the following subsection is for post-tweak img
[vec_a,N_a]= MakeVecCtr(src_a,ctr_common(1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,ctr_common(2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix2_SB = src_cnt_pix./times_pix;    
srcpix2_da= vec_a-ref_a;
srcpix2_db= vec_b-ref_b;

%------------ sub-plotting      post
subplot(2,num_colm,num+num_colm);
imagescwithnan(srcpix2_da,srcpix2_db,srcpix2_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
xlabel('arcseconds','FontSize',lab_fontsize);
ylabel('arcseconds','FontSize',lab_fontsize);
title(['corrected arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

%-------------------------------------------------------------------------------
% the following subsection is for pre-tweak img
src_a=src0_a;
src_b=src0_b;
[vec_a,N_a]=MakeVecCtr(src_a,src_ctr(num,1),binsize_a);
[vec_b,N_b]=  MakeVecCtr(src_b,src_ctr(num,2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix2_SB = src_cnt_pix./times_pix;    
srcpix2_da= vec_a-ref_a;
srcpix2_db= vec_b-ref_b;

%------------ sub-plotting      pre
subplot(2,num_colm,num);
imagescwithnan(srcpix2_da,srcpix2_db,srcpix2_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
ylabel('arcseconds','FontSize',lab_fontsize);
title(['original arc ',sys,'.',num2str(num)]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);


%% subplotting the combined pixelized src plane img
fprintf(['\n#------------------------ below doing srcpix for totsys ',sys,'!\n'])
%------------ set up ranges in a,b using macs0717.sys-ar
a_range= axial_range(1:2)+ref_a;
b_range= axial_range(3:4)+ref_b;

binsize_a= img_pixscale/scale_tot(1);
binsize_b= img_pixscale/scale_tot(2);
[vec_a,N_a]=MakeVecCtr(a_range,ctr_common(1),binsize_a);
[vec_b,N_b]=MakeVecCtr(b_range,ctr_common(2),binsize_b);
src_cnt_pix=zeros(N_b,N_a);
times_pix=  zeros(N_b,N_a);
for i=1:img0_N
    absdiff_a= abs(vec_a-img0_src_a(i));
    absdiff_b= abs(vec_b-img0_src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+img0_src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
for i=1:img1_N
    absdiff_a= abs(vec_a-img1_src_a(i));
    absdiff_b= abs(vec_b-img1_src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+img1_src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
for i=1:img2_N
    absdiff_a= abs(vec_a-img2_src_a(i));
    absdiff_b= abs(vec_b-img2_src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('>>>WARN: this point sitting on boundary: i=%d\n',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+img2_src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix_tot_SB= src_cnt_pix./times_pix;    
srcpix_tot_da= vec_a-ref_a;
srcpix_tot_db= vec_b-ref_b;

%------------ sub-plotting
subplot(2,num_colm,num_colm*2);
imagescwithnan(srcpix_tot_da,srcpix_tot_db,srcpix_tot_SB,jet,[1 1 1],true)
axis xy
colorbar('off')
colormap(flipud(gray))
xlabel('arcseconds','FontSize',lab_fontsize);
title(['combined arc ',sys]);
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);


%% over-plottiong SB isophote contours on every panel except the one of # num_colm
da_up=2; db_up=2;
sb_isophote=[75, 120, 170];
% sb_contour1=contourc(srcpix_tot_da,srcpix_tot_db,srcpix_tot_SB,[sb_isophote(1) sb_isophote(1)]);
sb_contour2=contourc(srcpix_tot_da,srcpix_tot_db,srcpix_tot_SB,[sb_isophote(2) sb_isophote(2)]);
% sb_contour3=contourc(srcpix_tot_da,srcpix_tot_db,srcpix_tot_SB,[sb_isophote(3) sb_isophote(3)]);
% indx1=find(sb_contour1(1,:)<da_up & sb_contour1(2,:)<db_up);
indx2=find(sb_contour2(1,:)<da_up & sb_contour2(2,:)<db_up);
% indx3=find(sb_contour3(1,:)<da_up & sb_contour3(2,:)<db_up);

for j=1:num_colm*2
    if j~=num_colm
        subplot(2,num_colm,j);
        hold on
%         plot(sb_contour1(1,indx1),sb_contour1(2,indx1),solid{2},'LineWidth',lw3)
        plot(sb_contour2(1,indx2),sb_contour2(2,indx2),solid{2},'LineWidth',lw3)
%         plot(sb_contour3(1,indx3),sb_contour3(2,indx3),solid{2},'LineWidth',lw3)
        hold off
    end
end

% subplot(2,num_colm,num_colm*2);       so sad I spent some time tuning this
% hold on
% text(0.1,2.2,'source plane reconstruction given by','HorizontalAlignment','center','FontSize',9)
% text(0.1,1.95,'top row: the original lens model','HorizontalAlignment','center','FontSize',9)
% text(0.1,1.7,'bottom row: the corrected lens model','HorizontalAlignment','center','FontSize',9)
% hold off

%% end-up work for the figure
tightfig(h);
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 9 4.5]);

% print(h,'-dpsc2',fullfile(corrdefl_dir,pic_name));
print(h,'-depsc2',fullfile(corrdefl_dir,pic_name));
toc
diary off

%----------------------------- no use anymore ----------------------------------%
% leg_end = legend(['\kappa_{ext}=',num2str(jacobi_1.kappa)],['|\gamma_{ext}|=',num2str(jacobi_1.gamma)],...
%     ['\phi=',num2str(jacobi_1.phi)],3);
% set(leg_end,'Box','off','FontSize',axes_fontsize);

%<<<141001>>> ------------ the part of writing _truedefl.dat files
% flag_wrtTDdat = false;
% corrdefl_extsn= '_truedefl.dat';
% if flag_wrtTDdat
% %%%%------------ write corrdefl ASCII file
% alpha_src=src_a/3600./cos(ref_dec/180.*pi);
% delta_src=src_b/3600.;
% truedefl_1=(alpha_src-img_ra)*60.*cos(ref_dec/180.*pi);
% truedefl_2=(img_dec-delta_src)*60.;
% truedefl=[truedefl_1 truedefl_2];
% 
% fid=fopen((fullfile(corrdefl_dir,[sys '.' num2str(num) corrdefl_extsn])),'wt');
% fprintf(fid,'#-------------------------------------------------------------------------------\n');
% fprintf(fid,'# RA\t\t DEC\t\n');
% fprintf(fid,'%12.7f\t %12.7f\n',img_ctr(1),img_ctr(2));
% fprintf(fid,'#-------------------------------------------------------------------------------\n');
% fprintf(fid,'# alpha_1,true\t alpha_2,true\n');
% fprintf(fid,'%12.7f\t %12.7f\n',truedefl');
% fclose(fid);
% end



