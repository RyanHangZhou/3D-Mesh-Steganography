function z = getModiCoord(x, y, v, b)
%GETMODICOORD Summary of this function goes here
%   Detailed explanation goes here

z = v;

if x~=y
    if x==1
        z = z-2^(-b);
    else
        z = z+2^(-b);
    end
end


