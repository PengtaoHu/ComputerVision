function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.
    layerNum=3;
	load('dictionary.mat');
	load('../data/traintest.mat');
    load('dictionary.mat','filterBank','dictionary','fixFR');
	% TODO create train_features
    source='../data/';
    load('../data/traintest.mat'); 
    dictionarySize=size(dictionary,2);
    train_features=zeros(dictionarySize*(4^layerNum-1)/3,length(train_imagenames));
    for i=1:length(train_imagenames)
        im = im2double(imread([source,train_imagenames{i}]));
        %wordMap=getVisualWords(im, filterBank, dictionary, fixFR);
        wordMap=load([source, strrep(train_imagenames{i},'.jpg','.mat')]);
        wordMap=wordMap.wordMap;
        train_features(:,i)=getImageFeaturesSPM(layerNum,wordMap, dictionarySize);
    end
	save('vision.mat', 'filterBank', 'dictionary', 'fixFR', 'train_features', 'train_labels');

end