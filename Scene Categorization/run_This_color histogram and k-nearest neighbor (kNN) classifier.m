close all;

%% SetUp
folder = './train/';
im = readImages(folder, 1:1888);
hist_train=cell(1888,3);
k=5; % For KNN
load gs.mat;

%% Compute 3 Channel histogram with 25 bins for each image
for i=1:1888
   
    im_r=im{i}(:,:,1);
    im_r1=reshape(im_r,[],1);
    hist_train{i,1}=hist(im_r1,25);

    im_g=im{i}(:,:,2);
    im_g1=reshape(im_g,[],1);
    hist_train{i,2}=hist(im_g1,25);

    im_b=im{i}(:,:,3);
    im_b1=reshape(im_b,[],1);
    hist_train{i,3}=hist(im_b1,25);
    
end


%% Compute histogram of each test image and find k nearest neighbors
folder = './test/';
im_test = readImages(folder, 1:800);
labels=zeros(800,1);

for i=1:800

distance=zeros(1888,1);    
    
    im_tr=im_test{i}(:,:,1);
    im_tr1=reshape(im_tr,[],1);
    hist_test_r=hist(im_tr1,25);

    im_tg=im_test{i}(:,:,2);
    im_tg1=reshape(im_tg,[],1);
    hist_test_g=hist(im_tg1,25);

    im_tb=im_test{i}(:,:,3);
    im_tb1=reshape(im_tb,[],1);
    hist_test_b=hist(im_tb1,25);

        for j=1:1888
            distance(j)=sum(((hist_train{j,1}-hist_test_r).^2)+((hist_train{j,2}-hist_test_g).^2)+((hist_train{j,3}-hist_test_b).^2));
        end
        
        [~,ind]=sort(distance);
        ind=ind(1:k);
        labels_k=train_gs(ind);
        
labels(i)=mode(labels_k);
end

test_gs2=test_gs';

diff=test_gs2-labels;
accuracy=size(find(diff==0),1)/800

%fprintf("Accuracy is %f\n",accuracy);
C = confusionmat(test_gs2,labels);
imagesc(C);
colorbar
%plotconfusion(test_gs2,labels);

