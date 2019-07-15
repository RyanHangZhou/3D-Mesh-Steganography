function lambda = calc_lambda(rho, message_length, n)

l3 = 1e0;
m3 = double(message_length + 1);
iterations = 0;
while m3 > message_length
    l3 = l3 * 2;
    m3 = octonion_entropyf(l3, rho);
    iterations = iterations + 1;
    if (iterations > 10)
        lambda = l3;
        return;
    end
end

l1 = 0;
m1 = double(n);
lambda = 0;

alpha = double(message_length)/n;
% limit search to 30 iterations
% and require that relative payload embedded is roughly within 1/1000 of the required relative payload
while  (double(m1-m3)/n > alpha/1000.0 ) && (iterations<30)
    lambda = l1+(l3-l1)/2;
    m2 = octonion_entropyf(lambda, rho);
    if m2 < message_length
        l3 = lambda;
        m3 = m2;
    else
        l1 = lambda;
        m1 = m2;
    end
    iterations = iterations + 1;
end
end