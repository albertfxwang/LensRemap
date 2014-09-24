#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
----------------------------
    PURPOSE/DESCRIPTION
----------------------------
 Interpolate values of kappa_model, gamma_model, phi_model for img centers based on the original lens model
----------------------------
   EXAMPLES/USAGE
----------------------------
 $ ./measure_kgphi.py
----------------------------
   INPUTS
----------------------------
 you will need to modify the path/file name variables at "some input/output file names and paths"
 to run this script successfully
"""
#-------------------------------------------------------------------------------------------------------------
# IMPORTING MODULES
import numpy as np         # enable opening with genfromtxt
import lensmap as lm

#-------------------------------------------------------------------------------------------------------------
# Setting up input file names and paths via concatenation
workdir=        './'
img_coord =     workdir+'z1.855_SLimgPeak.cat'

lensmodel_dir=  '/home/albert/Desktop/41.FF/cl01.MACS0717/sharon_z1.855/'
lm_root=        'hlsp_frontier_model_macs0717_sharon_v2'
lm_extsn=       'rs_1.855.fits'

lmap_mag=       lensmodel_dir+lm_root+'_mag_'+lm_extsn
lmap_kappa=     lensmodel_dir+lm_root+'_kappa_'+lm_extsn
lmap_gamma=     lensmodel_dir+lm_root+'_gamma_'+lm_extsn
lmap_angle=     lensmodel_dir+lm_root+'_angle_'+lm_extsn

output_file=    workdir+'interpVal_kgphi_z1.855Sharon.txt'

#-------------------------------------------------------------------------------------------------------------
# Reading ascii
dat = np.genfromtxt(img_coord, dtype=None, comments='#')
Nobj = len(dat)
IDs  = dat['f0']
RAs  = dat['f1']
DECs = dat['f2']

#-------------------------------------------------------------------------------------------------------------
# Use lm.interpVal to get the rslt
mag_model=      lm.interpVal(lmap_mag, (RAs, DECs))
kappa_model=    lm.interpVal(lmap_kappa, (RAs, DECs))
gamma_model=    lm.interpVal(lmap_gamma, (RAs, DECs))
angle_model=    lm.interpVal(lmap_angle, (RAs, DECs))
phi_model=      angle_model+90.0
Nphi= phi_model.size
for i in xrange(Nphi):
    if phi_model[i] > 180.0:
        phi_model[i]= phi_model[i]-180.0

#-------------------------------------------------------------------------------------------------------------
# Save rslt to output_file
tot_model= np.concatenate((mag_model[:,None], kappa_model[:,None], gamma_model[:,None], phi_model[:,None]), axis=1)
np.savetxt(output_file, tot_model, fmt='%3.6e')


