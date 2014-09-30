function ratioq=calcq(model_value)
%------------------------------------------------------------------------------
% calcq function
% Description:  Calc the values of q_+ and q_- given the model values of 
%               kappa, gamma, phi at img ctr
% Input  :  - model_value is a structure, containing kappa, gamma, phi (in deg)
% Output :  - ratioq is a structure, containing q_+ (".posi") and q_- (".nega")
% Tested :  Matlab R2011a
%     By :  Xin Wang                     Sept 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter calcq\n')
%------------ read in param values
kappa=model_value.kappa;
gamma=model_value.gamma;
phi=model_value.phi;
mu=1/((1-kappa)^2-gamma^2);
fprintf('mu_model=%g, kappa_model=%g, gamma_model=%g, phi_model=%g (deg)\n',mu,kappa,gamma,phi)
phi=phi/180.0*pi;
%------------ check whether kappa, gamma and phi are all positive
if kappa<0 || gamma<0 || phi<0
    fprintf('ERR: input model_value has negative components!\n')
end
%------------ do calculations of ratios q
q_posi = (1-kappa+gamma*cos(2*phi))/(gamma*sin(2*phi));
q_nega = (1-kappa-gamma*cos(2*phi))/(gamma*sin(2*phi));
fprintf('ratios: q_+ = %g, q_- = %g\n',q_posi,q_nega)
if abs(q_posi+q_nega) < 1e-4
    disp('>>> WARN: the sum of qs are close to 0!')
end

ratioq=struct('posi',q_posi,'nega',q_nega);
fprintf('#============ exit calcq\n')
