% pixelize the src plane in terms of all multiple images within one system
%<<<140811>>> Changed all variable names to my updated naming conventions
%<<<140924>>> Use _antiJacobiRot_ instead of _JacobiRot_ to do the tweak

clear all; clc; tic

addpath ../mscripts/
PlotParams;

sys= '3';
axial_range= macs0717.sys3ar;
mat_dir= 'z1.855_sharon_deflect';      % the folder containing .mat files
mat_extsn='_deflect.mat';
corrdefl_dir=  'CorrDefl_imgF140W_z1.855_sharon';
diary(fullfile(corrdefl_dir,[sys,'.tot_pix_orig.diary']));
pic_name=[sys '.tot_pix_orig.ps'];
flag_wrtTDdat = false;
% corrdefl_extsn= '_truedefl.dat';

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
scale=[2.4 2.4; 3.0 3.0; 1.2 2.4];  scale_tot=[3.7 3.7];

% *NOTE: the scale for totsys can be much higher than individual img
img0=3;  img1=2;  img2=1;

%------------ the anti-Jacobi matrix for the correct tweak 
img1_antiJ=struct('a',1,'c',0);
img2_antiJ=struct('a',1,'c',0);

%------------ set the handle for plotting
h=figure(1);

%% getting remapped results for each img and plotting figures as well!!!
%-------------------------------------------------------------------------------
% first of all, srcpix the img which has the smallest magnification
num=img0;
if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

src_a=  reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src_b=  reshape(DEC0_src,N_img,1)*3600.;       % b
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
ref_a=  ref_ra*cos(ref_dec/180.*pi)*3600.;     % a_ref
ref_b=  ref_dec*3600.;                         % b_ref
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

scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
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
        fprintf('this point sitting on boundary: i=%d',i)
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

