function stego = getStego(cover, rho, payload)
%GETSTEGO Summary of this function goes here
%   Detailed explanation goes here


wetCost = 10^10;

%   adjust embedding costs
rho(rho > wetCost) = wetCost; % threshold on the costs
rho(isnan(rho)) = wetCost; % if all xi{} are zero threshold the cost

%   embedding simulator
stego = EmbeddingSimulator(cover, rho, payload*numel(cover), false);

function [y] = EmbeddingSimulator(x, rho, m, fixEmbeddingChanges)

    n = numel(x);   
    lambda = calc_lambda(rho, m, n);
    pChangeP = (exp(-lambda .* rho))./(1 + exp(-lambda .* rho));
    pChangeP = pChangeP';
    if fixEmbeddingChanges == 1
        RandStream.setGlobalStream(RandStream('mt19937ar','seed',139187));
    else
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock)));
    end
    randChange = rand(size(x));
    y = x;
    y(randChange < pChangeP) = 1-y(randChange < pChangeP);
    y(randChange >= pChangeP) = y(randChange >= pChangeP);
    
%     Ps = pChangeP1 + pChangeM1;
    
    function lambda = calc_lambda(rho, message_length, n)

        l3 = 1e-2;
        m3 = double(message_length + 1);
        iterations = 0;
        while m3 > message_length
            l3 = l3 * 2;
            p = (exp(-l3 .* rho))./(1 + exp(-l3 .* rho));
            m3 = binary_entropyf(p);
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
            p = (exp(-lambda .* rho))./(1 + exp(-lambda .* rho));
            m2 = binary_entropyf(p);
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
    
    function Ht = binary_entropyf(p)
        p0 = 1-p;
        P = [p0(:); p(:)];
        H = -((P).*log2(P));
        H((P<eps) | (P > 1-eps)) = 0;
        Ht = sum(H);
    end
end
end