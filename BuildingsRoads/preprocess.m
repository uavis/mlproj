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
        if(params.rfSize(3)==1)
            currentimage = rgb2gray(imread(strcat(imagedir, currentfilename)));
        else
            currentimage = imread(strcat(imagedir, currentfilename));
        end
        
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        pyr = pyramid(currentimage, params);
        Vs= [Vs; pyr]; 
        
        if(params.rfSize(3)>1)
            VsR = [VsR; pyr(1:6, :)];
            VsG = [VsG; pyr(7:12, :)];
            VsB = [VsB; pyr(13:end, :)];
        end
        
        %imshow(pyr{1});
        %pause
        clear currentimage;
        clear pyr;
    end
    
   % Extract Patches from the Gaussian Pyramid
   patches = extract_patches_building(Vs, params);
   
   save patches.mat patches
   % load patchesRGB.mat
    if(params.rfSize(3)>1)
        images = [VsR; VsG; VsB];
    else
        images= Vs;
    end
    clear Vs;
    
    % Apply ZCA Whitening
     %if(params.rfSize(3)==1)
     patches_preproc= zcawhitening(patches, params);
%     else
%         patchesRGB= reshape(patches, params.npatches, params.rfSize(1), params.rfSize(2), params.rfSize(3));
%         patches_p= {};
%         for i=1:params.rfSize(3)
%             p= patchesRGB(:, :, :, i);
%             p= reshape(p, params.npatches, params.rfSize(1)*params.rfSize(2));
%             p_preproc= zcawhitening(p, params);
%             patches_p= [patches_p; p_preproc];
%         end
%         patches_preproc= cat(3, patches_p{1}, patches_p{2}, patches_p{3});
%         patches_preproc = reshape(patches_preproc, params.npatches, params.rfSize(1)*params.rfSize(2)*params.rfSize(3));
%         clear patches_p; clear p_preproc; clear patchesRGB;
%     end
    
    %patches_preproc= patches;
    
end
