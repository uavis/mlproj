function [model, prediction] = classification (labels_train, X_train, labels_test, X_test, params)
    if strcmp (params.classifier,'logistic_reg')
        B = mnrfit(X_train,labels_train+1);
        pihat = mnrval(B,X_test);
        model = B;
        prediction = pihat;
    elseif strcmp (params.classifier,'svm')
        model = libsvmtrain( labels_train, X_train);
        [prediction, accuracy] = libsvmpredict(labels_test, X_test, model);
    elseif strcmp (params.classifier,'RF')
        model = TreeBagger(params.numTrees,X_train,labels_train);
        prediction = predict(model, X_test);
    end
end