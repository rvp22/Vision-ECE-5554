function [x2, y2] = getNextPoints(x, y, im1, im2, ws,N)
% Iterative Lucas-Kanade feature tracking
% x,  y : initialized keypoint position in im2
% x2, y2: tracked keypoint positions in im2
% ws: patch window size

%% Compute gradients
[Ix, Iy] = gradient(im1);

%% Initialize x2 and y2
x2=x;
y2=y;

%% Find image patches with interpolation ; Solve the contrained equation
%% ICP Algorithm
k=floor(ws/2);
[x_p, y_p] = meshgrid(-k:k,-k:k);
img_size=size(im1);

for i = 1:5 %5 iterations
   
    for j=1:N % for each point tracked
        if(x2(j)>7 && x2(j)<(img_size(2)-7) && y2(j)>7 && y2(j)<(img_size(1)-7))%Act

        x_j=x2(j)+x_p;   % Defining the window around the tracked jth point
        y_j=y2(j)+y_p;
        
        Ix_p=interp2(Ix,x_j,y_j,'bilinear'); % Ix and Iy for the patch
        Iy_p=interp2(Iy,x_j,y_j,'bilinear');

        I1_p=interp2(im1,x_j,y_j,'bilinear');    %I1 and I2 patch
        I2_p=interp2(im2,x_j,y_j,'bilinear');
    
        Ix_2_p=Ix_p.^2;  % Define Ix^2, Iy^2 and Ix.Iy
        Iy_2_p=Iy_p.^2;
        Ix_y_p=Ix_p.*Iy_p;
    
        It=I2_p-I1_p; 
        
        A= [sum(sum(Ix_2_p)),sum(sum(Ix_y_p));sum(sum(Ix_y_p)),sum(sum(Iy_2_p))];
        b=-1*[sum(sum(Ix_p.*It));sum(sum(Iy_p.*It))];
        d=A\b;
        
        x2(j)=x2(j)+d(1);
        y2(j)=y2(j)+d(2);
        end
        
    end
    
end
end