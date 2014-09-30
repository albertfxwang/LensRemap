function [alpha_rot,beta_rot]=conJacobiRot(alpha_in,beta_in,ctr_in,conJparam)
%------------------------------------------------------------------------------
% conJacobiRot function
% Description:  rotate/distort the alpha/beta vector in terms of the con-Jacobi
%               matrix in the form of [[a, b], [c, d]]
% NOTE   :  by "alpha/beta" I really mean that it's "a/b"
% Input  :  - alpha,beta_in are actually vectors of a,b in the src plane before tweak
%           - ctr_in contains the img ctr position in terms of a,b, which
%             is used as a rotation axis
%           - conJparam is a structure, containing a (C_11), b (C_12), c
%           (C_21), d (C_22), where C is exactly the rotation matrix
% Output :  - alpha,beta_rot are the vectors of a,b after the tweak
% Tested :  Matlab R2011a
%     By :  Xin Wang                     Sept 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter conJacobiRot\n')
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

%------------ construct con-Jacobian matrix
rotmat=[conJparam.a conJparam.b; conJparam.c conJparam.d];
disp('The rotation matrix is')
disp(rotmat)

%------------ rotate coordinates
for i=1:N
    temp_rot=rotmat*[dalpha(i); dbeta(i)];
    alpha_rot(i)=temp_rot(1)+ctr_in(1);
    beta_rot(i)=temp_rot(2)+ctr_in(2);
    clear temp_rot
end
fprintf('#============ exit conJacobiRot\n')
