function yhat = segment_volume_lesion(V, mask, model, D, params, scaleparams)
ntv = size(V,1);
%preds = cell(ntv,1);
%L = cell(ntv,1);
yhat = [];
disp('Extracting first module feature maps...')
%false(size(V)); % predictions in 3D volume
for i = 1:ntv

    % Extract first module feature maps
    fprintf('.');
    
    if 1 == params.rfSize(3)
        % This part is for single modality
        L = extract_features_lesions(V{i}, D, params);
    else
        % This part is for multi-modality
        L= extract_features_modalities(V{i}, D, params);
    end
    
    % Upsample
    L = upsample(L, params.numscales, params.upsample);
    
    preds = false([params.upsample length(L)]); % predictions in 3D volume  
    for slice_index = 1:length(L)
        % Label each pixel
        p = annotate(L{slice_index}, model, mask{i}{slice_index}, scaleparams);
        preds(:,:,slice_index) = p>0.5;
    end
    
    yhat = [yhat; preds(:)];
end

end
