"""
----------------------------
   NAME
----------------------------
 RXJ1347.py
----------------------------
   PURPOSE/DESCRIPTION
----------------------------

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
#-------------------------------------------------------------------------------------------------------------
alpha1 = pf.open('./data.fits/RXJ1347.files_alpha1_rs_1.7.fits')[0].data.copy()
alpha2 = pf.open('./data.fits/RXJ1347.files_alpha2_rs_1.7.fits')[0].data.copy()
gamma1 = pf.open('./data.fits/RXJ1347.files_gamma1_rs_1.7.fits')[0].data.copy()
gamma2 = pf.open('./data.fits/RXJ1347.files_gamma2_rs_1.7.fits')[0].data.copy()
kappa = pf.open('./data.fits/RXJ1347.files_kappa_rs_1.7.fits')[0].data.copy()
mag = pf.open('./data.fits/RXJ1347.files_mag_rs_1.7.fits')[0].data.copy()

img = pf.open('./data.fits/RXJ1347-1145_fullres_G.fits')[0].data.copy()

#-------------------------------------------------------------------------------------------------------------
jacob_A = 1-kappa-gamma1
jacob_D = 1-kappa+gamma1
jacob_B = -1*gamma2
jacob_C = jacob_B

#-------------------------------------------------------------------------------------------------------------
x1 = 3676.539
y1 = 4759.3438
rad1 = 30
cut1 = img[y1-rad1:y1+rad1,x1-rad1:x1+rad1]
pf.PrimaryHDU(cut1).writeto('img_cut_i1.fits',clobber=True)

x2 = 4052.0352
y2 = 3676.0942
rad2 = 70
cut2 = img[y2-rad2:y2+rad2,x2-rad2:x2+rad2]
pf.PrimaryHDU(cut2).writeto('img_cut_i2.fits',clobber=True)

x3 = 4410.6401
y3 = 4802.8817
rad3 = 40
cut3 = img[y3-rad3:y3+rad3,x3-rad3:x3+rad3]
pf.PrimaryHDU(cut3).writeto('img_cut_i3.fits',clobber=True)

x4 = 2993.1057
y4 = 4091.6058
rad4 = 60
cut4 = img[y4-rad4:y4+rad4,x4-rad4:x4+rad4]
pf.PrimaryHDU(cut4).writeto('img_cut_i4.fits',clobber=True)

x5 = 3093.3176
y5 = 5917.4507
rad5 = 50
cut5 = img[y5-rad5:y5+rad5,x5-rad5:x5+rad5]
pf.PrimaryHDU(cut5).writeto('img_cut_i5.fits',clobber=True)

# Create fits file
#pf.PrimaryHDU(img).writeto('img_G.fits',clobber=True)

#-------------------------------------------------------------------------------------------------------------
# Show the image; note that the normalisations are arbitrary
pl.figure(1)
pl.imshow(cut1,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut_i1.png",dpi=200)

pl.figure(2)
pl.imshow(cut2,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut_i2.png",dpi=200)

pl.figure(3)
pl.imshow(cut3,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut_i3.png",dpi=200)

pl.figure(4)
pl.imshow(cut4,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut_i4.png",dpi=200)

pl.figure(5)
pl.imshow(cut5,origin='lower',interpolation='nearest')
pl.colorbar()
plt.savefig("img_cut_i5.png",dpi=200)

pl.ion()
pl.show()

#-------------------------------------------------------------------------------------------------------------
#                                                      END
#-------------------------------------------------------------------------------------------------------------
"""   tryout material 
----------------------------
# Create fits file
pf.PrimaryHDU(kappa).writeto('kappa.fits',clobber=True)
# Show the image; note that the normalisations are arbitrary
pl.figure()
pl.imshow(kappa,origin='lower',interpolation='nearest')
pl.colorbar()

minus_one = np.zeros((1024,1024))
minus_one[:,:] = -1.0

positive_one = np.zeros((1024,1024))
positive_one[:,:] = 1.0

minus_three = np.zeros((1024,1024))
minus_three[:,:] = -3.0

new=np.add(np.add(minus_one,positive_one),minus_three)

print "new=", new
np.savetxt('new', new, fmt='%s')

----------------------------
"""
