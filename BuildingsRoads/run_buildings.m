function [D,X,labels] = run_buildings(params)
% Function for learning features and extracting labels
    
    % Load volumes, annotations and pre-process
    disp('Loading and pre-processing data...')
    preprocess(params);

end