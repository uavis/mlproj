function [] = visualize_labels_pred(V, gt, preds, slice_index)

I = V(:,:,slice_index);
imshow(I,[])
hold on

BW = gt(:,:,slice_index);
B = bwboundaries(BW); % extract the contour, use it as ground truth

ground_truth = B{1};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'g');

ground_truth = B{2};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'g');

BW = preds>0.5;
B = bwboundaries(BW); % extract the contour, use it as ground truth

ground_truth = B{1};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'r');

ground_truth = B{2};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'r');

hold off

end

