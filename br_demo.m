% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all;

%% Set hyperparameters and data location
set_params;
basedir = '/home/mennatullah/Datasets/BuildingDetectionML/training/';
%params.scansdir = strcat(basedir, 'UNC_train_Case');
params.upsample = [1500 1500];
params.scansdir = strcat(basedir, 'input/');
params.annotdir = strcat(basedir, 'target/');

%% Run the code for building and road datasets preprocessing
run_buildings(params);

%% Visualize the dictionary
% figure(2);
% visualize_dictionary(D);
