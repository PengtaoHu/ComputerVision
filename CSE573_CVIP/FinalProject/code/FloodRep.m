%%replace label "old" with label "new" and collect similarity and
%%connection information of the target region to connected regions
%Xn is the number of border pixels that X(i,j)=1
%Xrate is the ratio of border pixels that X(i,j)=1
function [Xn,Xrate,seg]=FloodRep(seg,pr,pc,old,new,X)
    r=size(seg,1);
    c=size(seg,2);
    top=1;
    stack(1,:)=[pr pc];
    did=zeros(r,c);
    did(pr,pc)=1;
    Xn=0;
    peri=0;
    flag=length(X);
    while top>0
        i=stack(top,1);
        j=stack(top,2);
        top=top-1;
        seg(i,j)=new;
        if(flag>1&&(i>1&&seg(i-1,j)~=seg(i,j)||i<r&&seg(i+1,j)~=seg(i,j)||...
            j>1&&seg(i,j-1)~=seg(i,j)||j<c&&seg(i,j+1)~=seg(i,j)))
            peri=peri+1;
            Xn=Xn+X(i,j);
        end
        if(i>1&&seg(i-1,j)==old&&did(i-1,j)==0)
            top=top+1;
            stack(top,:)=[i-1 j];
            did(i-1,j)=1;
        end
        if(i<r&&seg(i+1,j)==old&&did(i+1,j)==0)
            top=top+1;
            stack(top,:)=[i+1 j];
            did(i+1,j)=1;
        end
        if(j>1&&seg(i,j-1)==old&&did(i,j-1)==0)
            top=top+1;
            stack(top,:)=[i j-1];
            did(i,j-1)=1;
        end
        if(j<c&&seg(i,j+1)==old&&did(i,j+1)==0)
            top=top+1;
            stack(top,:)=[i j+1];
            did(i,j+1)=1;
        end
    end
    Xrate=Xn/peri;