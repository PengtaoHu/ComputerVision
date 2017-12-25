function [im]=histogram_equalization(im)
    hist=zeros(256,1);
    t=zeros(256,1);
    im=im+1;
    for i=1:size(im,1)
        for j=1:size(im,2)
            hist(im(i,j))=hist(im(i,j))+1;
        end
    end
    for i=2:256
        hist(i)=hist(i)+hist(i-1);
    end
    hist_min=min(hist);
    maximum=size(im,1)*size(im,2)-hist_min;
    for i=1:256
        t(i,1)=round((hist(i)-hist_min)/maximum*255);
    end
    for i=1:size(im,1)
        for j=1:size(im,2)
            im(i,j)=t(im(i,j),1);
        end
    end