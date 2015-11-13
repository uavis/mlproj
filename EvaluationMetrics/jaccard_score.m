% This metric is for segmentation
% For classification jaccard_score = accuracy_score
% Jaccard index and distance co-efficient of segmemted and ground truth
% image
% Usage: [index,distance(JC)] = jaccard_score(Orig_Image,Seg_Image);
function [jaccard] = jaccard_score(img_true,img_pred)
    if ~islogical(img_true)
        error('Image must be in logical format');
    end
    if ~islogical(img_pred)
        error('Image must be in logical format');
    end
    % Check for logical image (0,1)
    jaccard = nnz(img_true & img_pred)/nnz(img_true | img_pred);

end