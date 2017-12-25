%%get confined standard deviation map for "im0" with window size "d" using
%%a pre-segmentation "seg".
function [SDM]=StdMap2(im0,d,seg)
im0=im0+0.01;
r=size(im0,1);
c=size(im0,2);
SDM=zeros(r,c);
im=MirrorExpand(im0,d);
seg=MirrorExpand(seg,d);
bord=getBorder(seg);
len=ceil(max(max(im0)));
for i=d+1:d+r
    for j=d+1:d+c
        count=0;
        sum=0;
        sum2=0;
        
        htg=zeros(len,1);
        for u=i-d:i+d
            for v=j-d:j+d
                if(seg(i,j)==seg(u,v))
                    count=count+1;
                    htg(ceil(im(u,v)))=htg(ceil(im(u,v)))+1;
                end
            end
        end
        count_left=0;
        for left=1:len
            count_left=count_left+htg(left);
            if(count_left/count>0.1)
                break;
            end
        end
        count_right=0;
        for right=len:-1:1
            count_right=count_right+htg(right);
            if(count_right/count>0.1)
                break;
            end
        end
        count=0;
        
        for u=i-d:i+d
            for v=j-d:j+d
                if(seg(i,j)==seg(u,v)&&(ceil(im(u,v))>=left&&im(u,v)<=right))
                    count=count+1;
                    sum=sum+im(u,v);
                    sum2=sum2+im(u,v)^2;
                end
            end
        end
        SDM(i-d,j-d)=(sum2/count-(sum/count)^2)^0.5;
    end
end