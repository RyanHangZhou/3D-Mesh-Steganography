function [y, z] = getBitplane(x, b)
%GETBITPLANE Summary of this function goes here
%   Detailed explanation goes here

% x = 0.1734;
% b = 5;

z = x;

%%  clear >=1 &<=-1 part
while x>=1
    x = x-1;
end

while x<=-1
    x = x+1;
end

x = abs(x);

for i=1:b
    x = x*2;
    if(x>=1)
        y = 1;
        x = x-1;
    else
        y = 0;
    end
end

%%  outut
z = z-y*2^(-b);
