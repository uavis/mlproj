function [D,X,labels] = run_mslesion(params)
% Function for learning features and extracting labels
    % Load volumes, annotations and pre-process
    disp('Loading and pre-processing data...')
    tic
    [patches, V, Vlist, I_mask, A] = preprocess_mslesion(params);
    disp(sprintf('Time Spent on Preprocessing in minutes= %f', toc/60));
    if exist ('ms_inter_data.mat', 'file')~=2
        save ms_inter_data.mat patches V Vlist I_mask A
    end

    % Train dictionary
    tic
    D = dictionary(patches, params);
    disp(sprintf('Time Spent on learning the dictionary in minutes= %f', toc/60));

    % Compute first module feature maps
    tic
    disp('Extracting first module feature maps...')
    L = cell(params.ntv, 1);
    for i = 1:params.ntv
        L{i} = extract_features_lesions(V{i}(Vlist{i}), D, params);  % Only extract features from slices with meaningful annotations
    end
    clear V;
    disp(sprintf('Time Spent on Encoding in minutes= %f', toc/60));
    if exist ('ms_inter_feature.mat', 'file')~=2
        save ms_inter_feature.mat L -v7.3
    end

    % Upsample all feature maps
    tic
    disp('Upsampling feature maps...')
    for i = 1:params.ntv
        L{i} = upsample(L{i}, params.numscales, params.upsample);
    end
    disp(sprintf('Time Spent on upsampling in minutes= %f', toc/60));
    if exist ('ms_inter_up_feature.mat', 'file')~=2
        save ms_inter_up_feature.mat L -v7.3
    end

    % Compute features for classification
    tic
    disp('Computing pixel-level features...')
    X = []; labels = [];
    for i = 1:params.ntv
        % Need to pass in the Image data, only convert the brain tissue
        slice_ind = Vlist{i}(params.numscales:params.numscales:end)/params.numscales;
        [tr, tl] = convert2(L{i}, I_mask{i}(:,:,slice_ind), A{i}(:,:,slice_ind), slice_ind, params);
        % Debug *********************
        %plot(1:length(tl), tl);
        %axis([0 length(tl) 0 3]);
        %title('voxel labels on 5 selected slices');
        %ylabel('label'); xlabel('voxel');
        % Debug End *****************
        X = [X; tr];
        labels = [labels; tl];
    end
    disp(sprintf('Time Spent on computing pixel-level features in minutes= %f', toc/60));
