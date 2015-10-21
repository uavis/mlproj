function preprocess(params)
    %%Loading Images
    imagefiles = dir(strcat(params.scansdir,'*.tiff'));      
    nfiles = length(imagefiles);    % Number of files found

    for i=1:nfiles
        currentfilename = imagefiles(i).name;
        currentimage = imread(strcat(params.scansdir, currentfilename));
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        pyr = pyramid(currentimage, params);
        %save pyramidTest.mat pyr 
        % Extract Patches from the Gaussian Pyramid
        
        % Apply Normalization and ZCA Whitening
        %zcawhitening();
        
        imshow(pyr{1});
        pause
    end
end