function visualize_labels_pred(V, gt, preds, vol_index, slice_index)

I = V(:,:,slice_index);
imshow(I,[])
hold on

BW = gt(:,:,slice_index);
B = bwboundaries(BW); % extract the contour, use it as ground truth

ground_truth = B{1};
ground_truth = ground_truth(:,[2 1]); % swap the columns
h1 = plot(ground_truth(:,1), ground_truth(:,2), 'g');

ground_truth = B{2};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'g');

BW = preds>0.5;
B = bwboundaries(BW); % extract the contour, use it as ground truth

ground_truth = B{1};
ground_truth = ground_truth(:,[2 1]); % swap the columns
h3 = plot(ground_truth(:,1), ground_truth(:,2), 'r');

ground_truth = B{2};
ground_truth = ground_truth(:,[2 1]); % swap the columns
plot(ground_truth(:,1), ground_truth(:,2), 'r');

legend([h1 h3],{'Ground Truth','Prediction'});
title(sprintf('Segmentation Result on volume %d, slice %d',vol_index, slice_index));
hold off

end

