function [Yactual,YpredP,YpredV, AAA,Mu2,Covar, Covar2,model,YY,Z,Cluster]...
    = Main_PRF_NewB(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex)

finalY=finalY(:,Column);
if F>1
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
else
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedData1fold(finalX,finalY);
    %[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataResub(finalX,finalY,F);
end

for FF=1:F  
    FF
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    [ranked, ~]=relieff(X1, Y1, 10);
    X1=X1(:,ranked(1:100));
    Xt{FF}=Xtest{FF}(:,ranked(1:100));%50-100
    Yt{FF}=Ytest{FF};
  
    model{FF} = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1);    
    [AAA{FF},Covar{FF},Z{FF},Cluster{FF}]=FindPR(X1,n_tree,model{FF});

    Y_hatP{FF} = forest_predict(Xt{FF}, model{FF},  AAA{FF});%forest_predict_alpha(Xt{FF}, model{FF}, AA{FF},Eta);
    [Mu2{FF}, Covar2{FF},YY{FF}] = FindPB_test(Xt{FF},n_tree,model{FF});
    
    Y_hatV{FF} = forest_predict(Xt{FF}, model{FF}, ones(1,n_tree)/n_tree);
end
cell2mat(Covar)
cell2mat(Covar2)

Yactual=[];
YpredP=[];
YpredV=[];

parfor i=1:F
    Yactual=[Yactual;Yt{i}];
    YpredP=[YpredP;Y_hatP{i}];
    YpredV=[YpredV;Y_hatV{i}];
end

