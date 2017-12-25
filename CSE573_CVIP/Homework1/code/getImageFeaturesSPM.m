function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    h=zeros(dictionarySize*(4^layerNum-1)/3,1);
    num_chunk=2^(layerNum-1);
    size_chunk1=ceil(size(wordMap,1)/num_chunk);
    size_chunk2=ceil(size(wordMap,2)/num_chunk);
    size_extend1=size_chunk1*num_chunk;
    size_extend2=size_chunk2*num_chunk;
    wordMap_=zeros(size_extend1,size_extend2);
    wordMap_(1:size(wordMap,1),1:size(wordMap,2))=wordMap;
    h_=zeros(num_chunk,num_chunk,dictionarySize);
    for i=1:num_chunk
        for j=1:num_chunk
            h_(i,j,:)=getImageFeaturesNoNorm(wordMap_((i-1)*size_chunk1+1:i*size_chunk1,(j-1)*size_chunk2+1:j*size_chunk2), dictionarySize);
        end
    end
    p=1;
    for i=1:layerNum
        weight=1/2^i;
        if(i==layerNum)
            weight=weight*2;
        end
        for j=1:size(h_,1)
            for k=1:size(h_,2)
                h((p-1)*dictionarySize+1:p*dictionarySize)=h_(j,k,:)/size_extend1/size_extend2*weight;
                p=p+1;
            end
        end
        if(i==layerNum)
            break;
        end
        h__=zeros(size(h_,1)/2,size(h_,2)/2,dictionarySize);
        for j=1:size(h__,1)
            for k=1:size(h__,2)
                h__(j,k,:)=h_(j*2-1,k*2-1,:)+h_(j*2,k*2-1,:)+...
                    h_(j*2-1,k*2,:)+h_(j*2,k*2,:);
            end
        end
        h_=h__;
    end
end