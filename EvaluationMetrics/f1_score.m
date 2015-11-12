function [f1] = f1_score(y_true, y_pred, label_p, label_n)

precision = precision_score(y_true, y_pred, label_p, label_n);
recall = recall_score(y_true, y_pred, label_p, label_n);

f1 = 2*precision*recall/(precision+recall);

end