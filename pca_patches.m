function params = pca_patches(x, params)

[xNr xNc] = size(x(:,:,1));
P = size(x,3);
wNr = params.wNr;
wNc = params.wNc;

C = zeros(wNr*wNc,wNr*wNc);
for r = 1:xNr-wNr+1
    r
    for c = 1:xNc-wNc+1
        patches = squeeze(reshape(x(r:r+wNr-1,c:c+wNc-1,:),wNr*wNc,1,P));
        C = C + patches*patches';
    end
end

[V, E] = eig(C);
E = diag(E);
[E,s] = sort(E,'descend');
params.V = V(:,s);
params.E = E;