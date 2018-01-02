% Load image and convert to floating point number format
% The image should be at least 640x480 pixels

%% SetUp - Import the Image and Define the Gaussian Filter being used
im = rgb2gray(imread('./images/tiger.jpg'));
im = im2double(im);
N = 5;
cutoff_frequency=5;  % Can be tuned.
filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);
%%

%% 2.a. Implement and display Gaussian and Laplacian Pyramids
[G, L] = pyramidsGL(im, N,filter);
displayPyramids(G, L, N);
%%

%% 2.b. Display the FFT amplitudes of the Gaussian/Laplacian pyramids.
% and call it in this function. You will find tight_subplot useful.
displayFFT(G,L,N);
%%

%% Graduate Points:
%%

%% 2.c Reconstruct Image using Laplacian Pyramids. 
% Filter used in Image Reconstruction will be same as used in Constructing the Pyramids.
reconstructed_image=reconstruct_L(L,N,filter); 
imwrite(reconstructed_image,'./images/reconstructed_image.png');
% Saving individual G and L images to show the reconstruction process
for i=1:N
    imwrite(G{i},strcat('./images/pyramids/G',num2str(i),'.png'));
    imwrite(L{i},strcat('./images/pyramids/L',num2str(i),'.png'));
end

% Reconstruction Error
reconstruction_error=sqrt(sum(sum((reconstructed_image-im).^2)))/numel(im);
%%

%% 2.d Multiplying L_5 by 2 and then Reconstructing.
L_new=L;
L_new{1}=L_new{1}.*2;
reconstructed_image_multiplied=reconstruct_L(L_new,N,filter);
imwrite(reconstructed_image_multiplied,'./images/reconstructed_image_multiplied.png');

%%Applying a simple 3x3 sharpening filter
sharp=[0,-1/4,0;-1/4,2,-1/4;0,-1/4,0];
sharpened = imfilter(im,sharp,'replicate');
%imwrite(sharpened,'./images/sharpened.png');
%%
