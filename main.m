% main_batch

clear; clc; close all;

addpath(genpath('functions'));
addpath(genpath('data'));
addpath('distortion'); 


%% conduct steganography
fprintf('Conduct steganography...\n');

alpha = 1;
basic_layer = 8;
nlsb = 10+basic_layer; % actual:-8
beta = 3;
lambda = 10^5;
payload = 0.1;
gamma = 0.001;

fid = fopen('results.txt', 'at');
fprintf(fid, 'nlsb=%.0f, alpha=%.0f, beta=%.1f, lambda=%.0f, payload=%.1f:\n', nlsb, alpha, beta, lambda, payload);
fclose(fid);

distortion(payload, nlsb, alpha, beta, lambda, gamma);
