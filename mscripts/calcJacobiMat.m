function A=calcJacobiMat(lensparam)
%------------------------------------------------------------------------------
% calcJacobiMat function
% Description:  Calc the Jacobian matrix in matrix form given the values of
%               lensing parameters kappa, gamma, phi
% Input  :  - lensparam is a structure, containing kappa, gamma, phi (in deg)
% Output :  - jacobimat is a 2*2 array, the indices are exactly in the form
%             of matrix
% Tested :  Matlab R2011a
%     By :  Xin Wang                     Sept 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter calcJacobiMat\n')
%------------ read in param values
k=lensparam.kappa;
g=lensparam.gamma;
phi=lensparam.phi;
mu=1/((1-k)^2-g^2);
fprintf('input lensing param: kappa=%g, gamma=%g, phi=%g (deg)  => mu=%g\n',k,g,phi,mu)
phi=phi/180.0*pi;
%------------ check whether kappa, gamma and phi are all positive
% if k<0 || g<0 || phi<0
%     fprintf('ERR: input lensparam has negative components!\n')
% end

%------------ calc the Jacobian matrix
A1=(1-k)*eye(2);
A2=g*[cos(2*phi) sin(2*phi); sin(2*phi) -cos(2*phi)];
A=A1-A2;
disp('The corresponding Jacobian matrix is')
disp(A)

fprintf('#============ exit calcJacobiMat\n')