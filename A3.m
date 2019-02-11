%Course 3D Augmented Reality
%Authors: Attanasio Luca, Savio Francesco

%% ASSIGNMENT A3
% Stereo disparity computation from projected random dot pattern. Given 1
% a couple of stereo images from Aquifi camera, compute disparity 
% using a multi-layer hierarchical approach, i.e.,
% computing the disparity on a reduced resolution version of the two images 
% and re-using the results of this computation 
% at the higher resolution layer.
% Use up to three decomposition layers and measure the complexity reduction 
% and the accuracy obtained.

% Load images
close all;
clear all;

model = 'model3';
version = '1';
% versions = ['1', '2', '3']; % uncomment to print all resultst
% for u = 1:3
%     clearvars -except u versions model
%     version = versions(u);
    fileL = strcat('./imagesStereo/',model,'/file_rectified/masterRect_',version,'.png');
    fileR = strcat('./imagesStereo/',model,'/file_rectified/slaveRect_',version,'.png');
    fileGT = strcat('./imagesStereo/',model,'/gt/Labels/qaRoiRectStereo.png'); %CAMBIA GT CON gt se non va
    imL = imread(fileL);
    imR = imread(fileR);
    GT = imread(fileGT);

    GTgray = rgb2gray(GT);

    if model == 'model1'
        scale_factor = 3.5; %MODEL1 RESCALED BY 3.5
    else
        scale_factor = 2.5; %MODEL2 and MODEL3 RESCALED BY 2.5
    end

    GTgray = double(GTgray)/scale_factor; 

    % Set up parameters
    best_range = [0, 0, 0, 0];
    best_blockSize = [0, 0, 0, 0];
    best_acc = [Inf, Inf, Inf, Inf];

    resize = [1, 1/2, 1/4, 1/8];

    if model == 'model3' %MODEL1 RESCALED BY 3.5
        original_range = 64:16:160; %MODEL3
    else
        original_range = 32:16:160; %MODEL1 e 2
    end
    Init_blockSize = [41, 21, 11, 7]; %MODEL1, 2 e 3

    % Disparity Computation

    for i=1:4 % for each resize factor
        imResizeL = imresize(imL, resize(i));
        imResizeR = imresize(imR, resize(i));

        range = original_range*resize(i);
        range = range(mod(range, 16) == 0);

        for blockSize=5:2:Init_blockSize(i) % for each blockSize
            for disparityRangeEnd=range % for each range

                disparityRange=[ 0 disparityRangeEnd ];

                %compute disparity
                disparityMap = disparity(imResizeL, imResizeR, 'BlockSize', blockSize, ...
                'DisparityRange', disparityRange,...
                'ContrastThreshold',0.1,'UniquenessThreshold',0,'DistanceThreshold',[]);

                GTgrayResize = imresize(GTgray, resize(i));

                %precision
                valid_index=find(~isinf(GTgrayResize(:))); %valid depth (GT)
                index=find(disparityMap(:)>=0); %valid depth (found);
                index_common=intersect(valid_index,index); %common points

                %compute accuracy
                acc=sqrt(mean((GTgrayResize(index_common)-disparityMap(index_common)).^2));

                if acc < best_acc(i)
                    best_acc(i) = acc;
                    best_range(i) = disparityRangeEnd;
                    best_blockSize(i) = blockSize;
                end
            end
        end
    end

    %% Complexity calculation

    complexity = [0, 0, 0, 0];
    for i=1:4
        image = imresize(imL, resize(i));
        im_size = size(image);
        complexity(i) = best_range(i)*im_size(1)*im_size(2);
    end

    %% SHOW ORIGINAL RESULTS

    fprintf("I'M USING "+model+" image #"+version+"\n");
    % fprintf("RESULT FOR ORIGINAL IMAGE\n");
    % FOR LATEX
    fprintf("\nversion & best block & best range & MSE & complexity \\\\ \n");
    fprintf("%s & %2.0f & %3.0f & %f & %2.2f\\\\ \n",version, best_blockSize(1), best_range(1), best_acc(1), complexity(1));


    %% Computy disparity map based on the result of the rescaled images
    for i=2:4

        disparityRange=[ 0 best_range(i)/resize(i)];

        disparityMap = disparity(imL, imR, 'BlockSize', best_blockSize(i)/resize(i) - 1, ...
                'DisparityRange', disparityRange,...
                'ContrastThreshold',0.1,'UniquenessThreshold',0,'DistanceThreshold',[]);

        valid_index=find(~isinf(GTgray(:)));
        index=find(disparityMap(:)>=0); 
        index_common=intersect(valid_index,index);
        New_acc=sqrt(mean((GTgray(index_common)-disparityMap(index_common)).^2));

        mse_reduction = 100 - best_acc(1)*100/New_acc;
        reduction = 100 - complexity(i)*100/complexity(1);
    
        %fprintf("\nReusing the result of image resize by %2.2f for original image\n", resize(i));
        %fprintf("version & resize & best block & best range & MSE & MSE reduction & complexity reduction \n");
        % FOR LATEX
        fprintf("%s & %1.2f & %2.0f & %3.0f & %f & %2.2f \\%% & %2.2f \\%% \\\\ \n", version, resize(i), best_blockSize(i), best_range(i), New_acc, mse_reduction, reduction);
    end
% end