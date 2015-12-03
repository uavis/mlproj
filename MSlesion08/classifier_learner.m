function [model, scaleparams] = classifier_learner(X_train, labels_train, params)
% scaleparams is additional feature scaling params
    if strcmp (params.classifier,'LR')
    % Training Classifier with inhouse LR algorithm
        [model, scaleparams] = learn_classifier(X_train, labels_train, params.n_folds);
    elseif strcmp (params.classifier,'svm')
        model = libsvmtrain( labels_train, X_train);
        scaleparams = [];
    elseif strcmp (params.classifier,'RF')
        model = TreeBagger(params.numTrees,X_train,labels_train, 'Cost', [0 1; 10 0], 'NumPredictorsToSample', 50);
        scaleparams = [];
    end
end
