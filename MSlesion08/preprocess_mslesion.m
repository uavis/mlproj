function [patches, V, I_mask, A] = preprocess_mslesion(params)
% Input: params: hyperparams
% Output: 
% patches: patches for learning the dictionary
% V: a cell array, each cell is a number of scaled image in a volume
% I_mask: brain mask
% A: annotations

ntv = params.ntv;   % number of training volumes
V = cell(ntv, 1);   % volumes
A = cell(ntv, 1);   % annotation
A_py = cell(ntv, 1);% annotation in a Gaussian pyramid
I_mask = cell(ntv, 1);% hold mask from multi-modalities
idx = cell(ntv, 1);
Vs = [];            % a cell array of all images from all volumes
Vs_mod1 = [];       % for T1
Vs_mod2 = [];       % for T2
Vs_mod3 = [];       % a cell array of all images from all FLAIR volumes
if params.rfSize(3) > 1
    modality_str = {'T1','T2','FLAIR'};
else
    modality_str = {'FLAIR'};
end

% Initialization
for i = 1:ntv
    % Load the annotations (labels: 0/1) in 3D matrix
    ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,i);  
    A{i} = load_annotation(ant_file);
    % Only keep slices that contain lesions
    % idx are already sorted here
    idx{i} = pick_slice_with_lesion(A{i}, params);
    A{i} = A{i}(:,:,idx{i}); % only keep slices that contain lesions
    % Annotation after applying Gaussian pyramid
    A_py{i} = pyramid(A{i}, params);
end

for i = 1:ntv
    I_mod = []; % hold scan from multi-modalities
    for j = 1:length(modality_str)
        % I is a 3D volume of the scan
        scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s.nhdr',params.scansdir,i,modality_str{j});
        I = load_mslesion(scan);
        % I_mask is the brain mask for the scan
        mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s_mask.nhdr',params.scansdir,i,modality_str{j});
        I_one_mask = load_annotation(mask);
        I_mask{i} = cat(3, I_mask{i}, I_one_mask(:,:,idx{i}));
        % Make the non brain tissue zero
        I = I(:,:,idx{i}).*I_one_mask(:,:,idx{i});
        I_mod = cat(3, I_mod, I);
    end
    % Gaussian Pyramid of the images in volume i, saved in a vector
    % V{i} is a cell array each of which is a scaled image in the pyramid
    % Example:
    % >> size(V{1}{1}) = 516   516
    % >> size(V{1}{2}) = 260   260
    V{i} = pyramid(I_mod, params);
    if 1 == params.rfSize(3)
        % Vs is a vector of cells where each cell is a scaled image
        Vs = [Vs; V{i}];
    else 
        % Group together each modality to make it easier for patch
        % extraction
        Vs_mod1 = [Vs_mod1; V{i}(1 : params.numscales*length(idx{i}))];
        Vs_mod2 = [Vs_mod2; V{i}(params.numscales*length(idx{i})+1 : 2*params.numscales*length(idx{i}))];
        Vs_mod3 = [Vs_mod3; V{i}(2*params.numscales*length(idx{i})+1 : end)];
    end
end
if 3 == params.rfSize(3)
    Vs = [Vs_mod1; Vs_mod2; Vs_mod3];
end
fprintf('How many images do we have: %d\n',length(Vs));
% Extract patches
patches = extract_patches_lesion(Vs, params, A_py);

