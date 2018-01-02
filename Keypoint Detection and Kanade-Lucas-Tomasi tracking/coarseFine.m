folder = './images';
im = readImages(folder, 0:50);

im2=cell(6,1);

im2{1}=im{1};
im2{2}=im{11};
im2{3}=im{21};
im2{4}=im{31};
im2{5}=im{41};
im2{6}=im{51};

tau = 0.2;                                 % Threshold for harris corner detection
[pt_y, pt_x] = getKeypoints(im2{1}, tau); 

ws = 15;                                     % Tracking ws x ws patches
[track_x, track_y] = ...                    % Keypoint tracking
 trackPoints_coarseFineV2(pt_x, pt_y, im2, ws);

% Visualizing the feature tracks on the first and the last frame
track_x1=track_x(track_x(:,6)>0&track_y(:,6)>0,:);
track_y1=track_y(track_x(:,6)>0&track_y(:,6)>0,:);

max_track_x1=max(track_x1,[],2);
max_track_y1=max(track_y1,[],2);

track_x_cut=track_x1(max_track_x1<512 & max_track_y1<480,:);
track_y_cut=track_y1(max_track_x1<512 & max_track_y1<480,:);

figure(2), imagesc(im2{1}), hold off, axis image, colormap gray
hold on, plot(track_x_cut', track_y_cut', 'r');%Act

figure(3), imagesc(im2{6}), hold off, axis image, colormap gray
hold on, plot(track_x_cut', track_y_cut', 'r');%Act


track_x_cut1=track_x_cut(:,1);
track_y_cut1=track_y_cut(:,1);
track_x_cut2=track_x_cut(:,2);
track_y_cut2=track_y_cut(:,2);
track_x_cut3=track_x_cut(:,3);
track_y_cut3=track_y_cut(:,3);
track_x_cut4=track_x_cut(:,4);
track_y_cut4=track_y_cut(:,4);
track_x_cut5=track_x_cut(:,5);
track_y_cut5=track_y_cut(:,5);
track_x_cut6=track_x_cut(:,6);
track_y_cut6=track_y_cut(:,6);

figure(4), imagesc(im2{1}), axis image, colormap(gray), hold on
plot(track_x_cut1',track_y_cut1','g.'), title('Keypoints');

%figure(5), imagesc(im2{2}), axis image, colormap(gray), hold on
plot(track_x_cut2',track_y_cut2','r.'), title('Keypoints');

%figure(6), imagesc(im2{3}), axis image, colormap(gray), hold on
plot(track_x_cut3',track_y_cut3','y.'), title('Keypoints');

%figure(7), imagesc(im2{4}), axis image, colormap(gray), hold on
plot(track_x_cut4',track_y_cut4','b.'), title('Keypoints');

%figure(8), imagesc(im2{5}), axis image, colormap(gray), hold on
plot(track_x_cut5',track_y_cut5','w.'), title('Keypoints');

%figure(9), imagesc(im2{6}), axis image, colormap(gray), hold on
plot(track_x_cut6',track_y_cut6','m.'), title('Keypoints');