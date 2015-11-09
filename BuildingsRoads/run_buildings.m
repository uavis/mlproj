function [D,X,labels] = run_buildings(params)
% Function for learning features and extracting labels
    
    %% Load images, annotations and pre-process
    %patches: number_of_patches by patch_width*patch_height. Preporcessed.
    disp('Loading and pre-processing data...')
    [patches, images, labels] = preprocess(params, params.scansdir, params.annotdir, 2);
    
    %% Train dictionary
    %To change the method for dictionary learning, please see inside
    %dictionary function. By default, uses omp-1.
    D = dictionary(patches, params);
    
    %Learning features for each pixel of each picture in the pyramid
    %Compute first module feature maps on slices with annotations
    % This part is for GrayScale Images
    %disp('Extracting first module feature maps...')
    %L = extract_features(images, D, params);
    
    % This part is for RGB Images
    disp('Extracting first module feature maps...')
    nimages= size(images, 1)/(params.numscales*3);
    
    for j=1:params.rfSize(3)
        D_modality.codes= D.codes(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        D_modality.mean= D.mean(:, params.rfSize(1)*params.rfSize(2)*(j-1)+1 : params.rfSize(1)*params.rfSize(2)*j);
        images_modality= images(nimages*params.numscales*(j-1)+1:nimages*j*params.numscales, :);
        L_modality = extract_features(images_modality, D_modality, params);
        
        if j==1
            L= L_modality;
        else
            L= addCells(L, L_modality);
        end
    end
    % Upsample all feature maps
    disp('Upsampling feature maps...')
    L = upsample(L, params.numscales, params.upsample);

    % Compute features for classification
    disp('Computing pixel-level features...')
    X = [];
    for i=1:size(L,1)
        X = [X; reshape(L{i},size(L{i},1)*size(L{i},2),params.numscales*params.nfeats)];
    end

    labels = reshape(labels, size(labels,1)*size(labels,2)*size(labels,3),1);
    
%   X= [];
%   labels=[];
end
