function visualize_dictionary(D,varargin)
% This function visualize the dictionary (feature extractor)
k = size(D.codes, 1);
n = size(D.codes, 2);
tmp = zeros(size(D.codes))';

for i=1:k
tmp(:,i) = map_image_to_256(D.codes(i,:)');
end

if nargin>1
    row = varargin{1};
    col = varargin{2};
else
    row = 4;
    col = 8;
end
for i = 1:k
	subplot(row,col,i);
    imshow(uint8(reshape(tmp(:,i), [sqrt(n) sqrt(n)])));
end
end
