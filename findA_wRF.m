function wRF_A=findA_wRF(X1,Model,n_tree,Y1)

variable_num = Model.variable_num;
forest = Model.forest;

for T=1:n_tree
    Train_sample=Model.bootsam(:,T);
    Trained_sample=unique(Train_sample);
    OOB_sample=setdiff(1:size(X1,1),Trained_sample);
    
    t = forest{1,T};
    Y_predict = single_tree_predict(X1(OOB_sample,:), t, variable_num);
    tPE(T)=(1/length(OOB_sample))*sum(Y_predict-Y1(OOB_sample,:));
    xj(T)=1-tPE(T);
end

for T=1:n_tree
    wRF_A(T)=xj(T)/sum(xj);
end