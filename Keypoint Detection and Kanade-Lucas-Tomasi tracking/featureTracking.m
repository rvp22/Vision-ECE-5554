%function featureTracking
% Main function for feature tracking
folder = './images';
im = readImages(folder, 0:50);

tau = 0.045;      %0.045                           % Threshold for harris corner detection
[pt_y, pt_x] = getKeypoints(im{1}, tau);    % Prob 1.1: keypoint detection

%k=load('initial_keypoints.mat');
%pt_x=k.Xo;
%pt_y=k.Yo;

ws = 15;                                     % Tracking ws x ws patches
[track_x, track_y] = ...                    % Keypoint tracking
 trackPoints(pt_x, pt_y, im, ws);
  

%% Visualizing the feature tracks on the first and the last frame
figure(2), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r');%Act

figure(3), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r');%Act

figure(4), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x(:,1), track_y(:,1), 'g.','linewidth',3);%Act

%figure(5), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x(:,2), track_y(:,2), 'r.','linewidth',3);%Act

figure(6), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(400, 50, 'r.');%Act

%% Out of  Frame Points
%track_x1=track_x(track_x(:,51)>0&track_y(:,51)>0,:);
%track_y1=track_y(track_x(:,51)>0&track_y(:,51)>0,:);

%max_track_x1=max(track_x1,[],2);
%max_track_y1=max(track_y1,[],2);

%track_x_cut=track_x1(max_track_x1<512 & max_track_y1<480,:);
%track_y_cut=track_y1(max_track_x1<512 & max_track_y1<480,:);

%figure(2), imagesc(im{1}), hold off, axis image, colormap gray
%hold on, plot(track_x_cut', track_y_cut', 'r');%Act

%figure(3), imagesc(im{6}), hold off, axis image, colormap gray
%hold on, plot(track_x_cut', track_y_cut', 'r');%Act





