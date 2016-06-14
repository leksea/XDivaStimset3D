function writeXDivaStim(where, blankA, sceneA, blankB, sceneB, ConditionType, number, imageSequence, previewImagesOnly)

        images(:, :, :, 1) = uint8(255.*blankA);        
        images(:, :, :, 2) = uint8(255.*sceneA);
        images(:, :, :, 3) = uint8(255.*blankB);        
        images(:, :, :, 4) = uint8(255.*sceneB);
                   
        number = [num2str(floor(number/10)) num2str(rem(number, 10))];
        filename = [ConditionType  '_' number];
        jpeg_dir = [where filesep 'jpegs'];
        
        if (~exist(jpeg_dir, 'dir'))
            mkdir(jpeg_dir);
        end

        sA = sceneA.^(1/2.2);
        sB = sceneB.^(1/2.2);
        bA = blankA.^(1/2.2);
        bB = blankB.^(1/2.2);
        
        
%         lowpass = fspecial('gaussian', [100 100], 10);
        
        imwrite(sA, fullfile(jpeg_dir,[filename 'A.jpeg']));
        imwrite(sB, fullfile(jpeg_dir, [filename 'B.jpeg']));
        
        
        imwrite(bA, fullfile(jpeg_dir, [filename 'A_blank.jpeg']));
        imwrite(bB, fullfile(jpeg_dir, [filename 'B_blank.jpeg']));
        
        
%         imwrite(imfilter(bA, lowpass), fullfile(jpeg_dir, [filename 'blankA_LP.jpeg']));
%         imwrite(imfilter(bB, lowpass), fullfile(jpeg_dir, [filename 'blankB_LP.jpeg']));
%         
%         imwrite(imfilter(sA, lowpass), fullfile(jpeg_dir, [filename 'blankA_LPS.jpeg']));
%         imwrite(imfilter(sB, lowpass), fullfile(jpeg_dir, [filename 'blankB_LPS.jpeg']));
% 
%         imwrite(imfilter(rgb2gray(bA), lowpass), fullfile(jpeg_dir, [filename 'blankA_LP_GS.jpeg']));
%         imwrite(imfilter(rgb2gray(bB), lowpass), fullfile(jpeg_dir, [filename 'blankB_LP_GS.jpeg']));
%         
%         imwrite(imfilter(rgb2gray(sA), lowpass), fullfile(jpeg_dir, [filename 'blankA_LPS_GS.jpeg']));
%         imwrite(imfilter(rgb2gray(sB), lowpass), fullfile(jpeg_dir, [filename 'blankB_LPS_GS.jpeg']));
        
        
        if (~previewImagesOnly)
            save(strcat(where, filesep, filename, '.mat'), 'images', 'imageSequence');
        end
end

