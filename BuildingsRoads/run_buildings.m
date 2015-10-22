function [D,X,labels] = run_buildings(params)
% Function for learning features and extracting labels
    
    % Load images, annotations and pre-process
    disp('Loading and pre-processing data...')
    preprocess(params, 0);

end