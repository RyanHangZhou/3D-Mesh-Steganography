function batchEmbedding(input_folder, output_folder_proposed, payload, k, alpha, beta, lambda, n_layer, nlsb, gamma )
%BATCHEMBEDDING Summary of this function goes here
%   Detailed explanation goes here

%   Examine input and output folder
[~, lghPath] = size(input_folder);
if input_folder(lghPath) ~= '/'
    input_folder = strcat(input_folder, '/');
end
[~, lghPath] = size(output_folder_proposed); 
if output_folder_proposed(lghPath) ~= '/'
    output_folder_proposed = strcat(output_folder_proposed, '/');
end

if ~exist(output_folder_proposed, 'dir')
    mkdir(output_folder_proposed);
end

drt = dir(input_folder);
[fnum, ~] = size(drt);

j = str2num(getenv('SLURM_CPUS_PER_TASK'));
parpool(j)
parfor_progress(fnum);

parfor i = 1:fnum
    if drt(i).isdir == 1
        continue;
    end
    [~, lghName] = size(drt(i).name);
    
    if (~contains(lower(drt(i).name), '.off')) || ((strfind(lower(drt(i).name), '.off') + 3) ~= lghName)
            continue;
     end
    inName = strcat(input_folder, drt(i).name);
    outName_proposed = strcat(output_folder_proposed, drt(i).name);

    JointEmbedding(inName, outName_proposed, payload, k, alpha, beta, lambda, n_layer );
    
    parfor_progress;
end

poolobj = gcp('nocreate');
delete(poolobj);

parfor_progress(0);

end