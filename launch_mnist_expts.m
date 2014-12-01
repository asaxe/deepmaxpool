function launch_mnist_expts

expt_nm = 6;
mkdir(sprintf('~/deepmaxpool/results/expt%d',expt_nm))

wNs = 5:10;
mNs = 5:10;
maxsz = 55000;

i = 1;
for wN = wNs
    for mN = mNs

        % Choose largest Nf that keeps size below maxsz x maxsz

        Nf = floor(maxsz/wN.^2/floor(28/mN).^2);
        if Nf >= 1

            theta(i,:) = [wN Nf mN];
            i = i + 1;
        end
    end
end

if ~isempty(strfind(getenv('HOSTNAME'),'sh'))
	launch_fn = @run_sherlock;
 else
	  launch_fn = @run_blam2;
end
launch_fn(theta, zeros(size(theta,1),1),expt_nm, 'run_model')
	 
