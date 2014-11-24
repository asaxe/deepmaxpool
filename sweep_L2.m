function [tr_error, ts_error, lambdas] = sweep_L2(sio, si, xmu_tr, ...
                                                  ymu_tr, xmu_ts, ymu_ts);
lambdas = logspace(-2,5,20);

ind = 1;
for lambda = lambdas


    W = linear_pred(sio, si, lambda);
    
    tr_error(ind) = eval_error(W,xmu_tr,ymu_tr);
    ts_error(ind) = eval_error(W,xmu_ts,ymu_ts);

    ind = ind + 1;
end