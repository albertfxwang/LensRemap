function bool_or_len=CheckVec(x)
%------------------------------------------------------------------------------
% CheckVec function
% Description: check the input is a vector or not
% Input  : - x is arbitrary
% Output : - bool_or_len
%            if x is NOT a vector, bool_or_len is "false", a boolean variable, having the value of 0
%            if x is a vector, bool_or_len stands for the length of this vector
% Tested : Matlab R2011a
%     By : Xin Wang                     August 2014
% Reliable: 2
%------------------------------------------------------------------------------
if min(size(x))>1
    bool_or_len=false;
else
    bool_or_len=length(x);
end