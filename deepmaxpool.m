clear all

load ../sparsedeeplin/code/face_cropped
xtmp = x;
xNr = round(sqrt(size(x,1)));
xNc = round(sqrt(size(x,2)));
clear x;
for i = 1:size(xtmp,2)
    x(:,:,i) = sh(xtmp(:,i)-mean(xtmp,2));
end

%%
%xNr = 100;
%xNc = 100;
P = size(x,3);
%x = randn(xNr,xNc,P);
y = randn(1,P);

wNr=5;
wNc=5;
Nfilt = 30;

mNr=3;
mNc=3;

w = randn(Nfilt,wNr*wNc);

xmu = zeros(wNr*wNc*Nfilt,P);

max_itr = 1;
for itr = 1:max_itr
    
    
    % Compute convolutions and maxes
    for mu = 1:P
        mu

        %Conv
        xc = im2col(padarray(x(:,:,mu),[(wNr-1)/2 (wNc-1)/2]),[wNr wNc]);
        xw = w*xc;

        % Max
        ind = 1;
        for pr = 1:mNr
            for pc = 1:mNc
                por(ind) = pr;
                poc(ind) = pc;
                ind = ind + 1;
            end
        end

        xm = zeros(size(xw));
        for r = 1:xNr-wNr+1-mNr
            for c = 1:xNc-wNc+1-mNc
                s = sub2ind([xNr-wNr+1 xNc-wNc+1],r+por-1,c+poc-1);
                [m(r,c,:),I(r,c,:)] = max(xw(:,s),[],2);
                for f = 1:Nfilt
                    xm(f,s(I(r,c,f))) = xm(f,s(I(r,c,f))) + 1;
                end
            end
        end
        
    
        % Compute max avged x values
        xf = xc*xm';
        xmu(:,mu) = xf(:);
    end %/mu
    
    %%

    [u,s,v] = svd(xtmp*xmu');
    
    w = reshape(v(:,1),wNr*wNc,Nfilt)';

    
    vt = reshape(v(:,1),wNr*wNc,Nfilt);
    for i = 1:Nfilt
       subplot(6,6,i)
       imagesc(reshape(vt(:,i),wNr,wNc)),axis off,axis equal, colormap gray
    end

    pause


    
end

