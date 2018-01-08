clear all;

%
folder = './train/';
im = readImages(folder, 1:1888);
hist_train=cell(1888,3);

load gs.mat;
load sift_desc.mat;

%
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

%K Means

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

% 

L=2;
M=K;


%% Compute Word for Train
sift_pos_l2=cell(16,1);

word_l2=cell(16,1);
word_l1=cell(4,1);


for i=1:1888
    
    %%L=2
    sift=train_D{i};
    siftposition=train_F{i};
    siftpositionlabel=calc_position(siftposition(1:2,:));
    
    trainData_l2=[];
    
    for j=1:16
        sift_pos_l2{j}=sift(:,find(siftpositionlabel==j));
    
        distance=pdist2(clusters',double(sift_pos_l2{j}'),'euclidean');
        [~,pred]=sort(distance,'ascend');
        pred=pred(1,:);
        word_l2{j}=histc(pred,1:K);
        word_l2_=word_l2{j}/sum(word_l2{j});
        trainData_l2=[trainData_l2,word_l2_];
    end
    trainData_l2=trainData_l2*0.5;  %% Weight for Layer 2
    
    
    %%L1
    trainData_l1=[];
    
        word_l1{1}=word_l2{1}+word_l2{2}+word_l2{5}+word_l2{6};
        word_l1_=word_l1{1}/sum(word_l1{1});
        trainData_l1=[trainData_l1,word_l1_];
        
        word_l1{2}=word_l2{3}+word_l2{7}+word_l2{4}+word_l2{8};
        word_l1_=word_l1{2}/sum(word_l1{2});
        trainData_l1=[trainData_l1,word_l1_];
        
        word_l1{3}=word_l2{9}+word_l2{10}+word_l2{13}+word_l2{14};
        word_l1_=word_l1{3}/sum(word_l1{3});
        trainData_l1=[trainData_l1,word_l1_];
        
        word_l1{4}=word_l2{11}+word_l2{12}+word_l2{15}+word_l2{16};
        word_l1_=word_l1{4}/sum(word_l1{4});
        trainData_l1=[trainData_l1,word_l1_];
        
    trainData_l1=trainData_l1*0.25;  %% Weight for Layer 1
    
    %%L0
    
    word=word_l1{1}+word_l1{2}+word_l1{3}+word_l1{4};
    word=word/sum(word);
    trainData_l0=word*0.25;  %% Weight for Layer 0
    
    %%Final Word
    trainData(i,:)=[trainData_l0,trainData_l1,trainData_l2];
end

%% Compute Word for Test
sift_pos_l2=cell(16,1);

word_l2=cell(16,1);
word_l1=cell(4,1);


for i=1:800
    
    %%L=2
    sift=test_D{i};
    siftposition=test_F{i};
    siftpositionlabel=calc_position(siftposition(1:2,:));
    
    testData_l2=[];
    
    for j=1:16
        sift_pos_l2{j}=sift(:,find(siftpositionlabel==j));
    
        distance=pdist2(clusters',double(sift_pos_l2{j}'),'euclidean');
        [~,pred]=sort(distance,'ascend');
        pred=pred(1,:);
        word_l2{j}=histc(pred,1:K);
        word_l2_=word_l2{j}/sum(word_l2{j});
        testData_l2=[testData_l2,word_l2_];
    end
    testData_l2=testData_l2*0.5;  %% Weight for Layer 2
    
    
    %%L1
    testData_l1=[];
    
        word_l1{1}=word_l2{1}+word_l2{2}+word_l2{5}+word_l2{6};
        word_l1_=word_l1{1}/sum(word_l1{1});
        testData_l1=[testData_l1,word_l1_];
        
        word_l1{2}=word_l2{3}+word_l2{7}+word_l2{4}+word_l2{8};
        word_l1_=word_l1{2}/sum(word_l1{2});
        testData_l1=[testData_l1,word_l1_];
        
        word_l1{3}=word_l2{9}+word_l2{10}+word_l2{13}+word_l2{14};
        word_l1_=word_l1{3}/sum(word_l1{3});
        testData_l1=[testData_l1,word_l1_];
        
        word_l1{4}=word_l2{11}+word_l2{12}+word_l2{15}+word_l2{16};
        word_l1_=word_l1{4}/sum(word_l1{4});
        testData_l1=[testData_l1,word_l1_];
        
    testData_l1=testData_l1*0.25;  %% Weight for Layer 1
    
    %%L0
    
    word=word_l1{1}+word_l1{2}+word_l1{3}+word_l1{4};
    word=word/sum(word);
    testData_l0=word*0.25;  %% Weight for Layer 0
    
    %%Final Word
    testData(i,:)=[testData_l0,testData_l1,testData_l2];
end


%% SVM
u=unique(train_gs');
numClasses=length(u);
result = zeros(length(testData(:,1)),1);

SVMModels = cell(numClasses,1);

for k=1:numClasses
    OneVsRest=(train_gs'==u(k));
    SVMModels{k} =fitcsvm(trainData,OneVsRest);
end

labels=zeros(800,2);
labels(:,1)=-100; % As One Vs Rest is highly imbalanced, for one class, class 
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

test_gs2=test_gs';

diff=test_gs2-labels(:,2);
accuracy=size(find(diff==0),1)/800;

fprintf("Accuracy is %f\n",accuracy);
C = confusionmat(test_gs2,labels(:,2));
imagesc(C);
colorbar

