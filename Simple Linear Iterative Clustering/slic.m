function [cIndMap, time, imgVis] = slic(img, K, compactness)

%% Implementation of Simple Linear Iterative Clustering (SLIC)
%
% Input:
%   - img: input color image
%   - K:   number of clusters
%   - compactness: the weights for compactness
% Output: 
%   - cIndMap: a map of type uint16 storing the cluster memberships
%     cIndMap(i, j) = k => Pixel (i,j) belongs to k-th cluster
%   - time:    the time required for the computation
%   - imgVis:  the input image overlaid with the segmentation

% Put your SLIC implementation here

%% SetUp
%K=1024;
%img=imread('8068.jpg');
%compactness=10;
%%

tic;
% Input data
imgB   = im2double(img);
%cform  = makecform('srgb2lab');
%imgLab = applycform(imgB, cform);
imgLab=rgb2lab(imgB);
%imgLab=imgB;    % For RGB Space; Use compactness = 0.5
[sy, sx, ~] = size(imgLab);
imgLab_e=zeros(sy,sx,5);
imgLab_e(:,:,1:3)=imgLab;

[imgLab_x,imgLab_y]=meshgrid(1:sx,1:sy);
imgLab_e(:,:,4)=imgLab_x;
imgLab_e(:,:,5)=imgLab_y;

% Initialize cluster centers (equally distribute on the image). Each cluster is represented by 5D feature (L, a, b, x, y)
% Hint: use linspace, meshgrid
N=sy*sx;      % Total pixels in image
s=floor(N/K); % Average size of each superpixel

S=floor(sqrt(s));    % Grid interval
% Regular Grid Interval Not Used

iniX = floor(linspace(1,sx,sqrt(K)+2)); 
iniX=iniX(2:end-1);
iniY = floor(linspace(1,sy,sqrt(K)+2));
iniY=iniY(2:end-1);

C=zeros(K,5);

C(:,4)=repmat(iniX,1,sqrt(K))';
C(:,5)=repelem(iniY,sqrt(K))';
C(:,6)=1:K;

for i=1:K
    C(i,1)=imgLab(C(i,5),C(i,4),1);
    C(i,2)=imgLab(C(i,5),C(i,4),2);
    C(i,3)=imgLab(C(i,5),C(i,4),3);
end

s1=floor(sx/(sqrt(K)+1));
s2=floor(sy/(sqrt(K)+1));

% 2s1 * 2s2 box
% SLIC superpixel segmentation
% In each iteration, we update the cluster assignment and then update the cluster center

numIter  = 10; % Number of iteration for running SLIC

cIndMap=zeros(sy,sx,3);
cIndMap(:,:,2)=reshape(repelem(9999,sx*sy),sy,sx);  % Min distance for any K
cIndMap(:,:,3)=reshape(repelem(9999,sx*sy),sy,sx); % For current K % Not used

for iter = 1: numIter
   % disp(iter);
	% 1) Update the pixel to cluster assignment
    for i=1:K
        cluster_center=zeros(1,1,3);   % Making cluster center in format of lab in image
        cluster_center(1,1,1)=C(i,1);
        cluster_center(1,1,2)=C(i,2);
        cluster_center(1,1,3)=C(i,3);
        
        dlab_temp=imgLab-cluster_center;
        dlab=sqrt(dlab_temp(:,:,1).^2+dlab_temp(:,:,2).^2+dlab_temp(:,:,3).^2);
        
        [imgLab_x,imgLab_y]=meshgrid(1:sx,1:sy); % Finding spatial coordinates of imgLab (imgLab_y,imgLab_x)
        dxy=sqrt(((imgLab_y-C(i,5)).^2)+(imgLab_x-C(i,4)).^2); %(C(K,5),C(K,4))
        
        Ds=dlab+((compactness/S)*dxy);
        
        bool1 = (abs(imgLab_e(:,:,4)-C(i,4))<=S) .* (abs(imgLab_e(:,:,5)-C(i,5))<=S);
         
        % Compare cIndMap(:,:,2) - current min distance and Ds. If Ds less
        % make cIndMap = Ds and cIndMap(:,:,1)=i. DO only if bool is active
        % (ie if within 2S x 2S window)
        
        bool2=cIndMap(:,:,2)-Ds>0;
        bool=bool1.*bool2;
        
        cIndMap(:,:,1)=(i.*bool)+(cIndMap(:,:,1).*not(bool));   % Works for first iter only; for rest iter replace, not .*
        cIndMap(:,:,2)=(Ds.*bool)+(cIndMap(:,:,2).*not(bool));  %  Does not work for first iter also...replces rest by 0, when 9999 should be there 
    end   
     
	% 2) Update the cluster center by computing the mean
    
    for i=1:K
        bool=(cIndMap(:,:,1)==i); % Mask of pixels belonging to cluster i
        count_i=sum(sum(bool));   % No of pixels belonging to cluster i
        
        sum_x=sum(sum(imgLab_x.*bool));  % Sum of x coordinates of all pixels belonging to cluster i
        sum_y=sum(sum(imgLab_y.*bool));  % Sum of y coordinates of all pixels belonging to cluster i
        
        C(i,4)=floor(sum_x/count_i); 
        C(i,5)=floor(sum_y/count_i);
    
        C(i,1)=imgLab(C(i,5),C(i,4),1);
        C(i,2)=imgLab(C(i,5),C(i,4),2);
        C(i,3)=imgLab(C(i,5),C(i,4),3);
    end 
        
        
     
        
end

time = toc;


% Visualize mean color image
cIndMap=cIndMap(:,:,1);
[gx, gy] = gradient(cIndMap);
bMap = (gx.^2 + gy.^2) > 0;
imgVis = img;
imgVis(cat(3, bMap, bMap, bMap)) = 1;

cIndMap = uint16(cIndMap);

imshow(imgVis);
end