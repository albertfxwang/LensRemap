#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
#+
#----------------------------
#   PURPOSE/DESCRIPTION
#----------------------------
# make corrected deflection angle postage stamps based on an original lens model and my tweaking
#----------------------------
#   EXAMPLES/USAGE
#----------------------------
# $ ./corrdefl.py ./z1.855_SLimgPeak.cat ./imgF140W_z1.855peak_fullfits CorrDefl_imgF140W_z1.855_sharon -v
#----------------------------
#   INPUTS
#----------------------------
# img_coord     : the file containing WCS coordinates (RA/DEC) of the centers of all multiple images
# imgstamp_dir  : the folder containing fits postage stamps cut from full FoV HST image, which provide mesh grids
# lenstamp_dir  : the folder containing all fits postage stamps of corrected deflection angle results
#----------------------------
#   OPTIONAL INPUTS
#----------------------------
# --verbose     : set "-v" to get info/messages printed to the screen
# --stop        : stoppping program before end for de-bugging
# --help        : Printing help menu
#----------------------------
#   REVISION HISTORY
#----------------------------
# based on Kasper's python script GLASS/papers/paper0/plotMagnification.py
#----------------------------
#   MODULES
#----------------------------
import argparse            # argument managing
import sys                 # enabling arguments to code
#import os                  # enabling command line runs and executing other Python scripts with os.system('string')
#import pyfits as pf
import numpy as np         # enable opening with genfromtxt
#import pylab as pl
#import matplotlib.pyplot as plt   # importing plotting packages
import pdb                 # for debugging with pdb.set_trace()
#import fitstools as ft
import lensmap as lm
import statutils as su

#-------------------------------------------------------------------------------------------------------------
# Managing arguments with argparse (see http://docs.python.org/howto/argparse.html)
parser = argparse.ArgumentParser()
# ---- required arguments ---- :
parser.add_argument("img_coord",   type=str, help="the file containing RA/DEC of the centers of all multiple images")
parser.add_argument("imgstamp_dir",type=str, help="containing postage stamps of multiple images")
parser.add_argument("lenstamp_dir",type=str, help="containing postage stamps of corrected deflection angle results")
# ---- optional arguments ----
parser.add_argument("-v", "--verbose", action="store_true", help="Print verbose comments")
parser.add_argument("--stop", action="store_true", help="Stopping program before end for debugging")

args = parser.parse_args()
#-------------------------------------------------------------------------------------------------------------
if args.verbose: print '\n:: '+sys.argv[0]+' :: -- START OF PROGRAM -- \n'
#-------------------------------------------------------------------------------------------------------------
# Reading ascii
dat = np.genfromtxt(args.img_coord, dtype=None, comments='#')
Nobj = len(dat)
IDs  = dat['f0']
RAs  = dat['f1']
DECs = dat['f2']
rads = dat['f3']
truedefl_root= '_truedefl.dat'
imgstamp_root= '_cut.fits'
corralpha1_root= '_corralpha1.fits'
corralpha2_root= '_corralpha2.fits'

for ii in xrange(Nobj):
    #-------------------------------------------------------------------------------
    id=float(IDs[ii])
    ra=float(RAs[ii])
    dec=float(DECs[ii])
    rad=float(rads[ii])
    print 'running corrdefl.py for img %s: (RA=%s, DEC=%s) with rad=%s <=> size=%s' % (str(id), str(ra), str(dec),
str(rad), str((rad*2)**2))
    #-------------------------------------------------------------------------------
    # read in the true deflection angle ASCII file calculated by matlab one by one
    truedefl_name= args.lenstamp_dir+'/'+str(id)+truedefl_root
    truedefl_dat = np.genfromtxt(truedefl_name, dtype=None, comments='#')
    assert (su.closenuf(ra,truedefl_dat[0,0]) and su.closenuf(dec,truedefl_dat[0,1])), "ERR: RA/DEC don't match!"
    alpha1_corr=truedefl_dat[1:,0].reshape(2*rad,2*rad)
    alpha2_corr=truedefl_dat[1:,1].reshape(2*rad,2*rad)
    #-------------------------------------------------------------------------------
    # overlay the true deflection angle values on grids of postage stamp img
    imgstamp_name= args.imgstamp_dir+'/'+str(id)+imgstamp_root
    corralpha1_name= args.lenstamp_dir+'/'+str(id)+corralpha1_root
    corralpha2_name= args.lenstamp_dir+'/'+str(id)+corralpha2_root
    lm.replVal(file_in=imgstamp_name,file_out=corralpha1_name,newdata=alpha1_corr)
    lm.replVal(file_in=imgstamp_name,file_out=corralpha2_name,newdata=alpha2_corr)

#-------------------------------------------------------------------------------------------------------------
if args.stop: pdb.set_trace()
#if args.stop: sys.exit('STOPPED PROGRAM AS REQUESTED')
if args.verbose: print '\n:: '+sys.argv[0]+' :: -- END OF PROGRAM -- \n'
#-------------------------------------------------------------------------------------------------------------

