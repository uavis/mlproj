function temp_visualize_results(prediction, labels_test)
   if params.classifier=='log_Reg'
        p = prediction(:, 2)> prediction(:, 1);
        acc= length(find(p==labels_test))/length(p)
        
        imgP= reshape(prediction(1:1500*1500, 2), 1500, 1500);
        imshow(imgP);
    else
        for i=1:length(prediction)
            if str2num(prediction{i})==labels_test(i)
                counter= counter+1;
            end
        end
        acc= counter/length(prediction)
        
        imgP= reshape(prediction(1:1500*1500, 1), 1500, 1500);
        imshow(imgP);
   end
    
    imgGt= reshape(labels_test(1:1500*1500), 1500, 1500);
    figure, imshow(imgGt);
end