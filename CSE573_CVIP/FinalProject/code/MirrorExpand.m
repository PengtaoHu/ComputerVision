%%expand length "d" for a image "im0" with its mirror image 
function [im_ex]=MirrorExpand(im0,d)
r=size(im0,1);
c=size(im0,2);
im_ex=zeros(r+2*d,c+2*d);

im_ex(d+1:d+r,d+1:d+c)=im0(1:r,1:c);

im_ex(1:d,1:d)=rot90(rot90(im0(1:d,1:d)));
im_ex(r+d+1:r+2*d,1:d)=rot90(rot90(im0(r-d+1:r,1:d)));
im_ex(1:d,c+d+1:c+2*d)=rot90(rot90(im0(1:d,c-d+1:c)));
im_ex(r+d+1:r+2*d,c+d+1:c+2*d)=rot90(rot90(im0(r-d+1:r,c-d+1:c)));

im_ex(1:d,d+1:d+c)=flipud(im0(1:d,1:c));
im_ex(r+d+1:r+2*d,d+1:d+c)=flipud(im0(r-d+1:r,1:c));
im_ex(d+1:d+r,1:d)=fliplr(im0(1:r,1:d));
im_ex(d+1:d+r,c+d+1:c+2*d)=fliplr(im0(1:r,c-d+1:c));