function classify_digits(xTrainImages,tTrain,xTestImages,tTest)

hiddenSize1 = 100;
hiddenSize2 = 50;

sample=xTrainImages{1};
% Get the number of pixels in each image
imageWidth = size(sample,2);
imageHeight = size(sample,1);
inputSize = imageWidth*imageHeight;


% Display some of the training images
clf
for i = 1:49
    subplot(7,7,i);
    imshow(xTrainImages{i});
end
saveas(gcf,'record\samples.jpg');
%}
rng('default');
autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);
figure();
plotWeights(autoenc1);
saveas(gcf,'record\feature1.jpg');
feat1 = encode(autoenc1,xTrainImages);
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);
figure();
plotWeights(autoenc2);
saveas(gcf,'record\feature2.jpg');
feat2 = encode(autoenc2,feat1);
softnet = trainSoftmaxLayer(feat2,tTrain,'MaxEpochs',400);
deepnet = stack(autoenc1,autoenc2,softnet);


% Turn the test images into vectors and put them in a matrix
xTest = zeros(inputSize,numel(xTestImages));
for i = 1:numel(xTestImages)
    xTest(:,i) = xTestImages{i}(:);
end

% Turn the training images into vectors and put them in a matrix
xTrain = zeros(inputSize,numel(xTrainImages));
for i = 1:numel(xTrainImages)
    xTrain(:,i) = xTrainImages{i}(:);
end

y = deepnet(xTest);
plotconfusion(tTest,y);
saveas(gcf,'record\con_test1.jpg');
x = deepnet(xTrain);
plotconfusion(tTrain,x);
saveas(gcf,'record\con_train1.jpg');

% Perform fine tuning
deepnet = train(deepnet,xTrain,tTrain);

y = deepnet(xTest);
plotconfusion(tTest,y);
saveas(gcf,'record\con_test2.jpg');
x = deepnet(xTrain);
plotconfusion(tTrain,x);
saveas(gcf,'record\con_train2.jpg');
