clear
load mnist_grid

wNs = unique(res(:,1));
mNs = unique(res(:,3));

min_ts = zeros(length(wNs),length(mNs));
for w = 1:length(wNs)
    for m = 1:length(mNs)
        [w m]
        
        tmp = res(res(:,1)==wNs(w) & res(:,3)==mNs(m),4);
        tmp2 = res(res(:,1)==wNs(w) & res(:,3)==mNs(m),5)
        if ~isempty(tmp)
            min_ts(w,m) = min(tmp);
            lam(w,m) = tmp2;
        else
            min_ts(w,m) = nan;
            lam(w,m) = nan;
        end
        
    end
end

imagesc((min_ts))
xlabel('w')
ylabel('m')