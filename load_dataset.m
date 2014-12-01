function [x, y, params] = load_dataset(params)

dataset = params.dataset;



if strcmp(dataset,'mnist_train')
    addpath('~/datasets/mnist')
    xtmp = loadMNISTImages(['~/datasets/mnist/train-images-idx3-' ...
                        'ubyte']);
    ytmp = loadMNISTLabels(['~/datasets/mnist/train-labels-idx1-' ...
                        'ubyte']);
    ytmp(ytmp==0) = 10;
elseif strcmp(dataset,'mnist_test')
    addpath('~/datasets/mnist')
    xtmp = loadMNISTImages(['~/datasets/mnist/t10k-images-idx3-' ...
                        'ubyte']);
    ytmp = loadMNISTLabels(['~/datasets/mnist/t10k-labels-idx1-' ...
                        'ubyte']);
    ytmp(ytmp==0) = 10;
end

sh = @(a) reshape(a,28,28);
xNr = round(sqrt(size(xtmp,1)));
xNc = round(sqrt(size(xtmp,1)));
P = size(xtmp,2);
x = zeros(xNr,xNc,P);
avg = mean(xtmp,2);
for i = 1:size(xtmp,2)
    x(:,:,i) = sh(xtmp(:,i)-avg);
end
clear xtmp;

params.sh = sh;
params.xNr = xNr;
params.xNc = xNc;
params.P = P;

y = -ones(max(ytmp(:)),P)/10;
for i = 1:P
    y(ytmp(i),i) = 1;
end
clear ytmp;

