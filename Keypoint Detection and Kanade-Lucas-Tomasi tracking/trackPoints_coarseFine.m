function [track_x, track_y] = trackPoints_coarseFine(pt_x, pt_y, im2, ws)
% Tracking initial points (pt_x, pt_y) across the image sequence
% track_x: [Number of keypoints] x [2]
% track_y: [Number of keypoints] x [2]

%% Set-Up
nim = numel(im2);
G_2=cell(nim,3);

cutoff_frequency=5;  % Can be tuned.
filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);

%% Constructing Pyramids with a Reduction Factor of 2

for z=1:nim
G_2{z,1}=im2{z};
image_initial_2=im2{z};
for i=2:1:(3)

        image_filtered = imfilter(image_initial_2,filter,'replicate');
        
        image_initial_size=size(image_initial_2);
        image_reduced_size(1)=floor(image_initial_size(1)/2);  % Reduction Factor is 2
        image_reduced_size(2)=floor(image_initial_size(2)/2);
        
        image_downsampled = zeros(image_reduced_size(1),image_reduced_size(2));
    
             for j=1:1:image_reduced_size(1)
                for k=1:1:image_reduced_size(2)
                   image_downsampled(j,k)=image_filtered(j*2,k*2);
                end
            end
          
         % image_downsampled = imresize(image_filtered,0.5,'nearest');
          G_2{z,i}=image_downsampled;  
          image_initial_2=image_downsampled;
        
end
end

%% Initialization
N = numel(pt_x);

track_x = zeros(N, nim); %Act
track_y = zeros(N, nim); %Act
track_x(:, 1) = pt_x(:,1)/4; %Act
track_y(:, 1) = pt_y(:,1)/4; %act

%% Tracking
for i=3:-1:1
    for j=1:nim-1
        [trackL_x,trackL_y]=getNextPoints(track_x(:,j),track_y(:,j),G_2{j,i},G_2{j+1,i},ws,N);
        track_x(:,j+1)=trackL_x;
        track_y(:,j+1)=trackL_y;
    end
    if i~=1
        track_x=2*track_x;
        track_y=2*track_y;
    end
end

end