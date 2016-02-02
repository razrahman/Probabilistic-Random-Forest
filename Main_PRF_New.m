function [YactualP,YpredP,YpredPB, P1, AA, Mu1,Mu2, Sigma1,Sigma2, LH_T, LH_default,model]...
    = Main_PRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex)

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
    [P1{FF}, Mu1{FF}, Sigma1{FF}] = FindP(X1,n_tree,model{FF});
    [AA{FF}, LH_T(FF), LH_default(FF)]=findA(P1{FF}', n_tree, Eta);
    Y_hatP{FF} = forest_predict(Xt{FF}, model{FF}, AA{FF});
    [Mu2{FF}, Sigma2{FF}] = FindP_test(Xt{FF},n_tree,model{FF});
    
end



YactualP=[];
YpredP=[];
YpredPB=[];

parfor i=1:F
    YactualP=[YactualP;Yt{i}];
    YpredP=[YpredP;Y_hatP{i}];
%     YpredPB=[YpredPB;Y_hatP{i}(:,1)+Bias(i,1)];
end

