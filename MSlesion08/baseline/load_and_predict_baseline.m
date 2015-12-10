function [annotation, pred] = load_and_predict(model, params, scaleparams)
%% Load the test data and make prediction
% Load test volumes
disp 'loading test volume'
[annotation,V,V_mask] = load_test_volume_baseline(params);
% Segment all slices of V
disp 'Segmenting test volume'
pred = segment_volume_lesion_light_baseline(V, V_mask, model, params, scaleparams);
