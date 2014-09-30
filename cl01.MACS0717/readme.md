%: vim: wrap linebreak smartindent formatoptions+=twa

remapping multiple images detected in the field of MACS0717
===================

### Naming Conventions:
    1. "src plane img"/"lens plane img" refer to the surface brightness (SB) profiles of distant galaxies on the
    src/lens plane.
    2. "src"/"img" are the short-form equivanlences of item 1. So if "img" is used independently (from "plane"), it
    refers to SB profile on the lens plane.
    3. when plotting .ps figures, there are some surfices, some with numbers some without, e.g., _fin1.ps, _fin2.ps,
    _fin.ps . Note that the truly final results are those w/o numbers, in this case _fin.ps! Moreover, their
    corresponding diary files record all important info in tweaking the images.
    4. if there is no _fin.ps figures, use _fin with the biggest number as the final result.
    5. the names of files created under folder "CorrDefl_"
        1) "pix_CorrDefl.png/.ps" or "pix_fin.png/.ps" : for one total sys, on pixelized src plane
        2) "src_truedefl.png/.ps" : for one total sys, just discrete src points
        3) "_truedefl.dat"        : for one idvd img, the corrected values of alpha
        4) "_corrdefl.png"        : for one idvd img, ds9 scrnshot, four panels, incl. corrected alpha map stamps

### To-do List:
    `WRONG` 1. <<<140731>>> mu_tot= mu_ctr * mu_ext  =>  the total effective magnification should include the
    multiplication by mu_ext= 1/[(1-kappa_ext)^2-|gamma_ext|^2]. So you should add the calculation of mu_ext in
    srcpix_tot...m
    2. <<<140731>>> there seems no clear dependence of reading in the magnification map, if the mag_ctr can be given in
    as direct values in the catalog used to cut out image/lensmodel postage stamps. In the meantime, you could put the
    1-sigma error range for mu_ctr (which can be given by Dan''s webtool) in the catalog as well. So a calculation on
    the 1-sigma range for mu_tot can also be done.
    3. <<<140812>>> in cutting postage stamps from HST RGB image .fits and lens model .fits, be sure that the ones from
    lens model cover larger RA/DEC ranges than those from HST RGB image. If pix_img < pix_lensmodel, the values of "rad"
    can be the same. Design a subroutine to check the ranges.

`WRONG` Scaling and JacobiRot Records (only for tot_pix_fin, i.e., the final result):
  * sys14:  scale=[2.4 2.9; 1.3 1.6; 2.6 2.2];  scale_tot=[3.0 2.7];
            img0=2;  img1=3;  img2=1;
            img1_jacobi=struct('kappa',1.9,'gamma',0.3,'phi',15);
            img2_jacobi=struct('kappa',0.98,'gamma',0.73,'phi',55);
  * sys3:   scale=[2.4 2.4; 3.0 3.0; 1.2 2.4];  scale_tot=[3.7 3.7];
            img0=3;  img1=2;  img2=1;
            img1_jacobi=struct('kappa',0.8,'gamma',1.06,'phi',80);
            img2_jacobi=struct('kappa',0.8,'gamma',0.96,'phi',80);
  * sys4:   scale=[1.9 1.9; 1.3 1.6; 1.5 1.5];  scale_tot=[2.2 2.2];
            img0=3;  img1=2;  img2=1;
            img1_jacobi=struct('kappa',-0.15,'gamma',0.15,'phi',-20);
            img2_jacobi=struct('kappa',0.05,'gamma',0.15,'phi',-30);

`WRONG` Correct tweaking records using anti-Jacobi matrix
  * sys4:    scale=[1.6 1.6; 1.2 1.2; 1.5 1.5]; scale_tot=[2.0 2.0];
            img0=3; img1=2; img2=1;
            img1_antiJ=struct('a',1.1,'c',0.12); img2_antiJ=struct('a',0.85,'c',0.05);
  * sys3:    stuck on 2*phi

### Scales of src plane pixels and values of con-Jacobian matrix for tweaking
  * sys3:   scale=[2.0 2.0; 3.0 3.0; 1.2 2.4];  scale_tot=[3.0 3.0];
            img0=3;  img1=2;  img2=1;
            img1_conJ=struct('a',1.2,'b',-1.1,'c',-0.5,'d',NaN);
            img2_conJ=struct('a',1.2,'b',-1.05,'c',+0.85,'d',NaN);
  * sys4:   scale=[1.9 1.9; 1.2 1.2; 1.5 1.5];  scale_tot=[1.9 1.9];
            img0=3;  img1=2;  img2=1;
            img1_conJ=struct('a',1.05,'b',0.3,'c',0.09,'d',NaN);
            img2_conJ=struct('a',0.98,'b',-0.85,'c',0.65,'d',NaN);
  * sys14:  scale=[2.5 3.0; 1.3 1.6; 2.4 1.2];  scale_tot=[2.6 2.6];
            img0=2;  img1=3;  img2=1;
            img1_conJ=struct('a',-1.3,'b',0.0,'c',-0.2,'d',NaN);
            img2_conJ=struct('a',0.8,'b',-0.35,'c',0.28,'d',NaN);


7/29/2014
---------
how to fine-tune scales
    1. first pick the same value for both alpha,beta (x,y) binsizes, see how img is pixelized and how many bins there 
    are.
    2. If the resulted y direction has much more bins, it means the count drops are more spread out and a small binsize 
    is more probable to lead to hollow pixels (along x direction!!!). As a result, tune down the y-scale a little bit.

when tuning the _rot plot:
    1. before this whole process, do not use the same axial ranges. 1st of all, try to obtain the appropriate ar. when
    doing this, you can comment out the ylabel of 2nd subplot
    2. tuning the rotation!
    3. after fixing the individual img scales for _rot, those scales should be still used by the _fin plot. The only
    scale needs to tune is scale_tot

8/14/2014
---------
  * created folder "obsHSTimg.fits.cat.reg/", which contains the HST full FoV fits image to be cut SL multiple images
    postage stamps from. From now on, for each full FoV fits image and each catalog, the folders named "img..." contains
    only the postage stamps given by the executable python script "cutimg.py". The names should denote which full FoV fits
    image those stamps are from.
  * There should always be only one .cat file at the cluster main folder level, to function as the catalog all procedures
    are based upon.

9/24/2014
---------
  * Re-arrange this folder such that all rslts drawn from the erroneous _JacobiRot_ are put under "0..wrongJacobiRot/"
  * The matlab script doing the correct tweak is called "srcpix_antiJacobi_totsys.m"

9/29/2014
---------
  * Finally completed the correction of deflection angle maps based upon the mathematically rigourous tweaking method
  * During my re-tweaking, I found out that the previous efforts are not totally in vain, because 
    ``test_wrongTweak.diary'' was heavily based on for the calculation of b given the values of a, d, q_+/- and c. For 
    instance, see the case for img 14.3
  ```python
  In [26]: a=-1.1598; d=-0.64019; q_posi=-7.75464; q_nega=-3.11533;
  
  In [27]: c=-0.15; b=(a+c*q_nega-d)/q_posi
  
  In [28]: b
  Out[28]: 0.006745703217686434
  ```



