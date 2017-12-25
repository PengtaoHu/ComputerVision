%%get the similarity of a region and its connected regions.
%"im" is the image for segment.
%"seg" is the segment result.
%start from "pr","pc".
%"labelmax" is the number of labels.
%"simi" is the similarity of the target region with its connected regions
%"connect" is the number of pixels of connection of the target region with its connected regions
function [simi,connect]=getSimiConnect(im,seg,pr,pc,labelmax)
    
    simi=zeros(labelmax,1);
    connect=zeros(labelmax,1);
    r=size(seg,1);
    c=size(seg,2);
    top=1;
    stack(1,:)=[pr pc];
    label0=seg(pr,pc);
    did=zeros(r,c);
    did(pr,pc)=1;
    while top>0
        i=stack(top,1);
        j=stack(top,2);
        top=top-1;
        if(i>1&&seg(i-1,j)~=seg(i,j)||i<r&&seg(i+1,j)~=seg(i,j)||...
            j>1&&seg(i,j-1)~=seg(i,j)||j<c&&seg(i,j+1)~=seg(i,j))
                mini=inf;
                if(i>1&&seg(i-1,j)~=seg(i,j))
                    s=sum((im(i,j,:)-im(i-1,j,:)).^2);
                    if(s<mini)
                        mini=s;
                        connect0=seg(i-1,j);
                    end
                end
                if(i<r&&seg(i+1,j)~=seg(i,j))
                    s=sum((im(i,j,:)-im(i+1,j,:)).^2);
                    if(s<mini)
                        mini=s;
                        connect0=seg(i+1,j);
                    end
                end
                if(j>1&&seg(i,j-1)~=seg(i,j))
                    s=sum((im(i,j,:)-im(i,j-1,:)).^2);
                    if(s<mini)
                        mini=s;
                        connect0=seg(i,j-1);
                    end
                end
                if(j<c&&seg(i,j+1)~=seg(i,j))
                    s=sum((im(i,j,:)-im(i,j+1,:)).^2);
                    if(s<mini)
                        mini=s;
                        connect0=seg(i,j+1);
                    end
                end
                simi(connect0)=simi(connect0)+mini;
                connect(connect0)=connect(connect0)+1;
        end
        if(i>1&&seg(i-1,j)==label0&&did(i-1,j)==0)
            top=top+1;
            stack(top,:)=[i-1 j];
            did(i-1,j)=1;
        end
        if(i<r&&seg(i+1,j)==label0&&did(i+1,j)==0)
            top=top+1;
            stack(top,:)=[i+1 j];
            did(i+1,j)=1;
        end
        if(j>1&&seg(i,j-1)==label0&&did(i,j-1)==0)
            top=top+1;
            stack(top,:)=[i j-1];
            did(i,j-1)=1;
        end
        if(j<c&&seg(i,j+1)==label0&&did(i,j+1)==0)
            top=top+1;
            stack(top,:)=[i j+1];
            did(i,j+1)=1;
        end
    end
    for j=1:labelmax
        if(connect(j)~=0)
            simi(j)=simi(j)/connect(j)/(1+log(connect(j)));
        else
            simi(j)=inf;
        end
    end