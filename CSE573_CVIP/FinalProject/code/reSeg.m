%%re-label a image using "border"
function [seg]=reSeg(border)
    r=size(border,1);
    c=size(border,2);
    seg=zeros(r,c);
    label0=1;
    for i=1:r
        for j=1:c
            if(seg(i,j)==0&&border(i,j)==0)
                seg=FloodFill(seg,border,i,j,0,label0);
                label0=label0+1;
            end
        end
    end
    isfull=zeros(r,c);
    flag=1;
    while flag==1
        flag=0;
        for i=1:r
            for j=1:c
                if(isfull(i,j)==0&&seg(i,j)~=0)
                    if(i>1&&seg(i-1,j)==0)
                        seg(i-1,j)=seg(i,j);
                        flag=1;
                    end
                    if(i<r&&seg(i+1,j)==0)
                        seg(i+1,j)=seg(i,j);
                        flag=1;
                    end
                    if(j>1&&seg(i,j-1)==0)
                        seg(i,j-1)=seg(i,j);
                        flag=1;
                    end
                    if(j<c&&seg(i,j+1)==0)
                        seg(i,j+1)=seg(i,j);
                        flag=1;
                    end
                    isfull(i,j)=1;
                end
            end
        end
    end