




%% basic information, assignments of public variables
global img_dir lens_dir ref_ra ref_dec SLcatalog

img_dir = 'imgF140W';
lens_dir = 'z1.855_sharon';
% HST image's reference pixel's WCS coord
% $ imhead MACS0717_F814WF105WF140W_R.fits | grep CRVAL1 (->RA), CRVAL2 (->DEC)
ref_ra=109.384564525;
ref_dec=37.7496681474;
SLcatalog = 'z1.855_SLimg.cat';

%% read in coordinates from the catalog
imgs_cat = importdata(SLcatalog, ' ', 2);
img_coord = imgs_cat.data;




