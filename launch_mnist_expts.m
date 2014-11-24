function launch_mnist_expts

expt_nm = 1;
mkdir(sprintf('~/deepmaxpool/results/expt%d',expt_nm))

wNs = 2:10;
mNs = 2:10;
maxsz = 20000;

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


run_blam2(theta, zeros(size(theta,1),1),expt_nm, 'run_model')