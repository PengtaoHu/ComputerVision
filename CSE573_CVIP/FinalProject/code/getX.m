%%get X for a image. X(i,j) is 1 if pixel at (i,j) is
%%similar to its neighbors.
function [X]=getX(im0,Ex,Wd,w)
if(size(im0,3)==1)
    im1(:,:,1)=im0;
    im1(:,:,2)=im0;
    im1(:,:,3)=im0;
else
    im1=im0;
end
r=size(im1,1);
c=size(im1,2);
n=size(im1,3);
X=zeros(r,c);
im=zeros(r+2*Wd,c+2*Wd,n);
for i=1:n
    im(:,:,i)=MirrorExpand(im1(:,:,i),Wd);
end
for i=Wd+1:Wd+r
    for j=Wd+1:Wd+c
        d=0;
        for k=-Wd:Wd
            for u=-Wd:Wd
                dd=0;
                for v=1:n
                    dd=dd+w(v)*(im(i,j,v)-im(i+k,j+u,v))^2;
                end
                d=d+dd^0.5;
            end
        end
        if(d<Ex)
            X(i-Wd,j-Wd)=1;
        end
    end
end