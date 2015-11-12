function [dice] = dice_score(img_Orig,img_Seg)

% Image must be in logical format
% Dice similarity co-efficient of segmemted and ground truth image

% Check for logical image (0,1)
if ~islogical(img_Orig)
    error('Image must be in logical format');
end
if ~islogical(img_Seg)
    error('Image must be in logical format');
end

dice = 2*nnz(img_Orig&img_Seg)/(nnz(img_Orig) + nnz(img_Seg))


end