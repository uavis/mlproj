function [gt,V_mod,V_mask] = load_test_volume(params)
% output: gt: ground truth labels
%         V_mod: V_mod{i} is test volume i
%         I_mask: mask for all volumes, I_mask{i} is the mask for volume i (may include three modalities)
ntv = length(params.test_vol);
V_mod = cell(ntv, 1);   % volumes
A = cell(ntv, 1);   % annotation
idx = cell(ntv, 1);
V_mask = cell(ntv, 1);% hold mask from multi-modalities
num_mod = params.rfSize(3);
if num_mod > 1
    modality_str = {'FLAIR','T1','T2'};
else
    modality_str = {'FLAIR'};
end

%% Load the test volume to segment
for i = 1:ntv
    test_idx = params.test_vol(i);
    % Load the annotations (labels: 0/1) in 3D matrix
    ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,test_idx); 
    % make it logical array to work with the eval metrics functions
    A{i} = logical(load_annotation(ant_file));
    if params.pick_slice
        % Only keep slices that contain lesions
        % idx are already sorted here
        idx{i} = pick_slice_with_lesion(A{i}, params);
    else
        % Use all the slices for testing
        idx{i} = 1:params.z_dim;
    end
    A{i} = A{i}(:,:,idx{i}); % only keep slices that contain lesions

    I_mod = []; % hold scan from multi-modalities
    I_mask = [];
    for j = 1:num_mod
        % I is a 3D volume of the scan
        test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s.nhdr',params.scansdir,test_idx,modality_str{j});
        I = load_mslesion(test_scan);
        % I_mask is the brain mask for the scan
        mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s_mask.nhdr',params.scansdir,test_idx,modality_str{j});
        I_one_mask = load_annotation(mask);
        I_mask = cat(3, I_mask, I_one_mask(:,:,idx{i}));
        % Make the non brain tissue zero
        I = I(:,:,idx{i}).*I_one_mask(:,:,idx{i});
        I_mod = cat(3, I_mod, I);
    end
    if 3 == num_mod
        len_idx = length(idx{i});
        % Combine the mask of three modalities into one
        V_mask{i} = I_mask(:,:,1:len_idx).*I_mask(:,:,len_idx+1:2*len_idx).*I_mask(:,:,2*len_idx+1:end);
    else
        V_mask{i} = I_mask;
    end
    V_mod{i} = I_mod;
end
gt = A;
