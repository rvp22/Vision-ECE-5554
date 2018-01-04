% Evaluate SLIC implementation

% 
% ECE 5554/4554 Computer Vision, Fall 2017
% Virginia Tech

addpath(genpath('BSR'));
addpath(genpath('superpixel_benchmark'));

% Run the complet benchmark
main_benchmark('evalSlicSetting.txt');

% Report the case with K = 64
load('result\slic\slic_1024_1\benchmarkResult.mat');

avgRecall   =  mean(imRecall(:));
avgUnderseg =  mean(imUnderseg(:));
fprintf('Average boundary recall = %f for K = 1024 \n' , avgRecall);
fprintf('Average underseg error  = %f for K = 1024 \n' , avgUnderseg);
