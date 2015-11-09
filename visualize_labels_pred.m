function visualize_labels_pred(V, gt, preds, vol_index, slice_index)

I = V(:,:,slice_index);
imshow(I,[])
hold on

%% visualize labels for groundtruth
BW = gt(:,:,slice_index);
B = bwboundaries(BW); % extract the contour, use it as ground truth
for i=1:length(B)
    ground_truth = B{i};
    ground_truth = ground_truth(:,[2 1]); % swap the columns
    plot(ground_truth(:,1), ground_truth(:,2), 'g');
end

%% visualize labels for prediction
BW = preds>0.5;
B = bwboundaries(BW); % extract the contour, use it as ground truth
for i=1:length(B)
    ground_truth = B{i};
    ground_truth = ground_truth(:,[2 1]); % swap the columns
    plot(ground_truth(:,1), ground_truth(:,2), 'r');
end

legend([h1 h3],{'Ground Truth','Prediction'});
title(sprintf('Segmentation Result on volume %d, slice %d',vol_index, slice_index));
hold off

end

