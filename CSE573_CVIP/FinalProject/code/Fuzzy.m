%%smooth "data0"
function [data]=Fuzzy(data0)
    mask_size=7;
    sigma=2;
    mask=fspecial('gaussian',mask_size, sigma);
    mask=sum(mask);
    length=size(data0,1);
    data=zeros(length,1);
    for i=1:length
        for u=-floor(mask_size/2):floor(mask_size/2)
            if(i+u<1)
                k=1;
            elseif(i+u>length)
                k=length;
            else
                k=i+u;
            end
            data(i)=data(i)+mask(u+ceil(mask_size/2))*data0(k);
        end
    end