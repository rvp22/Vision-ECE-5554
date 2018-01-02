close all;

%% Setup
% Reading the images and converting to floating point format
image1 = im2single(imread('./data/motorcycle.bmp'));
image2 = im2single(imread('./data/bicycle.bmp'));
%image2 = im2single(imread('./data/motorcycle.bmp'));
%image1 = im2single(imread('./data/bicycle.bmp'));


%% Filtering and Hybrid Image construction
cutoff_frequency1 = 5; % Can be tuned to achieve best results.
filter1 = fspecial('Gaussian', cutoff_frequency1*4+1, cutoff_frequency1);

cutoff_frequency2 = 6; % Can be tuned to achieve best results.
filter2 = fspecial('Gaussian', cutoff_frequency2*4+1, cutoff_frequency2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it.
low_frequencies = imfilter(image1,filter1,'replicate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ecide the sigma for gaussian filter on images for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removing the low frequencies from image2 by subtracting a blurred version
% of image2 from the original version
high_frequencies=image2-imfilter(image2,filter2,'replicate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
hybrid_image=(low_frequencies+high_frequencies)/2;
imshow(hybrid_image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Visualize and save outputs
figure(1); imshow(low_frequencies)
figure(2); imshow(high_frequencies + 0.5);
vis = vis_hybrid_image(hybrid_image);
figure(3); imshow(vis);
imwrite(low_frequencies, 'low_frequencies.jpg', 'quality', 95);
imwrite(high_frequencies + 0.5, 'high_frequencies.jpg', 'quality', 95);
imwrite(hybrid_image, 'hybrid_image.jpg', 'quality', 95);
imwrite(vis, 'hybrid_image_scales.jpg', 'quality', 95);

%% Log Magnitude of the Fourier transforms 
%We have to show the log magnitude of the Fourier Transforms of the
%original images, filtered images and the Hybrid image.

figure(4);imagesc(log(abs(fftshift(fft2(rgb2gray(image1),1024,1024))))),title('Image 1'); colormap('jet'); colorbar
figure(5);imagesc(log(abs(fftshift(fft2(rgb2gray(low_frequencies),1024,1024)))));title('Image 1 after Low Pass Filter ');colormap('jet'); colorbar
figure(6);imagesc(log(abs(fftshift(fft2(rgb2gray(image2),1024,1024)))));title('Image 2');colormap('jet'); colorbar
figure(7);imagesc(log(abs(fftshift(fft2(rgb2gray(high_frequencies),1024,1024)))));title('Image 2 after High Pass Filter');colormap('jet'); colorbar
figure(8);imagesc(log(abs(fftshift(fft2(rgb2gray(hybrid_image),1024,1024)))));title('Hybrid Image');colormap('jet'); colorbar
%%

%% Graduate Points:

%% a. More Hybrid Images.
% Hybrid Image1
image3 = im2single(imread('./solutions/additional_images/image_sim2_1.jpg'));
image4 = im2single(imread('./solutions/additional_images/image_sim2_2.jpg'));

image_3_low_frequencies = imfilter(image3,filter1,'replicate');
image_4_high_frequencies = image4-imfilter(image4,filter2,'replicate');

hybrid_image_2=(image_3_low_frequencies+image_4_high_frequencies)/2;
figure(9); imshow(hybrid_image_2);
% Hybrid Image2
image5 = im2single(imread('./solutions/additional_images/image_sim3_1.jpg'));
image6 = im2single(imread('./solutions/additional_images/image_sim3_2.jpg'));

image_5_low_frequencies = imfilter(image5,filter1,'replicate');
image_6_high_frequencies = image6-imfilter(image6,filter2,'replicate');

hybrid_image_3=(image_5_low_frequencies+image_6_high_frequencies)/2;
figure(10); imshow(hybrid_image_3);
%%

%% b. Using Color In Hybrid Images

%We will use the Example Used Initially, ie that of bicycle and motorcycle.

%Case 1: Using Low Pass Filtered Image(Motorcycle) as Grayscale and High Passed 
%Image(Bicycle) as Color
image1 = im2single(imread('./data/motorcycle.bmp'));
image2 = im2single(imread('./data/bicycle.bmp'));

image1_grayscale=rgb2gray(image1);
low_frequencies = imfilter(image1_grayscale,filter1,'replicate');
high_frequencies=image2-imfilter(image2,filter2,'replicate');
hybrid_image_4=(low_frequencies+high_frequencies)/2;

figure(11); imshow(hybrid_image_4);
%Case 2: Using High Pass Filtered Image(Bicycle) as Grayscale and Low Passed 
%Image(Motorcycle) as Color
image1 = im2single(imread('./data/motorcycle.bmp'));
image2 = im2single(imread('./data/bicycle.bmp'));

image2_grayscale=rgb2gray(image2);
low_frequencies = imfilter(image1,filter1,'replicate');
high_frequencies=image2_grayscale-imfilter(image2_grayscale,filter2,'replicate');
hybrid_image_5=(low_frequencies+high_frequencies)/2;

figure(12); imshow(hybrid_image_5);
%%

%Case 2: Using both Grayscale
image1 = im2single(imread('./data/motorcycle.bmp'));
image2 = im2single(imread('./data/bicycle.bmp'));

image2_grayscale=rgb2gray(image2);
image1_grayscale=rgb2gray(image1);

low_frequencies = imfilter(image1_grayscale,filter1,'replicate');
high_frequencies=image2_grayscale-imfilter(image2_grayscale,filter2,'replicate');

hybrid_image_6=(low_frequencies+high_frequencies)/2;
figure(13); imshow(hybrid_image_6);
%%

%% c. Illustrating the Hybrid Process by Laplacian and Gaussian Pyramids.
N=4;
cutoff_frequency=5;  % Can be tuned.
filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);
[G,L]=pyramidsGL(rgb2gray(hybrid_image), N, filter);
displayPyramids(G,L,N);