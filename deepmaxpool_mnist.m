clear all

addpath('../../doctoralwork/rht/project/datasets/mnist')
xtmp = loadMNISTimages('/Users/asaxe/Documents/doctoralwork/rht/project/datasets/mnist/t10k-images-idx3-ubyte');
sh = @(a) reshape(a,28,28)
xNr = round(sqrt(size(xtmp,1)));
xNc = round(sqrt(size(xtmp,1)));
P = size(xtmp,2);
x = zeros(xNr,xNc,P);
avg = mean(xtmp,2);
for i = 1:size(xtmp,2)
    x(:,:,i) = sh(xtmp(:,i)-avg);
end

%%

ytmp = loadMNISTlabels('/Users/asaxe/Documents/doctoralwork/rht/project/datasets/mnist/t10k-labels-idx1-ubyte');
ytmp(ytmp==0) = 10;

y = zeros(10,P);
for i = 1:P
    y(ytmp(i),i) = 1;
end



%% Set up filtering parameters

wNr=5;
wNc=5;
Nfilt = 120;

mNr=3;
mNc=3;

w = randn(Nfilt,wNr*wNc);

xmu = zeros(wNr*wNc*Nfilt,P);

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
for c = 1:xNc+1-mNc
    for r = 1:xNr+1-mNr    
        M = [M  sub2ind([xNr xNc],r+por-1,c+poc-1)'];
    end
end
%% Plot pooling regions
% 
% for i = 1:100;
%     tmp = zeros(1,xNr*xNc);
%     tmp(M(:,i))=1;
%    imagesc(sh(tmp))
%    pause
% end

%%
max_itr = 3;
for itr = 1:max_itr
    
    
    % Compute convolutions and maxes
    for mu = 1:P
        mu

        %Conv
        xc = im2col(padarray(x(:,:,mu),[(wNr-1)/2 (wNc-1)/2]),[wNr wNc]);      
        xw = w*xc;

        % Max
        xm = zeros(size(xw));
        for f = 1:Nfilt
            [m,I] = max(reshape(xw(f,M),size(M)));
            max_winners = M(sub2ind(size(M),I,1:length(I)));
            xm(f,max_winners) = xm(f,max_winners) + 1;
            
        end
        
    
        % Compute max avged x values
        xf = xc*xm';
        xmu(:,mu) = xf(:);
    end %/mu
    
    %%
    
    [vi,ei] = eig(xmu*xmu');
    
    %%
    lambda = 1e3;
    si = vi*inv(ei + lambda*eye(size(ei)))*vi';
    
    imagesc(si)
    
    %%
    beta = 1e-7;
    [u,s,v] = svd(y*xmu'*(si + beta*eye(size(si))));
    
    w = reshape(v(:,1),wNr*wNc,Nfilt)';
%%
    
    vt = reshape(v(:,1),wNr*wNc,Nfilt);
    for i = 1:Nfilt
       subplot(11,11,i)
       imagesc(reshape(vt(:,i),wNr,wNc)),axis off,axis equal, colormap gray
       caxis([-.03 .03])
    end
    %% Prediction
    yhat = u(:,1:end-2)*s(1:end-2,1:end-2)*v(:,1:end-2)'*xmu;
    
    %%


    
end

%%

mask = zeros(10,3000);
for i = 1:10
   mask(i,(i-1)*300+1:i*300)=ones(1,300);
end

v=randn(1,3000);

mtx = sio'*sio;
for i = 1:100
    i
    v = mtx*v';
    v = v';
    v = v.*mask(1,:);
    v = v/norm(v);
end

[u,s,v2] = svd(sio);

