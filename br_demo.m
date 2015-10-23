% Demo code for running on building and road datasets
%---------------------------------------

%% Clear up the workspace
clear; close all; clc;

%% Set hyperparameters and data location
set_params_buildings;

%% Run the code for building and road datasets preprocessing
run_buildings(params);

%% Visualize the dictionary
% figure(2);
% visualize_dictionary(D);
