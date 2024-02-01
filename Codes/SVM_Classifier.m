% ********************************Classification************************************

%%Declaration of train & test set
clc;
clear all;
close all;

%Creating the Train Feature Vector from the Train Dataset
Train_fv = table2array(importdata('G:\train_dataset2.mat'));

%Creating the Test Feature Vector from Test Dataset
Test_fv = table2array(importdata('G:\test_dataset2.mat'));

%Labeling the Train and Test Feature Vector
Train_label = ([ones(1,52), 2*ones(1,12)]).';
Test_label = ([ones(1,20), 2*ones(1,4)]).';
%t=templateSVM('KernelFunction','quadratic')
% MODEL=fitcsvm(Train_fv,Train_label);
% GROUP=predict(MODEL,Test_fv);
% CM=confusionmat(Test_label,GROUP);
% acc=(trace(CM)/80)*100;

%% CV partition
c = cvpartition(Train_label, 'k', 5);

%% feature selection
opts = statset('display','iter');
fun = @(Train_fv,Train_label,Test_fv,Test_label)...
sum(predict(fitcsvm(Train_fv,Train_label,'KernelFunction','rbf'),Test_fv) ~= Test_label)
[fs,history] = sequentialfs(fun,Train_fv,Train_label,'cv', c, 'options',opts, 'nfeatures',5)
%% Best Hyperparameters
X_train_w_best_features = Train_fv(:,fs);

%Creating the Support Vector Machine Machine Learning Model
Md1 = fitcsvm(X_train_w_best_features,Train_label,'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName',...
    'expected-improvement-plus','ShowPlots', true));
%% test model with test set
X_test_w_best_features = Test_fv(:,fs);

%Variable to store the Accurracy value of the Model
accuracy = sum(predict(Md1,X_test_w_best_features) == Test_label)/length(Test_label)*100

%Creating the Confusion Matrix
CM=confusionmat(Test_label,predict(Md1,X_test_w_best_features));
