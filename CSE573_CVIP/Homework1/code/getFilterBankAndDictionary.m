function [filterBank, dictionary, fixFR] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.
    % TODO Implement your code here
    num_pixel=200;
    filterBank  = createFilterBank();
    filter_responses=zeros(length(imPaths)*num_pixel,3*length(filterBank));
    for i=1:length(imPaths)
        im = imread(imPaths{i});
        fr=extractFilterResponses(im,filterBank);
        for j=1:num_pixel
            pos_row=ceil(rand(1)*size(im,1));
            pos_column=ceil(rand(1)*size(im,2));
            filter_responses((i-1)*num_pixel+j,:)=fr(pos_row,pos_column,:);
        end
    end
    [~, dictionary] = kmeans(filter_responses, 300, 'EmptyAction','drop');
    dictionary=dictionary';
    
    %% Boost accuracy by adjusting weight of filters
    %get average response from each filter
    for i=1:length(filterBank)/5
        magnitude_FR(i)=abs(sum(sum(dictionary((i-1)*15+1:i*15,:))))./15./size(dictionary,2);
    end
    para_fix=[1 3 3 3]; %set parameters for adjusting filters weight
    magnitude_FR=magnitude_FR.*para_fix;%adjust filters weight manually
    %generate fixFR.
    %fixFR is a vector for adjusting filter responses.
    for i=1:length(filterBank)/5 %5 is number of scales of a filter.
        for j=1:15
            fixFR((i-1)*15+j)=1/magnitude_FR(i);
        end
    end
    fixFR=fixFR';
    %use fixFR to adjust dictionary
    for i=1:size(dictionary,2)
        dictionary(:,i)=dictionary(:,i).*fixFR;
    end
end
