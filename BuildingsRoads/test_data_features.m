%%Reads data in the test directory, extract its features and lables for
%%evaluation.
function [X, labels] = test_data_features(D, params)
    % Prepocessing
    [patches, images, labels] = preprocess(params, params.testdatadir, params.testgrounddir, 2);
    
    %Learning features for each pixel of each picture in the pyramid
    % Compute first module feature maps on slices with annotations
    %disp('Extracting first module feature maps...')
    %L = extract_features(images, D, params);
    
    
    % Upsample all feature maps
    %disp('Upsampling feature maps...')
    %L = upsample(L, params.numscales, params.upsample);
    
    for j=1:params.rfSize(3)
        D_modality= D.codes(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        images_modality= images(nimages*(j-1)+1:nimages*j*params.numscales, :);
        L_modality = extract_features(images_modality, D_modality, params);
        
        % Upsample all feature maps
        disp('Upsampling feature maps...')
        L_modality = upsample(L_modality, params.numscales, params.upsample);
        if j==1
            L= L_modality;
        else
            L= L+L_modality;
        end
    end
    
    % Compute features for classification
    disp('Computing pixel-level features...')
    X = [];
    for i=1:size(L,1)
        X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end
    labels = reshape(labels, size(labels,1)*size(labels,2)*size(labels,3),1);
end