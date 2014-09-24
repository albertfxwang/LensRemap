function [alpha_rot,beta_rot]=antiJacobiRot(alpha_in,beta_in,ctr_in,bcratio,rotparam)
%------------------------------------------------------------------------------
% antiJacobiRot function
% Description: rotate/distort the alpha/beta vector in terms of the anti-Jacobi
%              matrix in the form of [[a, b], [c, a]]
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

%------------ constructing anti-Jacobi matrix
a=rotparam.a;
c=rotparam.c;
antimat=[a c*bcratio; c a];
fprintf('a = %g, c = %g, bcratio = %g\n',a,c,bcratio)

for i=1:N
    temp_rot=antimat*[dalpha(i); dbeta(i)];
    alpha_rot(i)=temp_rot(1)+ctr_in(1);
    beta_rot(i)=temp_rot(2)+ctr_in(2);
    clear temp_rot
end
fprintf('#============ exit antiJacobiRot\n')
