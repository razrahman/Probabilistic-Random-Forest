function [AA,Covar,Z,Clustering1] = FindPR(X1,n_tree,M)

forest = M.forest;
YY=cell(size(X1,1),n_tree);
for i = 1:n_tree
    t = forest{1,i};
    for j = 1:size(X1,1)
        x = X1(j,:);
        leaf_info = predict(x,t);
        YY{j,i} = leaf_info(:,2:end);
        MM(j,i)=mean(leaf_info(:,2:end));
    end
end
%% co-variance matrix
%for ii=1:size(X1,1)
for T1=1:n_tree
    for T2=1:n_tree
        com=[];
        for k=1:size(X1,1)
            for j=1:10
                com=[com ; datasample(YY{k,T1},1) datasample(YY{k,T2},1)];
            end
        end
        if T1==T2
            Covar(T1,T2)=cov(com(:,1));
        elseif T1~=T2
            COV=cov(com(:,1),com(:,2));
            Covar(T1,T2)=COV(1,2);
        end
        %              Covar(T1,T2)=min(min(corrcoef(com(:,1),com(:,2))))*std(com(:,1))*std(com(:,2));
    end
end
S=[];
for i=1:n_tree
    for j=i:n_tree
        if i~=j
            S=[S Covar(i,j)];
        end
    end
end
S1=(mean(diag(Covar))-S')';
Cutoff=mean(diag(Covar))-.6*mean(diag(Covar));
Z=linkage(S1);
Clustering1=cluster(Z,'cutoff',Cutoff,'criterion','distance');
Weight_clus=1/max(Clustering1);
for i=1:n_tree
    L=length(find(Clustering1(i)==Clustering1));
    AA(i)=Weight_clus/L;
end




