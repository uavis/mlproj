function [D,X,labels] = run_mslesion(params)
% Function for learning features and extracting labels
    % Load volumes, annotations and pre-process
    disp('Loading and pre-processing data...')
    tic
    % Some parameters, might move them into `params' later
    ntv = 2;   % number of training volumes
    V = cell(ntv, 1);
    A = cell(ntv, 1);
    A_py = cell(ntv, 1);
    Vlist = cell(ntv, 1);
    I_mask = cell(ntv, 1);
    Vs = [];
    % Initialization
    for i = 1:ntv
        % I is a 3D volume of the scan
        scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1_s.nhdr',params.scansdir,i);
        I = load_mslesion(scan);
        % I_mask is the brain mask for the scan
        mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1_s_mask.nhdr',params.scansdir,i);
        I_mask{i} = load_annotation(mask);
        % Load the annotations (labels: 0/1) in 3D matrix
        ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,i);
        A{i} = load_annotation(ant_file);
        % Only keep slices that contain lesions
        % ind are sorted here
        ind = pick_slice_with_lesion(A{i});
        A{i} = A{i}(:,:,ind); % only keep meaningful slices
        I_mask{i} = I_mask{i}(:,:,ind);
        % Make the non brain tissue zero
        I = I(:,:,ind).*I_mask{i};
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        V{i} = pyramid(I, params);
        A_py{i} = pyramid(A{i}, params);
        % The list of indexes of the slices which contain positive labels (ms lesion)
        Vlist{i} = imagelist_lesion(A{i}, params.numscales);
        % Vs is a vector of cells where each cell is a scaled image
        Vs = [Vs; V{i}];
        clear I;
    end

    % Extract patches
    patches = extract_patches_lesion(Vs, params, A_py);
    clear Vs A_py;
    disp(sprintf('Time Spent on Preprocessing in minutes= %f', toc/60));

    % Train dictionary
    tic
    D = dictionary(patches, params);
    disp(sprintf('Time Spent on learning the dictionary in minutes= %f', toc/60));

    % Compute first module feature maps
    tic
    disp('Extracting first module feature maps...')
    L = cell(ntv, 1);
    for i = 1:ntv
        L{i} = extract_features_lesions(V{i}(Vlist{i}), D, params);  % Only extract features from slices with meaningful annotations
    end
    clear V;
    disp(sprintf('Time Spent on Encoding in minutes= %f', toc/60));

    % Upsample all feature maps
    tic
    disp('Upsampling feature maps...')
    for i = 1:ntv
        L{i} = upsample(L{i}, params.numscales, params.upsample);
    end
    disp(sprintf('Time Spent on upsampling in minutes= %f', toc/60));

    % Compute features for classification
    tic
    disp('Computing pixel-level features...')
    X = []; labels = [];
    for i = 1:ntv
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
