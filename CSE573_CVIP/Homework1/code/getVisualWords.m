function [wordMap] = getVisualWords(img, filterBank, dictionary, fixFR)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here
    wordMap=zeros(size(img,1),size(img,2));
    fixFR=reshape(fixFR,1,1,size(fixFR,1));
    fixFR=repmat(fixFR,[size(img,1) size(img,2) 1]);
    filterResponses=extractFilterResponses(img, filterBank);
    
    filterResponses=filterResponses.*fixFR;%To adjust weight of each filter
    
    check=filterResponses(7,7,:);
    size_filterResponse=size(filterBank,1)*3;
    size_dictionary=size(dictionary,2);
    for i=1:size(img,1)
        for j=1:size(img,2)
            filterResponse=reshape(filterResponses(i,j,:),size_filterResponse,1);
            filterResponseCpy=repmat(filterResponse,1,size_dictionary);
            [~,wordMap(i,j)]=min(sum((filterResponseCpy-dictionary).^2));
        end
    end
end
