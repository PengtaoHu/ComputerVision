function [rgbResult] = alignChannels(red, green, blue)
rg=30;
rgResult=match(red,green);%match red and green
rbResult=match(red,blue);%match red and blue
size1=size(red);
red2=zeros(size1+2*rg);%Extend red channel.
red2(rg+1:rg+size1(1),rg+1:(rg+size1(2)))=red;
green2=zeros(size1+60);%Extend and move green channel.
green2(rg+1+rgResult(1):rg+rgResult(1)+size1(1),rg+1+rgResult(2):rg+rgResult(2)+size1(2))=green;
blue2=zeros(size1+60);%Extend and move blue channel.
blue2(rg+1+rbResult(1):rg+rbResult(1)+size1(1),rg+1+rbResult(2):rg+rbResult(2)+size1(2))=blue;
rgbResult=uint8(cat(3,red2,green2,blue2));%compound channels.
end
function [result2]=match(im1,im2)
    rg=30;
    %%valid size
    size1=size(im1);
    size2=size(im2);
    if(size1~=size2)
        return;
    end
    min=+inf;
    for i=-rg:rg%Sorry. I can't figure it out without loops.
        for j=-rg:rg
            %%get portions for matching
            if(i>=0)
               x1s=i+1;
               x1e=size1(1);
               x2s=1;
               x2e=size1(1)-i;
            else
                x1s=1;
                x1e=size1(1)+i;
                x2s=-i+1;
                x2e=size1(1);
            end
            if(j>=0)
               y1s=j+1;
               y1e=size1(2);
               y2s=1;
               y2e=size1(2)-j;
            else
                y1s=1;
                y1e=size1(2)+j;
                y2s=-j+1;
                y2e=size1(2);
            end
            mat1=im1(x1s:x1e,y1s:y1e);
            mat2=im2(x2s:x2e,y2s:y2e);
            value=SSD(mat1,mat2);%Compare two matrix.
            if(value<min)%if it is better.
                min=value;
                result2=[i,j];
            end
        end
    end   
end
function [result]=SSD(mat1,mat2)
    D=abs(mat1-mat2);
    D=D.*D;
    result=sum(sum(D));
end