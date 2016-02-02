function syntax_t = draw_syntax_tree(feature_threshold_t, features_name, model, tree_num)

feature_info = model.feature_info;
feature_num = feature_info(:,tree_num);

syntax_t = tree(feature_threshold_t, 'clear');
iterator = syntax_t.depthfirstiterator;
for i = iterator
    if feature_threshold_t.isleaf(i)==0
        temp = feature_threshold_t.get(i);
        feature = features_name(feature_num);
        syntax_t = syntax_t.set(i, sprintf('%s > %.4f', feature{temp(1)}, temp(2)));
    else
        syntax_t = syntax_t.set(i, feature_threshold_t.get(i));
    end
end

figure, syntax_t.plot