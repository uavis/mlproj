function [model, scaleparams] = classifier_learner(X_train, labels_train, params)
% scaleparams is additional feature scaling params
    if strcmp (params.classifier,'LR')
    % Training Classifier with inhouse LR algorithm
        [model, scaleparams] = learn_classifier(X_train, labels_train, params.n_folds);
    elseif strcmp (params.classifier,'svm')
        model = libsvmtrain( labels_train-1, X_train);
        scaleparams = [];
    elseif strcmp (params.classifier,'RF')
        rng('default') % Make sure it uses the same random number for every test
        model = TreeBagger(params.numTrees,X_train,labels_train,'OOBPred','On', 'Cost', params.cost, 'NumPredictorsToSample', params.npredictors);
        scaleparams = [];
    elseif strcmp (params.classifier,'RUS')
        rng('default') % Make sure it uses the same random number for every test
        t = templateTree('MinLeafSize',5);
        model = fitensemble(X_train,labels_train,'RUSBoost',100,t,...
    'LearnRate',0.1,'nprint',10);
        scaleparams = [];
    end
end
