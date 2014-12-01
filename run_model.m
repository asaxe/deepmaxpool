function run_model(theta,particleid,exptnum)

tic
%% Params

params.wNr=theta(1);
params.wNc=theta(1);
params.Nfilt = theta(2);

params.mNr=theta(3);
params.mNc=theta(3);

params.Npc = theta(4);

randn('seed',1);
params.w = randn(params.Nfilt,params.wNr*params.wNc);

%% Train
sprintf('Training')
params_tr = params;
params_tr.dataset = 'mnist_train';
[x, y, params_tr] = load_dataset(params_tr);
params_tr = pca_patch(x, params_tr);
[sio_tr, si_tr, so_tr, xmu_tr, ymu_tr, params_tr] = compute_2D_maxpool_corrs(x, y, params_tr);
clear x y 

%% Test
sprintf('Testing')
params_ts = params;
params_ts.dataset = 'mnist_test';
params_ts.compute_corrs = false;
[x, y, params_ts] = load_dataset(params_ts);
[sio_ts, si_ts, so_ts, xmu_ts, ymu_ts, params_ts] = compute_2D_maxpool_corrs(x, y, params_ts);
clear x y params sio_ts si_ts so_ts

%% Classify
sprintf('Crossvalidating')
sweep_L2_script
%[tr_error, ts_error, lambdas] = sweep_L2(sio_tr, si_tr, xmu_tr, ...
%                                         ymu_tr, xmu_ts, ymu_ts);

%% Save
sprintf('Saving')
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

params_tr.N = N;

save(sprintf('~/deepmaxpool/results/expt%d/l2_w%d_f%d_m%d.mat',exptnum,params_tr.wNr,params_tr.Nfilt,params_tr.mNr),'tr_error','ts_error','params_tr','params_ts','lambdas','best_ts','best_lambda');
