% Load the training data into memory
xTrainImages=rMNISTim('..\data\train-images.idx3-ubyte',1000);
tTrain=rMNISTl('..\data\train-labels.idx1-ubyte',1000);

% Load the test images
xTestImages=rMNISTim('..\data\t10k-images.idx3-ubyte',1000);
tTest=rMNISTl('..\data\t10k-labels.idx1-ubyte',1000);

classify_digits(xTrainImages,tTrain,xTestImages,tTest);