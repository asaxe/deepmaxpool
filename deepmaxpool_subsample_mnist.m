clear all

savefile = '~/datasets/mnist/mnist_train';

addpath('~/datasets/mnist')
%xtmp = loadMNISTImages('/Users/asaxe/Documents/doctoralwork/rht/project/datasets/mnist/t10k-images-idx3-ubyte');
xtmp = loadMNISTImages('~/datasets/mnist/train-images-idx3-ubyte');
sh = @(a) reshape(a,28,28)
xNr = round(sqrt(size(xtmp,1)));
xNc = round(sqrt(size(xtmp,1)));
P = size(xtmp,2);
x = zeros(xNr,xNc,P);
avg = mean(xtmp,2);
for i = 1:size(xtmp,2)
    x(:,:,i) = sh(xtmp(:,i)-avg);
    
end
clear xtmp;
%%

%ytmp = loadMNISTLabels('~/datasets/mnist/t10k-labels-idx1-ubyte');
ytmp = loadMNISTLabels('~/datasets/mnist/train-labels-idx1-ubyte');
ytmp(ytmp==0) = 10;

y = zeros(10,P);
for i = 1:P
    y(ytmp(i),i) = 1;
end
clear ytmp;


%% Set up filtering parameters

wNr=5;
wNc=5;
Nfilt = 8;

mNr=5;
mNc=5;
%%
w = randn(Nfilt,wNr*wNc);

for i = 1:Nfilt
    
end


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

%%



%% Compute input-output and input correlations


si = zeros(Np*wNr*wNc*Nfilt,Np*wNr*wNc*Nfilt);
sio = zeros(size(y,1),Np*wNr*wNc*Nfilt);

Nbatch = 10000;
for batch = 1:P/Nbatch

    xmu = zeros(size(M,2)*Nfilt,Nbatch);
    ind = 1;
    % Compute convolutions and maxes
    for mu = (batch-1)*Nbatch+1:batch*Nbatch
        mu


        %Conv
        xc = im2col(padarray(x(:,:,mu),[(wNr-1)/2 (wNc-1)/2]),[wNr wNc]);      
        xw = w*xc;

        % Max
        for f = 1:Nfilt
            [m,I] = max(reshape(xw(f,M),size(M)));
            max_winners = M(sub2ind(size(M),I,1:length(I)));
            xmu((f-1)*Np*wNr*wNc+1:f*Np*wNr*wNc,ind) = reshape(xc(:,max_winners),Np*wNr*wNc,1);
        end

        ind = ind + 1;

    end %/mu
    si = si + xmu*xmu';
    sio = sio + y(:,(batch-1)*Nbatch+1:batch*Nbatch)*xmu';

end %/batch
so = y*y';

%%
save_dataset = true;
if save_dataset
    save(strcat(savefile,'_corr'),'sio','si','so','wNc','wNr','xNc','xNr','w','mNr','mNc','Np','Nfilt','P');
    ys = y(:,(batch-1)*Nbatch+1:batch*Nbatch);
    save(strcat(savefile,'_subset'),'xmu','ys');
end

%% Find best linear predictor, plot test/train error
load mnist_train_subset
xmu_tr = xmu;
y_tr = ys;
clear ys xmu
load mnist_test_subset
xmu_ts = xmu;
y_ts = y;
clear xmu y

lambdas = logspace(-1,5,10);
lambdas = 10^-1;
ind = 1;
for lambda = lambdas
    ind
    
    W = sio/(si + lambda*eye(size(si)));

    % Compute error on subset of data

    % Train
    yhat = W*xmu_tr;

    [m,yn] = max(y_tr);
    [m,ynhat] = max(yhat);

    train(ind) = mean(yn==ynhat)
    
    % Test
    yhat = W*xmu_ts;

    [m,yn] = max(y_ts);
    [m,ynhat] = max(yhat);

    test(ind) = mean(yn==ynhat)
    ind = ind + 1;
end
%%
semilogx(lambdas,train,lambdas,test,'linewidth',2)
legend('train','test')

%% Try SVD breakdown

[u,s,v] = svd(W,'econ');

test = [];
for ind = 1:10
    yhat = u(:,1:ind)*s(1:ind,1:ind)*v(:,1:ind)'*xmu_ts;

    [m,yn] = max(y_ts);
    [m,ynhat] = max(yhat);

    test(ind) = mean(yn==ynhat)
end

%% Plot linear filter weights
output = 5;
for f = 1:Nfilt
    
    for p = 1:Np
        subplot(5,5,p)
        imagesc(reshape(W(output,(p-1)*wNr*wNc+(f-1)*Np*wNr*wNc+1:p*wNr*wNc+(f-1)*Np*wNr*wNc),wNr,wNc)),axis off,axis equal, colormap gray
    end
    pause
end
