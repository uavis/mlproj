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
    % labels: 0/1 labels for each sample in X
    [D, X, labels] = run_mslesion(params);
    % Save results to .mat file
    save ms_data.mat D X labels params -v7.3
else
    disp('Loading from ms_data.mat');
    addpath(genpath('.'));
    load ms_data
end

% measure time
tic;
%% Train a classifier on X
% model: the resulting model (theta's)
% scaleparams: means and stds of X for feature standardization
if exist ('ms_classifier.mat', 'file')~=2
    [model, scaleparams] = classifier_learner(X, labels, params);
    save ms_classifier.mat model scaleparams -v7.3
    % Release memory
    clear X labels
else
    disp('Loading from ms_classifier.mat');
    load ms_classifier
end
% Gather time
fprintf('\nTime Spent on classification in minutes= %f\n', toc/60);

%% Getting evaluation metrics
tic;
%% Load the test data and make prediction
[annotation, pred] = load_and_predict(model, D, params, scaleparams);
eval_stats = eval_metric_lesion(annotation, pred);
fprintf('Time Spent on evaluation stats in minutes= %f\n', toc/60);

%% Testing and visulization
%volume_index = 1;
%test_and_visualize(volume_index, params, model, D, scaleparams);
