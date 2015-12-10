function [V, I_mask, A] = preprocess_baseline(params)
% Input: params: hyperparams
% Output:

ntv = params.ntv;   % number of training volumes
V = cell(ntv, 1);   % volumes
A = cell(ntv, 1);   % annotation
I_mask = cell(ntv, 1);% hold mask from multi-modalities
idx = cell(ntv, 1);

% Initialization
for i = 1:ntv
    % Load the annotations (labels: 0/1) in 3D matrix
    ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,i);  
    A{i} = load_annotation(ant_file);
    % Only keep slices that contain lesions
    % idx are already sorted here
    idx{i} = pick_slice_with_lesion(A{i}, params);
    A{i} = A{i}(:,:,idx{i}); % only keep slices that contain lesions
    % I is a 3D volume of the scan
    scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s.nhdr',params.scansdir,i,'FLAIR');
    I = load_mslesion(scan);
    % I_mask is the brain mask for the scan
    mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s_mask.nhdr',params.scansdir,i,'FLAIR');
    I_mask{i} = load_annotation(mask);
    I_mask{i} = I_mask{i}(:,:,idx{i});
    % Make the non brain tissue zero
    I = I(:,:,idx{i}).*I_mask{i};
    V{i} = I;
end

