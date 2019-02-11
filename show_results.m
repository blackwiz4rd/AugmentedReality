
%% PLOT IMAGES
% figure(15);
% subplot(1,2,1);
% imshow(GTgray, [0 best_range(1)]);
% colormap jet 
% colorbar
% title('Ground truth');
% 
% 
% disparityM = disparity(imL, imR, 'BlockSize', best_blockSize(1), ...
%             'DisparityRange', [0 best_range(1)],...
%             'ContrastThreshold',0.1,'UniquenessThreshold',0,'DistanceThreshold',[]);
%         
% figure(15);
% subplot(1,2,2);
% imshow(disparityM, [0 best_range(1)]);
% colormap jet 
% colorbar
% title('Disparity Map');
% 
% %% VISUALIZZAZIONE IMMAGINI RISCALATE
% 
% %Per visualizzazione immagini 
% a = 8; %fattore di riscalo
% b = 7; % block size
% c = 16; % range
% GT = imread(fileGT);
% 
% GTgray = rgb2gray(GT);
% 
% GTgray = double(GTgray)/scale_factor;
% GTgray = imresize(GTgray,1/a);
% 
% figure(16);
% subplot(1,2,1);
% imshow(GTgray, [0 c*a]);
% colormap jet 
% colorbar
% title('Ground truth');
% 
% 
% disparityM = disparity(imL, imR, 'BlockSize', b*a-1, ...
%             'DisparityRange', [0 c*a],...
%             'ContrastThreshold',0.1,'UniquenessThreshold',0,'DistanceThreshold',[]);
% 
% figure(16);
% subplot(1,2,2);
% imshow(disparityM, [0 c*a]);
% colormap jet 
% colorbar
% title('Disparity Map');

%%
% disp(a);
% disp(" ");
% disp("image resize & mse & best block size & complexity");
% disp(" "); 
% complexity = [0, 0, 0, 0];
% for i=1:4
%     image = imresize(imL, resize(i));
%     im_size = size(image);
%     complexity(i) = best_range(i)*im_size(1)*im_size(2);
%     
%     fprintf("%2.2f & %f & %2.2f & %2.2f & %2.2f \\\\ \n", resize(i), best_acc(i), best_blockSize(i), best_range(i), complexity(i));
%     %fprintf("With Image resize by %2.2f complexity was \n", resize(i), complexity(i));
%     
% end
% %%
% disp(" ");
% fprintf("Comparing w.r.t original\n");
% disp(" ");
% disp("Image resize & complexity decrese by & original image perform better by ");
% for i=2:4
%     reduction = 100 - (complexity(i)*100)/complexity(1);
%     mse =100 - (best_acc(1)*100)/best_acc(i);
%     
%     %fprintf("\nUsing the best value of image rescaled by %2.2f the complexity reduction was %2.2f %% and mse perform %2.2f %% respect to the original",...
%     %    resize(i), reduction, mse);
%     fprintf("%2.2f & %2.2f %% & %2.2f %% \\\\ \n",...
%         resize(i), reduction, mse);
% end
% 
% % other interesting resulsts
% disp(" ")
% fprintf("comparing wrt 1/2\n")
% for i=3:4
%     reduction = 100 - (complexity(i)*100)/complexity(2);
%     mse =100 - (best_acc(2)*100)/best_acc(i);
%  fprintf("%2.2f & %2.2f %% & %2.2f %% \\\\ \n",...
%         resize(i), reduction, mse);
% end
% disp (" ");
% fprintf("wrt 1/4\n")
% for i=4:4
%     reduction = 100 - (complexity(i)*100)/complexity(3);
%     mse =100 - (best_acc(3)*100)/best_acc(i);
%     
%     fprintf("%2.2f & %2.2f %% & %2.2f %% \\\\ \n",...
%         resize(i), reduction, mse);
% end

%% SHOW RESULTS
% 
% % %% Show the disparity map.
% for i=1:4
%     disparityRange = [0 best_range(i)];
%     disparityMap = disparity(imL, imR, 'BlockSize', blockSize, ...
%             'DisparityRange', disparityRange,...
%             'ContrastThreshold',0.1,'UniquenessThreshold',0,'DistanceThreshold',[]);
%             
%     figure(i);
%     subplot(1,2,1);
%     imshow(disparityMap, disparityRange);
%     colormap jet;
%     colorbar
%     var = "Disparity image rescaled by"+resize(i)+" ";
%     title(var);
% 
% 
%     figure(i);
%     subplot(1,2,2);
%     imshow(GTgray, disparityRange);
%     colormap jet 
%     colorbar
%     title('Ground truth');
% %     savefig(strcat('imgs/disparity',num2str(i),'.fig'))
%     
%     %compute values for heat map
%     valid_index=find(~isinf(GTgray(:))); %valid depth (GT)
%     index=find(disparityMap(:)>=0); %valid depth (found);
%     index_common=intersect(valid_index,index); %common points
% 
%     heatMapDiff=zeros(size(GTgray));
%     heatMapDiff(index_common)=abs(GTgray(index_common)-disparityMap(index_common));
%     
%     %visualize heat map of differences
% %     figure(i+4)
% %     imagesc(heatMapDiff);
% %     colormap(hot);
% %     colorbar;
% %     savefig(strcat('imgs/heat',num2str(i),'.fig'))
% end

% figure(9);
% subplot(1,2,1);
% %imshow(imL);
% title("Left image");
% subplot(1,2,2)
% %imshow(imR);
% title("Right image");
% savefig('imgs/lr.fig')
% 
% figure(10); 
% %imshow(stereoAnaglyph(imL, imR));
% savefig('imgs/stereoAnaglyph.fig')