function e = eval_error(W,xmu,ys)

yhat = W*xmu;

[m,yn] = max(ys);
[m,ynhat] = max(yhat);

e = 1-mean(yn==ynhat);