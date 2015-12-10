function [X,labels] = run_baseline(params)
% Function for learning features and extracting labels
% Input: params: hyperparams
% Output: 
% X: matrix of features for each labelled voxel
% labels: 1/2 labels for each datapoint in X

% Load volumes, annotations and pre-process
disp('Loading and pre-processing data...')
tic
if exist ('ms_inter_data.mat', 'file')~=2
    [V, I_mask, A] = preprocess_baseline(params);
    fprintf('Time Spent on Preprocessing in minutes= %f\n', toc/60);
else
    disp('Loading from ms_inter_data.mat');
    load ms_inter_data.mat
end

% Compute features for classification
tic
disp('Computing pixel-level features...')
X = []; labels = [];
for i = 1:params.ntv
    % Need to pass in the Image data, only convert the brain tissue
    [tmp_feature, tmp_label] = choose_feature_baseline(V{i}, I_mask{i}, A{i}, params);
    X = [X; tmp_feature];
    labels = [labels; tmp_label];
end
fprintf('Time Spent on computing pixel-level features in minutes= %f\n', toc/60);
