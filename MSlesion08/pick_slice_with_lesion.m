function [idx_z, num_pos_labels] = pick_slice_with_lesion(slices, params)
% This function will return the indices that have lesion
% Input: 
%   slices: annotations in a 3D matrix
%   params: hyper parameters
% Output:
%   idx_z: the list of z-index where there are lesions, it's sorted
idx_z = [];

for i = 1:size(slices, 3)
   slice = slices(:,:,i);
   if sum(sum(slice)) > 0
       idx_z = [idx_z i];
   end
    
end

fprintf('The number of slices that contain lesions is: %d\n', length(idx_z));

[ num_pos_labels, sorted_idx ] = sort_lesion_slices( idx_z, slices );
idx_z = sorted_idx; % sorted in descending order

%num_slices = size(slices,3); % use all slices
num_slices = 10;
idx_z = idx_z(1:num_slices);
fprintf('Picking the top %d slices\n', num_slices);
fprintf('The total number of lesions in the top %d are %d\n', num_slices, sum(num_pos_labels(1:num_slices)));

end

