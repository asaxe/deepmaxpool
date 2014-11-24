function run_model(theta,particleid,exptnum)

tic
%% Params

params.wNr=theta(1);
params.wNc=theta(1);
params.Nfilt = theta(2);

params.mNr=theta(3);
params.mNc=theta(3);

randn('seed',1);
params.w = randn(params.Nfilt,params.wNr*params.wNc);

%% Train
params_tr = params;
params_tr.dataset = 'mnist_train';
[x, y, params_tr] = load_dataset(params_tr);
[sio_tr, si_tr, so_tr, xmu_tr, ymu_tr, params_tr] = compute_2D_maxpool_corrs(x, y, params_tr);
clear x y 

%% Test
params_ts = params;
params_ts.dataset = 'mnist_test';
[x, y, params_ts] = load_dataset(params_ts);
[sio_ts, si_ts, so_ts, xmu_ts, ymu_ts, params_ts] = compute_2D_maxpool_corrs(x, y, params_ts);
clear x y params sio_ts si_ts so_ts

%% Classify
[tr_error, ts_error, lambdas] = sweep_L2(sio_tr, si_tr, xmu_tr, ...
                                         ymu_tr, xmu_ts, ymu_ts);

%% Save
[best_ts,I] = min(ts_error);
best_ts
toc
best_lambda = lambdas(I);

params_tr.w = [];
params_ts.w = [];
params_ts.M = [];
params_ts.M = [];
params_tr.sh = [];
params_ts.sh = [];

save(sprintf('~/deepmaxpool/results/expt%d/l2_w%d_f%d_m%d.mat',exptnum,params_tr.wNr,params_tr.Nfilt,params_tr.mNr),'tr_error','ts_error','params_tr','params_ts','lambdas','best_ts','best_lambda');
