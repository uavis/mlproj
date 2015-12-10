function [X, label] = compute_Xtest(im, mask, annotation, D, params)
% X is the test data for this slice
    % Pre-process image
    up = [size(im, 1) size(im, 2)];
    im = pyramid(im, params);
    if max(mask(:)) > 1; mask = mask ./ 255; end

    % Extract first module feature maps
    if 1 == params.rfSize(3)
        % This part is for single modality
        L = extract_features_lesions(im, D, params);
    else
        % This part is for multi modality
        L = extract_features_modalities_lesion(im, D, params);
    end

    % Upsample
    L = upsample_light(L, params.numscales, up);

    % Label each pixel
    X_test = L{1}; % Access the item from the cell array
    X = reshape(X_test, size(X_test,1)*size(X_test,2), size(X_test,3));
    label = reshape(annotation, size(X,1), 1) + 1; % +1 to match the format of training label

