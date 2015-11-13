% input: label_p: the label for positive
%        label_n: the label for negative
function [recall] = recall_score(y_true, y_pred, label_p, label_n)
    tp = sum((y_true == y_pred) & (y_true == label_p));
    tn = sum((y_true == y_pred) & (y_true == label_n));
    fp = sum((y_true ~= y_pred) & (y_pred == label_p));
    fn = sum((y_true ~= y_pred) & (y_pred == label_n));

    recall = tp/(tp+fn);

end