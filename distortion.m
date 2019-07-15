function distortion(payload, nlsb, alpha, beta, lambda, gamma)

%% conduct steganography
fprintf('Conduct steganography...\n');


cover_dir = 'data/PSB_cover_norm';
stego_dir = 'data/PSB_stego';


k = 31-nlsb+1;% DONT TOUCH
n_layer = 1;

batchEmbedding(cover_dir, stego_dir, payload, k, alpha, beta, lambda, n_layer, nlsb, gamma);


