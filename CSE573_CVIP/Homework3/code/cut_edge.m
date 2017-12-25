function [im,up,down,left,right]=cut_edge(im)
for up=1:size(im,1)
    if(sum(im(up,:))~=0)
        break;
    end
end
for down=size(im,1):-1:1
    if(sum(im(down,:))~=0)
        break;
    end
end
for left=1:size(im,2)
    if(sum(im(:,left))~=0)
        break;
    end
end
for right=size(im,2):-1:1
    if(sum(im(:,right))~=0)
        break;
    end
end
im=im(up:down,left:right);