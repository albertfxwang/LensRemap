"""
----------------------------
    PURPOSE/DESCRIPTION
----------------------------
 using python to extract data of lens and SL multiple images, for MACS0717
 NOTE: all lensing quantity maps should have the same pixel size and dimensions!
----------------------------
"""
#-------------------------------------------------------------------------------------------------------------
__author__ = "Xin Wang (UCSB)"
#-------------------------------------------------------------------------------------------------------------
# IMPORTING MODULES
import numpy as np
import pyfits as pf
import pylab as pl
import matplotlib.pyplot as plt
import fitstools

#-------------------------------------------------------------------------------------------------------------
# some input/output file names
file_dir='/data2/xinwang/workplace/cl01.MACS0717.ff/bradac/alpha_z100/'
file_root='MACS0717.bradac'
z_src='1.855'     # systems 3,4,14
loc = './z1.855_bradac/'

img_coord = 'z1.855_SLimg.cat'
#-------------------------------------------------------------------------------------------------------------
# reading lens models
alpha1_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'alpha1_rs',z_src)
alpha2_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'alpha2_rs',z_src)
#kappa_name  = '%s%s_%s_%s.fits' % (file_dir,file_root,'kappa_rs',z_src)
#gamma1_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'gamma1_rs',z_src)
#gamma2_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'gamma2_rs',z_src)
mag_name    = '%s%s_%s_%s.fits' % (file_dir,file_root,'mag_rs',z_src)
print 'The lens model to be used is %s' % mag_name
alpha1_tot = pf.open(alpha1_name)[0].data.copy()
alpha2_tot = pf.open(alpha2_name)[0].data.copy()
#kappa_tot  = pf.open(kappa_name)[0].data.copy()
#gamma1_tot = pf.open(gamma1_name)[0].data.copy()
#gamma2_tot = pf.open(gamma2_name)[0].data.copy()
mag_tot    = pf.open(mag_name)[0].data.copy()

#-------------------------------------------------------------------------------------------------------------
# reading SLimg catalog
dat = np.genfromtxt(img_coord, dtype=None, comments='#')
Nobj = len(dat)
IDs  = dat['f0']
RAs  = dat['f1']
DECs = dat['f2']
rads = dat['f3']

#-------------------------------------------------------------------------------------------------------------
# cutting off postage stamps from lens models
for ii in xrange(Nobj):
    #--------------------------------------------------------------------------
    id=float(IDs[ii])
    ra=float(RAs[ii])
    dec=float(DECs[ii])
    rad=float(rads[ii])
    alpha1_stamp = loc+str(id)+'_alpha1.dat'
    alpha2_stamp = loc+str(id)+'_alpha2.dat'
#    kappa_stamp  = loc+str(id)+'_kappa.dat'
#    gamma1_stamp = loc+str(id)+'_gamma1.dat'
#    gamma2_stamp = loc+str(id)+'_gamma2.dat'
    mag_stamp    = loc+str(id)+'_mag.dat'
    lensra_stamp = loc+str(id)+'_lensra.dat'
    lensdec_stamp= loc+str(id)+'_lensdec.dat'
    #-------------------------------------------------------------------------- make .dat files
    lens_xy=fitstools.coords2pix(mag_name,(ra,dec))
    print 'processing img %s: (RA=%s, DEC=%s)  <=>  (x=%s, y=%s)' % (str(id), str(ra), str(dec), str(lens_xy[0]), str(lens_xy[1]))
    #<<<140607>>> the chopped size (2*rad) is plausible as long as the lens fitting pixel is larger than the HST image pixel
    alpha1 = alpha1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]  
    alpha2 = alpha2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#    kappa  =  kappa_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#    gamma1 = gamma1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#    gamma2 = gamma2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
    mag    =    mag_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]

    lens_x = np.arange(int(lens_xy[0]-rad+1),int(lens_xy[0]+rad+1))
    lens_y = np.arange(int(lens_xy[1]-rad+1),int(lens_xy[1]+rad+1))
    lens_wcs=fitstools.pix2coords(mag_name,(lens_x,lens_y))

    # output ASCII files for all relevant quantities to feed into matlab
    np.savetxt(alpha1_stamp ,alpha1,fmt='%s') 
    np.savetxt(alpha2_stamp ,alpha2,fmt='%s')
#    np.savetxt(kappa_stamp  ,kappa,fmt='%s')
#    np.savetxt(gamma1_stamp ,gamma1,fmt='%s')
#    np.savetxt(gamma2_stamp ,gamma2,fmt='%s')
    np.savetxt(mag_stamp    ,mag,fmt='%s')
    np.savetxt(lensra_stamp ,lens_wcs[0],fmt='%s')
    np.savetxt(lensdec_stamp,lens_wcs[1],fmt='%s')

#-------------------------------------------------------------------------------------------------------------
#                                                      END
#-------------------------------------------------------------------------------------------------------------
