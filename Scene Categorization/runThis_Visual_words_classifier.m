clear all;

%% SetUp
folder = './train/';
im = readImages(folder, 1:1888);
hist_train=cell(1888,3);

load gs.mat;
load sift_desc.mat;

%% 
from_each_image=20;

for i=1:1888
      if i==1 
        b=datasample(train_D{1},from_each_image,2);
      else
        b=horzcat(b,datasample(train_D{i},from_each_image,2));
      end
end

K=200;

centres=randsample(size(b,2),K);
clusters=b(:,centres);

label=zeros(size(b,2),1);

%%  KMeans
for iter=1:20  % 20 iters for KMeans

for j=1:size(b,2) % 1 to 30,000 Assigning cluster to each in y. Total K clusters
    min_dist=dist_(b(:,j),clusters(:,1));
    label(j)=1;
    for k=2:K
        d=dist_(b(:,j),clusters(:,k));
        if d<min_dist
            min_dist=d;
            label(j)=k;
        end
    end         
end   % labelling done based on cluster centers

for l=1:K  % Update cluster centers
    o=find(label==l);
    clusters(:,l)=mean(b(:,o),2);
end

end
%% Computing word for each Train Image

for i=1:1888
distance=pdist2(clusters',double(train_D{i}'),'euclidean');
[~,pred]=sort(distance,'ascend');
pred=pred(1,:);
trainData(i,:)=histc(pred,1:K);
trainData(i,:)=trainData(i,:)/sum(trainData(i,:));
end

%% On Test
k=10; % For KNN

for i=1:800
distance=pdist2(clusters',double(test_D{i}'),'euclidean');
[~,pred]=sort(distance,'ascend');
pred=pred(1,:);
testData(i,:)=histc(pred,1:K);
testData(i,:)=testData(i,:)/sum(testData(i,:));

    d=zeros(1888,1); 
    for j=1:1888
            d(j)=sum((testData(i,:)-trainData(j,:)).^2);
    end
        
    [~,ind]=sort(d);
    ind=ind(1:k);
    labels_k=train_gs(ind);
        
labels(i)=mode(labels_k);
end
test_gs2=test_gs;

diff=test_gs2-labels;
accuracy=size(find(diff==0),2)/800;

fprintf("Accuracy is %f\n",accuracy);
C = confusionmat(test_gs2,labels);
imagesc(C);
colorbar