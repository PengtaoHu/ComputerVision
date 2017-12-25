function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');

	% TODO Implement your code here
    source='../data/';
    target='../wrong/';
    target2='../right/';
    conf=zeros(8,8);
    set(gcf, 'Color', [1 1 1]);
    set(gcf, 'PaperPositionMode', 'auto');
    for i=1:length(test_imagenames)
        im = im2double(imread([source,test_imagenames{i}]));
        wordMap=load([source, strrep(test_imagenames{i},'.jpg','.mat')]);
        wordMap=wordMap.wordMap;
        h = getImageFeaturesSPM(3,wordMap, size(dictionary,2));
        distances = distanceToSet(h, train_features);
        
       %% Boost accuracy by using several train pictures that are closest to a test picture
       %% to predict the label of the test picture
        count_Labels=zeros(8,1);
        %To get n train pictures that are closest to the test picture and
        %count their labels
        for j=1:5
            [~,nnI] = max(distances);
            count_Labels(train_labels(nnI))=count_Labels(train_labels(nnI))+1;
            distances(nnI)=0;
        end
        [~,result]=max(count_Labels);%chose the most frequently one as result
        %%
        
        conf(test_labels(i),result)=conf(test_labels(i),result)+1;
    end
    accuracy=trace(conf)/length(test_imagenames)
    save('conf.mat','conf','accuracy');
end