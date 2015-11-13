% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all; clc;


if exist ('data.mat', 'file')~=2
    %% Set hyperparameters and data location
    set_params_buildings;

    %% Run the code for building and road datasets close allpreprocessing
    [D, X_train, labels_train] = run_buildings(params);

    %% Extractig Features for the test dataset
    tic;
    disp ('extracting features of the test data');
    [X_test, labels_test] = test_data_features(D, params);
    save('data_train.mat', 'X_train', '-v7.3')
    save('data_test.mat', 'X_test', '-v7.3')
    save data.mat D labels_train labels_test params
    disp(sprintf('Time Spent on Extractig Features for the test dataset in minutes= %f', toc/60));
else
    load data.mat
    load data_train.mat
    load data_test.mat
end


%% Training the Classifier
disp('training the classifier');
tic;
%load data.mat
%load results.mat
[model, prediction]=classification (labels_train, X_train, labels_test, X_test, params);
disp(sprintf('Time Spent on training the classifier in minutes= %f', toc/60));

%Evaluation metrics
[acc, precision, recall, f1, jaccard, dice] = evaluationBuilding(prediction, labels_test);
save results.mat prediction;
temp_visualize_results(prediction, labels_test);


%% Visualize the dictionary
visualize_dictionary_modalities(D, params)
