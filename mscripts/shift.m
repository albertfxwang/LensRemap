function [alpha_shift,beta_shift]=shift(alpha_in,beta_in,ctr_in,ctr_shift)
%------------------------------------------------------------------------------
% shift function
% Description: shift the alpha/beta vector in terms of the difference in
%              the center point
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     July 2014
% Reliable: 1
%------------------------------------------------------------------------------
fprintf('#------------ enter shift\n')
%------------ check whether alpha,beta_in are vectors
if min(size(alpha_in))+min(size(beta_in))>2
    fprintf('ERR: input alpha/beta are not vectors!\n')
end

delta= ctr_shift-ctr_in;
alpha_shift=alpha_in+delta(1);
beta_shift= beta_in+delta(2);
fprintf('#============ exit shift\n')
%----------------------------- no use anymore ----------------------------------%
% indx_alpha= find(ismember(alpha_in,ctr_in(1)));
% indx_beta=  find(ismember(beta_in,ctr_in(2)));
%------------ check whether ctr_in(1,2) really are members of alpha_in,beta_in
% if isempty(indx_alpha) || isempty(indx_beta)
%     fprintf('ERR: input ctr are not members of input alpha/beta vectors!\n')
% else
% absdiff_alpha=abs(alpha_shift(indx_alpha)-ctr_shift(1));
% absdiff_beta=abs(alpha_shift(indx_beta)-ctr_shift(2));
% if absdiff_alpha/ctr_shift(1) + absdiff_beta/ctr_shift(2) > 1e-6
%     fprintf('ERR: the shift of the center point is not complete!\n')
% end