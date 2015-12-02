function [gt,V,I_mask] = load_test_volume(params)
ntv = length(params.test_vol);
V = cell(ntv, 1);   % volumes
A = cell(ntv, 1);   % annotation
idx = cell(ntv, 1);
gt = [];
I_mask = cell(ntv, 1);% hold mask from multi-modalities
if params.rfSize(3) > 1
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
    % Only keep slices that contain lesions
    % idx are already sorted here
    idx{i} = pick_slice_with_lesion(A{i}, params);
    A{i} = A{i}(:,:,idx{i}); % only keep slices that contain lesions
    gt = [gt; A{i}(:)];
    I_mod = []; % hold scan from multi-modalities
    for j = 1:length(modality_str)
        % I is a 3D volume of the scan
        test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_%3$s_s.nhdr',params.scansdir,i,modality_str{j});
        I = load_mslesion(test_scan);
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
    V{i} = pyramid(I_mod, params);
end
gt = logical(gt);

