function yhat = segment_slice_lesions_baseline(im, mask, model, params, scaleparams)
    % Pre-process image
    up = [size(im, 1) size(im, 2) size(im, 3)];
    if max(mask(:)) > 1; mask = mask ./ 255; end

    % Label each pixel
    X_test = im;
    if strcmp (params.classifier,'LR')
        yhat = annotate(X_test, model, mask, scaleparams);
    elseif strcmp (params.classifier,'svm')
        yhat = libsvmpredict(ones(size(X_test,1)*size(X_test,2),1), reshape(X_test, size(X_test,1)*size(X_test,2), size(X_test,3)), model);
        yhat = reshape(yhat, up(1), up(2), 1);
    elseif strcmp (params.classifier,'RF')
        [~, yhat] = predict(model, X_test(:));
        yhat = reshape(yhat(:, 2), up(1), up(2));
    end

