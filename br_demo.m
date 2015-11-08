% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all; clc;

%% Set hyperparameters and data location
set_params_buildings;

%% Run the code for building and road datasets preprocessing
[D, X_train, labels_train] = run_buildings(params);

%%Extractig Features for the test dataset
disp ('extracting features of the test data');
[X_test, labels_test] = test_data_features(D, params);
%%Training the Classifier
disp('training the svm classifier');
classification (labels_train, X_train, labels_test, X_test, params);

%% Visualize the dictionary
% figure(2);
% visualize_dictionary(D);
