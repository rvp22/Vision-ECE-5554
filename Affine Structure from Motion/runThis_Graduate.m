%function F = HW3_SfM
close all;

folder = './images/';
im = readImages(folder, 0:50);

load './tracks.mat';


valid = ~any(isnan(track_x), 2) & ~any(isnan(track_y), 2); 
track_x_new=track_x;
track_y_new=track_y;


[R, S] = affineSFMV2(track_x(valid, :), track_y(valid, :)); %R=A


A=R;
notvalid = not(valid);

[i,~]=find(notvalid==1);

A1=A(1:end/2,:);
A2=A(1+end/2:end,:);

for j=1:size(i)
U=[];
a=[];
    for k=1:size(track_x,2)
        if(isnan(track_x(i(j), k)) || isnan(track_y(i(j), k)))
            break;
        end
        U=[U;track_x(i(j), k); track_y(i(j), k)];
        a=[a;A1(k, :);A2(k, :)];
    end
    d3point = a\U;
    points=A*d3point;
    
    track_x_new(i(j),:)=points(1:end/2);
    track_x_new_2(j,:)=points(1:end/2);
    track_y_new(i(j),:)=points(end/2+1:end);
    track_y_new_2(j,:)=points(end/2+1:end);
end


figure(1), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x_new', track_y_new', 'r')
figure(2), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x_new', track_y_new', 'r')

figure(3), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x_new_2', track_y_new_2', 'g')
figure(4), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x_new_2', track_y_new_2', 'g')

