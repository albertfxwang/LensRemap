#!/usr/bin/env python2.7
#+
#----------------------------
#   PURPOSE/DESCRIPTION
#----------------------------
# cut off postage stamps of strongly lensed multiple images from RGB fits files
#----------------------------
#   EXAMPLES/USAGE
#----------------------------
# bash> ./cut_img.py ../z1.855_SLimg.cat MACS0717_F814WF105WF140W_R.fits -v
#----------------------------
#   INPUTS:
#----------------------------
# img_coord        : file containing WCS coord info of multiple images
# img_obsfits      : the RGB fits image to be cut from
#----------------------------
#   OPTIONAL INPUTS:
#----------------------------
# --verbose        : set -verbose to get info/messages printed to the screen
# --stop           : stoppping program before end for de-bugging
# --help           : Printing help menu
#----------------------------
#   REVISION HISTORY
#----------------------------
# based on Kasper's python script GLASS/papers/paper0/plotMagnification.py
#----------------------------
#   MODULES
#----------------------------
import argparse            # argument managing
import sys                 # enabling arguments to code
import os                  # enabling command line runs and executing other Python scripts with os.system('string')
import pyfits as pf
import numpy as np         # enable opening with genfromtxt
import pylab as pl
import matplotlib.pyplot as plt   # importing plotting packages
import pdb                 # for debugging with pdb.set_trace()
import fitstools

#-------------------------------------------------------------------------------------------------------------
# Managing arguments with argparse (see http://docs.python.org/howto/argparse.html)
parser = argparse.ArgumentParser()
# ---- required arguments ---- :
parser.add_argument("img_coord", type=str, help="coordinates in pixel space for the SL images to be cut out")
parser.add_argument("img_obsfits", type=str, help="the RGB fits image to be cut from")
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

#-------------------------------------------------------------------------------------------------------------
# Reading observed RGB fits full HST image
img_name=args.img_obsfits
img = pf.open(args.img_obsfits)[0].data.copy()
print 'The HST fits image to be cut is %s' % img_name

for ii in xrange(Nobj):
    #--------------------------------------------------------------------------
    id=float(IDs[ii])
    ra=float(RAs[ii])
    dec=float(DECs[ii])
    rad=float(rads[ii])
    stampname= str(id)+'_cut.dat'
    raname   = str(id)+'_ra.dat'
    decname  = str(id)+'_dec.dat'
    plotname = str(id)+'_cut.png'
    fitsname = str(id)+'_cut.fits'
    #-------------------------------------------------------------------------- make .dat files
    (x,y)=fitstools.coords2pix(img_name,(ra,dec))   # NOTE this usage - tuple !!
    print 'processing img %s: (RA=%s, DEC=%s)  <=>  (x=%s, y=%s), with rad=%s' % (str(id), str(ra), str(dec), str(x), str(y), 
    str(rad))
    cut = img[y-rad:y+rad,x-rad:x+rad]
    if str(id) == '4.3':
        cut[0:34,24:rad*2]=0
        print 'contamination on %s is cleaned' % id
    
    img_x = np.arange(int(x-rad+1),int(x+rad+1))
    img_y = np.arange(int(y-rad+1),int(y+rad+1))
    X,Y = np.meshgrid(img_x,img_y)
    img_x_tot=X.flatten()
    img_y_tot=Y.flatten()
    img_wcs_tot = fitstools.pix2coords(img_name,(img_x_tot,img_y_tot))
    np.savetxt(stampname,cut.flatten(),fmt='%s')
    np.savetxt(raname,img_wcs_tot[0],fmt='%s')
    np.savetxt(decname,img_wcs_tot[1],fmt='%s')
    #-------------------------------------------------------------------------- plot
    plt.figure()    # create a figure object
    plt.clf()       # clearing figure
    pl.imshow(cut,origin='lower',interpolation='nearest')
    pl.colorbar()
    plt.savefig(plotname,dpi=200)
#    pl.ion()
#    pl.show()
    #-------------------------------------------------------------------------- write fits
    pf.PrimaryHDU(cut).writeto(fitsname,clobber=True)

#-------------------------------------------------------------------------------------------------------------
if args.stop: pdb.set_trace()
#if args.stop: sys.exit('STOPPED PROGRAM AS REQUESTED')
if args.verbose: print '\n:: '+sys.argv[0]+' :: -- END OF PROGRAM -- \n'
#-------------------------------------------------------------------------------------------------------------

