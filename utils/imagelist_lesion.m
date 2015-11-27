function im_idx = imagelist_lesion(annotations, params)
% Keep it here for compatibility
% Take a list of annotations and return the z indexes of a selected list of slices
% Parameters:
%               annotations: annotations in 3D matrix
%               params: hyper parameters
% Returns:
%               im_idx:      a list of scaled slices with annotations

%num_slices = size(annotations,3);
num_slices = 10;
% Save the slices in different scales
im_idx = 1:params.numscales * num_slices * params.rfSize(3);
