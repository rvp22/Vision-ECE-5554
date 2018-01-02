function [mag, theta] = gradientMagnitude(im, sigma)

im=im2double(im);
filter = fspecial('Gaussian', sigma*6+1, sigma);

h = fspecial('sobel');

grad_x=imfilter(filter, h');%, 'conv', 'same');
grad_y=imfilter(filter, h);%, 'conv', 'same');

mag_3 = zeros(size(im,1),size(im,2),3);
theta_3 = zeros(size(im,1),size(im,2),3);

for i=1:3
    
    %Computing gradients
    im_grad_X = imfilter(im(:,:,i),grad_x);
    im_grad_Y = imfilter(im(:,:,i),grad_y);

    % Magnitude and theta for each of the channels
    im_grad_mag = sqrt(im_grad_X.^2 + im_grad_Y.^2);
    im_grad_theta = atan2(-im_grad_Y,im_grad_X); %in radians

    %Storing the values for finding theta giving max magnitude response
    mag_3(:,:,i) = im_grad_mag;
    theta_3(:,:,i) = im_grad_theta;
end

mag = sqrt(mag_3(:,:,1).^2 + mag_3(:,:,2).^2 + mag_3(:,:,3).^2);

[~, maxi] = max(mag_3,[],3);

theta=zeros(size(im,1),size(im,2));

for i=1:3
      theta=theta+theta_3(:,:,i).*(maxi==i);
end

end