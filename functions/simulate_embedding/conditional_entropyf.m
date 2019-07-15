function Ht = conditional_entropyf(P, P2)

H = -((P).*log2(P));
H((P<eps) | (P > 1-eps)) = 0;
H2 = [H(1, :)+H(2, :)+H(3, :)+H(4, :); H(5, :)+H(6, :)+H(7, :)+H(8, :)];
H3 = H2.*P2;
Ht = sum(sum(H3));

end