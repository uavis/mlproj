% function imgZCAwhite= zcawhitening(patches, params)
% %    disp('ZCA Whitening...');
%     img= im2double(patches);
%     
%     cov = img' * img / size(img, 2);
%     [U,S,V] = svd(cov);
% 
%     imgZCAwhite = (U * diag(1./sqrt(diag(S) + 0.1 )) * U' * img')';
%     
% %     img= reshape( patches(1, :), params.rfSize(1), params.rfSize(2));
% %     figure(1), imshow(img);
% %     imgZ= reshape( imgZCAwhite(1, :), params.rfSize(1), params.rfSize(2));
% %     figure(2), imshow(imgZ);
% %     pause;
% end

function imgZCAwhite= zcawhitening(patches, params)
    disp('ZCA Whitening...');

    imgZCAwhite= zeros(size(patches, 1), params.rfSize(1)* params.rfSize(2));
    for i=1: size(patches, 1)
        img= patches(i, :);
        img= im2double(img);
        img= reshape( img, params.rfSize(1), params.rfSize(2));
        
        cov = img * img' / size(img, 2);
        [U,S,V] = svd(cov);

        imgPCAwhite = diag(1./sqrt(diag(S) + eps)) * U' * img;
        imgZCA = U * diag(1./sqrt(diag(S) + 0.1 )) * U' * img;
        imgZCAwhite(i, :)= reshape(imgZCA,1,size(imgZCA,1)*size(imgZCA,2));
        
    end
    
end

