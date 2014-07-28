function [vector,output]=MakeVec(x,index,variab)
%------------------------------------------------------------------------------
% MakeVec function
% Description: make a column vector in terms of the range of the input vector x
% Input  :
% Output : 
% Tested : Matlab R2011a
%     By : Xin Wang                     July 2014
% Reliable: 1
%------------------------------------------------------------------------------
fprintf('#-------------------------------- enter MakeVec\n')
xmin=min(x);
xmax=max(x);
if index == 1;
    binsize=variab;
    fprintf('fixed bin size = %d\n',binsize)
    vector=(xmin:binsize:xmax).';
    vector=[vector;vector(end)+binsize];
    output=length(vector);
    fprintf('the number of bins = %d\n',output)
    
elseif index == 2
    num=variab;
    fprintf('fixed number of bins = %d\n',num)
    vector=(linspace(xmin,xmax,num)).';
    output=vector(2)-vector(1);
    fprintf('the bin size = %d\n',output)

else fprintf('nothing to do!\n')
    vector=NaN;
    output=NaN;

end
fprintf('#================================ exit MakeVec\n')
%-------------------------------- end ------------------------------
