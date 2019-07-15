function [Ht, H] = binary_entropyf(P)

H = -((P).*log2(P));
H((P<eps) | (P > 1-eps)) = 0;
Ht = sum(sum(H));

end