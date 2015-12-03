function yhat = segment_volume_lesion_light(V, V_mask, model, D, params, scaleparams)
% This function calls segment_slice_lesions to segment each slice and put together the predictions
ntv = size(V,1);
yhat = [];
for i = 1:ntv
    % number of slice
    num_slice = size(V{i}, 3)/params.rfSize(3);
    preds = false([params.upsample num_slice]); % predictions in 3D volume  
    % Label each pixel on each slice
    for slice_index = 1:num_slice
        if 1 == params.rfSize(3)
            im = V{i}(:,:,slice_index);
        else
            im = cat(3, V{i}(:,:,slice_index), V{i}(:,:,num_slice+slice_index), V{i}(:,:,num_slice*2+slice_index));
        end
        mask = V_mask{i}(:,:,slice_index);
        p = segment_slice_lesions(im, mask, model, D, params, scaleparams);
        %disp('press enter');
        %pause;
        preds(:,:,slice_index) = reshape(p>0.5, size(preds,1), size(preds,2));
    end
    yhat = [yhat; preds(:)];
end
yhat = logical(yhat);

