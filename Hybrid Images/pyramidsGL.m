function [G, L] = pyramidsGL(im, N, filter)
% Creates Gaussian (G) and Laplacian (L) pyramids of level N from image im.
% G and L are cell where G{i}, L{i} stores the i-th level of Gaussian and Laplacian pyramid, respectively.

%% Set-Up

G=cell(1,N);
L=cell(1,N);
rows = size(im,1);
cols = size(im,2);
image_initial=im;

%% Constructing Pyramids with a Reduction Factor of 2
G{1}=image_initial;

for i=2:1:(N)

        image_filtered = imfilter(image_initial,filter,'replicate');
        
        image_initial_size=size(image_initial);
        image_reduced_size(1)=floor(image_initial_size(1)/2);  % Reduction Factor is 2
        image_reduced_size(2)=floor(image_initial_size(2)/2);
        
        image_downsampled = zeros(image_reduced_size(1),image_reduced_size(2));
    
             for j=1:1:image_reduced_size(1)
                for k=1:1:image_reduced_size(2)
                   image_downsampled(j,k)=image_filtered(j*2,k*2);
                end
            end
          
         % image_downsampled = imresize(image_filtered,0.5,'nearest');
          G{i}=image_downsampled;
          image_upsampled = imresize(G{i},2,'nearest');
          %image_upsampled = imresize(G{i},size(G{i-1}),'nearest');
    
          L{i-1}=G{i-1}-imfilter(image_upsampled,filter,'replicate');         
          image_initial=image_downsampled;
        
end
L{5}=G{5};
end



