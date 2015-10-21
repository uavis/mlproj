function imgZCAwhite= zcawhitening(patches)
    for i=1, size(patches, 1)
        img= patches(1, :, :);
        %img= rgb2gray(img);
        img= im2double(img);
        avg = mean(img, 1);
        img = img - repmat(avg, size(img, 1), 1);

        cov = img * img' / size(img, 2);
        [U,S,V] = svd(cov);

        %imgPCAwhite = diag(1./sqrt(diag(S) + eps)) * U' * img;
        imgZCA = U * diag(1./sqrt(diag(S) + eps )) * U' * img;
        imgZCAwhite{i}= imgZCAwhite;
        %cov2 = imgZCAwhite * imgZCAwhite' / size(imgZCAwhite, 2);
        %error= max(max(abs(cov2-eye(size(imgZCAwhite, 1), size(imgZCAwhite, 2)))))
    end
    
end