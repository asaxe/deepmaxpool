function run_blam2(thetas, particle_id, expt_nm, fn_str)

% make param file

wd = pwd;
pf = 'params.txt';
fid = fopen(pf,'w');
for i = 1:size(thetas,1)
    fprintf(fid,'cd %s; /usr/local/bin/matlabr2012a -nodisplay -nojvm -nodesktop -nosplash -r "addpath(''~/deepmaxpool''),%s(%s,%d,%d),exit"\n',wd,fn_str,mat2str(thetas(i,:)),particle_id(i),expt_nm);
     % confusing string escaping note: to get one single quote, put in two
end
fclose(fid);

% Run blam2

tic
system(['blam2 ~/blam2/nodes_spec.txt ' pf]);
toc

