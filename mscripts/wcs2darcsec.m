function [da,db]=wcs2darcsec(ra,dec,crval)
%------------------------------------------------------------------------------
% wcs2darcsec function
% Description: convert WCS coordinates (RA/DEC in deg) to arcsec space
%              coordinates w.r.t. the reference pixel => da, db (~in arcsec)
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     August 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter wcs2darcsec\n')
%------------ check vectors and whether they have the same dim
N_ra=CheckVec(ra);
N_dec=CheckVec(dec);
if N_ra*N_dec==0
    fprintf('ERR: some inputs are not vectors!\n')
elseif N_ra~=N_dec
    fprintf('ERR: some input vectors have different dimensions!\n')
end
a=      ra*cos(crval(2)/180.*pi)*3600.;
b=      dec*3600.;
a_ref=  crval(1)*cos(crval(2)/180.*pi)*3600.;
b_ref=  crval(2)*3600.;
da=     a-a_ref;
db=     b-b_ref;
fprintf('#============ exit wcs2darcsec\n')