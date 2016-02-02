 function [Mu, Covar,YY] = FindPB_test(XX,n_tree,M)

forest = M.forest;
YY=cell(size(XX,1),n_tree);
for i = 1:n_tree
    t = forest{1,i};
    for j = 1:size(XX,1)
        x = XX(j,:);
        leaf_info = predict(x,t);
        YY{j,i} = leaf_info(:,2:end);
        Mu(j,i)=mean(leaf_info(:,2:end));
    end
end
%% co-variance matrix
%for ii=1:size(XX,1)
    for T1=1:n_tree
        for T2=1:n_tree
            com=[];
            for k=1:size(XX,1)%kk:kk+9
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
            %Covar(T1,T2)=min(min(corrcoef(com(:,1),com(:,2))))*std(com(:,1))*std(com(:,2));%think
        end
    end
%end

% for i=1:n_tree
%     for j=1:n_tree
%         if Covar(i,j)<mean(diag(Covar))/2.33
%             Covar(i,j)=0;
%         end
%     end
% end