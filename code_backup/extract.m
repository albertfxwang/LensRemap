function b=extract(a)
% to extract non-redundant elements in a
% a and b are both vectors

len=length(a);

for n=1:len
    for m=n+1:len
        if a(m)==a(n)
           a(m)=nan;
        end,
    end,
end;
%去掉a中的非数
a(find(isnan(a)))=[];
b=a;

