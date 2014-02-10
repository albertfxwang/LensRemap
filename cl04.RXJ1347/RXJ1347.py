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
#-------------------------------------------------------------------------------------------------------------
alpha1 = pf.open('./data.fits/RXJ1347.files_alpha1_rs_1.7.fits')[0].data.copy()
alpha2 = pf.open('./data.fits/RXJ1347.files_alpha2_rs_1.7.fits')[0].data.copy()
gamma1 = pf.open('./data.fits/RXJ1347.files_gamma1_rs_1.7.fits')[0].data.copy()
gamma2 = pf.open('./data.fits/RXJ1347.files_gamma2_rs_1.7.fits')[0].data.copy()
kappa = pf.open('./data.fits/RXJ1347.files_kappa_rs_1.7.fits')[0].data.copy()
mag = pf.open('./data.fits/RXJ1347.files_mag_rs_1.7.fits')[0].data.copy()

#-------------------------------------------------------------------------------------------------------------
jacob_A = 1-kappa-gamma1
jacob_D = 1-kappa+gamma1
jacob_B = -1*gamma2
jacob_C = jacob_B


#-------------------------------------------------------------------------------------------------------------
#                                                      END
#-------------------------------------------------------------------------------------------------------------
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
np.savetxt('new', new, fmt='%s')

----------------------------
"""
