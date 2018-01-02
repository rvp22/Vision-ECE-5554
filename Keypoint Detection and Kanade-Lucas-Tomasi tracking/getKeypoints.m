function [keyXs, keyYs] = getKeypoints(im, tau)
% Detecting keypoints using Harris corner criterion  

%% SetUp
% im: input image
%im=im2double(imread('./hotel.seq0.png'));
% tau: threshold
window_size=5;
alpha=0.04;
% tau= 0.045; % For debugging function
% keyXs, keyYs: detected keypoints, with dimension [Number of keypoints] x [2]

%% Computing gradients for each pixel in the image

[Ix, Iy] = gradient(im);

Ix_2=Ix.*Ix;
Iy_2=Iy.*Iy;
Ix_y=Ix.*Iy;

smooth = fspecial('gaussian',window_size,2);

Ix_2_weighted=conv2(Ix_2,smooth,'same');
Iy_2_weighted=conv2(Iy_2,smooth,'same');
Ix_y_weighted=conv2(Ix_y,smooth,'same');

harris_score = ((Ix_2_weighted.*Iy_2_weighted)-(Ix_y_weighted.^2))-(alpha.*((Ix_2_weighted+Iy_2_weighted).^2));

harris_score=harris_score-min(abs(harris_score(:)));
harris_score = harris_score/(max(harris_score(:)));

n_m_suppression = ordfilt2(harris_score,25,ones(5)); 
key_points = (harris_score==n_m_suppression)&(harris_score>tau);       
[keyXs,keyYs] = find(key_points);                 

figure, imagesc(im), axis image, colormap(gray), hold on
plot(keyYs,keyXs,'g.','linewidth',3), title('Corners');

end