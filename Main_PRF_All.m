function [Yactual,YpredV,YpredP,YpredwRF, P1, AA, Mu1,Mu2, Sigma1,Sigma2, LH_T, LH_default,model,wRF_A,Y_testing]...
    = Main_PRF_All(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex)

finalY=finalY(:,Column);
if F>1
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
else
    [Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedData1fold(finalX,finalY);
end

for FF=1:F  
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
  
    model{FF} = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1); 
    %% RF
    Y_hatV{FF} = forest_predict(Xt{FF}, model{FF}, ones(1,n_tree)/n_tree);
    %% PRF
    [P1{FF}, Mu1{FF}, Sigma1{FF}] = FindP(X1,n_tree,model{FF});
    [AA{FF}, LH_T(FF), LH_default(FF)]=findA(P1{FF}', n_tree, Eta);
    Y_hatP{FF} = forest_predict(Xt{FF}, model{FF}, AA{FF});
    [Mu2{FF}, Sigma2{FF},Y_testing{FF}] = FindP_test(Xt{FF},n_tree,model{FF});
    %% wRF weight prediction
    wRF_A{FF}=findA_wRF(X1,model{FF},n_tree,Y1);
    Y_hat_wRF{FF} = forest_predict(Xt{FF}, model{FF}, wRF_A{FF});  
end

Yactual=[];
YpredV=[];
YpredP=[];
YpredwRF=[];

for i=1:F
    Yactual =[Yactual; Yt{i}];
    YpredV  =[YpredV;  Y_hatV{i}];
    YpredP  =[YpredP;  Y_hatP{i}];
    YpredwRF=[YpredwRF;Y_hat_wRF{i}];
end

