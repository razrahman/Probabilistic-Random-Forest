clear; close all;clc;
addpath(genpath(pwd))
tic
n_tree=5;
mtree=5;
F=1;
min_leaf=3;
Eta=2;
Sample=250;
finalX=rand(Sample,10);
Y1= 1*randn(Sample,1) + 0;  %real	valued,	normally distributed with mean 0 and variance 1
% Y2= rand(Sample,1);         %real	valued,	uniformly distributed in the range of (0,1)
% Y3=randi([0,1],Sample,1);   %containing	integers [0,1] at	equal	probability
finalY=5*finalX(:,3)+5*finalX(:,9)-1.5*finalX(:,1).^3+finalX(:,2).*finalX(:,4)+...
       2*finalX(:,5)+10*finalX(:,6)-1.5*finalX(:,7).^2+finalX(:,6).*finalX(:,8)+2*Y1;%+5*Y2-1.5*Y3.^3+4*Y1.*Y2;

finalY=(finalY-min(min(finalY)))/(max(max(finalY))-min(min(finalY)));

if F>1
    [Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataMRF(finalX,finalY,F);
else
    [Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataResub(finalX,finalY,F);
end
Command=3;
Column=1;
[Yactual,YpredV,YpredP,YpredW, P1, AA, Mu1,Mu2, Sigma1,Sigma2, LH_T, LH_default,model,wRF_A,Y_testing]...
    = Main_PRF_All(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex);

% [YactualP,YpredP,YpredPB, P, AA, Mu1,Mu2, Sigma1,Sigma2,LH_T, LH_default,ModelPRF]...
%     = Main_PRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex);
%
% [YactualV,YpredV,YpredVB,ModelRF]...
%     =Main_VRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex);
%
% [YactualW,YpredW,WRF_A]=Main_wRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex);
ll=length(Yactual);
NRMSEV=sqrt(((Yactual-YpredV)'*(Yactual-YpredV))...
                /((Yactual-(ones(1,ll)*YpredV/ll)*ones(ll,1))'*(Yactual-(ones(1,ll)*YpredV/ll)*ones(ll,1))));
NRMSEP=sqrt(((Yactual-YpredP)'*(Yactual-YpredP))...
                /((Yactual-(ones(1,ll)*YpredP/ll)*ones(ll,1))'*(Yactual-(ones(1,ll)*YpredP/ll)*ones(ll,1))));
NRMSEW=sqrt(((Yactual-YpredW)'*(Yactual-YpredW))...
                /((Yactual-(ones(1,ll)*YpredW/ll)*ones(ll,1))'*(Yactual-(ones(1,ll)*YpredW/ll)*ones(ll,1))));
MSEV=mean((Yactual-YpredV).^2);
MSEP=mean((Yactual-YpredP).^2);
MSEW=mean((Yactual-YpredW).^2);

MAEV=mean(abs(Yactual-YpredV));
MAEP=mean(abs(Yactual-YpredP));
MAEW=mean(abs(Yactual-YpredW));

CRFV=corr(Yactual, YpredV);
CRFP=corr(Yactual, YpredP);
CRFW=corr(Yactual, YpredW);
%% confidence level
Confidence=[0.50 0.70 0.80 0.95 0.99];
for k=1:length(Confidence)
    [Count11(k), Count12(k), Count13(k),BB, P_val]=Count2(Mu2, Sigma2, AA, wRF_A', finalY, F,Confidence(k), Yactual);
    
    NN(k)=length(BB(:,1));
    NNN(k)=sum((BB(:,1)-BB(:,2))<0);
    mBB{k}(1)=mean(BB(:,1));
    mBB{k}(2)=mean(BB(:,2));
    mBB{k}(3)=(mBB{k}(2)-mBB{k}(1))/mBB{k}(1)*100;
    
    NNN2(k)=sum((BB(:,1)-BB(:,3))<0);
    mBB2{k}(1)=mean(BB(:,1));
    mBB2{k}(2)=mean(BB(:,3));
    mBB2{k}(3)=(mBB2{k}(2)-mBB2{k}(1))/mBB2{k}(1)*100;
end
MBBB=cell2mat(mBB);
MBBB2=cell2mat(mBB2);
%% QRF confidence interval
for k=1:length(Confidence)
    [Count11_QRF(k), Count12_QRF(k), BB_QRF]=Count_QRF(Mu2, Sigma2, AA, Y_testing, finalY, F,Confidence(k), Yactual);
    
    NN_QRF(k)=length(BB_QRF(:,1));
    NNN_QRF(k)=sum((BB_QRF(:,1)-BB_QRF(:,2))<0);
    mBB_QRF{k}(1)=mean(BB_QRF(:,1));
    mBB_QRF{k}(2)=mean(BB_QRF(:,2));
    mBB_QRF{k}(3)=(mBB_QRF{k}(2)-mBB_QRF{k}(1))/mBB_QRF{k}(1)*100;
end
MBBB_QRF=cell2mat(mBB_QRF);
Time=toc;
[MAEV MAEW MAEP]
[MSEV MSEW MSEP]
[NRMSEV NRMSEW NRMSEP]
[CRFV CRFW CRFP]
[MBBB(:,3) MBBB(:,6) MBBB(:,9) MBBB(:,12) MBBB(:,15)]
[MBBB2(:,3) MBBB2(:,6) MBBB2(:,9) MBBB2(:,12) MBBB2(:,15)]
[MBBB_QRF(:,3) MBBB_QRF(:,6) MBBB_QRF(:,9) MBBB_QRF(:,12) MBBB_QRF(:,15)]
P_val
% save('PRF_syn_T5_sample250_Y1_NF.mat')