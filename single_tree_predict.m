function Y = single_tree_predict(X, t, variable_num)
% X: input testing sets
% t: tree model built
% Y: output predicted value

Y = zeros(size(X,1),variable_num);
for i = 1:size(X,1)
    x = X(i,:);
    
    leaf_info = predict(x,t);
    Y(i,:) = mean(leaf_info(:,2:end));
end

