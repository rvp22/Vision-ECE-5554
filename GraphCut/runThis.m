% Add path
addpath(genpath('GCmex1.5'));

% Load one of the images
%im = im2double( imread('hokie.jpg') );
im = im2double( imread('cat.jpg') );
%im = im2double( imread('bus.jpg') );
%im = im2double( imread('flowers1.jpg') );
%im = im2double( imread('ph.jpg') );
%im = im2double( imread('sign.jpg') );

org_im = im;

H = size(im, 1); W = size(im, 2); K=3;

%% Load one of the masks
% For cat
load cat_poly  

% For flowers1 
%poly = [276,406; 151,385;77,296;73,203;279,37;445,76;528,182;514,308;475,330;468,365;287,411;276,406];

% For flowers2
%poly= [136,242;369,45;734,156;830,429; 660,615;91,536;136,242];

% For flowers3
%poly=[107,30;781,20;792,596;101,625;107,30];
%poly=[247,31;80,367;449,631;769,481;781,337;632,111;542,126;445,14;247,31];

% For flowers3
%poly=[218,30;10,195;13,323;212,413;400,370;461,203;374,62;218,30];

%For bus
%poly=[171,143;147,282; 270,295; 626,262; 618,162;245,126; 171,143];
%poly=[157,50;134,187;259,195;609,167;603,65;238,27;157,50];


% For hokie
%poly = [468,4;488,123;514,141;407,183;346,88; 295,86;283,156;348,343;481,294;470,323;258,420;205,404;175,346;114,340;76,516;205,513;245,540;858,420;960,474;1010,412;971,269;1010,233;1009,132;918,69;841,95;791,110;792,139;625,48;468,4];
%poly = [468,4;488,123;514,141;407,183;346,88; 295,86;283,156;342,322; 375,319;383,331;407,311;445,284; 489,279; 489,315; 397,378;   258,420;  205,404;175,346;114,340;76,516;205,513;245,540;858,420;960,474;1010,412;971,269;1010,233;1009,132;918,69;841,95;791,110;792,139;625,48;468,4];

%Phone
%poly=[113,98;35,318;38,340;142,379;166,371;249,135;239,121;139,82;113,98];


%For signboard
%poly=[150,69;144,189;335,192;333,71;150,69];

inbox = poly2mask(poly(:,1), poly(:,2), size(im, 1), size(im,2));
%figure(1)
%imshow(im)
%figure(2)
%imshow(inbox)
im_r=org_im(:,:,1);
im_g=org_im(:,:,2);
im_b=org_im(:,:,3);

im_r_1d=reshape(im_r,[],1);
im_g_1d=reshape(im_g,[],1);
im_b_1d=reshape(im_b,[],1);

% 1) Fit Gaussian mixture model for foreground regions

im_rf=im_r(find(inbox==1));
im_gf=im_g(find(inbox==1));
im_bf=im_b(find(inbox==1));

im_f=[im_rf,im_gf,im_bf];

GMModel_f = fitgmdist(im_f,5);

% 2) Fit Gaussian mixture model for background regions
im_rb=im_r(find(inbox==0));
im_gb=im_g(find(inbox==0));
im_bb=im_b(find(inbox==0));

im_b=[im_rb,im_gb,im_bb];

GMModel_b = fitgmdist(im_b,5);

% 3) Prepare the data cost
% - data [Height x Width x 2] 
% - data(:,:,1) the cost of assigning pixels to label 1
% - data(:,:,2) the cost of assigning pixels to label 2

data=zeros(H,W,2);

data1=-1*log(pdf(GMModel_f,[im_r_1d,im_g_1d,im_b_1d]));
data2=-1*log(pdf(GMModel_b,[im_r_1d,im_g_1d,im_b_1d]));

data(:,:,1)=reshape(data1,H,W);
data(:,:,2)=reshape(data2,H,W);

% 4) Prepare smoothness cost
% - smoothcost [2 x 2]
% - smoothcost(1, 2) = smoothcost(2,1) => the cost if neighboring pixels do not have the same label
smoothcost=[0,10;10,0];

% 5) Prepare contrast sensitive cost
% - vC: [Height x Width]: vC = 2-exp(-gy/(2*sigma)); 
% - hC: [Height x Width]: hC  = 2-exp(-gx/(2*sigma));

[Gx_r, Gy_r] = imgradientxy(im(:,:,1));
[Gx_g, Gy_g] = imgradientxy(im(:,:,2));
[Gx_b, Gy_b] = imgradientxy(im(:,:,3));

gx=sqrt(Gx_r.^2+Gx_g.^2+Gx_b.^2);
gy=sqrt(Gy_r.^2+Gy_g.^2+Gy_b.^2);

sigma=1;
vC = 2-exp(-gy/(2*sigma)); 
hC  = 2-exp(-gx/(2*sigma));

% 6) Solve the labeling using graph cut
% - Check the function GraphCut
gch = GraphCut('open', data, smoothcost, vC, hC);
[gch labels] = GraphCut('expand', gch);

% 7) Visualize the results

% Image Foreground : 
figure(1)
image_f=org_im.*double(not(labels));
imshow(image_f)

% Image Background : 
figure(2)
image_b=org_im.*double((labels));
imshow(image_b)

blue_background=zeros(H,W,3);
blue_background(:,:,3)=1;

imshow(image_f+blue_background.*double((labels)));

% For the bounding Box
imshow(im)
hold on
plot(poly(:,1),poly(:,2),'r')


% Pasting segmented image on a different image

b=im2double(imread('table.jpg'));

r=1;
f=imresize(image_f,r);

final_image=imresize(b,0.75);
final_image(450:450+size(f,1)-1,400:400+size(f,2)-1,1:end)=final_image(450:450+size(f,1)-1,400:400+size(f,2)-1,1:end).*double((labels))+f;
imshow(final_image)