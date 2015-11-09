% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all; clc;

%% Set hyperparameters and data location
set_params_buildings;

if exist ('data.mat', 'file')~=2
    %% Set hyperparameters and data location
    set_params_buildings;

    %% Run the code for building and road datasets preprocessing
    [D, X_train, labels_train] = run_buildings(params);

    %%  Visualizing Dictionary for testing
    for i=1:5
        t= D.codes(i, :);
        img= reshape(t, params.rfSize(1), params.rfSize(2), params.rfSize(3));
        figure, imshow(img);
    end

    %% Extractig Features for the test dataset
    disp ('extracting features of the test data');
    [X_test, labels_test] = test_data_features(D, params);
    save('data_train.mat', 'X_train', '-v7.3')
    save('data_test.mat', 'X_test', '-v7.3')
    save data.mat D labels_train labels_test params
else
    load data.mat
    load data_train.mat
    load data_test.mat
end


%% Training the Classifier
disp('training the svm classifier');
[model, prediction]=classification (labels_train, X_train, labels_test, X_test, params);
save results.mat prediction;
p = prediction(:, 2)> prediction(:, 1);
acc= length(find(p==labels_test))/length(p)

%% Visualize the dictionary
% figure(2);
% visualize_dictionary(D);
