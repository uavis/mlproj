function [jaccardIdx,jaccardDist] = jaccard_score(img_Orig,img_Seg)
% This metric is for segmentation
% For classification jaccard_score = accuracy_score
% Jaccard index and distance co-efficient of segmemted and ground truth
% image
% Usage: [index,distance(JC)] = jaccard_score(Orig_Image,Seg_Image);

% Check for logical image (0,1)
if ~islogical(img_Orig)
    error('Image must be in logical format');
end
if ~islogical(img_Seg)
    error('Image must be in logical format');
end

% Find the intersection of the two images
inter_image = img_Orig & img_Seg;

% Find the union of the two images
union_image = img_Orig | img_Seg;

jaccardIdx = sum(inter_image(:))/sum(union_image(:));
% Jaccard distance = 1 - jaccardindex;
jaccardDist = 1 - jaccardIdx;

end