%%visiualize a image "im0" and border
function ShowBorder(im0,border)
    if(size(im0,3)==1)
        im(:,:,1)=im0;
        im(:,:,2)=im0;
        im(:,:,3)=im0;
    else
        im=im0;
    end
    for i=1:size(im,1)
        for j=1:size(im,2)
            if(border(i,j)>0)
                im(i,j,:)=[0 255 0];
            end
        end
    end
    imshow(im);
    