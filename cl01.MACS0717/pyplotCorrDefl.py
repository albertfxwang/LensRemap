#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
"""
----------------------------
   PURPOSE/DESCRIPTION
----------------------------
 Plot corrected deflection angle stamps with fits image using ds9 (someone calls this ``Montage'')
----------------------------
   EXAMPLES/USAGE
----------------------------
 $ ./pyplotCorrDefl.py
----------------------------
   INPUTS
----------------------------
 you will need to modify the path/file name variables at "some input/output file names and paths"
 to run this script successfully
"""
#-------------------------------------------------------------------------------------------------------------
# IMPORTING MODULES
import numpy as np
import commands

#-------------------------------------------------------------------------------------------------------------
# setting up input file names and paths
#workdir=        '$HOME/workplace/LensRemap/cl01.MACS0717/'
workdir=        './'
fullFoVHSTimg=  workdir+'obsHSTimg.fits.cat.reg/MACS0717_F814WF105WF140W_R.fits'
regionfile=     workdir+'obsHSTimg.fits.cat.reg/SLimgPeak_z1.855.reg'
img_coord =     workdir+'z1.855_SLimgPeak.cat'

imgstamp_dir=   'imgF140W_z1.855peak_fullfits/'
imgstamp_root=  '_cut.fits'

corralpha_dir=  'CorrDefl_imgF140W_z1.855_sharon/'
corralpha1_root='_corralpha1.fits'
corralpha2_root='_corralpha2.fits'
rsltimg_root=   '_corrdefl.png'

#-------------------------------------------------------------------------------------------------------------
# setting up ds9 command line options
##------------ "ds9" denotes a complete option
ds9zoom=    ' -zoom to fit '
ds9frame=   ' -frame lock wcs '
ds9page=    ' -pagesetup size letter '
ds9regions= ' -regions load all '+regionfile+' '
##------------ "ds" needs an additional input, e.g., output file name. should have corresponding "ds9" in the following
dssaveimg=  ' -saveimage png '

#-------------------------------------------------------------------------------------------------------------
# Reading ascii and plotting inside the for-loop
dat=    np.genfromtxt(img_coord, dtype=None, comments='#')
Nobj=   len(dat)
IDs=    dat['f0']
for ii in xrange(Nobj):
    #-------------------------------------------------------------------------------
    # string cat input fits file names
    id=str(IDs[ii])
    imgstamp_name=      workdir+imgstamp_dir+id+imgstamp_root
    corralpha1_name=    workdir+corralpha_dir+id+corralpha1_root
    corralpha2_name=    workdir+corralpha_dir+id+corralpha2_root
    #-------------------------------------------------------------------------------
    # string cat the full ds9 command
    ds9saveimg= dssaveimg+workdir+corralpha_dir+id+rsltimg_root+' '
    ds9cmd= 'ds9 '+fullFoVHSTimg+' '+imgstamp_name+' '+corralpha1_name+' '+corralpha2_name+ds9zoom+ds9frame+\
            ds9regions+ds9saveimg+ds9page
    ds9out= commands.getoutput(ds9cmd)

