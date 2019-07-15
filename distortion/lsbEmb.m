function s = lsbEmb(c, m, key)

% shuffle
r = zeros(1, numel(c));
r(1) = key;
for i = 2:numel(c)
    r(i) = 3.7*r(i-1)*(1-r(i-1));
end
[~,num] = sort(r);
y = zeros(size(c));
for i = 1:numel(c)
    y(i) = c(num(i));
end

% reshuffle
y2 = [m, y(numel(m)+1:end)];
s = zeros(size(c));
for i = 1:numel(c)
    s(num(i)) = y2(i);

end