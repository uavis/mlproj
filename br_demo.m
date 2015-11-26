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
    save('data_train5_OMP4.mat', 'X_train', '-v7.3')
    save('data_test5_OMP4.mat', 'X_test', '-v7.3')
    save data5_OMP4.mat D labels_train labels_test params
    fprintf('Time Spent on Extractig Features for the test dataset in minutes= %f\n', toc/60);
else
    addpath(genpath('.')); % need to add it here in case it bypass set_params_buildings
    load dataRGB.mat
    load data_trainRGB.mat
    load data_testRGB.mat
    params
end


%% Training the Classifier
disp('training the classifier');
tic;
% load data.mat
% load results.mat

X_train1= X_train((labels_train==1), :);
X_train2= X_train((labels_train==0), :);
X_train2= X_train2(1:size(X_train1, 1), :);
X_train= [X_train1; X_train2];
[model, prediction]=classification(labels_train, X_train, labels_test, X_test, params);
disp(sprintf('Time Spent on training the classifier in minutes= %f', toc/60));
save results5_OMP4.mat prediction;
save('model5_OMP4.mat', 'model', '-v7.3')

%Evaluation metrics
%load resultsOMP_Reg_Dtx_Gry.mat
prediction= prediction(:, 2);
[acc, precision, recall, f1, jaccard, dice] = evaluationBuilding(prediction, labels_test)
%temp_visualize_results(prediction, labels_test);


%% Visualize the dictionary
%visualize_dictionary_modalities(D, params)
