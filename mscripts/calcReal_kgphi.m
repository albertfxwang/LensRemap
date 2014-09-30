function real_value=calcReal_kgphi(model_value,ratioq,conJparam)
%------------------------------------------------------------------------------
% calcReal_kgphi function
% Description:  Calc the real values of kappa, gamma, phi at img ctr
% Input  :  - model_value is a structure, containing kappa, gamma, phi (in deg)
%           - ratioq is a structure, containing q_+ (".posi") and q_- (".nega")
%           - conJparam is a structure, containing a (C_11), b (C_12), c
%           (C_21), d (C_22)
% Output :  - real_value is a structure, containing the real values of k,
%             g, phi (in deg)
% Tested :  Matlab R2011a
%     By :  Xin Wang                     Sept 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter calcReal_kgphi\n')
%------------ read in param values from "model_value"
kappa=model_value.kappa;
gamma=model_value.gamma;
phi=model_value.phi;
mu=1/((1-kappa)^2-gamma^2);
fprintf('kappa_model=%g, gamma_model=%g, phi_model=%g (deg), mu_model=%g\n',kappa,gamma,phi,mu)
phi=phi/180.0*pi;
%------------ check whether kappa, gamma and phi are all positive
if kappa<0 || gamma<0 || phi<0
    disp('ERR: input model_value has negative components!')
end

%------------ read in param values from "ratioq"
q_posi = ratioq.posi;
q_nega = ratioq.nega;
if abs(q_posi+q_nega) < 1e-4
    disp('>>>WARN: the sum of qs are close to 0!')
end

%------------ read in param values from "conJparam"
a=conJparam.a;
b=conJparam.b;
c=conJparam.c;
d=conJparam.d;
%------------ check whether d has been assigned value
if isnan(d)
    disp('ERR: d has not been assigned value')
end

%------------ calc kappa_real
k = 1 - (1-kappa)/(q_posi+q_nega) * (a*q_nega -b -c +d*q_posi);
if k<0
    fprintf('ERR: calculated kappa_real = %g <0, stop tweaking!\n', k)
end

%------------ calc gamma_real
gsqr = ((1-kappa)/(q_posi+q_nega))^2 * ((a*q_nega -b +c -d*q_posi)^2+4*(a-b*q_posi)^2);
g=sqrt(gsqr);

%------------ calc phi_real
sin2theta = (1-kappa)/(q_posi+q_nega) * 2*(a-b*q_posi)/g;
tan2theta = 2*(b*q_posi-a)/(a*q_nega-b+c-d*q_posi);
temp2theta = atan(tan2theta);   % the arctan result for 2*theta. need some ifs
if sin2theta==1 || sin2theta==-1
    fprintf('>>>WARN(=+/- 1,Inf): sin2theta=%g, tan2theta=%g\n',sin2theta,tan2theta)
    theta=0.5*(pi/2.0+(1-sign(sin2theta))*pi);
elseif sin2theta==0 || tan2theta==0
    fprintf('>>>WARN(=0): sin2theta=%g, tan2theta=%g => cannot distinguish btw 2theta=0 or =pi\n',sin2theta,tan2theta)
    theta=pi/2.0;
elseif sin2theta>0 && tan2theta>0
    theta=0.5*temp2theta;
elseif sin2theta<0 && tan2theta<0
    theta=0.5*(temp2theta+2.0*pi);
else
    theta=0.5*(temp2theta+1.0*pi);
end
theta = theta/pi*180.0;

%------------ calc mu_real
mu_real=1/((1-k)^2-g^2);
fprintf('kappa_real=%g, gamma_real=%g, phi_real=%g (deg), mu_real=%g\n',k,g,theta,mu_real)

real_value=struct('kappa',k,'gamma',g,'phi',theta);     % NOTE: there's no "mu" element!

fprintf('#============ exit calcReal_kgphi\n')

%----------------------------- no use anymore ----------------------------------%
% kappa_true = 1-a*(1-kappa_model)+c/2.0*(bcratio+1)*gamma_model*sin(2*phi_model);
% if kappa_true<0
%     fprintf('ERR: calculated kappa_true = %g <0, stop tweaking!\n', kappa_true)
% end
% 
% gamma_true_sqr= (a*gamma_model*cos(2*phi_model)+c/2.0*(bcratio-1)*gamma_model*sin(2*phi_model))^2+...
%     (a*gamma_model*sin(2*phi_model)-c*(1-kappa_model-gamma_model*cos(2*phi_model)))^2;
% gamma_true=sqrt(gamma_true_sqr);
% 
% tan2phi_true= (a*gamma_model*sin(2*phi_model)-c*(1-kappa_model-gamma_model*cos(2*phi_model)))/...
%     (a*gamma_model*cos(2*phi_model)+c/2.0*(bcratio-1)*gamma_model*sin(2*phi_model));
% true_2phi=atan(tan2phi_true);