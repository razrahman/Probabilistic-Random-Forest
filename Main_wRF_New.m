function[YactualW,YpredW,wRF_A]=Main_wRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex)

finalY=finalY(:,Column);
if F>1
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
else
    [Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedData1fold(finalX,finalY);
    %[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataResub(finalX,finalY,F);
end

for FF=1:F  
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
  
    model{FF} = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1);    
    wRF_A{FF}=findA_wRF(X1,model{FF},n_tree,Y1);
    Y_hat_wRF{FF} = forest_predict(Xt{FF}, model{FF}, wRF_A{FF}); 
end



YactualW=[];
YpredW=[];

parfor i=1:F
    YactualW=[YactualW;Yt{i}];
    YpredW=[YpredW;Y_hat_wRF{i}];
end