%function featureMatching
% Matching SIFT Features

im1 = imread('./stop1.jpg');
im2 = imread('./stop2.jpg');

load('SIFT_features.mat'); % Load pre-computed SIFT features
% Descriptor1, Descriptor2: SIFT features from image 1 and image 2
% Frame1, Frame2: position, scale, rotation of keypoints

% YOUR CODE HERE
%N will be number of keypoints in Image1. Match each keypoint in Image 1 to
%corresponding point in Image 2 and then exclude using thresholding -Ratio
Descriptor2=double(Descriptor2);
Descriptor1=double(Descriptor1);

nearest=ones(size(Descriptor1,2),4);
%nearest=uint64(nearest);
%i=4;
for i=1:size(Descriptor1,2)
    dij_min=sqrt(sum((Descriptor1(:, i) - Descriptor2(:,1)).^2));
    nearest(i,1)=i;
    for j=1:size(Descriptor2,2)
        %disp("%%%")
        %disp(dij_min)
        dij=sqrt(sum((Descriptor1(:, i) - Descriptor2(:,j)).^2));
        if(dij<dij_min)
            nearest(i,3)=nearest(i,2);
            nearest(i,2)=j;
            dij_min=dij;
        end
    end
ratio=sqrt(sum((Descriptor1(:, i) - Descriptor2(:,nearest(i,2))).^2))/sqrt(sum((Descriptor1(:, i) - Descriptor2(:,nearest(i,3))).^2));
nearest(i,4)=ratio;
distance=sqrt(sum((Descriptor1(:, i) - Descriptor2(:,nearest(i,2))).^2));%-sqrt(sum((Descriptor1(:, i) - Descriptor2(:,nearest(i,2))).^2));
nearest(i,5)=distance;
end
%% Using Ratio Threshold
ratio_threshold=0.65;
nearest1_1=nearest(nearest(:,4)<ratio_threshold,:);
nearest2_1=nearest1_1(:,1:2);
matches_1=nearest2_1';
% matches: a 2 x N array of indices that indicates which keypoints from image
% 1 match which points in image 2

% Display the matched keypoints
figure(1), hold off, clf
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches_1);

%% Using Distance Threshold
dist_threshold=150;
nearest1_2=nearest(nearest(:,5)<dist_threshold,:);
nearest2_2=nearest1_2(:,1:2);
matches_2=nearest2_2';
% matches: a 2 x N array of indices that indicates which keypoints from image
% 1 match which points in image 2

% Display the matched keypoints
figure(2), hold off, clf
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches_2);