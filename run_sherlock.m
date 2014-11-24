function run_sherlock(thetas, particle_id, expt_nm, fn_str)

% make param file

wd = pwd;

N = size(thetas,1);

for i = 1:N
	  pf = 'job.sbatch';
fid = fopen(pf,'w');
jobname = sprintf('d%d_%d_%d',expt_nm,i,N);
fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'#SBATCH --job-name=%s\n',jobname);
fprintf(fid,'#SBATCH --output=/home/asaxe/deepmaxpool/log/%s.out\n',jobname);
fprintf(fid,'#SBATCH --error=/home/asaxe/deepmaxpool/log/%s.err\n',jobname);
fprintf(fid,'#SBATCH --time=24:00:00\n');
fprintf(fid,'#SBATCH --qos=normal\n');
fprintf(fid,'#SBATCH --nodes=1\n');
fprintf(fid,'#SBATCH --ntasks=1\n');
fprintf(fid,'#SBATCH --cpus-per-task=8\n');
fprintf(fid,'#SBATCH --mem=30000\n\n');
fprintf(fid,'module load matlab\n');
fprintf(fid,'cd %s; matlab -nodisplay -nojvm -nodesktop -nosplash -r "%s(%s,%d,%d),exit"\n',wd,fn_str,mat2str(thetas(i,:)),particle_id(i),expt_nm);
% confusing string escaping note: to get one single quote, put in two

    fclose(fid);
    
    % Submit job
    
    system(['sbatch ' pf]);
    
end




