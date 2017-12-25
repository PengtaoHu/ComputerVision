function [ warp_im,warp_mark ] = warp( im, H)
H=H^(-1);
warp_im=zeros(size(im)*3);
warp_mark=zeros(size(im)*3);
for i=1:size(warp_im,1)
    for j=1:size(warp_im,2)
        ii=i-size(im,1);
        jj=j-size(im,2);
        point_warp=H*[ii jj 1]';
        point_warp=round(point_warp/point_warp(3,1));
        if(point_warp(1)>0&&point_warp(1)<=size(im,1)&&...
                point_warp(2)>0&&point_warp(2)<=size(im,2))
        warp_im(i,j)=im(point_warp(1), point_warp(2));
        end
        %{
        P=zeros(4,3);
        P(1,:)=[floor(point_warp(1)) floor(point_warp(2)) 1];
        P(2,:)=[ceil(point_warp(1)) floor(point_warp(2)) 1];
        P(3,:)=[floor(point_warp(1)) ceil(point_warp(2)) 1];
        P(4,:)=[ceil(point_warp(1)) ceil(point_warp(2)) 1];
        weight_sum=0;
        for k=1:4
            if(P(k,1)>0&&P(k,1)<=size(im,1)&&...
                P(k,2)>0&&P(k,2)<=size(im,2))
                weight=1/sum((point_warp'-P(k,:)).^2).^0.5;
                weight_sum=weight_sum+weight;
                warp_mark(i,j)=255;
                warp_im(i,j)=warp_im(i,j)+weight*double(im(P(k,1),P(k,2)));
            end
        end
        if(weight_sum>0)
            warp_im(i,j)=warp_im(i,j)/weight_sum;
        end
        %}
    end
end
warp_im=uint8(warp_im);