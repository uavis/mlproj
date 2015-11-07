function imgZCAwhite= zcawhitening(patches, params)
    disp('ZCA Whitening...');
    img= im2double(patches);
    
    cov = img' * img / size(img, 2);
    [U,S,V] = svd(cov);

    imgZCAwhite = (U * diag(1./sqrt(diag(S) + 0.1 )) * U' * img')';
    
%     img= reshape( patches(1, :), params.rfSize(1), params.rfSize(2));
%     figure(1), imshow(img);
%     imgZ= reshape( imgZCAwhite(1, :), params.rfSize(1), params.rfSize(2));
%     figure(2), imshow(imgZ);
%     pause;
end