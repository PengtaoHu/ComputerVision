% Load the training data into memory
[xTrainImages,tTrain] = digitTrainCellArrayData;
% Load the test images
[xTestImages,tTest] = digitTestCellArrayData;

classify_digits(xTrainImages,tTrain,xTestImages,tTest);
