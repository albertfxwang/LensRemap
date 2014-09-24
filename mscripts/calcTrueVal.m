function true_value=calcTrueVal(model_value,bcratio,antiJparam)
%------------------------------------------------------------------------------
% calcTrueVal function
% Description: Calc true values of kappa, gamma, phi at img ctr
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     July 2014
% Reliable: 1
%------------------------------------------------------------------------------
fprintf('#------------ enter calcTrueVal\n')
%------------ read in values
kappa_model=model_value.kappa;
gamma_model=model_value.gamma;
phi_model=model_value.phi;
mu_model=1/((1-kappa_model)^2-gamma_model^2);
fprintf('mu_model=%g, kappa_model=%g, gamma_model=%g, phi_model=%g (deg)\n',mu_model,kappa_model,gamma_model,phi_model)
phi_model=phi_model/180.0*pi;
a=antiJparam.a;
c=antiJparam.c;
%------------ check whether kappa, gamma and phi are all positive
if kappa_model<0 || gamma_model<0 || phi_model<0
    fprintf('ERR: input model_value has negative components!\n')
end

kappa_true = 1-a*(1-kappa_model)+c/2.0*(bcratio+1)*gamma_model*sin(2*phi_model);
if kappa_true<0
    fprintf('ERR: calculated kappa_true = %g <0, stop tweaking!\n', kappa_true)
end

gamma_true_sqr= (a*gamma_model*cos(2*phi_model)+c/2.0*(bcratio-1)*gamma_model*sin(2*phi_model))^2+...
    (a*gamma_model*sin(2*phi_model)-c*(1-kappa_model-gamma_model*cos(2*phi_model)))^2;
gamma_true=sqrt(gamma_true_sqr);

tan2phi_true= (a*gamma_model*sin(2*phi_model)-c*(1-kappa_model-gamma_model*cos(2*phi_model)))/...
    (a*gamma_model*cos(2*phi_model)+c/2.0*(bcratio-1)*gamma_model*sin(2*phi_model));
true_2phi=atan(tan2phi_true);
if true_2phi<0
    true_2phi=true_2phi+pi;
end
phi_true=true_2phi/2.0/pi*180.0;

mu_true=1/((1-kappa_true)^2-gamma_true^2);

true_value=struct('mu',mu_true,'kappa',kappa_true,'gamma',gamma_true,'phi',phi_true);
fprintf('mu_true=%g, kappa_true=%g, gamma_true=%g, phi_true=%g (deg)\n',mu_true,kappa_true,gamma_true,phi_true)
fprintf('#============ exit calcTrueVal\n')