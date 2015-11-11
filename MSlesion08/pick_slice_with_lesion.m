function [idx_z] = pick_slice_with_lesion(slices)
% This function will return the idices that have lesion

idx_z = [];

for i = 1:size(slices, 3)
   slice = slices(:,:,i);
   if sum(sum(slice)) > 0
       idx_z = [idx_z i];
   end
    
end

length(idx_z)


end