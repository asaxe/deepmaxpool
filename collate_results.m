function res = collate_results(expt_nm)

fs = dir(sprintf('~/deepmaxpool/results/expt%d/*.mat',expt_nm));

for i = 1:length(fs)
	  load(sprintf('~/deepmaxpool/results/expt%d/%s',expt_nm,fs(i).name))
    res(i,:) = [params_tr.wNr params_tr.Nfilt params_tr.mNr best_ts ...
                best_lambda params_tr.N];
    

end
