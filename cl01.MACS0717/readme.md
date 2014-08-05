%: vim: linebreak smartindent formatoptions+=twa

remapping multiple images detected in the field of MACS0717
===================

naming conventions:

    1. "src plane img"/"lens plane img" refer to the surface brightness (SB) profiles of distant galaxies on the 
    src/lens plane.

    2. "src"/"img" are the short-form equivanlences of item 1. So if "img" is used independently (from "plane"), it 
    refers to SB profile on the lens plane. 

    3. when plotting .ps figures, there are some surfices, some with numbers some without, e.g., _fin1.ps, _fin2.ps, 
    _fin.ps . Note that the truly final results are those w/o numbers, in this case _fin.ps! Moreover, their 
    corresponding diary files record all important info in tweaking the images.

    4. if there is no _fin.ps figures, use _fin with the biggest number as the final result

to-do list:

    1. <<<140731>>> mu_tot= mu_ctr * mu_ext  =>  the total effective magnification should include the multiplication by 
    mu_ext= 1/[(1-kappa_ext)^2-|gamma_ext|^2]. So you should add the calculation of mu_ext in srcpix_tot...m

    2. <<<140731>>> there seems no clear dependence of reading in the magnification map, if the mag_ctr can be given in 
    as direct values in the catalog used to cut out image/lensmodel postage stamps. In the meantime, you could put the 
    1-sigma error range for mu_ctr (which can be given by Dan''s webtool) in the catalog as well. So a calculation on 
    the 1-sigma range for mu_tot can also be done.

scaling records:

    scales for sys3 tot_pix_fin
        scale=[2.4 2.4; 3.0 3.0; 1.2 2.4];  scale_tot=[3.7 3.7];
    scales for sys4 tot_pix_fin
        scale, scale_tot = all 1.3
    scales for sys14 tot_pix_fin
        scale=[2.4 2.9; 1.3 1.6; 2.6 2.2];  scale_tot=[3.0 2.7];

7/29/2014
---------
how to fine-tune scales

    first pick the same value for both alpha,beta (x,y) binsizes, see how img is pixelized and how many bins there are.  
    If the resulted y direction has much more bins, it means the count drops are more spread out and a small binsize is 
    more probable to lead to hollow pixels (along x direction!!!). As a result, tune down the y-scale a little bit.

when tuning the _rot plot:
    
    1. before this whole process, do not use the same axial ranges. 1st of all, try to obtain the appropriate ar. when 
    doing this, you can comment out the ylabel of 2nd subplot
    2. tuning the rotation!
    3. after fixing the individual img scales for _rot, those scales should be still used by the _fin plot. The only 
    scale needs to tune is scale_tot

