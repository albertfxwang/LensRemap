"""
----------------------------
   NAME
----------------------------
 lens_extract.py
----------------------------
   PURPOSE/DESCRIPTION
----------------------------
 using python to extract data of lens and SL multiple images
----------------------------
   COMMENTS
----------------------------

----------------------------
   EXAMPLES/USAGE
----------------------------

----------------------------
   BUGS
----------------------------

----------------------------
   REVISION HISTORY
----------------------------
 2014-2-9  started by Xin Wang (UCSB)
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
#from sonnentools import astrometry
#from sonnentools import fitstools

#-------------------------------------------------------------------------------------------------------------
img_name='./data.fits/RXJ1347-1145_fullres_G.fits'  # this is the image data
img = pf.open(img_name)[0].data.copy()

file_dir='/data2/xinwang/workplace/cl04.RXJ1347.swunitedamr/Regu60_PosiErr1as_Ngrid25to27/'
file_root='RXJ1347.PosiErr1as'
z_src='1.8'     # RXJ1347 - system i

alpha1_name = '%s%s_%s_%s%s' % (file_dir,file_root,'alpha1_rs',z_src,'.fits')
alpha2_name = '%s%s_%s_%s%s' % (file_dir,file_root,'alpha2_rs',z_src,'.fits')
gamma1_name = '%s%s_%s_%s%s' % (file_dir,file_root,'gamma1_rs',z_src,'.fits')
gamma2_name = '%s%s_%s_%s%s' % (file_dir,file_root,'gamma2_rs',z_src,'.fits')
kappa_name  = '%s%s_%s_%s%s' % (file_dir,file_root,'kappa_rs',z_src,'.fits')
mag_name    = '%s%s_%s_%s%s' % (file_dir,file_root,'mag_rs',z_src,'.fits')

alpha1_tot = pf.open(alpha1_name)[0].data.copy()
alpha2_tot = pf.open(alpha2_name)[0].data.copy()
gamma1_tot = pf.open(gamma1_name)[0].data.copy()
gamma2_tot = pf.open(gamma2_name)[0].data.copy()
kappa_tot  = pf.open(kappa_name)[0].data.copy()
mag_tot    = pf.open(mag_name)[0].data.copy()

#-------------------------------------------------------------------------------------------------------------
"""# RXJ1347 - i1
x = 3676.539
y = 4759.3438
rad = 30"""
"""# RXJ1347 - i2
x = 4052.0352
y = 3676.0942
rad = 70"""
"""# RXJ1347 - i3
x = 4410.6401
y = 4802.8817
rad = 40"""
"""# RXJ1347 - i4
x = 2993.1057
y = 4091.6058
rad = 60"""
"""# RXJ1347 - i5
x = 3093.3176
y = 5917.4507
rad = 50"""
"""# RXJ1347 - a1
x = 4689.6758
y = 5428.9874
rad = 115"""
# RXJ1347 - a2
x = 4935.8924 
y = 4149.0681
rad = 45

cut = img[y-rad:y+rad,x-rad:x+rad]
# Create fits file
pf.PrimaryHDU(cut).writeto('img_cut.fits',clobber=True)

#-------------------------------------------------------------------------------------------------------------
# to cut off a postage stamp from lens model as well
img_WCS_center=fitstools.pix2coords(img_name,(x,y))
lens_xy=fitstools.coords2pix(mag_name,img_WCS_center)

print "center in HST image's pixel space: x=", x, "y=", y
print "center in WCS coordinate (deg): RA=", img_WCS_center[0], "DEC=", img_WCS_center[1]
print "center in lens model's pixel space: x=", lens_xy[0], "y=", lens_xy[1]

f = open('img_WCS_ctr.dat', 'w')
f.write("%s  %s\n" % (x, y))
f.write("%s  %s\n" % (img_WCS_center[0], img_WCS_center[1]))
f.write("%s  %s\n" % (lens_xy[0], lens_xy[1]))
f.close()

# below is the chopped maps of lensing quantities for specific image cuts
alpha1 = alpha1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]  
alpha2 = alpha2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
gamma1 = gamma1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
gamma2 = gamma2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
kappa  =  kappa_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
mag    =    mag_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]

#-------------------------------------------------------------------------------------------------------------
# to use Ale's code to output WCS info
img_x = np.arange(int(x-rad+1),int(x+rad+1))
img_y = np.arange(int(y-rad+1),int(y+rad+1))
X,Y = np.meshgrid(img_x,img_y)
img_x_tot=X.flatten()
img_y_tot=Y.flatten()
img_wcs_tot = fitstools.pix2coords(img_name,(img_x_tot,img_y_tot))
#img_wcs=fitstools.pix2coords(img_name,(img_x,img_y))     % this only gives WCS coord for the diagonal line

#lens_size=mag.shape
#if lens_size[0]!=lens_size[1]:
#    print 'the lens model has odd dimensions'
##    break
#lens_pix=np.arange(1,lens_size[0]+1)
lens_x = np.arange(int(lens_xy[0]-rad+1),int(lens_xy[0]+rad+1))
lens_y = np.arange(int(lens_xy[1]-rad+1),int(lens_xy[1]+rad+1))
lens_wcs=fitstools.pix2coords(mag_name,(lens_x,lens_y))

#-------------------------------------------------------------------------------------------------------------
# Show the image; note that the normalisations are arbitrary
pl.figure(1)
pl.imshow(cut,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut.png",dpi=200)
pl.ion()
pl.show()

#-------------------------------------------------------------------------------------------------------------
# output ASCII files for all relevant quantities to feed into matlab
np.savetxt('alpha1.dat',alpha1,fmt='%s') 
np.savetxt('alpha2.dat',alpha2,fmt='%s')
np.savetxt('gamma1.dat',gamma1,fmt='%s')
np.savetxt('gamma2.dat',gamma2,fmt='%s')
np.savetxt('kappa.dat',kappa,fmt='%s')
np.savetxt('mag.dat',mag,fmt='%s')
np.savetxt('lens_ra.dat',lens_wcs[0],fmt='%s')
np.savetxt('lens_dec.dat',lens_wcs[1],fmt='%s')
np.savetxt('cut.dat',cut.flatten(),fmt='%s')
np.savetxt('img_ra.dat',img_wcs_tot[0],fmt='%s')
np.savetxt('img_dec.dat',img_wcs_tot[1],fmt='%s')

#-------------------------------------------------------------------------------------------------------------
#                                                      END
#-------------------------------------------------------------------------------------------------------------
"""     codes for the other four images, temporarily here
"""
"""   tryout material 
----------------------------
minus_one = np.zeros((1024,1024))
minus_one[:,:] = -1.0
positive_one = np.zeros((1024,1024))
positive_one[:,:] = 1.0
minus_three = np.zeros((1024,1024))
minus_three[:,:] = -3.0
new=np.add(np.add(minus_one,positive_one),minus_three)
print "new=", new

file_type = ('alpha1_rs','alpha2_rs','gamma1_rs','gamma2_rs','kappa_rs','mag_rs')
num_type = len(file_type)
for i in range(0,num_type):    
----------------------------
"""
