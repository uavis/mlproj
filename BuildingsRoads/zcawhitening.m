function imgZCAwhite= zcawhitening(patches, params)
    disp('ZCA Whitening...');

    imgZCAwhite= zeros(size(patches, 1), params.rfSize(1), params.rfSize(2));
    for i=1: size(patches, 1)
        img= patches(i, :);
        %img= rgb2gray(img);
        img= im2double(img);
        img= reshape( img, params.rfSize(1), params.rfSize(2));
        %already contrast normalization is done in extract_patches function
        %avg = mean(img, 1);
        %img = img - repmat(avg, size(img, 1), 1);
    
        cov = img * img' / size(img, 2);
        [U,S,V] = svd(cov);

        %imgPCAwhite = diag(1./sqrt(diag(S) + eps)) * U' * img;
        imgZCA = U * diag(1./sqrt(diag(S) + 0.1 )) * U' * img;
        imgZCAwhite(i, :, :)= imgZCA;
        %figure(1), imshow(img);
        %figure(2), imshow(imgZCA);
        %pause
        
        %cov2 = imgZCAwhite * imgZCAwhite' / size(imgZCAwhite, 2);
        %error= max(sum(abs(cov2-eye(size(imgZCAwhite, 1), size(imgZCAwhite, 2)))))
    end
    
end