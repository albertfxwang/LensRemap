function conJnew=update_d(ratioq,conJold)
%------------------------------------------------------------------------------
% update_d function
% Description:  Calc the values of q_+ and q_- given the model values of 
%               kappa, gamma, phi at img ctr
% Input  :  - ratioq is a structure, containing q_+ (".posi") and q_- (".nega")
%           - conJold is a structure, containing the values of a (C_11), b (C_12), c
%           (C_21), d (C_22) before this upade on d
% Output :  - conJnew is a structure, containing the values of a (C_11), b (C_12), c
%           (C_21), d (C_22) after this upade on d
% Tested :  Matlab R2011a
%     By :  Xin Wang                     Sept 2014
% Reliable: 2
%------------------------------------------------------------------------------
fprintf('#------------ enter update_d\n')
%------------ read in param values from "ratioq"
q_posi = ratioq.posi;
q_nega = ratioq.nega;
%------------ read in param values from "conJold"
a=conJold.a;
b=conJold.b;
c=conJold.c;
d=conJold.d;
%------------ check whether d has been assigned value
if ~isnan(d)
    fprintf('>>>WARN: d has already have a value of %g\n',d)
end

%------------ calc the real value of d
d = a-q_posi*b+q_nega*c;

fprintf('RSLT: d has been updated to %g\n',d)
conJnew=struct('a',a,'b',b,'c',c,'d',d);

fprintf('#============ exit update_d\n')
