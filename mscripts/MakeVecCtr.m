function [vector,nelem]=MakeVecCtr(x,x_ctr,binsize)
%------------------------------------------------------------------------------
% MakeVec function
% Description: make a column vector in terms of the range of the input vector x
%              and more importantly the central value x_ctr
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     July 2014
% Reliable: 1
%------------------------------------------------------------------------------
fprintf('#-------------------------------- enter MakeVecCtr\n')
xmin=min(x);
xmax=max(x);
if x_ctr>xmax || x_ctr<xmin
    fprintf('ERR: the central value is out of range!\n')
    vector=NaN;
    nelem=NaN;
else
    fprintf('fixed bin size = %d\n',binsize)
    vl0=(x_ctr:-binsize:xmin);
    vl=[vl0(end)-binsize vl0(end:-1:2)];    % to avoid double counting of x_ctr, stop at 2
        vr0=(x_ctr:binsize:xmax);
    vr=[vr0 vr0(end)+binsize];
    vector=[vl vr].';
    nelem=numel(vector);
    fprintf('the number of bins = %d\n',nelem)
end
fprintf('#================================ exit MakeVecCtr\n')
