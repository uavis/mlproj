% Demo code for running on ms lession 08 data
%---------------------------------------

%% Clear up the workspace
clear; close all;

if exist ('ms_data.mat', 'file')~=2
    %% Set hyperparameters and data location
    set_params;

    %% Learn features and extract labels
    % D: learned dictionary of filters
    % X: matrix of features for each labelled voxel
    % labels: 0/1 labels for each datapoint in X
    [D, X, labels] = run_mslesion(params);
    % Save results to .mat file
    save ms_data.mat D X labels params
else
    load ms_data
end

% measure time
tic;
%% Train a logistic regression classifier on X
% Applies n_folds cross validation
% model: the resulting model
% scaleparams: means and stds of X
n_folds = 10;
[model, scaleparams] = learn_classifier(X, labels, n_folds);

% Gather time
disp(sprintf('Time Spent on classification in minutes= %f', toc/60));

%% Testing and visulization
%volume_index = 1;
%test_and_visualize(volume_index, params, model, D, scaleparams);
