function stats = eval_metric_lesion(A, preds)
%% Compute metrics
% The value of pos or neg labels
label_p = 1;
label_n = 0;
gt = false(0);
p = false(0);
for i=1:size(A,1)
    gt = [gt; A{i}(:)];
    p = [p; preds{i}(:)];
end

% jaccard
stats.jaccard = jaccard_score(gt,p);
% dice
stats.dice = dice_score(gt,p);
% f1
stats.f1 = f1_score(gt, p, label_p, label_n);
% precision
stats.precision = precision_score(gt, p, label_p, label_n);
% recall
stats.recall = recall_score(gt, p, label_p, label_n);
% accuracy
stats.accuracy = accuracy_score(gt, p);
% Print to the console
fprintf('The accuracy is: %f\n', stats.accuracy);
fprintf('The precision(PPV) is: %f\n', stats.precision);
fprintf('The recall(TPR) is: %f\n', stats.recall);
fprintf('The f1(DSC) score is: %f\n', stats.f1);
fprintf('The jaccard score is: %f\n', stats.jaccard);
fprintf('The dice score is: %f\n', stats.dice);

