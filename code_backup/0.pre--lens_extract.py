"""
----------------------------
    PURPOSE/
----------------------------
 using python to extract data of lens and SL multiple images, for MACS0717
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
# cutting postage stamps from observed images
img_name='./data_rgb.fits_cat.reg/MACS0717_F814WF105WF140W_R.fits'
img = pf.open(img_name)[0].data.copy()

#-------------------------------------------------------------------------------------------------------------
# retrieving lens models
file_dir='/data2/xinwang/workplace/cl01.MACS0717.ff/sharon/'
file_root='hlsp_frontier_model_macs0717_sharon_v2'
z_src='1.855'     # systems 3,4,14
#z_src='1.7'     # system 12

alpha1_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'alpha1_rs',z_src)
alpha2_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'alpha2_rs',z_src)
#gamma1_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'gamma1_rs',z_src)
#gamma2_name = '%s%s_%s_%s.fits' % (file_dir,file_root,'gamma2_rs',z_src)
#kappa_name  = '%s%s_%s_%s.fits' % (file_dir,file_root,'kappa_rs',z_src)
mag_name    = '%s%s_%s_%s.fits' % (file_dir,file_root,'mag_rs',z_src)

alpha1_tot = pf.open(alpha1_name)[0].data.copy()
alpha2_tot = pf.open(alpha2_name)[0].data.copy()
#gamma1_tot = pf.open(gamma1_name)[0].data.copy()
#gamma2_tot = pf.open(gamma2_name)[0].data.copy()
#kappa_tot  = pf.open(kappa_name)[0].data.copy()
mag_tot    = pf.open(mag_name)[0].data.copy()

##<<<140607>>> the following should be uncommented only when high-resol remapped alpha maps are used
##alpha1_tot = alpha1_tot/1000.
##alpha2_tot = alpha2_tot/1000.      uncertain how alpha is defined in remap.c

#-------------------------------------------------------------------------------------------------------------
# here images' postage stamps are cut according to their spatial extension at R band filter (F140W)
#<<<140607>>> I have an idea for this: should write this part to read in info from the strong lensing catalog
#         *** the essence of programming is just to minimize human labor in a iterative fashion

x = 2766.2917; y = 3366.735; rad = 35;    # 4.1
#x = 3120.7598; y = 3717.8938; rad = 15;    # 4.2
#x = 1982.5423; y = 2628.303; rad = 20;    # 4.3

#x = 3598.6099; y = 2527.211; rad = 15;      # 3.1
#x = 3714.4754; y = 2788.6894; rad = 15;     # 3.2
#x = 2832.472; y = 1862.4514; rad = 15;      # 3.3

#x = 2731.7342; y = 2908.9482; rad = 25;     # 14.1
#x = 3502.9053; y = 3604.6515; rad = 12;     # 14.2
#x = 2238.8085; y = 2374.8719; rad = 15;     # 14.3

cut = img[y-rad:y+rad,x-rad:x+rad]

# clean some noises
#cut[0:34,24:rad*2]=0       # 4.3

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
#<<<140607>>> the chopped size (2*rad) is plausible as long as the lens fitting pixel is larger than the HST image pixel
alpha1 = alpha1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
alpha2 = alpha2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#gamma1 = gamma1_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#gamma2 = gamma2_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
#kappa  =  kappa_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]
mag    =    mag_tot[lens_xy[1]-rad:lens_xy[1]+rad,lens_xy[0]-rad:lens_xy[0]+rad]

#-------------------------------------------------------------------------------------------------------------
# to use Ale's code to output WCS info
img_x = np.arange(int(x-rad+1),int(x+rad+1))
img_y = np.arange(int(y-rad+1),int(y+rad+1))
X,Y = np.meshgrid(img_x,img_y)
img_x_tot=X.flatten()
img_y_tot=Y.flatten()
img_wcs_tot = fitstools.pix2coords(img_name,(img_x_tot,img_y_tot))
##img_wcs=fitstools.pix2coords(img_name,(img_x,img_y))     % this only gives WCS coord for the diagonal line

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
#np.savetxt('gamma1.dat',gamma1,fmt='%s')
#np.savetxt('gamma2.dat',gamma2,fmt='%s')
#np.savetxt('kappa.dat',kappa,fmt='%s')
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
# 12.1
x = 2711.7556
y = 3117.1252
rad = 18
# 12.2
x = 3255.8415
y = 3672.0838
rad = 11
# 12.3
x = 2166.1345
y = 2648.6497
rad = 20
"""
