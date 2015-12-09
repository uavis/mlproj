function yhat = segment_volume_lesion_light(V, V_mask, model, D, params, scaleparams)
% This function calls segment_slice_lesions to segment each slice and put together the predictions
ntv = size(V,1);
yhat = cell(ntv, 1);
%yhat = [];
for i = 1:ntv
    % number of slice
    num_slice = size(V{i}, 3)/params.rfSize(3);
    fprintf('The number of slices for testing in volume %d is %d\n', i, num_slice);
    preds = false([params.upsample(1) params.upsample(2) num_slice]); % predictions in 3D volume  
    % Label each pixel on each slice
    parfor slice_index = 1:num_slice
        if 1 == params.rfSize(3)
            im = V{i}(:,:,slice_index);
        else
            im = cat(3, V{i}(:,:,slice_index), V{i}(:,:,num_slice+slice_index), V{i}(:,:,num_slice*2+slice_index));
        end
        mask = V_mask{i}(:,:,slice_index);
        fprintf('Segmenting Volume %d, Slice %d ...\n', i,slice_index);
        if ~all(all(~mask))
            p = segment_slice_lesions(im, mask, model, D, params, scaleparams);
            preds(:,:,slice_index) = p>0.5;
        else    % if all are zero->no brain tissue->predict negative
            preds(:,:,slice_index) = false([params.upsample(1), params.upsample(2)]);
        end
    end
    yhat{i} = preds;
end

