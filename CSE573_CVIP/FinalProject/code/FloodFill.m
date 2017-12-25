%%starting from ("pr","pc"), replace label "old" with label "new" for
%%a segmentation "seg" with its corresponding "border"
function [seg]=FloodFill(seg,border,pr,pc,old,new)
    r=size(seg,1);
    c=size(seg,2);
    top=1;
    stack(1,:)=[pr pc];
    seg(pr,pc)=new;
    while top>0
        i=stack(top,1);
        j=stack(top,2);
        top=top-1;
        if(i>1&&seg(i-1,j)==old)
            seg(i-1,j)=new;
            if(border(i-1,j)==0)
                top=top+1;
                stack(top,:)=[i-1 j];
            end
        end
        if(i<r&&seg(i+1,j)==old)
            seg(i+1,j)=new;
            if(border(i+1,j)==0)
                top=top+1;
                stack(top,:)=[i+1 j];
            end
        end
        if(j>1&&seg(i,j-1)==old)
            seg(i,j-1)=new;
            if(border(i,j-1)==0)
                top=top+1;
                stack(top,:)=[i j-1];
            end
        end
        if(j<c&&seg(i,j+1)==old)
            seg(i,j+1)=new;
            if(border(i,j+1)==0)
                top=top+1;
                stack(top,:)=[i j+1];
            end
        end
    end