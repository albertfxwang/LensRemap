%: vim: wrap linebreak smartindent formatoptions+=twa
LensRemap
==========

4/29/2014
---------
NB, should use the RGB fits images created by Marusa's pipeline, rather than the ``_sci'' fits images at these filters, for better looking results.

7/29/2014
---------
  Today I formally changed the name of this small software to "LensRemap", in praise of recent efforts in bringing ``srcpix_tot'' into life

9/23/2014
---------
  It was just realized that the external Jacobian matrix distortion is ill-motivated and I tried to fix this.

9/26/2014
---------
The notations for image coordinates have undergone some changes, which are partly reflected by the headers of my matlab/python scripts. To avoid any further ambiguity I write down the most up-to-date notations as follows.

* pixel space (Cartesian): (x, y), in unit of pixel
* WCS space (non-Cartesian): (RA, Dec) \defeq (\alpha, \delta), in unit of degrees or hms(for RA)/dms(for Dec)
* arcmin/arcsec space (Cartesian): (a, b), in unit of arcmin or arcsec

The conversion btw WCS space and `arcsec` space is (assuming WCS is in unit of deg)<br />
> a = alpha * 3600 * cos(delta_ref)  <br />
> b = delta * 3600    <br />

