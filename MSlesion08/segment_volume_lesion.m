function yhat = segment_volume_lesion(V, V_mask, model, D, params, scaleparams)
ntv = size(V,1);
yhat = [];
for i = 1:ntv
    fprintf('Processing volume %d\n', i);
    % Gaussian Pyramid
    up = [size(V{i}{1}, 1) size(V{i}{1}, 2)];
    im = pyramid(im, params);

    % Extract first module feature maps
    fprintf('.');

    if 1 == params.rfSize(3)
        % This part is for single modality
        L = extract_features_lesions(V{i}, D, params);
    else
        % This part is for multi-modality
        L= extract_features_modalities_lesion(V{i}, D, params);
    end
    
    % Upsample
    L = upsample_light(L, params.numscales, params.upsample);
    
    preds = false([params.upsample length(L)]); % predictions in 3D volume  
    for slice_index = 1:length(L)
        % Label each pixel
        p = annotate(L{slice_index}, model, mask{i}(:,:,3*(slice_index-1)+1), scaleparams);
        preds(:,:,slice_index) = p>0.5;
    end
    
    yhat = [yhat; preds(:)];
end
yhat = logical(yhat);

end
