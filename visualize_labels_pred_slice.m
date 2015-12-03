function visualize_labels_pred_slice(im, preds)
% Overlays the annotations and predictions onto the original scan.
% Input:
%       im: a slice
%       preds: predictions

imshow(im,[])
hold on

%% visualize labels for prediction
BW = preds>0.5;
B = bwboundaries(BW); % extract the contour of the prediction
for i=1:length(B)
    ground_truth = B{i};
    ground_truth = ground_truth(:,[2 1]); % swap the columns
    % It's okay to overwrite the handle since we only need one for plotting the legends
    h1 = plot(ground_truth(:,1), ground_truth(:,2), 'r');
end

hold off

end

