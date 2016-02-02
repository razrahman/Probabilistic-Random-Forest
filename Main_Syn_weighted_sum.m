clear; close all;clc;
addpath(genpath(pwd))
tic
n_tree=5;
mtree=10;
F=1;
min_leaf=5;
Eta=1.5;
Sample=500;
finalX=rand(Sample,1000);
Y1= 1*randn(Sample,1) + 0;  %real	valued,	normally distributed with mean 0 and variance 1
% Y2= rand(Sample,1);         %real	valued,	uniformly distributed in the range of (0,1)
% Y3=randi([0,1],Sample,1);   %containing	integers [0,1] at	equal	probability
% finalY=2*finalX(:,1)+10*finalX(:,2)-1.5*finalX(:,3)+1*finalX(:,4);
finalY= 5*finalX(:,3)+5*finalX(:,9)-1.5*finalX(:,1).^3+finalX(:,2).*finalX(:,4)+...
    2*finalX(:,5)+10*finalX(:,6)-1.5*finalX(:,7).^2+finalX(:,6).*finalX(:,8)+2*Y1;

finalY=(finalY-min(min(finalY)))/(max(max(finalY))-min(min(finalY)));

if F>1
    [Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataMRF(finalX,finalY,F);
else
    [Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataResub(finalX,finalY,F);
end
Command=3;
Column=1;
[Yactual,YpredP,YpredV, AA,Mu2,Covar, Covar2,model,YY,Z,Cluster]...
    = Main_PRF_NewB(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex);

MSV=mean((Yactual-YpredV).^2);
MSP=mean((Yactual-YpredP).^2);

CRFV=min(min(corrcoef(Yactual, YpredV)));
CRFP=min(min(corrcoef(Yactual, YpredP)));

for i=1:F
    Var_T(i)=AA{i}*Covar2{i}*AA{i}';
    Var_default(i)=1/n_tree*ones(n_tree,1)'*Covar2{i}*1/n_tree*ones(n_tree,1);
end