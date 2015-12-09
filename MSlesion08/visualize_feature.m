function visualize_feature(feature)
% This function visualize the features for each slice of the brain
% and save each feature map to a png file

% The number of features
k = size(feature{1}, 3);
% The number of slices
m = size(feature,1);
% Create a tmp dir for images
src_dir = 'img';
if ~exist(src_dir, 'dir')
    mkdir(src_dir);
end
% Save images
for i=1:m
    x = feature{i};
    for j=1:k
        figure('Visible','off'); 
        imshow(x(:,:,j),[]);
        title_str = sprintf('slice %d, feature %d', i,j);
        title(title_str);
        print(sprintf('%s/slice%dfeature%d',src_dir,i,j),'-dpng');
    end
end
