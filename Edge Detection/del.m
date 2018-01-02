function [mag_max, theta_max] = gradientMagnitude(im,sigma)

% im = im2double(imread('G:\CV\hw1\prob_edge\data\images\3096.jpg'));
% sigma=2;
im=im2double(im);
[h, w, c] = size(im);

mag = zeros(h,w,c);
theta = zeros(h,w,c);

%creating the gaussian filter
gauss_fil = fspecial('gaussian',6*sigma+1,sigma);

v = fspecial('sobel');
%creating our gradient filters
grad_y = imfilter(gauss_fil,v);
v_trans = v';
grad_x = imfilter(gauss_fil,v_trans);

% grad_x = imfilter(gauss_fil,[1 0 -1]);
% grad_y = grad_x';

for i=1:3
    %apply the gaussian to the image
    %img_blur = imfilter(im(:,:,i),gfil);

    %compute gradients along x and y
    im_grad_x = imfilter(im(:,:,i),grad_x);
    im_grad_y = imfilter(im(:,:,i),grad_y);

    %compute the magnitude and theta along the channels (R,G or ?
    im_grad_mag = sqrt(im_grad_x.*im_grad_x + im_grad_y.*im_grad_y);
    im_grad_theta = atan2(-im_grad_y,im_grad_x);

    mag(:,:,i) = im_grad_mag;
    theta(:,:,i) = im_grad_theta;
end

im_mag = sqrt(mag(:,:,1).*mag(:,:,1) + mag(:,:,2).*mag(:,:,2) + mag(:,:,3).*mag(:,:,3));

%compute orientation from channel with largest gradient.
[mag_max, idx] = max(mag,[],3);

theta_max = zeros(h,w);

%storing orientation of channel with highest gradient magnitude.
for i=1:h
    for j=1:w
        theta_max(i,j) = theta(i,j,idx(i,j));
    end
end