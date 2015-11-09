% Script for setting the parameters
%--------------------------------------------------------------------------


%% Add current folder to the top of the search path
% Do not change
addpath(genpath('.'))
% -------------

%% Set up parameters
% Do not change
params.layer = 1;
params.alpha = 0;
params.D_iter = 50;
% -------------

% Upsampling size. Should be the x,y dimension of the volumes
params.upsample = [1500 1500];

% Number of scales
params.numscales = 6;

% Receptive field size e.g. 9x9
% Assume single modality to simplify
params.rfSize= [9 9 3];
% size of region?
params.regSize = [params.upsample(1) + params.rfSize(1) - 1 params.upsample(2) + params.rfSize(2) - 1 1];
% # of total pixels / # of lesion pixels
params.ratio = 15; % Ask Vincent about that parameter

% Number of patches to train dictionary
params.npatches = 100000;

% Number of features per scale. Total # of features: nfeats * numscales
params.nfeats = 32;

%Type of the classifier 
params.classifier = 'logistic_reg';

%Train data directory
basedir = '/usr/data/BuildingDetectionML/';%'/home/mennatullah/Datasets/BuildingDetectionML/';
params.scansdir = strcat(basedir, 'training/input/');
params.annotdir = strcat(basedir, 'training/target/');

%Test data directory
params.testdatadir = strcat(basedir, 'TestData/');
params.testgrounddir = strcat(basedir, 'TestDataGroundTruht/');

