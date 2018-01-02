im=cell(2,1);

%% Set-Up
im{1}=im2double(imread('./images/hotel.seq0.png'));
im{2}=im2double(imread('./images/hotel.seq10.png'));

d=2; %Sampling distance = Smaller for Image Flow with higher resolution

i=1:d:size(im{1},1);
j=1:d:size(im{1},2);
i=i';
j=j';

x=zeros(size(i,1)*size(j,1),1);
y=zeros(size(i,1)*size(j,1),1);

%% Points that will be  tracked
for a=1:size(i,1) %1 to 96
    for b=1:size(j,1) % 1 to 103
        x((a-1)*size(j,1)+b,1)=1+(b-1)*d;
        y((a-1)*size(j,1)+b,1)=1+(a-1)*d;
    end
end

%% Coarse to Fine Tracking
ws = 15;                                     % Tracking ws x ws patches
[track_x, track_y] = ...                     % Keypoint tracking
 trackPoints_coarseFine(x, y, im, ws);

%% The x and y displacements
u=track_x(:,2)-track_x(:,1);
v=track_y(:,2)-track_y(:,1);

%% Reshaping to get the Flow Field
flow=zeros(size(j,1),size(i,1),2);
flow(:,:,1)=reshape(u,(size(j,1)),size(i,1));
flow(:,:,2)=reshape(v,(size(j,1)),size(i,1));

flow2=zeros(size(i,1),size(j,1),2);
flow2(:,:,1)=flow(:,:,1)';
flow2(:,:,2)=flow(:,:,2)';

%% Plotting the optical field
img=flowToColor(flow2);
imshow(img)