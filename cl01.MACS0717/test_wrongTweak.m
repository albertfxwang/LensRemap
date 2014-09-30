% test previous results based on the erroneous assumption that the rotation
% matrix is an external Jacobian matrix. This test is to see how far off
% the previous results are.

clear all; clc; tic
diary('test_wrongTweak.diary')
addpath ../mscripts/

ext_tot = importdata('z1.855_wrongTweak.dat', ' ', 2);
ext_vals = ext_tot.data(:,2:end);
ext_names= ext_tot.data(:,1);
N_ext = length(ext_names);

LMtot = importdata('z1.855_sharon_LMkgphi.dat', ' ', 2);
LMvals = LMtot.data(:,2:end);
LMnames= LMtot.data(:,1);

%------------ loop over all images w/ non-zero external Jacobian matrix
fprintf('-------- start of checking extJacobian matrix --------\n')
for i = 1:N_ext
    imgname=ext_names(i);
    fprintf(['\n---- below is for img ',num2str(imgname),' ----\n'])
    
    % read in values for lens_ext
    lens_ext=struct('kappa',ext_vals(i,1),'gamma',ext_vals(i,2),'phi',ext_vals(i,3));
    
    % calc the external Jacobian matrix
    Aext=calcJacobiMat(lens_ext);
    
    % read in values for lens_model
    indx=find(ismember(LMnames,imgname));
    lens_model=struct('kappa',LMvals(indx,1),'gamma',LMvals(indx,2),'phi',LMvals(indx,3));
    
    % calc the ratios q
    ratioq=calcq(lens_model);
    
    % calc the correct value for d
    conJold=struct('a',Aext(1,1),'b',Aext(1,2),'c',Aext(2,1),'d',nan);
    conJnew=update_d(ratioq,conJold);
    
    % calc the partial difference of d
    d_old = Aext(2,2);
    d_new = conJnew.d;
    d_diff = abs(d_new-d_old)./d_new;
    
    % calc the real values for the lensing parameters
    lens_real=calcReal_kgphi(lens_model,ratioq,conJnew);
    mu_real=1/((1-lens_real.kappa)^2-lens_real.gamma^2);
    
    % output results to the screen and diary
    fprintf(['For img ',num2str(imgname),', d_ext= ',num2str(d_old),', d_con= ',num2str(d_new),...
        ', with percentage diff= ',num2str(d_diff),'\n'])
    fprintf('Moreover, kappa_real=%g, gamma_real=%g, phi_real=%g, mu_real=%g\n',...
        lens_real.kappa, lens_real.gamma, lens_real.phi, mu_real)
end

fprintf('======== stop of checking extJacobian matrix ========\n')
diary off
