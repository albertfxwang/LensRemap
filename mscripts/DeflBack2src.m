function [ra_src,dec_src]=DeflBack2src(ra_img,dec_img,alpha1,alpha2,ref_dec)
%------------------------------------------------------------------------------
% DeflBack2src function
% Description: shift img coordinates from lens plane back to its src plane
%              in terms of 2-cpt deflection angle maps
% Input  : - ra_img, dec_img, ref_dec must be in deg
%          - alpha1, alpha2 (in arcmin) should conform to the convention by Marusa and HFF
% Output : - ra_src, dec_src have the same dimensions with ra_img, dec_img
%          - their orderings are kept the same and their unit is in deg as well
% Tested : Matlab R2011a
%     By : Xin Wang                     August 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter DeflBack2src\n')
%------------ check vectors and whether they have the same dim
N_ra=CheckVec(ra_img);
N_dec=CheckVec(dec_img);
N_alpha1=CheckVec(alpha1);
N_alpha2=CheckVec(alpha2);
if N_ra*N_dec*N_alpha1*N_alpha2 == 0
    fprintf('ERR: some inputs are not vectors!\n')
elseif (N_ra~=N_dec) || (N_alpha1~=N_alpha2) || (N_ra~=N_alpha1)
    fprintf('ERR: some input vectors have different dimensions!\n')
end

%------------ deflection angle shift -> Remember the RA-axis is inverted, and the cos-factor !!!
ra_src=ra_img+alpha1/60./cos(ref_dec/180.*pi);       
dec_src=dec_img-alpha2/60.;

fprintf('#============ exit DeflBack2src\n')