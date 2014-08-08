function [alpha_rot,beta_rot]=JacobiRot(alpha_in,beta_in,ctr_in,jacobi)
%------------------------------------------------------------------------------
% JacobiRot function
% Description: rotate/distort the alpha/beta vector in terms of the Jacobi
%              matrix given by external kappa and gamma fields
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     July 2014
% Reliable: 1
%------------------------------------------------------------------------------
fprintf('#------------ enter JacobiRot\n')
%------------ check whether alpha,beta_in are vectors
if min(size(alpha_in))+min(size(beta_in))>2
    fprintf('ERR: input alpha/beta are not vectors!\n')
end
N=length(alpha_in);
%------------ check whether alpha,beta_in have the same dim
if N ~= length(beta_in)
    fprintf('ERR: input alpha and beta have different dimensions!\n')
end
alpha_rot=zeros(N,1);
beta_rot=zeros(N,1);
dalpha= alpha_in-ctr_in(1);
dbeta= beta_in-ctr_in(2);

%------------ constructing Jacobi matrix
k=jacobi.kappa;
g=jacobi.gamma;
phi=jacobi.phi;
fprintf('kappa_ext = %g, gamma_ext=%g, phi=%g (deg)\n',k,g,phi)
phi = phi*pi/180.;
fprintf('now phi looks more normal =%g (RAD)\n',phi)
A1=(1-k)*eye(2);
A2=g*[cos(2*phi) sin(2*phi); sin(2*phi) -cos(2*phi)];
A=A1-A2;

%------------ check whether ctr_in(1,2) really are members of alpha_in,beta_in
for i=1:N
    temp_rot=A*[dalpha(i); dbeta(i)];
    alpha_rot(i)=temp_rot(1)+ctr_in(1);
    beta_rot(i)=temp_rot(2)+ctr_in(2);
    clear temp_rot
end
fprintf('#============ exit JacobiRot\n')
