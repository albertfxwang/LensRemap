function a=posify(a)
% to extract non-negative elements in a and set negative elements to zero
% a can be either in the form of either vector or array

len_tot=numel(a);

for i=1:len_tot
    if a(i)<0
        a(i)=0;
    end
end