function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


% TODO Implement your code here
    if(length(size(img))<3)
        im(:,:,1)=img;
        im(:,:,2)=img;
        im(:,:,3)=img;
        img=im;
    end
    img=double(RGB2Lab(img));
    size_fb=length(filterBank);
    size_im=size(img);
    filterResponses=zeros(size_im(1),size_im(2),3*size_fb(1));
    for i=1:size_fb
        for j=1:3
            filterResponses(:,:,(i-1)*3+j)=imfilter(img(:,:,j),filterBank{i},'symmetric','same');
        end
    end
end
