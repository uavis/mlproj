function classification (labels_train, X_train, labels_test, X_test, params)
    if strcmp (params.classifier,'logistic_reg')
        B = mnrfit(X_train,labels_train);
        pihat = mnrval(B,X_test);
    elseif strcmp (params.classifier,'svm')
        model = libsvmtrain( labels_train, X_train);
        [predict_label, accuracy] = libsvmpredict(labels_test, X_test, model);
    end
end