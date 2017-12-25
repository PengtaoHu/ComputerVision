function [features]=fuzzy_features(features0)
    mask_size=7;
    sigma=2;
    mask=fspecial('gaussian',mask_size, sigma);
    mask=sum(mask);
    length=size(features0,2);
    features=zeros(size(features0,1),length);
    for i=1:size(features0,1)
        for j=1:length
            for u=-floor(mask_size/2):floor(mask_size/2)
                if(j+u<1)
                    k=1;
                elseif(j+u>length)
                    k=length;
                else
                    k=j+u;
                end
                features(i,j)=features(i,j)+mask(u+4)*features0(i,k);
            end
        end
    end