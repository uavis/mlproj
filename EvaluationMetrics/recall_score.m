function [recall] = recall_score(y_true, y_pred, label_p, label_n)
% input: label_p: the label for positive
%        label_n: the label for negative
tp = sum( (y_true == y_pred) & (y_true == label_p) );
fn = sum( (y_true ~= y_pred) & (y_pred == label_n) );

if tp || fn
    recall = tp/(tp+fn);
else
    recall = 0;
end

end
