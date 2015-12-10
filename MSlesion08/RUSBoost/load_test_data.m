function [X_test, L_test] = load_test_data(D, params)
%% Load the test data and make prediction
% Load test volumes
disp 'loading test volume'
[annotation, V, V_mask] = load_test_volume(params);
disp 'Put together X_test'
[X_test, L_test] = load_Xtest(V, V_mask, annotation, D, params);

