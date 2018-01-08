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

K=300;

centres=randsample(size(b,2),K);
clusters=b(:,centres);

label=zeros(size(b,2),1);

%%  KMeans
for iter=1:10  % 10 iters for KMeans

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
end
%%
 %% SVM
tic
u=unique(train_gs');
numClasses=length(u);
result = zeros(length(testData(:,1)),1);

SVMModels = cell(numClasses,1);

for k=1:numClasses
    G1vAll=(train_gs'==u(k));
    SVMModels{k} =fitcsvm(trainData,G1vAll);
end
toc

tic
labels=zeros(800,2);
labels(:,1)=-2; % As One Vs Rest is highly imbalanced, for one class, class 
      %scores is always -ve. That is each data point is always being assigned to rest class. 

for k=1:800
    for j=1:numClasses
        [~,score]=predict(SVMModels{j},testData(k,:));
        %score(:,2)
        if(score(:,2)>labels(k,1))
             labels(k,1)=score(:,2);
             labels(k,2)=j;
        end
    end
end
toc
test_gs2=test_gs';

diff=test_gs2-labels(:,2);
accuracy=size(find(diff==0),1)/800;

fprintf("Accuracy is %f\n",accuracy);
C = confusionmat(test_gs2,labels(:,2));
imagesc(C);
colorbar
