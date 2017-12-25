function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% TODO Implement your code here
    wordMap_=wordMap(:);
    h_=hist(wordMap_,0:dictionarySize);
    h=h_(2:dictionarySize+1)';
    h=h./size(wordMap,1)./size(wordMap,2);
    sum(h)
end