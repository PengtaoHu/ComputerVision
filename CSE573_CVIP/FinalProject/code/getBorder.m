%%get border of a segmentation
function [border]=getBorder(seg)
    r=size(seg,1);
    c=size(seg,2);
    border=zeros(r,c);
    for i=1:r
        for j=1:c
            if(i>1&&seg(i-1,j)~=seg(i,j))
                border(i,j)=1;
            elseif(i<r&&seg(i+1,j)~=seg(i,j))
                border(i,j)=1;
            elseif(j>1&&seg(i,j-1)~=seg(i,j))
                border(i,j)=1;
            elseif(j<c&&seg(i,j+1)~=seg(i,j))
                border(i,j)=1;
            end
        end
    end