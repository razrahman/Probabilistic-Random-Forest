function Y_norm = norm_response(Y)

Y_all = reshape(Y, [], 1);

range = max(Y_all) - min(Y_all);
Y_norm = (Y_all - min(Y_all))/range;

Y_norm = reshape(Y_norm, [], size(Y,2));