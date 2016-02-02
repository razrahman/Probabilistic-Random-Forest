function [AAD, CRF,Yactual,Ypred, model] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,Column, Command, min_leaf)

finalY=finalY(:,Column);
if F>1
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F,FoldedIndex);
else
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataResub(finalX,finalY,F);
end

for FF=1:F 
    FF
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
    model{FF} = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1)
    Y_hat{FF} = forest_predict(Xt{FF}, model{FF}, ones(1,n_tree)/n_tree);
    AAD(FF,:)=mean(abs(Y_hat{FF}-Yt{FF}));
end


Yactual=[];
Ypred=[];

for i=1:F
    Yactual=[Yactual;Yt{i}];
    Ypred=[Ypred;Y_hat{i}];
end

CRF=corrcoef(Yactual(:,1),Ypred(:,1));
