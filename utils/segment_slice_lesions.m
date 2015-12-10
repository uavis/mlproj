function yhat = segment_slice_lesions(im, mask, model, D, params, scaleparams)
% yhat is in the shape of the original image im
    % Visualize
    %original_im = im(:,:,1);
    % Pre-process image
    up = [size(im, 1) size(im, 2)];
    im = pyramid(im, params);
    if max(mask(:)) > 1; mask = mask ./ 255; end

    % Extract first module feature maps
    %fprintf('.');
    %disp('Segmenting a test image...')
    %disp('Extracting first module feature maps...')
    if 1 == params.rfSize(3)
        % This part is for single modality
        L = extract_features_lesions(im, D, params);
    else
        % This part is for multi modality
        L = extract_features_modalities_lesion(im, D, params);
    end

    % Upsample
    %disp('Upsampling...')
    L = upsample_light(L, params.numscales, up);

    % Label each pixel
    %disp('Making prediction...')
    X_test = L{1}; % Access the item from the cell array
    %X_test = cat(3,L{1}); % not sure what it does
    if strcmp (params.classifier,'LR')
        yhat = annotate(X_test, model, mask, scaleparams);
    elseif strcmp (params.classifier,'svm')
        yhat = libsvmpredict(ones(size(X_test,1)*size(X_test,2),1), reshape(X_test, size(X_test,1)*size(X_test,2), size(X_test,3)), model);
        yhat = reshape(yhat, up);
    elseif strcmp (params.classifier,'RF')
        [~, yhat] = predict(model, reshape(X_test, size(X_test,1)*size(X_test,2), size(X_test,3)));
        yhat = reshape(yhat(:, 2),up);
    elseif strcmp (params.classifier,'RUS')
        X = reshape(X_test, size(X_test,1)*size(X_test,2), size(X_test,3));
        [~, yhat] = predict(model, X); 
        yhat = reshape(yhat(:, 2),up);
    end

    % Visualize
    %visualize_labels_pred_slice(original_im, yhat);
