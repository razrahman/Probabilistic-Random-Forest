function [YactualV,YpredV,YpredVB,model,AA]...
    = Main_VRF_New(finalX,finalY,F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex)

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
  
%     [xtrain,xtest,ytrain,ytest,FoldedIndex2]=CreateFoldedDataMRF(X1,Y1,F);
%     
%                 for ff=1:F
%                     x1=xtrain{ff};
%                     y1=ytrain{ff};
%                     xt{ff}=xtest{ff};
%                     yt{ff}=ytest{ff};
% 
%                     m = build_forest(x1, y1, n_tree, mtree,1,Command, min_leaf, 1);
%                     y_hat{ff} = forest_predict(xt{ff}, m, ones(1,n_tree)/n_tree);
%                 end
% 
%                 yactual=[];
%                 ypred=[];
% 
%                 parfor i=1:F
%                     yactual=[yactual;yt{i}];
%                     ypred=[ypred;y_hat{i}];
%                 end
% 
%     Bias(FF,:)=mean(yactual-ypred);
    model{FF} = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1);    
    Y_hatV{FF} = forest_predict(Xt{FF}, model{FF}, ones(1,n_tree)/n_tree);
    AA{FF}=ones(1,n_tree)/n_tree;
end



YactualV=[];
YpredV=[];
YpredVB=[];

parfor i=1:F
    YactualV=[YactualV;Yt{i}];
    YpredV=[YpredV;Y_hatV{i}];
%     YpredVB=[YpredVB;Y_hatV{i}(:,1)+Bias(i,1) ];
end

