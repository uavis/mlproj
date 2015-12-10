function [annotation, pred] = load_and_predict(model, D, params, scaleparams)
%% Load the test data and make prediction
% Load test volumes
disp 'loading test volume'
[annotation,V,V_mask] = load_test_volume(params);
% Segment all slices of V
disp 'Segmenting test volume'
pred = segment_volume_lesion_light(V, V_mask, model, D, params, scaleparams);

