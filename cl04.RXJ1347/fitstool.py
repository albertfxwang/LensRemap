# this file contains some tools to manipulate .fits files
# some of them are based on Ale's scripts: /data3/sonnen/Python/sonnentools

import pyfits
from numpy import *
#from sonnentools import astrometry as at
#from scipy.interpolate import splrep,splev

def pix2coords(name,pixs,HDU=0):
#this program finds the world coordinates (RA and dec) of a given pixel of an image.
    import pyfits,numpy
    header = pyfits.open(name)[HDU].header.copy()
    rotM = numpy.array([[header['CD1_1'],header['CD1_2']],[header['CD2_1'],header['CD2_2']]])#rotation matrix: from pixels to world coordinates
    xref = header['CRPIX1']
    yref = header['CRPIX2']
    RAref = header['CRVAL1']
    decref = header['CRVAL2']
    dx = pixs[0] - xref
    dy = pixs[1] - yref
    dworld = numpy.dot(rotM,numpy.array((dx,dy)))
    return (RAref+dworld[0]/numpy.cos(numpy.deg2rad(decref)),decref+dworld[1])


def coords2pix(image,coords,HDU=0):
#Finds pixels corresponding to an astrometric coordinate.
#coords must be a tuple and coordinates must be in degrees

    hdu = pyfits.open(image)[HDU]
    header = hdu.header
    RA_ref = header['CRVAL1']
    dec_ref = header['CRVAL2']
    x_ref = header['CRPIX1']
    y_ref = header['CRPIX2']
    rotM = array([[header['CD1_1'],header['CD1_2']],[header['CD2_1'],header['CD2_2']]])#rotation matrix: from pixels to world coordinates
    inv_rotM = linalg.inv(rotM)
    dRA = (coords[0] - RA_ref)*cos(deg2rad(dec_ref))
    ddec = coords[1] - dec_ref
    dpix = dot(inv_rotM,array((dRA,ddec)))
    return (x_ref + dpix[0],y_ref + dpix[1])


