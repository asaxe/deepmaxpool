function W = linear_pred(sio, si, lambda)
%% Compute linear predictor
    
W = sio/(si + lambda*eye(size(si)));
