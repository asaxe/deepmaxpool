function [sio, si, so, xmu, ymu, params] = compute_2D_maxpool_corrs(x, ...
                                                      y, params)
        
P = params.P;
xNr = params.xNr;
xNc = params.xNc;
sh = params.sh;

sio = [];
si = [];
so = [];
compute_corrs = ~isfield(params,'compute_corrs') || params.compute_corrs;

%% Set up filtering parameters

wNr=params.wNr;
wNc=params.wNc;
Nfilt = params.Nfilt;

mNr=params.mNr;
mNc=params.mNc;

w = params.w;

%% Compute and store pooling regions

ind = 1;
for pr = 1:mNr
    for pc = 1:mNc
        por(ind) = pr;
        poc(ind) = pc;
        ind = ind + 1;
    end
end

M = [];
for c = 1:mNc:xNc+1-mNc
    for r = 1:mNr:xNr+1-mNr    
        M = [M  sub2ind([xNr xNc],r+por-1,c+poc-1)'];
    end
end
Np = size(M,2);

params.Np = Np;
params.M = M;

%% Plot pooling regions
plot_pool_reg = false;
if plot_pool_reg
     for i = 1:100;
         tmp = zeros(1,xNr*xNc);
         tmp(M(:,i))=1;
        imagesc(sh(tmp))
        pause
     end
end





%% Compute input-output and input correlations

if compute_corrs
    si = zeros(Np*wNr*wNc*Nfilt,Np*wNr*wNc*Nfilt);
    sio = zeros(size(y,1),Np*wNr*wNc*Nfilt);
end

Nbatch = 10000;
params.Nbatch = Nbatch;
for batch = 1:P/Nbatch
    tic
    batch

    xmu = zeros(size(M,2)*Nfilt,Nbatch);
    ind = 1;
    % Compute convolutions and maxes

    for mu = (batch-1)*Nbatch+1:batch*Nbatch
        
        %        if mod(mu,10)==0
        %    mu
        %end


        %Conv
        xc = im2col(padarray(x(:,:,mu),[ceil((wNr-1)/2) ceil((wNc-1)/2)]),[wNr wNc]);      
        
        for f = 1:Nfilt
            xw = w(f,:)*xc;

            % Max

            [m,I] = max(reshape(xw(M),size(M)));
            max_winners = M(sub2ind(size(M),I,1:length(I)));
            xmu((f-1)*Np*wNr*wNc+1:f*Np*wNr*wNc,ind) = reshape(xc(:,max_winners),Np*wNr*wNc,1);
        end

        ind = ind + 1;
        
    end %/mu
    ymu = y(:,(batch-1)*Nbatch+1:batch*Nbatch);
    
    if compute_corrs
        si = si + xmu*xmu';
        sio = sio + ymu*xmu';
    end
    toc
end %/batch
if compute_corrs
    so = y*y';
end

