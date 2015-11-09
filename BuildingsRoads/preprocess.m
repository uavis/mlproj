function [patches_preproc, images, labels] = preprocess(params, imagedir, labeldir,range)
    %%Loading Images
    imagefiles = dir(strcat(imagedir,'*.tiff'));     
    labelfiles = dir(strcat(labeldir,'*.tif'));
    nfiles = length(imagefiles);    % Number of files found
    if range==0
        range= nfiles;
    end
    
    d = 2;  
    sigma = [3 0.1];
    images= [];
    VsR = [];
    VsG = [];
    VsB = [];
    Vs= [];
    labels = [];
    for i=1:range
        currentfilename = imagefiles(i).name;
        currentlabelname = labelfiles(i).name;
        currentlabel = imread(strcat(labeldir, currentlabelname));
        
        labels(:,:,i) =double (currentlabel(:,:,1) > 0);
        %currentimage = rgb2gray(imread(strcat(imagedir, currentfilename)));
        currentimage = imread(strcat(imagedir, currentfilename));
        
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        pyr = pyramid(currentimage, params);
        %save pyramidTest.mat pyr 
        Vs= [Vs; pyr];
        VsR = [VsR; pyr(1:6, :)];
        VsG = [VsG; pyr(7:12, :)];
        VsB = [VsB; pyr(13:end, :)];
        
        %imshow(pyr{1});
        %pause
        clear currentimage;
        clear pyr;
    end
    
    % Extract Patches from the Gaussian Pyramid
    patches = extract_patches_building(Vs, params);
    images = [VsR; VsG; VsB];
    clear Vs;
    
    % Apply ZCA Whitening
    patches_preproc= zcawhitening(patches, params);
    
end