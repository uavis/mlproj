function [X_test, L_test] = load_Xtest(V, V_mask, annotation, D, params)
ntv = size(V,1);
L_test = cell(ntv, 1);
X_test = cell(ntv, 1);
for i = 1:ntv
    % number of slice
    num_slice = size(V{i}, 3)/params.rfSize(3);
    fprintf('The number of slices for testing in volume %d is %d\n', i, num_slice);

    % Label each pixel on each slice
    for slice_index = 1:30
        if 1 == params.rfSize(3)
            im = V{i}(:,:,slice_index);
        else
            im = cat(3, V{i}(:,:,slice_index), V{i}(:,:,num_slice+slice_index), V{i}(:,:,num_slice*2+slice_index));
        end
        mask = V_mask{i}(:,:,slice_index);
        if ~all(all(~mask))
            fprintf('Processing Volume %d, Slice %d ...\n', i,slice_index);
            [X, label] = compute_Xtest(im, mask, annotation{i}(:,:,slice_index), D, params);
            X_test{i} = [X_test{i}; X];
            L_test{i} = [L_test{i}; label];
        end
    end
end

