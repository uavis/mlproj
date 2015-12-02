function patches = extract_patches_lesion(V, params, A)
% Take a list of images and return the patches
%   Parameters:
%       
%       V:      the list of scaled images
%       params: dictionary of parameters
%       A:      pyramid of annotation 
%   Return:
%       patches: normalized patches from the images


    % Parameters
    rfSize = params.rfSize;
    npatches = params.npatches;

    % Main loop
    patches = zeros(npatches, rfSize(1) * rfSize(2) * rfSize(3));
    disp('Extracting patches...');
    
    %%
%    disp('Extracting patches from the lesion part of the slices...');
    nLesionPatchs = 0;
%     for i = 1:size(A,1)  % number of training volumes
%         for k = 1:size(A{i},1) % loop through each slice
%             tmp_slice = A{i}{k};
%             [rs, cs] = find(tmp_slice);
%             rs = rs(1:min(100, length(rs)));
%             cs = cs(1:min(100, length(cs)));
%             for j = 1:length(rs)
%                 s1 = rs(j); e1 = rs(j)+rfSize(1)-1;
%                 s2 = cs(j); e2 = cs(j)+rfSize(2)-1;
%                 if e1 < size(tmp_slice,1) && e2 < size(tmp_slice,2)
%                     patch = tmp_slice(s1:e1,s2:e2);
%                     % Debug, visualize the patch
% %                     imshow(reshape(patch,[5 5]),[]);
% %                     title(sprintf('patch %d', nLesionPatchs));
% %                     pause;
%                     % Debug END ****************
%                     nLesionPatchs = nLesionPatchs + 1;
%                     patches(nLesionPatchs,:) = patch(:)';
%                 end
%             end
%         end
%     end
%     
%     % only keep up to npatches/2 lesion patches
%     if nLesionPatchs > floor(npatches/2)
%         rand_idx_lesions = randperm(nLesionPatchs,floor(npatches/2));
%         patches(setdiff(1:nLesionPatchs, rand_idx_lesions), :)=[];
%     end
    %%
    % Divide V into three groups
    V1 = V(1:length(V)/3);
    V2 = V(length(V)/3+1:2*length(V)/3);
    V3 = V(2*length(V)/3+1:end);

    for i=nLesionPatchs+1:npatches
        
        if 1==rfSize(3)
            patch = double(V{mod(i-1,length(V))+1}); % a scaled image in the pyramid
            patch = squeeze(patch); % remove sington dimensions
        else
            patchMod1 = double(V1{mod(i-1,length(V1))+1}); % a scaled image in the pyramid
            patchMod1 = squeeze(patchMod1); % remove sington dimensions

            patchMod2 = double(V2{mod(i-1,length(V2))+1}); % a scaled image in the pyramid
            patchMod2 = squeeze(patchMod2); % remove sington dimensions

            patchMod3 = double(V3{mod(i-1,length(V3))+1}); % a scaled image in the pyramid
            patchMod3 = squeeze(patchMod3); % remove sington dimensions

%             if 1 == i
%                 subplot(3,1,1);
%                 imshow(reshape(patchT1,[size(patchT1,1) size(patchT1,2)]),[]);
%                 title(sprintf('patch %d T1', i));
%                 pause;
%                 subplot(3,1,2);
%                 imshow(reshape(patchT2,[size(patchT2,1) size(patchT2,2)]),[]);
%                 title(sprintf('patch %d T2', i));
%                 pause;
%                 subplot(3,1,3);
%                 imshow(reshape(patchFLAIR,[size(patchFLAIR,1) size(patchFLAIR,2)]),[]);
%                 title(sprintf('patch %d FLAIR', i));
%                 pause;
%             end
            patch= cat(3, patchMod1, patchMod2, patchMod3);
        end
        
        
        [nrows, ncols, nmaps] = size(patch);

        if (mod(i,10000) == 0) fprintf('Extracting patch: %d / %d\n', i, npatches); end

        % Extract random block
        not_done = true;
        while not_done
            r = random('unid', nrows - rfSize(1) + 1);
            c = random('unid', ncols - rfSize(2) + 1);
            if all(patch(r,c,:)) % only keep the pixel that are zero on all modalities 
                not_done = false;
            end
        end

        patch = patch(r:r+rfSize(1)-1,c:c+rfSize(2)-1,:);
        % Debug, visualize the patch
%         if 1 == i
%             imshow(reshape(patch(:,:,1),[5 5]),[]);
%             title(sprintf('patch %d T1', i));
%             pause;
%             imshow(reshape(patch(:,:,2),[5 5]),[]);
%             title(sprintf('patch %d T2', i));
%             pause;
%             imshow(reshape(patch(:,:,3),[5 5]),[]);
%             title(sprintf('patch %d FLAIR', i));
%             pause;
%         end
        % Debug END ****************
        patches(i,:) = patch(:)';
    
    end

    disp('Contrast normalization...');
    % +10 offset was added to the variance to avoid dividing by zero and also supressing noise
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,0,2) + 10));

end

