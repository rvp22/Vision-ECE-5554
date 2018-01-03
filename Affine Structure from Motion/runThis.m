%function F = HW3_SfM
close all;

folder = './images/';
im = readImages(folder, 0:50);

load './tracks.mat';


figure(1), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r')
figure(2), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r')
%pause;

valid = ~any(isnan(track_x), 2) & ~any(isnan(track_y), 2); 

[R, S] = affineSFM(track_x(valid, :), track_y(valid, :));

plotSfM(R,S); %R=motion(A),S=shape(X)






