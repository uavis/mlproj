function [precision] = precision_score(y_true, y_pred, label_p, label_n)
% input: label_p: the label for positive
%        label_n: the label for negative

tp = sum( (y_true == y_pred) & (y_true == label_p) );
fp = sum( (y_true ~= y_pred) & (y_pred == label_p) );

if tp || fp
    precision = tp/(tp+fp);
else
    precision = 0;
end

end
