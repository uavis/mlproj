function [optval, acc] = xval(X, L, vals, numfolds)

% Split into folds
% Balancing the positive and negative samples in each fold
folds = generateFolds(X, L, numfolds);




% Loop over values
acc = zeros(length(vals), 1);
for i = 1:length(vals)
    
    % Loop over folds
    accfold = zeros(length(numfolds), 1);
    parfor j = 1:numfolds
        
        % Use one fold as the test set, the other folds are used for training
        [trainSet, testSet, labelsTrain, labelsTest] = generateSets(X, L, folds, j);
        [trainSet, scaleparams] = standard(trainSet);
        % use the scaling parameters from the training set
        testSet = standard(testSet, scaleparams); 
        theta = softmax_regression(trainSet, labelsTrain, 2, vals(i));
        [~, M] = predict(theta, testSet);
        yhat = (M(2,:) >= 0.5)' + 1;
        
        accfold(j) = mean(yhat == labelsTest);
        
    end
    acc(i) = mean(accfold);
    disp(['Mean accuracy with parameter ' num2str(vals(i)) ': ' num2str(acc(i))]);
    
end

% Return optimal parameter
[foo, ind] = max(acc);
optval = vals(ind);
disp(' ');




