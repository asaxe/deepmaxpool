% Script version of sweep_L2 function for extra memory efficiency (avoids one copy of si)
 
lambdas = logspace(0,4,20);

N = size(si_tr,1);
diag_inds = 1:(N+1):N^2;

ind = 1;
for lambda = lambdas

    si_tr(diag_inds) = si_tr(diag_inds) + lambda;
    W = sio_tr/si_tr;
    si_tr(diag_inds) = si_tr(diag_inds) - lambda;
    
    tr_error(ind) = eval_error(W,xmu_tr,ymu_tr);
    ts_error(ind) = eval_error(W,xmu_ts,ymu_ts);

    ind = ind + 1;
end
