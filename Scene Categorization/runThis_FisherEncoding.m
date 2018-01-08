clear all;

%% SetUp
folder = './train/';
im = readImages(folder, 1:1888);
hist_train=cell(1888,3);

load gs.mat;
load sift_desc.mat;
run('vlfeat-0.9.20/toolbox/vl_setup');

%% 
from_each_image=20;

for i=1:1888
      if i==1 
        b=datasample(train_D{1},from_each_image,2);
      else
        b=horzcat(b,datasample(train_D{i},from_each_image,2));
      end
end

K=50;

trainDataForClustering = [];
for i = 1:length(train_gs)
   idx = randsample(size(train_D{i}, 2), 10);
   siftSubset = train_D{i};
   trainDataForClustering = [trainDataForClustering, siftSubset(:, idx)];
end
trainDataForClustering = double(trainDataForClustering);
[clusterMeans, clusterCovariances, clusterPriors] = vl_gmm(trainDataForClustering, K);



%% Computing word for each Train Image
for i = 1:length(train_gs)
    encoding = vl_fisher(double(train_D{i}), clusterMeans, clusterCovariances, clusterPriors);
    trainData(i, :) = encoding;
end

%% Computing word for each Test Image
for i = 1:length(test_gs)
    encoding = vl_fisher(double(test_D{i}), clusterMeans, clusterCovariances, clusterPriors);
    testData(i, :) = encoding;
end

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

