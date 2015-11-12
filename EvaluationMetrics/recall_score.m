function [recall] = recall_score(y_true, y_pred, label_p, label_n)

tp = (y_true == y_pred) & (y_true == label_p)
tn = (y_true == y_pred) & (y_true == label_n)
fp = (y_true ~= y_pred) & (y_pred == label_p)
fn = (y_true ~= y_pred) & (y_pred == label_n)

recall = tp/(tp+fn);

end