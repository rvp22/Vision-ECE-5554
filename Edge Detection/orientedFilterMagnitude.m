function [mag,theta] = orientedFilterMagnitude(im)

%% SetUp
im=im2double(im);
K=75;
a=5;
b=25;
[X, Y] = meshgrid(-K:K, -K:K);
sigma=4;
%%

%% Creating the Gaussian Filter
G = exp((-a*X.^2 - b*Y.^2)/(sigma.^2));        
G = G/sum(G(:));
%%

o=16;%No of orientations used
mag_oriented=zeros(size(im,1),size(im,2),o);
theta_oriented=zeros(size(im,1),size(im,2),o);

h = fspecial('sobel');

grad_x = imfilter(G, h');%, 'conv', 'same');
grad_y = imfilter(G, h);%, 'conv', 'same');

%theta_3 = zeros(size(im,1),size(im,2),3);

for i=1:1:o
    mag_3 = zeros(size(im,1),size(im,2),3);
    %disp(i)
    orientation=(i-1)*(180/o);
    %disp(orientation)
    %G_oriented=imrotate(G,orientation); %Rotating counter-clockwise
    
    %imagesc(G_oriented); colormap('jet'); colorbar
    %saveas(gcf,strcat('./images/oriented_filters',num2str(i),'.png'))
    
   
    %image_smoothed = imfilter(im,G_oriented,'replicate');
    
    orientation_orthonormal=(orientation+90);
    grad_orientation_orthogonal=(grad_x.*cos((orientation_orthonormal)))+(grad_y.*sin((orientation_orthonormal)));

    %A=[0,0,0;-1,0,1;0,0,0];
    %B=[0,1,0;0,0,0;0,-1,0];
        
    for j=1:3
    %Computing gradients
        im_grad_oriented_mag = imfilter(im(:,:,j),grad_orientation_orthogonal);  
        mag_3(:,:,j) = im_grad_oriented_mag;
     end
    
    mag = sqrt(mag_3(:,:,1).^2 + mag_3(:,:,2).^2 + mag_3(:,:,3).^2);
      
    theta_oriented(:,:,i)=orientation; %in degrees
    mag_oriented(:,:,i)=mag;
end

[mag,maxi]=max(mag_oriented,[],3);

%theta=zeros(size(im,1),size(im,2));
%    for j=1:o
%        theta=theta+theta_oriented(:,:,j).*(maxi==j);
%    end
theta=(maxi-1)/o*180;
theta=theta.*pi/180; %nonmax.m requires theta in radians
end


    