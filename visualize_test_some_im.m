
volume_index = 1;
slice_index = 1:11;
set_params

ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,volume_index);
A = load_annotation(ant_file);
slice_list = pick_slice_with_lesion(A);

%% Load a test volume to segment FLAIR
test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s.nhdr',params.scansdir,volume_index);
V_FLAIR = load_mslesion(test_scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_FLAIR_s_mask.nhdr',params.scansdir,volume_index);
V_mask_FLAIR = load_annotation(mask);

%% Load a test volume to segment T1
test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1_s.nhdr',params.scansdir,volume_index);
V_T1 = load_mslesion(test_scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1_s_mask.nhdr',params.scansdir,volume_index);
V_mask_T1 = load_annotation(mask);

%% Load a test volume to segment T2
test_scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T2_s.nhdr',params.scansdir,volume_index);
V_T2 = load_mslesion(test_scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T2_s_mask.nhdr',params.scansdir,volume_index);
V_mask_T2 = load_annotation(mask);

%%
gt = A;
for i=1:length(slice_list)
    slice_index = slice_list(i);
    
    %% visualize a slice of V_FLAIR
    I = V_FLAIR(:,:,slice_index);
    imshow(I,[])
    hold on
    
    BW = gt(:,:,slice_index);
    B = bwboundaries(BW); % extract the contour, use it as ground truth
    for j=1:length(B)
        ground_truth = B{j};
        ground_truth = ground_truth(:,[2 1]); % swap the column
        % It's okay to overwrite the handle since we only need one for plotting the legends
        h1 = plot(ground_truth(:,1), ground_truth(:,2), 'g');
    end
    pause(0.2);
    
    %% visualize a slice of V_T1
    I = V_T1(:,:,slice_index);
    imshow(I,[])
    hold on
    
    BW = gt(:,:,slice_index);
    B = bwboundaries(BW); % extract the contour, use it as ground truth
    for j=1:length(B)
        ground_truth = B{j};
        ground_truth = ground_truth(:,[2 1]); % swap the column
        % It's okay to overwrite the handle since we only need one for plotting the legends
        h1 = plot(ground_truth(:,1), ground_truth(:,2), 'r');
    end 
    pause(0.2);
    
    %% visualize a slice of V_T2
    I = V_T2(:,:,slice_index);
    imshow(I,[])
    hold on
    
    BW = gt(:,:,slice_index);
    B = bwboundaries(BW); % extract the contour, use it as ground truth
    for j=1:length(B)
        ground_truth = B{j};
        ground_truth = ground_truth(:,[2 1]); % swap the column
        % It's okay to overwrite the handle since we only need one for plotting the legends
        h1 = plot(ground_truth(:,1), ground_truth(:,2), 'b');
    end
    
    pause(0.2);
end





