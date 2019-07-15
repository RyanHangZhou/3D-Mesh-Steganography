function Ht = octonion_entropyf(l3, rho)

rho1 = exp(-l3 .* rho);
P = rho1./(repmat(sum(rho1, 1), 8, 1)); 
H = -((P).*log2(P));
H((P<eps) | (P > 1-eps)) = 0;
Ht = sum(sum(H));

end