%------------ sub-plotting
subplot(2,2,1);
imagescwithnan(srcpix0_da,srcpix0_db,srcpix0_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('da [arcsec]','FontSize',lab_fontsize);
ylabel('db [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

if flag_wrtTDdat
%%%%------------ write corrdefl ASCII file
alpha_src=src_a/3600./cos(ref_dec/180.*pi);
delta_src=src_b/3600.;
truedefl_1=(alpha_src-img_ra)*60.*cos(ref_dec/180.*pi);
truedefl_2=(img_dec-delta_src)*60.;
truedefl=[truedefl_1 truedefl_2];

fid=fopen((fullfile(corrdefl_dir,[sys '.' num2str(num) corrdefl_extsn])),'wt');
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# RA\t\t DEC\t\n');
fprintf(fid,'%12.7f\t %12.7f\n',img_ctr(1),img_ctr(2));
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# alpha_1,true\t alpha_2,true\n');
fprintf(fid,'%12.7f\t %12.7f\n',truedefl');
fclose(fid);
end

%-------------------------------------------------------------------------------
% srcpix another img
num=img1;
antiJparam=img1_antiJ;

if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

imgname=str2double([sys '.' num2str(num)]);
indx=find(ismember(LMnames,imgname));
km=LMvals(indx,2);
gm=LMvals(indx,3);
phim=LMvals(indx,4);
modelVal=struct('kappa',km,'gamma',gm,'phi',phim);

%------------ Calc b/c from kappa_model, gamma_model, phi_model
bcratio=(1-km-gm*cos(2*phim/180.0*pi))/(1-km+gm*cos(2*phim/180.0*pi));

src0_a= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src0_b= reshape(DEC0_src,N_img,1)*3600.;       % b
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
ref_a=  ref_ra*cos(ref_dec/180.*pi)*3600.;     % a_ref
ref_b=  ref_dec*3600.;                         % b_ref
%------------ records the indices of which src plane pixels cnts go into
indx_a = zeros(N_img,1);
indx_b = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_a,src1_b]= shift(src0_a,src0_b,src_ctr(num,:),ctr_common);
%------------ the following two lines are only for the shift plot
% src_a=src1_a;
% src_b=src1_b;
%%------------ anti-Jacobi tweaking img
[src_a,src_b]=   antiJacobiRot(src1_a,src1_b,ctr_common,bcratio,antiJparam);

%%%------------ saving data for the combined subplot
img1_N=N_img;
img1_src_a=src_a;
img1_src_b=src_b;
img1_src_cnt=src_cnt;

scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
[vec_a,N_a]= MakeVecCtr(src_a,ctr_common(1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,ctr_common(2),binsize_b);
%------------ the following four lines are only for the orig plot
% src_a=src0_a;
% src_b=src0_b;
% [vec_a,N_a]=MakeVecCtr(src_a,src_ctr(num,1),binsize_a);
% [vec_b,N_b]=  MakeVecCtr(src_b,src_ctr(num,2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix1_SB= src_cnt_pix./times_pix;    
srcpix1_da= vec_a-ref_a;
srcpix1_db= vec_b-ref_b;
trueVal1=calcTrueVal(modelVal,bcratio,antiJparam);

%------------ sub-plotting
subplot(2,2,2)
imagescwithnan(srcpix1_da,srcpix1_db,srcpix1_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('da [arcsec]','FontSize',lab_fontsize);
% ylabel('db [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

if flag_wrtTDdat
%%%%------------ write corrdefl ASCII file
alpha_src=src_a/3600./cos(ref_dec/180.*pi);
delta_src=src_b/3600.;
truedefl_1=(alpha_src-img_ra)*60.*cos(ref_dec/180.*pi);
truedefl_2=(img_dec-delta_src)*60.;
truedefl=[truedefl_1 truedefl_2];

fid=fopen((fullfile(corrdefl_dir,[sys '.' num2str(num) corrdefl_extsn])),'wt');
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# RA\t\t DEC\t\n');
fprintf(fid,'%12.7f\t %12.7f\n',img_ctr(1),img_ctr(2));
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# alpha_1,true\t alpha_2,true\n');
fprintf(fid,'%12.7f\t %12.7f\n',truedefl');
fclose(fid);
end


%-------------------------------------------------------------------------------
% srcpix another img
num=img2;
antiJparam=img2_antiJ;

if num>num_img
    fprintf('ERR: num=%d is out of range of num_img=%d',num,num_img)
end
fprintf(['#------------------------ below doing srcpix for img ',sys,'.',num2str(num),'!\n'])
%------------ NOTE: the following way to load .mat file in as a struct
load((fullfile(mat_dir,[sys '.' num2str(num) mat_extsn])))

imgname=str2double([sys '.' num2str(num)]);
indx=find(ismember(LMnames,imgname));
km=LMvals(indx,2);
gm=LMvals(indx,3);
phim=LMvals(indx,4);
modelVal=struct('kappa',km,'gamma',gm,'phi',phim);

%------------ Calc b/c from kappa_model, gamma_model, phi_model
bcratio=(1-km-gm*cos(2*phim/180.0*pi))/(1-km+gm*cos(2*phim/180.0*pi));

src0_a= reshape(RA0_src,N_img,1)*cos(ref_dec/180.*pi)*3600.;  % a
src0_b= reshape(DEC0_src,N_img,1)*3600.;       % b 
src_cnt=reshape(img,N_img,1);
ctr_a=  ctr_ra*cos(ref_dec/180.*pi)*3600.;     % a_ctr
ctr_b=  ctr_dec*3600.;                         % b_ctr
src_ctr(num,1)= ctr_a;
src_ctr(num,2)= ctr_b;
ref_a=  ref_ra*cos(ref_dec/180.*pi)*3600.;     % a_ref
ref_b=  ref_dec*3600.;                         % b_ref
%------------ records the indices of which src plane pixels cnts go into
indx_a = zeros(N_img,1);
indx_b = zeros(N_img,1);

%%------------ shift the center point to match ctr_common
[src1_a,src1_b]= shift(src0_a,src0_b,src_ctr(num,:),ctr_common);
%------------ the following two lines are only for the shift plot
% src_a=src1_a;
% src_b=src1_b;
%%------------ anti-Jacobi tweaking img
[src_a,src_b]=   antiJacobiRot(src1_a,src1_b,ctr_common,bcratio,antiJparam);

%%%------------ saving data for the combined subplot
img2_N=N_img;
img2_src_a=src_a;
img2_src_b=src_b;
img2_src_cnt=src_cnt;

scale_a=scale(num,1);
scale_b=scale(num,2);
binsize_a= img_pixscale/scale_a;
binsize_b= img_pixscale/scale_b;
[vec_a,N_a]= MakeVecCtr(src_a,ctr_common(1),binsize_a);
[vec_b,N_b]= MakeVecCtr(src_b,ctr_common(2),binsize_b);
%------------ the following four lines are only for the orig plot
% src_a=src0_a;
% src_b=src0_b;
% [vec_a,N_a]=MakeVecCtr(src_a,src_ctr(num,1),binsize_a);
% [vec_b,N_b]=  MakeVecCtr(src_b,src_ctr(num,2),binsize_b);
src_cnt_pix = zeros(N_b,N_a);
times_pix = zeros(N_b,N_a);

%------------ interlacing
for i=1:N_img
    absdiff_a= abs(vec_a-src_a(i));
    absdiff_b= abs(vec_b-src_b(i));
    [diff_a,indx_a(i)]= min(absdiff_a);
    [diff_b,indx_b(i)]= min(absdiff_b);
    if diff_a==binsize_a/2. || diff_b==binsize_b/2.
        fprintf('this point sitting on boundary: i=%d',i)
    end
    src_cnt_pix(indx_b(i),indx_a(i))=src_cnt_pix(indx_b(i),indx_a(i))+src_cnt(i);
    times_pix(indx_b(i),indx_a(i))=  times_pix(indx_b(i),indx_a(i))+1;
    clear absdiff_a absdiff_b diff_a diff_b
end
src_cnt_pix(src_cnt_pix == 0) = NaN;
srcpix2_SB = src_cnt_pix./times_pix;    
srcpix2_da= vec_a-ref_a;
srcpix2_db=  vec_b-ref_b;
trueVal2=calcTrueVal(modelVal,bcratio,antiJparam);

%------------ sub-plotting
subplot(2,2,3)
imagescwithnan(srcpix2_da,srcpix2_db,srcpix2_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('da [arcsec]','FontSize',lab_fontsize);
ylabel('db [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 img ',sys,'.',num2str(num),' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);

if flag_wrtTDdat
%%%%------------ write corrdefl ASCII file
alpha_src=src_a/3600./cos(ref_dec/180.*pi);
delta_src=src_b/3600.;
truedefl_1=(alpha_src-img_ra)*60.*cos(ref_dec/180.*pi);
truedefl_2=(img_dec-delta_src)*60.;
truedefl=[truedefl_1 truedefl_2];

fid=fopen((fullfile(corrdefl_dir,[sys '.' num2str(num) corrdefl_extsn])),'wt');
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# RA\t\t DEC\t\n');
fprintf(fid,'%12.7f\t %12.7f\n',img_ctr(1),img_ctr(2));
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# alpha_1,true\t alpha_2,true\n');
fprintf(fid,'%12.7f\t %12.7f\n',truedefl');
fclose(fid);
end


%%%-------------------------------------------------------------------------------
% subplotting the combined pixelized src plane img
fprintf(['#------------------------ below doing srcpix for totsys ',sys,'!\n'])
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
        fprintf('this point sitting on boundary: i=%d',i)
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
        fprintf('this point sitting on boundary: i=%d',i)
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
        fprintf('this point sitting on boundary: i=%d',i)
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
subplot(2,2,4)
imagescwithnan(srcpix_tot_da,srcpix_tot_db,srcpix_tot_SB,jet,[1 1 1],true)
axis xy
colorbar
xlabel('da [arcsec]','FontSize',lab_fontsize);
title(['MACS0717 combined img ',sys,' on the pixelized src plane'])
set(gca,'FontSize',axes_fontsize,'LineWidth',lw_gca,'XDir','Reverse'); 
axis(axial_range);


%% end-up work for the figure
set(gcf, 'PaperUnits','inches');
set(gcf, 'PaperPosition',[ 0 0 8 6]);
print(h,'-dpsc2',fullfile(corrdefl_dir,pic_name));
toc
diary off

%----------------------------- no use anymore ----------------------------------%
% leg_end = legend(['\kappa_{ext}=',num2str(jacobi_1.kappa)],['|\gamma_{ext}|=',num2str(jacobi_1.gamma)],...
%     ['\phi=',num2str(jacobi_1.phi)],3);
% set(leg_end,'Box','off','FontSize',axes_fontsize);

%<<<140812>>> the matlab part of this software ends at spitting out a
%             deflection angle correction parameter files recording the
%             values for del_deflection, and A_ext. Then python script can
%             take advantage of this file, read it in and make corrected
%             postage stamps for alpha_1,2
% deflcorrpar_name=[sys '.tot_pix_fin.']